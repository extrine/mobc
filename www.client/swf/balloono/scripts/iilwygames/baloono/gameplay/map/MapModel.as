package iilwygames.baloono.gameplay.map
{
   import de.polygonal.ds.Array2;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.bomb.Bomb;
   import iilwygames.baloono.gameplay.bomb.Explosion;
   import iilwygames.baloono.gameplay.tiles.AbstractTile;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   
   public class MapModel
   {
       
      
      public var explosions:Array2;
      
      public var blocks:Array2;
      
      public var ground:Array2;
      
      protected var ALL_GRIDS:Array;
      
      public var bombs:Array2;
      
      public var powerups:Array2;
      
      public function MapModel()
      {
         super();
         this.initialize();
      }
      
      public function isInBounds(param1:int, param2:int) : Boolean
      {
         return param1 >= 0 && param1 < this.width && param2 >= 0 && param2 < this.height;
      }
      
      function clearMap() : void
      {
         var _loc1_:Array2 = null;
         for each(_loc1_ in this.ALL_GRIDS)
         {
            _loc1_.clear();
         }
      }
      
      public function getNumberOfBreakableBlocks() : int
      {
         var _loc3_:int = 0;
         var _loc4_:AbstractTile = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.height)
         {
            _loc3_ = 0;
            while(_loc3_ < this.width)
            {
               if(this.blocks.get(_loc3_,_loc2_) != NullTile.NULL_TILE)
               {
                  _loc4_ = this.blocks.get(_loc3_,_loc2_);
                  if(_loc4_ is BlockTile && (_loc4_ as BlockTile).breakable && _loc4_.state.active)
                  {
                     _loc1_++;
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function initialize() : void
      {
         this.ground = new Array2(0,0);
         this.blocks = new Array2(0,0);
         this.explosions = new Array2(0,0);
         this.powerups = new Array2(0,0);
         this.bombs = new Array2(0,0);
         this.ALL_GRIDS = [this.ground,this.blocks,this.explosions,this.powerups,this.bombs];
      }
      
      public function get width() : int
      {
         return this.ground.width;
      }
      
      public function get height() : int
      {
         return this.ground.height;
      }
      
      public function getExistArray() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:BlockTile = null;
         var _loc7_:AbstractTile = null;
         var _loc8_:Bomb = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Explosion = null;
         var _loc1_:Array = new Array(this.blocks.getArray().length);
         var _loc4_:int = this.width;
         var _loc5_:int = this.height;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               if(this.blocks.get(_loc2_,_loc3_) != NullTile.NULL_TILE)
               {
                  _loc7_ = this.blocks.get(_loc2_,_loc3_);
                  if(_loc7_ is BlockTile)
                  {
                     _loc1_[_loc3_ * _loc4_ + _loc2_] = true;
                  }
                  else
                  {
                     _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                  }
               }
               else
               {
                  _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
               }
               _loc2_++;
            }
            _loc3_++;
         }
         if(BaloonoGame.instance.bombManager.bombs)
         {
            for each(_loc8_ in BaloonoGame.instance.bombManager.bombs)
            {
               if(_loc8_.state == TileState.ACTIVE)
               {
                  _loc9_ = _loc8_.graphicEntity.x;
                  _loc10_ = _loc8_.graphicEntity.y;
                  _loc11_ = _loc8_.explosionEgg.endLength;
                  _loc2_ = _loc9_;
                  _loc3_ = _loc10_;
                  while(_loc2_ >= 0 && _loc2_ >= _loc9_ - _loc11_)
                  {
                     if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                     {
                        _loc6_ = this.blocks.get(_loc2_,_loc3_);
                        if(_loc6_.breakable)
                        {
                           _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                           break;
                        }
                        break;
                     }
                     _loc2_--;
                  }
                  _loc2_ = _loc9_;
                  while(_loc2_ < this.width && _loc2_ <= _loc9_ + _loc11_)
                  {
                     if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                     {
                        _loc6_ = this.blocks.get(_loc2_,_loc3_);
                        if(_loc6_.breakable)
                        {
                           _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                           break;
                        }
                        break;
                     }
                     _loc2_++;
                  }
                  _loc2_ = _loc9_;
                  while(_loc3_ >= 0 && _loc3_ >= _loc10_ - _loc11_)
                  {
                     if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                     {
                        _loc6_ = this.blocks.get(_loc2_,_loc3_);
                        if(_loc6_.breakable)
                        {
                           _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                           break;
                        }
                        break;
                     }
                     _loc3_--;
                  }
                  _loc3_ = _loc10_;
                  while(_loc3_ < this.height && _loc3_ <= _loc10_ + _loc11_)
                  {
                     if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                     {
                        _loc6_ = this.blocks.get(_loc2_,_loc3_);
                        if(_loc6_.breakable)
                        {
                           _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                           break;
                        }
                        break;
                     }
                     _loc3_++;
                  }
               }
            }
         }
         if(BaloonoGame.instance.explosionManager)
         {
            for each(_loc12_ in BaloonoGame.instance.explosionManager.explosions)
            {
               _loc9_ = _loc12_.centerx;
               _loc10_ = _loc12_.centery;
               _loc11_ = _loc12_.endLength;
               _loc2_ = _loc9_;
               _loc3_ = _loc10_;
               while(_loc2_ >= 0 && _loc2_ >= _loc9_ - _loc11_)
               {
                  if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                  {
                     _loc6_ = this.blocks.get(_loc2_,_loc3_);
                     if(_loc6_.breakable)
                     {
                        _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                        break;
                     }
                     break;
                  }
                  _loc2_--;
               }
               _loc2_ = _loc9_;
               while(_loc2_ < this.width && _loc2_ <= _loc9_ + _loc11_)
               {
                  if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                  {
                     _loc6_ = this.blocks.get(_loc2_,_loc3_);
                     if(_loc6_.breakable)
                     {
                        _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                        break;
                     }
                     break;
                  }
                  _loc2_++;
               }
               _loc2_ = _loc9_;
               while(_loc3_ >= 0 && _loc3_ >= _loc10_ - _loc11_)
               {
                  if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                  {
                     _loc6_ = this.blocks.get(_loc2_,_loc3_);
                     if(_loc6_.breakable)
                     {
                        _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                        break;
                     }
                     break;
                  }
                  _loc3_--;
               }
               _loc3_ = _loc10_;
               while(_loc3_ < this.height && _loc3_ <= _loc10_ + _loc11_)
               {
                  if(_loc1_[_loc3_ * _loc4_ + _loc2_])
                  {
                     _loc6_ = this.blocks.get(_loc2_,_loc3_);
                     if(_loc6_.breakable)
                     {
                        _loc1_[_loc3_ * _loc4_ + _loc2_] = false;
                        break;
                     }
                     break;
                  }
                  _loc3_++;
               }
            }
         }
         return _loc1_;
      }
      
      function resizeArrays(param1:int, param2:int) : void
      {
         var _loc3_:Array2 = null;
         for each(_loc3_ in this.ALL_GRIDS)
         {
            _loc3_.resize(param1,param2);
         }
      }
   }
}
