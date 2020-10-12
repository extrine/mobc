package iilwy.chat
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.collections.DictionaryCollection;
   import iilwy.display.chat.ChatRoomWindow;
   import iilwy.events.ArcadeEvent;
   import iilwy.events.AsyncEvent;
   import iilwy.events.ChatEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.chat.GameChatRoom;
   import iilwy.model.dataobjects.chat.extensions.jingle.JingleExtension;
   import iilwy.model.dataobjects.metagame.MetagameSiteLevel;
   import iilwy.model.local.LocalProperties;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class ChatRoomManager extends EventDispatcher
   {
      
      public static const MAX_ROOMS:int = 5;
      
      public static const MIN_ROOMS:int = 0;
      
      public static const ROOM_PASSES:Array = [{
         "jidNode":"d5083670f58f09ab7f6c254b6df3d79a",
         "displayName":"SecondhandSerenade"
      }];
       
      
      private var _rooms:DictionaryCollection;
      
      private var _lastOpenRoom:ChatRoom;
      
      private var _initialRoomsJoined:Boolean;
      
      private var _allChatRoomsActive:Boolean;
      
      private var _window:ChatRoomWindow;
      
      private var _roomPass:Boolean;
      
      private var _chatRoomsContent:Object;
      
      private var _gameChatRoom:GameChatRoom;
      
      private var storedRoomJIDNodes:Array;
      
      private var initialized:Boolean;
      
      private var chatServerInitialized:Boolean;
      
      private var joinInitialRoomsResponder:Responder;
      
      private var chatRoomsContentInitialized:Boolean;
      
      private var chatRoomsContentResponder:Responder;
      
      public function ChatRoomManager()
      {
         this._chatRoomsContent = {};
         super();
         this._lastOpenRoom = new ChatRoom();
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_EARNED_EXPERIENCE_DATA,this.onEarnedExperience);
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
         StageReference.stage.addEventListener(ChatEvent.LOGGED_INTO_CHAT_SERVER,this.onLoggedIntoChatServer);
         StageReference.stage.addEventListener(ChatEvent.JOIN_INITIAL_CHAT_ROOMS_COMPLETE,this.onJoinInitialChatRoomsComplete);
         StageReference.stage.addEventListener(ChatEvent.DISCONNECTED_FROM_CHAT_SERVER,this.onDisconnectedFromChatServer);
      }
      
      public function get rooms() : DictionaryCollection
      {
         return this._rooms;
      }
      
      public function get lastOpenRoom() : ChatRoom
      {
         try
         {
            this._rooms.getItemAtKey(this._lastOpenRoom.jidNode);
         }
         catch(error:Error)
         {
            _lastOpenRoom = _rooms && _rooms.length > 0?_rooms.getItemAt(0) as ChatRoom:null;
         }
         return this._lastOpenRoom;
      }
      
      public function set lastOpenRoom(value:ChatRoom) : void
      {
         this._lastOpenRoom = value;
      }
      
      public function get initialRoomsJoined() : Boolean
      {
         return this._initialRoomsJoined;
      }
      
      public function get anyChatRoomsActive() : Boolean
      {
         var chatRoom:ChatRoom = null;
         if(!this._rooms)
         {
            return false;
         }
         var roomsArray:Array = this._rooms.toArray();
         var len:int = this._rooms.length;
         for(var i:int = 0; i < len; i++)
         {
            chatRoom = roomsArray[i].value as ChatRoom;
            if(chatRoom.room.isActive)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get allChatRoomsActive() : Boolean
      {
         var chatRoom:ChatRoom = null;
         if(!this._allChatRoomsActive)
         {
            return false;
         }
         var roomsArray:Array = this._rooms.toArray();
         var len:int = this._rooms.length;
         for(var i:int = 0; i < len; i++)
         {
            chatRoom = roomsArray[i].value as ChatRoom;
            if(!chatRoom.room.isActive)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get window() : ChatRoomWindow
      {
         return this._window;
      }
      
      public function set window(value:ChatRoomWindow) : void
      {
         this._window = value;
      }
      
      public function get roomPass() : Boolean
      {
         return this._roomPass;
      }
      
      public function set roomPass(value:Boolean) : void
      {
         if(value == this._roomPass)
         {
            return;
         }
         this._roomPass = value;
         StageReference.stage.dispatchEvent(new ChatEvent(ChatEvent.ROOM_PASS_UPDATE,true,true));
      }
      
      public function get chatRoomsContent() : Object
      {
         return this._chatRoomsContent;
      }
      
      public function get gameChatRoom() : GameChatRoom
      {
         return this._gameChatRoom;
      }
      
      public function isJoinedTo(roomJIDNode:String) : Boolean
      {
         var chatRoom:ChatRoom = null;
         var roomsArray:Array = this._rooms.toArray();
         var len:int = roomsArray.length;
         for(var i:int = 0; i < len; i++)
         {
            chatRoom = roomsArray[i].value as ChatRoom;
            if(chatRoom.jidNode == roomJIDNode)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getInitialChatRooms() : Array
      {
         var roomPassStored:Boolean = false;
         var storedRoomJIDNode:String = null;
         var roomPass:Object = null;
         var stored:Array = AppComponents.localStore.getUserSpecificObject(LocalProperties.STORED_CHAT_ROOMS) as Array;
         this.storedRoomJIDNodes = Boolean(stored)?stored:[];
         this.storedRoomJIDNodes = this.storedRoomJIDNodes.slice(0,MAX_ROOMS);
         if(this.roomPass)
         {
            if(stored)
            {
               loop0:
               for each(storedRoomJIDNode in this.storedRoomJIDNodes)
               {
                  for each(roomPass in ROOM_PASSES)
                  {
                     if(roomPass.jidNode == storedRoomJIDNode)
                     {
                        roomPassStored = true;
                        break loop0;
                     }
                  }
               }
            }
            this.storedRoomJIDNodes = !!roomPassStored?[storedRoomJIDNode]:[];
         }
         var initialRoomIDs:Array = this.storedRoomJIDNodes.slice();
         return initialRoomIDs;
      }
      
      public function getRoomOverview(room:ChatRoom) : String
      {
         var subject:String = room.room.subject;
         var numOccupants:String = room.numOccupants.toString() + " Active Users";
         var overview:Array = [];
         if(subject)
         {
            overview.push(subject);
         }
         overview.push(numOccupants);
         return overview.join(" // ");
      }
      
      public function updateChatUserStatus(chatRoom:ChatRoom) : void
      {
         var statusEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
         statusEvent.playerStatus = new PlayerStatus();
         statusEvent.playerStatus.chatting(chatRoom);
         StageReference.stage.dispatchEvent(statusEvent);
      }
      
      public function addRoom(room:ChatRoom) : void
      {
         room.addEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage,false,0,true);
         if(room is GameChatRoom)
         {
            this._gameChatRoom = room as GameChatRoom;
            return;
         }
         this._rooms.addItem(room.jidNode,room);
         this.addStoredChatRoom(room);
      }
      
      public function removeRoom(room:ChatRoom) : void
      {
         if(room)
         {
            this._rooms.removeItemAtKey(room.jidNode);
            room.leave();
            room.removeEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage);
            this.removeStoredChatRoom(room);
         }
      }
      
      private function addStoredChatRoom(room:ChatRoom) : void
      {
         var storedRoomJIDNode:* = undefined;
         for each(storedRoomJIDNode in this.storedRoomJIDNodes)
         {
            if(storedRoomJIDNode == room.jidNode)
            {
               return;
            }
         }
         this.storedRoomJIDNodes.push(room.jidNode);
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.STORED_CHAT_ROOMS,this.storedRoomJIDNodes);
         AppComponents.localStore.flushQueuedObjects();
      }
      
      private function removeStoredChatRoom(room:ChatRoom) : void
      {
         for(var i:int = 0; i < this.storedRoomJIDNodes.length; i++)
         {
            if(this.storedRoomJIDNodes[i] == room.jidNode)
            {
               this.storedRoomJIDNodes.splice(i,1);
            }
         }
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.STORED_CHAT_ROOMS,this.storedRoomJIDNodes);
         AppComponents.localStore.flushQueuedObjects();
      }
      
      private function joinInitialRooms() : void
      {
         this.joinInitialRoomsResponder = new Responder();
         this.joinInitialRoomsResponder.setAsyncListeners(this.onJoinInitialRoomsSuccess,this.onJoinInitialRoomsSuccess);
         var joinInitialRoomsEvent:ChatEvent = new ChatEvent(ChatEvent.JOIN_INITIAL_CHAT_ROOMS);
         joinInitialRoomsEvent.responder = this.joinInitialRoomsResponder;
         StageReference.stage.dispatchEvent(joinInitialRoomsEvent);
      }
      
      private function getChatRoomsContent() : void
      {
         this.chatRoomsContentResponder = new Responder();
         this.chatRoomsContentResponder.setAsyncListeners(this.onChatRoomsContentSuccess,this.onChatRoomsContentFail);
         var chatRoomsContentEvent:ChatEvent = new ChatEvent(ChatEvent.GET_CHAT_ROOMS_CONTENT);
         chatRoomsContentEvent.responder = this.chatRoomsContentResponder;
         StageReference.stage.dispatchEvent(chatRoomsContentEvent);
      }
      
      public function initialize() : void
      {
         if(!this.initialized && this.chatServerInitialized && this.chatRoomsContentInitialized)
         {
            if(AppComponents.model.privateUser.isLoggedIn && (AppComponents.model.privateUser.profile.experience.level >= MetagameSiteLevel.CHAT_ROOMS || this.roomPass))
            {
               this.initialized = true;
               this.setupRooms();
               this.joinInitialRooms();
            }
         }
      }
      
      public function deinitialize() : void
      {
         var roomsArray:Array = null;
         var len:int = 0;
         var i:int = 0;
         var chatRoom:ChatRoom = null;
         if(this._rooms)
         {
            roomsArray = this._rooms.toArray();
            len = roomsArray.length;
            for(i = 0; i < len; i++)
            {
               chatRoom = roomsArray[i].value as ChatRoom;
               chatRoom.leave();
            }
            this._rooms.clearSource();
         }
         if(this._gameChatRoom)
         {
            this._gameChatRoom.leave();
         }
         this._gameChatRoom = null;
         this.initialized = false;
      }
      
      private function setupRooms() : void
      {
         var len:int = 0;
         var room:ChatRoom = null;
         var i:int = 0;
         if(this._rooms)
         {
            len = this._rooms.length;
            for(i = 0; i < len; i++)
            {
               room = this._rooms.getItemAt(i);
               room.leave();
            }
         }
         this._rooms = new DictionaryCollection();
      }
      
      private function onEarnedExperience(event:UserDataEvent) : void
      {
         if(AppComponents.model.privateUser.profile.experience.level >= MetagameSiteLevel.CHAT_ROOMS)
         {
            this.roomPass = false;
         }
      }
      
      private function onLoginChanged(event:UserDataEvent) : void
      {
         if(!AppComponents.model.privateUser.isLoggedIn)
         {
            this.deinitialize();
            this.chatRoomsContentInitialized = false;
            this.chatServerInitialized = false;
            this.roomPass = false;
         }
         else if(!this.chatRoomsContentInitialized)
         {
            this.getChatRoomsContent();
            return;
         }
      }
      
      private function onLoggedIntoChatServer(event:ChatEvent) : void
      {
         if(this.chatServerInitialized || !AppProperties.appVersionIsWebsiteOrAIR)
         {
            return;
         }
         this.chatServerInitialized = true;
         this.initialize();
      }
      
      private function onJoinInitialRoomsSuccess(event:AsyncEvent) : void
      {
         StageReference.stage.dispatchEvent(new ChatEvent(ChatEvent.JOIN_INITIAL_CHAT_ROOMS_COMPLETE));
      }
      
      private function onChatRoomsContentSuccess(event:AsyncEvent) : void
      {
         if(this.chatRoomsContentInitialized)
         {
            return;
         }
         this._chatRoomsContent = event.data;
         this.chatRoomsContentInitialized = true;
         this.initialize();
      }
      
      private function onChatRoomsContentFail(event:AsyncEvent) : void
      {
         if(this.chatRoomsContentInitialized)
         {
            return;
         }
         this.chatRoomsContentInitialized = true;
         this.initialize();
      }
      
      private function onJoinInitialChatRoomsComplete(event:ChatEvent) : void
      {
         this._initialRoomsJoined = true;
         this._allChatRoomsActive = this.storedRoomJIDNodes.length == this.rooms.length;
      }
      
      private function onDisconnectedFromChatServer(event:ChatEvent) : void
      {
         this._initialRoomsJoined = false;
      }
      
      private function onGroupMessage(event:RoomEvent) : void
      {
         var jingleExtension:JingleExtension = null;
         var jingleExtensions:Array = null;
         var message:Message = event.data as Message;
         var room:ChatRoom = !!this._rooms.containsItemAtKey(message.from.unescaped.node)?this._rooms.getItemAtKey(message.from.unescaped.node):null;
         if(!room)
         {
            return;
         }
         var chatUser:ChatUser = !!room.users.containsItemAtKey(event.nickname)?room.users.getItemAtKey(event.nickname):null;
         if(!message.time)
         {
            jingleExtensions = message._exts[JingleExtension.NS];
            if(jingleExtensions)
            {
               jingleExtension = jingleExtensions[0];
            }
         }
         if(chatUser || jingleExtension)
         {
            dispatchEvent(event);
         }
      }
   }
}
