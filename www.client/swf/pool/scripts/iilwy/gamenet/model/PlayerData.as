package iilwy.gamenet.model
{
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.factories.ProductFactory;
   import iilwy.gamenet.developer.ExtendedGamenetPlayerData;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.model.dataobjects.ExperienceData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.shop.ProductInventory;
   import iilwy.utils.TextUtil;
   
   public class PlayerData extends ExtendedGamenetPlayerData
   {
       
      
      public var profileAcceptFriendRequests:Number;
      
      public var profileOrigin:String;
      
      public var score:Object;
      
      public var guestId:String;
      
      public var clientId:String;
      
      public var status:PlayerStatus;
      
      public var profileExperience:Number;
      
      public var experience:ExperienceData;
      
      public var medalHistory:String = "";
      
      public var pingTime:Number = -1;
      
      public var bonus:Number = -1;
      
      public var keepAliveTimeStamp:Number;
      
      public function PlayerData()
      {
         super();
         this.profileOrigin = AppProperties.origin;
         this.experience = new ExperienceData();
         this.activeProducts = new ProductInventory();
      }
      
      public static function createTest(online:Boolean = false) : PlayerData
      {
         var player:PlayerData = new PlayerData();
         var pfile:ProfileData = ProfileData.createTest();
         player.initFromProfile(pfile);
         player.pingTime = 300;
         player.playerJid = Math.floor(Math.random() * 10000).toString();
         var status:PlayerStatus = new PlayerStatus();
         if(online)
         {
            status.offline();
         }
         else
         {
            status.offline();
         }
         player.status = status;
         return player;
      }
      
      public static function createFromStatusApi(data:*) : PlayerData
      {
         var pfile:ProfileData = null;
         var p:PlayerData = new PlayerData();
         pfile = ProfileData.createFromMerbResult(data.profile);
         p.initFromProfile(pfile);
         var status:PlayerStatus = PlayerStatus.createFromApiResult(data);
         p.status = status;
         return p;
      }
      
      public function asProfileData() : ProfileData
      {
         var profile:ProfileData = new ProfileData();
         profile.profile_name = this.profileName;
         profile.firstName = this.profileFirstName;
         profile.id = this.profileId;
         profile.userId = this.userId;
         profile.facebookUID = this.facebookUID;
         profile.catch_phrase = this.profileCatchPhrase;
         profile.photo_url = this.profilePhoto;
         profile.age = Number(this.profileAge);
         profile.location = this.profileLocation;
         profile.acceptFriendRequests = this.profileAcceptFriendRequests;
         profile.experience = this.experience;
         profile.onlineStatus = this.status;
         profile.premiumLevel = this.premiumLevel;
         profile.favoriteGameIDs = this.favoriteGameIDs;
         return profile;
      }
      
      public function initFromPlayerExtension(extension:PlayerExtension) : void
      {
         if(!extension || !extension.status)
         {
            return;
         }
         var statusObj:Object = JSON.deserialize(extension.status);
         this.initFromStatusObject(statusObj);
      }
      
      public function initFromStatusObject(statusObj:Object) : void
      {
         profileName = statusObj.profile_name;
         profileFirstName = statusObj.profile_first_name;
         profileId = statusObj.profile_id;
         profilePhoto = statusObj.profile_photo;
         profileCatchPhrase = statusObj.profile_catch_phrase;
         playerJid = statusObj.jid;
         userId = statusObj.user_id;
         facebookUID = statusObj.facebook_uid;
         profileAge = statusObj.profile_age;
         profileLocation = statusObj.profile_location;
         this.profileAcceptFriendRequests = statusObj.profile_accept_friend_requests;
         this.guestId = statusObj.guest_id;
         this.profileOrigin = statusObj.profile_origin;
         premiumLevel = statusObj.premium_level;
         this.experience.level = statusObj.exp_level;
         this.experience.experiencePoints = statusObj.exp_points;
         activeProductData = DataUtil.createActiveProductDataFromSlate(statusObj.slate,playerJid);
         this.medalHistory = statusObj.medal_history;
         gameLevels = statusObj.game_levels;
         gameRatings = statusObj.game_ratings;
         this.pingTime = statusObj.ping_time;
         this.bonus = statusObj.bonus;
         this.clientId = statusObj.client_id;
      }
      
      public function set activeProducts(p:ProductInventory) : void
      {
         activeProductData = ProductFactory.serializeProductInventory(p);
      }
      
      public function toMinimizedStatusObject() : Object
      {
         var obj:Object = {
            "profile_name":profileName,
            "profile_first_name":profileFirstName,
            "profile_id":profileId,
            "user_id":userId,
            "guest_id":this.guestId,
            "profile_photo":profilePhoto,
            "jid":playerJid,
            "premium_level":premiumLevel,
            "client_id":this.clientId
         };
         return obj;
      }
      
      public function toStatusObject() : Object
      {
         var obj:Object = {
            "profile_name":profileName,
            "profile_first_name":profileFirstName,
            "profile_id":profileId,
            "user_id":userId,
            "facebook_uid":facebookUID,
            "profile_photo":profilePhoto,
            "profile_catch_phrase":profileCatchPhrase,
            "jid":playerJid,
            "profile_age":profileAge,
            "profile_location":profileLocation,
            "profile_origin":this.profileOrigin,
            "profile_accept_friend_requests":this.profileAcceptFriendRequests,
            "guest_id":this.guestId,
            "exp_level":this.experience.level,
            "exp_points":this.experience.experiencePoints,
            "slate":DataUtil.createSlateFromActiveProductData(activeProductData,playerJid),
            "premium_level":premiumLevel,
            "game_ratings":gameRatings,
            "game_levels":gameLevels,
            "medal_history":this.medalHistory,
            "ping_time":this.pingTime,
            "bonus":this.bonus,
            "client_id":this.clientId
         };
         return obj;
      }
      
      public function toStatusString() : String
      {
         return JSON.serialize(this.toStatusObject());
      }
      
      public function toExtension() : PlayerExtension
      {
         var extension:PlayerExtension = new PlayerExtension();
         extension.status = this.toStatusString();
         return extension;
      }
      
      public function copy(from:PlayerData) : void
      {
         playerJid = from.playerJid;
         profilePhoto = from.profilePhoto;
         profileName = from.profileName;
         profileFirstName = from.profileFirstName;
         profileCatchPhrase = from.profileCatchPhrase;
         profileId = from.profileId;
         userId = from.userId;
         facebookUID = from.facebookUID;
         profileAge = from.profileAge;
         profileLocation = from.profileLocation;
         this.profileAcceptFriendRequests = from.profileAcceptFriendRequests;
         this.guestId = from.guestId;
         this.score = from.score;
         this.experience.copy(from.experience);
         activeProductData = from.activeProductData;
         premiumLevel = from.premiumLevel;
         favoriteGameIDs = from.favoriteGameIDs;
         gameRatings = from.gameRatings;
         gameLevels = from.gameLevels;
         this.pingTime = from.pingTime;
         this.medalHistory = from.medalHistory;
         this.bonus = from.bonus;
         this.clientId = from.clientId;
      }
      
      public function get isGuest() : Boolean
      {
         var flag:Boolean = false;
         if(this.guestId)
         {
            flag = true;
         }
         if(profileId)
         {
            flag = false;
         }
         return flag;
      }
      
      public function getInGameAboutString() : String
      {
         var gameId:String = null;
         var str:String = "";
         var components:Array = [];
         try
         {
            gameId = AppComponents.model.arcade.currentGamePack.id;
         }
         catch(e:Error)
         {
         }
         if(gameId && gameLevels && gameLevels[gameId] && gameLevels[gameId] > 0)
         {
            components.push("Game Level " + gameLevels[AppComponents.gamenetManager.currentMatch.gameId]);
         }
         if(profileCatchPhrase)
         {
            components.push(AppComponents.textOffendCheck.screenOffensive(profileCatchPhrase));
         }
         str = TextUtil.makeSlashSeparatedString(components);
         return str;
      }
      
      public function getAboutString() : String
      {
         var str:String = "";
         var components:Array = [];
         if(this.experience && this.experience.level > 0)
         {
            components.push("Level " + this.experience.level);
         }
         if(profileCatchPhrase)
         {
            components.push(AppComponents.textOffendCheck.screenOffensive(profileCatchPhrase));
         }
         str = TextUtil.makeSlashSeparatedString(components);
         return str;
      }
      
      public function initFromProfile(p:ProfileData) : void
      {
         profileName = p.profile_name;
         profileFirstName = p.firstName;
         profileId = p.id;
         userId = p.userId;
         facebookUID = p.facebookUID;
         profilePhoto = p.photo_url;
         profileClanName = p.clan_name;
         profileCatchPhrase = p.catch_phrase;
         profileAge = p.age.toString();
         profileLocation = p.location;
         this.profileAcceptFriendRequests = p.acceptFriendRequests;
         this.experience.copy(p.experience);
         premiumLevel = p.premiumLevel;
         favoriteGameIDs = p.favoriteGameIDs;
         this.activeProducts = p.activeProducts;
         this.guestId = null;
         this.status = p.onlineStatus;
      }
      
      public function clone() : PlayerData
      {
         var p:PlayerData = new PlayerData();
         p.copy(this);
         return p;
      }
   }
}
