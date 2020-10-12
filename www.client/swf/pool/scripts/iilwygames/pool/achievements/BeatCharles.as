package iilwygames.pool.achievements
{
   import iilwy.model.dataobjects.user.PremiumLevels;
   
   public class BeatCharles extends BeatAStar
   {
       
      
      public function BeatCharles()
      {
         super();
         id = "beat_a_charles";
         premiumLevelTest = PremiumLevels.CHARLES;
      }
   }
}
