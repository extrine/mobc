package iilwy.model.dataobjects.arcade
{
   import iilwy.factories.AchievementFactory;
   import iilwy.factories.ShopFactory;
   import iilwy.iterators.ArrayIterator;
   import iilwy.model.dataobjects.AchievementData;
   import iilwy.model.dataobjects.shop.ProductPage;
   import iilwy.net.EventNotificationType;
   
   public class ArcadeMatchSummary
   {
       
      
      public var siteLevelUp:Boolean;
      
      public var gameLevelUp:Boolean;
      
      public var achievements:ArrayIterator;
      
      public var medal:String;
      
      public var siteUnlockedItems:Array;
      
      public var gameUnlockedItems:Array;
      
      public var betWonData:ArcadeBetWonData;
      
      public function ArcadeMatchSummary()
      {
         this.achievements = new ArrayIterator();
         this.siteUnlockedItems = [];
         this.gameUnlockedItems = [];
         this.betWonData = new ArcadeBetWonData();
         super();
      }
      
      public static function createDummyData() : ArcadeMatchSummary
      {
         var summary:ArcadeMatchSummary = new ArcadeMatchSummary();
         summary.siteLevelUp = Math.floor(Math.random() * 2) == 0?Boolean(false):Boolean(true);
         summary.gameLevelUp = Math.floor(Math.random() * 2) == 0?Boolean(false):Boolean(true);
         var achievementData:Object = {
            "asset_url":"http://achievementassetscdn.iminlikewithyou.com/achievement_asset-1-1248388800.jpg",
            "coins":20,
            "name":"Win A Race",
            "game_id":"hoverkart",
            "description":"Win your first race",
            "experience_points":10
         };
         var achievement:AchievementData = AchievementFactory.createAchievement(achievementData);
         summary.achievements.source.push(achievement);
         var medals:Array = [EventNotificationType.GOLD_MEDAL,EventNotificationType.SILVER_MEDAL,EventNotificationType.BRONZE_MEDAL];
         summary.medal = medals[Math.floor(Math.random() * 3)];
         var productPageData:Object = {"product_bases":[{
            "tags":[],
            "minimum_premium_level":0,
            "pop_text":"D O P E",
            "minimum_site_level":0,
            "minimum_game_level":0,
            "catalog_meta":{},
            "product_category_id":3,
            "product_category":{
               "icon_url":null,
               "selection_limit":1,
               "position":1,
               "previewable":false,
               "product_collection_id":1,
               "giftable":true,
               "external_key":"frames",
               "description":"You will look better on the internet with one of these photo frames.",
               "name":"Photo Frames",
               "id":3
            },
            "description":"Aim for the highest mountain!",
            "purchasable":true,
            "name":"Peak Vision",
            "products":[{
               "acquire_limit":0,
               "currency_type":"coins",
               "product_base_id":1451,
               "product_type":"perm_qty",
               "price":5400,
               "sell_back_coin_amount":1350,
               "pack_quantity":1,
               "units":"qty",
               "created_at":"2010-02-22T14:30:48-05:00",
               "stock_quantity":null,
               "acquirable":true,
               "purchasable":true,
               "name":"Peak Vision",
               "id":2585
            }],
            "image_url":"http://mediacdn.iminlikewithyou.com/productbase-1451-1266867034.jpg",
            "id":1451,
            "asset_url":"http://itemscdn.iminlikewithyou.com/productbasea-1451-1266867047.swf"
         }]};
         var productPage:ProductPage = ShopFactory.createProductPage(productPageData,0,0);
         summary.siteUnlockedItems = productPage.items.source;
         summary.gameUnlockedItems = productPage.items.source;
         return summary;
      }
      
      public function clear() : void
      {
         this.siteLevelUp = false;
         this.gameLevelUp = false;
         this.achievements = new ArrayIterator();
         this.medal = null;
         this.siteUnlockedItems = [];
         this.gameUnlockedItems = [];
         this.betWonData = new ArcadeBetWonData();
      }
   }
}
