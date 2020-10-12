package iilwy.model.dataobjects
{
   import com.adobe.utils.DateUtil;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.avatar.AvatarPack;
   import iilwy.model.dataobjects.avatar.BasicAvatar;
   import iilwy.model.dataobjects.shop.ProductInventory;
   import iilwy.utils.ChatUtil;
   import iilwy.utils.TestUtil;
   import iilwy.utils.TextUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class ProfileData
   {
      
      public static const CLAN_NAME_MAX_LENGTH:int = 8;
       
      
      public var data:Object;
      
      public var id:String;
      
      public var userId:int;
      
      public var facebookUID:Number;
      
      public var premiumLevel:int;
      
      public var profile_name:String;
      
      public var clan_name:String;
      
      public var catch_phrase:String;
      
      public var gender:int = -1;
      
      public var age:int;
      
      public var location:String;
      
      public var watch_level:String;
      
      public var photo_url:String;
      
      public var distance:String;
      
      public var direction:String;
      
      public var description:String;
      
      public var status:String;
      
      public var bio:String;
      
      public var hasMobile:Boolean;
      
      public var background:String;
      
      public var closedGames:Array;
      
      public var yesNoAnswers:Array;
      
      public var stats:Object;
      
      public var fullTextAnswers:Array;
      
      public var favoriteGameIDs:Array;
      
      public var in_top_five:Boolean = true;
      
      public var photos:Array;
      
      public var videos:Array;
      
      public var acceptFriendRequests:Number = 0;
      
      public var experience:ExperienceData;
      
      public var avatar:BasicAvatar;
      
      public var activeProducts:ProductInventory;
      
      public var onlineStatus:PlayerStatus;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var city:String;
      
      public var state:String;
      
      public var country:String;
      
      public var email:String;
      
      public var lastLogin:Date;
      
      private var _chatUserJID:UnescapedJID;
      
      public function ProfileData()
      {
         super();
         this.experience = new ExperienceData();
         this.avatar = new BasicAvatar();
         this.onlineStatus = new PlayerStatus();
         this.activeProducts = new ProductInventory();
         this.premiumLevel = 0;
      }
      
      public static function createFromMerbResult(data:*) : ProfileData
      {
         var avatarPack:AvatarPack = null;
         var pd:ProfileData = new ProfileData();
         pd.id = data.profile_id;
         pd.userId = data.user_id;
         pd.premiumLevel = data.premium_level;
         pd.facebookUID = data.facebook_id;
         if(data.experience)
         {
            pd.experience = ExperienceData.createFromMerbResult(data.experience);
         }
         if(data.location)
         {
            pd.location = TextUtil.stripDoubleCommas(data.location);
         }
         if(data.catch_phrase)
         {
            pd.catch_phrase = AppComponents.textOffendCheck.screenOffensive(data.catch_phrase);
         }
         if(data.avatar)
         {
            avatarPack = new AvatarPack(data.avatar);
            pd.avatar = new BasicAvatar();
            pd.avatar.pack = avatarPack;
         }
         pd.photo_url = data.photo_url;
         pd.profile_name = data.profile_name;
         pd.clan_name = Boolean(data.clan_name)?data.clan_name.substr(0,Math.min(data.clan_name.length,CLAN_NAME_MAX_LENGTH)):"";
         pd.background = AppComponents.model.standardBackgrounds[data.background_image_id];
         if(data.bio)
         {
            pd.bio = AppComponents.textOffendCheck.screenOffensive(data.bio);
         }
         pd.gender = Boolean(data.gender)?int(data.gender):int(pd.gender);
         pd.age = Boolean(data.age)?int(data.age):int(pd.age);
         pd.firstName = data.first_name;
         pd.lastName = data.last_name;
         pd.city = data.city;
         pd.state = data.state;
         pd.country = data.country;
         if(data.photos)
         {
            pd.photos = MediaItemData.createListFromMerbRequest(data.photos);
         }
         if(data.last_login_at)
         {
            pd.lastLogin = DateUtil.parseW3CDTF(data.last_login_at);
         }
         pd.favoriteGameIDs = data.favorite_game_ids;
         return pd;
      }
      
      public static function createTest() : ProfileData
      {
         var test:ProfileData = new ProfileData();
         var name:String = TestUtil.randomName();
         test.profile_name = name;
         test.id = name.toLowerCase();
         test.catch_phrase = TestUtil.generateLoremImsum(8);
         test.age = Math.floor(Math.random() * 10) + 18;
         test.location = "City, ST";
         var photos:Array = ["http://media.beta.iminlikewithyou.com/5/photos/5yuzrjm1mbnxrfx.gif","http://media.beta.iminlikewithyou.com/120/photos/120f7o10j8kud1quv.jpg","http://media.beta.iminlikewithyou.com/27/photos/27lnsphbwr5lvxv1.jpg"];
         test.photo_url = photos[Math.floor(Math.random() * photos.length)];
         return test;
      }
      
      public function get chatUserJID() : UnescapedJID
      {
         return Boolean(this._chatUserJID)?this._chatUserJID:ChatUtil.getJIDFromUserID(this.userId);
      }
      
      public function set chatUserJID(value:UnescapedJID) : void
      {
         this._chatUserJID = value;
      }
      
      public function get isMe() : Boolean
      {
         return AppComponents.model.privateUser.isLoggedIn && AppComponents.model.privateUser.profile.id == this.id;
      }
      
      public function get isFriend() : Boolean
      {
         return !this.isMe && this.chatUserJID && (AppComponents.chatManager.isFriend(this.chatUserJID) || AppComponents.fbChatManager && AppComponents.fbChatManager.isFriend(this.chatUserJID));
      }
      
      public function get isOnlineFriend() : Boolean
      {
         return !this.isMe && this.chatUserJID && (AppComponents.chatManager.isOnlineFriend(this.chatUserJID) || AppComponents.fbChatManager && AppComponents.fbChatManager.isOnlineFriend(this.chatUserJID));
      }
      
      public function get displayName() : String
      {
         var name:String = Boolean(this.clan_name)?this.profile_name + " [" + this.clan_name + "]":this.profile_name;
         if(AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE && this.firstName)
         {
            name = this.firstName;
         }
         return name;
      }
      
      public function getAboutString() : String
      {
         var str:String = "";
         var components:Array = [];
         if(this.experience && this.experience.level > 0)
         {
            components.push("Level " + this.experience.level);
         }
         if(this.onlineStatus && this.onlineStatus.isJoinable)
         {
            components.push(this.onlineStatus.description);
         }
         if(this.catch_phrase)
         {
            components.push(AppComponents.textOffendCheck.screenOffensive(this.catch_phrase));
         }
         str = TextUtil.makeSlashSeparatedString(components);
         return str;
      }
      
      public function initFromBrowseJSON(json:Object) : void
      {
         this.id = json.profile_id;
         this.location = TextUtil.stripDoubleCommas(json.location);
         this.photo_url = json.photo_url;
         this.acceptFriendRequests = json.available_for_request;
         this.premiumLevel = json.premium_level;
         this.profile_name = json.profile_name;
         this.watch_level = json.watch_level;
         this.gender = Boolean(json.gender)?int(json.gender):int(this.gender);
         this.age = Boolean(json.age)?int(json.age):int(this.age);
         this.direction = json.direction;
         this.distance = json.distance;
         try
         {
            if(json.in_top_five == false)
            {
               this.in_top_five = false;
            }
            else
            {
               this.in_top_five = true;
            }
         }
         catch(e:Error)
         {
         }
         this.catch_phrase = AppComponents.textOffendCheck.screenOffensive(json.catch_phrase);
      }
      
      public function initFromJSON(json:Object) : void
      {
         this.acceptFriendRequests = json.profile.available_for_request;
         this.userId = json.profile.user_id;
         this.id = json.profile.profile_id;
         this.facebookUID = json.profile.facebook_id;
         this.profile_name = json.profile.profile_name;
         if(json.profile.catch_phrase)
         {
            this.catch_phrase = AppComponents.textOffendCheck.screenOffensive(json.profile.catch_phrase);
         }
         this.gender = Boolean(json.profile.gender)?int(json.profile.gender):int(this.gender);
         this.age = Boolean(json.profile.age)?int(json.profile.age):int(this.age);
         if(json.profile.location)
         {
            this.location = TextUtil.stripDoubleCommas(json.profile.location);
         }
         this.watch_level = json.profile.watch_level;
         this.photo_url = json.profile.photo_url;
         this.distance = json.profile.distance;
         this.direction = json.profile.direction;
         this.premiumLevel = json.premium_level;
         this.description = json.description;
         this.bio = json.profile.bio;
         this.photos = json.profile.photos;
         this.videos = json.profile.videos;
         this.background = AppComponents.model.standardBackgrounds[json.profile.background_image];
         this.closedGames = json.closed_games;
         this.yesNoAnswers = json.yes_no_answers;
         this.stats = json.stats;
         this.fullTextAnswers = json.fulltext_answers;
         this.favoriteGameIDs = json.favorite_game_ids;
         this.firstName = json.profile.first_name;
         this.lastName = json.profile.last_name;
         this.city = json.profile.city;
         this.state = json.profile.state;
         this.country = json.profile.country;
         if(json.profile.last_login_at)
         {
            this.lastLogin = DateUtil.parseW3CDTF(json.profile.last_login_at);
         }
         this.data = json;
      }
   }
}
