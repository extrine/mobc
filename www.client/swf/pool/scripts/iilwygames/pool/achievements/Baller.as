package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class Baller extends AchievementTest
   {
       
      
      protected var pocketRequirement:int;
      
      public function Baller()
      {
         super();
         id = "baller";
         this.pocketRequirement = 100;
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.ballsPocketed >= this.pocketRequirement)
         {
            earn();
         }
      }
   }
}
