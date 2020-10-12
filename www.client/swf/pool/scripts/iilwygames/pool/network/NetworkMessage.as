package iilwygames.pool.network
{
   public class NetworkMessage
   {
       
      
      public var msgID:uint;
      
      public var data;
      
      public var mi:Number;
      
      public var fromPlayerJID:String;
      
      public var timeout:Number = 5.0;
      
      public function NetworkMessage(id:int)
      {
         super();
         this.mi = 0;
         this.msgID = id;
      }
   }
}
