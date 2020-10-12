package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   
   public class AchievementTest
   {
       
      
      public var active:Boolean;
      
      protected var id:String;
      
      public function AchievementTest()
      {
         super();
         this.active = true;
         this.id = "test_achievement";
      }
      
      public function destroy() : void
      {
      }
      
      public function test() : void
      {
      }
      
      public function get achievementID() : String
      {
         return this.id;
      }
      
      protected function earn() : void
      {
         if(this.id)
         {
            Globals.netController.earnAchievement(this.id);
            trace("achievement earned: " + this.id);
            this.active = false;
         }
      }
   }
}
