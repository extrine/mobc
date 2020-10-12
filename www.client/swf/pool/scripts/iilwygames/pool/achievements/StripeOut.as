package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class StripeOut extends AchievementTest
   {
       
      
      protected var winRequirement:int;
      
      public function StripeOut()
      {
         super();
         id = "stripe_out";
         this.winRequirement = 10;
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.winsAsStripes >= this.winRequirement)
         {
            earn();
         }
      }
   }
}
