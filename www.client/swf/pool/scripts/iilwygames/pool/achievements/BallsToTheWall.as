package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class BallsToTheWall extends AchievementTest
   {
       
      
      public function BallsToTheWall()
      {
         super();
         id = "balls_to_the_wall";
      }
      
      override public function test() : void
      {
         var b:Ball = null;
         var ballsPocketed:Vector.<Ball> = Globals.model.ruleset.ballsSankThisTurn;
         var i:int = 0;
         for(var len:int = ballsPocketed.length; i < len; )
         {
            b = ballsPocketed[i];
            if(b.ballType != Ball.BALL_CUE && b.railsHit > 1)
            {
               earn();
               return;
            }
            i++;
         }
      }
   }
}
