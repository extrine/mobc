package iilwygames.baloono.graphics
{
   import flash.events.Event;
   
   public class FramerateAlertEvent extends Event
   {
      
      public static const FRAMERATE_CRITICAL:String = "framerateCriticalAlert";
      
      public static const FRAMERATE_LOW:String = "framerateLowAlert";
       
      
      public function FramerateAlertEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
