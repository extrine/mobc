package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class PrinceOfPool extends AchievementTest
   {
       
      
      protected var winRequirement:int;
      
      public function PrinceOfPool()
      {
         super();
         id = "prince_of_pool";
         this.winRequirement = 10;
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.winsCount >= this.winRequirement)
         {
            earn();
         }
      }
   }
}
