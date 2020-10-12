package iilwygames.baloono.gameplay
{
   import com.partlyhuman.types.IDestroyable;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public interface ITileItem extends IDestroyable
   {
       
      
      function setArt(param1:GraphicSet) : void;
      
      function get graphicEntity() : GraphicEntity;
      
      function blocksPlayer(param1:IPlayer) : Boolean;
      
      function get state() : TileState;
      
      function setPosition(param1:Number, param2:Number) : void;
   }
}
