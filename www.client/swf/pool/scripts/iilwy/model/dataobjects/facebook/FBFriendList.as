package iilwy.model.dataobjects.facebook
{
   import com.facebook.graph.data.ExtendedPermission;
   import com.facebook.graph.data.fql.user.FQLUser;
   import com.facebook.graph.data.fql.user.FQLUserField;
   import com.facebook.graph.data.fql.user.OnlinePresence;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.events.AsyncEvent;
   import iilwy.events.CollectionEvent;
   import iilwy.events.FBEvent;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   
   public class FBFriendList
   {
       
      
      public var allFriends:ArrayCollection;
      
      public var onlineFriends:ArrayCollection;
      
      public var appUserFriends:ArrayCollection;
      
      public var nonAppUserFriends:ArrayCollection;
      
      private var getFriendsResponder:Responder;
      
      private var onlineFriendsPollTimer:Timer;
      
      private var onlineFriendsPollStarted:Boolean;
      
      private var _loaded:Boolean;
      
      public function FBFriendList()
      {
         super();
         this.allFriends = new ArrayCollection();
         this.onlineFriends = new ArrayCollection();
         this.onlineFriends.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onOnlineFriendsChange);
         this.appUserFriends = new ArrayCollection();
         this.nonAppUserFriends = new ArrayCollection();
         this.onlineFriendsPollTimer = new Timer(30000,1);
         this.onlineFriendsPollTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPollTimer);
      }
      
      public function clear() : void
      {
         this._loaded = false;
         this.allFriends.removeAll();
         this.onlineFriends.removeAll();
         this.appUserFriends.removeAll();
         this.nonAppUserFriends.removeAll();
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get numFriends() : int
      {
         return this.allFriends.length;
      }
      
      public function get numOnlineFriends() : int
      {
         return this.onlineFriends.length;
      }
      
      public function get numAppUserFriends() : int
      {
         return this.appUserFriends.length;
      }
      
      public function get numNonAppUserFriends() : int
      {
         return this.nonAppUserFriends.length;
      }
      
      public function getFriendsByID(ids:Array) : Array
      {
         var id:* = undefined;
         var friendID:Number = NaN;
         var friend:FQLUser = null;
         var friends:Array = [];
         for each(id in ids)
         {
            friendID = Number(id);
            for each(friend in this.allFriends.source)
            {
               if(friend.uid == friendID)
               {
                  friends.push(friend);
                  break;
               }
            }
         }
         return friends;
      }
      
      public function getFriends() : void
      {
         if(!AppComponents.model.privateUser.facebook.connected)
         {
            return;
         }
         this.getFriendsResponder = new Responder();
         this.getFriendsResponder.setAsyncListeners(this.onGetFriendsSuccess,this.onGetFriendsFail);
         var getFriendsEvent:FBEvent = new FBEvent(FBEvent.GET_FRIENDS,true,true);
         getFriendsEvent.userColumns = [FQLUserField.UID,FQLUserField.NAME,FQLUserField.FIRST_NAME,FQLUserField.LAST_NAME,FQLUserField.PIC_SQUARE,FQLUserField.PIC_SQUARE_WITH_LOGO,FQLUserField.IS_APP_USER,FQLUserField.ONLINE_PRESENCE];
         getFriendsEvent.responder = this.getFriendsResponder;
         StageReference.stage.dispatchEvent(getFriendsEvent);
      }
      
      private function getOnlineFriends() : void
      {
         if(!AppComponents.model.privateUser.facebook.connected)
         {
            return;
         }
         this.getFriendsResponder = new Responder();
         this.getFriendsResponder.setAsyncListeners(this.onGetOnlineFriendsSuccess,this.onGetOnlineFriendsFail);
         var getFriendsEvent:FBEvent = new FBEvent(FBEvent.GET_FRIENDS,true,true);
         getFriendsEvent.userColumns = [FQLUserField.UID,FQLUserField.NAME,FQLUserField.FIRST_NAME,FQLUserField.LAST_NAME,FQLUserField.PIC_SQUARE,FQLUserField.PIC_SQUARE_WITH_LOGO,FQLUserField.IS_APP_USER,FQLUserField.ONLINE_PRESENCE];
         getFriendsEvent.query = "( " + FQLUserField.ONLINE_PRESENCE + " = \'" + OnlinePresence.ACTIVE + "\' OR " + FQLUserField.ONLINE_PRESENCE + " = \'" + OnlinePresence.IDLE + "\' )";
         getFriendsEvent.responder = this.getFriendsResponder;
         StageReference.stage.dispatchEvent(getFriendsEvent);
      }
      
      private function onOnlineFriendsChange(event:CollectionEvent) : void
      {
         if(!this.onlineFriendsPollStarted)
         {
            this.onlineFriendsPollTimer.reset();
            this.onlineFriendsPollTimer.start();
            this.onlineFriendsPollStarted = true;
         }
      }
      
      private function onPollTimer(event:TimerEvent) : void
      {
         if(AppComponents.gamenetManager.currentMatch.isActive() && !AppComponents.gamenetManager.currentMatch.open)
         {
            this.onlineFriendsPollTimer.reset();
            this.onlineFriendsPollTimer.start();
            return;
         }
         var permissions:ArrayCollection = AppComponents.model.privateUser.facebook.permissions;
         if(!permissions.contains(ExtendedPermission.XMPP_LOGIN))
         {
            this.getOnlineFriends();
         }
      }
      
      private function onGetFriendsSuccess(event:AsyncEvent) : void
      {
         var user:FQLUser = null;
         var permissions:ArrayCollection = null;
         var onlinePresence:String = null;
         this.allFriends.source = ArrayCollection(event.data).source;
         var online:Array = [];
         var appUsers:Array = [];
         var nonAppUsers:Array = [];
         for each(user in this.allFriends.source)
         {
            onlinePresence = user.online_presence;
            if(onlinePresence == OnlinePresence.ACTIVE || onlinePresence == OnlinePresence.IDLE)
            {
               online.push(user);
            }
            if(user.is_app_user)
            {
               appUsers.push(user);
            }
            else
            {
               nonAppUsers.push(user);
            }
         }
         permissions = AppComponents.model.privateUser.facebook.permissions;
         if(!permissions.contains(ExtendedPermission.XMPP_LOGIN))
         {
            this.onlineFriends.source = online;
         }
         this.appUserFriends.source = appUsers;
         this.nonAppUserFriends.source = nonAppUsers;
         this._loaded = true;
      }
      
      private function onGetFriendsFail(event:AsyncEvent) : void
      {
         this.getFriends();
      }
      
      private function onGetOnlineFriendsSuccess(event:AsyncEvent) : void
      {
         this.onlineFriends.source = ArrayCollection(event.data).source;
         this.onlineFriendsPollTimer.reset();
         this.onlineFriendsPollTimer.start();
      }
      
      private function onGetOnlineFriendsFail(event:AsyncEvent) : void
      {
         this.getOnlineFriends();
      }
   }
}
