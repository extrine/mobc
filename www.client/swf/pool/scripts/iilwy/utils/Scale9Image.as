package iilwy.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Scale9Image extends Sprite
   {
       
      
      private var _backgroundImages:Array;
      
      private var _width:Number = 100;
      
      private var _height:Number = 100;
      
      public function Scale9Image(source:Sprite = null, left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
      {
         super();
         if(source)
         {
            this.setSource(source,left,top,right,bottom);
         }
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public static function cutUp(sprite:Sprite, left:Number, top:Number, right:Number, bottom:Number) : Array
      {
         var tReturnArray:Array = new Array();
         var sourceBitmap:BitmapData = new BitmapData(sprite.width,sprite.height,true,0);
         sourceBitmap.draw(sprite);
         tReturnArray.push(cut(sourceBitmap,left,top,0,0));
         tReturnArray.push(cut(sourceBitmap,right - left,top,left,0));
         tReturnArray.push(cut(sourceBitmap,sprite.width - right,top,right,0));
         tReturnArray.push(cut(sourceBitmap,left,bottom - top,0,top));
         tReturnArray.push(cut(sourceBitmap,right - left,bottom - top,left,top));
         tReturnArray.push(cut(sourceBitmap,sprite.width - right,bottom - top,right,top));
         tReturnArray.push(cut(sourceBitmap,left,sprite.height - bottom,0,bottom));
         tReturnArray.push(cut(sourceBitmap,right - left,sprite.height - bottom,left,bottom));
         tReturnArray.push(cut(sourceBitmap,sprite.width - right,sprite.height - bottom,right,bottom));
         return tReturnArray;
      }
      
      private static function cut(source:BitmapData, width:Number, height:Number, offsetX:Number, offsetY:Number) : Bitmap
      {
         var tBitmapData:BitmapData = new BitmapData(width,height,true,0);
         var tRect:Rectangle = new Rectangle(offsetX,offsetY,offsetX + width,offsetY + height);
         var tPoint:Point = new Point(0,0);
         tBitmapData.copyPixels(source,tRect,tPoint);
         var tBitmap:Bitmap = new Bitmap();
         tBitmap.pixelSnapping = PixelSnapping.ALWAYS;
         tBitmap.bitmapData = tBitmapData;
         tBitmap.pixelSnapping = PixelSnapping.ALWAYS;
         return tBitmap;
      }
      
      public function destroy() : void
      {
         var bmp:Bitmap = null;
         for(var i:Number = 0; i < this._backgroundImages.length; i++)
         {
            bmp = Bitmap(this._backgroundImages[i]);
            bmp.bitmapData.dispose();
            removeChild(bmp);
         }
         this._backgroundImages = null;
      }
      
      public function setSource(source:Sprite = null, left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0) : void
      {
         var bmp:Bitmap = null;
         this.clearChildren();
         this._backgroundImages = Scale9Image.cutUp(source,left,top,right,bottom);
         for(var i:Number = 0; i < 9; i++)
         {
            bmp = Bitmap(this._backgroundImages[i]);
            addChild(bmp);
         }
         this.resize();
      }
      
      private function clearChildren() : void
      {
         do
         {
            if(numChildren > 0)
            {
               removeChildAt(0);
            }
         }
         while(numChildren > 0);
         
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(n:Number) : void
      {
         this._width = n;
         this.resize();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(n:Number) : void
      {
         this._height = n;
         this.resize();
      }
      
      private function resize() : void
      {
         this._backgroundImages[0].x = 0;
         this._backgroundImages[0].y = 0;
         this._backgroundImages[1].x = this._backgroundImages[0].width;
         this._backgroundImages[1].y = 0;
         this._backgroundImages[1].width = this._width - this._backgroundImages[0].width * 2;
         this._backgroundImages[2].x = this._width - this._backgroundImages[0].width;
         this._backgroundImages[2].y = 0;
         this._backgroundImages[3].x = 0;
         this._backgroundImages[3].y = int(this._backgroundImages[0].height);
         this._backgroundImages[3].height = int(this._height - (this._backgroundImages[0].height + this._backgroundImages[6].height));
         this._backgroundImages[4].x = this._backgroundImages[0].width;
         this._backgroundImages[4].y = int(this._backgroundImages[0].height);
         this._backgroundImages[4].width = this._width - this._backgroundImages[0].width * 2;
         this._backgroundImages[4].height = int(this._height - (this._backgroundImages[0].height + this._backgroundImages[6].height));
         this._backgroundImages[5].x = this._width - this._backgroundImages[0].width;
         this._backgroundImages[5].y = int(this._backgroundImages[0].height);
         this._backgroundImages[5].height = int(this._height - (this._backgroundImages[0].height + this._backgroundImages[6].height));
         this._backgroundImages[6].x = 0;
         this._backgroundImages[6].y = int(this._height - this._backgroundImages[6].height);
         this._backgroundImages[7].x = this._backgroundImages[0].width;
         this._backgroundImages[7].y = int(this._height - this._backgroundImages[6].height);
         this._backgroundImages[7].width = this._width - this._backgroundImages[0].width * 2;
         this._backgroundImages[8].x = this._width - this._backgroundImages[0].width;
         this._backgroundImages[8].y = int(this._height - this._backgroundImages[6].height);
      }
      
      public function copy(other:Scale9Image) : void
      {
         var img:Bitmap = null;
         var copiedImg:Bitmap = null;
         this.clearChildren();
         this._backgroundImages = [];
         for each(img in other._backgroundImages)
         {
            copiedImg = new Bitmap(img.bitmapData,img.pixelSnapping,img.smoothing);
            addChild(copiedImg);
            this._backgroundImages.push(copiedImg);
         }
         this.resize();
      }
      
      public function clone() : Scale9Image
      {
         var result:Scale9Image = new Scale9Image();
         result.copy(this);
         return result;
      }
   }
}
