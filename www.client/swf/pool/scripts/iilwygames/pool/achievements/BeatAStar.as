package iilwygames.pool.achievements
{
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerRemote;
   
   public class BeatAStar extends AchievementTest
   {
       
      
      protected var premiumLevelTest:int;
      
      public function BeatAStar()
      {
         super();
         id = "beat_a_star";
         this.premiumLevelTest = PremiumLevels.STAR;
      }
      
      override public function test() : void
      {
         var focusPlayer:Player = null;
         var i:int = 0;
         var players:Vector.<Player> = Globals.model.players;
         var len:int = players.length;
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && localPlayer.teamID == Globals.model.ruleset.winnerIndex)
         {
            for(i = 0; i < len; i++)
            {
               focusPlayer = players[i];
               if(focusPlayer && focusPlayer.playerData.premiumLevel == this.premiumLevelTest && focusPlayer is PlayerRemote)
               {
                  earn();
               }
            }
         }
      }
   }
}
