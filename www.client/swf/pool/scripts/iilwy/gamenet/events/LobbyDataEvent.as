package iilwy.gamenet.events
{
   import flash.events.Event;
   
   public class LobbyDataEvent extends Event
   {
      
      public static const NOTIFY_MATCH_CREATED:String = "lobbyData_notifyMatchCreated";
      
      public static const NOTIFY_MATCH_JOINED:String = "lobbyData_notifyMatchJoined";
       
      
      public var recipient:String;
      
      public var sender:String;
      
      public var data;
      
      public function LobbyDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
