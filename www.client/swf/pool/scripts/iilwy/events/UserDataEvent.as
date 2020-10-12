package iilwy.events
{
   import flash.events.Event;
   
   public class UserDataEvent extends Event
   {
      
      public static const PRIVATE_ACTIVATED_RECRUITS_STATUS_DATA:String = "iilwy.events.UserRequestEvent.PRIVATE_ACTIVATED_RECRUITS_STATUS_DATA";
      
      public static const PRIVATE_ARCADE_STATS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_ARCADE_STATS_DATA";
      
      public static const PRIVATE_NUM_CONTACT_REQUESTS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_NUM_CONTACT_REQUESTS_DATA";
      
      public static const PRIVATE_CONTACT_REQUESTS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_CONTACT_REQUESTS_DATA";
      
      public static const PRIVATE_CONTACT_SUGGESTIONS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_CONTACT_SUGGESTIONS_DATA";
      
      public static const PRIVATE_CURRENT_BALANCE_DATA:String = "iilwy.events.UserRequestEvent.PRIVATE_CURRENT_BALANCE_DATA";
      
      public static const PRIVATE_FEED_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_FEED_DATA";
      
      public static const PRIVATE_OVERVIEW_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_OVERVIEW_DATA";
      
      public static const PRIVATE_PHOTO_EDITOR_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_PHOTO_EDITOR_DATA";
      
      public static const PRIVATE_PREMIUM_ITEMS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_PREMIUM_ITEMS_DATA";
      
      public static const PRIVATE_QUESTIONS_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_QUESTIONS_DATA";
      
      public static const PRIVATE_TRANSACTION_HISTORY_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_TRANSACTION_HISTORY_DATA";
      
      public static const PRIVATE_USER_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_USER_DATA";
      
      public static const PRIVATE_EARNED_EXPERIENCE_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_EARNED_EXPERIENCE_DATA";
      
      public static const PRIVATE_LEVEL_CHANGED_DATA:String = "iilwy.events.UserDataEvent.PRIVATE_LEVEL_CHANGED_DATA";
      
      public static const PRIVATE_LOGIN_STATE_CHANGED:String = "iilwy.events.UserRequestEvent.PRIVATE_LOGIN_STATE_CHANGED";
      
      public static const PUBLIC_ACHIEVEMENTS_DATA:String = "iilwy.events.UserDataEvent.PUBLIC_ACHIEVEMENTS_DATA";
      
      public static const PUBLIC_ARCADE_STATS_DATA:String = "iilwy.events.UserDataEvent.PUBLIC_ARCADE_STATS_DATA";
      
      public static const PUBLIC_FEED_DATA:String = "iilwy.events.UserDataEvent.PUBLIC_FEED_DATA";
      
      public static const PUBLIC_OVERVIEW_DATA:String = "iilwy.events.UserDataEvent.PUBLIC_OVERVIEW_DATA";
      
      public static const PUBLIC_QUESTIONS_DATA:String = "iilwy.events.UserDataEvent.PUBLIC_QUESTIONS_DATA";
       
      
      public var amount:Number;
      
      public function UserDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new UserDataEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("UserDataEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
