package iilwy.ui.events
{
   import flash.events.Event;
   
   public class ConfirmationWindowEvent extends Event
   {
      
      public static var YES:String = "iilwy.ui.events.ConfirmationWindowEvent.YES";
      
      public static var NO:String = "iilwy.ui.events.ConfirmationWindowEvent.NO";
      
      public static var CLOSED:String = "iilwy.ui.events.ConfirmationWindowEvent.CLOSED";
       
      
      public var checkboxSelected:Boolean = false;
      
      public var automaticClose:Boolean = false;
      
      public var userInitiatedClose:Boolean = false;
      
      public function ConfirmationWindowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var confirmationWindowEvent:ConfirmationWindowEvent = new ConfirmationWindowEvent(type,bubbles,cancelable);
         return confirmationWindowEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ConfirmationWindowEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
