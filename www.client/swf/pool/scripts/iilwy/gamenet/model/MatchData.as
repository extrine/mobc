package iilwy.gamenet.model
{
   import be.boulevart.as3.security.RC4;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.delegates.arcade.GamenetMatchDelegate;
   import iilwy.gamenet.GamenetManager;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.events.RoomDataEvent;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.gamenet.utils.MessageSerializer;
   import iilwy.gamenet.utils.PlayerRoles;
   import iilwy.model.dataobjects.AnimationData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.tracking.KontagentTracker;
   import iilwy.tracking.TrackerType;
   import iilwy.utils.logging.Logger;
   import mochi.as3.MochiDigits;
   import org.igniterealtime.xiff.collections.events.CollectionEvent;
   import org.igniterealtime.xiff.collections.events.CollectionEventKind;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.Browser;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class MatchData extends RoomData
   {
      
      public static const READY_TIME_MINIMUM:Number = 10000;
      
      public static const READY_TIME_MAXIMUM:Number = 60000;
      
      public static const READY_TIME_INITIAL:Number = 25000;
      
      public static const READY_TIME_ROUND_ONE:Number = 20000;
       
      
      private var _subject:String;
      
      private var _config:Object;
      
      private var _maxPlayers:MochiDigits;
      
      private var _host:PlayerData;
      
      private var _state:String;
      
      public var description:String;
      
      public var gameId:String;
      
      private var _browser:Browser;
      
      private var _playerposfind:String;
      
      public var approvedPlayerJids:Array;
      
      public var spectatorJids:Array;
      
      public var open:Boolean;
      
      public var randomSeed:Number;
      
      public var createdTime:Number;
      
      public var startTime:Number;
      
      public var readyTime:Number;
      
      public var avgRating:Number;
      
      public var avgLevel:Number;
      
      public var avgGameLevel:Number;
      
      public var skillLevel:String;
      
      public var useItems:Boolean;
      
      public var teamType:String;
      
      public var gameType:String;
      
      public var betAmount:int = -1;
      
      public var serverID:int = -1;
      
      public var privateMatch:Boolean;
      
      public var friendsOnly:Boolean = false;
      
      public var allowGuests:Boolean = true;
      
      public var minLevel:Number = 0;
      
      public var minRating:Number = 0;
      
      public var uid:int = -1;
      
      public var kickedJids:Array;
      
      public var kickedProfiles:Array;
      
      public var kickedGuests:Array;
      
      public var libVersion:String;
      
      public var round:Number;
      
      public var scores:Object;
      
      public var thumbnailUrl:String;
      
      public var aboutString:String;
      
      public var predictedOpenTime:Number;
      
      public var numChats:int;
      
      public var numJoins:int;
      
      public var numLeaves:int;
      
      public var numExtensions:int;
      
      public var _playerRole:String;
      
      private var _behavior:IMatchBehavior;
      
      public var spectators:PlayerCollection;
      
      private var _apiUpdateTimer:Timer;
      
      private var _apiPingTimer:Timer;
      
      public var _reportedPingTime:Boolean;
      
      public function MatchData(gamenetManager:GamenetManager)
      {
         this._maxPlayers = new MochiDigits();
         this.approvedPlayerJids = [];
         this.spectatorJids = [];
         this.kickedJids = [];
         this.kickedProfiles = [];
         this.kickedGuests = [];
         this.scores = {};
         super(gamenetManager);
         _logger.level = Logger.INFO;
         this._browser = new Browser(gamenetManager.connection);
         this.spectators = new PlayerCollection();
         this._apiUpdateTimer = new Timer(400,1);
         this._apiUpdateTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onApiUpdate);
         this._apiPingTimer = new Timer(60 * 1000);
         this._apiPingTimer.addEventListener(TimerEvent.TIMER,this.onApiPingTimer);
         addEventListener(MatchDataEvent.PING_TIME_INFORM,this.onPingTimeInform);
         addEventListener(MatchDataEvent.MATCH_END,this.onMatchEnd);
         addEventListener(MatchDataEvent.ALERT,this.onAlert);
         addEventListener(MatchDataEvent.NOTIFY,this.onNotify);
         addEventListener(RoomDataEvent.USER_PRESENCE_CHANGE,this.onUserPresenceChange);
      }
      
      public function joinMatch(name:String, role:String, config:MatchListingData = null) : void
      {
         var isHost:Boolean = role == PlayerRoles.HOST;
         if(role == PlayerRoles.HOST)
         {
            join(name,true);
         }
         else
         {
            join(name);
         }
         _logger.log("Joining",name,role);
         this.clearConfiguration();
         this._apiPingTimer.start();
         this.playerRole = role;
         this._behavior.join(name,config);
         this._reportedPingTime = false;
         if(isHost)
         {
            this.createdTime = new Date().getTime();
         }
         dispatchEvent(new MatchDataEvent(MatchDataEvent.MATCH_ROOM_INITIALIZED));
      }
      
      public function clearConfiguration() : void
      {
         this.libVersion = "";
         this.playerRole = "";
         this.subject = "";
         this.config = "";
         this.uid = -1;
         this.maxPlayers = -1;
         this.host = new PlayerData();
         this.state = "";
         this.description = "";
         this.gameId = "";
         this.approvedPlayerJids = [];
         this.spectatorJids = [];
         this.randomSeed = -1;
         this.createdTime = -1;
         this.startTime = -1;
         this.readyTime = -1;
         this.open = true;
         this.skillLevel = "";
         this.useItems = true;
         this.privateMatch = false;
         this.teamType = "";
         this.gameType = "";
         this.betAmount = -1;
         this.round = 0;
         this.serverID = -1;
         this.scores = {};
         this.friendsOnly = false;
         this.allowGuests = false;
         this.minLevel = 0;
         this.minRating = 0;
         this.avgRating = 1200;
         this.avgGameLevel = 0;
         this.avgLevel = 1;
         this.kickedJids = [];
         this.kickedProfiles = [];
         this.kickedGuests = [];
         this.thumbnailUrl = "";
         this.aboutString = "";
         this.predictedOpenTime = 0;
         this.numChats = 0;
         this.numJoins = 0;
         this.numLeaves = 0;
         this.numExtensions = 0;
      }
      
      override public function leave() : void
      {
         if(this.isHostedByCurrentPlayer())
         {
            this.hostLeave();
         }
         if(AppComponents.gamenetManager.currentPlayer)
         {
            AppComponents.gamenetManager.currentPlayer.reset();
         }
         this.spectators.removeAll();
         this.clearConfiguration();
         this._apiPingTimer.stop();
         this._apiUpdateTimer.stop();
         super.leave();
      }
      
      public function get behavior() : IMatchBehavior
      {
         return this._behavior;
      }
      
      public function get playerRole() : String
      {
         return this._playerRole;
      }
      
      public function set playerRole(role:String) : void
      {
         _logger.info("Setting role to ",role);
         if(this._behavior != null)
         {
            this._behavior.detach();
            this._behavior = null;
         }
         if(role == PlayerRoles.HOST)
         {
            this._behavior = new MatchBehaviorHost();
            this._behavior.attach(this);
         }
         else if(role == PlayerRoles.PLAYER)
         {
            this._behavior = new MatchBehaviorPlayer();
            this._behavior.attach(this);
         }
         else if(role == PlayerRoles.SPECTATOR)
         {
            this._behavior = new MatchBehaviorSpectator();
            this._behavior.attach(this);
         }
         this._playerRole = role;
      }
      
      public function assumeNewRole(role:String) : void
      {
         this.playerRole = role;
         this._behavior.registerInGameEvents();
      }
      
      public function getServiceInfo() : void
      {
         this._browser.connection = gamenetManager.connection;
         var jid:UnescapedJID = new UnescapedJID(xmppRoom.roomName + "@" + gamenetManager.conferenceServer);
         this._browser.getServiceInfo(jid.escaped,this.onGetServiceInfo);
      }
      
      public function onGetServiceInfo(iq:IQ) : void
      {
         var subject:* = undefined;
         var evt:RoomDataEvent = null;
         if(!this.isHostedByCurrentPlayer())
         {
            subject = DataUtil.getSubjectFromServiceInfo(iq);
            if(subject != null)
            {
               this.initFromSubject(subject);
               evt = new RoomDataEvent(RoomDataEvent.SERVICE_INFO_SET);
               dispatchEvent(evt);
            }
         }
      }
      
      override protected function onSubjectChange(evt:RoomEvent) : void
      {
         var subject:Object = null;
         var str:String = null;
         if(!this.isHostedByCurrentPlayer())
         {
            try
            {
               str = evt.subject;
               subject = JSON.deserialize(str);
               _logger.info("Heard subject change",str);
            }
            catch(e:Error)
            {
            }
            if(subject != null)
            {
               if(subject.approved_player_jids.length > 0)
               {
                  this.initFromSubject(subject);
               }
               else
               {
                  _logger.error("Subject with zero approved players heard");
                  _logger.error(str);
               }
            }
            else
            {
               _logger.error("Null subject");
               _logger.error(str);
            }
            this.invalidatePlayersCollection();
         }
         super.onSubjectChange(evt);
      }
      
      protected function initFromSubject(subject:*) : void
      {
         this.uid = subject.uid;
         this.description = subject.description;
         this.config = subject.config;
         this.gameId = subject.game_id;
         this.maxPlayers = subject.max_players;
         this.approvedPlayerJids = subject.approved_player_jids;
         this.spectatorJids = subject.spectator_jids;
         this.host = new PlayerData();
         this.host.initFromStatusObject(subject.host);
         this.open = subject.open;
         this.createdTime = subject.created_time;
         this.startTime = subject.start_time;
         this.readyTime = subject.ready_time;
         this.randomSeed = subject.random_seed;
         this.skillLevel = subject.skill_level;
         this.useItems = subject.game_type == "items_on";
         this.teamType = subject.team_type;
         this.gameType = subject.game_type;
         this.betAmount = subject.bet_amount;
         this.scores = subject.scores;
         this.round = subject.round;
         this.serverID = subject.server_id;
         this.privateMatch = subject.private_match;
         this.friendsOnly = subject.friends_only;
         this.allowGuests = subject.allow_guests == null?Boolean(true):Boolean(subject.allow_guests);
         this.minLevel = subject.min_level;
         this.minRating = subject.min_elo;
         this.avgRating = subject.avg_elo;
         this.avgGameLevel = subject.avg_game_level;
         this.avgLevel = subject.avg_level;
         this.kickedJids = subject.kicked_jids;
         this.kickedProfiles = subject.kicked_profiles;
         this.kickedGuests = subject.kicked_guests;
         this.libVersion = subject.lib_version;
         this.thumbnailUrl = subject.thumbnail_url;
         this.aboutString = subject.about_string;
         this.predictedOpenTime = subject.open_at;
         this.numChats = subject.chats;
         this.numJoins = subject.joins;
         this.numLeaves = subject.leaves;
         this.numExtensions = subject.extensions;
      }
      
      public function toSubjectObj() : Object
      {
         var obj:Object = {
            "uid":this.uid,
            "description":this.description,
            "config":this._config,
            "game_id":this.gameId,
            "max_players":this.maxPlayers.toString(),
            "approved_player_jids":this.approvedPlayerJids,
            "spectator_jids":this.spectatorJids,
            "host":this._host.toMinimizedStatusObject(),
            "open":this.open,
            "random_seed":this.randomSeed,
            "created_time":this.createdTime,
            "start_time":this.startTime,
            "ready_time":this.readyTime,
            "skill_level":this.skillLevel,
            "use_items":this.useItems,
            "team_type":this.teamType,
            "game_type":this.gameType,
            "scores":this.scores,
            "round":this.round,
            "server_id":this.serverID,
            "player_data":players.toObject(),
            "private_match":this.privateMatch,
            "team_data":{},
            "avg_elo":this.avgRating,
            "avg_game_level":this.avgGameLevel,
            "avg_level":this.avgLevel,
            "jid":xmppRoom.roomName,
            "friends_only":this.friendsOnly,
            "allow_guests":this.allowGuests,
            "min_level":this.minLevel,
            "min_elo":this.minRating,
            "kicked_jids":this.kickedJids,
            "kicked_profiles":this.kickedProfiles,
            "kicked_guests":this.kickedGuests,
            "lib_version":this.libVersion,
            "thumbnail_url":this.thumbnailUrl,
            "about_string":this.aboutString,
            "open_at":this.predictedOpenTime,
            "chats":this.numChats,
            "joins":this.numJoins,
            "leaves":this.numLeaves,
            "extensions":this.numExtensions
         };
         if(this.betAmount > -1)
         {
            obj.bet_amount = this.betAmount;
         }
         return obj;
      }
      
      public function sendSubject() : void
      {
         var subj:String = null;
         var obj:Object = this.toSubjectObj();
         subj = JSON.serialize(obj);
         xmppRoom.changeSubject(subj);
         _logger.info("Sending subject");
         if(!this._apiUpdateTimer.running)
         {
            this._apiUpdateTimer.reset();
            this._apiUpdateTimer.start();
         }
      }
      
      protected function onApiUpdate(event:Event) : void
      {
         if(isActive() && this.isHostedByCurrentPlayer())
         {
            new GamenetMatchDelegate().updateMatch(this);
         }
      }
      
      protected function onApiPingTimer(event:Event) : void
      {
         if(isActive() && this.isHostedByCurrentPlayer())
         {
            new GamenetMatchDelegate().pingMatch(xmppRoom.roomName);
         }
      }
      
      override protected function onPingTimer(event:TimerEvent) : void
      {
         var now:Number = NaN;
         var player:PlayerData = null;
         super.onPingTimer(event);
         if(isActive() && this.isHostedByCurrentPlayer())
         {
            now = new Date().time;
            for each(player in players.source)
            {
               if(now - player.keepAliveTimeStamp > 80000)
               {
                  this.hostKickPlayer(player.playerJid,"You were removed from the match due to inactivity",false);
               }
            }
         }
      }
      
      override protected function updatePingTime(time:Number) : void
      {
         var roundedBonus:int = 0;
         var bonus:Number = AppComponents.model.dateDrift;
         if(!this._reportedPingTime)
         {
            this._reportedPingTime = true;
            AppComponents.analytics.trackDiagnostic("pingtime/" + Math.round(time / 10) * 10);
            roundedBonus = Math.round(bonus / 10) * 10;
            AppComponents.analytics.trackDiagnostic("bonus/" + roundedBonus);
            if(bonus > 3000 || bonus < -3000)
            {
               roundedBonus = Math.round(bonus / 100) * 100;
               if(AppComponents.model.privateUser.isLoggedIn)
               {
                  AppComponents.analytics.trackDiagnostic("extraBonus/" + roundedBonus + "/" + AppComponents.model.arcade.currentGamePack.id + "/" + AppComponents.model.privateUser.id);
               }
               else
               {
                  AppComponents.analytics.trackDiagnostic("extraBonus/" + roundedBonus + "/" + AppComponents.model.arcade.currentGamePack.id + "/guest/" + AppComponents.gamenetManager.currentPlayer.guestId);
               }
               _logger.info("Extra bonus: " + bonus);
            }
         }
         AppComponents.gamenetManager.currentPlayer.pingTime = time;
         AppComponents.gamenetManager.currentPlayer.bonus = bonus;
         _logger.info("Ping time: " + time);
         this.sendMatchEvent(MatchDataEvent.PING_TIME_INFORM,{
            "time":time,
            "bonus":bonus
         });
      }
      
      private function onMatchEnd(event:MatchDataEvent) : void
      {
         this._reportedPingTime = false;
         AppComponents.gamenetManager.currentPlayer.updateInventory();
         AppComponents.gamenetManager.updatePresence();
      }
      
      private function onAlert(event:MatchDataEvent) : void
      {
         this.alertSelf(event.data.method,event.data.args);
      }
      
      private function onNotify(event:MatchDataEvent) : void
      {
         this.notifySelf(event.data.method,event.data.args);
      }
      
      private function onPingTimeInform(event:MatchDataEvent) : void
      {
         _logger.log("ping time informed",event.data.time);
         var player:PlayerData = players.findPlayerByJid(event.sender);
         if(player)
         {
            player.pingTime = event.data.time;
            player.keepAliveTimeStamp = new Date().time;
            player.bonus = event.data.bonus;
            players.itemUpdated(player);
         }
      }
      
      protected function onUserPresenceChange(event:RoomDataEvent) : void
      {
         var extension:PlayerExtension = null;
         var i:int = 0;
         var roomOccupant:RoomOccupant = null;
         var occupantJID:UnescapedJID = null;
         var player:PlayerData = players.findPlayerByJid(event.nickname);
         if(player)
         {
            for(i = 0; i < xmppRoom.length; i++)
            {
               roomOccupant = xmppRoom.getItemAt(i) as RoomOccupant;
               occupantJID = DataUtil.normalizeJID(roomOccupant.jid);
               if(roomOccupant.displayName == player.playerJid)
               {
                  try
                  {
                     extension = participants.getItemAtKey(occupantJID.node);
                  }
                  catch(e:Error)
                  {
                     trace("Presence for nonexistant participant");
                     _logger.warn("Presence for nonexistant participant");
                  }
               }
            }
            if(extension)
            {
               player.initFromPlayerExtension(extension);
               players.itemUpdated(player);
            }
         }
      }
      
      override protected function onRoomCollectionChange(event:CollectionEvent) : void
      {
         var player:PlayerData = null;
         var item:RoomOccupant = null;
         if(event.kind != CollectionEventKind.ADD)
         {
            if(event.kind == CollectionEventKind.REMOVE)
            {
               for each(item in event.items)
               {
                  player = createPlayerDataForParticipant(item);
                  if(player && !this.isHostedByCurrentPlayer())
                  {
                     if(player.equals(this.host))
                     {
                        dispatchEvent(new MatchDataEvent(MatchDataEvent.HOST_LEFT));
                     }
                  }
               }
            }
            else if(event.kind == CollectionEventKind.RESET)
            {
            }
         }
      }
      
      public function updateScores() : void
      {
         var jid:* = null;
         var p:PlayerData = null;
         if(players)
         {
            for(jid in this.scores)
            {
               p = players.findPlayerByJid(jid);
               if(p)
               {
                  p.score = this.scores[jid];
                  players.itemUpdated(p);
               }
            }
         }
      }
      
      override protected function findPlayerForChat(jid:String) : PlayerData
      {
         var player:PlayerData = super.findPlayerForChat(jid);
         if(player == null)
         {
            player = this.spectators.findPlayerByJid(jid);
         }
         return player;
      }
      
      public function groomApprovedLists() : void
      {
         var index:int = 0;
         var roomOccupant:RoomOccupant = null;
         var player:PlayerData = null;
         var validJids:Array = [];
         for(var i:int = 0; i < xmppRoom.length; i++)
         {
            roomOccupant = xmppRoom.getItemAt(i) as RoomOccupant;
            player = createPlayerDataForParticipant(roomOccupant);
            validJids.push(player.playerJid);
         }
         var tList:Array = [];
         for(i = 0; i < this.approvedPlayerJids.length; i++)
         {
            index = validJids.indexOf(this.approvedPlayerJids[i]);
            if(index >= 0)
            {
               tList.push(this.approvedPlayerJids[i]);
            }
         }
         this.approvedPlayerJids = tList;
         tList = [];
         for(i = 0; i < this.spectatorJids.length; i++)
         {
            index = validJids.indexOf(this.spectatorJids[i]);
            if(index >= 0)
            {
               tList.push(this.spectatorJids[i]);
            }
         }
         this.spectatorJids = tList;
      }
      
      public function updatePlayersCollection() : void
      {
         var i:int = 0;
         var j:int = 0;
         var p:PlayerData = null;
         var tp:PlayerData = null;
         var existing:PlayerData = null;
         var jid:String = null;
         var roomOccupant:RoomOccupant = null;
         var occupantJID:UnescapedJID = null;
         var extension:PlayerExtension = null;
         var index:int = 0;
         var gEvent:GamenetEvent = null;
         var tPlayers:PlayerCollection = new PlayerCollection();
         var tSpectators:PlayerCollection = new PlayerCollection();
         for(i = 0; i < this.approvedPlayerJids.length; i++)
         {
            tPlayers.addItem({});
         }
         for(i = 0; i < this.spectatorJids.length; i++)
         {
            tSpectators.addItem({});
         }
         _logger.info("Updating player collection --------");
         _logger.info("My jid: ",AppComponents.gamenetManager.currentPlayer.playerJid);
         _logger.info("Roster length: ",xmppRoom.length);
         _logger.info("Approved players (",this.approvedPlayerJids.length,"): ",this.approvedPlayerJids);
         _logger.info("Approved spectators (",this.spectatorJids.length,"): ",this.spectatorJids);
         var removedPlayerJids:Array = [];
         for(i = 0; i < xmppRoom.length; i++)
         {
            roomOccupant = xmppRoom.getItemAt(i) as RoomOccupant;
            occupantJID = DataUtil.normalizeJID(roomOccupant.jid);
            if(participants.containsItemAtKey(occupantJID.node))
            {
               extension = participants.getItemAtKey(occupantJID.node);
            }
            else
            {
               _logger.warn("No extension for participant");
            }
            _logger.info("Checking",roomOccupant.displayName);
            index = this.approvedPlayerJids.indexOf(roomOccupant.displayName);
            _logger.info("Checked approved players",index);
            if(index > -1 && extension)
            {
               p = new PlayerData();
               p.initFromPlayerExtension(extension);
               p.score = this.scores[p.playerJid];
               _logger.info("Inited player to",p.profileName);
               tPlayers.setPlayerAt(p,index);
            }
            index = this.spectatorJids.indexOf(roomOccupant.displayName);
            _logger.info("Checked spectators",index);
            if(index > -1 && extension)
            {
               p = new PlayerData();
               p.initFromPlayerExtension(extension);
               _logger.info("Inited spectator to",p.profileName);
               tSpectators.setPlayerAt(p,index);
            }
         }
         _logger.info("tSpectators length",tSpectators.length);
         _logger.info("tPlayers length",tPlayers.length);
         for(i = 0; i < players.length; i++)
         {
            p = players.getItemAt(i) as PlayerData;
            existing = tPlayers.findPlayerByJid(p.playerJid);
            if(!existing)
            {
               players.removePlayer(p);
               removedPlayerJids.push(p.playerJid);
               _logger.info("Removing player",p.profileName);
            }
         }
         for(i = 0; i < tPlayers.length; i++)
         {
            tp = tPlayers.getItemAt(i) as PlayerData;
            if(tp)
            {
               existing = players.findPlayerByJid(tp.playerJid);
               if(!existing)
               {
                  players.addPlayer(tp);
               }
            }
            else
            {
               _logger.error("More approved players than in roster");
            }
         }
         for(i = 0; i < this.spectators.length; i++)
         {
            p = this.spectators.getItemAt(i) as PlayerData;
            existing = tSpectators.findPlayerByJid(p.playerJid);
            if(!existing)
            {
               this.spectators.removePlayer(p);
            }
         }
         for(i = 0; i < tSpectators.length; i++)
         {
            tp = tSpectators.getItemAt(i) as PlayerData;
            if(tp)
            {
               existing = this.spectators.findPlayerByJid(tp.playerJid);
               if(!existing)
               {
                  this.spectators.addPlayer(tp);
               }
            }
            else
            {
               _logger.error("More approved spectators than in roster");
            }
         }
         for each(jid in removedPlayerJids)
         {
            gEvent = new GamenetEvent(GamenetEvent.PLAYER_LEFT);
            gEvent.sender = jid;
            gEvent.recipient = gamenetManager.currentPlayer.playerJid;
            gEvent.data = {"jid":jid};
            gamenetManager.gamenetController.dispatchEvent(gEvent);
         }
         this.calculateAverages();
      }
      
      public function invalidatePlayersCollection() : void
      {
         this.updatePlayersCollection();
      }
      
      protected function calculateAverages() : void
      {
         var p:PlayerData = null;
         var rating:Number = NaN;
         var ratingCount:int = 0;
         var ratingSum:int = 0;
         var expCount:int = 0;
         var expSum:int = 0;
         var gameLevelCount:int = 0;
         var gameLevelSum:int = 0;
         var packId:String = this.gameId;
         var pack:ArcadeGamePackData = AppComponents.model.arcade.getGamePack(this.gameId);
         for(var i:int = 0; i < players.length; i++)
         {
            p = players.getItemAt(i);
            if(p.experience)
            {
               expSum = expSum + p.experience.level;
               expCount++;
            }
            if(p.gameLevels && p.gameLevels[packId])
            {
               gameLevelSum = gameLevelSum + p.gameLevels[packId];
               gameLevelCount++;
            }
            if(p.gameRatings)
            {
               rating = p.gameRatings[packId];
               ratingCount++;
               if(rating > 0)
               {
                  ratingSum = ratingSum + rating;
               }
               else if(pack)
               {
                  ratingSum = ratingSum + pack.defaultGuestRating;
               }
            }
         }
         this.avgLevel = expSum / expCount;
         this.avgRating = ratingSum / ratingCount;
         this.avgGameLevel = gameLevelSum / gameLevelCount;
         if(isNaN(this.avgRating))
         {
            this.avgRating = 1300;
         }
         if(isNaN(this.avgLevel))
         {
            this.avgLevel = 0;
         }
         if(isNaN(this.avgGameLevel))
         {
            this.avgGameLevel = 0;
         }
         _logger.info("Avg game level: ",this.avgGameLevel,"Avg level: ",this.avgLevel,"Avg rating: ",this.avgRating,"Valid ratings: ",ratingCount);
      }
      
      public function hostClearReadyTime() : void
      {
         if(this.isHostedByCurrentPlayer() && this.open)
         {
            this.predictedOpenTime = 0;
            this.readyTime = -1;
            this.sendSubject();
         }
      }
      
      public function hostExtendReadyTime(count:Number = 10) : void
      {
         var oldReady:Number = NaN;
         if(this.isHostedByCurrentPlayer() && this.open)
         {
            oldReady = this.readyTime;
            if(this.readyTime == -1 && count == 10)
            {
               if(this.round == 0)
               {
                  this.readyTime = gamenetManager.serverNowTime + AppComponents.model.arcade.currentGamePack.roundOneReadyTime;
               }
               else
               {
                  this.readyTime = gamenetManager.serverNowTime + AppComponents.model.arcade.currentGamePack.initialReadyTime;
               }
            }
            else
            {
               if(this.readyTime > gamenetManager.serverNowTime + READY_TIME_MAXIMUM - 1000)
               {
                  return;
               }
               if(this.readyTime > gamenetManager.serverNowTime)
               {
                  this.readyTime = this.readyTime + (count * 1000 + 1000);
                  this.readyTime = this.readyTime - (this.readyTime - gamenetManager.serverNowTime) % 10000;
               }
               else
               {
                  this.readyTime = gamenetManager.serverNowTime + count * 1000 + 10000;
               }
            }
            this.readyTime = Math.min(this.readyTime,gamenetManager.serverNowTime + READY_TIME_MAXIMUM);
            this.sendSubject();
            _logger.info("Host extending ready time,",this.readyTime,oldReady,this.readyTime - oldReady);
            this.sendMatchEvent(MatchDataEvent.READY_TIME_CHANGED);
         }
      }
      
      public function hostStartMatch() : void
      {
         if(this.isHostedByCurrentPlayer() && this.open)
         {
            this.open = false;
            this.randomSeed = Math.floor(Math.random() * 10000000);
            this.startTime = gamenetManager.serverNowTime + 5000;
            this.readyTime = -1;
            this.sendSubject();
            _logger.info("Host starting match,","seed: " + this.randomSeed + ", start time: " + this.startTime);
            this.sendMatchEvent(MatchDataEvent.MATCH_START);
         }
      }
      
      public function hostKickPlayer(jid:String, msg:String = null, ban:Boolean = true) : void
      {
         var index:int = 0;
         var p:PlayerData = null;
         if(this.isHostedByCurrentPlayer())
         {
            if(jid != this.host.playerJid)
            {
               if(ban)
               {
                  this.kickedJids.push(jid);
                  p = players.findPlayerByJid(jid);
                  if(p.profileId)
                  {
                     this.kickedProfiles.push(p.profileId);
                  }
                  else if(p.guestId)
                  {
                     this.kickedGuests.push(p.guestId);
                  }
               }
               this.sendMatchEvent(MatchDataEvent.KICK_PLAYER,{"reason":msg},jid);
               index = this.approvedPlayerJids.indexOf(jid);
               if(index >= 0)
               {
                  this.approvedPlayerJids.splice(index,1);
               }
               index = this.spectatorJids.indexOf(jid);
               if(index >= 0)
               {
                  this.spectatorJids.splice(index,1);
               }
               this.invalidatePlayersCollection();
               this.sendSubject();
            }
         }
      }
      
      public function hostEndMatch() : void
      {
         if(this.isHostedByCurrentPlayer() && !this.open)
         {
            this.open = true;
            if(players.length < 2)
            {
               this.readyTime = -1;
            }
            else
            {
               this.readyTime = gamenetManager.serverNowTime + AppComponents.model.arcade.currentGamePack.initialReadyTime;
            }
            this.predictedOpenTime = 0;
            this.sendSubject();
            _logger.info("Host ending match");
            this.sendMatchEvent(MatchDataEvent.MATCH_END);
         }
      }
      
      public function recordRound(results:RoundResults) : void
      {
         if(this._behavior)
         {
            this._behavior.recordRound(results);
         }
      }
      
      public function hostLeave() : void
      {
         if(players.length <= 1)
         {
            try
            {
               new GamenetMatchDelegate().destroyMatch(xmppRoom.roomName);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function isHostedByCurrentPlayer() : Boolean
      {
         var flag:Boolean = false;
         if(this._host != null && this._host.equals(gamenetManager.currentPlayer) && this._playerRole == PlayerRoles.HOST)
         {
            flag = true;
         }
         return flag;
      }
      
      public function clearPremiumSettings() : void
      {
         this.minLevel = 0;
         this.minRating = 0;
         this.allowGuests = true;
         this.friendsOnly = false;
      }
      
      public function sendMatchEvent(type:String, data:Object = " ", playerJid:String = null) : void
      {
         _logger.log("Sending match event",type);
         var obj:Object = {
            "type":MessageSerializer.TYPE_MATCHMAKINGEVENT,
            "event":{
               "type":type,
               "data":data
            }
         };
         sendMessage(MessageSerializer.getInstance().serialize(obj),playerJid);
      }
      
      public function sendGameActionEncrypted(data:Object, playerJid:String = null) : void
      {
         var obj:Object = {
            "round":this.round,
            "type":MessageSerializer.TYPE_GAMEACTION,
            "edata":RC4.encrypt(JSON.serialize(data),AppComponents.gamenetManager.currentPlayer.playerJid)
         };
         sendMessage(MessageSerializer.getInstance().serialize(obj),playerJid);
      }
      
      public function sendGameAction(data:Object, playerJid:String = null) : void
      {
         var obj:Object = {
            "round":this.round,
            "type":MessageSerializer.TYPE_GAMEACTION,
            "data":data
         };
         sendMessage(MessageSerializer.getInstance().serialize(obj),playerJid);
      }
      
      public function alert(method:String, args:Array, playerJID:String = null) : void
      {
         AppComponents.gamenetManager.currentMatch.sendMatchEvent(MatchDataEvent.ALERT,{
            "method":method,
            "args":args
         },playerJID);
      }
      
      public function alertSelf(method:String, args:Array) : void
      {
         if(AppComponents.alertManager[method])
         {
            AppComponents.alertManager[method].apply(null,args);
         }
      }
      
      public function notify(method:String, args:Array, playerJID:String = null) : void
      {
         AppComponents.gamenetManager.currentMatch.sendMatchEvent(MatchDataEvent.NOTIFY,{
            "method":method,
            "args":args
         },playerJID);
      }
      
      public function notifySelf(method:String, args:Array) : void
      {
         if(AppComponents.notificationManager[method])
         {
            AppComponents.notificationManager[method].apply(null,args);
         }
      }
      
      public function track(trackerType:String, method:String, args:Array) : void
      {
         var kontagentTracker:KontagentTracker = null;
         if(trackerType == TrackerType.KONTAGENT)
         {
            kontagentTracker = AppComponents.analytics.kontagentTracker;
            if(kontagentTracker && kontagentTracker[method])
            {
               kontagentTracker[method].apply(null,args);
            }
         }
         else if(AppComponents.analytics[method])
         {
            AppComponents.analytics[method].apply(null,args);
         }
      }
      
      override protected function shouldReceiveGameEvent(msg:*) : Boolean
      {
         if(msg.round && msg.round != this.round)
         {
            return false;
         }
         return true;
      }
      
      public function fillPlayersWithSpectators() : void
      {
         var newPlayers:Array = null;
         var jid:String = null;
         var newJid:String = null;
         if(this.isHostedByCurrentPlayer())
         {
            newPlayers = [];
            if(this.approvedPlayerJids.length < this.maxPlayers && this.spectatorJids.length > 0)
            {
               do
               {
                  newJid = this.spectatorJids.shift();
                  newPlayers.push(newJid);
                  this.approvedPlayerJids.push(newJid);
               }
               while(this.approvedPlayerJids.length < this.maxPlayers && this.spectatorJids.length > 0);
               
            }
            if(newPlayers.length > 0)
            {
               this.invalidatePlayersCollection();
               this.sendSubject();
            }
            for each(jid in newPlayers)
            {
               this.sendMatchEvent(MatchDataEvent.SPECTATOR_TO_PLAYER,{},jid);
            }
         }
      }
      
      public function hostSetPredictedOpenTime(offset:Number) : void
      {
         var del:GamenetMatchDelegate = null;
         if(this.isHostedByCurrentPlayer())
         {
            this.predictedOpenTime = AppComponents.model.serverNow.time;
            this.predictedOpenTime = this.predictedOpenTime + offset;
            del = new GamenetMatchDelegate();
            del.setPredictedOpenTime(this);
         }
      }
      
      public function set subject(s:String) : void
      {
         this._subject = s;
      }
      
      public function set config(c:Object) : void
      {
         this._config = c;
      }
      
      public function set maxPlayers(p:int) : void
      {
         this._maxPlayers.value = p;
      }
      
      public function set host(h:PlayerData) : void
      {
         this._host = h;
      }
      
      public function set state(s:String) : void
      {
         this._state = s;
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function get config() : Object
      {
         return this._config;
      }
      
      public function get maxPlayers() : int
      {
         return this._maxPlayers.value;
      }
      
      public function get host() : PlayerData
      {
         return this._host;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function createTest() : void
      {
         var player:PlayerData = null;
         var animationData:AnimationData = null;
         for(var i:int = 0; i < 6; i++)
         {
            player = PlayerData.createTest(true);
            players.addItem(player);
            player.premiumLevel = PremiumLevels.CHARLES;
            player.profileName = "alksjflajksffl aksjdflaj sdfljkasf";
            if(Math.random() < 0.5)
            {
               player.premiumLevel = PremiumLevels.STAR;
            }
            animationData = new AnimationData();
         }
         this.open = true;
         this.description = "This is a test match";
         this.gameId = "dinglepop";
         this.host = players.getItemAt(0);
         this.readyTime = gamenetManager.serverNowTime + 60000;
         this.maxPlayers = 7;
      }
      
      public function willSpectatorBePromotedNextRound(player:PlayerData) : Boolean
      {
         if(!player || !player.playerJid)
         {
            return false;
         }
         var index:int = this.spectatorJids.indexOf(player.playerJid);
         if(index >= 0 && this.approvedPlayerJids.length + index < this.maxPlayers)
         {
            return true;
         }
         return false;
      }
   }
}
