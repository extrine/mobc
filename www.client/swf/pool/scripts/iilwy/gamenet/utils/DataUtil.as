package iilwy.gamenet.utils
{
   import be.boulevart.as3.security.RC4;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.gamenet.GamenetManager;
   import iilwy.gamenet.model.MatchData;
   import iilwy.gamenet.model.MatchListingData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardItemData;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.shop.enum.ProductShopKey;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.utils.MathUtil;
   import iilwy.utils.logging.Logger;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
   
   public class DataUtil
   {
      
      private static const matchRexExp:RegExp = /^m_([a-z0-9]+)_([0-9]+)_([0-9]+)_([0-9]+)/;
      
      private static const BASELINE_COMPRESS_DATE:Number = 1251777600000;
       
      
      public function DataUtil()
      {
         super();
      }
      
      public static function createSlateFromActiveProductData(activeProductData:*, playerJid:String) : String
      {
         var pData:String = null;
         var reducedData:* = {};
         if(AppComponents.model.arcade.currentGamePack && AppComponents.model.arcade.currentGamePack.shopId >= 0)
         {
            reducedData[AppComponents.model.arcade.currentGamePack.shopId] = activeProductData[AppComponents.model.arcade.currentGamePack.shopId];
         }
         reducedData[ProductShopKey.WEBSITE] = activeProductData[ProductShopKey.WEBSITE];
         pData = JSON.serialize(reducedData);
         var itemsRegEx:RegExp = new RegExp(AppProperties.fileServerItems + "productbase","gi");
         var mediaRegEx:RegExp = new RegExp(AppProperties.fileServerMedia + "productbase","gi");
         pData = pData.replace(itemsRegEx,"__i");
         pData = pData.replace(mediaRegEx,"__m");
         pData = RC4.encrypt(pData,playerJid);
         return pData;
      }
      
      public static function createActiveProductDataFromSlate(slate:String, playerJid:String) : *
      {
         var pData:String = null;
         var activeProductData:* = {};
         if(slate)
         {
            pData = RC4.decrypt(slate,playerJid);
            try
            {
               pData = pData.replace(/__i/gi,AppProperties.fileServerItems + "productbase");
               pData = pData.replace(/__m/gi,AppProperties.fileServerMedia + "productbase");
               activeProductData = JSON.deserialize(pData);
            }
            catch(e:Error)
            {
            }
         }
         return activeProductData;
      }
      
      public static function getSubdomainFromURL(url:String) : String
      {
         return url.split(".")[0];
      }
      
      public static function getSubjectFromServiceInfo(iq:IQ) : Object
      {
         var infoExt:InfoDiscoExtension = null;
         var node:XML = null;
         var disco:Namespace = null;
         var xns:Namespace = null;
         var rawSubject:String = null;
         var subjectObj:* = undefined;
         infoExt = iq.getAllExtensions()[0];
         node = new XML(infoExt.getNode());
         disco = new Namespace("http://jabber.org/protocol/disco#info");
         xns = new Namespace("jabber:x:data");
         rawSubject = node..xns::field.(attribute("label") == "Subject").xns::value;
         try
         {
            subjectObj = JSON.deserialize(rawSubject);
         }
         catch(e:Error)
         {
         }
         return subjectObj;
      }
      
      public static function generateMatchName(gameName:String, serverID:int, userId:String, time:Number) : String
      {
         var str:String = "";
         var un:String = escape(userId).substr(0,10);
         var t:String = time.toString();
         str = "m_" + gameName + "_" + serverID.toString() + "_" + un + "_" + t;
         Logger.getLogger("DataUtil").debug("Created match name: ",str,", chars: ",str.length);
         return str;
      }
      
      public static function isValidMatchName(matchName:String) : Boolean
      {
         var match:* = matchName.match(matchRexExp);
         return match != null;
      }
      
      public static function roomNameFromFullJID(fullJID:String) : String
      {
         var result:String = null;
         try
         {
            result = fullJID.match(/^(\w+)@/)[1];
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      public static function getPlayerToMatchRatingOffsetValue(playerElo:Number, matchElo:Number, pack:ArcadeGamePackData) : Number
      {
         var rating:Number = playerElo;
         if(isNaN(matchElo) || !pack)
         {
            return 0;
         }
         if(isNaN(playerElo) || playerElo <= 0)
         {
            rating = pack.defaultGuestRating;
         }
         if(isNaN(playerElo) || playerElo <= 0)
         {
            rating = 1300;
         }
         var result:Number = 0;
         if(rating > matchElo + pack.maximumRatingTolerance)
         {
            result = -2;
         }
         else if(rating > matchElo + pack.minimumRatingTolerance)
         {
            result = -1;
         }
         else if(rating < matchElo - pack.minimumRatingTolerance)
         {
            result = 1;
         }
         else if(rating < matchElo - pack.maximumRatingTolerance)
         {
            result = 2;
         }
         return result / 2;
      }
      
      public static function getServerIDFromMatchName(matchName:String) : int
      {
         var id:int = -1;
         try
         {
            id = matchName.match(matchRexExp)[2];
         }
         catch(e:Error)
         {
         }
         return id;
      }
      
      public static function getGameIdFromMatchName(matchName:String) : String
      {
         var id:String = null;
         try
         {
            id = matchName.match(matchRexExp)[1];
         }
         catch(e:Error)
         {
         }
         return id;
      }
      
      public static function getMatchCreationTime(matchName:String) : String
      {
         var result:String = null;
         try
         {
            result = matchName.match(matchRexExp)[4];
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      public static function isMatchRecent(matchName:String, windowMinutes:Number, currentTime:Number) : Boolean
      {
         var time:String = null;
         var diff:Number = NaN;
         var result:Boolean = true;
         try
         {
            time = getMatchCreationTime(matchName);
            diff = currentTime - Number(time);
            if(diff > windowMinutes * 60 * 1000)
            {
               result = false;
            }
         }
         catch(e:Error)
         {
         }
         return result;
      }
      
      public static function createShortInviteLink(match:MatchData, user:PrivateUserData) : String
      {
         var str:String = "i/" + match.gameId + "/" + match.uid.toString(36);
         if(user.isLoggedIn)
         {
            str = str + ("_" + user.id.toString(36));
         }
         return str;
      }
      
      public static function createShortFacebookInviteLink() : String
      {
         return "jfb/" + AppComponents.model.privateUser.facebook.session.uid;
      }
      
      public static function parseInviteLink(link:String) : *
      {
         var str:String = null;
         var elements:Array = link.split("_");
         var result:* = {};
         if(elements.length > 0)
         {
            str = elements[0];
            result.matchId = parseInt(str,36);
         }
         if(elements.length > 1)
         {
            str = elements[1];
            result.inviterId = parseInt(str,36);
         }
         return result;
      }
      
      public static function canUserJoinMatch(user:PrivateUserData, match:MatchListingData) : Boolean
      {
         var reason:String = canUserJoinMatchReason(user,match);
         if(reason)
         {
            return false;
         }
         return true;
      }
      
      public static function canUserJoinMatchReason(user:PrivateUserData, match:MatchListingData) : String
      {
         var playerIndex:int = 0;
         var playerData:PlayerData = null;
         var profileData:ProfileData = null;
         var reason:String = null;
         var hasFriendInMatch:Boolean = false;
         var chatUser:ChatUser = null;
         var stats:ArcadeLeaderboardItemData = null;
         var pack:ArcadeGamePackData = AppComponents.model.arcade.getGamePack(match.gameId);
         for(var i:int = 0; i < match.players.length; i++)
         {
            playerData = match.players.getItemAt(i);
            chatUser = AppComponents.model.privateUser.friends.getFriend(0,playerData.profileId);
            if(chatUser)
            {
               hasFriendInMatch = true;
               break;
            }
         }
         if(!pack)
         {
            reason = "Game not loaded.";
            return reason;
         }
         if(pack.isRestricted)
         {
            reason = "You had a problem joining this game.";
            return reason;
         }
         if(match.libVersion != pack.libVersion && pack.libVersion != ArcadeGamePackData.LIB_VERSION_LOCAL)
         {
            reason = "Your version of this game is out of sync with the host\'s. Please clear your browser cache and refresh.";
            return reason;
         }
         if(match.betAmount > user.currentBalance.soft)
         {
            reason = "You don\'t have enough coins to bet in this game. <u><a href=\'event:coinshop\'>Get some more coins!</a></u>.";
            return reason;
         }
         if(AppComponents.model.arcade.inviter)
         {
            playerData = match.players.findPlayerByProfileId(AppComponents.model.arcade.inviter.id);
            if(playerData)
            {
               return null;
            }
         }
         var rating:Number = user.getStatsForGame(match.gameId).rating;
         if(pack)
         {
            rating = MathUtil.clamp(pack.minimumComparisonRating,pack.maximumComparisonRating,rating);
         }
         var offset:Number = getPlayerToMatchRatingOffsetValue(rating,match.avgRating,pack);
         if(offset < -0.5 && !hasFriendInMatch)
         {
            reason = "Wow, you are good! You should play in a more challenging match. <br/>" + "<u><a href = \'event:" + pack.quickPlayUrl + "\'>Click here to find a better match.</a></u>";
            return reason;
         }
         if(AppProperties.debugMode == AppProperties.MODE_NOT_DEBUGGING)
         {
            if(user.isLoggedIn && user.profile.id)
            {
               playerData = match.players.findPlayerByProfileId(user.profile.id);
               if(playerData)
               {
                  if(user.isLoggedIn)
                  {
                     AppComponents.analytics.trackDiagnostic("doublejoin/user/" + user.id);
                  }
                  reason = "You had a problem joining this match.";
                  return reason;
               }
            }
            for each(playerData in match.players.source)
            {
               if(AppComponents.gamenetManager.currentPlayer.clientId && playerData.clientId == AppComponents.gamenetManager.currentPlayer.clientId && pack.libVersion != ArcadeGamePackData.LIB_VERSION_LOCAL)
               {
                  if(user.isLoggedIn)
                  {
                     AppComponents.analytics.trackDiagnostic("doublejoin/user/" + user.id);
                  }
                  else
                  {
                     AppComponents.analytics.trackDiagnostic("doublejoin/guest" + playerData.clientId);
                  }
                  reason = "There was an unspecified problem joining this match.";
                  return reason;
               }
            }
         }
         if(!user.isLoggedIn && !match.allowGuests)
         {
            reason = "Guests are not allowed in this match.";
            return reason;
         }
         if(match.friendsOnly)
         {
            if(!user.isLoggedIn)
            {
               reason = "Only friends of the players can join this match. Please log in.";
               return reason;
            }
            if(!hasFriendInMatch)
            {
               reason = "Only friends of the players can join this match";
               return reason;
            }
         }
         if(!isNaN(match.minLevel) && match.minLevel > 0)
         {
            if(!user.isLoggedIn)
            {
               reason = "This match has a minimum level required. Please log in.";
               return reason;
            }
            if(user.profile.experience.level < match.minLevel)
            {
               reason = "This match has a minimum level of " + match.minLevel + " required. " + "Your are only level " + user.profile.experience.level + ". " + "Please join another match.";
               return reason;
            }
         }
         if(!isNaN(match.minRating) && match.minRating > 0)
         {
            if(!user.isLoggedIn)
            {
               reason = "This match has a minimum rating required. Please log in.";
               return reason;
            }
            stats = user.getStatsForGame(match.gameId);
            reason = "This match has a minimum rating of " + match.minRating + " required. ";
            if(!stats || stats.isProvisional)
            {
               reason = reason + "You need to play more to get an accurate rating.";
               return reason;
            }
            if(stats.rating < match.minRating)
            {
               reason = reason + ("Your rating is only " + stats.rating + ".");
               return reason;
            }
            reason = "";
         }
         return null;
      }
      
      public static function compressTimeStamp(time:Number) : String
      {
         var num:Number = time - BASELINE_COMPRESS_DATE;
         return num.toString(26);
      }
      
      public static function expandTimeStamp(timeStamp:String) : Number
      {
         var num:Number = parseInt(timeStamp,26);
         return BASELINE_COMPRESS_DATE + num;
      }
      
      public static function normalizeJID(jid:UnescapedJID) : UnescapedJID
      {
         var gamenetManager:GamenetManager = AppComponents.gamenetManager;
         var node:String = jid.domain == gamenetManager.conferenceServer?jid.resource.indexOf("@") > -1?jid.resource.slice(0,jid.resource.indexOf("@")):jid.resource:jid.node;
         var domain:String = jid.domain == gamenetManager.conferenceServer?gamenetManager.serverURL:jid.domain;
         var resource:String = "/xiff";
         return new UnescapedJID(node + "@" + domain + resource);
      }
      
      public static function getInviteLinkBaseURL() : String
      {
         var appName:String = null;
         if(AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE)
         {
            appName = AppProperties.parentParameters.fb_app_name;
            return "https://apps.facebook.com/" + appName + "/";
         }
         if(!AppProperties.appVersionIsWebsiteOrAIR && EmbedSettings.getInstance().inviteLinkBaseURL)
         {
            return EmbedSettings.getInstance().inviteLinkBaseURL;
         }
         if(AppProperties.debugMode == AppProperties.MODE_REMOTE_DEBUGGING)
         {
            return "http://www.omgpop.com/?beta=swifty_poo";
         }
         return "http://omgpop.com/";
      }
      
      public static function getFullInviteLinkURL(match:MatchData, user:PrivateUserData) : String
      {
         var url:String = "";
         var baseURL:String = getInviteLinkBaseURL();
         if(AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE)
         {
            return baseURL + "?app_data=" + encodeURIComponent(createShortFacebookInviteLink());
         }
         var inviteLink:String = createShortInviteLink(match,user);
         var split:Array = baseURL.split("?");
         split.splice(1,0,inviteLink);
         url = url + split.shift();
         url = url + split.join("?");
         return url;
      }
      
      public function extractPlayerJIDFromSender(sender:String) : String
      {
         return sender.match(/\/(\w+$)/)[1];
      }
   }
}
