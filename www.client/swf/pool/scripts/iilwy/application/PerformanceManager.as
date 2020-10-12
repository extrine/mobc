package iilwy.application
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.data.PageCommand;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.ArcadeEvent;
   import iilwy.events.AsyncEvent;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.model.ChatData;
   import iilwy.gamenet.model.MatchData;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.local.LocalProperties;
   import iilwy.net.MerbProxyProperties;
   import iilwy.utils.DateUtil;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class PerformanceManager
   {
       
      
      private var performanceHistory:Array;
      
      private var frameCount:int;
      
      private var sampleSize:int;
      
      private var lastFrame:int;
      
      private var initTimer:Timer;
      
      private var fpsTimer:Timer;
      
      private var matchDelayTimer:Timer;
      
      private var lobbyEntered:Boolean;
      
      private var matchStarted:Boolean;
      
      private var matchMakingPerformanceSent:Boolean;
      
      private var userInLobbyPerformanceSent:Boolean;
      
      private var lobbyPerformanceSent:Boolean;
      
      private var matchCreatedAt:Date;
      
      private var matchMadeTimeLeft;
      
      private var matchPeopleInLobby:int;
      
      private var matchJoinType:int;
      
      private var matchJoinAttempts:int = 0;
      
      private var matchMakingId:int;
      
      private var lobbyJid:String;
      
      private var attemptedToEnterLobbyTime:int;
      
      private var enteredLobbyTime:int;
      
      private var lobbyCreatedAt:Date;
      
      private var lobbyUserLeftAt:Date;
      
      private var userInLobbyId:int;
      
      private var gameId:int;
      
      private var lastMatchJid:String;
      
      private var lastMatchRound:int;
      
      private var matchParticipants:int;
      
      private var matchRound:int;
      
      private const JOIN_TYPE_QUICK_PLAY:int = 0;
      
      private const JOIN_TYPE_QUICK_PLAY_CREATE:int = 1;
      
      private const JOIN_TYPE_CREATE:int = 2;
      
      private const JOIN_TYPE_JOIN_SIDEBAR:int = 3;
      
      private const JOIN_TYPE_JOIN_FRIEND:int = 4;
      
      private const JOIN_TYPE_INVITATION:int = 5;
      
      private const JOIN_TYPE_INHERIT:int = 6;
      
      private var logger:Logger;
      
      private var userState:String;
      
      public function PerformanceManager()
      {
         super();
         this.logger = Logger.getLogger(this);
         this.initState();
         this.fpsTimer = new Timer(100);
         this.fpsTimer.addEventListener(TimerEvent.TIMER,this.onFpsTimer);
         this.matchDelayTimer = new Timer(10 * 1000,1);
         this.matchDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onMatchStartDelay);
         this.initTimer = new Timer(100);
         this.initTimer.addEventListener(TimerEvent.TIMER,this.onInitTimer);
         this.initTimer.start();
      }
      
      protected function initState() : void
      {
         this.lobbyEntered = false;
         this.matchStarted = false;
         this.matchMakingPerformanceSent = false;
         this.userInLobbyPerformanceSent = false;
         this.lobbyPerformanceSent = false;
         this.matchCreatedAt = null;
         this.matchMadeTimeLeft = -1;
         this.matchPeopleInLobby = -1;
         this.matchJoinType = -1;
         this.matchJoinAttempts = 0;
         this.matchMakingId = -1;
         this.lobbyJid = null;
         this.attemptedToEnterLobbyTime = 0;
         this.enteredLobbyTime = 0;
         this.lobbyCreatedAt = null;
         this.lobbyUserLeftAt = null;
         this.userInLobbyId = -1;
         this.gameId = 0;
      }
      
      protected function onMatchQuickPlay(event:ArcadeEvent) : void
      {
         this.onAttemptToEnterLobby(event,this.JOIN_TYPE_QUICK_PLAY);
      }
      
      protected function onMatchCreate(event:ArcadeEvent) : void
      {
         if(event.context == ArcadeEvent.CONTEXT_CREATE_MATCH_MANUAL)
         {
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_CREATE);
         }
         else if(event.context == ArcadeEvent.CONTEXT_CREATE_MATCH_AUTO)
         {
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_QUICK_PLAY_CREATE);
         }
      }
      
      protected function onMatchQuickPlayAuto(event:ApplicationEvent) : void
      {
         if(event.type == ApplicationEvent.SHOW_PAGE && event.id.indexOf("arcade/quickplay/") > -1 && event.context == ArcadeEvent.CONTEXT_QUICKPLAY_AUTO)
         {
            this.onAttemptToEnterLobbyFromAppEvent(event,this.JOIN_TYPE_QUICK_PLAY);
         }
      }
      
      protected function onMatchJoinByProfileId(event:ArcadeEvent) : void
      {
         if(event.context == ArcadeEvent.CONTEXT_JOIN_PLAYER_EXTERNAL)
         {
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_JOIN_FRIEND);
         }
      }
      
      protected function onMatchJoinByInvitation(event:ArcadeEvent) : void
      {
         if(event.context == ArcadeEvent.CONTEXT_INVITE_TO_MATCH_EXTERNAL)
         {
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_INVITATION);
         }
      }
      
      protected function onShowGamePlay(event:ArcadeEvent) : void
      {
         if(event.context == ArcadeEvent.CONTEXT_JOIN_MATCH_SIDEBAR_MANUAL)
         {
            if(!(event.data && event.data.gameId) && event.gamePack)
            {
               event.data = {"gameId":event.gamePack.uid};
            }
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_JOIN_SIDEBAR);
         }
      }
      
      protected function onSetPlayerStatus(event:ArcadeEvent) : void
      {
         if(event.playerStatus.type == PlayerStatus.TYPE_READY && this.matchStarted)
         {
            this.onAttemptToEnterLobby(event,this.JOIN_TYPE_CREATE);
            this.onEnterLobby();
         }
      }
      
      protected function onAttemptToEnterLobbyFromAppEvent(event:ApplicationEvent, joinType:int) : void
      {
         var gameId:int = int(event.data.gameId);
         this.attemptToEnterLobby(gameId,joinType);
      }
      
      protected function onAttemptToEnterLobby(event:ArcadeEvent, joinType:int) : void
      {
         var gamePack:ArcadeGamePackData = null;
         var gameId:int = Boolean(event.gamePack)?int(event.gamePack.uid):int(0);
         if(!gameId && event.matchListingData)
         {
            gamePack = AppComponents.model.arcade.getCatalogItem(event.matchListingData.gameId);
            gameId = Boolean(gamePack)?int(gamePack.uid):int(-1);
         }
         this.attemptToEnterLobby(gameId,joinType);
      }
      
      protected function attemptToEnterLobby(gameId:int, joinType:int) : void
      {
         this.gameId = gameId;
         this.attemptedToEnterLobbyTime = getTimer();
         if(this.matchJoinType == -1)
         {
            this.matchCreatedAt = MerbProxyProperties.serverNow;
         }
         this.setJoinType(joinType);
      }
      
      public function onEnterLobby() : void
      {
         var matchData:MatchData = AppComponents.gamenetManager.currentMatch;
         if(!this.gameId && matchData.gameId)
         {
            this.gameId = int(matchData.gameId);
         }
         this.matchMadeTimeLeft = matchData.readyTime > -1?matchData.readyTime - matchData.gamenetManager.serverNowTime:null;
         this.matchPeopleInLobby = matchData.participants.length;
         this.enteredLobbyTime = getTimer();
         this.matchRound = Math.max(1,matchData.round);
         if(!this.matchCreatedAt)
         {
            this.matchCreatedAt = MerbProxyProperties.serverNow;
         }
         this.lobbyCreatedAt = MerbProxyProperties.serverNow;
         this.lobbyEntered = true;
         if(matchData.roomName)
         {
            AppComponents.gamenetManager.currentMatch.removeEventListener(MatchDataEvent.MATCH_ROOM_INITIALIZED,this.onMatchInitialized);
            this.recordMatchMakingPerformance();
         }
         else
         {
            AppComponents.gamenetManager.currentMatch.addEventListener(MatchDataEvent.MATCH_ROOM_INITIALIZED,this.onMatchInitialized);
         }
      }
      
      protected function onMatchCheckExistence(event:ArcadeEvent) : void
      {
         this.matchJoinAttempts++;
      }
      
      protected function onMatchInitialized(event:MatchDataEvent) : void
      {
         this.recordMatchMakingPerformance();
      }
      
      protected function onMatchStart(event:MatchDataEvent) : void
      {
         this.matchStarted = true;
         var matchData:MatchData = AppComponents.gamenetManager.currentMatch;
         this.matchParticipants = matchData.players.length;
         this.recordUserInLobbyPerformance();
         this.recordLobbyPerformance(matchData);
         this.matchDelayTimer.reset();
         this.matchDelayTimer.start();
      }
      
      protected function onMatchStartDelay(event:TimerEvent) : void
      {
         this.startTracking();
      }
      
      public function onMatchEnd() : void
      {
         this.lastMatchJid = this.lobbyJid;
         this.lastMatchRound = this.matchRound;
         this.doMatchEnd();
      }
      
      protected function onMatchQuit(event:ArcadeEvent) : void
      {
         this.lobbyUserLeftAt = MerbProxyProperties.serverNow;
         this.doMatchEnd();
      }
      
      protected function onMatchForceLeaveHost(event:ArcadeEvent) : void
      {
         this.lobbyUserLeftAt = MerbProxyProperties.serverNow;
         this.doMatchEnd();
      }
      
      protected function onMatchForceLeavePlayer(event:MatchDataEvent) : void
      {
         this.lobbyUserLeftAt = MerbProxyProperties.serverNow;
         this.doMatchEnd();
      }
      
      protected function doMatchEnd() : void
      {
         var gamePack:ArcadeGamePackData = null;
         var matchData:MatchData = AppComponents.gamenetManager.currentMatch;
         this.recordUserInLobbyPerformance();
         this.recordLobbyPerformance(matchData);
         this.recordMatchData();
         this.initState();
         var currentPage:PageCommand = AppComponents.stateManager.currentPageCommand;
         if(currentPage.path[0] == "arcade" && currentPage.path[1] == "play")
         {
            gamePack = AppComponents.model.arcade.getCatalogItem(matchData.gameId);
            if(gamePack)
            {
               this.attemptToEnterLobby(gamePack.uid,this.JOIN_TYPE_INHERIT);
            }
            this.onEnterLobby();
         }
      }
      
      protected function recordMatchMakingPerformance() : void
      {
         if(this.matchMakingPerformanceSent)
         {
            return;
         }
         var matchData:MatchData = AppComponents.gamenetManager.currentMatch;
         this.lobbyJid = new UnescapedJID(matchData.xmppRoom.roomName).toString();
         var userId:* = AppComponents.model.privateUser && AppComponents.model.privateUser.isLoggedIn?AppComponents.model.privateUser.id:null;
         var anonId:* = !userId?AppComponents.localStore.getObject(LocalProperties.SAVED_ANONYMOUS_ID):null;
         var createdAt:String = DateUtil.getMySQLDate(this.matchCreatedAt);
         var gameId:int = this.gameId;
         var matchId:int = matchData.uid;
         var peopleInLobby:int = Math.max(0,this.matchPeopleInLobby);
         var joinAttempts:int = Math.max(1,this.matchJoinAttempts);
         var roundNum:int = this.matchRound;
         var timeToJoin:int = this.enteredLobbyTime - this.attemptedToEnterLobbyTime;
         var joinType:int = this.matchJoinType;
         var timeLeft:int = this.matchMadeTimeLeft;
         var stats:Object = {
            "lobby_jid":this.lobbyJid,
            "lobby_round":roundNum,
            "user_id":userId,
            "anonymous_id":anonId,
            "created_at":createdAt,
            "people_in_lobby":peopleInLobby,
            "time_to_join":timeToJoin,
            "time_left":timeLeft,
            "join_attempts":joinAttempts,
            "join_type":joinType
         };
         var responder:Responder = new Responder();
         responder.setAsyncListeners(this.onMatchMakingPerformanceSent);
         var event:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SEND_PERFORMANCE_STATS);
         event.data = {
            "name":"matchmaking",
            "vals":stats
         };
         event.responder = responder;
         StageReference.stage.dispatchEvent(event);
         this.logger.log("Recording match making performance");
         this.matchMakingPerformanceSent = true;
      }
      
      protected function recordUserInLobbyPerformance() : void
      {
         if(this.userInLobbyPerformanceSent || !this.lobbyEntered)
         {
            return;
         }
         if(!this.matchMakingPerformanceSent)
         {
            this.recordMatchMakingPerformance();
         }
         var matchData:MatchData = AppComponents.gamenetManager.currentMatch;
         var userId:* = AppComponents.model.privateUser && AppComponents.model.privateUser.isLoggedIn?AppComponents.model.privateUser.id:null;
         var anonId:* = !userId?AppComponents.localStore.getObject(LocalProperties.SAVED_ANONYMOUS_ID):null;
         var lobbyJid:String = this.lobbyJid;
         var lobbyRound:int = this.matchRound;
         var matchMakingId:int = this.matchMakingId;
         var userChats:Array = this.getChatsForUser(matchData,AppComponents.gamenetManager.currentPlayer.playerJid);
         var leftLobbyAt:String = Boolean(this.lobbyUserLeftAt)?DateUtil.getMySQLDate(this.lobbyUserLeftAt):"";
         var createdAt:String = DateUtil.getMySQLDate(this.lobbyCreatedAt);
         var stats:Object = {
            "user_id":userId,
            "anonymous_id":anonId,
            "matchmaking_id":matchMakingId,
            "lobby_jid":lobbyJid,
            "lobby_round":lobbyRound,
            "left_lobby_at":leftLobbyAt,
            "chats":(Boolean(userChats)?userChats.length:0),
            "created_at":createdAt
         };
         var responder:Responder = new Responder();
         responder.setAsyncListeners(this.onUserInLobbyPerformanceSent);
         var event:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SEND_PERFORMANCE_STATS);
         event.data = {
            "name":"user_in_lobby",
            "vals":stats
         };
         event.responder = responder;
         StageReference.stage.dispatchEvent(event);
         this.logger.log("Recording lobby performance (user)");
         this.userInLobbyPerformanceSent = true;
      }
      
      protected function recordLobbyPerformance(matchData:MatchData) : void
      {
         if(this.lobbyPerformanceSent)
         {
            return;
         }
         var userId:* = AppComponents.model.privateUser && AppComponents.model.privateUser.isLoggedIn?AppComponents.model.privateUser.id:null;
         var anonId:* = !userId?AppComponents.localStore.getObject(LocalProperties.SAVED_ANONYMOUS_ID):null;
         var isHost:Boolean = AppComponents.model.privateUser && AppComponents.model.privateUser.isLoggedIn?Boolean(matchData.host.userId == userId):Boolean(matchData.host.guestId == anonId);
         if(!isHost)
         {
            return;
         }
         var previousMatchJid:* = Boolean(this.lastMatchJid)?this.lastMatchJid:null;
         var previousGameRound:* = Boolean(this.lastMatchRound)?this.lastMatchRound:null;
         var gameId:int = this.gameId;
         var roundNum:int = Math.max(1,matchData.round);
         var lifetime:int = new Date().getTime() - matchData.createdTime;
         var kicks:int = matchData.kickedProfiles.length + matchData.kickedGuests.length;
         var joins:int = matchData.numJoins;
         var leaves:int = matchData.numLeaves;
         var chats:int = matchData.numChats;
         var extendedTimes:int = matchData.numExtensions;
         var lobbyDestroyed:Boolean = !matchData.participants.length;
         var createdAtDate:Date = new Date();
         createdAtDate.setTime(matchData.createdTime);
         var createdAt:String = DateUtil.getMySQLDate(createdAtDate);
         var stats:Object = {
            "previous_game_jid":previousMatchJid,
            "previous_game_round":previousGameRound,
            "game_id":gameId,
            "round_num":roundNum,
            "lifetime":lifetime,
            "kicks":kicks,
            "joins":joins,
            "leaves":leaves,
            "chats":chats,
            "extended_times":extendedTimes,
            "lobby_destroyed":lobbyDestroyed,
            "created_at":createdAt
         };
         var event:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SEND_PERFORMANCE_STATS);
         event.data = {
            "name":"lobby_room",
            "vals":stats
         };
         StageReference.stage.dispatchEvent(event);
         this.logger.log("Recording lobby performance (host)");
         this.lobbyPerformanceSent = true;
      }
      
      protected function recordMatchData() : void
      {
         var matchData:MatchData = null;
         var avgStats:Object = null;
         var lobbyJid:String = null;
         var userId:* = undefined;
         var anonId:* = undefined;
         var roundNum:int = 0;
         var gameId:int = 0;
         var avgFps:int = 0;
         var avgLatency:int = 0;
         var memoryUsage:int = 0;
         var flashVersion:String = null;
         var usersInMatch:int = 0;
         var stats:Object = null;
         var event:ApplicationEvent = null;
         this.stopTracking();
         if(this.gameId && this.matchStarted)
         {
            matchData = AppComponents.gamenetManager.currentMatch;
            avgStats = this.trackingAverages;
            lobbyJid = this.lobbyJid;
            userId = AppComponents.model.privateUser && AppComponents.model.privateUser.isLoggedIn?AppComponents.model.privateUser.id:null;
            anonId = !userId?AppComponents.localStore.getObject(LocalProperties.SAVED_ANONYMOUS_ID):null;
            roundNum = this.matchRound;
            gameId = this.gameId;
            avgFps = avgStats.fps;
            avgLatency = avgStats.latency;
            memoryUsage = avgStats.memoryUsage;
            flashVersion = Capabilities.version;
            usersInMatch = this.matchParticipants;
            stats = {
               "user_id":userId,
               "anonymous_id":anonId,
               "jid":lobbyJid,
               "round":roundNum,
               "game_id":gameId,
               "avg_fps":avgFps,
               "avg_latency":avgLatency,
               "memory_usage":memoryUsage,
               "flash_version":flashVersion,
               "users_in_match":usersInMatch
            };
            event = new ApplicationEvent(ApplicationEvent.SEND_PERFORMANCE_STATS);
            event.data = {
               "name":"game_performance",
               "vals":stats
            };
            StageReference.stage.dispatchEvent(event);
            this.logger.log("Recording match performance (user)");
         }
      }
      
      protected function startTracking(sampleSize:int = 0) : void
      {
         this.sampleSize = sampleSize;
         this.stopTracking();
         this.performanceHistory = new Array();
         this.frameCount = 0;
         this.lastFrame = getTimer();
         this.fpsTimer.start();
         AppComponents.display.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function stopTracking() : void
      {
         AppComponents.display.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.fpsTimer.stop();
      }
      
      protected function onEnterFrame(event:Event) : void
      {
         this.frameCount++;
      }
      
      protected function onFpsTimer(event:TimerEvent) : void
      {
         var curFrame:int = getTimer();
         if(curFrame - this.lastFrame >= 1000)
         {
            if(this.sampleSize && this.performanceHistory.length == this.sampleSize)
            {
               this.performanceHistory.splice(0,1);
            }
            this.performanceHistory.push({
               "fps":this.frameCount,
               "memoryUsage":System.totalMemory,
               "latency":AppComponents.gamenetManager.currentPlayer.pingTime
            });
            this.frameCount = 0;
            this.lastFrame = curFrame;
         }
      }
      
      protected function get trackingAverages() : Object
      {
         var i:int = 0;
         var sample:Object = null;
         var avg:Object = {
            "fps":0,
            "memoryUsage":0,
            "latency":0
         };
         if(this.performanceHistory)
         {
            for(i = 0; i < this.performanceHistory.length; i++)
            {
               sample = this.performanceHistory[i];
               avg.fps = avg.fps + this.performanceHistory[i].fps;
               avg.latency = avg.latency + this.performanceHistory[i].latency;
               avg.memoryUsage = avg.memoryUsage + this.performanceHistory[i].memoryUsage;
            }
            avg.fps = avg.fps / this.performanceHistory.length;
            avg.latency = avg.latency / this.performanceHistory.length;
            avg.memoryUsage = avg.memoryUsage / this.performanceHistory.length;
         }
         return avg;
      }
      
      protected function onInitTimer(event:TimerEvent) : void
      {
         if(AppComponents.gamenetManager && AppComponents.gamenetManager.currentMatch)
         {
            StageReference.stage.addEventListener(ArcadeEvent.QUICK_PLAY,this.onMatchQuickPlay);
            StageReference.stage.addEventListener(ArcadeEvent.CREATE_MATCH,this.onMatchCreate);
            StageReference.stage.addEventListener(ApplicationEvent.SHOW_PAGE,this.onMatchQuickPlayAuto);
            StageReference.stage.addEventListener(ArcadeEvent.JOIN_PLAYER_BY_PROFILE_ID,this.onMatchJoinByProfileId);
            StageReference.stage.addEventListener(ArcadeEvent.JOIN_MATCH_BY_INVITATION,this.onMatchJoinByInvitation);
            StageReference.stage.addEventListener(ArcadeEvent.JOIN_PLAYER_BY_PROFILE_ID_AUTHENTICATED,this.onMatchJoinByProfileId);
            StageReference.stage.addEventListener(ArcadeEvent.SHOW_GAME_PLAY,this.onShowGamePlay);
            StageReference.stage.addEventListener(ArcadeEvent.CHECK_MATCH_EXISTENCE,this.onMatchCheckExistence);
            AppComponents.gamenetManager.currentMatch.addEventListener(MatchDataEvent.MATCH_START,this.onMatchStart);
            StageReference.stage.addEventListener(ArcadeEvent.KICK_PLAYER,this.onMatchForceLeaveHost);
            AppComponents.gamenetManager.currentMatch.addEventListener(MatchDataEvent.FORCE_LEAVE,this.onMatchForceLeavePlayer);
            StageReference.stage.addEventListener(ArcadeEvent.QUIT_MATCH,this.onMatchQuit);
            this.initTimer.stop();
            delete this["initTimer"];
         }
      }
      
      protected function onMatchMakingPerformanceSent(event:AsyncEvent) : void
      {
         this.matchMakingId = event.data.matchmaking_id;
      }
      
      protected function onUserInLobbyPerformanceSent(event:AsyncEvent) : void
      {
         this.userInLobbyId = event.data.user_in_lobby_id;
      }
      
      protected function setJoinType(joinType:int) : void
      {
         if(this.matchJoinType == this.JOIN_TYPE_QUICK_PLAY && joinType == this.JOIN_TYPE_CREATE)
         {
            joinType = this.JOIN_TYPE_QUICK_PLAY_CREATE;
         }
         this.matchJoinType = joinType;
      }
      
      protected function get targetFPS() : int
      {
         return AppComponents.display.stage.frameRate;
      }
      
      protected function getChatsForUser(matchData:MatchData, playerJid:String) : Array
      {
         var chat:ChatData = null;
         var chats:Array = new Array();
         if(matchData.chatMessages)
         {
            for each(chat in matchData.chatMessages.source)
            {
               if(chat.player && chat.player.playerJid == playerJid)
               {
                  chats.push(chat);
               }
            }
         }
         return chats;
      }
   }
}
