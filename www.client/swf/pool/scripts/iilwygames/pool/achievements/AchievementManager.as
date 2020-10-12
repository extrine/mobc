package iilwygames.pool.achievements
{
   import flash.utils.Dictionary;
   import iilwygames.pool.core.Globals;
   
   public class AchievementManager
   {
       
      
      private var achievementClasses:Array;
      
      private var achTests:Dictionary;
      
      private var numAchievements:int;
      
      private const ACHIEVEMENTS_ENABLED:Boolean = true;
      
      public function AchievementManager()
      {
         var ac:Class = null;
         var newTest:AchievementTest = null;
         this.achievementClasses = [FirstVictory,BreakDown,IntentionalError,TwoFer,BallsToTheWall,BeatACrew,BeatAStar,BeatCharles,BlackDeath,NotYourDay,Unstoppable,StickItHard,HowYouUseYourStick,ThereCanOnlyBeOne,NinjaBreaker,OnARoll,HighRoller,PoolShark,PrinceOfPool,KingOfPool,Baller,BallAssassin,BallBuster,SolidSnake,StripeOut];
         super();
         this.achTests = new Dictionary();
         for each(ac in this.achievementClasses)
         {
            newTest = new ac();
            this.achTests[newTest.achievementID] = newTest;
         }
         this.achievementClasses = null;
      }
      
      public function destroy() : void
      {
         var at:AchievementTest = null;
         for each(at in this.achTests)
         {
            at.destroy();
         }
         this.achTests = null;
      }
      
      public function testAchievement(id:String) : void
      {
         var at:AchievementTest = null;
         if(this.ACHIEVEMENTS_ENABLED && id)
         {
            at = this.achTests[id];
            if(at && at.active)
            {
               at.test();
            }
         }
      }
      
      public function postGameAchievementTests() : void
      {
         if(Globals.model.ruleset.singlePlayer == false && Globals.model.localPlayer)
         {
            this.testAchievement("first_victory");
            this.testAchievement("beat_a_star");
            this.testAchievement("beat_a_crew");
            this.testAchievement("beat_a_charles");
            this.testAchievement("stick_it_hard");
            this.testAchievement("not_your_day");
            this.testAchievement("unstoppable");
            this.testAchievement("how_you_use_your_stick");
            this.testAchievement("there_can_only_be_one");
            this.testAchievement("high_roller");
            this.testAchievement("pool_shark");
            this.testAchievement("prince_of_pool");
            this.testAchievement("king_of_pool");
            this.testAchievement("solid_snake");
            this.testAchievement("stripe_out");
         }
      }
   }
}
