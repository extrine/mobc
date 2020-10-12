package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class RoomEvent extends Event
   {
      
      public static const ADMIN_ERROR:String = "adminError";
      
      public static const AFFILIATION_CHANGE_COMPLETE:String = "affiliationChangeComplete";
      
      public static const AFFILIATIONS:String = "affiliations";
      
      public static const BANNED_ERROR:String = "bannedError";
      
      public static const CONFIGURE_ROOM:String = "configureRoom";
      
      public static const CONFIGURE_ROOM_COMPLETE:String = "configureRoomComplete";
      
      public static const DECLINED:String = "declined";
      
      public static const GROUP_MESSAGE:String = "groupMessage";
      
      public static const LOCKED_ERROR:String = "lockedError";
      
      public static const MAX_USERS_ERROR:String = "maxUsersError";
      
      public static const NICK_CONFLICT:String = "nickConflict";
      
      public static const PASSWORD_ERROR:String = "passwordError";
      
      public static const PRIVATE_MESSAGE:String = "privateMessage";
      
      public static const REGISTRATION_REQ_ERROR:String = "registrationReqError";
      
      public static const ROOM_DESTROYED:String = "roomDestroyed";
      
      public static const ROOM_JOIN:String = "roomJoin";
      
      public static const ROOM_LEAVE:String = "roomLeave";
      
      public static const SUBJECT_CHANGE:String = "subjectChange";
      
      public static const USER_BANNED:String = "userBanned";
      
      public static const USER_DEPARTURE:String = "userDeparture";
      
      public static const USER_JOIN:String = "userJoin";
      
      public static const USER_KICKED:String = "userKicked";
      
      public static const USER_PRESENCE_CHANGE:String = "userPresenceChange";
       
      
      private var _data;
      
      private var _errorCode:uint;
      
      private var _errorCondition:String;
      
      private var _errorMessage:String;
      
      private var _errorType:String;
      
      private var _from:String;
      
      private var _nickname:String;
      
      private var _reason:String;
      
      private var _subject:String;
      
      public function RoomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var event:RoomEvent = new RoomEvent(type,bubbles,cancelable);
         event.subject = this._subject;
         event.data = this._data;
         event.errorCondition = this._errorCondition;
         event.errorMessage = this._errorMessage;
         event.errorType = this._errorType;
         event.errorCode = this._errorCode;
         event.nickname = this._nickname;
         event.from = this._from;
         event.reason = this._reason;
         return event;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(value:*) : void
      {
         this._data = value;
      }
      
      public function get errorCode() : uint
      {
         return this._errorCode;
      }
      
      public function set errorCode(value:uint) : void
      {
         this._errorCode = value;
      }
      
      public function get errorCondition() : String
      {
         return this._errorCondition;
      }
      
      public function set errorCondition(value:String) : void
      {
         this._errorCondition = value;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
      
      public function set errorMessage(value:String) : void
      {
         this._errorMessage = value;
      }
      
      public function get errorType() : String
      {
         return this._errorType;
      }
      
      public function set errorType(value:String) : void
      {
         this._errorType = value;
      }
      
      public function get from() : String
      {
         return this._from;
      }
      
      public function set from(value:String) : void
      {
         this._from = value;
      }
      
      public function get nickname() : String
      {
         return this._nickname;
      }
      
      public function set nickname(value:String) : void
      {
         this._nickname = value;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
      
      public function set reason(value:String) : void
      {
         this._reason = value;
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function set subject(value:String) : void
      {
         this._subject = value;
      }
      
      override public function toString() : String
      {
         return "[RoomEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
