package iilwygames.pool.model.gameplay.powerups
{
   import com.omgpop.game.fbpool.model.enum.shop.CatalogMetaValues;
   import iilwygames.pool.model.Player;
   
   public class TimeExtend extends Powerup
   {
       
      
      public var timeIncrements:Array;
      
      public function TimeExtend()
      {
         super();
         power_type = CatalogMetaValues.KEY_POWER_SHOT_TIME;
      }
      
      override protected function execute(forPlayer:Player) : void
      {
         var time:uint = 0;
         if(power_level >= 0)
         {
            time = this.timeIncrements[power_level] * 1000;
            forPlayer.timeExtenstion = time;
         }
      }
      
      override protected function deactivate() : void
      {
         _player.timeExtenstion = 0;
      }
   }
}
