package iilwy.model.dataobjects.chat
{
   public class ChatMessage
   {
       
      
      public var text:String;
      
      public var color:uint;
      
      public var user:ChatUser;
      
      private var _hexColor:String;
      
      public function ChatMessage(text:String = null, color:uint = 0)
      {
         super();
         this.text = text;
         this.color = color;
      }
      
      public function getHexColor(color:uint) : String
      {
         return color.toString(16);
      }
   }
}
