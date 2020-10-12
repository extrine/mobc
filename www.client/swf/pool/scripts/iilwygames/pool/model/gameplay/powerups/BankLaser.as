package iilwygames.pool.model.gameplay.powerups
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.CueStick;
   
   public class BankLaser extends Powerup
   {
       
      
      public function BankLaser()
      {
         super();
      }
      
      override protected function execute(forPlayer:Player) : void
      {
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         cueStick.setBounceLevel(power_level);
      }
      
      override protected function deactivate() : void
      {
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         cueStick.setBounceLevel(0);
      }
   }
}
