package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class BreakDown extends AchievementTest
   {
       
      
      public function BreakDown()
      {
         super();
         id = "break_down";
      }
      
      override public function test() : void
      {
         var ballsPocketed:Vector.<Ball> = Globals.model.ruleset.ballsSankThisTurn;
         var cueBall:Ball = Globals.model.ruleset.cueBall;
         var numBallsPocketed:int = ballsPocketed.length;
         if(!cueBall.active)
         {
            numBallsPocketed = numBallsPocketed - 1;
         }
         if(numBallsPocketed > 0)
         {
            earn();
         }
      }
   }
}
