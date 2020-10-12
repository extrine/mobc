package iilwy.gamenet.events
{
   import flash.events.Event;
   
   public class RoomDataEvent extends Event
   {
      
      public static var SUBJECT_CHANGE:String = "subjectChange";
      
      public static var GROUP_MESSAGE:String = "groupMessage";
      
      public static var GAME_EVENT:String = "gameEvent";
      
      public static var PRIVATE_MESSAGE:String = "privateMessage";
      
      public static var ROOM_JOIN:String = "roomJoin";
      
      public static var ROOM_LEAVE:String = "roomLeave";
      
      public static var AFFILIATIONS:String = "affiliations";
      
      public static var ADMIN_ERROR:String = "adminError";
      
      public static var USER_JOIN:String = "userJoin";
      
      public static var USER_DEPARTURE:String = "userDeparture";
      
      public static var NICK_CONFLICT:String = "nickConflict";
      
      public static var CONFIGURE_ROOM:String = "configureRoom";
      
      public static var CONFIGURE_ROOM_COMPLETE:String = "configureRoomComplete";
      
      public static var DECLINED:String = "declined";
      
      public static var ROOM_JOIN_TIMEOUT:String = "roomJoinTimeout";
      
      public static var USER_PRESENCE_CHANGE:String = "userPresenceChange";
      
      public static var REFRESH_MATCHES_TIMEOUT:String = "refreshMatchesTimeout";
      
      public static var MATCHES_REFRESHED:String = "refreshedMatches";
      
      public static var SERVICE_INFO_SET:String = "serviceInfoSet";
      
      public static var GENERIC_ERROR:String = "genericError";
       
      
      private var _subject:String;
      
      private var _data;
      
      private var _errorCondition:String;
      
      private var _errorMessage:String;
      
      private var _errorType:String;
      
      private var _errorCode:Number;
      
      private var _nickname:String;
      
      private var _from:String;
      
      private var _reason:String;
      
      public function RoomDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public function set subject(s:String) : void
      {
         this._subject = s;
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function set data(s:*) : void
      {
         this._data = s;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set errorCondition(s:String) : void
      {
         this._errorCondition = s;
      }
      
      public function get errorCondition() : String
      {
         return this._errorCondition;
      }
      
      public function set errorMessage(s:String) : void
      {
         this._errorMessage = s;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
      
      public function set errorType(s:String) : void
      {
         this._errorType = s;
      }
      
      public function get errorType() : String
      {
         return this._errorType;
      }
      
      public function set errorCode(s:Number) : void
      {
         this._errorCode = s;
      }
      
      public function get errorCode() : Number
      {
         return this._errorCode;
      }
      
      public function set nickname(s:String) : void
      {
         this._nickname = s;
      }
      
      public function get nickname() : String
      {
         return this._nickname;
      }
      
      public function set from(s:String) : void
      {
         this._from = s;
      }
      
      public function get from() : String
      {
         return this._from;
      }
      
      public function set reason(s:String) : void
      {
         this._reason = s;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
   }
}
