package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class IncomingDataEvent extends Event
   {
      
      public static const INCOMING_DATA:String = "incomingData";
       
      
      private var _data:ByteArray;
      
      public function IncomingDataEvent()
      {
         super(IncomingDataEvent.INCOMING_DATA,false,false);
      }
      
      override public function clone() : Event
      {
         var event:IncomingDataEvent = new IncomingDataEvent();
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
         return "[IncomingDataEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
