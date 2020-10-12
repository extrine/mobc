package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class PresenceEvent extends Event
   {
      
      public static const PRESENCE:String = "presence";
       
      
      private var _data:Array;
      
      public function PresenceEvent()
      {
         super(PresenceEvent.PRESENCE,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var event:PresenceEvent = new PresenceEvent();
         event.data = this._data;
         return event;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(value:Array) : void
      {
         this._data = value;
      }
      
      override public function toString() : String
      {
         return "[PresenceEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
