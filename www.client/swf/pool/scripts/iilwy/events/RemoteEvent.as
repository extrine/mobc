package iilwy.events
{
   import flash.events.Event;
   
   public class RemoteEvent extends DataEvent
   {
      
      public static const QUEUED_EVENTS:String = "iilwy.events.RemoteEvent.QUEUED_EVENTS";
      
      public static const RECEIVE_NOTIFICATION:String = "iilwy.events.RemoteEvent.RECEIVE_NOTIFICATION";
      
      public static const NEW_BET:String = "iilwy.events.RemoteEvent.NEW_BET";
      
      public static const NEW_BID:String = "iilwy.events.RemoteEvent.NEW_BID";
      
      public static const POINTS_CHANGED:String = "iilwy.events.RemoteEvent.POINTS_CHANGED";
      
      public static const CONTACT_LOGS_IN:String = "iilwy.events.RemoteEvent.CONTACT_LOGS_IN";
      
      public static const CONTACT_LOGS_OUT:String = "iilwy.events.RemoteEvent.CONTACT_LOGS_OUT";
      
      public static const CONTACT_LOGS_OUT_FROM_IDLE:String = "iilwy.events.RemoteEvent.CONTACT_LOGS_OUT_FROM_IDLE";
      
      public static const CONTACT_STATUS_CHANGES:String = "iilwy.events.RemoteEvent.CONTACT_STATUS_CHANGES";
      
      public static const NEW_CONTACT_ADDED:String = "iilwy.events.RemoteEvent.NEW_CONTACT_ADDED";
      
      public static const NEW_CONTACT_REQUEST:String = "iilwy.events.RemoteEvent.NEW_CONTACT_REQUEST";
      
      public static const NEW_PHOTO_UPLOADED:String = "iilwy.events.RemoteEvent.NEW_PHOTO_UPLOADED";
      
      public static const BALANCE_CHANGED:String = "iilwy.events.RemoteEvent.BALANCE_CHANGED";
      
      public static const BET_LOST:String = "iilwy.events.RemoteEvent.BET_LOST";
      
      public static const BET_WON:String = "iilwy.events.RemoteEvent.BET_WON";
      
      public static const EARNED_EXPERIENCE:String = "iilwy.events.RemoteEvent.EARNED_EXPERIENCE";
      
      public static const EARNED_GAME_EXPERIENCE:String = "iilwy.events.RemoteEvent.EARNED_GAME_EXPERIENCE";
      
      public static const GAME_LEVEL_UP:String = "iilwy.events.RemoteEvent.GAME_LEVEL_UP";
      
      public static const LEVEL_UP:String = "iilwy.events.RemoteEvent.LEVEL_UP";
      
      public static const MEDAL_RECEIVED:String = "iilwy.events.RemoteEvent.MEDAL_RECEIVED";
      
      public static const SECONDARY_FRIEND_CREATE:String = "iilwy.events.RemoteEvent.SECONDARY_FRIEND_CREATE";
      
      public static const SECONDARY_FRIEND_REMOVE:String = "iilwy.events.RemoteEvent.SECONDARY_FRIEND_REMOVE";
      
      public static const USER_BANNED:String = "iilwy.events.RemoteEvent.USER_BANNED";
      
      public static const USER_REPORTED:String = "iilwy.events.RemoteEvent.USER_REPORTED";
      
      public static const VERSION_UPDATED:String = "iilwy.events.RemoteEvent.VERSION_UPDATED";
       
      
      public var queuedEvents:Array;
      
      public function RemoteEvent(type:String, data:* = null)
      {
         this.queuedEvents = [];
         super(type,true,true,data);
      }
      
      override public function clone() : Event
      {
         var remoteEvent:RemoteEvent = new RemoteEvent(type,data);
         remoteEvent.queuedEvents = this.queuedEvents.concat();
         return remoteEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("RemoteEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
