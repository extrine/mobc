package iilwygames.baloono.gameplay.map
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.display.DisplayUtilities;
   import de.polygonal.ds.Array2;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.bomb.Bomb;
   import iilwygames.baloono.gameplay.player.NullPlayer;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.tiles.ExplosionTile;
   import iilwygames.baloono.gameplay.tiles.GroundTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.IDrawable;
   import iilwygames.baloono.graphics.IResizable;
   import iilwygames.baloono.graphics2.DirtyRectRender;
   
   public class MapView implements IDrawable, IResizable
   {
      
      protected static const MIN_ACCEPTABLE_TILE_SIZE:int = 5;
       
      
      public var test:Boolean = false;
      
      protected var groundLayerStatic:Boolean;
      
      protected var depthsPerColumn:int;
      
      protected var height:int;
      
      public var grid2:DirtyRectRender;
      
      protected var depthsPerRow:int;
      
      protected var debugLayer:Sprite;
      
      public var tileWidth:int;
      
      protected var width:int;
      
      public var cachedWidth:Number = 0;
      
      protected var map:MapModel;
      
      protected var overlayLayer:Sprite;
      
      protected var root:Sprite;
      
      protected const DRAW_GRID:Boolean = false;
      
      public var cachedHeight:Number = 0;
      
      protected const DRAW_LABELS:Boolean = false;
      
      public var tileHeight:int;
      
      public function MapView()
      {
         super();
         this.initialize();
      }
      
      public function get size() : Rectangle
      {
         return new Rectangle(0,0,this.cachedWidth,this.cachedHeight);
      }
      
      protected function getDepthFor(param1:int, param2:int, param3:GraphicEntity) : int
      {
         return param2 * this.depthsPerRow + param1 * this.depthsPerColumn + param3.drawLayer;
      }
      
      protected function redrawBombs(param1:uint) : void
      {
         this.animateTiles(this.map.bombs,param1);
      }
      
      private function markDirtyRects() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ITileItem = null;
         var _loc4_:Array = null;
         var _loc1_:int = 0;
         _loc4_ = this.map.blocks.getArray();
         _loc2_ = _loc4_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[_loc1_] as ITileItem;
            if(_loc3_ && !(_loc3_ is NullTile) && _loc3_.state == TileState.INACTIVE_ANIMATING)
            {
               this.grid2.setTileAsDirty(_loc3_,true);
            }
            _loc1_++;
         }
         _loc4_ = this.map.bombs.getArray();
         _loc2_ = _loc4_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[_loc1_] as ITileItem;
            if(_loc3_ && !(_loc3_ is NullTile))
            {
               this.grid2.setTileAsDirty(_loc3_);
            }
            _loc1_++;
         }
         _loc4_ = this.map.explosions.getArray();
         _loc2_ = _loc4_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[_loc1_] as ITileItem;
            if(_loc3_ && !(_loc3_ is NullTile))
            {
               this.grid2.setTileAsDirty(_loc3_);
            }
            _loc1_++;
         }
      }
      
      protected function initialize() : void
      {
         this.root = new Sprite();
         this.grid2 = new DirtyRectRender();
         this.overlayLayer = new Sprite();
         this.root.addChild(this.grid2);
         this.root.addChild(this.overlayLayer);
         if(BaloonoGame.instance.DEBUG_VISUAL)
         {
            this.debugLayer = new Sprite();
            this.root.addChild(this.debugLayer);
         }
      }
      
      protected function buildBlocks() : void
      {
         var _loc1_:ITileItem = null;
         var _loc3_:int = 0;
         this.animateTiles(this.map.blocks,0);
         var _loc2_:int = 0;
         while(_loc2_ < this.map.blocks.height)
         {
            _loc3_ = 0;
            while(_loc3_ < this.map.blocks.width)
            {
               _loc1_ = this.map.blocks.get(_loc3_,_loc2_);
               if(_loc1_ && !(_loc1_ is NullTile))
               {
                  this.grid2.setTileAsDirty(_loc1_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      protected function buildGround() : void
      {
         var _loc1_:GroundTile = null;
         var _loc3_:int = 0;
         this.groundLayerStatic = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.map.ground.height)
         {
            _loc3_ = 0;
            while(_loc3_ < this.map.ground.width)
            {
               _loc1_ = this.map.ground.get(_loc3_,_loc2_);
               if(_loc1_)
               {
                  if(!_loc1_.graphicEntity.isStatic)
                  {
                     this.groundLayerStatic = false;
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         if(this.groundLayerStatic)
         {
            this.animateTiles(this.map.ground,0);
         }
      }
      
      public function setMap(param1:MapModel) : void
      {
         this.clear();
         this.map = param1;
         this.width = this.map.width;
         this.height = this.map.height;
         this.depthsPerColumn = BaloonoGame.instance.assetManager.activeDrawLayers;
         this.depthsPerRow = this.depthsPerColumn * this.width;
      }
      
      protected function redrawPowerups(param1:uint) : void
      {
         this.animateTiles(this.map.powerups,param1);
      }
      
      protected function animateTiles(param1:Array2, param2:uint, param3:Boolean = true) : void
      {
         var _loc4_:ITileItem = null;
         var _loc5_:Array = param1.getArray();
         var _loc6_:int = _loc5_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = _loc5_[_loc7_];
            if(!(_loc4_ == NullTile.NULL_TILE || !_loc4_))
            {
               this.redrawEntity(_loc4_.graphicEntity,param2,param3);
            }
            _loc7_++;
         }
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:Graphics = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TextField = null;
         if(this.map == null)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.warn("MapView ignoring resize");
            }
            return;
         }
         this.tileWidth = int(param1 / this.map.ground.width);
         this.tileHeight = int(param2 / this.map.ground.height);
         if(this.tileWidth < this.tileHeight)
         {
            this.tileHeight = this.tileWidth;
         }
         else
         {
            this.tileWidth = this.tileHeight;
         }
         if(this.tileWidth < MIN_ACCEPTABLE_TILE_SIZE)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.warn("MapView:: Requested an unacceptably small size, defaulting to the min tile size of " + MIN_ACCEPTABLE_TILE_SIZE);
            }
            this.tileWidth = this.tileHeight = MIN_ACCEPTABLE_TILE_SIZE;
         }
         trace("================= resize active graphics to tile size " + this.tileWidth + "x" + this.tileHeight);
         var _loc3_:int = getTimer();
         BaloonoGame.instance.assetManager.resizeActiveGraphics(new Rectangle(0,0,this.tileWidth,this.tileHeight));
         var _loc4_:int = getTimer() - _loc3_;
         trace("redraw time: " + _loc4_ + "ms, now at time " + BaloonoGame.instance.gamenetController.syncedTime);
         this.cachedWidth = this.map.ground.width * this.tileWidth;
         this.cachedHeight = this.map.ground.height * this.tileHeight;
         if(BaloonoGame.instance.DEBUG_VISUAL)
         {
            DisplayUtilities.removeAllChildren(this.debugLayer);
            _loc5_ = 65535;
            _loc6_ = this.debugLayer.graphics;
            _loc6_.clear();
            _loc6_.lineStyle(1,_loc5_);
            _loc7_ = 0;
            while(_loc7_ < this.map.ground.height)
            {
               _loc8_ = 0;
               while(_loc8_ < this.map.ground.width)
               {
                  if(this.DRAW_GRID)
                  {
                     _loc6_.moveTo(_loc8_ * this.tileWidth,0);
                     _loc6_.lineTo(_loc8_ * this.tileWidth,param2);
                     _loc6_.moveTo(0,_loc7_ * this.tileHeight);
                     _loc6_.lineTo(param1,_loc7_ * this.tileHeight);
                  }
                  if(this.DRAW_LABELS)
                  {
                     _loc9_ = new TextField();
                     _loc9_.selectable = false;
                     _loc9_.autoSize = TextFieldAutoSize.LEFT;
                     _loc9_.defaultTextFormat = new TextFormat("_typewriter",10,_loc5_);
                     _loc9_.text = "(" + _loc8_ + "," + _loc7_ + ")";
                     this.debugLayer.addChild(_loc9_);
                     _loc9_.x = _loc8_ * this.tileWidth + 4;
                     _loc9_.y = _loc7_ * this.tileHeight + 4;
                  }
                  _loc8_++;
               }
               _loc7_++;
            }
            this.debugLayer.cacheAsBitmap = true;
         }
         this.grid2.setSize(this.width,this.height,this,this.map);
         this.build();
      }
      
      protected function redrawEntity(param1:GraphicEntity, param2:uint, param3:Boolean = true) : void
      {
         if(param1 == null || param1.activeAsset == null)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("Undefined graphic entity redrawn");
            }
            return;
         }
         param1.redraw(param2);
      }
      
      protected function redrawPlayers(param1:uint) : void
      {
         var player:Player = null;
         var g:GraphicEntity = null;
         var ox:int = 0;
         var oy:int = 0;
         var testx:Number = NaN;
         var testy:Number = NaN;
         var time:uint = param1;
         for each(player in BaloonoGame.instance.playerManager.activePlayers)
         {
            if(!(player is NullPlayer))
            {
               if(player.state != TileState.INACTIVE)
               {
                  this.redrawEntity(player.graphicEntity,time,false);
                  if(player.state != TileState.INACTIVE)
                  {
                     if(player.graphicEntity.isMarkedForDirty)
                     {
                        this.grid2.setTileAsDirty(player,true);
                     }
                     try
                     {
                        g = player.graphicEntity;
                        if(g.activeAsset)
                        {
                           ox = 0;
                           oy = 0;
                           if(g.activeAsset.drawOffset)
                           {
                              ox = g.activeAsset.drawOffset.x;
                              oy = g.activeAsset.drawOffset.y;
                           }
                           testx = g.x * this.tileWidth - ox;
                           testy = g.y * this.tileHeight - oy;
                           player.playerLabel.x = Math.round(testx + player.graphicEntity.bitMapData.width * 0.5);
                           player.playerLabel.y = Math.round(testy);
                        }
                        else
                        {
                           continue;
                        }
                     }
                     catch(e:Error)
                     {
                        continue;
                     }
                  }
               }
            }
         }
      }
      
      public function get display() : DisplayObject
      {
         return this.root;
      }
      
      public function clear() : void
      {
         while(this.overlayLayer.numChildren > 0)
         {
            this.overlayLayer.removeChildAt(0);
         }
      }
      
      protected function redrawExplosions(param1:uint) : void
      {
         this.animateTiles(this.map.explosions,param1);
      }
      
      public function removeTile(param1:ITileItem) : void
      {
         this.grid2.setTileAsDirty(param1);
         param1.destroy();
      }
      
      protected function redrawBlocks(param1:uint) : void
      {
         this.animateTiles(this.map.blocks,param1);
      }
      
      public function addBomb(param1:Bomb) : void
      {
         trace("MAP: Add bomb at ",param1.graphicEntity.x,param1.graphicEntity.y,int(param1.graphicEntity.x),int(param1.graphicEntity.y),param1.graphicEntity.drawLayer);
      }
      
      public function addPowerupTile(param1:ITileItem) : void
      {
         param1.graphicEntity.redraw(BaloonoGame.time);
         this.grid2.setTileAsDirty(param1);
      }
      
      protected function buildPlayers() : void
      {
         var _loc2_:Player = null;
         var _loc1_:Array = BaloonoGame.instance.playerManager.activePlayers;
         for each(_loc2_ in _loc1_)
         {
            if(!(_loc2_ is NullPlayer || _loc2_.state.inactive))
            {
               this.addPlayer(_loc2_);
            }
         }
      }
      
      public function build() : void
      {
         Console.dumpThisMethod();
         this.clear();
         this.buildGround();
         this.buildBlocks();
         this.buildPlayers();
      }
      
      public function addExplosionTile(param1:ExplosionTile) : void
      {
      }
      
      public function addPlayer(param1:Player) : void
      {
         var _loc2_:GraphicEntity = param1.graphicEntity;
         if(param1 is NullPlayer)
         {
            return;
         }
         this.overlayLayer.addChild(param1.playerLabel);
      }
      
      public function redraw(param1:uint) : void
      {
         if(this.map == null)
         {
            return;
         }
         this.redrawBlocks(param1);
         this.redrawBombs(param1);
         this.redrawExplosions(param1);
         this.redrawPowerups(param1);
         this.redrawPlayers(param1);
         this.markDirtyRects();
         this.grid2.render2(param1);
      }
      
      protected function debugDisplayContentsOfCell(param1:int, param2:int) : void
      {
      }
   }
}
