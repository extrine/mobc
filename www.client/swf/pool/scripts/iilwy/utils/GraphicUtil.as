package iilwy.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class GraphicUtil
   {
       
      
      public function GraphicUtil()
      {
         super();
      }
      
      public static function makeBitmapSprite(canvas:Sprite, width:Number, height:Number) : Sprite
      {
         var data:BitmapData = new BitmapData(width,height,true,16777215);
         data.draw(canvas);
         var bmp:Bitmap = new Bitmap(data);
         var sprite:Sprite = new Sprite();
         sprite.addChild(bmp);
         return sprite;
      }
      
      public static function makeBitmapData(canvas:Sprite, width:Number, height:Number) : BitmapData
      {
         var data:BitmapData = new BitmapData(Math.max(1,width),Math.max(1,height),true,16777215);
         data.draw(canvas);
         return data;
      }
      
      public static function mixColor(originalColor:Number, newColor:Number, percentage:Number) : Number
      {
         var tOColor:Object = getChannels(originalColor.valueOf());
         var tNColor:Object = getChannels(newColor.valueOf());
         tOColor.red = tOColor.red * (1 - percentage) + tNColor.red * percentage;
         tOColor.green = tOColor.green * (1 - percentage) + tNColor.green * percentage;
         tOColor.blue = tOColor.blue * (1 - percentage) + tNColor.blue * percentage;
         tOColor.alpha = tOColor.alpha * (1 - percentage) + tNColor.alpha * percentage;
         return setChannels(tOColor);
      }
      
      public static function getChannels(tcolor:Number) : Object
      {
         var tObject:Object = {};
         tObject.blue = tcolor % 256;
         tObject.green = (tcolor >>> 8) % 256;
         tObject.red = (tcolor >>> 16) % 256;
         tObject.alpha = (tcolor >>> 24) % 256;
         return tObject;
      }
      
      public static function setChannels(colorObject:Object) : Number
      {
         var tcolor:uint = 0;
         tcolor = tcolor + colorObject.blue;
         tcolor = tcolor + (colorObject.green << 8);
         tcolor = tcolor + (colorObject.red << 16);
         tcolor = tcolor + (colorObject.alpha << 24);
         return tcolor;
      }
      
      public static function horizontalDottedLine(startX:Number, endX:Number, yPos:Number, color:Number = 0, thickness:Number = 1, alpha:Number = 1) : Sprite
      {
         var dottedLine:Sprite = new Sprite();
         var xY:Number = yPos;
         var xE:Number = endX;
         var xS:Number = startX;
         dottedLine.graphics.lineStyle(thickness,color,alpha);
         dottedLine.graphics.moveTo(startX,xY);
         for(var l:Number = 1; l < xE; l++)
         {
            xS = xS + 2;
            if(xS >= xE)
            {
               xS = xE;
               l = xE;
            }
            dottedLine.graphics.lineTo(xS,xY);
            xS = xS + 2;
            dottedLine.graphics.moveTo(xS,xY);
         }
         return dottedLine;
      }
      
      public static function horizontalDottedLineRender(canvas:Sprite, startX:Number, endX:Number, yPos:Number, color:Number = 0, thickness:Number = 1, alpha:Number = 1) : void
      {
         var dottedLine:Sprite = canvas;
         var xY:Number = yPos;
         var xE:Number = endX;
         var xS:Number = startX;
         dottedLine.graphics.lineStyle(thickness,color,alpha);
         dottedLine.graphics.moveTo(startX,xY);
         for(var l:Number = 1; l < xE; l++)
         {
            xS = xS + 2;
            if(xS >= xE)
            {
               xS = xE;
               l = xE;
            }
            dottedLine.graphics.lineTo(xS,xY);
            xS = xS + 2;
            dottedLine.graphics.moveTo(xS,xY);
         }
      }
      
      public static function verticalDottedLine(startY:Number, endY:Number, xPos:Number, color:Number = 0, thickness:Number = 1, alpha:Number = 1) : Sprite
      {
         var dottedLine:Sprite = new Sprite();
         var yX:Number = xPos;
         var yE:Number = endY;
         var yS:Number = startY;
         dottedLine.graphics.lineStyle(thickness,color,alpha);
         dottedLine.graphics.moveTo(yX,yS);
         for(var l:Number = 1; l < yE; l++)
         {
            yS = yS + 2;
            if(yS >= yE)
            {
               yS = yE;
               l = yE;
            }
            dottedLine.graphics.lineTo(yX,yS);
            yS = yS + 2;
            dottedLine.graphics.moveTo(yX,yS);
         }
         return dottedLine;
      }
      
      public static function getAlpha(color:uint) : Number
      {
         var a:uint = color >>> 24;
         var alpha:Number = a % 256 / 255;
         if(a == 1)
         {
            alpha = 0;
         }
         if(alpha == 0 && a != 1)
         {
            alpha = 1;
         }
         return alpha;
      }
      
      public static function setColor(obj:DisplayObject, color:Number) : void
      {
         var ct:ColorTransform = new ColorTransform();
         ct.color = color;
         obj.transform.colorTransform = ct;
         var a:Number = getAlpha(color);
         if(a != obj.alpha)
         {
            obj.alpha = a;
         }
      }
      
      public static function setColorNotAlpha(obj:DisplayObject, color:Number) : void
      {
         var ct:ColorTransform = new ColorTransform();
         ct.color = color;
         obj.transform.colorTransform = ct;
      }
      
      public static function fillInto(item:DisplayObject, left:Number, top:Number, width:Number, height:Number) : void
      {
         var ratio:Number = item.width / item.height;
         item.height = height;
         item.width = height * ratio;
         if(item.width < width)
         {
            ratio = item.height / item.width;
            item.width = width;
            item.height = width * ratio;
         }
         item.x = left + width / 2 - item.width / 2;
         item.y = top + height / 2 - item.height / 2;
      }
      
      public static function fitInto(item:DisplayObject, left:Number, top:Number, width:Number, height:Number) : void
      {
         var ratio:Number = item.width / item.height;
         item.height = height;
         item.width = height * ratio;
         if(item.width > width)
         {
            ratio = item.height / item.width;
            item.width = width;
            item.height = width * ratio;
         }
         item.x = left + width / 2 - item.width / 2;
         item.y = top + height / 2 - item.height / 2;
      }
      
      public static function centerHorizontallyInto(item:DisplayObject, left:Number, width:Number, pixelSnapping:Boolean = false) : void
      {
         item.x = left + width / 2 - item.width / 2;
         if(pixelSnapping)
         {
            item.x = Math.round(item.x);
         }
      }
      
      public static function centerInto(item:DisplayObject, left:Number, top:Number, width:Number, height:Number, pixelSnapping:Boolean = false) : void
      {
         item.x = left + width / 2 - item.width / 2;
         item.y = top + height / 2 - item.height / 2;
         if(pixelSnapping)
         {
            item.x = Math.round(item.x);
            item.y = Math.round(item.y);
         }
      }
      
      public static function centerTextInto(item:DisplayObject, left:Number, top:Number, width:Number, height:Number) : void
      {
         var untyped:* = undefined;
         var text:String = null;
         item.x = left + width / 2 - item.width / 2;
         item.y = top + height / 2 - item.height / 2;
         try
         {
            untyped = item;
            text = untyped.text;
            if(text.toLowerCase() == text)
            {
               item.y = Math.floor(item.y);
            }
            else
            {
               item.y = Math.ceil(item.y);
            }
         }
         catch(e:Error)
         {
            item.y = Math.round(item.y);
         }
         item.x = Math.round(item.x);
      }
      
      public static function getResizeRatio(sourceWidth:Number, sourceHeight:Number, newWidth:Number = NaN, newHeight:Number = NaN) : Number
      {
         var ratio:Number = NaN;
         if(isNaN(newWidth) || isNaN(newHeight))
         {
            ratio = !isNaN(newWidth)?Number(newWidth / sourceWidth):!isNaN(newHeight)?Number(newHeight / sourceHeight):Number(1);
         }
         else
         {
            ratio = sourceWidth > sourceHeight?Number(newHeight / sourceHeight):Number(newWidth / sourceWidth);
         }
         return ratio;
      }
      
      public static function getResizeMatrix(sourceWidth:Number, sourceHeight:Number, newWidth:Number = NaN, newHeight:Number = NaN, widthOffset:Number = 0, heightOffset:Number = 0) : Matrix
      {
         var matrix:Matrix = new Matrix();
         var ratio:Number = getResizeRatio(sourceWidth,sourceHeight,newWidth,newHeight);
         var scaledWidth:Number = sourceWidth * ratio;
         var scaledHeight:Number = sourceHeight * ratio;
         newWidth = !!isNaN(newWidth)?Number(0):Number(newWidth);
         newHeight = !!isNaN(newHeight)?Number(0):Number(newHeight);
         var translateX:Number = sourceWidth > sourceHeight?Number(-((scaledWidth - newWidth) * widthOffset)):Number(0);
         var translateY:Number = sourceWidth < sourceHeight?Number(-((scaledHeight - newHeight) * heightOffset)):Number(0);
         matrix.scale(ratio,ratio);
         matrix.translate(translateX,translateY);
         return matrix;
      }
      
      public static function getParentChain(item:DisplayObject) : Array
      {
         var arr:Array = new Array();
         getParentChainRecursor(item,arr);
         return arr;
      }
      
      private static function getParentChainRecursor(item:DisplayObject, list:Array) : void
      {
         list.unshift(item);
         if(item.parent != null)
         {
            getParentChainRecursor(item.parent,list);
         }
      }
   }
}
