package iilwygames.pool.model.gameplay.powerups
{
   import iilwygames.pool.model.Player;
   
   public class Powerup
   {
       
      
      public var power_type:String;
      
      public var power_level:int;
      
      protected var _player:Player;
      
      public function Powerup()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function onTurnStart(forPlayer:Player) : void
      {
      }
      
      public function onTurnEnd() : void
      {
      }
      
      protected function execute(forPlayer:Player) : void
      {
      }
      
      public function activate(forPlayer:Player) : void
      {
      }
      
      protected function deactivate() : void
      {
      }
   }
}
