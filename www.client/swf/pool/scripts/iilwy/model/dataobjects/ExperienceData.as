package iilwy.model.dataobjects
{
   import iilwy.utils.MathUtil;
   
   public class ExperienceData
   {
       
      
      public var level:Number = 0;
      
      public var levelUp:Boolean;
      
      public var experiencePoints:Number = 0;
      
      public var levelStartExperiencePoints:Number = 0;
      
      public var levelEndExperiencePoints:Number = 100;
      
      public function ExperienceData()
      {
         super();
      }
      
      public static function createTest() : ExperienceData
      {
         var test:ExperienceData = new ExperienceData();
         test.level = Math.floor(Math.random() * 100);
         test.levelUp = Math.floor(Math.random() * 2) == 0?Boolean(false):Boolean(true);
         test.levelStartExperiencePoints = test.level * 100;
         test.levelEndExperiencePoints = test.levelStartExperiencePoints + 99;
         test.experiencePoints = test.levelStartExperiencePoints + Math.floor(Math.random() * 100);
         return test;
      }
      
      public static function createFromMerbResult(data:*) : ExperienceData
      {
         var exp:ExperienceData = new ExperienceData();
         if(data)
         {
            exp.level = data.level;
            exp.levelUp = data.level_up;
            exp.levelStartExperiencePoints = data.total_exp_for_this_level;
            exp.levelEndExperiencePoints = data.total_exp_for_next_level;
            exp.experiencePoints = data.exp;
         }
         return exp;
      }
      
      public static function createDummy() : ExperienceData
      {
         var exp:ExperienceData = new ExperienceData();
         exp.level = 1;
         exp.levelUp = true;
         exp.levelStartExperiencePoints = 0;
         exp.levelEndExperiencePoints = 100;
         exp.experiencePoints = 0;
         return exp;
      }
      
      public function copy(from:ExperienceData) : void
      {
         this.level = from.level;
         this.levelUp = from.levelUp;
         this.experiencePoints = from.experiencePoints;
         this.levelStartExperiencePoints = from.levelStartExperiencePoints;
         this.levelEndExperiencePoints = from.levelEndExperiencePoints;
      }
      
      public function clone() : ExperienceData
      {
         var exp:ExperienceData = new ExperienceData();
         exp.copy(this);
         return exp;
      }
      
      public function get percentOfLevelComplete() : Number
      {
         var result:Number = 0;
         var elapsed:Number = this.experiencePoints - this.levelStartExperiencePoints;
         var max:Number = this.levelEndExperiencePoints - this.levelStartExperiencePoints;
         return MathUtil.clamp(0,1,elapsed / max);
      }
      
      public function get pointsEarnedInThisLevel() : Number
      {
         return this.experiencePoints - this.levelStartExperiencePoints;
      }
      
      public function get pointsRemainingInThisLevel() : Number
      {
         return this.levelEndExperiencePoints - this.experiencePoints;
      }
      
      public function get pointsInThisLevel() : Number
      {
         return this.levelEndExperiencePoints - this.levelStartExperiencePoints;
      }
      
      public function getTooltipString() : String
      {
         var str:String = "Level " + this.level + " // " + this.experiencePoints + " experience points";
         return str;
      }
   }
}
