package iilwy.events
{
   import flash.events.Event;
   import iilwy.model.dataobjects.MediaItemData;
   import iilwy.model.dataobjects.ProfileData;
   
   public class ModelEvent extends DataEvent
   {
      
      public static const CURRENT_PROFILE_LOAD:String = "iilwy.events.ModelEvent.CURRENT_PROFILE_LOAD";
      
      public static const CURRENT_PROFILE_LOAD_SUCCESS:String = "iilwy.events.ModelEvent.CURRENT_PROFILE_LOAD_SUCCESS";
      
      public static const CURRENT_PROFILE_LOAD_FAIL:String = "iilwy.events.ModelEvent.CURRENT_PROFILE_LOAD_FAIL";
      
      public static const USER_IDLE_CHANGED:String = "iilwy.events.ModelEvent.USER_IDLE_CHANGED";
      
      public static const SEARCH_PREFS_CHANGED:String = "iilwy.events.ModelEvent.SEARCH_PREFS_CHANGED";
      
      public static const GAME_BIDS_CHANGED:String = "iilwy.events.ModelEvent.GAME_BIDS_CHANGED";
      
      public static const GAME_SUBMIT_BID_SUCCESS:String = "iilwy.events.ModelEvent.GAME_SUBMIT_BID_SUCCESS";
      
      public static const GAME_SUBMIT_BID_FAIL:String = "iilwy.events.ModelEvent.GAME_SUBMIT_BID_FAIL";
      
      public static const GAME_BETS_CHANGED:String = "iilwy.events.ModelEvent.GAME_BETS_CHANGED";
      
      public static const GAME_SUBMIT_BET_SUCCESS:String = "iilwy.events.ModelEvent.GAME_SUBMIT_BET_SUCCESS";
      
      public static const GAME_SUBMIT_BET_FAIL:String = "iilwy.events.ModelEvent.GAME_SUBMIT_BET_FAIL";
      
      public static const USER_CLOSED_GAME:String = "iilwy.events.ModelEvent.USER_CLOSED_GAME";
      
      public static const USER_GAME_FINISHED:String = "iilwy.events.ModelEvent.USER_GAME_FINISHED";
      
      public static const GAME_WINNER_CHANGED:String = "iilwy.events.ModelEvent.GAME_WINNER_CHANGED";
      
      public static const GAME_SUBMIT_WINNER_SUCCESS:String = "iilwy.events.ModelEvent.GAME_SUBMIT_WINNER_SUCCESS";
      
      public static const GAME_SUBMIT_WINNER_FAIL:String = "iilwy.events.ModelEvent.GAME_SUBMIT_WINNER_FAIL";
      
      public static const RESET_DEFAULT_BACKGROUND:String = "iilwy.events.ModelEvent.RESET_DEFAULT_BACKGROUND";
      
      public static const USER_UPLOAD_COMPLETE:String = "iilwy.events.ModelEvent.USER_UPLOAD_COMPLETE";
      
      public static const UPDATE_USER_FRIEND_LIST:String = "iilwy.events.ModelEvent.UPDATE_USER_FRIEND_LIST";
      
      public static const USER_SPENT_POINTS:String = "iilwy.events.ModelEvent.USER_SPENT_POINTS";
      
      public static const USER_BALANCE_CHANGED:String = "iilwy.events.ModelEvent.USER_BALANCE_CHANGED";
      
      public static const USER_CREATED_GAME:String = "iilwy.events.ModelEvent.USER_CREATED_GAME";
      
      public static const SERVER_NOW_VALIDATED:String = "iilwy.events.ModelEvent.SERVER_NOW_VALIDATED";
      
      public static const USER_ADDED_A_CONTACT:String = "iilwy.events.ModelEvent.USER_ADDED_A_CONTACT";
      
      public static const USER_NUM_CONTACTS_UPDATED:String = "iilwy.events.ModelEvent.USER_NUM_CONTACTS_UPDATED";
      
      public static const USER_ONLINE_IDLE_UPDATED:String = "iilwy.events.ModelEvent.USER_ONLINE_IDLE_UPDATED";
      
      public static const USER_SETTINGS_META_SET:String = "iilwy.events.ModelEvent.USER_SETTINGS_META_SET";
      
      public static const USER_NEEDS_PROFILE:String = "iilwy.events.ModelEvent.USER_NEEDS_PROFILE";
      
      public static const USER_SET_DEFAULT_PHOTO:String = "iilwy.events.ModelEvent.USER_SET_DEFAULT_PHOTO";
      
      public static const USER_ACTIVITY_UPDATED:String = "iilwy.events.ModelEvent.USER_ACTIVITY_UPDATED";
      
      public static const RESET_USER_TICKER:String = "iilwy.events.ModelEvent.RESET_USER_TICKER";
      
      public static const USER_JUST_BID:String = "iilwy.events.ModelEvent.USER_JUST_BID";
      
      public static const USER_JUST_BET:String = "iilwy.events.ModelEvent.USER_JUST_BET";
      
      public static const POPULAR_BOARDS_SET:String = "iilwy.events.ModelEvent.POPULAR_BOARDS_SET";
      
      public static const CHANGE_BACKGROUND:String = "iilwy.events.ModelEvent.CHANGE_BACKGROUND";
      
      public static const UPDATE_BROWSE_BLOCK:String = "iilwy.events.ModelEvent.UPDATE_BROWSE_BLOCK";
      
      public static const USER_WATCH_LIST_CHANGED:String = "iilwy.events.ModelEvent.USER_WATCH_LIST_CHANGED";
      
      public static const CONTACT_LOGGED_IN:String = "iilwy.events.ModelEvent.CONTACT_LOGGED_IN";
      
      public static const CONTACT_LOGGED_OUT:String = "iilwy.events.ModelEvent.CONTACT_LOGGED_OUT";
      
      public static const CONTACT_IDLE_CHANGED:String = "iilwy.events.ModelEvent.CONTACT_IDLE_CHANGED";
      
      public static const PHOTO_VIEWER_GOING_FULL_SCREEN:String = "iilwy.events.ModelEvent.PHOTO_VIEWER_GOING_FULL_SCREEN";
      
      public static const PHOTO_VIEWER_LEAVING_FULL_SCREEN:String = "iilwy.events.ModelEvent.PHOTO_VIEWER_LEAVING_FULL_SCREEN";
      
      public static const USER_GAMES_BIDDING_ON_SET:String = "iilwy.events.ModelEvent.USER_GAMES_BIDDING_ON_SET";
      
      public static const USER_GAMES_BETTING_ON_SET:String = "iilwy.events.ModelEvent.USER_GAMES_BETTING_ON_SET";
      
      public static const CLOSE_LOGIN_SCREEN:String = "iilwy.events.ModelEvent.CLOSE_LOGIN_SCREEN";
      
      public static const MEDIA_PHOTOS_CHANGED:String = "iilwy.events.ModelEvent.MEDIA_PHOTOS_CHANGED";
      
      public static const MEDIA_PHOTO_VISIBILITY_CHANGED:String = "iilwy.events.ModelEvent.MEDIA_PHOTO_VISIBILITY_CHANGED";
      
      public static const MEDIA_CAPTION_CHANGED:String = "iilwy.events.ModelEvent.MEDIA_CAPTION_CHANGED";
      
      public static const MINI_PROFILE_LOADED:String = "iilwy.events.ModelEvent.MINI_PROFILE_LOADED";
      
      public static const MINI_PROFILE_SELECTED:String = "iilwy.events.ModelEvent.MINI_PROFILE_SELECTED";
      
      public static const CONFIGURATION_LOAD:String = "iilwy.events.ModelEvent.CONFIGURATION_LOAD";
      
      public static const CONFIGURATION_COMPLETE:String = "iilwy.events.ModelEvent.CONFIGURATION_COMPLETE";
      
      public static const LIVESTREAM_STATUS_CHANGED:String = "iilwy.events.ModelEvent.LIVESTREAM_STATUS_CHANGED";
      
      public static const LIVESTREAM_META_CHANGED:String = "iilwy.events.ModelEvent.LIVESTREAM_META_CHANGED";
      
      public static const GLOBAL_VOLUME_CHANGED:String = "iilwy.events.ModelEvent.GLOBAL_VOLUME_CHANGED";
      
      public static const GLOBAL_QUALITY_CHANGED:String = "iilwy.events.ModelEvent.GLOBAL_QUALITY_CHANGED";
      
      public static const PROMO_LOAD:String = "iilwy.events.ModelEvent.PROMO_LOAD";
       
      
      public var profileData:ProfileData;
      
      public var mediaItemData:MediaItemData;
      
      public function ModelEvent(type:String, data:* = null)
      {
         super(type,false,false,data);
      }
      
      override public function clone() : Event
      {
         var modelEvent:ModelEvent = new ModelEvent(type,data);
         return modelEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ModelEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
