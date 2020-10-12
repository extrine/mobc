package iilwy.events
{
   import flash.events.Event;
   
   public class AsyncEvent extends DataEvent
   {
      
      public static const SUCCESS:String = "iilwy.events.AsyncEvent.SUCCESS";
      
      public static const FAIL:String = "iilwy.events.AsyncEvent.FAIL";
      
      public static const TIMEOUT:String = "iilwy.events.AsyncEvent.TIMEOUT";
       
      
      public var errorInfo:String;
      
      public function AsyncEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var asyncEvent:AsyncEvent = new AsyncEvent(type,bubbles,cancelable);
         asyncEvent.data = data;
         asyncEvent.errorInfo = this.errorInfo;
         return asyncEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("AsyncEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
