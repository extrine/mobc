package iilwy.chat
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.collections.DictionaryCollection;
   import iilwy.events.ChatEvent;
   import iilwy.events.ChatUserEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.ExternalSounds;
   import iilwy.model.dataobjects.LoginCredentials;
   import iilwy.model.dataobjects.chat.ChatMessage;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.EventNotificationType;
   import iilwy.net.MediaProxy;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.collections.events.CollectionEvent;
   import org.igniterealtime.xiff.conference.InviteListener;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.data.muc.MUC;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.InviteEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.events.RegistrationFieldsEvent;
   import org.igniterealtime.xiff.events.RegistrationSuccessEvent;
   import org.igniterealtime.xiff.events.RosterEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   import org.igniterealtime.xiff.im.Roster;
   
   use namespace omgpop_internal;
   
   public class ChatManager extends EventDispatcher
   {
      
      public static const EVENT_BOT_JID:String = "event@xmpp_messenger.chatfarm.omgpop.com";
       
      
      private const KEEP_ALIVE_TIME:int = 30000;
      
      protected var registerUser:Boolean;
      
      protected var registrationData:Object;
      
      protected var keepAliveTimer:Timer;
      
      protected var _serverURL:String;
      
      protected var _port:int = 5222;
      
      protected var _policyPort:int = 5229;
      
      protected var _streamType:uint = 0;
      
      protected var _connection:XMPPConnection;
      
      protected var _inviteListener:InviteListener;
      
      protected var _roster:Roster;
      
      protected var _chatUserRoster:DictionaryCollection;
      
      protected var _onlineChatUserRoster:DictionaryCollection;
      
      protected var _currentUser:ChatUser;
      
      protected var _privateMessages:Dictionary;
      
      protected var _serverPinged:Boolean;
      
      public function ChatManager()
      {
         super();
         this.setupConnection();
         this.setupInviteListener();
         this.setupRoster();
         this.setupChat();
         this.setupCurrentUser();
         this.registerSASLMechanisms();
         this.registerExtensions();
         this.setupPMDict();
         this.setupTimer();
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
      }
      
      public static function isValidJID(jid:UnescapedJID) : Boolean
      {
         var value:Boolean = false;
         var pattern:RegExp = /(\w|[_.\-])+@(localhost$|((\w|-)+\.)+\w{2,4}$){1}/;
         var result:Object = pattern.exec(jid.toString());
         if(result)
         {
            value = true;
         }
         return value;
      }
      
      public function get serverID() : String
      {
         return this._serverURL.substring(0,this._serverURL.indexOf("."));
      }
      
      public function get serverDomain() : String
      {
         return this._serverURL.substring(this._serverURL.indexOf("."));
      }
      
      public function get serverURL() : String
      {
         return this._serverURL;
      }
      
      public function set serverURL(value:String) : void
      {
         this._serverURL = value;
      }
      
      public function get conferenceServer() : String
      {
         return "conference." + this.serverURL;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function set port(value:int) : void
      {
         this._port = value;
      }
      
      public function get policyPort() : int
      {
         return this._policyPort;
      }
      
      public function set policyPort(value:int) : void
      {
         this._policyPort = value;
      }
      
      public function get streamType() : uint
      {
         return this._streamType;
      }
      
      public function set streamType(value:uint) : void
      {
         this._streamType = value;
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function set connection(value:XMPPConnection) : void
      {
         if(this._connection.isActive())
         {
            this.disconnect();
            this.cleanup();
         }
         this._connection = value;
         this.addConnectionListeners();
      }
      
      public function get inviteListener() : InviteListener
      {
         return this._inviteListener;
      }
      
      public function get roster() : Roster
      {
         return this._roster;
      }
      
      public function get chatUserRoster() : DictionaryCollection
      {
         return this._chatUserRoster;
      }
      
      public function get onlineChatUserRoster() : DictionaryCollection
      {
         return this._onlineChatUserRoster;
      }
      
      public function get currentUser() : ChatUser
      {
         return this._currentUser;
      }
      
      public function set currentUser(value:ChatUser) : void
      {
         this._currentUser = value;
      }
      
      public function get privateMessages() : Dictionary
      {
         return this._privateMessages;
      }
      
      public function get serverPinged() : Boolean
      {
         return this._serverPinged;
      }
      
      public function get numFriends() : int
      {
         return this.chatUserRoster.length;
      }
      
      public function get numOnlineFriends() : int
      {
         return this.onlineChatUserRoster.length;
      }
      
      public function isFriend(jid:UnescapedJID) : Boolean
      {
         return this.chatUserRoster.containsItemAtKey(jid.bareJID);
      }
      
      public function isOnlineFriend(jid:UnescapedJID) : Boolean
      {
         return this.onlineChatUserRoster.containsItemAtKey(jid.bareJID);
      }
      
      public function getFriend(jid:UnescapedJID) : ChatUser
      {
         var friend:ChatUser = null;
         if(this.isFriend(jid))
         {
            friend = this.chatUserRoster.getItemAtKey(jid.bareJID);
         }
         return friend;
      }
      
      public function connect(credentials:LoginCredentials) : Boolean
      {
         Security.loadPolicyFile("xmlsocket://" + this.serverURL + ":" + this.policyPort);
         this.registerUser = false;
         this.connection.username = credentials.username;
         this.connection.password = credentials.password;
         this.connection.server = this.serverURL;
         this.connection.port = this.port;
         return this.connection.connect(this._streamType);
      }
      
      public function disconnect() : void
      {
         this.connection.disconnect();
      }
      
      public function updatePresence(show:String, status:String, priority:Number = 0) : void
      {
         this.currentUser.status = status;
         AppComponents.model.privateUser.profile.onlineStatus = PlayerStatus.createFromDescription(status);
         this.roster.setPresence(show,status,priority);
      }
      
      public function register(credentials:LoginCredentials) : void
      {
         this.registerUser = true;
         this.connection.username = null;
         this.connection.password = null;
         this.connection.server = this.serverURL;
         this.connection.port = this._port;
         this.connection.connect(this._streamType);
         this.registrationData = {};
         this.registrationData.username = credentials.username;
         this.registrationData.password = credentials.password;
      }
      
      public function addBuddy(jid:UnescapedJID) : void
      {
         this.roster.addContact(jid,jid.toString(),"Buddies",true);
      }
      
      public function removeBuddy(rosterItem:RosterItemVO) : void
      {
         this.roster.removeContact(rosterItem);
      }
      
      public function updateGroup(rosterItem:RosterItemVO, groupName:String) : void
      {
         this.roster.updateContactGroups(rosterItem,[groupName]);
      }
      
      protected function setupConnection() : void
      {
         this._connection = new XMPPConnection();
         this.addConnectionListeners();
      }
      
      protected function setupInviteListener() : void
      {
         this._inviteListener = new InviteListener();
         this._inviteListener.addEventListener(InviteEvent.INVITED,this.onInvited);
         this._inviteListener.connection = this._connection;
      }
      
      protected function setupRoster() : void
      {
         this._roster = new Roster();
         this._roster.addEventListener(RosterEvent.ROSTER_LOADED,this.onRosterLoaded);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL,this.onSubscriptionDenial);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST,this.onSubscriptionRequest);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION,this.onSubscriptionRevocation);
         this._roster.addEventListener(RosterEvent.USER_ADDED,this.onUserAdded);
         this._roster.addEventListener(RosterEvent.USER_AVAILABLE,this.onUserAvailable);
         this._roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED,this.onUserPresenceUpdated);
         this._roster.addEventListener(RosterEvent.USER_REMOVED,this.onUserRemoved);
         this._roster.addEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED,this.onUserSubscriptionUpdated);
         this._roster.addEventListener(RosterEvent.USER_UNAVAILABLE,this.onUserUnavailable);
         this._roster.connection = this._connection;
         this._chatUserRoster = new DictionaryCollection();
         this._onlineChatUserRoster = new DictionaryCollection();
      }
      
      protected function setupChat() : void
      {
         MUC.enable();
      }
      
      protected function setupCurrentUser() : void
      {
         this._currentUser = new ChatUser(this._connection.jid);
      }
      
      protected function registerSASLMechanisms() : void
      {
      }
      
      protected function registerExtensions() : void
      {
      }
      
      protected function setupPMDict() : void
      {
         this._privateMessages = new Dictionary();
      }
      
      protected function setupTimer() : void
      {
         this.keepAliveTimer = new Timer(this.KEEP_ALIVE_TIME);
         this.keepAliveTimer.addEventListener(TimerEvent.TIMER,this.onKeepAliveTimer);
      }
      
      protected function cleanup() : void
      {
         this.removeConnectionListeners();
         this.setupCurrentUser();
         this._chatUserRoster.removeAll();
         this._onlineChatUserRoster.removeAll();
         this.keepAliveTimer.stop();
         this._serverPinged = false;
      }
      
      protected function addConnectionListeners() : void
      {
         this._connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnectSuccess);
         this._connection.addEventListener(DisconnectionEvent.DISCONNECT,this.onDisconnect);
         this._connection.addEventListener(LoginEvent.LOGIN,this.onLogin);
         this._connection.addEventListener(XIFFErrorEvent.XIFF_ERROR,this.onXIFFError);
         this._connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onOutgoingData);
         this._connection.addEventListener(IncomingDataEvent.INCOMING_DATA,this.onIncomingData);
         this._connection.addEventListener(RegistrationFieldsEvent.REG_FIELDS,this.onRegistrationFields);
         this._connection.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS,this.onRegistrationSuccess);
         this._connection.addEventListener(PresenceEvent.PRESENCE,this.onPresence);
         this._connection.addEventListener(MessageEvent.MESSAGE,this.onMessage);
      }
      
      protected function removeConnectionListeners() : void
      {
         this._connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnectSuccess);
         this._connection.removeEventListener(DisconnectionEvent.DISCONNECT,this.onDisconnect);
         this._connection.removeEventListener(LoginEvent.LOGIN,this.onLogin);
         this._connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR,this.onXIFFError);
         this._connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onOutgoingData);
         this._connection.removeEventListener(IncomingDataEvent.INCOMING_DATA,this.onIncomingData);
         this._connection.removeEventListener(RegistrationFieldsEvent.REG_FIELDS,this.onRegistrationFields);
         this._connection.removeEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS,this.onRegistrationSuccess);
         this._connection.removeEventListener(PresenceEvent.PRESENCE,this.onPresence);
         this._connection.removeEventListener(MessageEvent.MESSAGE,this.onMessage);
      }
      
      protected function addLoginEvent(chatUser:ChatUser) : void
      {
         var eventData:Object = null;
         if(this.onlineChatUserRoster.containsItemAtKey(chatUser.jid.bareJID) && this.serverPinged)
         {
            eventData = {
               "lookup_type":"user",
               "lookup_id":chatUser.userID,
               "e_type":EventNotificationType.FRIEND_LOGS_IN,
               "e_message":"Your contact, " + chatUser.displayName + " just logged in!",
               "user":{
                  "type":"profile",
                  "photo_url":chatUser.photoURL,
                  "user_id":chatUser.userID,
                  "profile_id":chatUser.profileID,
                  "profile_name":chatUser.displayName
               },
               "e_link":"#",
               "e_image":MediaProxy.url(chatUser.photoURL,MediaProxy.SIZE_TINY_THUMB)
            };
            AppComponents.remoteEventSubscriber.addEvent(eventData);
         }
      }
      
      protected function onLoginChanged(event:UserDataEvent) : void
      {
         if(!AppComponents.model.privateUser.isLoggedIn)
         {
            this.disconnect();
         }
      }
      
      protected function onConnectSuccess(event:ConnectionSuccessEvent) : void
      {
         if(this.registerUser)
         {
            this._connection.sendRegistrationFields(this.registrationData,null);
         }
         dispatchEvent(event);
      }
      
      protected function onDisconnect(event:DisconnectionEvent) : void
      {
         this.cleanup();
         this.setupConnection();
         this._roster.connection = this._connection;
         StageReference.stage.dispatchEvent(new ChatEvent(ChatEvent.DISCONNECTED_FROM_CHAT_SERVER,true,true));
         dispatchEvent(event);
      }
      
      protected function onLogin(event:LoginEvent) : void
      {
         this._currentUser.loadVCard();
         this.keepAliveTimer.start();
         dispatchEvent(event);
      }
      
      protected function onXIFFError(event:XIFFErrorEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onOutgoingData(event:OutgoingDataEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onIncomingData(event:IncomingDataEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRegistrationFields(event:RegistrationFieldsEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRegistrationSuccess(event:RegistrationSuccessEvent) : void
      {
         this._connection.disconnect();
         dispatchEvent(event);
      }
      
      protected function onPresence(event:PresenceEvent) : void
      {
         var xiffErrorEvent:XIFFErrorEvent = null;
         var presence:Presence = event.data[0] as Presence;
         if(presence.type == Presence.TYPE_ERROR)
         {
            xiffErrorEvent = new XIFFErrorEvent();
            xiffErrorEvent.errorCode = presence.errorCode;
            xiffErrorEvent.errorCondition = presence.errorCondition;
            xiffErrorEvent.errorMessage = presence.errorMessage;
            xiffErrorEvent.errorType = presence.errorType;
            this.onXIFFError(xiffErrorEvent);
         }
         else
         {
            dispatchEvent(event);
         }
      }
      
      protected function onMessage(event:MessageEvent) : void
      {
         var jid:UnescapedJID = null;
         var chatUser:ChatUser = null;
         var chatMessage:ChatMessage = null;
         var chatEvent:ChatEvent = null;
         var eventData:Object = null;
         var allowSuppress:Boolean = false;
         var message:Message = event.data as Message;
         if(message.type == Message.TYPE_CHAT && (message.body || message.htmlBody))
         {
            jid = message.from.unescaped;
            chatUser = !!this.chatUserRoster.containsItemAtKey(jid.bareJID)?this.chatUserRoster.getItemAtKey(jid.bareJID):new ChatUser(jid);
            chatUser.loadVCard();
            AppComponents.soundManager.playSound(ExternalSounds.MESSAGE);
            chatMessage = new ChatMessage(message.body);
            chatMessage.user = chatUser;
            chatEvent = new ChatEvent(ChatEvent.OPEN_CHAT,true,true);
            chatEvent.chatUser = chatUser;
            chatEvent.chatMessage = chatMessage;
            StageReference.stage.dispatchEvent(chatEvent);
         }
         else if(message.type == Message.TYPE_HEADLINE && (message.body || message.htmlBody))
         {
            if(message.from.bareJID == EVENT_BOT_JID)
            {
               eventData = JSON.deserialize(message.body);
               allowSuppress = eventData.e_type != EventNotificationType.PRODUCT_PURCHASE && eventData.e_type != EventNotificationType.COIN_UP && eventData.e_type != EventNotificationType.COIN_DOWN;
               AppComponents.remoteEventSubscriber.addEvent(eventData,allowSuppress);
            }
         }
         else
         {
            dispatchEvent(event);
         }
      }
      
      protected function onInvited(event:InviteEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRosterLoaded(event:RosterEvent) : void
      {
         this.updatePresence(null,"Online",5);
         this._roster.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRosterChange);
         this._roster.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRosterChange);
         AppComponents.model.privateUser.friends.init();
         dispatchEvent(event);
      }
      
      protected function onSubscriptionDenial(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onSubscriptionRequest(event:RosterEvent) : void
      {
         if(this._roster.contains(RosterItemVO.get(event.jid,false)))
         {
            this._roster.grantSubscription(event.jid,true);
         }
         dispatchEvent(event);
      }
      
      protected function onSubscriptionRevocation(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onUserAdded(event:RosterEvent) : void
      {
         var rosterItem:RosterItemVO = event.data;
         var chatUser:ChatUser = new ChatUser(rosterItem.jid);
         chatUser.rosterItem = rosterItem;
         chatUser.addEventListener(ChatUserEvent.UPDATE,this.onChatUserUpdate);
         if(!this._chatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
         {
            this._chatUserRoster.addItem(rosterItem.jid.bareJID,chatUser);
         }
         if(rosterItem.online)
         {
            chatUser.loadVCard();
            if(!this._onlineChatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
            {
               this._onlineChatUserRoster.addItem(rosterItem.jid.bareJID,chatUser);
            }
         }
         else
         {
            rosterItem.removeEventListener(PropertyChangeEvent.CHANGE,this.onRosterItemChange);
            rosterItem.addEventListener(PropertyChangeEvent.CHANGE,this.onRosterItemChange);
         }
         dispatchEvent(event);
      }
      
      protected function onUserAvailable(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onUserPresenceUpdated(event:RosterEvent) : void
      {
         var chatUser:ChatUser = null;
         var rosterItem:RosterItemVO = event.data;
         if(rosterItem.online)
         {
            if(this._chatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
            {
               chatUser = this._chatUserRoster.getItemAtKey(rosterItem.jid.bareJID);
               chatUser.loadVCard();
               if(!this._onlineChatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
               {
                  this._onlineChatUserRoster.addItem(rosterItem.jid.bareJID,chatUser);
               }
            }
         }
         else if(this._onlineChatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
         {
            this._onlineChatUserRoster.removeItemAtKey(rosterItem.jid.bareJID);
         }
         dispatchEvent(event);
      }
      
      protected function onUserRemoved(event:RosterEvent) : void
      {
         var chatUser:ChatUser = null;
         var rosterItem:RosterItemVO = event.data;
         if(this._chatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
         {
            chatUser = this._chatUserRoster.removeItemAtKey(rosterItem.jid.bareJID);
            chatUser.removeEventListener(ChatUserEvent.UPDATE,this.onChatUserUpdate);
         }
         if(this._onlineChatUserRoster.containsItemAtKey(rosterItem.jid.bareJID))
         {
            this._onlineChatUserRoster.removeItemAtKey(rosterItem.jid.bareJID);
         }
         dispatchEvent(event);
      }
      
      protected function onUserSubscriptionUpdated(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onUserUnavailable(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      protected function onRosterChange(event:CollectionEvent) : void
      {
      }
      
      protected function onRosterItemChange(event:PropertyChangeEvent) : void
      {
         var rosterItem:RosterItemVO = event.target as RosterItemVO;
         if(!rosterItem)
         {
            return;
         }
         var chatUser:ChatUser = !!this.chatUserRoster.containsItemAtKey(rosterItem.jid.bareJID)?this.chatUserRoster.getItemAtKey(rosterItem.jid.bareJID):null;
         if(!chatUser)
         {
            return;
         }
         if(event.name == "online" && event.newValue == true)
         {
            if(!chatUser.vCardRequested)
            {
               chatUser.loadVCard();
            }
            else
            {
               this.addLoginEvent(chatUser);
            }
         }
      }
      
      protected function onChatUserUpdate(event:ChatUserEvent) : void
      {
         this.addLoginEvent(event.chatUser);
      }
      
      protected function onKeepAliveTimer(event:TimerEvent) : void
      {
         if(this.connection.isLoggedIn())
         {
            this._serverPinged = true;
            this.connection.sendKeepAlive();
         }
      }
   }
}
