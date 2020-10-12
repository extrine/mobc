package iilwygames.pool.events
{
   import flash.events.Event;
   
   public class ResourceManagerEvent extends Event
   {
      
      public static const ASSETS_READY:String = "assets_loaded";
       
      
      public function ResourceManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
