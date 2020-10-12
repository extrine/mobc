package iilwy.events
{
   import flash.events.Event;
   import iilwy.display.popups.authentication.enum.LoginType;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.LoginCredentials;
   import iilwy.model.dataobjects.PartnerValues;
   import iilwy.model.dataobjects.SignupValues;
   import iilwy.model.dataobjects.user.AnswerData;
   import iilwy.model.dataobjects.user.CurrencyData;
   import iilwy.model.dataobjects.user.FeedData;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.model.dataobjects.user.PublicUserData;
   import iilwy.model.dataobjects.user.QuestionData;
   
   public class UserRequestEvent extends ResponderEvent
   {
      
      public static const GET_LOGIN_STREAK:String = "iilwy.events.UserRequestEvent.GET_LOGIN_STREAK";
      
      public static const GET_RECENT_ACHIEVEMENTS:String = "iilwy.events.UserRequestEvent.GET_RECENT_ACHIEVEMENTS";
      
      public static const PRIVATE_ACHIEVEMENTS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_ACHIEVEMENTS_REQUEST";
      
      public static const PRIVATE_ACHIEVEMENTS_BY_GAME_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_ACHIEVEMENTS_BY_GAME_REQUEST";
      
      public static const PRIVATE_ARCADE_STATS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_ARCADE_STATS_REQUEST";
      
      public static const PRIVATE_CONTACT_REQUESTS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_CONTACT_REQUESTS_REQUEST";
      
      public static const PRIVATE_CONTACT_SUGGESTIONS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_CONTACT_SUGGESTIONS_REQUEST";
      
      public static const PRIVATE_CURRENT_BALANCE_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_CURRENT_BALANCE_REQUEST";
      
      public static const PRIVATE_FEED_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_FEED_REQUEST";
      
      public static const PRIVATE_OVERVIEW_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_OVERVIEW_REQUEST";
      
      public static const PRIVATE_PHOTO_EDITOR_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_PHOTO_EDITOR_REQUEST";
      
      public static const PRIVATE_PREMIUM_ITEMS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_PREMIUM_ITEMS_REQUEST";
      
      public static const PRIVATE_QUESTIONS_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_QUESTIONS_REQUEST";
      
      public static const PRIVATE_SUBSCRIPTION_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_SUBSCRIPTION_REQUEST";
      
      public static const PRIVATE_TRANSACTION_HISTORY_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_TRANSACTION_HISTORY_REQUEST";
      
      public static const PRIVATE_AUTHENTICATE:String = "iilwy.events.UserRequestEvent.PRIVATE_AUTHENTICATE";
      
      public static const PRIVATE_GET_SESSION:String = "iilwy.events.UserRequestEvent.PRIVATE_GET_SESSION";
      
      public static const PRIVATE_INITIALIZE_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_INITIALIZE_REQUEST";
      
      public static const ANONYMOUS_INITIALIZE_REQUEST:String = "iilwy.events.UserRequestEvent.ANONYMOUS_INITIALIZE_REQUEST";
      
      public static const PARTNER_INITIALIZE_REQUEST:String = "iilwy.events.UserRequestEvent.PARTNER_INITIALIZE_REQUEST";
      
      public static const PRIVATE_FORCE_EXTERNAL_SESSION:String = "iilwy.events.UserRequestEvent.PRIVATE_FORCE_EXTERNAL_SESSION";
      
      public static const PRIVATE_LOGIN_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_LOGIN_REQUEST";
      
      public static const PRIVATE_LOGOUT_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_LOGOUT_REQUEST";
      
      public static const PRIVATE_SIGNUP_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_SIGNUP_REQUEST";
      
      public static const PRIVATE_UPDATE_PASSWORD_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_UPDATE_PASSWORD_REQUEST";
      
      public static const PRIVATE_UPDATE_PROFILE_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_UPDATE_PROFILE_REQUEST";
      
      public static const PRIVATE_UPDATE_PROFILE_NAME_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_UPDATE_PROFILE_NAME_REQUEST";
      
      public static const PRIVATE_GET_PROFILE_NAME_UPDATE_STATUS:String = "iilwy.events.UserRequestEvent.PRIVATE_GET_PROFILE_NAME_UPDATE_STATUS";
      
      public static const PRIVATE_CHANGE_EMAIL_ACCESS_CODE_REQUEST:String = "iilwy.events.UserRequestEvent.PRIVATE_CHANGE_EMAIL_ACCESS_CODE_REQUEST";
      
      public static const PRIVATE_IS_EMAIL_VERIFIED:String = "iilwy.events.UserRequestEvent.PRIVATE_IS_EMAIL_VERIFIED";
      
      public static const PRIVATE_SEND_EMAIL_VERIFICATION:String = "iilwy.events.UserRequestEvent.PRIVATE_SEND_EMAIL_VERIFICATION";
      
      public static const PRIVATE_GET_AUTHENTICATORS:String = "iilwy.events.UserRequestEvent.PRIVATE_GET_AUTHENTICATORS";
      
      public static const PRIVATE_HAS_ACCEPTED_RULES:String = "iilwy.events.UserRequestEvent.PRIVATE_HAS_ACCEPTED_RULES";
      
      public static const PRIVATE_ACCEPT_RULES:String = "iilwy.events.UserRequestEvent.PRIVATE_ACCEPT_RULES";
      
      public static const PUBLIC_ACHIEVEMENTS_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_ACHIEVEMENTS_REQUEST";
      
      public static const PUBLIC_ARCADE_STATS_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_ARCADE_STATS_REQUEST";
      
      public static const PUBLIC_FEED_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_FEED_REQUEST";
      
      public static const PUBLIC_OVERVIEW_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_OVERVIEW_REQUEST";
      
      public static const PUBLIC_QUESTIONS_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_QUESTIONS_REQUEST";
      
      public static const PUBLIC_ANSWERS_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_ANSWERS_REQUEST";
      
      public static const PUBLIC_RECENT_OPPONENTS_REQUEST:String = "iilwy.events.UserRequestEvent.PUBLIC_RECENT_OPPONENTS_REQUEST";
      
      public static const CREATE_WALL_POST:String = "iilwy.events.UserRequestEvent.CREATE_WALL_POST";
      
      public static const ASK_QUESTION:String = "iilwy.events.UserRequestEvent.ASK_QUESTION";
      
      public static const ANSWER_QUESTION:String = "iilwy.events.UserRequestEvent.ANSWER_QUESTION";
      
      public static const DELETE_FEED_REQUEST:String = "iilwy.events.UserRequestEvent.DELETE_FEED_REQUEST";
      
      public static const DELETE_QUESTION_REQUEST:String = "iilwy.events.UserRequestEvent.DELETE_QUESTION_REQUEST";
      
      public static const DELETE_ANSWER_REQUEST:String = "iilwy.events.UserRequestEvent.DELETE_ANSWER_REQUEST";
      
      public static const CHECK_BAN_STATE:String = "iilwy.events.UserRequestEvent.CHECK_BAN_STATE";
      
      public static const GET_RECRUITS_OVERVIEW:String = "iilwy.events.UserRequestEvent.GET_RECRUITS_OVERVIEW";
      
      public static const GET_RECRUIT_REWARDS:String = "iilwy.events.UserRequestEvent.GET_RECRUIT_REWARDS";
      
      public static const GET_RECRUITS:String = "iilwy.events.UserRequestEvent.GET_RECRUITS";
      
      public static const GET_PENDING_INVITES:String = "iilwy.events.UserRequestEvent.GET_PENDING_INVITES";
      
      public static const GIVE_RECRUIT_XP:String = "iilwy.events.UserRequestEvent.GIVE_RECRUIT_XP";
       
      
      private var _page:int;
      
      private var _pageDirection:int;
      
      public var forceRefresh:Boolean;
      
      public var showConfirmation:Boolean;
      
      public var privateUser:PrivateUserData;
      
      public var publicUser:PublicUserData;
      
      public var userID:int;
      
      public var profileID:String;
      
      public var loginCredentials:LoginCredentials;
      
      public var signupValues:SignupValues;
      
      public var partnerValues:PartnerValues;
      
      public var sessionData;
      
      public var merge:Boolean;
      
      public var alternateLogin:LoginType;
      
      public var body:String;
      
      public var drawing:DrawingData;
      
      public var filters:Array;
      
      public var feedData:FeedData;
      
      public var questionData:QuestionData;
      
      public var answerData:AnswerData;
      
      public var currencyData:CurrencyData;
      
      public var context:String;
      
      public var gameID:String;
      
      public function UserRequestEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function set page(value:int) : void
      {
         this._page = value;
      }
      
      public function get pageDirection() : int
      {
         return this._pageDirection;
      }
      
      public function set pageDirection(value:int) : void
      {
         this._pageDirection = value;
      }
      
      override public function clone() : Event
      {
         var userRequestEvent:UserRequestEvent = new UserRequestEvent(type,bubbles,cancelable);
         userRequestEvent.page = this.page;
         userRequestEvent.pageDirection = this.pageDirection;
         userRequestEvent.responder = responder;
         return userRequestEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("UserRequestEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
