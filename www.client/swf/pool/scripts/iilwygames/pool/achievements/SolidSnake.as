package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class SolidSnake extends AchievementTest
   {
       
      
      protected var winRequirement:int;
      
      public function SolidSnake()
      {
         super();
         id = "solid_snake";
         this.winRequirement = 10;
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.winsAsSolids >= this.winRequirement)
         {
            earn();
         }
      }
   }
}
