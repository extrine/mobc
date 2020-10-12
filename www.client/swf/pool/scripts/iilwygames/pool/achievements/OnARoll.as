package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Team;
   
   public class OnARoll extends AchievementTest
   {
       
      
      public function OnARoll()
      {
         super();
         id = "on_a_roll";
      }
      
      override public function test() : void
      {
         var currentTeam:Team = Globals.model.ruleset.currentTeam;
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.teamID == currentTeam.teamID && currentTeam.consecutiveTurns == 3)
         {
            earn();
         }
      }
   }
}
