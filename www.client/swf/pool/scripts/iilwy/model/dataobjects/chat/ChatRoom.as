package iilwy.model.dataobjects.chat
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatManager;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.DictionaryCollection;
   import iilwy.events.ChatEvent;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.Browser;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.events.RoomEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   
   public class ChatRoom extends EventDispatcher
   {
       
      
      protected const MAX_MESSAGES:int = 100;
      
      protected var manager:ChatManager;
      
      protected var browser:Browser;
      
      protected var roomJoinedEvent:RoomEvent;
      
      protected var _room:Room;
      
      protected var _jidNode:String;
      
      protected var _displayName:String;
      
      protected var _isPrivate:Boolean;
      
      protected var _numOccupants:int;
      
      protected var _users:DictionaryCollection;
      
      protected var _messages:ArrayCollection;
      
      public function ChatRoom()
      {
         super();
         this.manager = AppComponents.chatManager;
         this.manager.addEventListener(PresenceEvent.PRESENCE,this.onPresence);
         this._room = new Room();
         this.addRoomListeners();
         this._users = new DictionaryCollection();
         this._messages = new ArrayCollection();
      }
      
      public function get room() : Room
      {
         return this._room;
      }
      
      public function get jidNode() : String
      {
         return this._room && this._room.roomJID?this._room.roomJID.node:this._jidNode;
      }
      
      public function set jidNode(value:String) : void
      {
         this._jidNode = value;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function set displayName(value:String) : void
      {
         this._displayName = value;
      }
      
      public function get isPrivate() : Boolean
      {
         return this._isPrivate;
      }
      
      public function set isPrivate(value:Boolean) : void
      {
         this._isPrivate = value;
      }
      
      public function get numOccupants() : int
      {
         return !!this._room.isActive?int(this._users.length):int(this._numOccupants);
      }
      
      public function set numOccupants(value:int) : void
      {
         this._numOccupants = value;
      }
      
      public function get users() : DictionaryCollection
      {
         return this._users;
      }
      
      public function get messages() : ArrayCollection
      {
         return this._messages;
      }
      
      public function create() : Boolean
      {
         if(!this.displayName)
         {
            return false;
         }
         this._room.nickname = this.manager.currentUser.displayName;
         this._room.roomJID = new UnescapedJID(this.jidNode + "@" + this.manager.conferenceServer);
         this._room.connection = this.manager.connection;
         return this._room.join(true);
      }
      
      public function join() : Boolean
      {
         if(!this.jidNode)
         {
            return false;
         }
         this._room.nickname = this.manager.currentUser.displayName;
         this._room.roomJID = new UnescapedJID(this.jidNode + "@" + this.manager.conferenceServer);
         this._room.connection = this.manager.connection;
         return this._room.join();
      }
      
      public function leave() : void
      {
         this._users.removeAll();
         this._messages.removeAll();
         this._room.leave();
         this._room = new Room();
      }
      
      public function sendMessage(body:String) : void
      {
         this._room.sendMessage(body);
      }
      
      public function appendMessage(message:ChatMessage) : void
      {
         this._messages.addItem(message);
         if(this._messages.length > this.MAX_MESSAGES)
         {
            this._messages.removeItemAt(0);
         }
      }
      
      protected function addRoomListeners() : void
      {
         this._room.addEventListener(PropertyChangeEvent.CHANGE,this.onPropertyChange,false,0,true);
         this._room.addEventListener(RoomEvent.ADMIN_ERROR,this.onAdminError,false,0,true);
         this._room.addEventListener(RoomEvent.AFFILIATION_CHANGE_COMPLETE,this.onAffiliationChangeComplete,false,0,true);
         this._room.addEventListener(RoomEvent.AFFILIATIONS,this.onAffiliations,false,0,true);
         this._room.addEventListener(RoomEvent.BANNED_ERROR,this.onBannedError,false,0,true);
         this._room.addEventListener(RoomEvent.CONFIGURE_ROOM,this.onConfigureRoom,false,0,true);
         this._room.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigureRoomComplete,false,0,true);
         this._room.addEventListener(RoomEvent.DECLINED,this.onDeclined,false,0,true);
         this._room.addEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage,false,0,true);
         this._room.addEventListener(RoomEvent.LOCKED_ERROR,this.onLockedError,false,0,true);
         this._room.addEventListener(RoomEvent.MAX_USERS_ERROR,this.onMaxUsersError,false,0,true);
         this._room.addEventListener(RoomEvent.NICK_CONFLICT,this.onNickConflict,false,0,true);
         this._room.addEventListener(RoomEvent.PASSWORD_ERROR,this.onPasswordError,false,0,true);
         this._room.addEventListener(RoomEvent.PRIVATE_MESSAGE,this.onPrivateMessage,false,0,true);
         this._room.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR,this.onRegistrationReqError,false,0,true);
         this._room.addEventListener(RoomEvent.ROOM_DESTROYED,this.onRoomDestroyed,false,0,true);
         this._room.addEventListener(RoomEvent.ROOM_JOIN,this.onRoomJoin,false,0,true);
         this._room.addEventListener(RoomEvent.ROOM_LEAVE,this.onRoomLeave,false,0,true);
         this._room.addEventListener(RoomEvent.SUBJECT_CHANGE,this.onSubjectChange,false,0,true);
         this._room.addEventListener(RoomEvent.USER_BANNED,this.onUserBanned,false,0,true);
         this._room.addEventListener(RoomEvent.USER_DEPARTURE,this.onUserDeparture,false,0,true);
         this._room.addEventListener(RoomEvent.USER_JOIN,this.onUserJoin,false,0,true);
         this._room.addEventListener(RoomEvent.USER_KICKED,this.onUserKicked,false,0,true);
         this._room.addEventListener(RoomEvent.USER_PRESENCE_CHANGE,this.onUserPresenceChange,false,0,true);
      }
      
      protected function removeRoomListeners() : void
      {
         this._room.removeEventListener(RoomEvent.ADMIN_ERROR,this.onAdminError);
         this._room.removeEventListener(RoomEvent.AFFILIATION_CHANGE_COMPLETE,this.onAffiliationChangeComplete);
         this._room.removeEventListener(RoomEvent.AFFILIATIONS,this.onAffiliations);
         this._room.removeEventListener(RoomEvent.BANNED_ERROR,this.onBannedError);
         this._room.removeEventListener(RoomEvent.CONFIGURE_ROOM,this.onConfigureRoom);
         this._room.removeEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigureRoomComplete);
         this._room.removeEventListener(RoomEvent.DECLINED,this.onDeclined);
         this._room.removeEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage);
         this._room.removeEventListener(RoomEvent.LOCKED_ERROR,this.onLockedError);
         this._room.removeEventListener(RoomEvent.MAX_USERS_ERROR,this.onMaxUsersError);
         this._room.removeEventListener(RoomEvent.NICK_CONFLICT,this.onNickConflict);
         this._room.removeEventListener(RoomEvent.PASSWORD_ERROR,this.onPasswordError);
         this._room.removeEventListener(RoomEvent.PRIVATE_MESSAGE,this.onPrivateMessage);
         this._room.removeEventListener(RoomEvent.REGISTRATION_REQ_ERROR,this.onRegistrationReqError);
         this._room.removeEventListener(RoomEvent.ROOM_DESTROYED,this.onRoomDestroyed);
         this._room.removeEventListener(RoomEvent.ROOM_JOIN,this.onRoomJoin);
         this._room.removeEventListener(RoomEvent.ROOM_LEAVE,this.onRoomLeave);
         this._room.removeEventListener(RoomEvent.SUBJECT_CHANGE,this.onSubjectChange);
         this._room.removeEventListener(RoomEvent.USER_BANNED,this.onUserBanned);
         this._room.removeEventListener(RoomEvent.USER_DEPARTURE,this.onUserDeparture);
         this._room.removeEventListener(RoomEvent.USER_JOIN,this.onUserJoin);
         this._room.removeEventListener(RoomEvent.USER_KICKED,this.onUserKicked);
         this._room.removeEventListener(RoomEvent.USER_PRESENCE_CHANGE,this.onUserPresenceChange);
      }
      
      protected function roomJoined() : void
      {
         if(!AppComponents.chatRoomManager.rooms.containsItemAtKey(this.jidNode))
         {
            AppComponents.chatRoomManager.addRoom(this);
         }
         this.appendWelcomeMessage();
         dispatchEvent(this.roomJoinedEvent);
      }
      
      protected function appendWelcomeMessage() : void
      {
         var welcomeMessage:String = "<br /><font size=\"14\" color=\"#ABABAB\"><strong>Be nice. All chat rooms are logged.<br />If someone is being mean, click on their name and report them.</strong></font><br />";
         if(AppComponents.chatRoomManager.chatRoomsContent.welcome_message)
         {
            welcomeMessage = AppComponents.chatRoomManager.chatRoomsContent.welcome_message;
         }
         var chatMessage:ChatMessage = new ChatMessage(welcomeMessage,11250603);
         this.appendMessage(chatMessage);
      }
      
      protected function onPropertyChange(event:PropertyChangeEvent) : void
      {
         var notification:String = null;
         if(!event.oldValue)
         {
            return;
         }
         if(event.name == "affiliation")
         {
            if(event.newValue == Room.AFFILIATION_ADMIN)
            {
               notification = "You are now a moderator of " + this.displayName + ". Use your new power wisely.";
            }
            else if(event.newValue == Room.AFFILIATION_NONE)
            {
               if(event.oldValue == Room.AFFILIATION_ADMIN)
               {
                  notification = "You are no longer a moderator of " + this.displayName + ". Dzam.";
               }
               else if(event.oldValue == Room.AFFILIATION_OUTCAST)
               {
                  notification = "You are no longer banned from " + this.displayName + ". Sweet!";
               }
               else if(event.oldValue == Room.AFFILIATION_OWNER)
               {
                  notification = "You are no longer an owner of " + this.displayName + ". That\'s gotta hurt.";
               }
            }
            else if(event.newValue == Room.AFFILIATION_OWNER)
            {
               notification = "You are now an owner of " + this.displayName + ". What what?!.";
            }
         }
         if(notification)
         {
            AppComponents.alertManager.showNotification(notification);
         }
      }
      
      protected function onAdminError(event:RoomEvent) : void
      {
         var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
         xiffErrorEvent.errorCode = event.errorCode;
         xiffErrorEvent.errorCondition = event.errorCondition;
         xiffErrorEvent.errorMessage = event.errorMessage;
         xiffErrorEvent.errorType = event.errorType;
         dispatchEvent(xiffErrorEvent);
      }
      
      protected function onAffiliationChangeComplete(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onAffiliations(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onBannedError(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onConfigureRoom(event:RoomEvent) : void
      {
         var formExtension:FormExtension = event.data as FormExtension;
         var fieldMap:Object = {};
         fieldMap["muc#roomconfig_roomname"] = [this.displayName];
         fieldMap["muc#roomconfig_persistentroom"] = ["1"];
         fieldMap["muc#roomconfig_maxusers"] = ["500"];
         fieldMap["muc#roomconfig_whois"] = ["anyone"];
         fieldMap["muc#roomconfig_allowvisitornickchange"] = ["0"];
         this.room.configure(fieldMap);
         dispatchEvent(event);
      }
      
      protected function onConfigureRoomComplete(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onDeclined(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onGroupMessage(event:RoomEvent) : void
      {
         var message:Message = event.data as Message;
         var chatUser:ChatUser = !!this._users.containsItemAtKey(event.nickname)?this._users.getItemAtKey(event.nickname):null;
         var chatMessage:ChatMessage = new ChatMessage(message.body);
         chatMessage.user = chatUser;
         if(chatUser)
         {
            this.appendMessage(chatMessage);
         }
         dispatchEvent(event);
      }
      
      protected function onLockedError(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onMaxUsersError(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onNickConflict(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onPasswordError(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onPrivateMessage(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRegistrationReqError(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRoomDestroyed(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRoomJoin(event:RoomEvent) : void
      {
         var server:EscapedJID = null;
         this.roomJoinedEvent = event;
         this.jidNode = this.jidNode;
         if(!this.displayName)
         {
            server = new EscapedJID(AppComponents.chatManager.conferenceServer);
            this.browser = new Browser(AppComponents.chatManager.connection);
            this.browser.getServiceInfo(this._room.roomJID.escaped,this.onGetRoomInfo,this.onGetRoomInfoError);
         }
         else
         {
            this.roomJoined();
         }
      }
      
      protected function onRoomLeave(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onSubjectChange(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onUserBanned(event:RoomEvent) : void
      {
         var chatEvent:ChatEvent = null;
         var notification:String = null;
         var message:ChatMessage = null;
         var chatUser:ChatUser = !!this._users.containsItemAtKey(event.nickname)?this._users.getItemAtKey(event.nickname):null;
         if(chatUser)
         {
            if(chatUser.isMe)
            {
               chatEvent = new ChatEvent(ChatEvent.LEAVE_CHAT_ROOM,true);
               chatEvent.chatRoom = this;
               StageReference.stage.dispatchEvent(chatEvent);
               notification = "You have been banned from " + this.displayName + ". Who\'d you make mad?";
               AppComponents.alertManager.showNotification(notification);
            }
            else
            {
               message = new ChatMessage(chatUser.displayName + " was banned from the room.",11250603);
               this.appendMessage(message);
               this._users.removeItemAtKey(event.nickname);
            }
         }
         dispatchEvent(event);
      }
      
      protected function onUserDeparture(event:RoomEvent) : void
      {
         var message:ChatMessage = null;
         var chatUser:ChatUser = !!this._users.containsItemAtKey(event.nickname)?this._users.getItemAtKey(event.nickname):null;
         if(chatUser)
         {
            message = new ChatMessage(chatUser.displayName + " left the room.",11250603);
            this._users.removeItemAtKey(event.nickname);
         }
         dispatchEvent(event);
      }
      
      protected function onUserJoin(event:RoomEvent) : void
      {
         var occupant:RoomOccupant = this.room.getOccupantNamed(event.nickname);
         if(!occupant || !occupant.jid)
         {
            return;
         }
         var chatUser:ChatUser = new ChatUser(occupant.jid);
         chatUser.displayName = event.nickname;
         if(this._users.containsItemAtKey(event.nickname))
         {
            return;
         }
         this._users.addItem(event.nickname,chatUser);
         var message:ChatMessage = new ChatMessage(chatUser.displayName + " joined the room.",11250603);
         dispatchEvent(event);
      }
      
      protected function onUserKicked(event:RoomEvent) : void
      {
         var chatEvent:ChatEvent = null;
         var notification:String = null;
         var message:ChatMessage = null;
         var chatUser:ChatUser = !!this._users.containsItemAtKey(event.nickname)?this._users.getItemAtKey(event.nickname):null;
         if(chatUser)
         {
            if(chatUser.isMe)
            {
               chatEvent = new ChatEvent(ChatEvent.LEAVE_CHAT_ROOM,true);
               chatEvent.chatRoom = this;
               StageReference.stage.dispatchEvent(chatEvent);
               notification = "You have been kicked from " + this.displayName + ". So sorry.";
               AppComponents.alertManager.showNotification(notification);
            }
            else
            {
               message = new ChatMessage(chatUser.displayName + " was kicked from the room.",11250603);
               this.appendMessage(message);
               this._users.removeItemAtKey(event.nickname);
            }
         }
         dispatchEvent(event);
      }
      
      protected function onUserPresenceChange(event:RoomEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onPresence(event:PresenceEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onGetRoomInfo(iq:IQ) : void
      {
         var extensions:Array = iq.getAllExtensions();
         var disco:InfoDiscoExtension = extensions.length > 0?extensions[0]:null;
         if(disco && disco.identities.length > 0)
         {
            this.displayName = disco.identities[0].name;
         }
         this.roomJoined();
      }
      
      protected function onGetRoomInfoError(iq:IQ) : void
      {
         this.roomJoined();
      }
   }
}
