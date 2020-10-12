package iilwy.gamenet.events
{
   import flash.events.Event;
   
   public class XMPPDataEvent extends Event
   {
      
      public static var INCOMING_DATA:String = "incomingData";
      
      public static var OUTGOING_DATA:String = "outgoingData";
       
      
      private var _data;
      
      public function XMPPDataEvent(type:String)
      {
         super(type,false,false);
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(x:*) : void
      {
         this._data = x;
      }
   }
}
