package iilwy.model.dataobjects.user
{
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.DictionaryCollection;
   import iilwy.events.CollectionEvent;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.namespaces.omgpop_internal;
   
   use namespace omgpop_internal;
   
   public class FriendsData
   {
       
      
      private var _all:ArrayCollection;
      
      private var _online:ArrayCollection;
      
      private var _loaded:Boolean;
      
      public function FriendsData()
      {
         super();
         this._all = new ArrayCollection();
         this._online = new ArrayCollection();
      }
      
      public function clear() : void
      {
         this._loaded = false;
         if(AppComponents.chatManager)
         {
            if(AppComponents.chatManager.chatUserRoster)
            {
               AppComponents.chatManager.chatUserRoster.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChatUserRosterChange);
            }
            if(AppComponents.chatManager.onlineChatUserRoster)
            {
               AppComponents.chatManager.onlineChatUserRoster.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOnlineChatUserRosterChange);
            }
         }
         this.all.removeAll();
         this.online.removeAll();
      }
      
      public function get all() : ArrayCollection
      {
         return this._all;
      }
      
      public function get online() : ArrayCollection
      {
         return this._online;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get numFriends() : int
      {
         return this.all.length;
      }
      
      public function get numOnlineFriends() : int
      {
         return this.online.length;
      }
      
      public function isFriend(userID:int = 0, profileID:String = null, profileName:String = null) : Boolean
      {
         return this.getFriend(false,userID,profileID,profileName) != null;
      }
      
      public function isOnlineFriend(userID:int = 0, profileID:String = null, profileName:String = null) : Boolean
      {
         return this.getFriend(true,userID,profileID,profileName) != null;
      }
      
      public function getFriend(userID:int = 0, profileID:String = null, profileName:String = null) : ChatUser
      {
         return this.getFriend(false,userID,profileID,profileName);
      }
      
      omgpop_internal function getFriend(online:Boolean, userID:int = 0, profileID:String = null, profileName:String = null) : ChatUser
      {
         var friend:ChatUser = null;
         var chatUser:ChatUser = null;
         var property:String = null;
         var value:* = undefined;
         var collection:ArrayCollection = !!online?this.online:this.all;
         for(var i:int = 0; i < collection.length; i++)
         {
            chatUser = collection.getItemAt(i) as ChatUser;
            property = userID > 0?"userID":Boolean(profileID)?"profileID":Boolean(profileName)?"displayName":null;
            value = userID > 0?userID:Boolean(profileID)?profileID:Boolean(profileName)?profileName:null;
            if(property && value && chatUser[property] == value)
            {
               friend = chatUser;
               break;
            }
         }
         return friend;
      }
      
      omgpop_internal function init() : void
      {
         this.updateAllFriends();
         this.updateOnlineFriends();
         AppComponents.chatManager.chatUserRoster.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChatUserRosterChange);
         AppComponents.chatManager.onlineChatUserRoster.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOnlineChatUserRosterChange);
         this._loaded = true;
      }
      
      protected function updateAllFriends() : void
      {
         var source:Array = AppComponents.chatManager.chatUserRoster.toArray(DictionaryCollection.VALUE);
         this.all.source = source;
      }
      
      protected function updateOnlineFriends() : void
      {
         var source:Array = AppComponents.chatManager.onlineChatUserRoster.toArray(DictionaryCollection.VALUE);
         this.online.source = source;
      }
      
      private function onChatUserRosterChange(event:CollectionEvent) : void
      {
         this.updateAllFriends();
      }
      
      private function onOnlineChatUserRosterChange(event:CollectionEvent) : void
      {
         this.updateOnlineFriends();
      }
   }
}
