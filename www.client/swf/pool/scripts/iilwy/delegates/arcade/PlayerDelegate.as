package iilwy.delegates.arcade
{
   import flash.events.EventDispatcher;
   import iilwy.delegates.MerbRequestDelegate;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.net.MerbRequest;
   
   public class PlayerDelegate extends MerbRequestDelegate
   {
       
      
      public function PlayerDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         super();
         _success = success;
         _fail = fail;
         _timeout = timeout;
      }
      
      public function getFeaturedPlayers(limit:Number, cacheDuration:Number) : EventDispatcher
      {
         var req:MerbRequest = null;
         var params:* = {
            "limit":limit,
            "cache_duration":cacheDuration
         };
         req = getMerbProxy().requestImmediate("gamenet_player_controller/get_homepage_players",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getFriendsWithFavoriteGames(limit:Number, cacheDuration:Number) : EventDispatcher
      {
         var req:MerbRequest = null;
         var params:* = {
            "limit":limit,
            "cache_duration":cacheDuration
         };
         req = getMerbProxy().requestImmediate("gamenet_player_controller/friends_with_favorite_games",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getRecentPlayers(profileId:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"profile_id":profileId};
         req = getMerbProxy().requestImmediate("gamenet_player_controller/get_recent_players",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getFriendsPlaying(userId:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"user_id":userId};
         req = getMerbProxy().requestImmediate("gamenet_player_controller/get_friends_playing",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getProfileStatus(profileID:String = null, facebookID:String = null) : MerbRequest
      {
         var params:Object = {};
         if(profileID)
         {
            params.profile_id = profileID;
         }
         else if(facebookID)
         {
            params.facebook_id = facebookID;
         }
         var request:MerbRequest = getMerbProxy().requestQueued("gamenet_player_controller/get_profile_status",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function getUsersPlaying(gameID:String, userIDs:Array = null, facebookIDs:Array = null) : MerbRequest
      {
         var params:Object = {"game_name":gameID};
         if(userIDs && userIDs.length > 0)
         {
            params.user_ids = userIDs;
         }
         else if(facebookIDs && facebookIDs.length > 0)
         {
            params.facebook_ids = facebookIDs;
         }
         var request:MerbRequest = getMerbProxy().requestQueued("gamenet_player_controller/get_profile_statuses",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function setPlayerStatus(data:PlayerStatus, profileId:String, userId:String) : EventDispatcher
      {
         var params:* = {
            "description":data.description,
            "user_id":userId,
            "profile_id":profileId,
            "jid":data.jid,
            "type":data.type,
            "server_id":(data.serverID > -1?data.serverID:null),
            "server":data.serverURL,
            "game_id":data.gameId,
            "game_title":data.gameTitle
         };
         request = getMerbProxy().requestQueued("gamenet_player_controller/update_status",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
   }
}
