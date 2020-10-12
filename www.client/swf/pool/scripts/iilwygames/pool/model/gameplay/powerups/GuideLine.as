package iilwygames.pool.model.gameplay.powerups
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.CueStick;
   
   public class GuideLine extends Powerup
   {
       
      
      public function GuideLine()
      {
         super();
      }
      
      override protected function execute(forPlayer:Player) : void
      {
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         cueStick.setGuideLevel(power_level);
      }
      
      override protected function deactivate() : void
      {
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         cueStick.setGuideLevel(0);
      }
   }
}
