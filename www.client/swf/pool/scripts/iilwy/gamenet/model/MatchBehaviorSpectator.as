package iilwy.gamenet.model
{
   import iilwy.application.AppComponents;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.events.RoomDataEvent;
   import iilwy.gamenet.utils.PlayerRoles;
   
   public class MatchBehaviorSpectator extends MatchBehaviorPlayer
   {
       
      
      public function MatchBehaviorSpectator()
      {
         super();
      }
      
      override protected function requestPosition() : void
      {
         addMatchListener(MatchDataEvent.SPECTATOR_REQUEST_DECLINED,this.onSpectatorRequestDeclined);
         addMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedInJoin);
         _match.sendMatchEvent(MatchDataEvent.REQUEST_SPECTATOR_POSITION,null,_match.host.playerJid);
      }
      
      protected function onSpectatorRequestDeclined(event:MatchDataEvent) : void
      {
         removeMatchListener(MatchDataEvent.SPECTATOR_REQUEST_DECLINED,this.onSpectatorRequestDeclined);
         removeMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedInJoin);
         _logger.log("Spectator request declined");
         var evt:MatchDataEvent = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_AS_SPECTATOR_FAIL);
         _match.dispatchEvent(evt);
      }
      
      override protected function onSubjectChangedInJoin(event:RoomDataEvent) : void
      {
         var evt:MatchDataEvent = null;
         _logger.log("Subject changed");
         if(_match.spectatorJids.indexOf(_match.gamenetManager.currentPlayer.playerJid) > -1)
         {
            removeMatchListener(MatchDataEvent.SPECTATOR_REQUEST_DECLINED,this.onSpectatorRequestDeclined);
            removeMatchListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChangedInJoin);
            _logger.log("Player approved");
            evt = new MatchDataEvent(MatchDataEvent.MATCH_JOIN_AS_SPECTATOR);
            _match.dispatchEvent(evt);
            _joinTimer.stop();
            this.registerInGameEvents();
            _match.sendMatchEvent(MatchDataEvent.REQUEST_SPECTATOR_TO_PLAYER);
         }
      }
      
      override public function registerInGameEvents() : void
      {
         addMatchListener(MatchDataEvent.MATCH_START,onMatchStart);
         addMatchListener(MatchDataEvent.MATCH_END,onMatchEnd);
         addMatchListener(MatchDataEvent.HOST_LEFT,onHostLeft);
         addMatchListener(MatchDataEvent.ROUND_RECORDED,onHostRoundRecorded);
         addMatchListener(MatchDataEvent.SPECTATOR_TO_PLAYER,this.onSpectatorToPlayer);
      }
      
      protected function onSpectatorToPlayer(event:MatchDataEvent) : void
      {
         try
         {
            _match.sendNotification(AppComponents.gamenetManager.currentPlayer.profileName + " is now playing.");
         }
         catch(e:Error)
         {
         }
         try
         {
            _match.assumeNewRole(PlayerRoles.PLAYER);
         }
         catch(e:Error)
         {
            AppComponents.gamenetManager.disconnect();
            AppComponents.alertManager.showError("Error becoming player");
         }
         requestEnhancedTimeSync();
      }
      
      override public function recordRound(results:RoundResults) : void
      {
      }
   }
}
