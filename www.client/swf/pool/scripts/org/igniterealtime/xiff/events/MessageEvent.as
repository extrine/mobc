package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.Message;
   
   public class MessageEvent extends Event
   {
      
      public static const MESSAGE:String = "message";
       
      
      private var _data:Message;
      
      public function MessageEvent()
      {
         super(MessageEvent.MESSAGE,false,false);
      }
      
      override public function clone() : Event
      {
         var event:MessageEvent = new MessageEvent();
         event.data = this._data;
         return event;
      }
      
      public function get data() : Message
      {
         return this._data;
      }
      
      public function set data(value:Message) : void
      {
         this._data = value;
      }
      
      override public function toString() : String
      {
         return "[MessageEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
