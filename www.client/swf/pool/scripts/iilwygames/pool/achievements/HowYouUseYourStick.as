package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class HowYouUseYourStick extends AchievementTest
   {
       
      
      public function HowYouUseYourStick()
      {
         super();
         id = "how_you_use_your_stick";
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.teamID == Globals.model.ruleset.winnerIndex && Globals.model.ruleset.singlePlayer == false && !localPlayer.maxPowerUsed)
         {
            earn();
         }
      }
   }
}
