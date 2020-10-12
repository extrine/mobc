package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   
   public class InviteEvent extends Event
   {
      
      public static const INVITED:String = "invited";
       
      
      private var _data:Message;
      
      private var _from:UnescapedJID;
      
      private var _reason:String;
      
      private var _room:Room;
      
      public function InviteEvent()
      {
         super(INVITED);
      }
      
      override public function clone() : Event
      {
         var event:InviteEvent = new InviteEvent();
         event.from = this._from;
         event.reason = this._reason;
         event.room = this._room;
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
      
      public function get from() : UnescapedJID
      {
         return this._from;
      }
      
      public function set from(value:UnescapedJID) : void
      {
         this._from = value;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
      
      public function set reason(value:String) : void
      {
         this._reason = value;
      }
      
      public function get room() : Room
      {
         return this._room;
      }
      
      public function set room(value:Room) : void
      {
         this._room = value;
      }
      
      override public function toString() : String
      {
         return "[InviteEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
