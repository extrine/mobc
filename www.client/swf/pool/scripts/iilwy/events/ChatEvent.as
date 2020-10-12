package iilwy.events
{
   import flash.events.Event;
   import iilwy.chat.ChatManager;
   import iilwy.data.PageCommand;
   import iilwy.model.dataobjects.chat.ChatMessage;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.chat.extensions.jingle.JingleExtension;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class ChatEvent extends DataResponderEvent
   {
      
      public static const AUTHORIZE_CHAT_USER:String = "iilwy.events.ChatEvent.AUTHORIZE_CHAT_USER";
      
      public static const BAN_CHAT_USER:String = "iilwy.events.ChatEvent.BAN_CHAT_USER";
      
      public static const CHAT_ROOM_ERROR:String = "iilwy.events.ChatEvent.CHAT_ROOM_ERROR";
      
      public static const CHAT_ROOM_JINGLE:String = "iilwy.events.ChatEvent.CHAT_ROOM_JINGLE";
      
      public static const CLOSE_ONLINE_FRIENDS_LIST:String = "iilwy.events.ChatEvent.CLOSE_ONLINE_FRIENDS_LIST";
      
      public static const CONNECT_TO_CHAT_SERVER:String = "iilwy.events.ChatEvent.CONNECT_TO_CHAT_SERVER";
      
      public static const CONNECT_TO_VOICE_CHAT_SERVER:String = "iilwy.events.ChatEvent.CONNECT_TO_VOICE_CHAT_SERVER";
      
      public static const CONNECTED_TO_VOICE_CHAT_SERVER:String = "iilwy.events.ChatEvent.CONNECTED_TO_VOICE_CHAT_SERVER";
      
      public static const DISABLE_VOICE_CHAT:String = "iilwy.events.ChatEvent.DISABLE_VOICE_CHAT";
      
      public static const DISCONNECTED_FROM_CHAT_SERVER:String = "iilwy.events.ChatEvent.DISCONNECTED_FROM_CHAT_SERVER";
      
      public static const ENABLE_VOICE_CHAT:String = "iilwy.events.ChatEvent.ENABLE_VOICE_CHAT";
      
      public static const GET_CHAT_ROOM_INDEX:String = "iilwy.events.ChatEvent.GET_CHAT_ROOM_INDEX";
      
      public static const GET_CHAT_ROOMS_CONTENT:String = "iilwy.events.ChatEvent.GET_CHAT_ROOMS_CONTENT";
      
      public static const GRANT_CHAT_USER_PRIVILEGE:String = "iilwy.events.ChatEvent.GRANT_CHAT_USER_PRIVILEGE";
      
      public static const JOIN_CHAT_ROOM:String = "iilwy.events.ChatEvent.JOIN_CHAT_ROOM";
      
      public static const JOIN_CHAT_USER:String = "iilwy.events.ChatEvent.JOIN_CHAT_USER";
      
      public static const JOIN_GAME_CHAT_ROOM:String = "iilwy.events.ChatEvent.JOIN_GAME_CHAT_ROOM";
      
      public static const JOIN_INITIAL_CHAT_ROOMS:String = "iilwy.events.ChatEvent.JOIN_INITIAL_CHAT_ROOMS";
      
      public static const JOIN_INITIAL_CHAT_ROOMS_COMPLETE:String = "iilwy.events.ChatEvent.JOIN_INITIAL_CHAT_ROOMS_COMPLETE";
      
      public static const KICK_CHAT_USER:String = "iilwy.events.ChatEvent.KICK_CHAT_USER";
      
      public static const LEAVE_CHAT_ROOM:String = "iilwy.events.ChatEvent.LEAVE_CHAT_ROOM";
      
      public static const LOGGED_INTO_CHAT_SERVER:String = "iilwy.events.ChatEvent.LOGGED_INTO_CHAT_SERVER";
      
      public static const MESSAGE:String = "iilwy.events.ChatEvent.MESSAGE";
      
      public static const MINIMIZE_CHAT_ROOM_WINDOW:String = "iilwy.events.ChatEvent.MINIMIZE_CHAT_ROOM_WINDOW";
      
      public static const OPEN_CHAT:String = "iilwy.events.ChatEvent.OPEN_CHAT";
      
      public static const OPEN_CHAT_AND_SEND_MESSAGE:String = "iilwy.events.ChatEvent.OPEN_CHAT_AND_SEND_MESSAGE";
      
      public static const OPEN_CHAT_ROOM:String = "iilwy.events.ChatEvent.OPEN_CHAT_ROOM";
      
      public static const OPEN_ONLINE_FRIENDS_LIST:String = "iilwy.events.ChatEvent.OPEN_ONLINE_FRIENDS_LIST";
      
      public static const REVOKE_CHAT_USER_PRIVILEGE:String = "iilwy.events.ChatEvent.REVOKE_CHAT_USER_PRIVILEGE";
      
      public static const ROOM_PASS_UPDATE:String = "iilwy.events.ChatEvent.ROOM_PASS_UPDATE";
      
      public static const SET_CHAT_ROOM_WINDOW_VIEW:String = "iilwy.events.ChatEvent.SET_CHAT_ROOM_WINDOW_VIEW";
      
      public static const UPDATE_CHAT_ROOM:String = "iilwy.events.ChatEvent.UPDATE_CHAT_ROOM";
      
      public static const VOICE_CHAT_DISABLED:String = "iilwy.events.ChatEvent.VOICE_CHAT_DISABLED";
      
      public static const VOICE_CHAT_ENABLED:String = "iilwy.events.ChatEvent.VOICE_CHAT_ENABLED";
       
      
      public var chatManager:ChatManager;
      
      public var serverURL:String;
      
      public var chatRoomUser:ChatRoomUser;
      
      public var chatRoom:ChatRoom;
      
      public var chatRoomJIDNode:String;
      
      public var chatRoomDisplayName:String;
      
      public var chatRoomIsPrivate:Boolean;
      
      public var createRoom:Boolean;
      
      public var chatRoomWindowView:String;
      
      public var roomListScreen:String;
      
      public var showProcess:Boolean;
      
      public var privilege:String;
      
      public var chatUser:ChatUser;
      
      public var chatMessage:ChatMessage;
      
      public var voiceChatChannel:UnescapedJID;
      
      public var jingle:JingleExtension;
      
      public var pageCommand:PageCommand;
      
      public var profileID:String;
      
      public function ChatEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         super(type,bubbles,cancelable,data);
      }
      
      override public function clone() : Event
      {
         var chatEvent:ChatEvent = new ChatEvent(type,bubbles,cancelable,data);
         chatEvent.responder = responder;
         chatEvent.chatManager = this.chatManager;
         chatEvent.serverURL = this.serverURL;
         chatEvent.chatRoomUser = this.chatRoomUser;
         chatEvent.chatRoom = this.chatRoom;
         chatEvent.chatRoomJIDNode = this.chatRoomJIDNode;
         chatEvent.chatRoomDisplayName = this.chatRoomDisplayName;
         chatEvent.chatRoomIsPrivate = this.chatRoomIsPrivate;
         chatEvent.createRoom = this.createRoom;
         chatEvent.chatRoomWindowView = this.chatRoomWindowView;
         chatEvent.roomListScreen = this.roomListScreen;
         chatEvent.showProcess = this.showProcess;
         chatEvent.privilege = this.privilege;
         chatEvent.chatUser = this.chatUser;
         chatEvent.chatMessage = this.chatMessage;
         chatEvent.voiceChatChannel = this.voiceChatChannel;
         chatEvent.jingle = this.jingle;
         chatEvent.pageCommand = Boolean(this.pageCommand)?this.pageCommand.clone():null;
         chatEvent.profileID = this.profileID;
         return chatEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ChatEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
