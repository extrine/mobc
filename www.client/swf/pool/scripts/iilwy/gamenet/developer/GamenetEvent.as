package iilwy.gamenet.developer
{
   import flash.events.Event;
   
   public dynamic class GamenetEvent extends Event
   {
      
      public static const CHAT:String = "chat";
      
      public static const NOTIFICATION:String = "notification";
      
      public static const GAME_ACTION:String = "gameAction";
      
      public static const HOST_CHANGED:String = "hostChanged";
      
      public static const PLAYER_LEFT:String = "playerLeft";
       
      
      public var sender:String;
      
      public var recipient:String;
      
      public var data;
      
      public function GamenetEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
