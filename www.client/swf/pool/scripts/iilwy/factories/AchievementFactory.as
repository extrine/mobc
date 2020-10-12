package iilwy.factories
{
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.DictionaryCollection;
   import iilwy.model.dataobjects.AchievementData;
   
   public class AchievementFactory
   {
       
      
      public function AchievementFactory()
      {
         super();
      }
      
      public static function createAchievementCollection(data:Object) : DictionaryCollection
      {
         var game:Object = null;
         var achievementCollection:DictionaryCollection = new DictionaryCollection();
         for each(game in data)
         {
            achievementCollection.addItem(game.game_id,new ArrayCollection(createAchievementsArray(game.achievements)));
         }
         return achievementCollection;
      }
      
      public static function createAchievementsArray(data:Object) : Array
      {
         var achievementData:Object = null;
         var achievement:AchievementData = null;
         var achievements:Array = [];
         for each(achievementData in data)
         {
            achievement = createAchievement(achievementData);
            achievements.push(achievement);
         }
         return achievements;
      }
      
      public static function createAchievement(data:Object) : AchievementData
      {
         var achievement:AchievementData = new AchievementData();
         achievement.id = data.id;
         achievement.gameID = data.game_id;
         achievement.name = data.name;
         achievement.description = data.description;
         achievement.imageURL = data.asset_url;
         achievement.experiencePoints = data.experience_points;
         achievement.achieved = data.achieved;
         achievement.coins = data.coins;
         return achievement;
      }
   }
}
