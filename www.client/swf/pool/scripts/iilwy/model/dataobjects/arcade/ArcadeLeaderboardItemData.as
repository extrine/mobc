package iilwy.model.dataobjects.arcade
{
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ExperienceData;
   import iilwy.model.dataobjects.ProfileData;
   
   public class ArcadeLeaderboardItemData
   {
       
      
      public var player:PlayerData;
      
      public var position:Number = 0;
      
      public var rating:Number = 0;
      
      public var ratingCoefficient:Number = 0;
      
      public var coinsWon:Number = 0;
      
      public var gold:Number = 0;
      
      public var silver:Number = 0;
      
      public var bronze:Number = 0;
      
      public var medals:Number = 0;
      
      public var score1:Number = 0;
      
      public var score2:Number = 0;
      
      public var score3:Number = 0;
      
      public var score4:Number = 0;
      
      public var score5:Number = 0;
      
      public var plays:Number = 0;
      
      public var time:Number = 0;
      
      public var gameId:String;
      
      public var experience:ExperienceData;
      
      public function ArcadeLeaderboardItemData()
      {
         super();
         this.experience = new ExperienceData();
      }
      
      public static function createDictFromStatsResponse(data:*) : *
      {
         var gameId:* = null;
         var stat:* = undefined;
         var stats:* = {};
         for(gameId in data)
         {
            if(AppComponents.model.arcade.isApprovedGame(gameId))
            {
               stat = {};
               stat = ArcadeLeaderboardItemData.createFromApiResponse(data[gameId]);
               stats[gameId] = stat;
            }
         }
         return stats;
      }
      
      public static function createListFromStatsResponse(data:*) : Array
      {
         var gameId:* = null;
         var stat:* = undefined;
         var arr:Array = new Array();
         for(gameId in data)
         {
            if(AppComponents.model.arcade.isApprovedGame(gameId) || AppProperties.debugMode != AppProperties.MODE_NOT_DEBUGGING)
            {
               stat = {};
               stat = ArcadeLeaderboardItemData.createFromApiResponse(data[gameId]);
               stat.gameId = gameId;
               arr.push(stat);
            }
         }
         return arr;
      }
      
      public static function createFromApiResponse(data:*) : ArcadeLeaderboardItemData
      {
         var profile:ProfileData = null;
         var d:ArcadeLeaderboardItemData = new ArcadeLeaderboardItemData();
         if(data.profile)
         {
            profile = new ProfileData();
            profile.initFromJSON(data);
            d.player = new PlayerData();
            d.player.initFromProfile(profile);
         }
         if(data.experience)
         {
            d.experience = ExperienceData.createFromMerbResult(data.experience);
         }
         else
         {
            d.experience = ExperienceData.createDummy();
         }
         d.coinsWon = data.coins_won;
         d.gold = data.gold;
         d.silver = data.silver;
         d.bronze = data.bronze;
         d.medals = d.gold + d.silver + d.bronze;
         d.score1 = data.score1;
         d.score2 = data.score2;
         d.score3 = data.score3;
         d.score4 = data.score4;
         d.score5 = data.score5;
         d.rating = data.elo;
         d.ratingCoefficient = data.coefficient;
         d.position = data.position;
         d.plays = data.plays;
         d.time = data.total_time;
         return d;
      }
      
      public static function createTest() : ArcadeLeaderboardItemData
      {
         var d:ArcadeLeaderboardItemData = new ArcadeLeaderboardItemData();
         d.player = PlayerData.createTest();
         d.coinsWon = Math.floor(Math.random() * 20);
         d.gold = Math.floor(Math.random() * 20);
         d.silver = Math.floor(Math.random() * 20);
         d.bronze = Math.floor(Math.random() * 20);
         d.medals = d.gold + d.silver + d.bronze;
         d.score1 = Math.floor(Math.random() * 20);
         d.score2 = Math.floor(Math.random() * 20);
         d.score3 = Math.floor(Math.random() * 20);
         d.score4 = Math.floor(Math.random() * 20);
         d.score5 = Math.floor(Math.random() * 20);
         d.rating = Math.floor(Math.random() * 900) + 900;
         d.plays = Math.floor(Math.random() * 100);
         return d;
      }
      
      public function get isProvisional() : Boolean
      {
         if(this.ratingCoefficient < 32)
         {
            return true;
         }
         return false;
      }
      
      public function get playsTillNotProvisional() : Number
      {
         return Math.ceil((32 - this.ratingCoefficient) / 2);
      }
   }
}
