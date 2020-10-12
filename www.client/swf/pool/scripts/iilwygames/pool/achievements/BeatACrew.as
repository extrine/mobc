package iilwygames.pool.achievements
{
   import iilwy.model.dataobjects.user.PremiumLevels;
   
   public class BeatACrew extends BeatAStar
   {
       
      
      public function BeatACrew()
      {
         super();
         id = "beat_a_crew";
         premiumLevelTest = PremiumLevels.CREW;
      }
   }
}
