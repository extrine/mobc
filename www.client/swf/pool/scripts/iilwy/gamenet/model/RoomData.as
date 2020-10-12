package iilwy.gamenet.model
{
   import be.boulevart.as3.security.RC4;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.DictionaryCollection;
   import iilwy.gamenet.GamenetManager;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.events.LobbyDataEvent;
   import iilwy.gamenet.events.MatchDataEvent;
   import iilwy.gamenet.events.RoomDataEvent;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.gamenet.utils.MessageSerializer;
   import iilwy.utils.logging.Logger;
   import org.igniterealtime.xiff.collections.events.CollectionEvent;
   import org.igniterealtime.xiff.collections.events.CollectionEventKind;
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.events.RoomEvent;

   public class RoomData extends EventDispatcher
   {


      public var defaultPingInterval:int = 30000.0;

      protected var _logger:Logger;

      protected var _pingTimer:Timer;

      private var _gamenetManager:GamenetManager;

      private var _xmppRoom:Room;

      private var _roomName:String;

      private var _participants:DictionaryCollection;

      private var _players:PlayerCollection;

      private var _chatMessages:ArrayCollection;

      private var _numParticipants:int;

      public function RoomData(gamenetManager:GamenetManager)
      {
         super();
         this._gamenetManager = gamenetManager;
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.NONE;
         this._participants = new DictionaryCollection();
         this._players = new PlayerCollection();
         this._chatMessages = new ArrayCollection();
         this._pingTimer = new Timer(this.defaultPingInterval);
         this._pingTimer.addEventListener(TimerEvent.TIMER,this.onPingTimer);
         this._xmppRoom = new Room();
      }

      public function get gamenetManager() : GamenetManager
      {
         return this._gamenetManager;
      }

      public function set gamenetManager(value:GamenetManager) : void
      {
         this._gamenetManager = value;
      }

      public function get roomName() : String
      {
         return this._roomName;
      }

      public function set roomName(value:String) : void
      {
         this._roomName = value;
      }

      public function get xmppRoom() : Room
      {
         return this._xmppRoom;
      }

      public function get participants() : DictionaryCollection
      {
         return this._participants;
      }

      public function get players() : PlayerCollection
      {
         return this._players;
      }

      public function get chatMessages() : ArrayCollection
      {
         return this._chatMessages;
      }

      public function get numParticipants() : int
      {
         return this.participants.length;
      }

      public function isActive() : Boolean
      {
         return this.xmppRoom.isActive;
      }

      public function join(newRoomName:String, createReserved:Boolean = false) : void
      {
         if(this.roomName == newRoomName)
         {
            this._logger.log("Already in room",this.roomName);
         }
         else if(this.roomName != null)
         {
            this._logger.log("Leaving room",this.roomName);
            this.leave();
         }
         else
         {
            this._logger.log("Joining room",newRoomName);
         }
         this._xmppRoom = new Room();
         this.registerEvents();
         this.roomName = newRoomName;
         this._pingTimer.reset();
         this._pingTimer.start();
         this._xmppRoom.connection = this._gamenetManager.connection;
         this._xmppRoom.nickname = this._gamenetManager.username;
         this._xmppRoom.roomJID = new UnescapedJID(this.roomName + "@" + this._gamenetManager.conferenceServer);
         this._xmppRoom.roomName = this.roomName;
         this._xmppRoom.conferenceServer = this._gamenetManager.conferenceServer;
         var playerExtension:PlayerExtension = this._gamenetManager.currentPlayer.toExtension();
         this._xmppRoom.join(createReserved,[playerExtension]);
      }

      public function leave() : void
      {
         this._pingTimer.stop();
         this._chatMessages.removeAll();
         this._players.removeAll();
         this._participants.removeAll();
         this._logger.log("leaving");
         this._xmppRoom.leave();
         this.unregisterEvents();
         this.roomName = null;
         this._xmppRoom = new Room();
      }

      public function createPlayerDataForParticipant(occupant:RoomOccupant) : PlayerData
      {
         var player:PlayerData = null;
         var occupantJID:UnescapedJID = null;
         var extension:PlayerExtension = null;
         try
         {
            occupantJID = DataUtil.normalizeJID(occupant.jid);
            extension = this.participants.getItemAtKey(occupantJID.node);
            player = new PlayerData();
            player.initFromPlayerExtension(extension);
         }
         catch(e:Error)
         {
            trace("Error creating data for participant");
            _logger.log("Error creating data for participant");
         }
         return player;
      }

      public function sendChat(text:String, playerJID:String = null) : void
      {
         var msg:String = text;
         try
         {
            msg = this.gamenetManager.gamenetController.chatOutFilter(text);
         }
         catch(e:Error)
         {
         }
         var obj:Object = {
            "type":MessageSerializer.TYPE_CHAT,
            "data":{"body":msg}
         };
         this.sendMessage(MessageSerializer.getInstance().serialize(obj),playerJID);
      }

      public function sendNotification(text:String, playerJID:String = null) : void
      {
         var obj:Object = {
            "type":MessageSerializer.TYPE_NOTIFICATION,
            "data":{"body":text}
         };
         this.sendMessage(MessageSerializer.getInstance().serialize(obj),playerJID);
      }

      public function selfSendSystemMessage(body:String, type:String) : void
      {
         var chat:ChatData = new ChatData();
         chat.type = type;
         chat.message = body;
         this._chatMessages.addItem(chat);
      }

      public function selfNotification(body:String) : void
      {
         var chat:ChatData = new ChatData();
         chat.message = body;
         this._chatMessages.addItem(chat);
      }

      public function sendMessage(body:String, playerJID:String = null) : void
      {
         if(playerJID == null)
         {
            this.xmppRoom.sendMessage(body);
         }
         else
         {
            this.xmppRoom.sendPrivateMessage(playerJID,body);
         }
      }

      private function registerEvents() : void
      {
         this._xmppRoom.addEventListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChange);
         this._xmppRoom.addEventListener(RoomDataEvent.GROUP_MESSAGE,this.onGroupMessage);
         this._xmppRoom.addEventListener(RoomDataEvent.GAME_EVENT,this.onGameEvent);
         this._xmppRoom.addEventListener(RoomDataEvent.PRIVATE_MESSAGE,this.onPrivateMessage);
         this._xmppRoom.addEventListener(RoomDataEvent.ROOM_JOIN,this.onRoomJoin);
         this._xmppRoom.addEventListener(RoomDataEvent.ROOM_LEAVE,this.onRoomLeave);
         this._xmppRoom.addEventListener(RoomDataEvent.AFFILIATIONS,this.onAffiliations);
         this._xmppRoom.addEventListener(RoomDataEvent.ADMIN_ERROR,this.onAdminError);
         this._xmppRoom.addEventListener(RoomDataEvent.USER_JOIN,this.onUserJoin);
         this._xmppRoom.addEventListener(RoomDataEvent.USER_DEPARTURE,this.onUserDeparture);
         this._xmppRoom.addEventListener(RoomDataEvent.NICK_CONFLICT,this.onNickConflict);
         this._xmppRoom.addEventListener(RoomDataEvent.CONFIGURE_ROOM,this.onConfigureRoom);
         this._xmppRoom.addEventListener(RoomDataEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigureRoomComplete);
         this._xmppRoom.addEventListener(RoomDataEvent.DECLINED,this.onDeclined);
         this._xmppRoom.addEventListener(RoomDataEvent.USER_PRESENCE_CHANGE,this.onUserPresenceChange);
         this._xmppRoom.addEventListener(RoomEvent.PASSWORD_ERROR,this.onRoomError);
         this._xmppRoom.addEventListener(RoomEvent.BANNED_ERROR,this.onRoomError);
         this._xmppRoom.addEventListener(RoomEvent.LOCKED_ERROR,this.onRoomError);
         this._xmppRoom.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR,this.onRoomError);
         this._xmppRoom.addEventListener(RoomEvent.NICK_CONFLICT,this.onRoomError);
         this._xmppRoom.addEventListener(RoomEvent.MAX_USERS_ERROR,this.onRoomError);
         this._xmppRoom.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange);
      }

      private function unregisterEvents() : void
      {
         this._xmppRoom.removeEventListener(RoomDataEvent.SUBJECT_CHANGE,this.onSubjectChange);
         this._xmppRoom.removeEventListener(RoomDataEvent.GROUP_MESSAGE,this.onGroupMessage);
         this._xmppRoom.removeEventListener(RoomDataEvent.GAME_EVENT,this.onGameEvent);
         this._xmppRoom.removeEventListener(RoomDataEvent.PRIVATE_MESSAGE,this.onPrivateMessage);
         this._xmppRoom.removeEventListener(RoomDataEvent.ROOM_JOIN,this.onRoomJoin);
         this._xmppRoom.removeEventListener(RoomDataEvent.ROOM_LEAVE,this.onRoomLeave);
         this._xmppRoom.removeEventListener(RoomDataEvent.AFFILIATIONS,this.onAffiliations);
         this._xmppRoom.removeEventListener(RoomDataEvent.ADMIN_ERROR,this.onAdminError);
         this._xmppRoom.removeEventListener(RoomDataEvent.USER_JOIN,this.onUserJoin);
         this._xmppRoom.removeEventListener(RoomDataEvent.USER_DEPARTURE,this.onUserDeparture);
         this._xmppRoom.removeEventListener(RoomDataEvent.NICK_CONFLICT,this.onNickConflict);
         this._xmppRoom.removeEventListener(RoomDataEvent.CONFIGURE_ROOM,this.onConfigureRoom);
         this._xmppRoom.removeEventListener(RoomDataEvent.CONFIGURE_ROOM_COMPLETE,this.onConfigureRoomComplete);
         this._xmppRoom.removeEventListener(RoomDataEvent.DECLINED,this.onDeclined);
         this._xmppRoom.removeEventListener(RoomDataEvent.USER_PRESENCE_CHANGE,this.onUserPresenceChange);
         this._xmppRoom.removeEventListener(RoomEvent.PASSWORD_ERROR,this.onRoomError);
         this._xmppRoom.removeEventListener(RoomEvent.BANNED_ERROR,this.onRoomError);
         this._xmppRoom.removeEventListener(RoomEvent.LOCKED_ERROR,this.onRoomError);
         this._xmppRoom.removeEventListener(RoomEvent.REGISTRATION_REQ_ERROR,this.onRoomError);
         this._xmppRoom.removeEventListener(RoomEvent.NICK_CONFLICT,this.onRoomError);
         this._xmppRoom.removeEventListener(RoomEvent.MAX_USERS_ERROR,this.onRoomError);
         this._xmppRoom.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange);
      }

      protected function isChatSenderMuted(chat:ChatData) : Boolean
      {
         var result:Boolean = false;
         if(!chat.player)
         {
            return false;
         }
         if(!chat.player.equals(AppComponents.gamenetManager.currentPlayer))
         {
            if(AppComponents.model.privateUser.isProfileMuted(chat.player.profileId))
            {
               result = true;
            }
            else if(AppComponents.model.privateUser.isGuestMuted(chat.player.guestId))
            {
               result = true;
            }
         }
         return result;
      }

      public function clearChatMessages(leave:int = 10) : void
      {
         var msg:* = undefined;
         var startIndex:int = Math.max(0,this.chatMessages.source.length - leave);
         var endIndex:int = Math.max(0,this.chatMessages.source.length);
         var tempSource:Array = this.chatMessages.source.slice(startIndex,endIndex);
         this.chatMessages.removeAll();
         for each(msg in tempSource)
         {
            this.chatMessages.addItem(msg);
         }
      }

      protected function updatePingTime(time:Number) : void
      {
      }

      protected function findPlayerForChat(jid:String) : PlayerData
      {
         return this._players.findPlayerByJid(jid);
      }

      public function pingSelf(delay:int = 1) : void
      {
         this._pingTimer.reset();
         this._pingTimer.delay = delay;
         this._pingTimer.start();
      }

      protected function shouldReceiveGameEvent(msg:*) : Boolean
      {
         return true;
      }

      private function onGameEvent(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      protected function onSubjectChange(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      protected function onRoomCollectionChange(event:CollectionEvent) : void
      {
         var player:PlayerData = null;
         var roomOccupant:RoomOccupant = null;
         var occupantJID:UnescapedJID = null;
         var extension:PlayerExtension = null;
         if(event.kind == CollectionEventKind.ADD)
         {
            for each(roomOccupant in event.items)
            {
               player = this.createPlayerDataForParticipant(roomOccupant);
               if(player)
               {
                  this._players.addPlayer(player);
               }
            }
         }
         else if(event.kind == CollectionEventKind.REMOVE)
         {
            for each(roomOccupant in event.items)
            {
               player = this.createPlayerDataForParticipant(roomOccupant);
               if(player)
               {
                  this._players.removePlayer(player);
               }
            }
         }
         else if(event.kind == CollectionEventKind.RESET)
         {
            this._players.removeAll();
         }
      }

      protected function onPrivateMessage(evt:RoomEvent) : void
      {
         this.onGroupMessage(evt);
      }

      protected function onGroupMessage(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = null;
         var str:String = null;
         var gEvent:GamenetEvent = null;
         var msg:Object = null;
         var senderJID:String = null;
         var recipientJID:String = null;
         var chat:ChatData = null;
         var senderIsMe:Boolean = false;
         var dec:String = null;
         var mEvent:MatchDataEvent = null;
         var lEvent:LobbyDataEvent = null;
         var chatMsg:String = null;
         var player:PlayerData = null;
         var time:int = 0;
         try
         {
            senderJID = evt.data.from.toString().match(/\/(\w+$)/)[1];
         }
         catch(e:Error)
         {
         }
         try
         {
            recipientJID = evt.data.to.toString().match(/^(\w+)/)[1];
         }
         catch(e:Error)
         {
         }
         try
         {
            senderIsMe = senderJID == AppComponents.gamenetManager.currentPlayer.playerJid;
         }
         catch(e:Error)
         {
         }
         if(evt.data.body)
         {
            msg = MessageSerializer.getInstance().deserialize(evt.data.body);
            if(msg.type == MessageSerializer.TYPE_GAMEACTION)
            {
               this._logger.log("Game action received");
               gEvent = new GamenetEvent(GamenetEvent.GAME_ACTION);
               gEvent.sender = senderJID;
               gEvent.recipient = recipientJID;
               if(msg.data)
               {
                  gEvent.data = msg.data;
               }
               else if(msg.edata)
               {
                  dec = RC4.decrypt(msg.edata,senderJID);
                  gEvent.data = JSON.deserialize(dec);
               }
               if(this.shouldReceiveGameEvent(msg))
               {
                  this.gamenetManager.gamenetController.dispatchEvent(gEvent);
               }
            }
            else if(msg.type == MessageSerializer.TYPE_MATCHMAKINGEVENT)
            {
               this._logger.log("Match event received");
               mEvent = new MatchDataEvent(msg.event.type);
               mEvent.sender = senderJID;
               mEvent.recipient = recipientJID;
               mEvent.data = msg.event.data;
               dispatchEvent(mEvent);
            }
            else if(msg.type == MessageSerializer.TYPE_LOBBYEVENT)
            {
               this._logger.log("Match event received");
               lEvent = new LobbyDataEvent(msg.event.type);
               lEvent.sender = senderJID;
               lEvent.recipient = recipientJID;
               lEvent.data = msg.event.data;
               dispatchEvent(lEvent);
            }
            else if(msg.type == MessageSerializer.TYPE_NOTIFICATION)
            {
               this._logger.log("Notification received");
               chat = new ChatData();
               try
               {
                  chat.message = msg.data.body;
               }
               catch(e:Error)
               {
               }
               this._chatMessages.addItem(chat);
               gEvent = new GamenetEvent(GamenetEvent.NOTIFICATION);
               gEvent.sender = senderJID;
               gEvent.recipient = recipientJID;
               gEvent.data = msg.data;
               this.gamenetManager.gamenetController.dispatchEvent(gEvent);
            }
            else if(msg.type == MessageSerializer.TYPE_CHAT)
            {
               this._logger.log("Chat message received");
               chat = new ChatData();
               try
               {
                  chatMsg = msg.data.body;
               }
               catch(e:Error)
               {
               }
               try
               {
                  if(senderJID != this.gamenetManager.currentPlayer.playerJid)
                  {
                     chatMsg = this.gamenetManager.gamenetController.chatInFilter(chatMsg);
                  }
               }
               catch(e:Error)
               {
               }
               chat.message = chatMsg;
               player = this.findPlayerForChat(senderJID);
               chat.player = player;
               chat.message = chatMsg;
               chat.muted = this.isChatSenderMuted(chat);
               this._chatMessages.addItem(chat);
               gEvent = new GamenetEvent(GamenetEvent.CHAT);
               gEvent.sender = senderJID;
               gEvent.recipient = recipientJID;
               gEvent.data = msg.data;
               this.gamenetManager.gamenetController.dispatchEvent(gEvent);
            }
            else if(msg.type == MessageSerializer.TYPE_PING)
            {
               if(senderIsMe && msg.data && msg.data.ts)
               {
                  time = (getTimer() - msg.data.ts) / 2;
                  this._logger.log("Ping received ",msg,msg.data,time);
                  this.updatePingTime(time);
               }
            }
            else
            {
               this._logger.log("Generic group message received ",msg);
               event = new RoomDataEvent("");
               event = this.cloneXIFFRoomEvent(evt);
               dispatchEvent(event);
            }
            return;
         }
      }

      private function onRoomJoin(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onRoomLeave(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onAffiliations(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onAdminError(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      protected function onUserDeparture(event:RoomEvent) : void
      {
         var presence:Presence = event.data as Presence;
         var presenceJID:UnescapedJID = DataUtil.normalizeJID(presence.from.unescaped);
         if(this.participants.containsItemAtKey(presenceJID.node))
         {
            this.participants.removeItemAtKey(presenceJID.node);
         }
         var roomDataEvent:RoomDataEvent = this.cloneXIFFRoomEvent(event);
         dispatchEvent(roomDataEvent);
      }

      protected function onUserJoin(event:RoomEvent) : void
      {
         var playerExtension:PlayerExtension = null;
         var roomDataEvent:RoomDataEvent = null;
         var presence:Presence = event.data as Presence;
         var presenceJID:UnescapedJID = DataUtil.normalizeJID(presence.from.unescaped);
         var playerExtensions:Array = presence._exts[PlayerExtension.NS];
         for each(playerExtension in playerExtensions)
         {
            if(this._participants.containsItemAtKey(presenceJID.node))
            {
               this._participants.removeItemAtKey(presenceJID.node);
            }
            this._participants.addItem(presenceJID.node,playerExtension);
         }
         roomDataEvent = this.cloneXIFFRoomEvent(event);
         dispatchEvent(roomDataEvent);
      }

      private function onNickConflict(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onConfigureRoom(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onConfigureRoomComplete(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onDeclined(evt:RoomEvent) : void
      {
         var event:RoomDataEvent = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function onUserPresenceChange(evt:RoomEvent) : void
      {
         var playerExtension:PlayerExtension = null;
         var event:RoomDataEvent = null;
         var presence:Presence = evt.data as Presence;
         var presenceJID:UnescapedJID = DataUtil.normalizeJID(presence.from.unescaped);
         var playerExtensions:Array = presence._exts[PlayerExtension.NS];
         for each(playerExtension in playerExtensions)
         {
            if(this._participants.containsItemAtKey(presenceJID.node))
            {
               this._participants.setItemAtKey(playerExtension,presenceJID.node);
            }
         }
         event = this.cloneXIFFRoomEvent(evt);
         dispatchEvent(event);
      }

      private function cloneXIFFRoomEvent(evt:RoomEvent) : RoomDataEvent
      {
         var event:RoomDataEvent = new RoomDataEvent(evt.type);
         event.subject = evt.subject;
         event.data = evt.data;
         event.errorCondition = evt.errorCondition;
         event.errorMessage = evt.errorMessage;
         event.errorType = evt.errorType;
         event.errorCode = evt.errorCode;
         event.from = evt.from;
         event.nickname = evt.nickname;
         event.reason = evt.reason;
         return event;
      }

      protected function onPingTimer(event:TimerEvent) : void
      {
         var obj:Object = {
            "type":MessageSerializer.TYPE_PING,
            "data":{"ts":getTimer()}
         };
         this._xmppRoom.sendPrivateMessage(this.gamenetManager.currentPlayer.playerJid,MessageSerializer.getInstance().serialize(obj));
         this._pingTimer.delay = this.defaultPingInterval;
      }

      protected function onRoomError(event:RoomEvent) : void
      {
         var evt:RoomDataEvent = new RoomDataEvent(RoomDataEvent.GENERIC_ERROR);
         dispatchEvent(evt);
      }

      public function testAddChat(str:String) : void
      {
         var chat:ChatData = new ChatData();
         chat.message = str;
         this.chatMessages.addItem(chat);
      }

      public function testAddPlayer(name:String, photo:String, id:String) : void
      {
         var player:PlayerData = new PlayerData();
         player.profilePhoto = photo;
         player.profileName = name;
         player.profileId = id;
         this.players.addItem(player);
      }
   }
}
