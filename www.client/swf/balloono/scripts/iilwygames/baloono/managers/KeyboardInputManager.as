package iilwygames.baloono.managers
{
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   
   public class KeyboardInputManager implements IInputManager
   {
      
      protected static const HIGHEST_KEYCODE:uint = 256;
       
      
      protected var eventSource:EventDispatcher;
      
      public var pressedKeys:Array;
      
      public function KeyboardInputManager()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.pressedKeys = new Array(HIGHEST_KEYCODE);
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         this.pressedKeys[param1.keyCode] = true;
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         this.pressedKeys[param1.keyCode] = false;
      }
      
      public function assignEventSource(param1:EventDispatcher) : void
      {
         if(this.eventSource)
         {
            this.eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            this.eventSource.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         }
         this.eventSource = param1;
         this.eventSource.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.eventSource.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
   }
}
