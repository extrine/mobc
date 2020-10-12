package iilwy.factories.context
{
   import iilwy.model.dataobjects.chat.ChatUser;
   
   public class ChatUserContextActionFactory extends AbstractUserContextActionFactory
   {
       
      
      protected var chatUser:ChatUser;
      
      public function ChatUserContextActionFactory(chatUser:ChatUser)
      {
         this.chatUser = chatUser;
         super(chatUser.asProfileData());
      }
   }
}
