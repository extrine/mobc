package iilwy.model.dataobjects
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import iilwy.abtest.ABTest;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.PagingArrayCollection;
   import iilwy.display.arcade.leaderboard.enum.ArcadeLeaderboardGroup;
   import iilwy.display.arcade.leaderboard.enum.ArcadeLeaderboardLocation;
   import iilwy.display.arcade.leaderboard.enum.ArcadeLeaderboardSort;
   import iilwy.display.arcade.leaderboard.enum.ArcadeLeaderboardTimeRange;
   import iilwy.events.CollectionEvent;
   import iilwy.gamenet.model.MatchListingCollection;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.ad.enum.AdPathKey;
   import iilwy.model.dataobjects.arcade.ArcadeGameStats;
   import iilwy.model.dataobjects.arcade.ArcadeGenericValueStoreData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardItemData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardSettings;
   import iilwy.model.dataobjects.arcade.ArcadeMatchSummary;
   import iilwy.model.dataobjects.arcade.ArcadePlayerStatsData;
   import iilwy.model.local.LocalProperties;
   import iilwy.utils.TextUtil;
   
   public class ArcadeData extends EventDispatcher
   {
       
      
      public var gamePacks;
      
      public var catalog:ArrayCollection;
      
      public var isCatalogLoaded:Boolean = false;
      
      public var catalogSortedByFavorite:ArrayCollection;
      
      public var catalogListed:ArrayCollection;
      
      public var catalogPromoted:ArrayCollection;
      
      public var catalogPopular:ArrayCollection;
      
      public var currentGamePack:ArcadeGamePackData;
      
      public var currentUserGameStore;
      
      public var currentUserGenericValueStore:ArcadeGenericValueStoreData;
      
      public var currentInstantPuchaseCollection:ArrayCollection;
      
      public var matchSummary:ArcadeMatchSummary;
      
      public var leaderboardMini;
      
      public var allGameStatsLoaded:Boolean = false;
      
      public var leaderboardFullList:PagingArrayCollection;
      
      public var leaderboardFullSettings:ArcadeLeaderboardSettings;
      
      public var leaderboardFullLoaded:Boolean = false;
      
      public var leaderboardFullUserPosition;
      
      public var horizontalLeaderboardList:PagingArrayCollection;
      
      public var horizontalLeaderboardSettings:ArcadeLeaderboardSettings;
      
      public var horizontalLeaderboardLoaded:Boolean = false;
      
      public var horizontalLeaderboardUserPosition;
      
      public var featuredPlayers:ArrayCollection;
      
      public var matches:MatchListingCollection;
      
      public var recentPlayers:ArrayCollection;
      
      public var friendsPlaying:ArrayCollection;
      
      public var favoriteGameFriends:ArrayCollection;
      
      public var gameStats:ArcadeGameStats;
      
      public var userScores:ArcadeLeaderboardItemData;
      
      public var userStats:ArcadePlayerStatsData;
      
      public var userStatus:PlayerStatus;
      
      public var inviter:ProfileData;
      
      public var sessionPlays:Number;
      
      public var pendingConfig:Object;
      
      public var achievementsEarnedThisSession:Array;
      
      public var playerPreviews:Dictionary;
      
      protected var guestPlayLimitTest:ABTest;
      
      protected var guestPlayLimitDefault:int = 20;
      
      public var guestPlayLimit:int = -1;
      
      protected var _matchNameIndex:Number = -1;
      
      protected var _matchNames:Array;
      
      public function ArcadeData()
      {
         this._matchNames = ["#pname# milkshake brings all the boys to the yard.","#pname# Pleasure Palace","Whose house? #pname# house!","#pname# House of Pain","Who put this thing together? #name# thats who.","#pname# Boiler Room","For a good time, call #name#","#pname# Washy-washy","I can has #name#?","Girl you know it\'s true, #name# loves you.","#name# got it at the gettin\' place","This is your brain on #name#","Have you ever heard of #name#?","#name# is the new black","#name# does Dallas.","#pname# Steel Cage","#name# is steady killin\' fools","Startup founder, #name#","#name# is a major dinglepopper","#name#izzle, my nizzle","#name# hearts blockles the blockle.","#name# drank your milkshake.","#name# much?","#name#? Really?","#name# eats babies.","Do you have love for #name#??","#pname# Major Pwnage","In the octagon with #name#","Good times with #name#","Is #name# awesome (Y/y)","#pname# Boutique","#name#, a rabbi, and Jesus walk into a bar...","#name# on top. You on the bottom.","Madness?...THIS... IS... #name#!!!","#name# pitchin\', you catchin\'","Did you know #name# had a blog?","All your #name# are belong to us","#name#. Kid tested, mother approved.","Stay classy, #name#.","First rule of #name# Club, you do not talk about #name# Club..."];
         super();
         this.gamePacks = {};
         this.catalog = new ArrayCollection();
         this.catalogSortedByFavorite = new ArrayCollection();
         this.catalogListed = new ArrayCollection();
         this.catalogPromoted = new ArrayCollection();
         this.catalogPopular = new ArrayCollection();
         this.catalog.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCatalogChanged);
         this.matches = new MatchListingCollection();
         this.recentPlayers = new ArrayCollection();
         this.friendsPlaying = new ArrayCollection();
         this.featuredPlayers = new ArrayCollection();
         this.favoriteGameFriends = new ArrayCollection();
         this.userStatus = new PlayerStatus();
         this.userStatus.offline();
         this.userStats = new ArcadePlayerStatsData();
         this.gameStats = new ArcadeGameStats();
         this.currentUserGenericValueStore = new ArcadeGenericValueStoreData();
         this.leaderboardFullList = new PagingArrayCollection();
         this.leaderboardFullList.limit = 50;
         this.leaderboardFullList.maxItems = 200;
         this.leaderboardFullSettings = new ArcadeLeaderboardSettings();
         this.leaderboardFullSettings.sort = ArcadeLeaderboardSort.GOLDS;
         this.leaderboardFullSettings.timeRange = ArcadeLeaderboardTimeRange.WEEK;
         this.leaderboardFullSettings.group = ArcadeLeaderboardGroup.FRIENDS;
         this.horizontalLeaderboardList = new PagingArrayCollection();
         this.horizontalLeaderboardList.limit = 50;
         this.horizontalLeaderboardList.maxItems = 200;
         this.horizontalLeaderboardSettings = new ArcadeLeaderboardSettings();
         this.horizontalLeaderboardSettings.sort = ArcadeLeaderboardSort.GOLDS;
         this.horizontalLeaderboardSettings.timeRange = ArcadeLeaderboardTimeRange.WEEK;
         this.horizontalLeaderboardSettings.group = ArcadeLeaderboardGroup.FRIENDS;
         this.horizontalLeaderboardSettings.location = ArcadeLeaderboardLocation.ALL;
         this.achievementsEarnedThisSession = [];
         this.playerPreviews = new Dictionary();
         this.matchSummary = new ArcadeMatchSummary();
         this.sessionPlays = 0;
      }
      
      public function clearPlayerPreviews() : void
      {
         this.playerPreviews = new Dictionary();
      }
      
      public function clearUserSpecificData() : void
      {
         this.currentUserGameStore = null;
         this.currentUserGenericValueStore.reset();
         this.achievementsEarnedThisSession = [];
         this.recentPlayers.clearSource();
         this.friendsPlaying.clearSource();
         this.favoriteGameFriends.clearSource();
      }
      
      public function refreshForUser() : void
      {
         var pack:ArcadeGamePackData = null;
         for each(pack in this.catalog.source)
         {
            pack.retrieveLocalData();
         }
         this.updateSortedCatalog();
      }
      
      public function addGamePack(gamePack:ArcadeGamePackData) : ArcadeGamePackData
      {
         var pack:ArcadeGamePackData = this.getGamePack(gamePack.id);
         if(!pack)
         {
            this.gamePacks[gamePack.id] = gamePack;
            pack = gamePack;
         }
         return pack;
      }
      
      public function getGamePack(id:String) : ArcadeGamePackData
      {
         if(id)
         {
            id = id.toLocaleLowerCase();
         }
         var pack:ArcadeGamePackData = this.gamePacks[id];
         return pack;
      }
      
      public function getGamePackByUid(uid:int) : ArcadeGamePackData
      {
         var pack:ArcadeGamePackData = null;
         for each(pack in this.gamePacks)
         {
            if(pack.uid == uid)
            {
               return pack;
            }
         }
         return null;
      }
      
      public function getCatalogItem(id:String) : ArcadeGamePackData
      {
         var pack:ArcadeGamePackData = null;
         var test:ArcadeGamePackData = null;
         for(var i:int = 0; i < this.catalog.length; i++)
         {
            test = this.catalog.getItemAt(i);
            if(test.id == id)
            {
               pack = test;
               break;
            }
         }
         return pack;
      }
      
      public function getCatalogItemByUid(uid:int) : ArcadeGamePackData
      {
         var pack:ArcadeGamePackData = null;
         var test:ArcadeGamePackData = null;
         for(var i:int = 0; i < this.catalog.length; i++)
         {
            test = this.catalog.getItemAt(i);
            if(test.uid == uid)
            {
               pack = test;
               break;
            }
         }
         return pack;
      }
      
      public function clearLeaderboards() : void
      {
         this.leaderboardFullList.removeAll();
         this.leaderboardFullLoaded = false;
         this.horizontalLeaderboardList.removeAll();
         this.horizontalLeaderboardLoaded = false;
      }
      
      public function isApprovedGame(id:String) : Boolean
      {
         var check:ArcadeGamePackData = this.getCatalogItem(id);
         return check != null;
      }
      
      public function userReachedPlayLimit() : Boolean
      {
         var flag:Boolean = false;
         var pack:ArcadeGamePackData = this.getCatalogItem(this.currentGamePack.id);
         if(!this.guestPlayLimitTest)
         {
            this.guestPlayLimitTest = AppComponents.abTestManager.getAvailableTestForStartContext(null,"arcade$playable_limit");
         }
         if(this.guestPlayLimit == -1)
         {
            if(this.guestPlayLimitTest && this.guestPlayLimitTest.hasValue("max_plays"))
            {
               AppComponents.abTestManager.startTest(this.guestPlayLimitTest);
               this.guestPlayLimit = this.guestPlayLimitTest.getValue("max_plays");
            }
            else
            {
               this.guestPlayLimit = this.guestPlayLimitDefault;
            }
         }
         if(AppProperties.rootParameters.hasOwnProperty("adPath") && AppProperties.rootParameters.adPath == AdPathKey.ACQUISITION)
         {
            this.guestPlayLimit = 1;
         }
         if(!AppComponents.model.privateUser.isLoggedIn && pack && (pack.localPlayCount >= this.guestPlayLimit && !EmbedSettings.getInstance().allowUnlimitedGuestPlay))
         {
            flag = true;
         }
         return flag;
      }
      
      public function getGameTitleById(id:String) : String
      {
         var title:String = null;
         var check:ArcadeGamePackData = this.getCatalogItem(id);
         if(check)
         {
            title = check.title;
         }
         if(!title)
         {
            title = id;
         }
         return title;
      }
      
      public function getGameIDByTitle(title:String) : String
      {
         var id:String = null;
         var test:ArcadeGamePackData = null;
         for(var i:int = 0; i < this.catalog.length; i++)
         {
            test = this.catalog.getItemAt(i);
            if(test.title == title)
            {
               id = test.id;
               break;
            }
         }
         return id;
      }
      
      public function storeLocalDataForCatalog() : void
      {
         var pack:ArcadeGamePackData = null;
         var obj:* = {};
         for(var i:int = 0; i < this.catalog.length; i++)
         {
            pack = this.catalog.getItemAt(i);
            obj[pack.id] = pack.toLocalData();
         }
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.ARCADE_LAST_PLAYED_TIMES,obj);
      }
      
      protected function onCatalogChanged(event:Event) : void
      {
         this.updateSortedCatalog();
      }
      
      public function updateCatalogLists() : void
      {
         var pack:ArcadeGamePackData = null;
         var flag:Boolean = false;
         var popularSrc:Array = null;
         var listedSrc:Array = [];
         var promotedSrc:Array = [];
         for each(pack in this.catalog.source)
         {
            flag = true;
            if(!pack.listed)
            {
               flag = false;
            }
            if(flag)
            {
               listedSrc.push(pack);
               if(pack.promoted)
               {
                  promotedSrc.push(pack);
               }
            }
         }
         this.catalogListed.source = listedSrc;
         this.catalogPromoted.source = promotedSrc;
         popularSrc = promotedSrc.concat();
         popularSrc.sortOn("popularity",Array.DESCENDING | Array.NUMERIC);
         this.catalogPopular.source = popularSrc;
      }
      
      public function updateSortedCatalog() : void
      {
         this.updateCatalogLists();
         var sorted:Array = this.catalogPromoted.source.slice();
         sorted.sort(this.updateSortedCatalog_sort);
         this.catalogSortedByFavorite.source = sorted;
      }
      
      private function updateSortedCatalog_sort(a:ArcadeGamePackData, b:ArcadeGamePackData) : int
      {
         var aScore:int = 0;
         var bScore:int = 0;
         aScore = aScore + (a.liveDate > b.liveDate?1:0);
         bScore = bScore + (b.liveDate > a.liveDate?1:0);
         aScore = aScore + (a.promoted > b.promoted?2:0);
         bScore = bScore + (b.promoted > a.promoted?2:0);
         aScore = aScore + (a.localPlayCount > b.localPlayCount?4:0);
         bScore = bScore + (b.localPlayCount > a.localPlayCount?4:0);
         aScore = aScore + (a.lastPlayedTime > b.lastPlayedTime?8:0);
         bScore = bScore + (b.lastPlayedTime > a.lastPlayedTime?8:0);
         if(aScore > bScore)
         {
            return -1;
         }
         if(bScore > aScore)
         {
            return 1;
         }
         return 0;
      }
      
      public function getRandomMatchName() : String
      {
         var str:String = null;
         if(this._matchNameIndex < 0)
         {
            this._matchNameIndex = Math.floor(Math.random() * this._matchNames.length);
         }
         str = "My match";
         var cPlayer:PlayerData = AppComponents.gamenetManager.currentPlayer;
         if(cPlayer && cPlayer.displayName)
         {
            str = this._matchNames[this._matchNameIndex];
            str = str.replace(/#name#/g,cPlayer.displayName);
            str = str.replace(/#pname#/g,TextUtil.makePosessive(cPlayer.displayName));
            this._matchNameIndex = this._matchNameIndex + 1;
            this._matchNameIndex = this._matchNameIndex % this._matchNames.length;
         }
         return str;
      }
   }
}
