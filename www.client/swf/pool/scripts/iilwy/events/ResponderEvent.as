package iilwy.events
{
   import flash.events.Event;
   import iilwy.utils.Responder;
   
   public class ResponderEvent extends Event implements IResponderEvent
   {
       
      
      private var _responder:Responder;
      
      public function ResponderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
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
         var responderEvent:ResponderEvent = new ResponderEvent(type,bubbles,cancelable);
         responderEvent.responder = this.responder;
         return responderEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ResponderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
