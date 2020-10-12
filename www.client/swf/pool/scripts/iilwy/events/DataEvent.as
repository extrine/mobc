package iilwy.events
{
   import flash.events.Event;
   
   public class DataEvent extends Event
   {
       
      
      private var _data;
      
      public function DataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
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
      
      override public function clone() : Event
      {
         var dataEvent:DataEvent = new DataEvent(type,bubbles,cancelable,this.data);
         return dataEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("DataEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
