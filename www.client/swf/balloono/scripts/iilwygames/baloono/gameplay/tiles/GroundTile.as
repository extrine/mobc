package iilwygames.baloono.gameplay.tiles
{
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class GroundTile extends AbstractTile
   {
      
      protected static const DEFAULT:String = "default";
       
      
      public function GroundTile()
      {
         super();
      }
      
      override public function setArt(param1:GraphicSet) : void
      {
         super.setArt(param1);
         graphics.playAnimation(DEFAULT);
      }
      
      override public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return false;
      }
   }
}
