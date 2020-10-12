package iilwygames.baloono.core
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   import iilwy.gamenet.developer.GamenetController;
   
   public class CoreGameEvent extends Event
   {
      
      public static const GAME_RESIZE:String = "gameResize";
      
      public static const GAME_START:String = "gameStart";
      
      public static const GAME_STOP:String = "gameStop";
       
      
      public var newSize:Rectangle;
      
      public var gamenetController:GamenetController;
      
      public function CoreGameEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
