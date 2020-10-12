package iilwy.model.dataobjects.arcade
{
   public class ArcadePlayerStatsData
   {
       
      
      public var record:ArcadeLeaderboardItemData;
      
      public var recentAchievements;
      
      public var goldPosition:Number = 0;
      
      public var ratingPosition:Number = 0;
      
      public var timeSpent:Number = 0;
      
      public var plays:Number = 0;
      
      public function ArcadePlayerStatsData()
      {
         super();
         this.record = new ArcadeLeaderboardItemData();
      }
   }
}
