package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class StickItHard extends AchievementTest
   {
       
      
      public function StickItHard()
      {
         super();
         id = "stick_it_hard";
      }
      
      override public function test() : void
      {
         var lp:Player = Globals.model.localPlayer;
         var rs:Ruleset = Globals.model.ruleset;
         if(lp && lp.fullPowerPlay && rs.legalBreak && lp.turnFinished)
         {
            earn();
         }
      }
   }
}
