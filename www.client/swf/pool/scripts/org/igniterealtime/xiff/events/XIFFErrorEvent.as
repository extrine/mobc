package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.Extension;
   
   public class XIFFErrorEvent extends Event
   {
      
      public static const XIFF_ERROR:String = "error";
       
      
      private var _errorCode:int;
      
      private var _errorCondition:String;
      
      private var _errorExt:Extension;
      
      private var _errorMessage:String;
      
      private var _errorType:String;
      
      public function XIFFErrorEvent()
      {
         super(XIFFErrorEvent.XIFF_ERROR,false,false);
      }
      
      override public function clone() : Event
      {
         var event:XIFFErrorEvent = new XIFFErrorEvent();
         event.errorCondition = this._errorCondition;
         event.errorMessage = this._errorMessage;
         event.errorType = this._errorType;
         event.errorCode = this._errorCode;
         event.errorExt = this._errorExt;
         return event;
      }
      
      public function get errorCode() : int
      {
         return this._errorCode;
      }
      
      public function set errorCode(value:int) : void
      {
         this._errorCode = value;
      }
      
      public function get errorCondition() : String
      {
         return this._errorCondition;
      }
      
      public function set errorCondition(value:String) : void
      {
         this._errorCondition = value;
      }
      
      public function get errorExt() : Extension
      {
         return this._errorExt;
      }
      
      public function set errorExt(value:Extension) : void
      {
         this._errorExt = value;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
      
      public function set errorMessage(value:String) : void
      {
         this._errorMessage = value;
      }
      
      public function get errorType() : String
      {
         return this._errorType;
      }
      
      public function set errorType(value:String) : void
      {
         this._errorType = value;
      }
      
      override public function toString() : String
      {
         return "[XIFFErrorEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
