package iilwy.chat
{
   import com.facebook.graph.data.fql.user.FQLUser;
   import flash.utils.Dictionary;
   import iilwy.application.AppComponents;
   import iilwy.chat.xiff.auth.XFacebookPlatformExtended;
   import iilwy.chat.xiff.core.XMPPConnectionExtended;
   import iilwy.events.CollectionEvent;
   import iilwy.events.FBEvent;
   import iilwy.factories.ChatFactory;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   
   public class FBChatManager extends ChatManager
   {
       
      
      public function FBChatManager()
      {
         super();
         serverURL = "chat.facebook.com";
         policyPort = 5221;
         AppComponents.model.privateUser.facebook.friendList.onlineFriends.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOnlineFriendsChange);
         StageReference.stage.addEventListener(FBEvent.LOGGED_INTO_CHAT_SERVER,this.onLoggedIntoChatServer);
      }
      
      override protected function setupConnection() : void
      {
         _connection = new XMPPConnectionExtended();
         addConnectionListeners();
      }
      
      override protected function registerSASLMechanisms() : void
      {
         super.registerSASLMechanisms();
         XMPPConnection.registerSASLMechanism("X-FACEBOOK-PLATFORM",XFacebookPlatformExtended);
      }
      
      override protected function addLoginEvent(chatUser:ChatUser) : void
      {
      }
      
      override protected function onDisconnect(event:DisconnectionEvent) : void
      {
         cleanup();
         this.setupConnection();
         _roster.connection = _connection;
         dispatchEvent(event);
      }
      
      override protected function onXIFFError(event:XIFFErrorEvent) : void
      {
         super.onXIFFError(event);
      }
      
      override protected function onOutgoingData(event:OutgoingDataEvent) : void
      {
         super.onOutgoingData(event);
      }
      
      override protected function onIncomingData(event:IncomingDataEvent) : void
      {
         super.onIncomingData(event);
      }
      
      protected function onOnlineFriendsChange(event:CollectionEvent) : void
      {
         var fqlUser:FQLUser = null;
         var chatUser:ChatUser = null;
         var chatUserSource:Dictionary = new Dictionary();
         for each(fqlUser in AppComponents.model.privateUser.facebook.friendList.onlineFriends.source)
         {
            chatUser = ChatFactory.createChatUserFromFQLUser(fqlUser);
            chatUserSource[chatUser.jid.bareJID] = chatUser;
         }
         chatUserRoster.source = chatUserSource;
         onlineChatUserRoster.source = chatUserSource;
      }
      
      protected function onLoggedIntoChatServer(event:FBEvent) : void
      {
         chatUserRoster.source = new Dictionary();
         onlineChatUserRoster.source = new Dictionary();
      }
   }
}
