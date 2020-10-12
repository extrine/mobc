package iilwygames.baloono.graphics2
{
   import de.polygonal.ds.Array2;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.map.MapView;
   import iilwygames.baloono.gameplay.player.NullPlayer;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.GraphicEntity;
   
   public class DirtyRectRender extends Sprite
   {
      
      private static const USE_RECTANGLE_POOL:Boolean = true;
       
      
      public var USE_BITMAP_PARTITIONS:Boolean = true;
      
      protected var tileRec:Rectangle;
      
      public var canvasBitMap:Bitmap;
      
      private var test:Vector.<ITileItem>;
      
      public var canvasBDQuads:Vector.<BitmapData>;
      
      public var canvasBD:BitmapData;
      
      private var lists:Vector.<Array2>;
      
      protected var destPoint:Point;
      
      private var _rectanglePool:Array;
      
      public var groundPrerender:BitmapData;
      
      public var canvasBitMapQuads:Vector.<Bitmap>;
      
      private var _height:Number;
      
      private var _width:Number;
      
      protected var tileH:Number;
      
      private var _MAX_RECTANGLES:int = 50;
      
      protected var tileW:Number;
      
      public var dirtyLaundry:Vector.<Rectangle>;
      
      public var USE_OLD_LAUNDRY:Boolean = false;
      
      public var bufferBitMap:BitmapData;
      
      private var _groundRendered:Boolean = false;
      
      public var oldLaundry:Vector.<Rectangle>;
      
      public function DirtyRectRender()
      {
         var _loc1_:int = 0;
         this._rectanglePool = [];
         super();
         this.canvasBD = null;
         this.dirtyLaundry = new Vector.<Rectangle>();
         this.oldLaundry = new Vector.<Rectangle>();
         this.test = new Vector.<ITileItem>();
         this.lists = new Vector.<Array2>();
         this.canvasBitMapQuads = new Vector.<Bitmap>();
         this.canvasBDQuads = new Vector.<BitmapData>();
         this._width = 0;
         this._height = 0;
         if(this.USE_BITMAP_PARTITIONS)
         {
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               this.canvasBitMapQuads[this.canvasBitMapQuads.length] = new Bitmap();
               this.addChild(this.canvasBitMapQuads[_loc1_]);
               _loc1_++;
            }
         }
         else
         {
            this.canvasBitMap = new Bitmap();
            this.addChild(this.canvasBitMap);
         }
         this.tileRec = new Rectangle();
         this.destPoint = new Point();
         if(USE_RECTANGLE_POOL)
         {
            _loc1_ = 0;
            while(_loc1_ < this._MAX_RECTANGLES)
            {
               this._rectanglePool[this._rectanglePool.length] = new Rectangle();
               _loc1_++;
            }
         }
      }
      
      public function setSize(param1:Number, param2:Number, param3:MapView, param4:MapModel) : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this._width = param1;
         this._height = param2;
         if(this.canvasBD)
         {
            this.canvasBD.dispose();
            this.canvasBD = null;
         }
         if(this.groundPrerender)
         {
            this.groundPrerender.dispose();
            this.groundPrerender = null;
         }
         if(this.bufferBitMap)
         {
            this.bufferBitMap.dispose();
            this.bufferBitMap = null;
         }
         if(this.canvasBDQuads.length > 0)
         {
            for each(_loc5_ in this.canvasBDQuads)
            {
               _loc5_.dispose();
            }
            this.canvasBDQuads.splice(0,this.canvasBDQuads.length);
         }
         if(this.USE_BITMAP_PARTITIONS)
         {
            param1 = param3.cachedWidth * 0.5;
            param2 = param3.cachedHeight * 0.5;
            _loc6_ = Math.floor(param1);
            _loc7_ = Math.ceil(param1);
            _loc8_ = Math.floor(param2);
            _loc9_ = Math.ceil(param2);
            this.canvasBDQuads[0] = new BitmapData(_loc6_,_loc8_,false);
            this.canvasBDQuads[1] = new BitmapData(_loc7_,_loc8_,false);
            this.canvasBDQuads[2] = new BitmapData(_loc6_,_loc9_,false);
            this.canvasBDQuads[3] = new BitmapData(_loc7_,_loc9_,false);
            _loc10_ = 0;
            while(_loc10_ < 4)
            {
               (this.canvasBitMapQuads[_loc10_] as Bitmap).bitmapData = this.canvasBDQuads[_loc10_];
               _loc10_++;
            }
            (this.canvasBitMapQuads[0] as Bitmap).x = 0;
            (this.canvasBitMapQuads[0] as Bitmap).y = 0;
            (this.canvasBitMapQuads[1] as Bitmap).x = _loc6_;
            (this.canvasBitMapQuads[1] as Bitmap).y = 0;
            (this.canvasBitMapQuads[2] as Bitmap).x = 0;
            (this.canvasBitMapQuads[2] as Bitmap).y = _loc8_;
            (this.canvasBitMapQuads[3] as Bitmap).x = _loc6_;
            (this.canvasBitMapQuads[3] as Bitmap).y = _loc8_;
         }
         else
         {
            this.canvasBD = new BitmapData(param3.cachedWidth,param3.cachedHeight,false);
            this.canvasBitMap.bitmapData = this.canvasBD;
         }
         this.groundPrerender = new BitmapData(param3.cachedWidth,param3.cachedHeight,false);
         this.bufferBitMap = new BitmapData(param3.cachedWidth,param3.cachedHeight,false);
         this._groundRendered = false;
         this.tileW = param3.tileWidth;
         this.tileH = param3.tileHeight;
         this.lists.splice(0,this.lists.length);
         this.lists.push(param4.powerups);
         this.lists.push(param4.explosions);
         this.lists.push(param4.bombs);
         this.lists.push(param4.blocks);
      }
      
      public function render(param1:Number) : void
      {
         var _loc8_:ITileItem = null;
         var _loc9_:BitmapData = null;
         var _loc14_:Rectangle = null;
         var _loc15_:Vector.<Rectangle> = null;
         var _loc16_:Rectangle = null;
         var _loc17_:Array2 = null;
         var _loc18_:Player = null;
         if(!this.canvasBD)
         {
            return;
         }
         if(this._groundRendered == false)
         {
            this.renderGround(param1);
         }
         if(this.dirtyLaundry.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         var _loc4_:int = _loc3_.height;
         var _loc5_:int = _loc3_.width;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.USE_OLD_LAUNDRY)
         {
            _loc15_ = this.dirtyLaundry.concat();
            for each(_loc16_ in this.oldLaundry)
            {
               this.combineDirtyRects(_loc16_,false);
            }
            if(USE_RECTANGLE_POOL)
            {
               this.returnRectsToPoolFromArray(this.oldLaundry);
            }
            this.oldLaundry = _loc15_;
         }
         this.test.splice(0,this.test.length);
         var _loc10_:int = int.MAX_VALUE;
         var _loc11_:int = int.MAX_VALUE;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         this.bufferBitMap.lock();
         for each(_loc14_ in this.dirtyLaundry)
         {
            this.destPoint.x = _loc14_.x;
            this.destPoint.y = _loc14_.y;
            this.bufferBitMap.copyPixels(this.groundPrerender,_loc14_,this.destPoint);
            if(_loc14_.x < _loc10_)
            {
               _loc10_ = _loc14_.x;
            }
            if(_loc14_.y < _loc11_)
            {
               _loc11_ = _loc14_.y;
            }
            if(_loc14_.right > _loc12_)
            {
               _loc12_ = _loc14_.right;
            }
            if(_loc14_.bottom > _loc13_)
            {
               _loc13_ = _loc14_.bottom;
            }
         }
         for each(_loc14_ in this.dirtyLaundry)
         {
            _loc2_ = Math.floor(_loc14_.y / this.tileH);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            _loc6_ = _loc2_;
            while(_loc6_ < _loc4_)
            {
               for each(_loc17_ in this.lists)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc5_)
                  {
                     _loc8_ = _loc17_.get(_loc7_,_loc6_);
                     if(_loc8_ && !(_loc8_ is NullTile) && this.test.indexOf(_loc8_) == -1 && _loc8_.graphicEntity)
                     {
                        this.tileRec.x = _loc8_.graphicEntity.x * this.tileW;
                        this.tileRec.y = _loc8_.graphicEntity.y * this.tileH;
                        if(_loc8_.graphicEntity.activeAsset.drawOffset)
                        {
                           this.tileRec.x = this.tileRec.x - _loc8_.graphicEntity.activeAsset.drawOffset.x;
                           this.tileRec.y = this.tileRec.y - _loc8_.graphicEntity.activeAsset.drawOffset.y;
                        }
                        this.tileRec.width = _loc8_.graphicEntity.bitMapData.width;
                        this.tileRec.height = _loc8_.graphicEntity.bitMapData.height;
                        if(this.RectangleCollide(_loc14_,this.tileRec))
                        {
                           _loc9_ = _loc8_.graphicEntity.bitMapData;
                           this.destPoint.x = this.tileRec.x;
                           this.destPoint.y = this.tileRec.y;
                           this.tileRec.x = 0;
                           this.tileRec.y = 0;
                           this.bufferBitMap.copyPixels(_loc9_,this.tileRec,this.destPoint);
                           this.test[this.test.length] = _loc8_;
                        }
                     }
                     _loc7_++;
                  }
               }
               for each(_loc18_ in BaloonoGame.instance.playerManager.activePlayers)
               {
                  if(!(_loc18_ is NullPlayer || _loc18_.state == TileState.INACTIVE || !_loc18_.graphicEntity || Math.round(_loc18_.graphicEntity.y) != _loc6_))
                  {
                     this.tileRec.x = _loc18_.graphicEntity.x * this.tileW;
                     this.tileRec.y = _loc18_.graphicEntity.y * this.tileH;
                     if(_loc18_.graphicEntity.activeAsset.drawOffset)
                     {
                        this.tileRec.x = this.tileRec.x - _loc18_.graphicEntity.activeAsset.drawOffset.x;
                        this.tileRec.y = this.tileRec.y - _loc18_.graphicEntity.activeAsset.drawOffset.y;
                     }
                     this.tileRec.width = _loc18_.graphicEntity.bitMapData.width;
                     this.tileRec.height = _loc18_.graphicEntity.bitMapData.height;
                     if(this.RectangleCollide(_loc14_,this.tileRec))
                     {
                        _loc9_ = _loc18_.graphicEntity.bitMapData;
                        this.destPoint.x = this.tileRec.x;
                        this.destPoint.y = this.tileRec.y;
                        this.tileRec.x = 0;
                        this.tileRec.y = 0;
                        this.bufferBitMap.copyPixels(_loc9_,this.tileRec,this.destPoint);
                     }
                  }
               }
               _loc6_++;
            }
         }
         this.tileRec.x = _loc10_;
         this.tileRec.y = _loc11_;
         this.tileRec.width = _loc12_ - _loc10_;
         this.tileRec.height = _loc13_ - _loc11_;
         this.bufferBitMap.unlock(this.tileRec);
         this.canvasBD.lock();
         for each(_loc14_ in this.dirtyLaundry)
         {
            this.destPoint.x = _loc14_.x;
            this.destPoint.y = _loc14_.y;
            this.canvasBD.copyPixels(this.bufferBitMap,_loc14_,this.destPoint);
         }
         this.canvasBD.unlock(this.tileRec);
         if(this.USE_OLD_LAUNDRY)
         {
            this.dirtyLaundry.splice(0,this.dirtyLaundry.length);
         }
         else
         {
            this.returnRectsToPoolFromArray(this.dirtyLaundry);
         }
      }
      
      private function returnRectsToPoolFromArray(param1:Vector.<Rectangle>) : void
      {
         while(param1.length > 0)
         {
            this._rectanglePool[this._rectanglePool.length] = param1.pop();
         }
      }
      
      private function returnRectangleToPool(param1:Rectangle) : void
      {
         this._rectanglePool[this._rectanglePool.length] = param1;
      }
      
      public function renderGround(param1:Number) : void
      {
         var _loc3_:GraphicEntity = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ITileItem = null;
         var _loc2_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(this._groundRendered == false)
         {
            this._groundRendered = true;
            this.groundPrerender.lock();
            _loc7_ = 0;
            while(_loc7_ < _loc2_.ground.height)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc2_.ground.width)
               {
                  _loc9_ = _loc2_.ground.get(_loc8_,_loc7_);
                  _loc3_ = _loc9_.graphicEntity;
                  _loc6_ = _loc3_.bitMapData;
                  _loc4_ = 0;
                  _loc5_ = 0;
                  if(_loc3_.activeAsset.drawOffset)
                  {
                     _loc4_ = _loc3_.activeAsset.drawOffset.x;
                     _loc5_ = _loc3_.activeAsset.drawOffset.y;
                  }
                  this.groundPrerender.copyPixels(_loc6_,new Rectangle(0,0,_loc3_.bitMapData.width,_loc3_.bitMapData.height),new Point(_loc8_ * this.tileW - _loc4_,_loc7_ * this.tileH - _loc5_),null,null,false);
                  _loc8_++;
               }
               _loc7_++;
            }
            this.groundPrerender.unlock();
         }
      }
      
      private function getRectangleFromPool() : Rectangle
      {
         if(this._rectanglePool.length > 0)
         {
            return this._rectanglePool.pop();
         }
         trace("ran out of rectangles in the pool!");
         return null;
      }
      
      public function render2(param1:Number) : void
      {
         var _loc12_:ITileItem = null;
         var _loc13_:BitmapData = null;
         var _loc18_:Rectangle = null;
         var _loc20_:Vector.<Rectangle> = null;
         var _loc21_:Rectangle = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:Array2 = null;
         var _loc25_:Player = null;
         var _loc26_:Bitmap = null;
         var _loc27_:Boolean = false;
         if(!this.canvasBD && !this.canvasBitMapQuads && this.canvasBitMapQuads.length == 0)
         {
            return;
         }
         var _loc2_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(!_loc2_)
         {
            return;
         }
         if(this._groundRendered == false)
         {
            this.renderGround(param1);
         }
         if(this.dirtyLaundry.length == 0)
         {
            return;
         }
         var _loc4_:int = _loc2_.height;
         var _loc5_:int = _loc2_.width;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = this.lists.length;
         if(this.USE_OLD_LAUNDRY)
         {
            _loc20_ = this.dirtyLaundry.concat();
            for each(_loc21_ in this.oldLaundry)
            {
               this.combineDirtyRects(_loc21_,false);
            }
            if(USE_RECTANGLE_POOL)
            {
               this.returnRectsToPoolFromArray(this.oldLaundry);
            }
            this.oldLaundry = _loc20_;
         }
         this.test.splice(0,this.test.length);
         this.bufferBitMap.lock();
         var _loc14_:int = int.MAX_VALUE;
         var _loc15_:int = int.MAX_VALUE;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         _loc9_ = this.dirtyLaundry.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc18_ = this.dirtyLaundry[_loc8_];
            this.destPoint.x = _loc18_.x;
            this.destPoint.y = _loc18_.y;
            this.bufferBitMap.copyPixels(this.groundPrerender,_loc18_,this.destPoint);
            if(_loc18_.x < _loc14_)
            {
               _loc14_ = _loc18_.x;
            }
            if(_loc18_.y < _loc15_)
            {
               _loc15_ = _loc18_.y;
            }
            if(_loc18_.right > _loc16_)
            {
               _loc16_ = _loc18_.right;
            }
            if(_loc18_.bottom > _loc17_)
            {
               _loc17_ = _loc18_.bottom;
            }
            _loc8_++;
         }
         var _loc19_:GraphicEntity = null;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc24_ = this.lists[_loc10_];
               _loc7_ = 0;
               while(_loc7_ < _loc5_)
               {
                  _loc12_ = _loc24_.get(_loc7_,_loc6_);
                  if(!(_loc12_ is NullTile))
                  {
                     if(_loc12_)
                     {
                        _loc19_ = _loc12_.graphicEntity;
                     }
                     _loc8_ = 0;
                     while(_loc8_ < _loc9_)
                     {
                        _loc18_ = this.dirtyLaundry[_loc8_];
                        if(_loc12_ && !(_loc12_ is NullTile) && this.test.indexOf(_loc12_) == -1 && _loc19_)
                        {
                           this.tileRec.x = _loc19_.x * this.tileW;
                           this.tileRec.y = _loc19_.y * this.tileH;
                           if(_loc19_.activeAsset.drawOffset)
                           {
                              this.tileRec.x = this.tileRec.x - _loc19_.activeAsset.drawOffset.x;
                              this.tileRec.y = this.tileRec.y - _loc19_.activeAsset.drawOffset.y;
                           }
                           this.tileRec.width = _loc19_.bitMapData.width;
                           this.tileRec.height = _loc19_.bitMapData.height;
                           if(this.RectangleCollide(_loc18_,this.tileRec))
                           {
                              _loc13_ = _loc19_.bitMapData;
                              this.destPoint.x = this.tileRec.x;
                              this.destPoint.y = this.tileRec.y;
                              this.tileRec.x = 0;
                              this.tileRec.y = 0;
                              this.bufferBitMap.copyPixels(_loc13_,this.tileRec,this.destPoint);
                              this.test[this.test.length] = _loc12_;
                           }
                        }
                        _loc8_++;
                     }
                  }
                  _loc7_++;
               }
               _loc10_++;
            }
            if(BaloonoGame.instance.playerManager.activePlayers != null)
            {
               _loc22_ = BaloonoGame.instance.playerManager.activePlayers.length;
               _loc23_ = 0;
               while(_loc23_ < _loc22_)
               {
                  _loc25_ = BaloonoGame.instance.playerManager.activePlayers[_loc23_];
                  _loc19_ = _loc25_.graphicEntity;
                  if(!(_loc25_ is NullPlayer || _loc19_ == null))
                  {
                     if(_loc25_.state != TileState.INACTIVE)
                     {
                        if(Math.round(_loc19_.y) == _loc6_)
                        {
                           _loc8_ = 0;
                           while(_loc8_ < _loc9_)
                           {
                              _loc18_ = this.dirtyLaundry[_loc8_];
                              this.tileRec.x = _loc19_.x * this.tileW;
                              this.tileRec.y = _loc19_.y * this.tileH;
                              if(_loc19_.activeAsset.drawOffset)
                              {
                                 this.tileRec.x = this.tileRec.x - _loc19_.activeAsset.drawOffset.x;
                                 this.tileRec.y = this.tileRec.y - _loc19_.activeAsset.drawOffset.y;
                              }
                              this.tileRec.width = _loc19_.bitMapData.width;
                              this.tileRec.height = _loc19_.bitMapData.height;
                              if(this.RectangleCollide(_loc18_,this.tileRec))
                              {
                                 _loc13_ = _loc19_.bitMapData;
                                 this.destPoint.x = this.tileRec.x;
                                 this.destPoint.y = this.tileRec.y;
                                 this.tileRec.x = 0;
                                 this.tileRec.y = 0;
                                 this.bufferBitMap.copyPixels(_loc13_,this.tileRec,this.destPoint);
                              }
                              _loc8_++;
                           }
                        }
                     }
                  }
                  _loc23_++;
               }
            }
            _loc6_++;
         }
         this.tileRec.x = _loc14_;
         this.tileRec.y = _loc15_;
         this.tileRec.width = _loc16_ - _loc14_;
         this.tileRec.height = _loc17_ - _loc15_;
         this.bufferBitMap.unlock(this.tileRec);
         if(!this.USE_BITMAP_PARTITIONS)
         {
            this.canvasBD.lock();
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc18_ = this.dirtyLaundry[_loc8_];
               this.destPoint.x = _loc18_.x;
               this.destPoint.y = _loc18_.y;
               this.canvasBD.copyPixels(this.bufferBitMap,_loc18_,this.destPoint);
               _loc8_++;
            }
            this.canvasBD.unlock(this.tileRec);
         }
         else
         {
            _loc10_ = 0;
            while(_loc10_ < 4)
            {
               _loc26_ = this.canvasBitMapQuads[_loc10_];
               _loc27_ = false;
               _loc14_ = int.MAX_VALUE;
               _loc15_ = int.MAX_VALUE;
               _loc16_ = 0;
               _loc17_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  _loc18_ = this.dirtyLaundry[_loc8_];
                  if(this.RectangleCollide(_loc18_,_loc26_.getRect(this)))
                  {
                     if(!_loc27_)
                     {
                        _loc26_.bitmapData.lock();
                        _loc27_ = true;
                     }
                     this.destPoint.x = _loc18_.x - _loc26_.x;
                     this.destPoint.y = _loc18_.y - _loc26_.y;
                     _loc26_.bitmapData.copyPixels(this.bufferBitMap,_loc18_,this.destPoint);
                     if(this.destPoint.x < _loc14_)
                     {
                        _loc14_ = this.destPoint.x;
                     }
                     if(this.destPoint.y < _loc15_)
                     {
                        _loc15_ = this.destPoint.y;
                     }
                     if(this.destPoint.x + _loc18_.width > _loc16_)
                     {
                        _loc16_ = this.destPoint.x + _loc18_.width;
                     }
                     if(this.destPoint.y + _loc18_.height > _loc17_)
                     {
                        _loc17_ = this.destPoint.y + _loc18_.height;
                     }
                  }
                  _loc8_++;
               }
               if(_loc27_)
               {
                  this.tileRec.x = _loc14_;
                  this.tileRec.y = _loc15_;
                  this.tileRec.width = _loc16_ - _loc14_;
                  this.tileRec.height = _loc17_ - _loc15_;
                  _loc26_.bitmapData.unlock(this.tileRec);
               }
               _loc10_++;
            }
         }
         if(this.USE_OLD_LAUNDRY)
         {
            this.dirtyLaundry.splice(0,this.dirtyLaundry.length);
         }
         else
         {
            this.returnRectsToPoolFromArray(this.dirtyLaundry);
         }
      }
      
      private function RectangleCollide(param1:Rectangle, param2:Rectangle) : Boolean
      {
         if(param1.right < param2.left)
         {
            return false;
         }
         if(param1.left > param2.right)
         {
            return false;
         }
         if(param1.top > param2.bottom)
         {
            return false;
         }
         if(param1.bottom < param2.top)
         {
            return false;
         }
         return true;
      }
      
      public function setTileAsDirty(param1:ITileItem, param2:Boolean = false) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var ox:Number = NaN;
         var oy:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var rect:Rectangle = null;
         var savex:Number = NaN;
         var savey:Number = NaN;
         var saveox:Number = NaN;
         var saveoy:Number = NaN;
         var savew:Number = NaN;
         var saveh:Number = NaN;
         var rect_prev:Rectangle = null;
         var tile:ITileItem = param1;
         var addBuffer:Boolean = param2;
         if(!tile || !tile.graphicEntity || !tile.graphicEntity.bitMapData)
         {
            return;
         }
         try
         {
            x = tile.graphicEntity.x;
            y = tile.graphicEntity.y;
            ox = 0;
            oy = 0;
            if(tile.graphicEntity.activeAsset.drawOffset)
            {
               ox = tile.graphicEntity.activeAsset.drawOffset.x;
               oy = tile.graphicEntity.activeAsset.drawOffset.y;
            }
            if(tile.graphicEntity.bitMapData)
            {
               w = tile.graphicEntity.bitMapData.width;
               h = tile.graphicEntity.bitMapData.height;
               if(addBuffer)
               {
                  savex = x;
                  savey = y;
                  saveox = ox;
                  saveoy = oy;
                  savew = w;
                  saveh = h;
                  if(USE_RECTANGLE_POOL)
                  {
                     rect = this.getRectangleFromPool();
                     rect.x = int(x * this.tileW - ox);
                     rect.y = int(y * this.tileH - oy);
                     rect.width = w + 1;
                     rect.height = h + 1;
                  }
                  else
                  {
                     rect = new Rectangle(Math.floor(x * this.tileW - ox),Math.floor(y * this.tileH - oy),w + 1,h + 1);
                  }
                  x = tile.graphicEntity.lastX;
                  y = tile.graphicEntity.lastY;
                  w = tile.graphicEntity.lastW;
                  h = tile.graphicEntity.lastH;
                  ox = tile.graphicEntity.lastOffsetX;
                  oy = tile.graphicEntity.lastOffsetY;
                  if(w != 0 || h != 0)
                  {
                     if(USE_RECTANGLE_POOL)
                     {
                        rect_prev = this.getRectangleFromPool();
                        rect_prev.x = int(x * this.tileW - ox);
                        rect_prev.y = int(y * this.tileH - oy);
                        rect_prev.width = w + 1;
                        rect_prev.height = h + 1;
                     }
                     else
                     {
                        rect_prev = new Rectangle(int(x * this.tileW - ox),int(y * this.tileH - oy),w,h);
                     }
                     this.combineDirtyRects(rect_prev);
                  }
                  tile.graphicEntity.lastX = savex;
                  tile.graphicEntity.lastY = savey;
                  tile.graphicEntity.lastOffsetX = saveox;
                  tile.graphicEntity.lastOffsetY = saveoy;
                  tile.graphicEntity.lastW = savew;
                  tile.graphicEntity.lastH = saveh;
               }
               else if(USE_RECTANGLE_POOL)
               {
                  rect = this.getRectangleFromPool();
                  rect.x = x * this.tileW - ox;
                  rect.y = y * this.tileH - oy;
                  rect.width = w;
                  rect.height = h;
               }
               else
               {
                  rect = new Rectangle(x * this.tileW - ox,y * this.tileH - oy,w,h);
               }
               this.combineDirtyRects(rect);
            }
            return;
         }
         catch(error:Error)
         {
            trace("There was an error trying to set a Dirty Tile!");
            return;
         }
      }
      
      public function combineDirtyRects(param1:Rectangle = null, param2:Boolean = true) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1)
         {
            this.dirtyLaundry[this.dirtyLaundry.length] = param1;
         }
         while(_loc3_ < this.dirtyLaundry.length)
         {
            _loc5_ = this.dirtyLaundry[_loc3_];
            _loc4_ = _loc3_ + 1;
            while(_loc4_ < this.dirtyLaundry.length)
            {
               _loc6_ = this.dirtyLaundry[_loc4_];
               if(this.RectangleCollide(_loc5_,_loc6_))
               {
                  _loc7_ = _loc5_.x < _loc6_.x?int(_loc5_.x):int(_loc6_.x);
                  _loc8_ = _loc5_.y < _loc6_.y?int(_loc5_.y):int(_loc6_.y);
                  _loc6_.width = Math.ceil((_loc5_.right > _loc6_.right?_loc5_.right:_loc6_.right) - _loc7_);
                  _loc6_.height = Math.ceil((_loc5_.bottom > _loc6_.bottom?_loc5_.bottom:_loc6_.bottom) - _loc8_);
                  _loc6_.x = _loc7_;
                  _loc6_.y = _loc8_;
                  if(param2 && USE_RECTANGLE_POOL)
                  {
                     this.returnRectangleToPool(this.dirtyLaundry.splice(_loc3_,1)[0]);
                  }
                  else
                  {
                     this.dirtyLaundry.splice(_loc3_,1);
                  }
                  _loc3_--;
                  break;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
   }
}
