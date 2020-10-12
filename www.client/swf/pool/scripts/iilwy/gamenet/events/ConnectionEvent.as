package iilwy.gamenet.events
{
   import flash.events.Event;
   
   public class ConnectionEvent extends Event
   {
      
      public static var CONNECTION_SUCCESS:String = "connectionSuccess";
      
      public static var DISCONNECTION:String = "disconnection";
      
      public static var LOGIN:String = "login";
      
      public static var CONNECTION_TIMEOUT:String = "connectionTimeout";
       
      
      public function ConnectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
