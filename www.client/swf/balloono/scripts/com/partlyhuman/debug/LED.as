package com.partlyhuman.debug
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LED extends Sprite
   {
       
      
      protected const ALPHA_ON:Number = 1;
      
      protected var timer:Timer;
      
      protected const ALPHA_OFF:Number = 0.2;
      
      public function LED(param1:uint = 4290559, param2:Number = 4)
      {
         super();
         graphics.beginFill(param1,1);
         graphics.drawCircle(0,0,param2);
         graphics.endFill();
         this.timer = new Timer(0,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.turnOff();
      }
      
      public function turnOff() : void
      {
         alpha = this.ALPHA_OFF;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         this.turnOff();
      }
      
      public function get isOn() : Boolean
      {
         return alpha == this.ALPHA_ON;
      }
      
      public function turnOn() : void
      {
         alpha = this.ALPHA_ON;
      }
      
      public function flash(param1:Number = 50) : void
      {
         this.timer.reset();
         this.timer.delay = param1;
         this.turnOn();
         this.timer.start();
      }
   }
}
