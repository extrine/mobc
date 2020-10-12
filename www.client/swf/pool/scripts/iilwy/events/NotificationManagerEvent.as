package iilwy.events
{
   import flash.events.Event;
   
   public class NotificationManagerEvent extends Event
   {
      
      public static const NOTIFCATION_ADDED:String = "iilwy.events.NotificationManagerEvent.NOTIFCATION_ADDED";
      
      public static const NOTIFICATION_REMOVED:String = "iilwy.events.NotificationManagerEvent.NOTIFICATION_REMOVED";
       
      
      public function NotificationManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
