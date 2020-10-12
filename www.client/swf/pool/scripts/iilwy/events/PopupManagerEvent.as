package iilwy.events
{
   import flash.events.Event;
   
   public class PopupManagerEvent extends Event
   {
      
      public static const DIALOG_ADDED:String = "iilwy.events.PopupManagerEvent.DIALOG_ADDED";
      
      public static const DIALOG_REMOVED:String = "iilwy.events.PopupManagerEvent.DIALOG_REMOVED";
      
      public static const FLOATING_ADDED:String = "iilwy.events.PopupManagerEvent.FLOATING_ADDED";
      
      public static const FLOATING_REMOVED:String = "iilwy.events.PopupManagerEvent.FLOATING_REMOVED";
       
      
      public function PopupManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
