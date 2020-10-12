package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class IntentionalError extends AchievementTest
   {
       
      
      public function IntentionalError()
      {
         super();
         id = "i_meant_to_do_that";
      }
      
      override public function test() : void
      {
         var b:Ball = null;
         var ballsPocketed:Vector.<Ball> = Globals.model.ruleset.ballsSankThisTurn;
         var teamType:int = Globals.model.ruleset.currentTeam.teamBallType;
         var i:int = ballsPocketed.length - 1;
         while(i >= 0)
         {
            b = ballsPocketed[i--];
            if(teamType != b.ballType && b.ballType != Ball.BALL_CUE && teamType != Ball.BALL_NONE)
            {
               earn();
               return;
            }
         }
      }
   }
}
