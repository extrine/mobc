package iilwy.display.core
{
   import flash.events.Event;
   
   public class PopupQueueItem
   {
       
      
      public var id:String;
      
      public var event:Event;
      
      public function PopupQueueItem(id:String, event:Event = null)
      {
         super();
         this.id = id;
         this.event = event;
      }
   }
}
