package iilwy.gamenet.model
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import iilwy.application.AppComponents;
   import iilwy.events.CollectionEvent;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.events.RoomDataEvent;
   import iilwy.gamenet.utils.PlayerRoles;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.utils.TextUtil;
   
   public class MatchBehaviorPlayer extends MatchBehavior implements IMatchBehavior
   {
       
      
      protected var _joinTimer:Timer;
      
      private var _hostLeftTimer:Timer;
      
      protected var _roundRecorded:Boolean;
      
      protected var _timeSyncStartTime:uint;
      
      private var _timeSynceCounter:int;
      
      private var _synceTimeSamples:Array;
      
      private var _syncRepeat:int = 10;
      
      private var _timeBegunMultipleTimeSyncRequests:uint;
      
      public function MatchBehaviorPlayer()
      {
         this._synceTimeSamples = [];
         super();
         this._joinTimer = new Timer(10000,1);
         this._joinTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this._hostLeftTimer = new Timer(5000,1);
         this._hostLeftTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHostLeftTimeout);
         this._timeSynceCounter = 0;
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
         this._hostLeftTimer.stop();
         this._joinTimer.stop();
         _match = null;
      }
      
      protected function onLogPlayersChange(event:CollectionEvent) : void
      {
         _logger.log("Players  changed",event.kind);
      }
      
      protected function onLogSpectatorsChange(event:CollectionEvent) : void
      {
         _logger.log("Spectators changed",event.kind);
      }
      
      public function join(matchName:String, config:MatchListingData) : void
      {
         _logger.log("Attempting to joing match");
         addMatchListener(RoomDataEvent.ROOM_JOIN,this.onJoin);
         addMatchListener(RoomDataEvent.GENERIC_ERROR,this.onError);
         this._joinTimer.reset();
         this._joinTimer.start();
         this._timeSynceCounter = 0;
         this._synceTimeSamples.splice(0,this._synceTimeSamples.length);
      }
      
      protected function onTimeout(event:TimerEvent) : void
      {
         clearAllListeners();
         _logger.warn("Join match timeout");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_TIMEOUT);
         _match.dispatchEvent(evt);
      }
      
      protected function onError(event:Event) : void
      {
         clearAllListeners();
         _logger.error("Join match error");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_ERROR);
         _match.dispatchEvent(evt);
      }
      
      protected function onJoin(event:RoomDataEvent) : void
      {
         _logger.log("Joined match");
         removeMatchListener(RoomDataEvent.ROOM_JOIN,this.onJoin);
         removeMatchListener(RoomDataEvent.GENERIC_ERROR,this.onError);
         _logger.log("Attempting to get service info");
         addMatchListener(RoomDataEvent.SERVICE_INFO_SET,this.onGetServiceInfo);
         _match.getServiceInfo();
      }
      
      protected function onGetServiceInfo(event:RoomDataEvent) : void
      {
         _logger.log("Service info set");
         _logger.log("Attempting to sync time");
         addMatchListener(MatchDataEvent.TIMESYNC_RESPONSE,this.onInitialTimeSync);
         this.requestTimeSync();
      }
      
      protected function onInitialTimeSync(event:MatchDataEvent) : void
      {
         removeMatchListener(MatchDataEvent.TIMESYNC_RESPONSE,this.onInitialTimeSync);
         this.onTimeSync(event);
         _logger.log("Time sync attempt",this._timeSynceCounter);
         this.requestPosition();
      }
      
      protected function requestPosition() : void
      {
         addMatchListener(MatchDataEvent.ROSTER_REQUEST_DECLINED,this.onRosterRequestDeclined);
         addMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedInJoin);
         _match.sendMatchEvent(MatchDataEvent.REQUEST_ROSTER_POSITION,null,_match.host.playerJid);
      }
      
      protected function onRosterRequestDeclined(event:MatchDataEvent) : void
      {
         removeMatchListener(MatchDataEvent.ROSTER_REQUEST_DECLINED,this.onRosterRequestDeclined);
         removeMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedInJoin);
         _logger.log("Roster request declined");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_AS_PLAYER_FAIL);
         _match.dispatchEvent(evt);
      }
      
      protected function onSubjectChangedInJoin(event:RoomDataEvent) : void
      {
         var evt:MatchDataEvent = null;
         _logger.log("Subject changed");
         var allowed:Boolean = false;
         if(_match.approvedPlayerJids.indexOf(_match.gamenetManager.currentPlayer.playerJid) > -1)
         {
            _logger.log("Player approved");
            this._joinTimer.stop();
            clearAllListeners();
            this.registerInGameEvents();
            _match.pingSelf(1000);
            this.requestEnhancedTimeSync();
            evt = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_AS_PLAYER);
            _match.dispatchEvent(evt);
         }
         else if(_match.spectatorJids.indexOf(_match.gamenetManager.currentPlayer.playerJid) > -1)
         {
            _logger.log("Player approved as spectator guaranteed access");
            this._joinTimer.stop();
            clearAllListeners();
            evt = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_AS_SPECTATOR);
            _match.dispatchEvent(evt);
            _match.assumeNewRole(PlayerRoles.SPECTATOR);
         }
      }
      
      protected function requestTimeSync() : void
      {
         if(!_match)
         {
            return;
         }
         _match.sendMatchEvent(MatchDataEvent.TIMESYNC_REQUEST,null,_match.host.playerJid);
         this._timeSyncStartTime = getTimer();
      }
      
      protected function onTimeSync(event:MatchDataEvent) : void
      {
         this._timeSynceCounter++;
         var elapsed:uint = getTimer() - this._timeSyncStartTime;
         var newTime:uint = uint(event.data.time) + elapsed * 0.5;
         if(this._timeSynceCounter == 1)
         {
            _match.gamenetManager.serverNowTime = newTime;
            _match.gamenetManager.currentPlayer.pingTime = elapsed * 0.5;
         }
         var deltaTime:uint = uint(event.data.time) - getTimer() + elapsed * 0.5;
         this._synceTimeSamples.push(deltaTime);
         var date:Date = new Date(newTime);
         _logger.log("Test date",newTime,date.toString(),date.milliseconds);
         _logger.log("TimeSynced","original time was:",event.data.time,"ping time was:",elapsed);
         _logger.log("New time is",_match.gamenetManager.serverNowTime,new Date(_match.gamenetManager.serverNowTime).toString(),new Date(_match.gamenetManager.serverNowTime).milliseconds);
      }
      
      protected function requestEnhancedTimeSync() : void
      {
         this._syncRepeat = this._timeSynceCounter > 2?int(5):int(10);
         this._timeBegunMultipleTimeSyncRequests = getTimer();
         addMatchListener(MatchDataEvent.TIMESYNC_RESPONSE,this.onEnhancedTimeSync);
         this.requestTimeSync();
      }
      
      protected function onEnhancedTimeSync(event:MatchDataEvent) : void
      {
         this.onTimeSync(event);
         _logger.log("Time sync attempt",this._timeSynceCounter);
         if(this._timeSynceCounter >= this._syncRepeat || getTimer() - this._timeBegunMultipleTimeSyncRequests > 10000)
         {
            removeMatchListener(MatchDataEvent.TIMESYNC_RESPONSE,this.onEnhancedTimeSync);
            this.processTimeSyncSamples();
         }
         else
         {
            setTimeout(this.requestTimeSync,100);
         }
      }
      
      protected function processTimeSyncSamples() : void
      {
         var time:uint = 0;
         this._synceTimeSamples.sort(Array.NUMERIC);
         var length:uint = this._synceTimeSamples.length;
         var median:uint = this._synceTimeSamples[int(length / 2)];
         var accum:Number = 0;
         for(var i:int = 0; i < this._synceTimeSamples.length; i++)
         {
            time = this._synceTimeSamples[i];
            time = time - median;
            time = time * time;
            accum = accum + time;
         }
         accum = accum / length;
         var std_Dev:Number = Math.sqrt(accum);
         i = 0;
         while(i < this._synceTimeSamples.length)
         {
            time = this._synceTimeSamples[i];
            if(Math.abs(time - median) > std_Dev)
            {
               this._synceTimeSamples.splice(i,1);
            }
            else
            {
               i++;
            }
         }
         length = i = this._synceTimeSamples.length;
         i--;
         accum = 0;
         while(i > -1)
         {
            time = this._synceTimeSamples[i];
            accum = accum + time;
            i--;
         }
         _logger.log("Time sync samples",this._synceTimeSamples);
         var syncedTime:uint = uint(accum / length) + getTimer();
         _logger.log("Synced time: ",syncedTime);
         _match.gamenetManager.serverNowTime = syncedTime;
      }
      
      public function registerInGameEvents() : void
      {
         addMatchListener(MatchDataEvent.MATCH_START,this.onMatchStart);
         addMatchListener(MatchDataEvent.MATCH_END,this.onMatchEnd);
         addMatchListener(MatchDataEvent.HOST_LEFT,this.onHostLeft);
         addMatchListener(MatchDataEvent.ROUND_RECORDED,this.onHostRoundRecorded);
         addMatchListener(MatchDataEvent.KICK_PLAYER,this.onKicked);
      }
      
      protected function onMatchStart(event:MatchDataEvent) : void
      {
         _logger.log("Match Starting",",seed:",_match.randomSeed,",start time:",_match.startTime);
         this._roundRecorded = false;
      }
      
      protected function onMatchEnd(event:MatchDataEvent) : void
      {
         _logger.log("Match Ended");
         this.requestEnhancedTimeSync();
      }
      
      protected function onHostLeft(event:MatchDataEvent) : void
      {
         var myIndex:int = _match.approvedPlayerJids.indexOf(_match.gamenetManager.currentPlayer.playerJid);
         var prevPlayerJID:String = _match.approvedPlayerJids[myIndex - 1];
         _logger.log("The host left, my index in the players array is",myIndex,":",_match.approvedPlayerJids);
         if(prevPlayerJID == _match.host.playerJid)
         {
            _logger.log("I am next in line, lets try to become host");
            this.becomeHost();
         }
         else
         {
            _logger.log("I am not next in line, i will not try to become host");
            this._hostLeftTimer.reset();
            this._hostLeftTimer.start();
            addMatchListener(MatchDataEvent.HOST_CHANGED,this.onWaitingForHostToChange);
         }
      }
      
      protected function onHostRoundRecorded(event:MatchDataEvent) : void
      {
         _match.updateScores();
      }
      
      public function recordRound(results:RoundResults) : void
      {
         if(!this._roundRecorded)
         {
            this._roundRecorded = true;
         }
      }
      
      protected function onKicked(event:MatchDataEvent) : void
      {
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.FORCE_LEAVE);
         evt.data = event.data;
         _match.dispatchEvent(evt);
      }
      
      protected function becomeHost() : void
      {
         _match.groomApprovedLists();
         _match.description = this.overwriteMatchDescription(_match.description,_match.host,_match.gamenetManager.currentPlayer);
         _match.host = _match.gamenetManager.currentPlayer.clone();
         if(AppComponents.model.privateUser.profile.premiumLevel < PremiumLevels.STAR)
         {
            _match.clearPremiumSettings();
         }
         if(_match.approvedPlayerJids.length > 1)
         {
            _match.readyTime = _match.gamenetManager.serverNowTime + MatchData.READY_TIME_INITIAL;
         }
         else
         {
            _match.readyTime = -1;
         }
         _match.predictedOpenTime = 0;
         _match.sendSubject();
         addMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedBecomingHost);
      }
      
      private function overwriteMatchDescription(description:String, oldHost:PlayerData, newHost:PlayerData) : String
      {
         var descrip:String = null;
         var oname:String = null;
         var regex:RegExp = null;
         if(oldHost)
         {
            oname = oldHost.displayName;
         }
         if(oname)
         {
            regex = new RegExp(oname,"gi");
            descrip = description.replace(regex,newHost.displayName);
         }
         else
         {
            descrip = TextUtil.makePosessive(newHost.displayName) + " match";
         }
         return descrip;
      }
      
      protected function onSubjectChangedBecomingHost(event:Event) : void
      {
         _logger.log("Successfully became host");
         removeMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedBecomingHost);
         _match.invalidatePlayersCollection();
         _match.gamenetManager.gamenetController.playerRole = PlayerRoles.HOST;
         _match.gamenetManager.gamenetController.host = _match.host.clone();
         _match.gamenetManager.gamenetController.hostData = _match.host.clone();
         var gEvent:GamenetEvent = new GamenetEvent(GamenetEvent.HOST_CHANGED);
         _match.gamenetManager.gamenetController.dispatchEvent(gEvent);
         _match.sendMatchEvent(MatchDataEvent.HOST_CHANGED);
         _match.assumeNewRole(PlayerRoles.HOST);
      }
      
      protected function onWaitingForHostToChange(event:MatchDataEvent) : void
      {
         _logger.log("Someone else became host");
         removeMatchListener(MatchDataEvent.HOST_CHANGED,this.onWaitingForHostToChange);
         this._hostLeftTimer.stop();
         _match.gamenetManager.gamenetController.host = _match.host.clone();
         var gEvent:GamenetEvent = new GamenetEvent(GamenetEvent.HOST_CHANGED);
         _match.gamenetManager.gamenetController.dispatchEvent(gEvent);
      }
      
      protected function onHostLeftTimeout(event:TimerEvent) : void
      {
         _logger.log("No new host yet");
         removeMatchListener(MatchDataEvent.HOST_CHANGED,this.onWaitingForHostToChange);
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.FORCE_LEAVE);
         evt.data = {"reason":"The host left the match, and we were not able to find a new host"};
         _match.dispatchEvent(evt);
      }
   }
}
