package iilwy.delegates.arcade
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.delegates.MerbRequestDelegate;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.model.MatchData;
   import iilwy.gamenet.model.MatchListingData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardItemData;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.net.MerbProxy;
   import iilwy.net.MerbRequest;
   
   public class GamenetMatchDelegate extends MerbRequestDelegate
   {
       
      
      public function GamenetMatchDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         super();
         _success = success;
         _fail = fail;
         _timeout = timeout;
      }
      
      public function getLoadBalancedServer(code:String, gamePack:ArcadeGamePackData) : EventDispatcher
      {
         var req:MerbRequest = null;
         req = getMerbProxy().requestQueued("xmpp_login_controller/get_optimal_server",{
            "location_code":code,
            "game_name":gamePack.id
         });
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getCredentials(userID:int, serverID:int) : EventDispatcher
      {
         var req:MerbRequest = null;
         req = getMerbProxy().requestQueued("xmpp_login_controller/assign_xmpp_login",{
            "user_id":userID,
            "server_id":serverID
         });
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getLocationCode() : EventDispatcher
      {
         var req:MerbRequest = null;
         req = getMerbProxy().requestQueued("xmpp_login_controller/get_location_code",{});
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function destroyMatch(jid:String) : EventDispatcher
      {
         _logger.log("Deleting ",jid);
         request = getMerbProxy().requestImmediate("gamenet_match_controller/destroy",{"jid":jid});
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function flagMatch(jid:String) : EventDispatcher
      {
         _logger.log("Flag ",jid);
         request = getMerbProxy().requestQueued("gamenet_match_controller/destroy",{"jid":jid});
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      protected function prepareMatchParams(subject:*) : *
      {
         var params:* = subject;
         var subj:* = JSON.serialize(subject);
         subj = escape(subj);
         params.origin = AppProperties.origin;
         params.deleted = 0;
         params.subject = subj;
         if(!isNaN(params.open_at))
         {
            params.open_at = params.open_at / 1000;
         }
         params.participant_count = params.approved_player_jids.length;
         if(params.spectator_jids)
         {
            params.participant_count = params.participant_count + params.spectator_jids.length;
         }
         var slots:Number = 6;
         var pack:ArcadeGamePackData = AppComponents.model.arcade.getGamePack(params.game_id);
         if(pack && pack.maxPlayerCount > 1)
         {
            slots = pack.maxPlayerCount - params.participant_count;
         }
         params.available_slots = slots;
         return params;
      }
      
      public function createMatch(data:MatchListingData, user:PrivateUserData) : EventDispatcher
      {
         var params:* = this.prepareMatchParams(data.toSubjectObj());
         params.silo = Boolean(EmbedSettings.getInstance().matchMakingSilo)?EmbedSettings.getInstance().matchMakingSilo:"15to17";
         if(user.isLoggedIn && user.matchMakingSilo)
         {
            params.silo = user.matchMakingSilo;
         }
         request = getMerbProxy().requestQueued("gamenet_match_controller/create",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function pingMatch(jid:String) : EventDispatcher
      {
         request = getMerbProxy().requestQueued("gamenet_match_controller/update",{
            "jid":jid,
            "deleted":0
         });
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function getMatch(id:String) : EventDispatcher
      {
         request = getMerbProxy().requestQueued("gamenet_match_controller/show",{"id":id});
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function updateMatch(data:MatchData) : EventDispatcher
      {
         var params:* = this.prepareMatchParams(data.toSubjectObj());
         request = getMerbProxy().requestQueued("gamenet_match_controller/update",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function setPredictedOpenTime(data:MatchData) : EventDispatcher
      {
         var params:* = {
            "jid":data.roomName,
            "open_at":data.predictedOpenTime
         };
         if(!isNaN(params.open_at))
         {
            params.open_at = params.open_at / 1000;
         }
         request = getMerbProxy().requestQueued("gamenet_match_controller/update",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function searchNewMatches(since:Date, user:PrivateUserData, gameId:String, settings:* = null) : EventDispatcher
      {
         var elo:Number = 1300;
         if(AppComponents.model.arcade.currentGamePack)
         {
            elo = AppComponents.model.arcade.currentGamePack.defaultGuestRating;
         }
         var stats:ArcadeLeaderboardItemData = AppComponents.model.privateUser.getStatsForGame(gameId);
         if(stats && stats.rating > 0)
         {
            elo = stats.rating;
         }
         var params:* = {
            "game_id":gameId,
            "since":Math.floor(since.time / 1000),
            "quickplay":true,
            "max_results":10,
            "player_is_guest":!user.isLoggedIn,
            "origin":AppProperties.origin
         };
         if(user.isLoggedIn && user.matchMakingSilo)
         {
            params.silo = user.matchMakingSilo;
         }
         if(settings)
         {
            if(!isNaN(settings.bet_min) && settings.bet_min > -1)
            {
               params.bet_min = settings.bet_min;
            }
            if(!isNaN(settings.bet_max) && settings.bet_max > -1)
            {
               params.bet_max = settings.bet_max;
            }
         }
         request = getMerbProxy().requestQueued("gamenet_match_controller/search",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function searchMatches(user:PrivateUserData, gameId:String, quickPlay:Boolean = false, serverID:int = -1, settings:* = null) : EventDispatcher
      {
         var elo:Number = 1300;
         if(AppComponents.model.arcade.currentGamePack)
         {
            elo = AppComponents.model.arcade.currentGamePack.defaultGuestRating;
         }
         var stats:ArcadeLeaderboardItemData = AppComponents.model.privateUser.getStatsForGame(gameId);
         if(stats && stats.rating > 0)
         {
            elo = stats.rating;
         }
         var params:* = {
            "game_id":gameId,
            "quickplay":quickPlay,
            "target_elo":elo,
            "player_is_guest":!user.isLoggedIn,
            "max_results":15,
            "origin":AppProperties.origin
         };
         if(user.isLoggedIn && user.matchMakingSilo)
         {
            params.silo = user.matchMakingSilo;
         }
         if(serverID > -1)
         {
            params.server_id = serverID;
         }
         if(settings)
         {
            if(!isNaN(settings.bet_min) && settings.bet_min > -1)
            {
               params.bet_min = settings.bet_min;
            }
            if(!isNaN(settings.bet_max) && settings.bet_max > -1)
            {
               params.bet_max = settings.bet_max;
            }
         }
         if(queueType == MerbProxy.QUEUE_TYPE_IMMEDIATE)
         {
            request = getMerbProxy().requestImmediate("gamenet_match_controller/search",params);
         }
         else
         {
            request = getMerbProxy().requestQueued("gamenet_match_controller/search",params);
         }
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function getMatchStatus(matches:Array) : EventDispatcher
      {
         var params:* = {"jid_array":matches};
         request = getMerbProxy().requestImmediate("gamenet_match_controller/get_status",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function recordMatch(match:MatchData, results:RoundResults, duration:Number) : EventDispatcher
      {
         var result:* = undefined;
         var player:PlayerData = null;
         var o:* = undefined;
         var serializedResults:String = null;
         var standings:Array = [];
         for(var i:int = 0; i < results.list.length; i++)
         {
            result = results.list[i];
            player = result.player;
            o = {
               "position":result.position,
               "score1":result.score1,
               "score2":result.score2,
               "score3":result.score3,
               "score4":result.score4,
               "score5":result.score5
            };
            if(player.isGuest)
            {
               o.anonymous_id = player.guestId;
               o.registered = false;
               o.origin = player.profileOrigin;
            }
            else
            {
               o.profile_id = player.profileId;
               o.registered = true;
               o.origin = player.profileOrigin;
            }
            standings.push(o);
         }
         var params:* = {
            "game_id":match.gameId,
            "game_type":match.gameType,
            "team_type":match.teamType,
            "match_name":match.roomName,
            "round_number":match.round,
            "duration":duration,
            "standings":standings
         };
         try
         {
            if(AppProperties.debugMode != AppProperties.MODE_NOT_DEBUGGING)
            {
               serializedResults = JSON.serialize(params);
               _logger.log("Round recorded",serializedResults);
               if(AppProperties.debugMode == AppProperties.MODE_LOCAL_DEBUGGING)
               {
                  AppComponents.popupManager.popupDebugMessage("Round recorded",serializedResults,true);
               }
            }
         }
         catch(e:Error)
         {
         }
         request = getMerbProxy().requestQueued("gamenet_match_controller/record_match",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
   }
}
