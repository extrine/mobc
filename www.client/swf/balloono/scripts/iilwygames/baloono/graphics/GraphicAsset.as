package iilwygames.baloono.graphics
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class GraphicAsset
   {
       
      
      public var drawOffset:Point;
      
      public var colorTransform:ColorTransform;
      
      protected var sourceClip:MovieClip;
      
      public var name:String;
      
      protected var rasterizedFrames:Array;
      
      public var blendMode:String;
      
      public var defaultmspf:int;
      
      protected const TILE_INSTANCE_NAME:String = "TILE";
      
      protected var isSingleFrame:Boolean;
      
      protected const USE_SMOOTHING:Boolean = true;
      
      protected var shouldLoop:Boolean;
      
      public function GraphicAsset(param1:String, param2:Number, param3:Boolean, param4:String, param5:ColorTransform)
      {
         super();
         this.name = param1;
         this.shouldLoop = param3;
         this.blendMode = !!param4?param4:BlendMode.NORMAL;
         this.defaultmspf = !!isNaN(param2)?30:int(1000 / param2);
         this.colorTransform = param5;
      }
      
      public function getLastFrame() : BitmapData
      {
         return this.rasterizedFrames[this.rasterizedFrames.length - 1];
      }
      
      public function consumeFrames(param1:MovieClip) : void
      {
         this.sourceClip = param1;
         this.isSingleFrame = param1.totalFrames == 1;
         this.invalidateBitmaps();
      }
      
      public function get totalFrames() : int
      {
         return this.rasterizedFrames.length;
      }
      
      public function get bitmapsReady() : Boolean
      {
         return this.rasterizedFrames && this.rasterizedFrames.length > 0;
      }
      
      protected function roundRect(param1:Rectangle) : void
      {
         param1.x = Math.round(param1.x);
         param1.y = Math.round(param1.y);
         param1.width = Math.round(param1.width);
         param1.height = Math.round(param1.height);
      }
      
      protected function invalidateBitmaps() : void
      {
         var _loc1_:BitmapData = null;
         if(this.rasterizedFrames)
         {
            for each(_loc1_ in this.rasterizedFrames)
            {
               _loc1_.dispose();
            }
         }
         this.rasterizedFrames = null;
      }
      
      public function consumeEmbeddedFrames(param1:Class) : void
      {
         var mc:MovieClip = null;
         var source:Class = param1;
         try
         {
            mc = MovieClip(new source());
            this.consumeFrames(mc);
            return;
         }
         catch(error:Error)
         {
            trace(error);
            return;
         }
      }
      
      public function getFrame(param1:uint, param2:uint, param3:int = 0, param4:int = -1, param5:GraphicEntity = null) : BitmapData
      {
         var _loc7_:int = 0;
         if(this.isSingleFrame)
         {
            return this.rasterizedFrames[0];
         }
         if(param4 == -1)
         {
            param4 = this.defaultmspf;
         }
         var _loc6_:int = param3 + int((param2 - param1) / param4);
         if(this.shouldLoop)
         {
            _loc6_ = _loc6_ % this.rasterizedFrames.length;
         }
         else
         {
            _loc7_ = this.rasterizedFrames.length - 1;
            if(_loc6_ > _loc7_)
            {
               if(param5)
               {
                  param5.animationComplete();
               }
               _loc6_ = _loc7_;
            }
         }
         return this.rasterizedFrames[_loc6_];
      }
      
      public function openForEditing() : MovieClip
      {
         this.invalidateBitmaps();
         return this.sourceClip;
      }
      
      public function rasterizeFrames(param1:Rectangle) : void
      {
         var fullImageSize:Rectangle = null;
         var maxBounds:Rectangle = null;
         var sourceTileSize:Rectangle = null;
         var bmp:BitmapData = null;
         var j:int = 0;
         var child:DisplayObject = null;
         var targetTileSize:Rectangle = param1;
         if(!this.sourceClip)
         {
            return;
         }
         var i:int = 1;
         while(i <= this.sourceClip.totalFrames)
         {
            this.sourceClip.gotoAndStop(i);
            fullImageSize = this.sourceClip.getRect(this.sourceClip);
            if(maxBounds == null)
            {
               maxBounds = fullImageSize;
            }
            else
            {
               maxBounds = maxBounds.union(fullImageSize);
            }
            i++;
         }
         this.sourceClip.gotoAndStop(1);
         var sourceTileClip:DisplayObject = this.sourceClip.getChildByName(this.TILE_INSTANCE_NAME);
         if(sourceTileClip)
         {
            sourceTileClip.visible = true;
            sourceTileSize = sourceTileClip.getRect(this.sourceClip);
            sourceTileClip.visible = false;
         }
         else
         {
            sourceTileSize = maxBounds;
         }
         var drawClipRect:Rectangle = null;
         var drawTransformation:Matrix = new Matrix();
         drawTransformation.translate(-sourceTileSize.left,-sourceTileSize.top);
         var xscale:Number = targetTileSize.width / sourceTileSize.width;
         var yscale:Number = targetTileSize.height / sourceTileSize.height;
         drawTransformation.scale(xscale,yscale);
         var drawWidth:int = Math.ceil(maxBounds.width * xscale);
         var drawHeight:int = Math.ceil(maxBounds.height * yscale);
         var tileOffsetX:int = Math.ceil((maxBounds.left - sourceTileSize.left) * xscale);
         var tileOffsetY:int = Math.ceil((maxBounds.top - sourceTileSize.top) * yscale);
         drawTransformation.translate(-tileOffsetX,-tileOffsetY);
         this.drawOffset = new Point(-tileOffsetX,-tileOffsetY);
         var start:int = getTimer();
         this.invalidateBitmaps();
         var dur:int = getTimer() - start;
         this.rasterizedFrames = new Array();
         start = getTimer();
         i = 1;
         while(i <= this.sourceClip.totalFrames)
         {
            this.sourceClip.gotoAndStop(i);
            if(this.colorTransform)
            {
               j = 0;
               while(j < this.sourceClip.numChildren)
               {
                  try
                  {
                     child = this.sourceClip.getChildAt(j);
                  }
                  catch(e:Error)
                  {
                  }
                  if(child && child.name.indexOf("COLORIZE") >= 0)
                  {
                     child.transform.colorTransform = this.colorTransform;
                     try
                     {
                        MovieClip(child).gotoAndStop(i);
                     }
                     catch(e:Error)
                     {
                     }
                  }
                  j++;
               }
            }
            bmp = new BitmapData(drawWidth,drawHeight,true,0);
            bmp.draw(this.sourceClip,drawTransformation,null,null,drawClipRect,this.USE_SMOOTHING);
            this.rasterizedFrames.push(bmp);
            i++;
         }
         dur = getTimer() - start;
      }
      
      public function get isStatic() : Boolean
      {
         return this.rasterizedFrames.length == 1;
      }
   }
}
