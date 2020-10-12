package iilwygames.pool.network
{
   public class MessageTypes
   {
      
      public static const MSG_START_GAME:int = 100;
      
      public static const MSG_END_GAME:int = 101;
      
      public static const MSG_EMPTY:int = 0;
      
      public static const MSG_MOUSE_UPDATE:int = 1;
      
      public static const MSG_MOUSE_DOWN:int = 2;
      
      public static const MSG_MOUSE_UP:int = 3;
      
      public static const MSG_BALLINHAND_DRAG:int = 4;
      
      public static const MSG_BALLINHAND_DROP:int = 5;
      
      public static const MSG_FORFEIT_TURN:int = 6;
      
      public static const MSG_SPECTATOR_REQUEST_GAMESTATE:int = 7;
      
      public static const MSG_HOST_RESPONSE_GAMESTATE:int = 8;
      
      public static const MSG_TURN_REQUEST:int = 9;
      
      public static const MSG_TURN_RESPONSE:int = 10;
       
      
      public function MessageTypes()
      {
         super();
      }
   }
}
