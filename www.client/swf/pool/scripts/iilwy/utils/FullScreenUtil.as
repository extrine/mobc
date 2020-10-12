package iilwy.utils
{
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FullScreenEvent;
   
   public class FullScreenUtil extends EventDispatcher
   {
      
      private static var _instance:FullScreenUtil = new FullScreenUtil();
      
      public static const FULL_SCREEN:String = "FULL_SCREEN";
      
      public static const NORMAL:String = "NORMAL";
      
      private static var _fullScreenCapable:Boolean = true;
      
      private static var _stageRef:Object;
      
      private static var _screenState:String = NORMAL;
       
      
      public function FullScreenUtil()
      {
         super();
         if(_instance)
         {
            throw new Error("Singleton and can only be accessed through Singleton.instance.doStuff");
         }
      }
      
      public static function goFullScreen() : void
      {
         try
         {
            if(_stageRef.displayState != StageDisplayState.FULL_SCREEN)
            {
               _stageRef.displayState = StageDisplayState.FULL_SCREEN;
            }
         }
         catch(err:Error)
         {
            trace("Not full screen Capable!");
            _fullScreenCapable = false;
         }
      }
      
      public static function goNormal() : void
      {
         try
         {
            _stageRef.displayState = StageDisplayState.NORMAL;
         }
         catch(err:Error)
         {
            _fullScreenCapable = false;
         }
      }
      
      public static function set stageReference(stageRef:Object) : void
      {
         _stageRef = stageRef;
         try
         {
            _stageRef.addEventListener(FullScreenEvent.FULL_SCREEN,onDisplayStateChanged);
         }
         catch(err:Error)
         {
            _fullScreenCapable = false;
         }
      }
      
      private static function onDisplayStateChanged(evt:Event) : void
      {
         var fsEvent:FullScreenEvent = evt as FullScreenEvent;
         if(fsEvent.fullScreen)
         {
            _screenState = FULL_SCREEN;
            _instance.dispatchEvent(new Event(FULL_SCREEN));
         }
         else
         {
            _screenState = NORMAL;
            _instance.dispatchEvent(new Event(NORMAL));
         }
      }
      
      public static function get fullScreenCapable() : Boolean
      {
         return _fullScreenCapable;
      }
      
      public static function get screenState() : String
      {
         return _screenState;
      }
      
      public static function destroyInstance() : void
      {
         _instance = null;
      }
      
      public static function get instance() : FullScreenUtil
      {
         return _instance;
      }
   }
}
