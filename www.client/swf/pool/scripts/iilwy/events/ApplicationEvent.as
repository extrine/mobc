package iilwy.events
{
   import flash.events.Event;
   import iilwy.data.PageCommand;
   import iilwy.display.drawing.model.DrawingFileData;
   import iilwy.display.popups.authentication.enum.LoginType;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.MediaItemData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.user.SuggestionData;
   
   public class ApplicationEvent extends DataResponderEvent
   {
      
      public static const CLICK:String = "iilwy.events.ApplicationEvent.CLICK";
      
      public static const LOAD_LOGGEDOUT_HOMEPAGE_DATA:String = "iilwy.events.ApplicationEvent.LOAD_LOGGEDOUT_HOMEPAGE_DATA";
      
      public static const NAVIGATE_TO_URL:String = "iilwy.events.ApplicationEvent.NAVIGATE_TO_URL";
      
      public static const BROWSE_CLICKED:String = "iilwy.events.ApplicationEvent.BROWSE_CLICKED";
      
      public static const TOP_BAR_INITIALIZED:String = "iilwy.events.ApplicationEvent.TOP_BAR_INITIALIZED";
      
      public static const SHOW_INITIAL_PAGE:String = "iilwy.events.ApplicationEvent.SHOW_INITIAL_PAGE";
      
      public static const SHOW_PAGE:String = "iilwy.events.ApplicationEvent.SHOW_PAGE";
      
      public static const SHOW_EXTERNAL_LINK:String = "iilwy.events.ApplicationEvent.SHOW_EXTERNAL_LINK";
      
      public static const PROCESS_NAV_SELECTION:String = "iilwy.events.ApplicationEvent.PROCESS_NAV_SELECTION";
      
      public static const ROLL_OVER_WEATHER:String = "iilwy.events.ApplicationEvent.ROLL_OVER_WEATHER";
      
      public static const ROLL_OUT_WEATHER:String = "iilwy.events.ApplicationEvent.ROLL_OUT_WEATHER";
      
      public static const REFER_TO_WEBSITE:String = "iilwy.events.ApplicationEvent.REFER_TO_WEBSITE";
      
      public static const HOME_LAYOUT_DISPLAYED:String = "iilwy.events.ApplicationEvent.HOME_LAYOUT_DISPLAYED";
      
      public static const HOME_LAYOUT_CREATED:String = "iilwy.events.ApplicationEvent.HOME_LAYOUT_CREATED";
      
      public static const HOME_LAYOUT_HIDDEN:String = "iilwy.events.ApplicationEvent.HOME_LAYOUT_HIDDEN";
      
      public static const LAYOUT_CHANGED:String = "iilwy.events.ApplicationEvent.LAYOUT_CHANGED";
      
      public static const CONTACT_WINDOW_CREATED:String = "iilwy.events.ApplicationEvent.CONTACT_WINDOW_CREATED";
      
      public static const CONTACT_WINDOW_DISPLAYED:String = "iilwy.events.ApplicationEvent.CONTACT_WINDOW_DISPLAYED";
      
      public static const CONTACT_WINDOW_HIDDEN:String = "iilwy.events.ApplicationEvent.CONTACT_WINDOW_HIDDEN";
      
      public static const OFFLINE_CONTACT_CLICKED:String = "iilwy.events.ApplicationEvent.OFFLINE_CONTACT_CLICKED";
      
      public static const CONTACT_CLICKED:String = "iilwy.events.ApplicationEvent.CONTACT_CLICKED";
      
      public static const SET_ITEM_CLICKED:String = "iilwy.events.ApplicationEvent.SET_ITEM_CLICKED";
      
      public static const REFRESH_BROWSE:String = "iilwy.events.ApplicationEvent.REFRESH_BROWSE";
      
      public static const PROFILE_SELECTED:String = "iilwy.events.ApplicationEvent.PROFILE_SELECTED";
      
      public static const PROFILE_USER_SELETED:String = "iilwy.events.ApplicationEvent.PROFILE_USER_SELETED";
      
      public static const PROFILE_SHOW_MINI:String = "iilwy.events.ApplicationEvent.PROFILE_SHOW_MINI";
      
      public static const PROFILE_REMOVE_MINI:String = "iilwy.events.ApplicationEvent.PROFILE_REMOVE_MINI";
      
      public static const DO_CONTEXT_ACTION:String = "iilwy.events.ApplicationEvent.DO_CONTEXT_ACTION";
      
      public static const PROFILE_INVITE:String = "iilwy.events.ApplicationEvent.PROFILE_INVITE";
      
      public static const PROFILE_JOIN:String = "iilwy.events.ApplicationEvent.PROFILE_JOIN";
      
      public static const PROFILE_START_CHAT:String = "iilwy.events.ApplicationEvent.PROFILE_START_CHAT";
      
      public static const PROFILE_SHARE:String = "iilwy.events.ApplicationEvent.PROFILE_SHARE";
      
      public static const PROFILE_UNBLOCK:String = "iilwy.events.ApplicationEvent.PROFILE_UNBLOCK";
      
      public static const PROFILE_UNMUTE:String = "iilwy.events.ApplicationEvent.PROFILE_UNMUTE";
      
      public static const PROFILE_MUTE:String = "iilwy.events.ApplicationEvent.PROFILE_MUTE";
      
      public static const PROFILE_REMOVE_FRIEND:String = "iilwy.events.ApplicationEvent.PROFILE_REMOVE_FRIEND";
      
      public static const PROFILE_PROMPT_CREATE_CONTACT_REQUEST:String = "iilwy.events.ApplicationEvent.PROFILE_PROMPT_CREATE_CONTACT_REQUEST";
      
      public static const PROFILE_LIKE:String = "iilwy.events.ApplicationEvent.PROFILE_LIKE";
      
      public static const PROFILE_DISLIKE:String = "iilwy.events.ApplicationEvent.PROFILE_DISLIKE";
      
      public static const OPEN_VERIFY_EMAIL_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_VERIFY_EMAIL_POPUP";
      
      public static const OPEN_FEEDBACK_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_FEEDBACK_POPUP";
      
      public static const OPEN_INVITE_FRIENDS_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_INVITE_FRIENDS_POPUP";
      
      public static const OPEN_FIND_FRIENDS_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_FIND_FRIENDS_POPUP";
      
      public static const OPEN_RECRUITS:String = "iilwy.events.ApplicationEvent.OPEN_RECRUITS";
      
      public static const SET_RECRUITER:String = "iilwy.events.ApplicationEvent.SET_RECRUITER";
      
      public static const OPEN_INITIAL_POPUP_QUEUE:String = "iilwy.events.ApplicationEvent.OPEN_INITIAL_POPUP_QUEUE";
      
      public static const OPEN_DRAWING_LIGHTBOX:String = "iilwy.events.ApplicationEvent.OPEN_DRAWING_LIGHTBOX";
      
      public static const SHOW_HTML_VIEWER:String = "iilwy.events.ApplicationEvent.SHOW_HTML_VIEWER";
      
      public static const OPEN_POPUP_BY_ID:String = "iilwy.events.ApplicationEvent.OPEN_POPUP_BY_ID";
      
      public static const OPEN_LOGIN_REQUIRED_POPUP_BY_ID:String = "iilwy.events.ApplicationEvent.OPEN_LOGIN_REQUIRED_POPUP_BY_ID";
      
      public static const LOAD_POPULAR_BOARDS:String = "iilwy.events.ApplicationEvent.LOAD_POPULAR_BOARDS";
      
      public static const USER_PROMPT_LOGIN:String = "iilwy.events.ApplicationEvent.USER_PROMPT_LOGIN";
      
      public static const USER_PROMPT_SIGNUP:String = "iilwy.events.ApplicationEvent.USER_PROMPT_SIGNUP";
      
      public static const USER_PROMPT_SIGNUP_OR_LOGIN:String = "iilwy.events.ApplicationEvent.USER_PROMPT_SIGNUP_OR_LOGIN";
      
      public static const USER_LOGOUT:String = "iilwy.events.ApplicationEvent.USER_LOGOUT";
      
      public static const USER_LOGIN:String = "iilwy.events.ApplicationEvent.USER_LOGIN";
      
      public static const PROMPT_ALTERNATE_SIGNUP_COMPLETION:String = "iilwy.events.ApplicationEvent.PROMPT_ALTERNATE_SIGNUP_COMPLETION";
      
      public static const PROMPT_FINALIZE_ACCOUNT:String = "iilwy.events.ApplicationEvent.PROMPT_FINALIZE_ACCOUNT";
      
      public static const PROMPT_MERGE_ACCOUNT:String = "iilwy.events.ApplicationEvent.PROMPT_MERGE_ACCOUNT";
      
      public static const SUBMIT_BID:String = "iilwy.events.ApplicationEvent.SUBMIT_BID";
      
      public static const SUBMIT_BET:String = "iilwy.events.ApplicationEvent.SUBMIT_BET";
      
      public static const GAME_SUBMIT_WINNER:String = "iilwy.events.ApplicationEvent.GAME_SUBMIT_WINNER";
      
      public static const GAME_PICK_WINNER:String = "iilwy.events.ApplicationEvent.GAME_PICK_WINNER";
      
      public static const GAME_CLOSE:String = "iilwy.events.ApplicationEvent.GAME_CLOSE";
      
      public static const GAME_NOWINNER:String = "iilwy.events.ApplicationEvent.GAME_NOWINNER";
      
      public static const GAME_CREATE:String = "iilwy.events.ApplicationEvent.GAME_CREATE";
      
      public static const MEDIA_LOAD_LIST:String = "iilwy.events.ApplicationEvent.MEDIA_LOAD_LIST";
      
      public static const MEDIA_SET_DEFAULT_PHOTO:String = "iilwy.events.ApplicationEvent.MEDIA_SET_DEFAULT_PHOTO";
      
      public static const MEDIA_SET_ITEM_VISIBILITY:String = "iilwy.events.ApplicationEvent.MEDIA_SET_ITEM_VISIBILITY";
      
      public static const MEDIA_DELETE_ITEM:String = "iilwy.events.ApplicationEvent.MEDIA_DELETE_ITEM";
      
      public static const MEDIA_SET_CAPTION:String = "iilwy.events.ApplicationEvent.MEDIA_SET_CAPTION";
      
      public static const MEDIA_DRAW_ON_PHOTO:String = "iilwy.events.ApplicationEvent.MEDIA_DRAW_ON_PHOTO";
      
      public static const LIVESTREAM_GET_STATUS:String = "iilwy.events.ApplicationEvent.LIVESTREAM_GET_STATUS";
      
      public static const LIVESTREAM_SHOW_POPUP:String = "iilwy.events.ApplicationEvent.LIVESTREAM_SHOW_POPUP";
      
      public static const LIVESTREAM_CONNECT_TO_CHAT:String = "iilwy.events.ApplicationEvent.LIVESTREAM_CONNECT_TO_CHAT";
      
      public static const LIVESTREAM_DISCONNECT_FROM_CHAT:String = "iilwy.events.ApplicationEvent.LIVESTREAM_DISCONNECT_FROM_CHAT";
      
      public static const PHOTO_VIEWER_GOING_FULL_SCREEN:String = "iilwy.events.ApplicationEvent.PHOTO_VIEWER_GOING_FULL_SCREEN";
      
      public static const PHOTO_VIEWER_LEAVING_FULL_SCREEN:String = "iilwy.events.ApplicationEvent.PHOTO_VIEWER_LEAVING_FULL_SCREEN";
      
      public static const MINIMIZE_ALL_WINDOWS:String = "iilwy.events.ApplicationEvent.MINIMIZE_ALL_WINDOWS";
      
      public static const SET_PAGE_TITLE:String = "iilwy.events.ApplicationEvent.SET_PAGE_TITLE";
      
      public static const SET_PAGE_SUBTITLE:String = "iilwy.events.ApplicationEvent.SET_PAGE_SUBTITLE";
      
      public static const SET_GLOBAL_NAV_SELECTION:String = "iilwy.events.ApplicationEvent.SET_GLOBAL_NAV_SELECTION";
      
      public static const BEFORE_UNLOAD:String = "iilwy.events.ApplicationEvent.BEFORE_UNLOAD";
      
      public static const ARCADE_HANDLE_DEEPLINKS:String = "iilwy.events.ApplicationEvent.ARCADE_HANDLE_DEEPLINKS";
      
      public static const ARCADE_SHOW_GAME:String = "iilwy.events.ApplicationEvent.ARCADE_SHOW_GAME";
      
      public static const ARCADE_SHOW_MORE_GAMES:String = "iilwy.events.ApplicationEvent.ARCADE_SHOW_MORE_GAMES";
      
      public static const DEBUG_OPEN_TOOLS:String = "iilwy.events.ApplicationEvent.DEBUG_OPEN_TOOLS";
      
      public static const PROMPT_ACCOUNT_SETTINGS:String = "iilwy.events.ApplicationEvent.PROMPT_ACCOUNT_SETTINGS";
      
      public static const PROMPT_REPORT_PROFILE:String = "iilwy.events.ApplicationEvent.PROMPT_REPORT_PROFILE";
      
      public static const GET_CONTACT_PREFERENCES:String = "iilwy.events.ApplicationEvent.GET_CONTACT_MESSAGING_PREFERENCES";
      
      public static const UPDATE_CONTACT_PREFERENCES:String = "iilwy.events.ApplicationEvent.UPDATE_CONTACT_PREFERENCES";
      
      public static const CHANGE_BACKGROUND:String = "iilwy.events.ApplicationEvent.CHANGE_BACKGROUND";
      
      public static const SET_GLOBAL_VOLUME:String = "iilwy.events.ApplicationEvent.SET_GLOBAL_VOLUME";
      
      public static const SET_GLOBAL_QUALITY:String = "iilwy.events.ApplicationEvent.SET_GLOBAL_QUALITY";
      
      public static const OPEN_PREMIUM_ABOUT:String = "iilwy.events.ApplicationEvent.OPEN_PREMIUM_ABOUT";
      
      public static const OPEN_PREMIUM_UPSELL:String = "iilwy.events.ApplicationEvent.OPEN_PREMIUM_UPSELL";
      
      public static const AR_PANDA_POPUP:String = "iilwy.events.ApplicationEvent.AR_PANDA_POPUP";
      
      public static const GET_SITE_NEWS:String = "iilwy.events.ApplicationEvent.GET_SITE_NEWS";
      
      public static const OPEN_DAILY_LOGIN_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_DAILY_LOGIN_POPUP";
      
      public static const GET_DAILY_LOGIN_LAYOUT:String = "iilwy.events.ApplicationEvent.GET_DAILY_LOGIN_LAYOUT";
      
      public static const OPEN_SITE_RULES_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_SITE_RULES_POPUP";
      
      public static const SEND_PERFORMANCE_STATS:String = "iilwy.events.ApplicationEvent.SEND_PERFORMANCE_STATS";
      
      public static const OPEN_PROMO_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_PROMO_POPUP";
      
      public static const OPEN_REWARDS:String = "iilwy.events.ApplicationEvent.OPEN_REWARDS";
      
      public static const OPEN_REWARDS_POPUPS:String = "iilwy.events.ApplicationEvent.OPEN_REWARDS_POPUPS";
      
      public static const OPEN_SELECTABLE_MEDIA_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_SELECTABLE_MEDIA_POPUP";
      
      public static const GET_SELECTABLE_MEDIA_ACTIVITIES:String = "iilwy.events.ApplicationEvent.GET_SELECTABLE_MEDIA_ACTIVITIES";
      
      public static const OPEN_SOCIAL_VIBE_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_SOCIAL_VIBE_POPUP";
      
      public static const GET_SOCIAL_VIBE_ACTIVITIES:String = "iilwy.events.ApplicationEvent.GET_SOCIAL_VIBE_ACTIVITIES";
      
      public static const OPEN_SUPER_SONIC_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_SUPER_SONIC_POPUP";
      
      public static const GET_SUPER_SONIC_ACTIVITIES:String = "iilwy.events.ApplicationEvent.GET_SUPER_SONIC_ACTIVITIES";
      
      public static const ACCEPT_REWARD:String = "iilwy.events.ApplicationEvent.ACCEPT_REWARD";
      
      public static const PET_ACCEPT_FRIEND:String = "iilwy.events.ApplicationEvent.PET_ACCEPT_FRIEND";
      
      public static const OPEN_PETVIEW:String = "iilwy.events.ApplicationEvent.OPEN_PETVIEW";
      
      public static const OPEN_PETVIEW_CHECK:String = "iilwy.events.ApplicationEvent.OPEN_PETVIEW_CHECK";
      
      public static const OPEN_TOOLBAR_POPUP:String = "iilwy.events.ApplicationEvent.OPEN_TOOLBAR_POPUP";
      
      public static const DOWNLOAD_TOOLBAR:String = "iilwy.events.ApplicationEvent.DOWNLOAD_TOOLBAR";
      
      public static const CAN_USER_EARN:String = "iilwy.event.AdEvent.CAN_USER_EARN";
      
      public static const GET_AD_PATTERN:String = "iilwy.event.AdEvent.GET_AD_PATTERN";
      
      public static const TRACK_PIXEL:String = "iilwy.event.ApplicationEvent.TRACK_PIXEL";
       
      
      public var mediaItemData:MediaItemData;
      
      public var profileData:ProfileData;
      
      public var playerData:PlayerData;
      
      public var chatUser:ChatUser;
      
      public var chatRoomUser:ChatRoomUser;
      
      public var profileId:String;
      
      public var profileName:String;
      
      public var gameId:Number;
      
      public var message:String;
      
      public var id:String;
      
      public var url:String;
      
      public var jid:String;
      
      public var contextAction:String;
      
      public var suggestionData:SuggestionData;
      
      public var rewardID:int;
      
      public var pageCommand:PageCommand;
      
      public var drawingData:DrawingData;
      
      public var drawingFileData:DrawingFileData;
      
      public var requireConfirmation:Boolean;
      
      public var context:String;
      
      public var closable:Boolean = true;
      
      public var navSelection:String;
      
      public var navData:XMLList;
      
      public var navLocation:String;
      
      public var loginType:LoginType;
      
      public function ApplicationEvent(type:String, data:* = null)
      {
         super(type,true,true,data);
      }
      
      override public function clone() : Event
      {
         var applicationEvent:ApplicationEvent = new ApplicationEvent(type,data);
         applicationEvent.responder = responder;
         return applicationEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ApplicationEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
