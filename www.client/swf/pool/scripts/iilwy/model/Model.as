package iilwy.model
{
   import flash.display.Bitmap;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.events.ModelEvent;
   import iilwy.model.dataobjects.ArcadeData;
   import iilwy.model.dataobjects.LiveStreamData;
   import iilwy.model.dataobjects.LoggedOutHomepageData;
   import iilwy.model.dataobjects.MiniProfileBrowserData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.SearchPrefs;
   import iilwy.model.dataobjects.ViralMediaListData;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.shop.GlobalProductShopModel;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.model.dataobjects.user.PublicUserData;
   import iilwy.model.local.LocalProperties;
   import iilwy.net.ApiRequest;
   import iilwy.net.MerbProxyProperties;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class Model extends EventDispatcher implements IModel
   {
       
      
      public var privateUser:PrivateUserData;
      
      public var currentPublicUser:PublicUserData;
      
      public var shop:GlobalProductShopModel;
      
      public var currentProfile:ProfileData;
      
      public var popularBoards:Object;
      
      public var signupSettingsMeta:Object;
      
      public var miniProfileBrowser:MiniProfileBrowserData;
      
      public var activityDataArray:Array;
      
      public var news:ViralMediaListData;
      
      public var viralVideos:ViralMediaListData;
      
      public var arcade:ArcadeData;
      
      public var loggedOutHomepage:LoggedOutHomepageData;
      
      public var liveStreamStatus:Boolean = false;
      
      public var liveStream:LiveStreamData;
      
      public var searchPrefs:SearchPrefs;
      
      public var profileCache:Object;
      
      private var _currentBackground;
      
      private var _arrivalTime:Number;
      
      private var _lastProfileRequest:ApiRequest;
      
      private var _loadingProfile:Boolean = false;
      
      public var debugMode:Boolean = false;
      
      public var firstSessionLoaded:Boolean = false;
      
      public var facebookInitialized:Boolean = false;
      
      public var defaultBetRange:String;
      
      public var lastBetAmount:int = -1;
      
      private var _sessionStartDate:Date;
      
      private var _sessionStartTime:Number;
      
      private var _logger:Logger;
      
      private var _globalVolume:Number;
      
      private var _clientId:int;
      
      public var standardBackgrounds:Dictionary;
      
      public function Model()
      {
         super();
         this._logger = Logger.getLogger(this);
         this.privateUser = new PrivateUserData();
         this.privateUser.clear();
         this.currentPublicUser = new PublicUserData();
         this.currentPublicUser.clear();
         this.currentProfile = new ProfileData();
         this.searchPrefs = new SearchPrefs();
         this.news = new ViralMediaListData();
         this.viralVideos = new ViralMediaListData();
         this.miniProfileBrowser = new MiniProfileBrowserData();
         this.liveStream = new LiveStreamData();
         this.arcade = new ArcadeData();
         this.shop = new GlobalProductShopModel();
         this.loggedOutHomepage = new LoggedOutHomepageData();
         this.standardBackgrounds = createStandardBackgrounds();
         this._sessionStartTime = getTimer();
         this._sessionStartDate = new Date();
      }
      
      public static function createStandardBackgrounds() : Dictionary
      {
         var bgs:Dictionary = new Dictionary();
         bgs["1"] = "http://staticcdn.iminlikewithyou.com/standard1.jpg";
         bgs["2"] = "http://staticcdn.iminlikewithyou.com/standard2.jpg";
         bgs["3"] = "http://staticcdn.iminlikewithyou.com/standard3.jpg";
         bgs["4"] = "http://staticcdn.iminlikewithyou.com/awesome.jpg";
         bgs["5"] = "http://staticcdn.iminlikewithyou.com/army.jpg";
         bgs["6"] = "http://staticcdn.iminlikewithyou.com/staygolden.jpg";
         bgs["7"] = "http://staticcdn.iminlikewithyou.com/blackgrad.jpg";
         bgs["8"] = "http://staticcdn.iminlikewithyou.com/ilovepoop.jpg";
         bgs["9"] = "http://staticcdn.iminlikewithyou.com/booger.jpg";
         bgs["10"] = "http://staticcdn.iminlikewithyou.com/pouisvutton.jpg";
         bgs["11"] = "http://staticcdn.iminlikewithyou.com/pinkpoo.jpg";
         bgs["12"] = "http://staticcdn.iminlikewithyou.com/eatpuppies.jpg";
         bgs["13"] = "http://staticcdn.iminlikewithyou.com/blueball.jpg";
         bgs["14"] = "http://staticcdn.iminlikewithyou.com/sharkweek.jpg";
         bgs["15"] = "http://staticcdn.iminlikewithyou.com/purplepoo.jpg";
         bgs["16"] = "http://staticcdn.iminlikewithyou.com/droppinjewels.jpg";
         bgs["17"] = "http://staticcdn.iminlikewithyou.com/purpleletter.jpg";
         bgs["18"] = "http://staticcdn.iminlikewithyou.com/kindagay.jpg";
         bgs["19"] = "http://staticcdn.iminlikewithyou.com/fuckyeahblack.jpg";
         bgs["20"] = "http://staticcdn.iminlikewithyou.com/dusk.jpg";
         bgs["21"] = "http://staticcdn.iminlikewithyou.com/pink.jpg";
         bgs["22"] = "http://staticcdn.iminlikewithyou.com/redpurple.jpg";
         bgs["23"] = "http://staticcdn.iminlikewithyou.com/trees.jpg";
         bgs["24"] = "http://staticcdn.iminlikewithyou.com/sherbet.jpg";
         return bgs;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function get currentBackground() : *
      {
         return this._currentBackground;
      }
      
      public function get clientId() : String
      {
         var clientId:String = null;
         try
         {
            clientId = AppComponents.localStore.getObject(LocalProperties.SAVED_CLIENT_ID);
            if(!clientId)
            {
               clientId = AppComponents.model.serverNow.time.toString() + Math.floor(Math.random() * 100000).toString();
               AppComponents.localStore.saveObject(LocalProperties.SAVED_CLIENT_ID,clientId);
            }
         }
         catch(e:Error)
         {
         }
         return clientId;
      }
      
      public function get inviteCookieCode() : String
      {
         var code:String = "";
         try
         {
            code = ExternalInterface.call("getInviteCookie");
         }
         catch(e:Error)
         {
         }
         return code;
      }
      
      public function set globalQuality(value:String) : void
      {
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.GLOBAL_QUALITY,value,true);
         StageReference.stage.quality = value;
      }
      
      public function get globalQuality() : String
      {
         var q:String = StageReference.stage.quality;
         return StageReference.stage.quality;
      }
      
      public function set globalVolume(n:Number) : void
      {
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.GLOBAL_VOLUME,n,true);
         this._globalVolume = n;
      }
      
      public function get globalVolume() : Number
      {
         var stored:Number = NaN;
         if(isNaN(this._globalVolume))
         {
            stored = AppComponents.localStore.getUserSpecificObject(LocalProperties.GLOBAL_VOLUME);
            if(isNaN(stored))
            {
               AppComponents.localStore.saveUserSpecificObject(LocalProperties.GLOBAL_VOLUME,1,true);
               this._globalVolume = 1;
            }
            else
            {
               this._globalVolume = stored;
            }
         }
         return this._globalVolume;
      }
      
      public function setCurrentBackground(url:String = null, bitmap:Bitmap = null) : void
      {
         if(!url && !bitmap)
         {
            return;
         }
         this._currentBackground = Boolean(url)?url:bitmap;
         dispatchEvent(new ModelEvent(ModelEvent.CHANGE_BACKGROUND,this._currentBackground));
      }
      
      public function setDefaultBackground() : void
      {
         dispatchEvent(new ModelEvent(ModelEvent.RESET_DEFAULT_BACKGROUND));
      }
      
      public function dispatchToFriendsView(oldStatus:String, newStatus:String, profileName:String) : void
      {
         dispatchEvent(new ModelEvent(ModelEvent.UPDATE_USER_FRIEND_LIST,{
            "profile_name":profileName,
            "old_status":oldStatus,
            "new_status":newStatus
         }));
      }
      
      public function getRecipientProfiles(str:String) : Array
      {
         var name:String = null;
         var chatUser:ChatUser = null;
         var buddy:ProfileData = null;
         var nameArray:Array = str.split(",");
         var idList:String = "";
         var trim:RegExp = /^[ \t]+|[ \t]+$/g;
         var profileArray:Array = new Array();
         for each(name in nameArray)
         {
            name = name.replace(trim,"");
            if(name != "" && name != null)
            {
               chatUser = this.privateUser && this.privateUser.friends?this.privateUser.friends.getFriend(0,null,name):null;
               buddy = Boolean(chatUser)?chatUser.asProfileData():null;
               if(buddy != null && buddy.id != "" && buddy.id != null)
               {
                  profileArray.push(buddy);
               }
            }
         }
         return profileArray;
      }
      
      public function get serverNow() : Date
      {
         return MerbProxyProperties.serverNow;
      }
      
      public function markArrivalTime() : void
      {
         var already:* = undefined;
         if(!this._arrivalTime)
         {
            already = AppComponents.localStore.getExpiringObject("arrivalTime");
            if(!already)
            {
               already = this.serverNow.getTime();
               AppComponents.localStore.saveExpiringObject("arrivalTime",3 * 60 * 60 * 1000,already);
            }
            this._arrivalTime = already;
         }
      }
      
      public function get arrivalTime() : Number
      {
         this.markArrivalTime();
         return this._arrivalTime;
      }
      
      public function get timeOnSite() : Number
      {
         return this.serverNow.getTime() - this.arrivalTime;
      }
      
      public function get dateDrift() : Number
      {
         var nowDate:Date = new Date();
         var nowTime:Number = getTimer();
         var elapsedTime:Number = nowTime - this._sessionStartTime;
         var elapsedDate:Number = nowDate.time - this._sessionStartDate.time;
         return elapsedTime - elapsedDate;
      }
   }
}
