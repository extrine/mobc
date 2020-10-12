package iilwy.display.core
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.Capabilities;
   import iilwy.ui.events.ContainerEvent;
   
   public final class WindowManager extends EventDispatcher
   {
      
      private static var instance:WindowManager;
       
      
      private var manager:IWindowManager;
      
      public function WindowManager(enforcer:SingletonEnforcer)
      {
         super();
      }
      
      public static function get width() : Number
      {
         return getInstance().manager.width;
      }
      
      public static function get height() : Number
      {
         return getInstance().manager.height;
      }
      
      public static function get environment() : String
      {
         return Capabilities.playerType == WindowManagerEnvironment.DESKTOP?WindowManagerEnvironment.DESKTOP:WindowManagerEnvironment.BROWSER;
      }
      
      public static function getInstance() : WindowManager
      {
         if(!instance)
         {
            instance = new WindowManager(new SingletonEnforcer());
         }
         return instance;
      }
      
      public static function init(managerClass:Class, applicationStage:Stage, target:Sprite) : void
      {
         var ManagerClassReference:Object = managerClass as Object;
         getInstance().manager = ManagerClassReference.init(applicationStage,target);
         getInstance().manager.addEventListener(Event.ACTIVATE,getInstance().onActivate);
         getInstance().manager.addEventListener(Event.RESIZE,getInstance().onResize);
         getInstance().manager.addEventListener(ContainerEvent.MAXIMIZE,getInstance().onMaximize);
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = true) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return getInstance().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
      
      public function get isMinimized() : Boolean
      {
         return this.manager.isMinimized;
      }
      
      private function onActivate(event:Event) : void
      {
      }
      
      private function onResize(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function onMaximize(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}
