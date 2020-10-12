package iilwygames.pool.achievements
{
   import iilwy.application.AppComponents;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class HighRoller extends AchievementTest
   {
       
      
      public function HighRoller()
      {
         super();
         id = "high_roller";
      }
      
      override public function test() : void
      {
         var betAmount:int = 0;
         var localPlayer:Player = Globals.model.localPlayer;
         if(AppComponents.gamenetManager && AppComponents.gamenetManager.currentMatch)
         {
            betAmount = AppComponents.gamenetManager.currentMatch.betAmount;
            if(localPlayer && localPlayer.teamID == Globals.model.ruleset.winnerIndex && Globals.model.ruleset.singlePlayer == false && betAmount >= 10000)
            {
               earn();
            }
         }
      }
   }
}
