package iilwy.gamenet.model
{
   public class ChatData
   {
      
      public static var TYPE_PROMO:String = "chatData.typePromo";
      
      public static var TYPE_WARNING:String = "chatData.typeWarning";
       
      
      public var message:String;
      
      public var player:PlayerData;
      
      public var type:String;
      
      public var muted:Boolean;
      
      public function ChatData()
      {
         super();
         this.player = new PlayerData();
      }
   }
}
