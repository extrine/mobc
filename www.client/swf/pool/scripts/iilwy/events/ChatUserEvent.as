package iilwy.events
{
   import flash.events.Event;
   import iilwy.model.dataobjects.chat.ChatUser;
   
   public class ChatUserEvent extends DataResponderEvent
   {
      
      public static const UPDATE:String = "iilwy.events.ChatUserEvent.UPDATE";
       
      
      public var chatUser:ChatUser;
      
      public function ChatUserEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         super(type,bubbles,cancelable,data);
      }
      
      override public function clone() : Event
      {
         var chatEvent:ChatUserEvent = new ChatUserEvent(type,bubbles,cancelable,data);
         chatEvent.responder = responder;
         chatEvent.chatUser = this.chatUser;
         return chatEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ChatUserEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
