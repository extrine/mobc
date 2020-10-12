package iilwy.events
{
   import flash.events.Event;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.model.MatchListingData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.AchievementData;
   import iilwy.model.dataobjects.AnimationData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.arcade.ArcadeChallengeData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardSettings;
   
   public class ArcadeEvent extends PaginationDataResponderEvent
   {
      
      public static const SHOW_GAME:String = "iilwy.events.ArcadeEvent.SHOW_GAME";
      
      public static const SHOW_GAME_PLAY:String = "iilwy.events.ArcadeEvent.SHOW_GAME_PLAY";
      
      public static const GET_RELATED_GAMES:String = "iilwy.events.ArcadeEvent.GET_RELATED_GAMES";
      
      public static const LOAD_CATALOG:String = "iilwy.events.ArcadeEvent.LOAD_CATALOG";
      
      public static const LOAD_GAME_PACK:String = "iilwy.events.ArcadeEvent.LOAD_GAME_PACK";
      
      public static const LOAD_GAME_PACK_LIBRARY:String = "iilwy.events.ArcadeEvent.LOAD_GAME_PACK_LIBRARY";
      
      public static const GAME_PACK_CHANGED:String = "iilwy.events.ArcadeEvent.GAME_PACK_CHANGED";
      
      public static const SET_GAME_PACK:String = "iilwy.events.ArcadeEvent.SET_GAME_PACK";
      
      public static const SET_GAME_PACK_LOAD_LIBRARY:String = "iilwy.events.ArcadeEvent.SET_GAME_PACK_LOAD_LIBRARY";
      
      public static const GET_PLAYER_STATS:String = "iilwy.events.ArcadeEvent.GET_PLAYER_STATS";
      
      public static const GET_USER_STATS:String = "iilwy.events.ArcadeEvent.GET_USER_STATS";
      
      public static const USER_STATS_CHANGED:String = "iilwy.events.ArcadeEvent.USER_STATS_CHANGED";
      
      public static const AUTHORIZE_CURRENT_PLAYER:String = "iilwy.events.ArcadeEvent.AUTHORIZE_CURRENT_PLAYER";
      
      public static const INIT_CURRENT_PLAYER:String = "iilwy.events.ArcadeEvent.INIT_CURRENT_PLAYER";
      
      public static const CONNECT_TO_GAMENET:String = "iilwy.events.ArcadeEvent.CONNECT_TO_GAMENET";
      
      public static const CONNECT_TO_MAIN_LOBBY:String = "iilwy.events.ArcadeEvent.CONNECT_TO_MAIN_LOBBY";
      
      public static const CONNECT_TO_GAME_LOBBY:String = "iilwy.events.ArcadeEvent.CONNECT_TO_GAME_LOBBY";
      
      public static const CREATE_MATCH:String = "iilwy.events.ArcadeEvent.CREATE_MATCH";
      
      public static const MODIFY_MATCH:String = "iilwy.events.ArcadeEvent.MODIFY_MATCH";
      
      public static const FLAG_MATCH:String = "iilwy.events.ArcadeEvent.FLAG_MATCH";
      
      public static const JOIN_MATCH:String = "iilwy.events.ArcadeEvent.JOIN_MATCH";
      
      public static const EXTEND_READY_TIME:String = "iilwy.events.ArcadeEvent.EXTEND_READY_TIME";
      
      public static const START_MATCH:String = "iilwy.events.ArcadeEvent.START_MATCH";
      
      public static const CHECK_MATCH_EXISTENCE:String = "iilwy.events.ArcadeEvent.CHECK_MATCH_EXISTENCE";
      
      public static const GET_USERS_PLAYING_BY_FACEBOOK_ID:String = "iilwy.events.ArcadeEvent.GET_USERS_PLAYING_BY_FACEBOOK_ID";
      
      public static const JOIN_MATCH_AS_SPECTATOR:String = "iilwy.events.ArcadeEvent.JOIN_MATCH_AS_SPECTATOR";
      
      public static const JOIN_MATCH_AS_PLAYER_OR_SPECTATOR:String = "iilwy.events.ArcadeEvent.JOIN_MATCH_AS_PLAYER_OR_SPECTATOR";
      
      public static const JOIN_MATCH_BY_NAME:String = "iilwy.events.ArcadeEvent.JOIN_MATCH_BY_NAME";
      
      public static const JOIN_PLAYER_BY_PROFILE_ID:String = "iilwy.events.ArcadeEvent.JOIN_PLAYER_BY_PROFILE_ID";
      
      public static const JOIN_PLAYER_BY_PROFILE_ID_AUTHENTICATED:String = "iilwy.events.ArcadeEvent.JOIN_PLAYER_BY_PROFILE_ID_AUTHENTICATED";
      
      public static const JOIN_PLAYER_BY_FACEBOOK_ID:String = "iilwy.events.ArcadeEvent.JOIN_PLAYER_BY_FACEBOOK_ID";
      
      public static const JOIN_MATCH_BY_INVITATION:String = "iilwy.events.ArcadeEvent.JOIN_MATCH_BY_INVITATION";
      
      public static const QUICK_PLAY:String = "iilwy.events.ArcadeEvent.QUICK_PLAY";
      
      public static const QUICK_CREATE:String = "iilwy.events.ArcadeEvent.QUICK_CREATE";
      
      public static const QUICK_PLAY_SINGLE_PLAYER:String = "iilwy.events.ArcadeEvent.QUICK_PLAY_SINGLE_PLAYER";
      
      public static const QUIT_MATCH:String = "iilwy.events.ArcadeEvent.QUIT_MATCH";
      
      public static const GET_MATCH_SUMMARY:String = "iilwy.events.ArcadeEvent.GET_MATCH_SUMMARY";
      
      public static const SHOW_MATCH_SUMMARY:String = "iilwy.events.ArcadeEvent.SHOW_MATCH_SUMMARY";
      
      public static const SHOW_CUSTOMIZE_SINGLEPLAYER_SETTINGS:String = "iilwy.events.ArcadeEvent.SHOW_CUSTOMIZE_SINGLEPLAYER_SETTINGS";
      
      public static const SHOW_CUSTOMIZE_MATCH_SETTINGS:String = "iilwy.events.ArcadeEvent.SHOW_CUSTOMIZE_MATCH_SETTINGS";
      
      public static const SHOW_CREATE_MATCH_SETTINGS:String = "iilwy.events.ArcadeEvent.SHOW_CREATE_MATCH_SETTINGS";
      
      public static const SHOW_SWITCH_GAME_OPTIONS:String = "iilwy.events.ArcadeEvent.SHOW_SWITCH_GAME_OPTIONS";
      
      public static const INITIATE_PARTY_SWITCH:String = "iilwy.events.ArcadeEvent.INITIATE_PARTY_SWITCH";
      
      public static const FOLLOW_PARTY_SWITCH:String = "iilwy.events.ArcadeEvent.FOLLOW_PARTY_SWITCH";
      
      public static const SUBMIT_ROUND_RESULTS:String = "iilwy.events.ArcadeEvent.SUBMIT_ROUND_RESULTS";
      
      public static const SHOW_INSTRUCTIONS:String = "iilwy.events.ArcadeEvent.SHOW_INSTRUCTIONS";
      
      public static const KICK_PLAYER:String = "iilwy.events.ArcadeEvent.KICK_PLAYER";
      
      public static const SEARCH_MATCHES:String = "iilwy.events.ArcadeEvent.SEARCH_MATCHES";
      
      public static const POLL_MATCHES:String = "iilwy.events.ArcadeEvent.POLL_MATCHES";
      
      public static const GET_FEATURED_PLAYERS:String = "iilwy.events.ArcadeEvent.GET_FEATURED_PLAYERS";
      
      public static const GET_FRIENDS_PLAYING:String = "iilwy.events.ArcadeEvent.GET_FRIENDS_PLAYING";
      
      public static const GET_FRIENDS_WITH_FAVORITE_GAMES:String = "iilwy.events.ArcadeEvent.GET_FRIENDS_WITH_FAVORITE_GAMES";
      
      public static const GET_RECENT_PLAYERS:String = "iilwy.events.ArcadeEvent.GET_RECENT_PLAYERS";
      
      public static const SET_PLAYER_STATUS:String = "iilwy.events.ArcadeEvent.SET_PLAYER_STATUS";
      
      public static const GET_ALL_GAME_STATS:String = "iilwy.events.ArcadeEvent.GET_ALL_GAME_STATS";
      
      public static const GET_GAME_STATS:String = "iilwy.events.ArcadeEvent.GET_GAME_STATS";
      
      public static const GAME_STATS_CHANGED:String = "iilwy.events.ArcadeEvent.GAME_STATS_CHANGED";
      
      public static const GET_LEADERBOARD:String = "iilwy.events.ArcadeEvent.GET_LEADERBOARD";
      
      public static const UPDATE_LEADERBOARD_FULL:String = "iilwy.events.ArcadeEvent.UPDATE_LEADERBOARD_FULL";
      
      public static const UPDATE_LEADERBOARD_MINI:String = "iilwy.events.ArcadeEvent.UPDATE_LEADERBOARD_MINI";
      
      public static const UPDATE_HORIZONTAL_LEADERBOARD:String = "iilwy.events.ArcadeEvent.UPDATE_HORIZONTAL_LEADERBOARD";
      
      public static const LEADERBOARD_MINI_CHANGED:String = "iilwy.events.ArcadeEvent.LEADERBOARD_MINI_CHANGED";
      
      public static const LEADERBOARD_FULL_CHANGED:String = "iilwy.events.ArcadeEvent.LEADERBOARD_FULL_CHANGED";
      
      public static const HORIZONTAL_LEADERBOARD_CHANGED:String = "iilwy.events.ArcadeEvent.HORIZONTAL_LEADERBOARD_CHANGED";
      
      public static const GET_CREDENTIALS:String = "iilwy.events.ArcadeEvent.GET_CREDENTIALS";
      
      public static const GET_LOCATIONCODE:String = "iilwy.events.ArcadeEvent.GET_LOCATIONCODE";
      
      public static const SET_CHOSEN_GUEST_NAME:String = "iilwy.events.ArcadeEvent.SET_CHOSEN_GUEST_NAME";
      
      public static const PROMPT_CHOSEN_GUEST_NAME:String = "iilwy.events.ArcadeEvent.PROMPT_CHOSEN_GUEST_NAME";
      
      public static const PROMPT_USER_PLAY_LIMIT:String = "iilwy.events.ArcadeEvent.PROMPT_USER_PLAY_LIMIT";
      
      public static const CREATE_CHALLENGE:String = "iilwy.events.ArcadeEvent.CREATE_CHALLENGE";
      
      public static const ACCEPT_CHALLENGE:String = "iilwy.events.ArcadeEvent.ACCEPT_CHALLENGE";
      
      public static const BEGIN_CHALLENGE:String = "iilwy.events.ArcadeEvent.BEGIN_CHALLENGE";
      
      public static const PROCESS_CHALLENGE:String = "iilwy.events.ArcadeEvent.PROCESS_CHALLENGE";
      
      public static const IGNORE_CHALLENGE:String = "iilwy.events.ArcadeEvent.IGNORE_CHALLENGE";
      
      public static const ABANDON_CHALLENGE:String = "iilwy.events.ArcadeEvent.ABANDON_CHALLENGE";
      
      public static const CREATE_BET_POT:String = "iilwy.events.ArcadeEvent.CREATE_BET_POT";
      
      public static const PROMPT_BET_ENTERED:String = "iilwy.events.ArcadeEvent.PROMPT_BET_ENTERED";
      
      public static const PROMPT_BET_CHANGED:String = "iilwy.events.ArcadeEvent.PROMPT_BET_CHANGED";
      
      public static const ADD_GAME_TO_HISTORY:String = "iilwy.events.ArcadeEvent.ADD_GAME_TO_HISTORY";
      
      public static const GAME_HISTORY_CHANGED:String = "iilwy.events.ArcadeEvent.GAME_HISTORY_CHANGED";
      
      public static const EARN_ACHIEVEMENT:String = "iilwy.events.ArcadeEvent.EARN_ACHIEVEMENT";
      
      public static const UPDATE_USER_GAME_STORE:String = "iilwy.events.ArcadeEvent.UPDATE_USER_GAME_STORE";
      
      public static const LOAD_USER_GAME_STORE:String = "iilwy.events.ArcadeEvent.LOAD_USER_GAME_STORE";
      
      public static const LOAD_INSTANT_PURCHASE_COLLECTION:String = "iilwy.events.ArcadeEvent.LOAD_INSTANT_PURCHASE_COLLECTION";
      
      public static const BUY_INSTANT_PURCHASE_PRODUCT:String = "iilwy.events.ArcadeEvent.BUY_INSTANT_PURCHASE_PRODUCT";
      
      public static const CONSUME_PRODUCT:String = "iilwy.events.ArcadeEvent.CONSUME_PRODUCT";
      
      public static const GET_BEST_SCORES:String = "iilwy.events.ArcadeEvent.GET_BEST_SCORES";
      
      public static const NOTIFY_ATTEMPTING_JOIN:String = "iilwy.events.ArcadeEvent.NOTIFY_ATTEMPTING_JOIN";
      
      public static const CONTEXT_QUICKPLAY_AUTO:String = "quickPlayAuto";
      
      public static const CONTEXT_CREATE_MATCH_MANUAL:String = "createMatchManual";
      
      public static const CONTEXT_CREATE_MATCH_AUTO:String = "createMatchAuto";
      
      public static const CONTEXT_JOIN_MATCH_SIDEBAR_MANUAL:String = "joinMatchSidebarManual";
      
      public static const CONTEXT_JOIN_PLAYER_EXTERNAL:String = "joinPlayerExternal";
      
      public static const CONTEXT_INVITE_TO_MATCH_EXTERNAL:String = "inviteToMatchExternal";
       
      
      public var id:String;
      
      public var player:PlayerData;
      
      public var gamePack:ArcadeGamePackData;
      
      public var matchListingData:MatchListingData;
      
      public var suppressFeedback:Boolean;
      
      public var serverID:int = -1;
      
      public var serverURL:String;
      
      public var playerStatus:PlayerStatus;
      
      public var roundResults:RoundResults;
      
      public var leaderboardSettings:ArcadeLeaderboardSettings;
      
      public var pendingEvent:Event;
      
      public var challenge:ArcadeChallengeData;
      
      public var achievement:AchievementData;
      
      public var extraMatchConfiguration:Object;
      
      public var confirmSpectate:Boolean;
      
      public var playerJid:String;
      
      public var playerPreview:AnimationData;
      
      public var betMin:int = -1;
      
      public var betMax:int = -1;
      
      public var context:String;
      
      public var quantity:int;
      
      public function ArcadeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var arcadeEvent:ArcadeEvent = new ArcadeEvent(type,bubbles,cancelable);
         arcadeEvent.data = data;
         arcadeEvent.responder = responder;
         arcadeEvent.direction = direction;
         arcadeEvent.page = page;
         arcadeEvent.offset = offset;
         arcadeEvent.limit = limit;
         arcadeEvent.forceRefresh = forceRefresh;
         arcadeEvent.leaderboardSettings = this.leaderboardSettings;
         return arcadeEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ArcadeEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
