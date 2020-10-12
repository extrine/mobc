package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class FirstVictory extends AchievementTest
   {
       
      
      public function FirstVictory()
      {
         super();
         id = "first_victory";
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.teamID == Globals.model.ruleset.winnerIndex && Globals.model.ruleset.singlePlayer == false)
         {
            earn();
         }
      }
   }
}
