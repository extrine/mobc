package iilwygames.baloono.gameplay.tiles
{
   import com.partlyhuman.types.IDestroyable;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class AbstractTile implements ITileItem, IDestroyable
   {
       
      
      protected var graphics:GraphicEntity;
      
      protected var _state:TileState;
      
      public function AbstractTile()
      {
         super();
         this.graphics = new GraphicEntity();
         this._state = TileState.ACTIVE;
      }
      
      public function destroy() : void
      {
         if(this.graphics)
         {
            this.graphics.destroy();
            this.graphics = null;
         }
         else
         {
            trace("deleting null graphics!");
         }
      }
      
      public function set state(param1:TileState) : void
      {
         this._state = param1;
      }
      
      public function get graphicEntity() : GraphicEntity
      {
         return this.graphics;
      }
      
      public function get x() : Number
      {
         if(!this.graphics)
         {
            return -1;
         }
         return this.graphics.x;
      }
      
      public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return false;
      }
      
      public function setArt(param1:GraphicSet) : void
      {
         this.graphics.gset = param1;
      }
      
      public function get state() : TileState
      {
         return this._state;
      }
      
      public function get y() : Number
      {
         if(!this.graphics)
         {
            return -1;
         }
         return this.graphics.y;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.graphics.x = param1;
         this.graphics.y = param2;
      }
   }
}
