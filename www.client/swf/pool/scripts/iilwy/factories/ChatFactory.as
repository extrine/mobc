package iilwy.factories
{
   import com.facebook.graph.data.fql.user.FQLUser;
   import iilwy.application.AppComponents;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.net.MediaProxy;
   import iilwy.utils.ChatUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class ChatFactory
   {
       
      
      public function ChatFactory()
      {
         super();
      }
      
      public static function createChatUserFromPrivateUserData() : ChatUser
      {
         var privateUserData:PrivateUserData = AppComponents.model.privateUser;
         var chatUser:ChatUser = createChatUserFromProfileData(privateUserData.profile);
         if(chatUser.jid)
         {
            chatUser.credentials.username = chatUser.jid.node;
         }
         chatUser.credentials.password = privateUserData.chatUserPassword;
         return chatUser;
      }
      
      public static function createChatUserFromPrivateFacebookData() : ChatUser
      {
         var privateUserData:PrivateUserData = AppComponents.model.privateUser;
         var chatUser:ChatUser = createChatUserFromProfileData(privateUserData.profile);
         chatUser.jid = ChatUtil.normalizeJID(new UnescapedJID("u" + privateUserData.facebook.session.uid + "@chat.facebook.com"),AppComponents.fbChatManager);
         if(chatUser.jid)
         {
            chatUser.credentials.username = chatUser.jid.node;
         }
         return chatUser;
      }
      
      public static function createChatUserFromFQLUser(fqlUser:FQLUser) : ChatUser
      {
         var jid:UnescapedJID = new UnescapedJID("-" + fqlUser.uid.toString() + "@chat.facebook.com/xiff");
         var chatUser:ChatUser = new ChatUser(jid);
         chatUser.displayName = fqlUser.name;
         chatUser.firstName = fqlUser.first_name;
         chatUser.photoURL = fqlUser.pic_square_with_logo;
         chatUser.status = "Online";
         return chatUser;
      }
      
      public static function createChatUserFromProfileData(profileData:ProfileData) : ChatUser
      {
         var chatUser:ChatUser = new ChatUser(profileData.chatUserJID);
         chatUser.userID = profileData.userId;
         chatUser.profileID = profileData.id;
         chatUser.displayName = profileData.profile_name;
         chatUser.firstName = profileData.firstName;
         chatUser.photoURL = MediaProxy.url(profileData.photo_url,MediaProxy.SIZE_TINY_THUMB);
         chatUser.status = profileData.status;
         chatUser.gender = profileData.gender;
         chatUser.experience = profileData.experience;
         chatUser.clanName = profileData.clan_name;
         chatUser.premiumLevel = profileData.premiumLevel;
         return chatUser;
      }
      
      public static function createChatRoomsFromIndex(index:Array) : Array
      {
         var item:Object = null;
         var chatRoom:ChatRoom = null;
         var pattern:RegExp = null;
         var result:Array = null;
         var name:String = null;
         var count:int = 0;
         var chatRoomArray:Array = [];
         for each(item in index)
         {
            chatRoom = new ChatRoom();
            if(item.jid)
            {
               pattern = /(.+)(?:\s\((\d+)\)$)/g;
               result = pattern.exec(String(item.name));
               name = result && result.length > 0?result[1]:String(item.name);
               count = result && result.length > 1?int(result[2]):int(0);
               if(name == String(item.jid).split("@")[0])
               {
                  continue;
               }
               chatRoom.room.roomJID = new UnescapedJID(item.jid);
               chatRoom.displayName = name;
               chatRoom.numOccupants = count;
            }
            else
            {
               chatRoom.jidNode = item.name;
               chatRoom.displayName = item.display_name;
               chatRoom.isPrivate = item.is_private;
               chatRoom.numOccupants = item.participant_count;
            }
            chatRoomArray.push(chatRoom);
         }
         return chatRoomArray;
      }
   }
}
