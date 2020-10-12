package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class ThereCanOnlyBeOne extends AchievementTest
   {
       
      
      public function ThereCanOnlyBeOne()
      {
         super();
         id = "there_can_only_be_one";
      }
      
      override public function test() : void
      {
         var i:int = 0;
         var len:int = 0;
         var b:Ball = null;
         var localPlayer:Player = Globals.model.localPlayer;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         if(localPlayer && localPlayer.teamID == Globals.model.ruleset.winnerIndex && Globals.model.ruleset.singlePlayer == false)
         {
            i = 0;
            for(len = balls.length; i < len; )
            {
               b = balls[i];
               if(b.active && b.ballType != Ball.BALL_CUE)
               {
                  return;
               }
               i++;
            }
            earn();
         }
      }
   }
}
