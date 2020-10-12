package iilwygames.baloono.graphics
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.core.IGameStoppable;
   
   public class FramerateMonitor extends EventDispatcher implements IGameStoppable
   {
      
      public static var LOW_FRAMERATE:Number = 30;
      
      public static var AVERAGE_FRAMES:int = 20;
      
      public static var CRITICAL_FRAMERATE:Number = 10;
       
      
      protected var frameCount:int = 0;
      
      protected var samples:Array;
      
      protected var startSamplesLeft:int;
      
      protected var i:int;
      
      protected var t:int;
      
      protected var frameDispatcher:Sprite;
      
      protected var average:Number;
      
      public function FramerateMonitor(param1:Sprite)
      {
         super();
         this.frameDispatcher = param1;
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_STOP,this.gameStop,false,0,true);
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_START,this.gameStart,false,0,true);
      }
      
      public function gameStop(param1:CoreGameEvent) : void
      {
         this.frameDispatcher.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.frameCount = 0;
      }
      
      public function get framerate() : Number
      {
         return this.average;
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         this.frameCount++;
         if(this.frameCount % 15 == 0)
         {
            this.average = this.frameCount / (_loc2_ - this.t) * 1000;
            this.t = _loc2_;
            this.frameCount = 0;
         }
      }
      
      public function gameStart(param1:CoreGameEvent) : void
      {
         this.frameDispatcher.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.samples = new Array(AVERAGE_FRAMES);
         this.startSamplesLeft = AVERAGE_FRAMES;
         this.average = 0;
         this.t = getTimer();
         this.i = 0;
      }
   }
}
