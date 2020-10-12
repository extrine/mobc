package iilwygames.baloono.gameplay.bomb
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.types.IDestroyable;
   import flash.utils.getTimer;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.IBomb;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.player.BombAbility;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class Bomb implements IBomb, ITileItem, IDestroyable
   {
      
      protected static const UPDATE_PRIORITY:int = 2;
      
      protected static const EXPLODE_ANIMATION_DURATION:int = 400;
       
      
      public var lastTime:int;
      
      public var prevX:int;
      
      public var prevY:int;
      
      protected const MAX_SPEEDUP:Number = 2;
      
      public var detonateTime:uint;
      
      protected const EXPLODING_ASSET:String = "exploding";
      
      protected var _state:TileState;
      
      public var dx:int;
      
      public var dy:int;
      
      public var flying:Boolean;
      
      protected const TICKING_ASSET:String = "ticking";
      
      protected var manager:BombManager;
      
      public var explosionEgg:Explosion;
      
      public var owner:Player;
      
      protected var _id:int;
      
      protected var graphic:GraphicEntity;
      
      public var createTime:uint;
      
      public var flyVelocity:Number = 0.007;
      
      public function Bomb(param1:int, param2:uint, param3:uint, param4:Player, param5:BombAbility)
      {
         super();
         this._id = param1;
         this.detonateTime = param3;
         this.createTime = param2;
         this.owner = param4;
         this.explosionEgg = new Explosion(param4,param5.explosionSize,param5.explosionMaxSizeHoldTime,param5.explosionExpansionDelay,this);
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.flying = false;
         this.dx = 0;
         this.dy = 0;
         this.lastTime = getTimer();
         this._state = TileState.ACTIVE;
         this.graphic = new GraphicEntity();
         this.setArt(BaloonoGame.instance.assetManager.getGraphicSet("bomb"));
         this.manager = BaloonoGame.instance.bombManager;
         this.manager.registerBomb(this);
      }
      
      public function get state() : TileState
      {
         return this._state;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return this._state == TileState.ACTIVE;
      }
      
      public function setArt(param1:GraphicSet) : void
      {
         this.graphic.gset = param1;
         this.graphic.playAnimation(this.TICKING_ASSET,0,this.createTime);
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.graphic.x = param1;
         this.graphic.y = param2;
         this.prevX = Math.round(this.graphic.x);
         this.prevY = Math.round(this.graphic.y);
      }
      
      public function update(param1:uint) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc11_:Player = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc2_:uint = BaloonoGame.time;
         if(this._state == TileState.INACTIVE)
         {
            return true;
         }
         if(this._state == TileState.INACTIVE_ANIMATING)
         {
            if(_loc2_ > this.detonateTime + EXPLODE_ANIMATION_DURATION)
            {
               this._state = TileState.INACTIVE;
               this.manager.removeBomb(this);
               this.manager.removeExplodedBombAnimation(this);
               return false;
            }
            return true;
         }
         this.graphic.speedup = 1 + this.MAX_SPEEDUP * (_loc2_ - this.createTime) / (this.detonateTime - this.createTime);
         if(_loc2_ > this.detonateTime && this._state == TileState.ACTIVE)
         {
            this.graphic.speedup = 1;
            this.explode(this.detonateTime);
            return true;
         }
         if(this.flying == false)
         {
            return true;
         }
         var _loc3_:Number = this.graphic.x + this.flyVelocity * this.dx * param1;
         var _loc4_:Number = this.graphic.y + this.flyVelocity * this.dy * param1;
         if(this.dx == 1)
         {
            _loc5_ = Math.ceil(_loc3_);
         }
         else if(this.dx == -1)
         {
            _loc5_ = Math.floor(_loc3_);
         }
         else
         {
            _loc5_ = Math.round(_loc3_);
         }
         if(this.dy == 1)
         {
            _loc6_ = Math.ceil(_loc4_);
         }
         else if(this.dy == -1)
         {
            _loc6_ = Math.floor(_loc4_);
         }
         else
         {
            _loc6_ = Math.round(_loc4_);
         }
         var _loc7_:BlockTile = BaloonoGame.instance.mapManager.currentMap.blocks.get(_loc5_,_loc6_) as BlockTile;
         var _loc8_:Bomb = BaloonoGame.instance.mapManager.currentMap.bombs.get(_loc5_,_loc6_) as Bomb;
         if(_loc7_ || _loc8_ && _loc8_ != this)
         {
            trace("hit wall");
            this.flying = false;
            this.dx = 0;
            this.dy = 0;
            this.graphic.x = Math.round(this.graphic.x);
            this.graphic.y = Math.round(this.graphic.y);
         }
         var _loc9_:Array = BaloonoGame.instance.playerManager.activePlayers;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc11_ = _loc9_[_loc10_];
            if(_loc11_ != this.owner && _loc11_.graphicEntity)
            {
               _loc12_ = Math.abs(_loc11_.graphicEntity.x - _loc3_);
               _loc13_ = Math.abs(_loc11_.graphicEntity.y - _loc4_);
               if(_loc12_ < 1 && _loc13_ < 1)
               {
                  this.flying = false;
                  this.dx = 0;
                  this.dy = 0;
                  this.graphic.x = Math.round(this.graphic.x);
                  this.graphic.y = Math.round(this.graphic.y);
               }
            }
            _loc10_++;
         }
         if(this.flying)
         {
            this.graphic.x = _loc3_;
            this.graphic.y = _loc4_;
            if(_loc5_ != this.prevX || _loc6_ != this.prevY)
            {
               trace("flying set : prevX: " + this.prevX + " prevY: " + this.prevY + " to NULL");
               BaloonoGame.instance.mapManager.currentMap.bombs.set(this.prevX,this.prevY,NullTile.NULL_TILE);
               trace("flying set : curX: " + _loc5_ + " curY: " + _loc6_);
               BaloonoGame.instance.mapManager.currentMap.bombs.set(_loc5_,_loc6_,this);
            }
         }
         else
         {
            trace("eh?");
         }
         this.prevX = _loc5_;
         this.prevY = _loc6_;
         return true;
      }
      
      public function get graphicEntity() : GraphicEntity
      {
         return this.graphic;
      }
      
      public function explode(param1:uint) : void
      {
         if(this._state != TileState.ACTIVE)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.warn("Bomb: explode() called on already exploded bomb");
            }
            return;
         }
         this._state = TileState.INACTIVE_ANIMATING;
         this.detonateTime = param1;
         if(this.graphic)
         {
            this.graphic.playAnimation(this.EXPLODING_ASSET,0,param1);
         }
         if(this.manager)
         {
            this.manager.startBombExplosion(this,param1);
            this.manager.deregisterBomb(this);
         }
      }
      
      public function destroy() : void
      {
         this.owner = null;
         this.graphic.destroy();
         this.graphic = null;
         this.explosionEgg = null;
      }
   }
}
