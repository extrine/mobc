package iilwygames.baloono.commands
{
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   
   public class BlockDamageCommand extends TileChangeCommand
   {
       
      
      public var newStrength:Number;
      
      public function BlockDamageCommand(param1:uint = 0, param2:BlockTile = null, param3:int = 0)
      {
         super(param1,0,0);
         if(param2)
         {
            this.x = int(param2.graphicEntity.x);
            this.y = int(param2.graphicEntity.y);
            this.newStrength = param2.strength - param3;
            trace("BLOCK\'S NEW STRENF:",this.newStrength.toString());
         }
      }
      
      override public function toString() : String
      {
         return "[BlockDamageCommand]";
      }
      
      public function get isDestroyed() : Boolean
      {
         return this.newStrength <= 0;
      }
   }
}
