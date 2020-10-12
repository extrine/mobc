package iilwy.gamenet.events
{
   import flash.events.Event;
   
   public class MatchDataEvent extends Event
   {
      
      public static const MATCH_START:String = "matchStart";
      
      public static const MATCH_END:String = "matchEnd";
      
      public static const MATCH_JOIN_AS_SPECTATOR:String = "matchJoinAsSpectator";
      
      public static const MATCH_JOIN_AS_SPECTATOR_FAIL:String = "matchJoinAsSpectatorFail";
      
      public static const MATCH_JOIN_AS_PLAYER:String = "matchJoinAsPlayer";
      
      public static const MATCH_JOIN_TIMEOUT:String = "matchJoinTimeout";
      
      public static const MATCH_JOIN_AS_PLAYER_FAIL:String = "matchJoinAsPlayerFail";
      
      public static const MATCH_CREATE:String = "matchCreate";
      
      public static const MATCH_CREATE_TIMEOUT:String = "matchCreateTimeout";
      
      public static const MATCH_ROOM_INITIALIZED:String = "matchRoomInitialized";
      
      public static const MATCH_ERROR:String = "matchError";
      
      public static const TIMESYNC_REQUEST:String = "syncRequest";
      
      public static const TIMESYNC_RESPONSE:String = "syncResponse";
      
      public static const REQUEST_SPECTATOR_POSITION:String = "spectatorRequest";
      
      public static const SPECTATOR_REQUEST_ACCEPTED:String = "spectatorRequestAccepted";
      
      public static const SPECTATOR_REQUEST_DECLINED:String = "spectatorRequestDeclined";
      
      public static const REQUEST_ROSTER_POSITION:String = "rosterRequest";
      
      public static const ROSTER_REQUEST_ACCEPTED:String = "rosterRequestAccepted";
      
      public static const ROSTER_REQUEST_DECLINED:String = "rosterRequestDeclined";
      
      public static const ROUND_RECORDED:String = "roundRecorded";
      
      public static const REQUEST_SPECTATOR_TO_PLAYER:String = "requestSpectatorToPlayer";
      
      public static const SPECTATOR_TO_PLAYER:String = "spectatorToPlayer";
      
      public static const PLAYER_TO_HOST:String = "playerToHost";
      
      public static const SETTINGS_CHANGED:String = "settingsChanged";
      
      public static const BET_CHANGED:String = "betChanged";
      
      public static const HOST_LEFT:String = "hostLeft";
      
      public static const HOST_CHANGED:String = "hostChanged";
      
      public static const PARTY_SWITCH_INITIATED:String = "partySwitchInitiated";
      
      public static const ISALIVE_REQUEST:String = "isaliveRequest";
      
      public static const ISALIVE_RESPONSE:String = "isaliveRequest";
      
      public static const FORCE_LEAVE:String = "forceLeave";
      
      public static const PING_TIME_INFORM:String = "pingInform";
      
      public static const KICK_PLAYER:String = "kickPlayer";
      
      public static const REQUEST_KICK_PLAYER:String = "requestKickPlayer";
      
      public static const READY_TIME_CHANGED:String = "hostModifyReadyTime";
      
      public static const TOYS_UPDATEMOUSE:String = "toys_updateMouse";
      
      public static const TOYS_UPDATEBALL:String = "toys_updateBall";
      
      public static const NOTIFY:String = "notify";
      
      public static const ALERT:String = "alert";
       
      
      public var recipient:String;
      
      public var sender:String;
      
      public var data;
      
      public function MatchDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
