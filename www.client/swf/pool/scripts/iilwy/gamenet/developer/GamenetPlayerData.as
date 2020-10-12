package iilwy.gamenet.developer
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.utils.ChatUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class GamenetPlayerData extends EventDispatcher
   {
       
      
      public var playerJid:String;
      
      public var profilePhoto:String;
      
      public var profileName:String;
      
      public var profileFirstName:String;
      
      public var profileId:String;
      
      public var userId:int;
      
      public var facebookUID:Number;
      
      public var profileCatchPhrase:String;
      
      public var profileClanName:String;
      
      public var profileAge:String;
      
      public var profileLocation:String;
      
      public var gameRatings;
      
      public var activeProductData;
      
      public var gameLevels;
      
      public var premiumLevel:Number = 0;
      
      public var favoriteGameIDs:Array;
      
      public function GamenetPlayerData()
      {
         super();
      }
      
      public function get chatUserJID() : UnescapedJID
      {
         return ChatUtil.getJIDFromUserID(this.userId);
      }
      
      public function get isMe() : Boolean
      {
         return AppComponents.model.privateUser.isLoggedIn && AppComponents.model.privateUser.profile.id == this.profileId;
      }
      
      public function get isFriend() : Boolean
      {
         return !this.isMe && this.chatUserJID && (AppComponents.chatManager.isFriend(this.chatUserJID) || AppComponents.fbChatManager && AppComponents.fbChatManager.isFriend(this.chatUserJID));
      }
      
      public function get isOnlineFriend() : Boolean
      {
         return !this.isMe && this.chatUserJID && (AppComponents.chatManager.isOnlineFriend(this.chatUserJID) || AppComponents.fbChatManager && AppComponents.fbChatManager.isOnlineFriend(this.chatUserJID));
      }
      
      public function get displayName() : String
      {
         var name:String = Boolean(this.profileClanName)?this.profileName + "[" + this.profileClanName + "]":this.profileName;
         if((AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE || AppComponents.model.privateUser.facebook.connected) && this.profileFirstName)
         {
            name = this.profileFirstName;
         }
         return name;
      }
      
      public function equals(other:GamenetPlayerData) : Boolean
      {
         return this.playerJid == other.playerJid;
      }
   }
}
