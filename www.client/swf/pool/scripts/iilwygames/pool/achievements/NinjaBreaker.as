package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class NinjaBreaker extends AchievementTest
   {
       
      
      public function NinjaBreaker()
      {
         super();
         id = "ninja_breaker";
      }
      
      override public function test() : void
      {
         var cueBall:Ball = Globals.model.ruleset.cueBall;
         if(cueBall.railsHitBeforeFirstHit > 0)
         {
            earn();
         }
      }
   }
}
