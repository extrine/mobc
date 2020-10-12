package iilwy.gamenet.model
{
   import iilwy.application.AppComponents;
   import iilwy.model.dataobjects.ArcadeData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.utils.TextUtil;
   
   public class PlayerStatus
   {
      
      public static const TYPE_CHATTING:String = "chatting";
      
      public static const TYPE_IDLE:String = "idle";
      
      public static const TYPE_LOBBY:String = "lobby";
      
      public static const TYPE_OFFLINE:String = "offline";
      
      public static const TYPE_ONLINE:String = "online";
      
      public static const TYPE_PLAYING:String = "playing";
      
      public static const TYPE_READY:String = "ready";
      
      protected static const LABEL_CHATTING_PRIVATE:String = "Chatting";
      
      protected static const LABEL_CHATTING_PUBLIC:String = "Chatting in #chatRoomDisplayName#";
      
      protected static const LABEL_IDLE:String = "Idle";
      
      protected static const LABEL_LAST_SEEN_PLAYING:String = "Last seen playing #gameTitle#";
      
      protected static const LABEL_LOBBY:String = "Looking for a #gameTitle# match";
      
      protected static const LABEL_OFFLINE:String = "Offline";
      
      protected static const LABEL_ONLINE:String = "Online";
      
      protected static const LABEL_PLAYING:String = "Playing #gameTitle#";
      
      protected static const LABEL_READY:String = "Waiting to play #gameTitle#";
      
      protected static const CHAT_ROOM_DISPLAY_NAME_PATTERN:RegExp = /#chatRoomDisplayName#/;
      
      protected static const GAME_TITLE_PATTERN:RegExp = /#gameTitle#/;
       
      
      public var jid:String;
      
      public var serverID:int = -1;
      
      public var serverURL:String;
      
      public var gameId:String;
      
      public var type:String;
      
      public var description:String;
      
      public var gameTitle:String;
      
      public var timeStamp:Date;
      
      public function PlayerStatus()
      {
         super();
         this.offline();
      }
      
      public static function createFromApiResult(data:*) : PlayerStatus
      {
         var s:PlayerStatus = new PlayerStatus();
         s.gameId = data.game_id;
         if(data.game_title)
         {
            s.gameTitle = data.game_title;
         }
         else
         {
            s.gameTitle = AppComponents.model.arcade.getGameTitleById(data.game_id);
            if(!s.gameTitle)
            {
               s.gameTitle = data.game_id;
            }
         }
         s.jid = data.jid;
         if(data.server_id)
         {
            s.serverID = data.server_id;
         }
         if(data.server)
         {
            s.serverURL = data.server;
         }
         s.type = data.type;
         s.description = data.description;
         if(data.modified_at)
         {
            s.timeStamp = new Date(data.modified_at);
         }
         if((s.type == PlayerStatus.TYPE_OFFLINE || s.type == PlayerStatus.TYPE_IDLE || s.type == PlayerStatus.TYPE_ONLINE) && s.gameTitle)
         {
            s.description = TextUtil.replaceMultiple(LABEL_LAST_SEEN_PLAYING,[GAME_TITLE_PATTERN],[s.gameTitle]);
         }
         return s;
      }
      
      public static function createFromDescription(description:String) : PlayerStatus
      {
         var pattern:RegExp = null;
         var result:Array = null;
         var status:PlayerStatus = new PlayerStatus();
         status.description = description;
         var arcade:ArcadeData = AppComponents.model.arcade;
         pattern = new RegExp(TextUtil.replaceMultiple(LABEL_CHATTING_PUBLIC,[CHAT_ROOM_DISPLAY_NAME_PATTERN],["(.+)"]));
         result = pattern.exec(description);
         if(result)
         {
            status.type = TYPE_CHATTING;
            if(result.length > 1)
            {
               status.jid = result[1];
            }
            return status;
         }
         if(description.indexOf(LABEL_CHATTING_PRIVATE) > -1)
         {
            status.type = TYPE_CHATTING;
            return status;
         }
         if(description.indexOf(LABEL_IDLE) > -1)
         {
            status.type = TYPE_IDLE;
            return status;
         }
         pattern = new RegExp(TextUtil.replaceMultiple(LABEL_LOBBY,[GAME_TITLE_PATTERN],["(.+)"]));
         result = pattern.exec(description);
         if(result)
         {
            status.type = TYPE_LOBBY;
            if(result.length > 1)
            {
               status.gameTitle = result[1];
            }
            if(status.gameTitle)
            {
               status.gameId = arcade.getGameIDByTitle(status.gameTitle);
            }
            return status;
         }
         if(description.indexOf(LABEL_OFFLINE) > -1)
         {
            status.type = TYPE_OFFLINE;
            return status;
         }
         if(description.indexOf(LABEL_ONLINE) > -1)
         {
            status.type = TYPE_ONLINE;
            return status;
         }
         pattern = new RegExp(TextUtil.replaceMultiple(LABEL_PLAYING,[GAME_TITLE_PATTERN],["(.+)"]));
         result = pattern.exec(description);
         if(result)
         {
            status.type = TYPE_PLAYING;
            if(result.length > 1)
            {
               status.gameTitle = result[1];
            }
            if(status.gameTitle)
            {
               status.gameId = arcade.getGameIDByTitle(status.gameTitle);
            }
            return status;
         }
         pattern = new RegExp(TextUtil.replaceMultiple(LABEL_READY,[GAME_TITLE_PATTERN],["(.+)"]));
         result = pattern.exec(description);
         if(result)
         {
            status.type = TYPE_READY;
            if(result.length > 1)
            {
               status.gameTitle = result[1];
            }
            if(status.gameTitle)
            {
               status.gameId = arcade.getGameIDByTitle(status.gameTitle);
            }
            return status;
         }
         return status;
      }
      
      public function clone() : PlayerStatus
      {
         var p:PlayerStatus = new PlayerStatus();
         p.copy(this);
         return p;
      }
      
      public function copy(from:PlayerStatus) : void
      {
         this.jid = from.jid;
         this.serverID = from.serverID;
         this.serverURL = from.serverURL;
         this.gameId = from.gameId;
         this.type = from.type;
         this.gameTitle = from.gameTitle;
         this.description = from.description;
      }
      
      public function ready(match:MatchData, gamePack:ArcadeGamePackData) : void
      {
         this.jid = match.roomName;
         this.serverID = match.serverID;
         this.gameId = gamePack.id;
         this.type = TYPE_READY;
         this.gameTitle = gamePack.title;
         this.description = TextUtil.replaceMultiple(LABEL_READY,[GAME_TITLE_PATTERN],[gamePack.title]);
      }
      
      public function playing(match:MatchData, gamePack:ArcadeGamePackData) : void
      {
         this.jid = match.roomName;
         this.serverID = match.serverID;
         this.gameId = gamePack.id;
         this.type = TYPE_PLAYING;
         this.gameTitle = gamePack.title;
         this.description = TextUtil.replaceMultiple(LABEL_PLAYING,[GAME_TITLE_PATTERN],[gamePack.title]);
      }
      
      public function chatting(chatRoom:ChatRoom) : void
      {
         this.jid = !!chatRoom.isPrivate?null:chatRoom.displayName;
         this.type = TYPE_CHATTING;
         this.description = !!chatRoom.isPrivate?LABEL_CHATTING_PRIVATE:TextUtil.replaceMultiple(LABEL_CHATTING_PUBLIC,[CHAT_ROOM_DISPLAY_NAME_PATTERN],[chatRoom.displayName]);
      }
      
      public function offline() : void
      {
         this.type = TYPE_OFFLINE;
         this.description = LABEL_OFFLINE;
      }
      
      public function idle() : void
      {
         this.type = TYPE_IDLE;
         this.description = LABEL_IDLE;
      }
      
      public function lobby(gamePack:ArcadeGamePackData) : void
      {
         this.gameId = gamePack.id;
         this.gameTitle = gamePack.title;
         this.type = TYPE_LOBBY;
         this.description = TextUtil.replaceMultiple(LABEL_LOBBY,[GAME_TITLE_PATTERN],[gamePack.title]);
      }
      
      public function online() : void
      {
         this.type = TYPE_ONLINE;
         this.description = LABEL_ONLINE;
      }
      
      public function get isInvitable() : Boolean
      {
         var result:Boolean = false;
         if(this.type == TYPE_ONLINE || this.type == TYPE_IDLE || this.type == TYPE_CHATTING)
         {
            result = true;
         }
         return result;
      }
      
      public function get isJoinable() : Boolean
      {
         var gamePack:ArcadeGamePackData = null;
         var isRestricted:Boolean = false;
         var result:Boolean = false;
         if(this.type == TYPE_PLAYING || this.type == TYPE_LOBBY || this.type == TYPE_READY)
         {
            gamePack = AppComponents.model.arcade.getCatalogItem(this.gameId);
            isRestricted = gamePack && gamePack.isRestricted || this.gameId && !gamePack;
            result = !isRestricted;
         }
         else if(this.type == TYPE_CHATTING)
         {
            result = this.description != LABEL_CHATTING_PRIVATE;
         }
         return result;
      }
   }
}
