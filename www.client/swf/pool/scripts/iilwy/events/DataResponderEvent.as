package iilwy.events
{
   import flash.events.Event;
   import iilwy.utils.Responder;
   
   public class DataResponderEvent extends Event implements IResponderEvent
   {
       
      
      private var _data;
      
      private var _responder:Responder;
      
      public function DataResponderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(value:*) : void
      {
         this._data = value;
      }
      
      public function get responder() : Responder
      {
         return this._responder;
      }
      
      public function set responder(value:Responder) : void
      {
         this._responder = value;
      }
      
      override public function clone() : Event
      {
         var dataResponderEvent:DataResponderEvent = new DataResponderEvent(type,bubbles,cancelable,this.data);
         dataResponderEvent.responder = this.responder;
         return dataResponderEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("DataResponderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
