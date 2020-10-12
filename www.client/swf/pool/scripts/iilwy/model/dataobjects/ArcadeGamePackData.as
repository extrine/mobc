package iilwy.model.dataobjects
{
   import com.adobe.utils.DateUtil;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.display.ad.AdPatternFactory;
   import iilwy.display.ad.AdPatternType;
   import iilwy.display.arcade.leaderboard.enum.ArcadeLeaderboardSort;
   import iilwy.gamenet.model.MatchData;
   import iilwy.model.dataobjects.arcade.ArcadeGameStats;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardItemData;
   import iilwy.model.local.LocalProperties;
   import iilwy.net.ClassLoader;
   import iilwy.ui.themes.DynamicTheme;
   import iilwy.ui.themes.Theme;
   import iilwy.ui.themes.Themes;
   import iilwy.utils.logging.Logger;
   
   public class ArcadeGamePackData
   {
      
      public static const GAME_INSTANCE:String = "gameInstance";
      
      public static const LOGO_INSTANCE:String = "logoInstance";
      
      public static const PROMO_INSTANCE:String = "promoInstance";
      
      public static const CUSTOMIZE_MATCH_INSTANCE:String = "customizeMatchInstance";
      
      public static const SHOP_PREVIEW_INSTANCE:String = "shopPreviewInstance";
      
      public static const RELEASE_STATUS_SOON:int = 5;
      
      public static const RELEASE_STATUS_NEW:int = 10;
      
      public static const RELEASE_STATUS_LIVE:int = 20;
      
      public static const LIB_VERSION_LOCAL:String = "local";
      
      private static var popularityLookup;
       
      
      public var gameInstanceClass:String;
      
      public var promoInstanceClass:String;
      
      public var logoInstanceClass:String;
      
      public var customizeMatchInstanceClass:String;
      
      public var shopPreviewInstanceClass:String;
      
      protected var gameInstance;
      
      protected var logoInstance;
      
      protected var promoInstance;
      
      protected var customizeMatchInstance;
      
      protected var shopPreviewInstance;
      
      public var shopId:int = -1;
      
      public var instantPurchaseCategoryId:int = -1;
      
      public var uid:int;
      
      public var id:String;
      
      private var _isConfigLoaded:Boolean = false;
      
      private var _configLoadedTimeStamp:int = -999999999;
      
      private var _isLoaded:Boolean = false;
      
      private var _loadedTimeStamp:int = -999999999;
      
      public var loader:ClassLoader;
      
      public var roomName:String;
      
      protected var fileId:String;
      
      public var title:String;
      
      public var subtitle:String;
      
      public var description:String;
      
      public var useChat:Boolean = false;
      
      public var useChrome:Boolean = false;
      
      public var themeDescriptor;
      
      public var liveDate:Number = -1;
      
      public var listed:Boolean;
      
      public var promoted:Boolean;
      
      public var gameStats:ArcadeGameStats;
      
      public var leaderboardMini;
      
      public var keyboardFocusRequired:Boolean = true;
      
      public var keyboardFocusDelay:Number = 7000;
      
      public var defaultBackground:String;
      
      public var minimumPremiumLevel:Number = 0;
      
      public var userGameStoreEnabled:Boolean = false;
      
      public var libDependancy:String;
      
      public var releaseStatus:int = 20;
      
      public var gameTypes:Array;
      
      public var betMode:String;
      
      public var betAmounts:Array;
      
      public var maxPlayerCount:Number;
      
      public var defaultMaxPlayerCount:Number;
      
      public var minPlayerCount:Number;
      
      public var defaultMinPlayerCount:Number;
      
      public var hasTutorial:Boolean;
      
      public var scoreAliases:Object;
      
      public var lastPlayedTime:Number = -1;
      
      public var localPlayCount:Number = 0;
      
      private var betaSwf:String;
      
      private var productionSwf:String;
      
      public var restrictedTo:String;
      
      public var popularity:Number = 9.9999999999E10;
      
      protected var _logger:Logger;
      
      public var defaultGuestRating:Number = 1300;
      
      public var minimumRatingTolerance:Number = 300;
      
      public var maximumRatingTolerance:Number = 1000;
      
      public var minimumComparisonRating:Number = 500;
      
      public var maximumComparisonRating:Number = 3000;
      
      public var adPattern:Array;
      
      public var inGameAdPattern:Array;
      
      public var lobbyAdPattern:Array;
      
      public var lobbyVisitorAdPattern:Array;
      
      public var fallbackAdPattern:Array;
      
      protected var _hasAchievements:Boolean;
      
      protected var _minimumPremiumLevelForAchievements:int;
      
      protected var _minimumPremiumLevelForShop:int;
      
      public var notificationPosition:String;
      
      public var roundOneReadyTime:Number;
      
      public var initialReadyTime:Number;
      
      public var genericNumberStoreKeys:Array;
      
      public function ArcadeGamePackData()
      {
         this.roundOneReadyTime = MatchData.READY_TIME_ROUND_ONE;
         this.initialReadyTime = MatchData.READY_TIME_INITIAL;
         super();
         this.loader = new ClassLoader();
         this._logger = Logger.getLogger(this);
      }
      
      public function initFromIndex(data:*) : void
      {
         this.gameStats = new ArcadeGameStats();
         this.gameStats.totalHoursSpent = data.count_seconds / (60 * 60);
         this.gameStats.totalPlays = data.count_plays;
         this.id = data.game_name;
         this.uid = data.id;
         this.localHacks();
         this.fileId = data.file_name;
         this._hasAchievements = data.has_achievements;
         this._minimumPremiumLevelForAchievements = data.mpl_for_achievements;
         this._minimumPremiumLevelForShop = data.mpl_for_shop;
         this.title = data.title;
         this.promoted = data.promoted;
         this.listed = data.listed;
         if(data.description)
         {
            this.description = data.description;
         }
         if(data.date_live)
         {
            this.liveDate = DateUtil.parseW3CDTF(data.date_live).time;
         }
         if(data.product_collection_id)
         {
            this.shopId = data.product_collection_id;
         }
         if(data.instant_purchase_category_id)
         {
            this.instantPurchaseCategoryId = data.instant_purchase_category_id;
         }
         if(data.lib_dependancy)
         {
            this.libDependancy = data.lib_dependancy;
         }
         if(data.has_tutorial)
         {
            this.hasTutorial = data.has_tutorial;
         }
         if(data.minimum_premium_level)
         {
            this.minimumPremiumLevel = data.minimum_premium_level;
         }
         if(data.restricted_to)
         {
            this.restrictedTo = data.restricted_to;
         }
         if(data.release_status)
         {
            this.releaseStatus = data.release_status;
         }
         if(!popularityLookup)
         {
            popularityLookup = {
               "balloono":1010,
               "drawmything":1009,
               "fourplay":1008,
               "booya":1007,
               "letterblox":1006,
               "hoverkartbattle":1005,
               "missilecommand":1004,
               "hitmachine":1004,
               "hoverkart":1003,
               "dinglepop":1002,
               "checkers":1001,
               "ballracer":1000,
               "blockles":999,
               "puttputtpenguin":998,
               "jigsawce":997,
               "tracism":996,
               "gemmers":995,
               "hamsterbattle":994,
               "hamsterjet":993
            };
            if(Math.random() < 0.5)
            {
               popularityLookup["drawmything"] = popularityLookup["drawmything"] + 3;
            }
            if(Math.random() < 0.5)
            {
               popularityLookup["letterblox"] = popularityLookup["letterblox"] + 3;
            }
            if(Math.random() < 0.5)
            {
               popularityLookup["balloono"] = popularityLookup["balloono"] + 3;
            }
         }
         this.popularity = popularityLookup[this.id];
         this.retrieveLocalData();
      }
      
      public function toLocalData() : *
      {
         return {
            "lastPlayed":this.lastPlayedTime,
            "playCount":this.localPlayCount
         };
      }
      
      public function retrieveLocalData() : void
      {
         var time:* = undefined;
         var times:* = AppComponents.localStore.getUserSpecificObject(LocalProperties.ARCADE_LAST_PLAYED_TIMES);
         if(times)
         {
            time = times[this.id];
            if(time)
            {
               try
               {
                  this.lastPlayedTime = time.lastPlayed;
                  this.localPlayCount = time.playCount;
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      public function initStats(data:*) : void
      {
         var parseLeaderboardResults:Function = function(results:*):Array
         {
            var item:ArcadeLeaderboardItemData = null;
            var arr:Array = [];
            if(!results)
            {
               return null;
            }
            for(var i:int = 0; i < results.length; i++)
            {
               item = ArcadeLeaderboardItemData.createFromApiResponse(results[i]);
               arr.push(item);
            }
            return arr;
         };
         if(data)
         {
            this.gameStats = new ArcadeGameStats();
            this.gameStats.totalHoursSpent = data.total_hours;
            this.gameStats.totalPlays = data.total_plays;
            this.leaderboardMini = new Object();
            if(data.featured_leaderboards.hours)
            {
               this.leaderboardMini[ArcadeLeaderboardSort.HOURS] = parseLeaderboardResults(data.featured_leaderboards.hours.result.leaderboard_data);
            }
            if(data.featured_leaderboards.plays)
            {
               this.leaderboardMini[ArcadeLeaderboardSort.PLAYS] = parseLeaderboardResults(data.featured_leaderboards.plays.result.leaderboard_data);
            }
            if(data.featured_leaderboards.gold)
            {
               this.leaderboardMini[ArcadeLeaderboardSort.GOLDS] = parseLeaderboardResults(data.featured_leaderboards.gold.result.leaderboard_data);
            }
            if(data.featured_leaderboards.elo)
            {
               this.leaderboardMini[ArcadeLeaderboardSort.RATING] = parseLeaderboardResults(data.featured_leaderboards.elo.result.leaderboard_data);
            }
         }
      }
      
      public function get libVersion() : String
      {
         if(AppProperties.debugMode == AppProperties.MODE_REMOTE_DEBUGGING)
         {
            return this.betaSwf;
         }
         if(AppProperties.debugMode == AppProperties.MODE_NOT_DEBUGGING)
         {
            return this.productionSwf;
         }
         return LIB_VERSION_LOCAL;
      }
      
      protected function localHacks() : void
      {
         if(this.id == "drawmything")
         {
         }
         if(this.id == "balloono2")
         {
         }
         if(this.id == "hitmachine")
         {
            this.promoInstanceClass = "iilwygames.soundgame.promo.SoundGamePromo";
            this.customizeMatchInstanceClass = "iilwygames.soundgame.menu.SoundGameMenu";
         }
         if(this.id == "pool")
         {
            this.shopPreviewInstanceClass = "iilwygames.pool.core.ShopPreview";
         }
         if(this.id == "swapples")
         {
            this.fileId = "MatchGame";
         }
      }
      
      public function initFromConfigData(data:*) : void
      {
         var gameType:Object = null;
         var pattern:Object = null;
         var type:String = null;
         var version:String = null;
         var adPatternType:String = null;
         var match:* = undefined;
         var user:* = undefined;
         var stats:ArcadeLeaderboardItemData = null;
         var experience:ExperienceData = null;
         this._isConfigLoaded = true;
         this._configLoadedTimeStamp = getTimer();
         this.id = data.game_name;
         this.fileId = data.file_name;
         this.uid = data.id;
         this.localHacks();
         this.retrieveLocalData();
         if(data.user_game_store_enabled)
         {
            this.userGameStoreEnabled = data.user_game_store_enabled;
         }
         if(data.generic_number_store_keys)
         {
            this.genericNumberStoreKeys = data.generic_number_store_keys.split(",");
         }
         if(data.noob_elo)
         {
            this.defaultGuestRating = data.noob_elo;
         }
         if(data.quickplay_tolerance)
         {
            this.minimumRatingTolerance = data.quickplay_tolerance;
         }
         if(data.maximum_tolerance)
         {
            this.maximumRatingTolerance = data.maximum_tolerance;
         }
         if(data.product_collection_id)
         {
            this.shopId = data.product_collection_id;
         }
         if(data.instant_purchase_category_id)
         {
            this.instantPurchaseCategoryId = data.instant_purchase_category_id;
         }
         if(data.min_search_elo)
         {
            this.minimumComparisonRating = data.min_search_elo;
         }
         if(data.max_search_elo)
         {
            this.maximumComparisonRating = data.max_search_elo;
         }
         if(data.lib_dependancy)
         {
            this.libDependancy = data.lib_dependancy;
         }
         if(data.has_tutorial)
         {
            this.hasTutorial = data.has_tutorial;
         }
         if(data.shop_preview_class)
         {
            this.shopPreviewInstanceClass = data.shop_preview_class;
         }
         if(data.logo_instance_class)
         {
            this.logoInstanceClass = data.logo_instance_class;
         }
         if(data.notification_position)
         {
            this.notificationPosition = data.notification_position;
         }
         if(data.round_one_ready_time)
         {
            this.roundOneReadyTime = data.round_one_ready_time;
         }
         if(data.initial_ready_time)
         {
            this.initialReadyTime = data.initial_ready_time;
         }
         if(data.ad_patterns)
         {
            for each(pattern in data.ad_patterns)
            {
               if(pattern.type)
               {
                  type = pattern.type;
                  version = AppProperties.appVersion;
                  if(type == AdPatternType.WEBSITE && AppProperties.appVersionIsWebsiteOrAIR)
                  {
                     match = pattern;
                  }
                  else if(type == AdPatternType.MYSPACE && version == AppProperties.VERSION_MYSPACE_ARCADE)
                  {
                     match = pattern;
                  }
                  else if(type == AdPatternType.EXTERNAL && version == AppProperties.VERSION_EXTERNAL_ARCADE)
                  {
                     match = pattern;
                  }
                  if(match)
                  {
                     this.adPattern = AdPatternFactory.createFromApiResult(match.ad_pattern);
                  }
                  if(type == AdPatternType.IN_GAME)
                  {
                     this.inGameAdPattern = AdPatternFactory.createFromApiResult(pattern.ad_pattern);
                  }
                  else if(type == AdPatternType.LOBBY)
                  {
                     this.lobbyAdPattern = AdPatternFactory.createFromApiResult(pattern.ad_pattern);
                  }
                  else if(type == AdPatternType.LOBBY_VISITOR)
                  {
                     this.lobbyVisitorAdPattern = AdPatternFactory.createFromApiResult(pattern.ad_pattern);
                  }
                  else if(type == AdPatternType.WEBSITE_FALLBACK)
                  {
                     this.fallbackAdPattern = AdPatternFactory.createFromApiResult(pattern.ad_pattern);
                  }
               }
            }
         }
         this.betaSwf = data.beta_swf;
         this.productionSwf = data.production_swf;
         if(data.restricted_to)
         {
            this.restrictedTo = data.restricted_to;
         }
         this.gameInstanceClass = data.main_class;
         this.roomName = data.room_name;
         this.title = data.title;
         this.subtitle = data.subtitle;
         this.description = data.description;
         this.useChat = data.use_chat;
         this.useChrome = data.use_chrome;
         this._hasAchievements = data.has_achievements;
         this._minimumPremiumLevelForAchievements = data.mpl_for_achievements;
         this._minimumPremiumLevelForShop = data.mpl_for_shop;
         this.keyboardFocusRequired = data.keyboard_focus_required;
         if(data.keyboard_focus_delay)
         {
            this.keyboardFocusDelay = data.keyboard_focus_delay;
         }
         this.scoreAliases = new Object();
         var i:int = 0;
         if(data.score_aliases)
         {
            i = 0;
            for(i = 0; i < data.score_aliases.length; i++)
            {
               this.scoreAliases[data.score_aliases[i].id] = data.score_aliases[i].label;
            }
         }
         this.themeDescriptor = data.theme;
         this.maxPlayerCount = 7;
         if(data.max_player_count)
         {
            this.maxPlayerCount = data.max_player_count;
         }
         if(data.default_max_player_count)
         {
            this.defaultMaxPlayerCount = data.default_max_player_count;
         }
         else
         {
            this.defaultMaxPlayerCount = this.maxPlayerCount;
         }
         this.minPlayerCount = 1;
         if(data.min_player_count)
         {
            this.minPlayerCount = data.min_player_count;
         }
         if(data.default_min_player_count)
         {
            this.defaultMinPlayerCount = data.default_min_player_count;
         }
         else
         {
            this.defaultMinPlayerCount = this.minPlayerCount;
         }
         this.gameTypes = data.game_types;
         if(!this.gameTypes || this.gameTypes.length == 0)
         {
            this.gameTypes = [{
               "label":"Default",
               "value":"default"
            }];
         }
         for each(gameType in this.gameTypes)
         {
            if(gameType.gameLevelLocked)
            {
               gameType.disabled = true;
               user = AppComponents.model.privateUser;
               stats = AppComponents.model.privateUser.getStatsForGame(this.id);
               if(!stats)
               {
                  break;
               }
               experience = stats.experience;
               if(!experience)
               {
                  break;
               }
               if(experience.level >= gameType.gameLevelLocked)
               {
                  gameType.disabled = false;
               }
            }
         }
         this.betMode = data.bet_mode && data.bet_mode != ""?data.bet_mode:null;
         this.betAmounts = Boolean(data.bet_amounts)?data.bet_amounts:[];
         if(data.default_background)
         {
            this.defaultBackground = AppProperties.fileServerStaticOrLocal + data.default_background;
         }
         if(data.minimum_premium_level)
         {
            this.minimumPremiumLevel = data.minimum_premium_level;
         }
      }
      
      public function initFromXML(xml:XML) : void
      {
         var node:* = undefined;
         var obj:* = undefined;
         var gameLevelLock:* = undefined;
         this._isConfigLoaded = true;
         this.id = xml.@id.toXMLString();
         this.localHacks();
         node = xml.fileId[0];
         if(node)
         {
            this.fileId = node.text();
         }
         else
         {
            this.fileId = this.id;
         }
         this._hasAchievements = true;
         this._minimumPremiumLevelForAchievements = 0;
         this.userGameStoreEnabled = true;
         this.gameInstanceClass = xml.mainClass[0].text();
         node = xml.roomName[0];
         if(node)
         {
            this.roomName = node.text();
         }
         else
         {
            this.roomName = this.id;
         }
         try
         {
            this.title = xml.title[0].text();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.subtitle = xml.subtitle[0].text();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.genericNumberStoreKeys = xml.genericNumberStoreKeys[0].text().split(",");
         }
         catch(e:Error)
         {
         }
         try
         {
            if(xml.hasTutorial[0].text() == "true")
            {
               this.hasTutorial = true;
            }
         }
         catch(e:Error)
         {
         }
         if(xml.useChat[0].text() == "true")
         {
            this.useChat = true;
         }
         if(xml.useChrome[0].text() == "true")
         {
            this.useChrome = true;
         }
         if(xml.keyboardFocusRequired.length() > 0 && xml.keyboardFocusRequired[0].text() == "false")
         {
            this.keyboardFocusRequired = false;
         }
         node = xml.defaultBackground[0];
         if(node)
         {
            this.defaultBackground = AppProperties.fileServerStaticOrLocal + node.text();
         }
         node = xml.theme;
         if(node[0])
         {
            obj = JSON.deserialize(node.text().toXMLString());
            this.themeDescriptor = obj;
         }
         node = xml.productCollection[0];
         if(node)
         {
            this.shopId = node.text();
         }
         node = xml.instantPurchaseCategoryId[0];
         if(node)
         {
            this.instantPurchaseCategoryId = node.text();
         }
         node = xml.maxPlayerCount[0];
         if(node)
         {
            this.maxPlayerCount = node.text();
         }
         else
         {
            this.maxPlayerCount = 7;
         }
         node = xml.defaultMaxPlayerCount[0];
         if(node)
         {
            this.defaultMaxPlayerCount = node.text();
         }
         else
         {
            this.defaultMaxPlayerCount = this.maxPlayerCount;
         }
         node = xml.minPlayerCount[0];
         if(node)
         {
            this.minPlayerCount = node.text();
         }
         else
         {
            this.minPlayerCount = 1;
         }
         node = xml.defaultMinPlayerCount[0];
         if(node)
         {
            this.defaultMinPlayerCount = node.text();
         }
         else
         {
            this.defaultMinPlayerCount = this.minPlayerCount;
         }
         var i:int = 0;
         node = xml.gameTypes.gameType;
         if(node[0])
         {
            this.gameTypes = [];
            for(i = 0; i < node.length(); i++)
            {
               gameLevelLock = node[i].@gameLevelLock;
               this.gameTypes.push({
                  "label":node[i].text()[0].toXMLString(),
                  "value":node[i].@id[0].toXMLString()
               });
            }
         }
         else
         {
            this.gameTypes = [{
               "label":"Default",
               "value":"default"
            }];
         }
         try
         {
            this.betMode = xml.betMode[0] && xml.betMode[0].text() != ""?xml.betMode[0].text():null;
         }
         catch(e:Error)
         {
         }
         this.scoreAliases = new Object();
         node = xml.scoreAliases.alias;
         i = 0;
         for(i = 0; i < node.length(); i++)
         {
            this.scoreAliases[node[i].@id] = node[i].text()[0].toXMLString();
         }
      }
      
      public function get configLoadedTimeStamp() : int
      {
         return this._configLoadedTimeStamp;
      }
      
      public function get loadedTimeStamp() : int
      {
         return this._loadedTimeStamp;
      }
      
      public function set isLoaded(b:Boolean) : void
      {
         if(b)
         {
            this._loadedTimeStamp = getTimer();
         }
         this._isLoaded = b;
      }
      
      public function get isCustomizeMatchEnabled() : Boolean
      {
         if(this.customizeMatchInstanceClass)
         {
            return true;
         }
         return false;
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function get isConfigLoaded() : Boolean
      {
         return this._isConfigLoaded;
      }
      
      public function get fileName() : String
      {
         var result:String = null;
         if(AppProperties.debugMode == AppProperties.MODE_LOCAL_DEBUGGING)
         {
            if(AppProperties.appVersion == AppProperties.VERSION_ARCADE_TESTER && AppProperties.arcadeTesterLibraryOverride)
            {
               result = AppProperties.arcadeTesterLibraryOverride;
            }
            else
            {
               result = AppProperties.localGamesDir + this.fileId + "/bin-debug/" + this.fileId + ".swf";
            }
         }
         else if(AppProperties.debugMode == AppProperties.MODE_REMOTE_DEBUGGING || AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE && AppProperties.parentParameters.swf_debug == "sup")
         {
            result = AppProperties.fileServerGamesDev + this.betaSwf;
         }
         else if(AppProperties.fileServerGames)
         {
            result = AppProperties.fileServerGames + this.productionSwf;
         }
         else
         {
            result = "http://gamenetgamescdn.iminlikewithyou.com/" + this.productionSwf;
         }
         return result;
      }
      
      public function get banner175x60() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-banner175x60.png";
      }
      
      public function get readyBackground() : String
      {
         if(this.fileId == "balloono" && !AppProperties.appVersionIsWebsiteOrAIR)
         {
            return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-readybg-default.jpg";
         }
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-readybg.jpg";
      }
      
      public function get updateXML() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-updates.html";
      }
      
      public function get catalogThumbnail() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-catalogthumb.jpg";
      }
      
      public function get icon25() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-icon25.png";
      }
      
      public function get catalogFeature() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-catalogfeature.png";
      }
      
      public function getCatalogFeatureByVersion(version:String) : String
      {
         version = version == AppProperties.VERSION_MYSPACE_ARCADE?"myspace":version;
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-catalogfeature-" + version + ".png";
      }
      
      public function get promoVideo() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-catalogvideo.flv";
      }
      
      public function get promoSwf() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-promo.swf";
      }
      
      public function getPromoSwfByVersion(version:String) : String
      {
         version = version == AppProperties.VERSION_MYSPACE_ARCADE?"myspace":version;
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-promo-" + version + ".swf";
      }
      
      public function get helpSwf() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-help.swf";
      }
      
      public function get helpSwfSmall() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-help-small.swf";
      }
      
      public function get navThumbnailTop() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-navtop.jpg";
      }
      
      public function get navThumbnailFeature() : String
      {
         return AppProperties.fileServerStaticOrLocal + "games-" + this.fileId + "-navfeature.jpg";
      }
      
      public function get singlePlayerUrl() : String
      {
         return "/arcade/singleplayer/" + this.id;
      }
      
      public function get tutorialUrl() : String
      {
         return "/arcade/tutorial/" + this.id;
      }
      
      public function get playUrl() : String
      {
         return "/arcade/play/" + this.id;
      }
      
      public function get quickPlayUrl() : String
      {
         return "/arcade/quickplay/" + this.id;
      }
      
      public function get leaderboardUrl() : String
      {
         return "/arcade/gamelobby/" + this.id + "/leaderboards";
      }
      
      public function get lobbyUrl() : String
      {
         return "/arcade/gamelobby/" + this.id;
      }
      
      public function get lobbyShopUrl() : String
      {
         return "/shops/shop/" + this.id;
      }
      
      public function get startUrl() : String
      {
         return "/arcade/gamestart/" + this.id;
      }
      
      public function get isRestricted() : Boolean
      {
         if(!this.restrictedTo)
         {
            return false;
         }
         if(AppProperties.appVersion == AppProperties.VERSION_WEBSITE && this.restrictedTo == "site")
         {
            return false;
         }
         if(AppProperties.appVersion == AppProperties.VERSION_EXTERNAL_ARCADE && this.restrictedTo == "external")
         {
            return false;
         }
         if(AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE && this.restrictedTo == "facebook")
         {
            return false;
         }
         return true;
      }
      
      public function get disclaimer() : String
      {
         var s:String = "";
         return s;
      }
      
      public function getTheme() : Theme
      {
         var t:Theme = null;
         if(this.themeDescriptor)
         {
            t = new DynamicTheme(this.id,this.themeDescriptor);
         }
         else
         {
            t = AppComponents.themeManager.getTheme(Themes.APPLICATION_THEME);
         }
         return t;
      }
      
      public function hasAchievementsForPremiumLevel(level:int) : Boolean
      {
         if(this._hasAchievements && level >= this._minimumPremiumLevelForAchievements)
         {
            return true;
         }
         return false;
      }
      
      public function hasShopForPremiumLevel(level:int) : Boolean
      {
         if(this.shopId >= 0 && level >= this._minimumPremiumLevelForShop)
         {
            return true;
         }
         return false;
      }
      
      public function hasGameTypes() : Boolean
      {
         var b:Boolean = false;
         if(this.gameTypes && this.gameTypes.length > 1)
         {
            b = true;
         }
         return b;
      }
      
      public function hasBetAmounts() : Boolean
      {
         var b:Boolean = false;
         if(this.bettingEnabled && this.betAmounts && this.betAmounts.length > 0)
         {
            b = true;
         }
         return b;
      }
      
      public function get bettingEnabled() : Boolean
      {
         var bettingEnabled:Boolean = false;
         if(AppProperties.appVersionIsWebsiteOrAIR || AppProperties.appVersion == AppProperties.VERSION_ARCADE_TESTER)
         {
            bettingEnabled = this.betMode != null;
         }
         else if(EmbedSettings.getInstance().enableBetting)
         {
            bettingEnabled = true;
            if(EmbedSettings.getInstance().gamesBettingWhiteList.length && EmbedSettings.getInstance().gamesBettingWhiteList.indexOf(this.id) == -1)
            {
               bettingEnabled = false;
            }
         }
         return bettingEnabled;
      }
      
      public function getDefaultGameType() : *
      {
         return this.gameTypes[0];
      }
      
      public function getGameTypeLabel(id:String) : String
      {
         for(var i:int = 0; i < this.gameTypes.length; i++)
         {
            if(this.gameTypes[i].value == id)
            {
               return this.gameTypes[i].label;
            }
         }
         return null;
      }
      
      public function getScoreAlias(id:String) : String
      {
         return this.scoreAliases[id];
      }
      
      public function equals(other:ArcadeGamePackData) : Boolean
      {
         if(other && other.id == this.id)
         {
            return true;
         }
         return false;
      }
      
      public function getClassInstance(instanceType:String) : Object
      {
         var theClass:Class = null;
         var classInstance:Object = null;
         var instance:* = instanceType == GAME_INSTANCE?this.gameInstance:instanceType == PROMO_INSTANCE?this.promoInstance:instanceType == CUSTOMIZE_MATCH_INSTANCE?this.customizeMatchInstance:instanceType == SHOP_PREVIEW_INSTANCE?this.shopPreviewInstance:instanceType == LOGO_INSTANCE?this.logoInstance:null;
         if(instance)
         {
            this._logger.log(this.id,instanceType + " already constructed.");
            return instance;
         }
         if(!this.isLoaded)
         {
            this._logger.error(this.id,"GamePack not loaded");
            return null;
         }
         theClass = this.loader.getClass(this[instanceType + "Class"]);
         if(!theClass)
         {
            this._logger.error(this.id,instanceType + " class does not exist.");
            return null;
         }
         try
         {
            classInstance = new theClass();
            this._logger.log(this.id,instanceType + " constructed.");
            this[instanceType] = classInstance;
         }
         catch(error:Error)
         {
            _logger.error(id,"Error constructing " + instanceType + ".");
            AppComponents.popupManager.popupError(this,error);
         }
         return classInstance;
      }
      
      public function destroyClassInstance(instanceType:String) : void
      {
         if(this[instanceType])
         {
            try
            {
               this[instanceType].destroy();
               this._logger.log(this.id,instanceType + " destroyed.");
            }
            catch(e:Error)
            {
               _logger.error(id,"Error destroying " + instanceType + ".");
               AppComponents.popupManager.popupError(this,e);
            }
         }
         this[instanceType] = null;
      }
   }
}
