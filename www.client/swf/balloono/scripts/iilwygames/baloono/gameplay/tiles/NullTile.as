package iilwygames.baloono.gameplay.tiles
{
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class NullTile implements ITileItem
   {
      
      public static const NULL_TILE:NullTile = new NullTile();
       
      
      public function NullTile()
      {
         super();
      }
      
      public function setArt(param1:GraphicSet) : void
      {
      }
      
      public function get graphicEntity() : GraphicEntity
      {
         return null;
      }
      
      public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return false;
      }
      
      public function toString() : String
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            return "[NullTile]";
         }
         return "";
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
      }
      
      public function get state() : TileState
      {
         return TileState.INACTIVE;
      }
      
      public function destroy() : void
      {
      }
   }
}
