package iilwy.events
{
   import flash.events.Event;
   import iilwy.ui.controls.ModuleLoader;
   
   public class ModuleManagerEvent extends Event
   {
      
      public static const MODULE_LOADED:String = "moduleLoaded";
      
      public static const MODULE_LOAD_ERROR:String = "moduleLoadError";
       
      
      public var module:ModuleLoader;
      
      public function ModuleManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var event:ModuleManagerEvent = new ModuleManagerEvent(type,bubbles,cancelable);
         return event;
      }
      
      override public function toString() : String
      {
         return formatToString("ModuleManagerEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
