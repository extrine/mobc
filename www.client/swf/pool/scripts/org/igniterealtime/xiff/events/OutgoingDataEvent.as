package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class OutgoingDataEvent extends Event
   {
      
      public static const OUTGOING_DATA:String = "outgoingData";
       
      
      private var _data:ByteArray;
      
      public function OutgoingDataEvent()
      {
         super(OutgoingDataEvent.OUTGOING_DATA,false,false);
      }
      
      override public function clone() : Event
      {
         var event:OutgoingDataEvent = new OutgoingDataEvent();
         event.data = this._data;
         return event;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function set data(value:ByteArray) : void
      {
         this._data = value;
      }
      
      override public function toString() : String
      {
         return "[OutgoingDataEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
