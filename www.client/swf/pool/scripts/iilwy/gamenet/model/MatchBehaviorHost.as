package iilwy.gamenet.model
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.events.ArcadeEvent;
   import iilwy.events.CollectionEvent;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.events.RoomDataEvent;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.collections.events.CollectionEventKind;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class MatchBehaviorHost extends MatchBehavior implements IMatchBehavior
   {
       
      
      private var _pendingConfig:MatchListingData;
      
      protected var _roundRecorded:Boolean;
      
      protected var _joinTimer:Timer;
      
      public function MatchBehaviorHost()
      {
         super();
         this._joinTimer = new Timer(10000,0);
         this._joinTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onJoinTimeout);
      }
      
      public function attach(match:MatchData) : void
      {
         _match = match;
         _match.players.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onLogPlayersChange,false,0,true);
         _match.spectators.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onLogSpectatorsChange,false,0,true);
      }
      
      public function detach() : void
      {
         clearAllListeners();
         _match.players.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onLogPlayersChange);
         _match.spectators.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onLogSpectatorsChange);
         _match.xmppRoom.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange);
         _match.players.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPlayersCollectionChange);
         _match.spectators.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpectatorsCollectionChange);
         _match = null;
      }
      
      protected function onLogPlayersChange(event:iilwy.events.CollectionEvent) : void
      {
         _logger.log("Players  changed",event.kind);
      }
      
      protected function onLogSpectatorsChange(event:iilwy.events.CollectionEvent) : void
      {
         _logger.log("Spectators changed",event.kind);
      }
      
      public function join(matchName:String, config:MatchListingData) : void
      {
         _logger.log("Attempting to create room");
         addMatchListener(RoomDataEvent.CONFIGURE_ROOM,this.onJoinAndConfiguration);
         addMatchListener(RoomDataEvent.GENERIC_ERROR,this.onError);
         this._pendingConfig = config;
         this._joinTimer.reset();
         this._joinTimer.start();
      }
      
      protected function onError(event:Event) : void
      {
         clearAllListeners();
         _logger.error("Join match error");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_ERROR);
         _match.dispatchEvent(evt);
      }
      
      protected function onJoinTimeout(event:TimerEvent) : void
      {
         clearAllListeners();
         _logger.error("Timout configuring room");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_CREATE_TIMEOUT);
         _match.dispatchEvent(evt);
      }
      
      protected function onJoinAndConfiguration(event:RoomDataEvent) : void
      {
         _logger.log("Room created, Requesting configuration");
         removeMatchListener(RoomDataEvent.CONFIGURE_ROOM,this.onJoinAndConfiguration);
         _match.host = _match.gamenetManager.currentPlayer;
         _match.open = true;
         _match.description = this._pendingConfig.description;
         _match.maxPlayers = this._pendingConfig.maxPlayers;
         _match.config = this._pendingConfig.config;
         _match.state = "";
         _match.gameId = this._pendingConfig.gameId;
         _match.skillLevel = this._pendingConfig.skillLevel;
         _match.serverID = this._pendingConfig.serverID;
         _match.teamType = this._pendingConfig.teamType;
         _match.gameType = this._pendingConfig.gameType;
         _match.betAmount = this._pendingConfig.betAmount;
         _match.useItems = this._pendingConfig.gameType == "items_on";
         _match.privateMatch = this._pendingConfig.privateMatch;
         _match.allowGuests = this._pendingConfig.allowGuests;
         _match.minLevel = this._pendingConfig.minLevel;
         _match.minRating = this._pendingConfig.minRating;
         _match.friendsOnly = this._pendingConfig.friendsOnly;
         _match.libVersion = AppComponents.model.arcade.currentGamePack.libVersion;
         _match.approvedPlayerJids = [_match.gamenetManager.currentPlayer.playerJid];
         var xmppConfig:Object = new Object();
         xmppConfig["muc#roomconfig_changesubject"] = ["1"];
         addMatchListener(RoomDataEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigurationComplete);
         _match.xmppRoom.configure(xmppConfig);
      }
      
      protected function onConfigurationComplete(event:RoomDataEvent) : void
      {
         removeMatchListener(RoomDataEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigurationComplete);
         _logger.log("Room configured, sending subject");
         addMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onInitialSetSubject);
         _match.sendSubject();
      }
      
      protected function onInitialSetSubject(event:RoomDataEvent) : void
      {
         removeMatchListener(RoomDataEvent.GENERIC_ERROR,this.onError);
         this._joinTimer.stop();
         _logger.log("Subject sent");
         removeMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onInitialSetSubject);
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_CREATE);
         _match.dispatchEvent(evt);
         _match.invalidatePlayersCollection();
         this.registerInGameEvents();
         _match.pingSelf(1000);
      }
      
      public function registerInGameEvents() : void
      {
         addMatchListener(MatchDataEvent.REQUEST_KICK_PLAYER,this.onRequestKickPlayer);
         addMatchListener(MatchDataEvent.REQUEST_SPECTATOR_POSITION,this.onRequestSpectatorPosition);
         addMatchListener(MatchDataEvent.REQUEST_ROSTER_POSITION,this.onRequestRosterPosition);
         addMatchListener(MatchDataEvent.TIMESYNC_REQUEST,this.onRequestTimeSync);
         addMatchListener(MatchDataEvent.REQUEST_SPECTATOR_TO_PLAYER,this.onRequestSpectatorToPlayer);
         addMatchListener(MatchDataEvent.MATCH_END,this.onMatchEnd);
         addMatchListener(MatchDataEvent.MATCH_START,this.onMatchStart);
         _match.xmppRoom.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange,false,0,true);
         _match.chatMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChatCollectionChange,false,0,true);
         _match.players.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPlayersCollectionChange,false,0,true);
         _match.spectators.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpectatorsCollectionChange,false,0,true);
         _match.fillPlayersWithSpectators();
      }
      
      protected function onChatCollectionChange(event:iilwy.events.CollectionEvent) : void
      {
         var numChats:int = 0;
         var chat:ChatData = null;
         if(_match)
         {
            numChats = 0;
            for each(chat in _match.chatMessages)
            {
               if(chat.player)
               {
                  numChats++;
               }
            }
            _match.numChats = numChats;
         }
      }
      
      protected function onPlayersCollectionChange(event:iilwy.events.CollectionEvent) : void
      {
         var player:PlayerData = null;
         if(event.kind == CollectionEvent.KIND_REMOVE)
         {
            for each(player in event.items)
            {
               _match.sendNotification(player.profileName + " has left the match.");
            }
            if(_match.open)
            {
               _match.fillPlayersWithSpectators();
            }
         }
         else if(event.kind == CollectionEvent.KIND_ADD)
         {
            _match.numJoins++;
         }
      }
      
      protected function onRequestSpectatorToPlayer(event:MatchDataEvent) : void
      {
         if(_match.open)
         {
            _match.fillPlayersWithSpectators();
         }
      }
      
      protected function onSpectatorsCollectionChange(event:iilwy.events.CollectionEvent) : void
      {
      }
      
      public function recordRound(results:RoundResults) : void
      {
         var jid:* = null;
         var submitEvent2:ArcadeEvent = null;
         var prop:* = null;
         if(this._roundRecorded)
         {
            _logger.warn("Atempting to submit round multiple times");
            return;
         }
         this._roundRecorded = true;
         _match.round++;
         var endTime:Number = AppComponents.gamenetManager.serverNowTime;
         var duration:Number = endTime - _match.startTime;
         var newScores:Object = this.parseScoresFromRoundResults(results);
         var scores:Object = _match.scores;
         for(jid in newScores)
         {
            if(scores[jid] == null)
            {
               scores[jid] = new Object();
            }
            for(prop in newScores[jid])
            {
               if(scores[jid][prop] == null)
               {
                  scores[jid][prop] = newScores[jid][prop];
               }
               else
               {
                  scores[jid][prop] = scores[jid][prop] + newScores[jid][prop];
               }
            }
         }
         for(jid in scores)
         {
            if(!(_match.approvedPlayerJids.indexOf(jid) >= 0 || _match.host.playerJid == jid))
            {
               delete scores[jid];
            }
         }
         _match.sendSubject();
         _match.updateScores();
         _match.sendMatchEvent(MatchDataEvent.ROUND_RECORDED);
         submitEvent2 = new ArcadeEvent(ArcadeEvent.SUBMIT_ROUND_RESULTS,true);
         submitEvent2.roundResults = results;
         StageReference.stage.dispatchEvent(submitEvent2);
      }
      
      protected function parseScoresFromRoundResults(results:RoundResults) : *
      {
         var score:Object = null;
         var p:GamenetPlayerData = null;
         var obj:* = undefined;
         var s:Object = {};
         for each(score in results.list)
         {
            p = score.player;
            obj = {"Rounds":1};
            if(score.position == 1)
            {
               obj.Wins = 1;
            }
            s[p.playerJid] = obj;
         }
         return s;
      }
      
      protected function onMatchStart(event:MatchDataEvent) : void
      {
         this._roundRecorded = false;
      }
      
      protected function onMatchEnd(event:MatchDataEvent) : void
      {
         _match.groomApprovedLists();
         _match.fillPlayersWithSpectators();
      }
      
      protected function onRoomCollectionChange(event:org.igniterealtime.xiff.collections.events.CollectionEvent) : void
      {
         var player:PlayerData = null;
         var roomOccupant:RoomOccupant = null;
         var occupantJID:UnescapedJID = null;
         var jidNode:String = null;
         var index:int = 0;
         var changeSubject:Boolean = false;
         if(event.kind == CollectionEventKind.REMOVE)
         {
            for each(roomOccupant in event.items)
            {
               if(roomOccupant.jid)
               {
                  occupantJID = DataUtil.normalizeJID(roomOccupant.jid);
               }
               if(occupantJID)
               {
                  jidNode = occupantJID.node;
               }
               index = -1;
               if(jidNode)
               {
                  index = _match.approvedPlayerJids.indexOf(jidNode);
               }
               if(index > -1)
               {
                  _match.approvedPlayerJids.splice(index,1);
                  changeSubject = true;
               }
               index = -1;
               if(jidNode)
               {
                  index = _match.spectatorJids.indexOf(jidNode);
               }
               if(index > -1)
               {
                  _match.spectatorJids.splice(index,1);
                  changeSubject = true;
               }
            }
            _match.numLeaves++;
            _match.invalidatePlayersCollection();
         }
         if(changeSubject)
         {
            _match.sendSubject();
         }
      }
      
      protected function onRequestKickPlayer(event:MatchDataEvent) : void
      {
         if(event.data.kick)
         {
            _match.hostKickPlayer(event.data.kick,"You should find a different match. Try clicking PLAY NOW.");
         }
      }
      
      protected function onRequestTimeSync(event:MatchDataEvent) : void
      {
         var t:Number = _match.gamenetManager.serverNowTime;
         _logger.log("TimeSync request heard");
         _match.sendMatchEvent(MatchDataEvent.TIMESYNC_RESPONSE,{
            "time":t,
            "hostPing":AppComponents.gamenetManager.currentPlayer.pingTime
         },event.sender);
         _logger.log("Sending time:",t,new Date(t).toString(),new Date(t).milliseconds);
      }
      
      protected function isPlayerKickedOrBlocked(jid:String) : Boolean
      {
         var tPlayer:PlayerData = null;
         var roomOccupant:RoomOccupant = null;
         var p:PlayerData = null;
         for(var i:int = 0; i < _match.xmppRoom.length; i++)
         {
            roomOccupant = _match.xmppRoom.getItemAt(i) as RoomOccupant;
            p = _match.createPlayerDataForParticipant(roomOccupant);
            if(p && p.playerJid == jid)
            {
               tPlayer = p;
               break;
            }
         }
         var kickedProfileIndex:int = -1;
         var kickedGuestIndex:int = -1;
         if(tPlayer)
         {
            if(tPlayer.profileId)
            {
               kickedProfileIndex = _match.kickedProfiles.indexOf(tPlayer.profileId);
            }
            if(tPlayer.guestId)
            {
               kickedGuestIndex = _match.kickedGuests.indexOf(tPlayer.guestId);
            }
         }
         if(kickedProfileIndex >= 0)
         {
            return true;
         }
         if(kickedGuestIndex >= 0)
         {
            return true;
         }
         return false;
      }
      
      protected function onRequestRosterPosition(event:MatchDataEvent) : void
      {
         _logger.info("Received roster request from",event.sender,"Match open: ",_match.open,"Players: ",_match.approvedPlayerJids);
         var now:Number = AppComponents.gamenetManager.serverNowTime;
         if(_match.approvedPlayerJids.length < _match.maxPlayers && _match.open && !this.isPlayerKickedOrBlocked(event.sender))
         {
            if(_match.approvedPlayerJids.indexOf(event.sender) < 0)
            {
               _match.approvedPlayerJids.push(event.sender);
               _logger.info("Allowing player",event.sender,"into match");
            }
            _match.invalidatePlayersCollection();
            _match.sendSubject();
         }
         else if(!_match.open && _match.predictedOpenTime > 0 && !this.isPlayerKickedOrBlocked(event.sender) && _match.approvedPlayerJids.length + _match.spectatorJids.length < _match.maxPlayers)
         {
            if(_match.spectatorJids.indexOf(event.sender) < 0)
            {
               _match.spectatorJids.push(event.sender);
               _logger.info("Allowing player",event.sender,"into match");
            }
            _match.invalidatePlayersCollection();
            _match.sendSubject();
         }
         else
         {
            _logger.info("Declining player",event.sender);
            _match.sendMatchEvent(MatchDataEvent.ROSTER_REQUEST_DECLINED,{},event.sender);
         }
      }
      
      protected function onRequestSpectatorPosition(event:MatchDataEvent) : void
      {
         _logger.info("Received spectator request from",event.sender,"Match open: ",_match.open,"Players: ",_match.spectatorJids);
         if(_match.spectatorJids.length < 10 && !this.isPlayerKickedOrBlocked(event.sender))
         {
            if(_match.spectatorJids.indexOf(event.sender) < 0)
            {
               _match.spectatorJids.push(event.sender);
               _logger.info("Allowing player",event.sender,"to spectate");
            }
            _match.invalidatePlayersCollection();
            _match.sendSubject();
         }
         else
         {
            _logger.info("Declining  spectator",event.sender);
            _match.sendMatchEvent(MatchDataEvent.SPECTATOR_REQUEST_DECLINED,{},event.sender);
         }
      }
   }
}
