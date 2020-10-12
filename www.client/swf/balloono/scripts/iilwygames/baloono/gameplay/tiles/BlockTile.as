package iilwygames.baloono.gameplay.tiles
{
   import com.partlyhuman.util.Assert;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.BlockDamageCommand;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.player.MyPlayer;
   import iilwygames.baloono.graphics.AssetEvent;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class BlockTile extends AbstractTile
   {
      
      protected static const ASSET_DAMAGED:String = "damaged";
      
      protected static const ASSET_RECEIVE_DAMAGE:String = "receiveDamage";
      
      protected static const ASSET_DESTROY:String = "destroy";
      
      protected static const ASSET_NORMAL:String = "default";
       
      
      public var strength:Number = 1;
      
      public var contents:ITileItem;
      
      public var breakable:Boolean = true;
      
      public function BlockTile()
      {
         super();
      }
      
      override public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return state.active;
      }
      
      public function toString() : String
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            return "[Block Tile]";
         }
         return "";
      }
      
      override public function setArt(param1:GraphicSet) : void
      {
         super.setArt(param1);
         graphics.playAnimation(ASSET_NORMAL);
      }
      
      protected function onDestroyAnimationComplete(param1:AssetEvent) : void
      {
         _state = TileState.INACTIVE;
         graphics.removeEventListener(AssetEvent.SEQUENCE_COMPLETE,this.onDestroyAnimationComplete);
         BaloonoGame.instance.mapManager.currentMap.blocks.set(int(graphics.x),int(graphics.y),NullTile.NULL_TILE);
         BaloonoGame.instance.mapView.removeTile(this);
      }
      
      public function destroyBlock(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MapModel = null;
         var _loc5_:Object = null;
         if(state.inactive)
         {
            return;
         }
         graphics.playAnimation(ASSET_DESTROY,param1);
         graphics.addEventListener(AssetEvent.SEQUENCE_COMPLETE,this.onDestroyAnimationComplete);
         _state = TileState.INACTIVE_ANIMATING;
         if(this.contents)
         {
            _loc2_ = int(graphics.x);
            _loc3_ = int(graphics.y);
            _loc4_ = BaloonoGame.instance.mapManager.currentMap;
            _loc5_ = _loc4_.powerups.get(_loc2_,_loc3_);
            if(_loc5_ is NullTile || _loc5_ == null)
            {
               this.contents.setPosition(_loc2_,_loc3_);
               _loc4_.powerups.set(_loc2_,_loc3_,this.contents);
               BaloonoGame.instance.mapView.addPowerupTile(this.contents);
            }
            else
            {
               Assert.fail("adding a powerup to a tile with a powerup already there");
            }
         }
         BaloonoGame.instance.mapManager.checkMapStatus();
      }
      
      public function respondToCommand(param1:BlockDamageCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MapModel = null;
         var _loc5_:Object = null;
         if(state.inactive)
         {
            return;
         }
         this.strength = param1.newStrength;
         if(param1.isDestroyed)
         {
            graphics.playAnimation(ASSET_DESTROY,param1.occurTime);
            graphics.addEventListener(AssetEvent.SEQUENCE_COMPLETE,this.onDestroyAnimationComplete);
            _state = TileState.INACTIVE_ANIMATING;
            if(this.contents)
            {
               _loc2_ = int(graphics.x);
               _loc3_ = int(graphics.y);
               _loc4_ = BaloonoGame.instance.mapManager.currentMap;
               _loc5_ = _loc4_.powerups.get(_loc2_,_loc3_);
               if(_loc5_ is NullTile || _loc5_ == null)
               {
                  this.contents.setPosition(_loc2_,_loc3_);
                  _loc4_.powerups.set(_loc2_,_loc3_,this.contents);
                  BaloonoGame.instance.mapView.addPowerupTile(this.contents);
               }
               else
               {
                  Assert.fail("adding a powerup to a tile with a powerup already there");
               }
            }
         }
         else
         {
            graphics.playAnimation(ASSET_RECEIVE_DAMAGE,param1.occurTime);
         }
      }
      
      public function onDropBlockAnimationComplete(param1:AssetEvent) : void
      {
         _state = TileState.ACTIVE;
         graphics.removeEventListener(AssetEvent.SEQUENCE_COMPLETE,this.onDropBlockAnimationComplete);
         var _loc2_:MyPlayer = BaloonoGame.instance.playerManager.me;
         if(_loc2_ && _loc2_.state.active && _loc2_.graphicEntity && Math.round(_loc2_.graphicEntity.x) == x && Math.round(_loc2_.graphicEntity.y) == y)
         {
            _loc2_.die();
         }
         BaloonoGame.instance.mapView.grid2.setTileAsDirty(this);
         graphicEntity.playAnimation("default",BaloonoGame.time);
      }
   }
}
