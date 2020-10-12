package iilwygames.baloono.gameplay.bomb
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.types.IDestroyable;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.gameplay.Directions;
   import iilwygames.baloono.gameplay.IExplosion;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.ExplosionTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   
   public class Explosion implements IExplosion, IDestroyable
   {
      
      protected static const UPDATE_PRIORITY:int = 1;
       
      
      public var centerx:int;
      
      protected var timeBetweenExpansion:uint = 0;
      
      public var tiles:Array;
      
      protected var endTime:uint;
      
      public var centery:int;
      
      protected var holdTime:uint = 1000;
      
      protected var startTime:uint;
      
      protected var map:MapModel;
      
      public var endLength:int;
      
      protected var activelyExpandingDirections:uint;
      
      public var parentBomb:Bomb;
      
      public var markedForRemoval:Boolean;
      
      protected var owner:IPlayer;
      
      private var _active:Boolean = false;
      
      private var _debugSuddenDeath:Boolean = false;
      
      protected var lastExpansionTime:uint;
      
      protected var currentLength:int;
      
      public function Explosion(param1:IPlayer, param2:int, param3:uint, param4:uint, param5:Bomb)
      {
         this.tiles = [];
         super();
         this.owner = param1;
         this.endLength = param2;
         this.holdTime = param3;
         this.timeBetweenExpansion = param4;
         this.parentBomb = param5;
         this.initialize();
      }
      
      public function destroy() : void
      {
         var _loc1_:ExplosionTile = null;
         for each(_loc1_ in this.tiles)
         {
            _loc1_.deregisterOccupyingExplosion(this);
            if(_loc1_.empty)
            {
               if(_loc1_.isActive)
               {
                  _loc1_.reset();
                  BaloonoGame.instance.explosionManager.returnExplosionTile(_loc1_);
               }
            }
         }
         this.owner = null;
         this._active = false;
         this.tiles = null;
         this.parentBomb = null;
         this.map = null;
      }
      
      public function startExplosion(param1:uint, param2:int, param3:int) : void
      {
         this._active = true;
         this.activelyExpandingDirections = Directions.COMBINED;
         this.currentLength = 0;
         this.centerx = param2;
         this.centery = param3;
         this.startTime = this.lastExpansionTime = param1;
         if(this.tiles.length > 0)
         {
            this.tiles.splice(0);
         }
         var _loc4_:ExplosionTile = this.map.explosions.get(this.centerx,this.centery) as ExplosionTile;
         if(!_loc4_)
         {
            _loc4_ = BaloonoGame.instance.explosionManager.getExplosionTile();
            _loc4_.setPosition(this.centerx,this.centery);
            this.map.explosions.set(this.centerx,this.centery,_loc4_);
         }
         var _loc5_:ExplosionDirection = new ExplosionDirection(Directions.COMBINED);
         this.tiles.push(_loc4_);
         _loc4_.registerOccupyingExplosion(this,_loc5_);
         BaloonoGame.instance.explosionManager.registerExplosion(this);
      }
      
      protected function finishExplosion() : void
      {
         var _loc1_:ExplosionTile = null;
         var _loc2_:ITileItem = null;
         for each(_loc1_ in this.tiles)
         {
            _loc1_.deregisterOccupyingExplosion(this);
            if(_loc1_.empty)
            {
               if(BaloonoGame.instance.mapView.grid2.USE_OLD_LAUNDRY == false)
               {
                  BaloonoGame.instance.mapView.grid2.setTileAsDirty(_loc1_);
               }
               this.map.explosions.set(int(_loc1_.graphicEntity.x),int(_loc1_.graphicEntity.y),NullTile.NULL_TILE);
               _loc2_ = this.map.blocks.get(int(_loc1_.graphicEntity.x),int(_loc1_.graphicEntity.y));
               if(_loc2_ && _loc2_ is BlockTile && (_loc2_ as BlockTile).breakable)
               {
                  this.map.blocks.set(int(_loc1_.graphicEntity.x),int(_loc1_.graphicEntity.y),NullTile.NULL_TILE);
               }
            }
         }
         this._active = false;
         this.markedForRemoval = true;
      }
      
      protected function initialize() : void
      {
         this.map = BaloonoGame.instance.mapManager.currentMap;
         this._active = false;
         this.markedForRemoval = false;
      }
      
      public function update(param1:CoreGameEvent) : void
      {
         if(!this._active)
         {
            return;
         }
         var _loc2_:uint = BaloonoGame.time;
         if(_loc2_ < this.startTime)
         {
            return;
         }
         while(this.lastExpansionTime + this.timeBetweenExpansion <= _loc2_ && this.currentLength < this.endLength)
         {
            this.expand(this.lastExpansionTime + this.timeBetweenExpansion);
         }
         if(this.currentLength == this.endLength && _loc2_ - this.lastExpansionTime > this.holdTime)
         {
            this.finishExplosion();
         }
      }
      
      protected function expand(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:BlockTile = null;
         var _loc7_:Bomb = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:ExplosionTile = null;
         var _loc15_:ExplosionDirection = null;
         var _loc16_:ExplosionTile = null;
         var _loc17_:ExplosionDirection = null;
         if(this.currentLength >= this.endLength)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("Explosion was asked to expand but can\'t");
            }
            return;
         }
         this.lastExpansionTime = param1;
         this.currentLength++;
         for each(_loc4_ in Directions.ALL_ARRAY)
         {
            if((this.activelyExpandingDirections & _loc4_) != 0)
            {
               _loc2_ = this.centerx + Directions.toDx(_loc4_) * this.currentLength;
               _loc3_ = this.centery + Directions.toDy(_loc4_) * this.currentLength;
               _loc5_ = this.map.isInBounds(_loc2_,_loc3_);
               _loc6_ = !!_loc5_?this.map.blocks.get(_loc2_,_loc3_) as BlockTile:null;
               if(!_loc5_ || _loc6_)
               {
                  if(_loc6_ && _loc6_.breakable)
                  {
                     _loc6_.destroyBlock(param1);
                     _loc8_ = Directions.toDx(_loc4_);
                     _loc9_ = Directions.toDy(_loc4_);
                     if(_loc8_ == -1)
                     {
                        BaloonoGame.instance.screen.psystem.makeSplash((_loc2_ - _loc8_) * BaloonoGame.instance.mapView.tileWidth,(_loc3_ + 0.5) * BaloonoGame.instance.mapView.tileHeight,_loc8_,_loc9_);
                     }
                     else if(_loc8_ == 1)
                     {
                        BaloonoGame.instance.screen.psystem.makeSplash(_loc2_ * BaloonoGame.instance.mapView.tileWidth,(_loc3_ + 0.5) * BaloonoGame.instance.mapView.tileHeight,_loc8_,_loc9_);
                     }
                     if(_loc9_ == -1)
                     {
                        BaloonoGame.instance.screen.psystem.makeSplash((_loc2_ + 0.5) * BaloonoGame.instance.mapView.tileWidth,(_loc3_ - _loc9_) * BaloonoGame.instance.mapView.tileHeight,_loc8_,_loc9_);
                     }
                     else if(_loc9_ == 1)
                     {
                        BaloonoGame.instance.screen.psystem.makeSplash((_loc2_ + 0.5) * BaloonoGame.instance.mapView.tileWidth,_loc3_ * BaloonoGame.instance.mapView.tileHeight,_loc8_,_loc9_);
                     }
                     this.activelyExpandingDirections = this.activelyExpandingDirections & ~_loc4_;
                     if(this._debugSuddenDeath)
                     {
                        _loc10_ = this.map.blocks.getArray();
                        _loc11_ = 0;
                        while(_loc11_ < _loc10_.length)
                        {
                           _loc6_ = _loc10_[_loc11_] as BlockTile;
                           if(_loc6_ && _loc6_.breakable)
                           {
                              _loc6_.destroyBlock(param1);
                           }
                           _loc11_++;
                        }
                     }
                  }
                  else
                  {
                     this.activelyExpandingDirections = this.activelyExpandingDirections & ~_loc4_;
                     if(this.currentLength > 1)
                     {
                        _loc12_ = _loc2_ - Directions.toDx(_loc4_);
                        _loc13_ = _loc3_ - Directions.toDy(_loc4_);
                        _loc14_ = this.map.explosions.get(_loc2_ - Directions.toDx(_loc4_),_loc3_ - Directions.toDy(_loc4_)) as ExplosionTile;
                        if(_loc14_ == null)
                        {
                           if(BaloonoGame.instance.DEBUG_LOGGING)
                           {
                              Console.error("Missing explosion when trying to convert prior explosion bit into cap");
                           }
                           continue;
                        }
                        _loc15_ = new ExplosionDirection(_loc4_);
                        _loc14_.registerOccupyingExplosion(this,_loc15_);
                     }
                  }
               }
               else
               {
                  _loc16_ = this.map.explosions.get(_loc2_,_loc3_) as ExplosionTile;
                  if(!_loc16_)
                  {
                     _loc16_ = BaloonoGame.instance.explosionManager.getExplosionTile();
                     _loc16_.setPosition(_loc2_,_loc3_);
                     this.map.explosions.set(_loc2_,_loc3_,_loc16_);
                  }
                  _loc17_ = new ExplosionDirection(_loc4_);
                  if(this.currentLength != this.endLength)
                  {
                     _loc17_.coverBothDirectionsInAxis();
                  }
                  this.tiles.push(_loc16_);
                  _loc16_.registerOccupyingExplosion(this,_loc17_);
               }
               _loc7_ = null;
               if(this.map.isInBounds(_loc2_,_loc3_))
               {
                  _loc7_ = this.map.bombs.get(_loc2_,_loc3_) as Bomb;
               }
               if(_loc7_)
               {
                  if(!_loc7_.flying)
                  {
                     _loc7_.explode(param1);
                  }
               }
            }
         }
      }
   }
}
