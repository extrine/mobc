package iilwy.utils
{
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatManager;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class ChatUtil
   {
       
      
      public function ChatUtil()
      {
         super();
      }
      
      public static function getJIDFromUserID(userID:int) : UnescapedJID
      {
         if(userID <= 0)
         {
            return null;
         }
         return normalizeJID(new UnescapedJID(userID.toString() + "@chatfarm.omgpop.com"),AppComponents.chatManager);
      }
      
      public static function normalizeJID(jid:UnescapedJID, chatManager:ChatManager) : UnescapedJID
      {
         var node:String = jid.domain == chatManager.conferenceServer?jid.resource.indexOf("@") > -1?jid.resource.slice(0,jid.resource.indexOf("@")):jid.resource:jid.node;
         var domain:String = jid.domain == chatManager.conferenceServer?chatManager.serverURL:jid.domain;
         var resource:String = "/xiff";
         return new UnescapedJID(node + "@" + domain + resource);
      }
   }
}
