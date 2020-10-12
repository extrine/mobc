package iilwygames.pool.achievements
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   
   public class PoolShark extends AchievementTest
   {
       
      
      public function PoolShark()
      {
         super();
         id = "pool_shark";
      }
      
      override public function test() : void
      {
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.winStreak >= 3)
         {
            earn();
         }
      }
   }
}
