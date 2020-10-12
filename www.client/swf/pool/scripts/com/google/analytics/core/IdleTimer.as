package com.google.analytics.core
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.v4.Configuration;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class IdleTimer
   {
       
      
      private var _loop:Timer;
      
      private var _session:Timer;
      
      private var _debug:DebugConfiguration;
      
      private var _stage:Stage;
      
      private var _buffer:Buffer;
      
      private var _lastMove:int;
      
      private var _inactivity:Number;
      
      public function IdleTimer(config:Configuration, debug:DebugConfiguration, display:DisplayObject, buffer:Buffer)
      {
         super();
         var delay:Number = config.idleLoop;
         var inactivity:Number = config.idleTimeout;
         var sessionTimeout:Number = config.sessionTimeout;
         this._loop = new Timer(delay * 1000);
         this._session = new Timer(sessionTimeout * 1000,1);
         this._debug = debug;
         this._stage = display.stage;
         this._buffer = buffer;
         this._lastMove = getTimer();
         this._inactivity = inactivity * 1000;
         this._loop.addEventListener(TimerEvent.TIMER,this.checkForIdle);
         this._session.addEventListener(TimerEvent.TIMER_COMPLETE,this.endSession);
         this._stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this._debug.info("delay: " + delay + "sec , inactivity: " + inactivity + "sec, sessionTimeout: " + sessionTimeout,VisualDebugMode.geek);
         this._loop.start();
      }
      
      private function onMouseMove(event:MouseEvent) : void
      {
         this._lastMove = getTimer();
         if(this._session.running)
         {
            this._debug.info("session timer reset",VisualDebugMode.geek);
            this._session.reset();
         }
      }
      
      public function checkForIdle(event:TimerEvent) : void
      {
         var current:int = getTimer();
         if(current - this._lastMove >= this._inactivity)
         {
            if(!this._session.running)
            {
               this._debug.info("session timer start",VisualDebugMode.geek);
               this._session.start();
            }
         }
      }
      
      public function endSession(event:TimerEvent) : void
      {
         this._session.removeEventListener(TimerEvent.TIMER_COMPLETE,this.endSession);
         this._debug.info("session timer end session",VisualDebugMode.geek);
         this._session.reset();
         this._buffer.resetCurrentSession();
         this._debug.info(this._buffer.utmb.toString(),VisualDebugMode.geek);
         this._debug.info(this._buffer.utmc.toString(),VisualDebugMode.geek);
         this._session.addEventListener(TimerEvent.TIMER_COMPLETE,this.endSession);
      }
   }
}
