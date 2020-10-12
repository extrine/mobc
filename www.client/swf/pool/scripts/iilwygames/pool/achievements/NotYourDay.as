package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerRemote;
   import iilwygames.pool.model.gameplay.Team;
   
   public class NotYourDay extends AchievementTest
   {
       
      
      public function NotYourDay()
      {
         super();
         id = "not_your_day";
      }
      
      override public function test() : void
      {
         var winner:int = Globals.model.ruleset.winnerIndex;
         var team:Team = Globals.model.ruleset.teams[winner];
         var player:Player = team.getCurrentPlayerUp();
         if(player is PlayerRemote && !player.tableRelenquished && player.isBreaker)
         {
            earn();
         }
      }
   }
}
