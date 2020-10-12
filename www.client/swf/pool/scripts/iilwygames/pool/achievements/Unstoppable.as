package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerLocal;
   import iilwygames.pool.model.gameplay.Team;
   
   public class Unstoppable extends AchievementTest
   {
       
      
      public function Unstoppable()
      {
         super();
         id = "unstoppable";
      }
      
      override public function test() : void
      {
         var winner:int = Globals.model.ruleset.winnerIndex;
         var team:Team = Globals.model.ruleset.teams[winner];
         var player:Player = team.getCurrentPlayerUp();
         if(player is PlayerLocal && player.turnTaken && !player.tableRelenquished && player.isBreaker)
         {
            earn();
         }
      }
   }
}
