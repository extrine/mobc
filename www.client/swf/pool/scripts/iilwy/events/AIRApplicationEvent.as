package iilwy.events
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class AIRApplicationEvent extends ResponderEvent
   {
      
      public static const GET_LOADER_CONTEXT:String = "iilwy.events.AIRApplicationEvent.GET_LOADER_CONTEXT";
      
      public static const OPEN_FULL_SCREEN_INTERACTIVE:String = "iilwy.events.AIRApplicationEvent.OPEN_FULL_SCREEN_INTERACTIVE";
      
      public static const WRITEBYTES_APPLICATION_STORAGE_DIRECTORY_FILE:String = "iilwy.events.AIRApplicationEvent.WRITEBYTES_APPLICATION_STORAGE_DIRECTORY_FILE";
       
      
      public var filePath:String;
      
      public var fileData:ByteArray;
      
      public function AIRApplicationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var airApplicationEvent:AIRApplicationEvent = new AIRApplicationEvent(type,bubbles,cancelable);
         airApplicationEvent.filePath = this.filePath;
         airApplicationEvent.fileData = this.fileData;
         airApplicationEvent.responder = responder;
         return airApplicationEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("AIRApplicationEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
