package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class BlackDeath extends AchievementTest
   {
       
      
      public function BlackDeath()
      {
         super();
         id = "black_death";
      }
      
      override public function test() : void
      {
         var b:Ball = null;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         var ballsPocketed:Vector.<Ball> = Globals.model.ruleset.ballsSankThisTurn;
         var teamType:int = Globals.model.ruleset.currentTeam.teamBallType;
         var numBalls:int = ballsPocketed.length;
         var eightBallActive:Boolean = true;
         var teamBallsActive:int = 0;
         for(var i:int = 0; i < numBalls; i++)
         {
            b = ballsPocketed[i];
            if(b.ballNumber == 8)
            {
               eightBallActive = false;
            }
            else if(b.ballType == teamType && b.ballNumber != 8 && b.ballType != Ball.BALL_CUE)
            {
               teamBallsActive++;
            }
         }
         if(!eightBallActive)
         {
            for(i = 0; i < balls.length; i++)
            {
               b = balls[i];
               if(b.ballType == teamType && b.ballNumber != 8 && b.ballType != Ball.BALL_CUE && b.active)
               {
                  teamBallsActive++;
               }
            }
            if(teamBallsActive)
            {
               earn();
            }
         }
      }
   }
}
