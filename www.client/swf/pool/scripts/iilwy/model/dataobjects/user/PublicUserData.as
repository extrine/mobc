package iilwy.model.dataobjects.user
{
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.PagingArrayCollection;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.ExperienceData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.arcade.ArcadeLeaderboardItemData;
   import iilwy.model.dataobjects.shop.ProductInventory;
   import iilwy.model.dataobjects.shop.ProductShop;
   import iilwy.utils.ChatUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class PublicUserData
   {
       
      
      public var id:int = -1;
      
      public var profile:ProfileData;
      
      public var playerStatus:PlayerStatus;
      
      public var email:String;
      
      public var aimUsername:String;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var facebook:FacebookData;
      
      public var numContactRequests:int;
      
      public var numSuggestionRequests:int;
      
      public var productInventory:ProductInventory;
      
      public var contactRequests:PagingArrayCollection;
      
      public var transactionHistory:PagingArrayCollection;
      
      public var achievements:PagingArrayCollection;
      
      public var arcadeStats:PagingArrayCollection;
      
      public var feed:PagingArrayCollection;
      
      public var questions:PagingArrayCollection;
      
      public var recentOpponents:PagingArrayCollection;
      
      public var recentQuestions:ArrayCollection;
      
      public var favoriteArcadeStats:ArrayCollection;
      
      public var recentActivity:ArrayCollection;
      
      public var recentAchievements:ArrayCollection;
      
      public var recentWallPosts:ArrayCollection;
      
      public var recentContactSuggestions:PagingArrayCollection;
      
      public function PublicUserData()
      {
         super();
         this.profile = new ProfileData();
         this.playerStatus = new PlayerStatus();
         this.facebook = new FacebookData();
         this.productInventory = new ProductInventory();
         this.contactRequests = new PagingArrayCollection();
         this.transactionHistory = new PagingArrayCollection();
         this.achievements = new PagingArrayCollection();
         this.arcadeStats = new PagingArrayCollection();
         this.feed = new PagingArrayCollection();
         this.questions = new PagingArrayCollection();
         this.recentOpponents = new PagingArrayCollection();
         this.recentQuestions = new ArrayCollection();
         this.recentContactSuggestions = new PagingArrayCollection();
         this.favoriteArcadeStats = new ArrayCollection();
         this.recentActivity = new ArrayCollection();
         this.recentAchievements = new ArrayCollection();
         this.recentWallPosts = new ArrayCollection();
      }
      
      public function get chatUserJID() : UnescapedJID
      {
         return ChatUtil.getJIDFromUserID(this.id);
      }
      
      public function clear() : void
      {
         this.profile = new ProfileData();
         this.playerStatus.offline();
         this.facebook.clear();
         this.id = -1;
         this.numContactRequests = 0;
         this.email = "";
         this.aimUsername = "";
         this.firstName = "";
         this.lastName = "";
         this.contactRequests.removeAll();
         this.transactionHistory.removeAll();
         this.achievements.removeAll();
         this.feed.removeAll();
         this.questions.removeAll();
         this.recentOpponents.removeAll();
         this.recentQuestions.removeAll();
         this.recentContactSuggestions.removeAll();
         this.favoriteArcadeStats.removeAll();
         this.recentActivity.removeAll();
         this.recentWallPosts.removeAll();
         this.arcadeStats.removeAll();
         this.recentAchievements.removeAll();
         this.productInventory.collection.removeAll();
      }
      
      public function getStatsForGame(gameId:String) : ArcadeLeaderboardItemData
      {
         var stats:ArcadeLeaderboardItemData = null;
         var checkStat:ArcadeLeaderboardItemData = null;
         for each(checkStat in this.arcadeStats.source)
         {
            if(checkStat.gameId == gameId)
            {
               stats = checkStat;
               break;
            }
         }
         if(!stats)
         {
            stats = new ArcadeLeaderboardItemData();
            stats.experience = ExperienceData.createDummy();
            if(AppComponents.model.arcade.isApprovedGame(gameId))
            {
               stats.gameId = gameId;
               AppComponents.model.privateUser.arcadeStats.addItem(stats);
            }
         }
         return stats;
      }
      
      public function getGameStatsByShopId(shopID:int) : ArcadeLeaderboardItemData
      {
         var stats:ArcadeLeaderboardItemData = null;
         var shop:ProductShop = null;
         var pack:ArcadeGamePackData = null;
         try
         {
            shop = AppComponents.model.shop.shopCollection.getShopByID(shopID);
            pack = AppComponents.model.arcade.getCatalogItemByUid(shop.gameUID);
            stats = this.getStatsForGame(pack.id);
         }
         catch(e:Error)
         {
         }
         return stats;
      }
      
      public function getGameRatingHash() : *
      {
         var stat:ArcadeLeaderboardItemData = null;
         var result:* = {};
         for each(stat in this.arcadeStats.source)
         {
            if(AppComponents.model.arcade.isApprovedGame(stat.gameId) && !stat.isProvisional)
            {
               result[stat.gameId] = stat.rating;
            }
         }
         return result;
      }
      
      public function getGameLevelHash() : *
      {
         var stat:ArcadeLeaderboardItemData = null;
         var result:* = {};
         for each(stat in this.arcadeStats.source)
         {
            if(AppComponents.model.arcade.isApprovedGame(stat.gameId) || AppProperties.appVersion == AppProperties.VERSION_ARCADE_TESTER)
            {
               result[stat.gameId] = stat.experience.level;
            }
         }
         return result;
      }
      
      public function getGamePlaysHash() : *
      {
         var stat:ArcadeLeaderboardItemData = null;
         var result:* = {};
         for each(stat in this.arcadeStats.source)
         {
            if(AppComponents.model.arcade.isApprovedGame(stat.gameId))
            {
               result[stat.gameId] = stat.plays;
            }
         }
         return result;
      }
      
      public function initFromSessionData(data:*) : void
      {
         this.id = data.id;
         this.email = data.email_address;
         this.aimUsername = Boolean(data.aim_username)?data.aim_username:"";
         this.firstName = Boolean(data.first_name)?data.first_name:"";
         this.lastName = Boolean(data.last_name)?data.last_name:"";
         this.profile = ProfileData.createFromMerbResult(data);
         this.facebook.session.uid = data.facebook_id;
      }
      
      public function get hasPhoto() : Boolean
      {
         var pattern:RegExp = /\/gfx\/system_photo\//i;
         var test:Number = this.profile.photo_url.search(pattern);
         if(test >= 0)
         {
            return false;
         }
         return true;
      }
   }
}
