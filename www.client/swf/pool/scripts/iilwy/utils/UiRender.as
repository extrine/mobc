package iilwy.utils
{
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import iilwy.graphics.GradientFill;
   import iilwy.ui.themes.Style;
   import iilwy.utils.logging.Logger;
   
   public class UiRender
   {
       
      
      public function UiRender()
      {
         super();
      }
      
      public static function renderRoundRect(canvas:Sprite, color:uint, x:Number, y:Number, width:Number, height:Number, cornerDiameter:* = 0) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         canvas.graphics.beginFill(color,GraphicUtil.getAlpha(color));
         if(cornerDiameter is Number)
         {
            canvas.graphics.drawRoundRect(x,y,width,height,cornerDiameter,cornerDiameter);
         }
         else if(cornerDiameter is Array)
         {
            drawRoundRectComplex(canvas.graphics,x,y,width,height,cornerDiameter[0] / 2,cornerDiameter[1] / 2,cornerDiameter[2] / 2,cornerDiameter[3] / 2);
         }
         canvas.graphics.endFill();
      }
      
      public static function renderRect(canvas:Sprite, color:uint, x:Number, y:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         canvas.graphics.beginFill(color,GraphicUtil.getAlpha(color));
         canvas.graphics.drawRect(x,y,width,height);
         canvas.graphics.endFill();
      }
      
      public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var xw:Number = x + width;
         var yh:Number = y + height;
         var minSize:Number = width < height?Number(width * 2):Number(height * 2);
         topLeftRadius = topLeftRadius < minSize?Number(topLeftRadius):Number(minSize);
         topRightRadius = topRightRadius < minSize?Number(topRightRadius):Number(minSize);
         bottomLeftRadius = bottomLeftRadius < minSize?Number(bottomLeftRadius):Number(minSize);
         bottomRightRadius = bottomRightRadius < minSize?Number(bottomRightRadius):Number(minSize);
         var a:Number = bottomRightRadius * 0.292893218813453;
         var s:Number = bottomRightRadius * 0.585786437626905;
         graphics.moveTo(xw,yh - bottomRightRadius);
         graphics.curveTo(xw,yh - s,xw - a,yh - a);
         graphics.curveTo(xw - s,yh,xw - bottomRightRadius,yh);
         a = bottomLeftRadius * 0.292893218813453;
         s = bottomLeftRadius * 0.585786437626905;
         graphics.lineTo(x + bottomLeftRadius,yh);
         graphics.curveTo(x + s,yh,x + a,yh - a);
         graphics.curveTo(x,yh - s,x,yh - bottomLeftRadius);
         a = topLeftRadius * 0.292893218813453;
         s = topLeftRadius * 0.585786437626905;
         graphics.lineTo(x,y + topLeftRadius);
         graphics.curveTo(x,y + s,x + a,y + a);
         graphics.curveTo(x + s,y,x + topLeftRadius,y);
         a = topRightRadius * 0.292893218813453;
         s = topRightRadius * 0.585786437626905;
         graphics.lineTo(xw - topRightRadius,y);
         graphics.curveTo(xw - s,y,xw - a,y + a);
         graphics.curveTo(xw,y + s,xw,y + topRightRadius);
         graphics.lineTo(xw,yh - bottomRightRadius);
      }
      
      public static function renderRightFacingTriangle(canvas:Sprite, color:uint, tX:Number, tY:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var alpha:Number = GraphicUtil.getAlpha(color);
         canvas.graphics.beginFill(color,alpha);
         canvas.graphics.lineStyle(0,0,0);
         canvas.graphics.moveTo(tX,tY);
         canvas.graphics.lineTo(tX,tY + height);
         canvas.graphics.lineTo(tX + width,tY + height / 2);
         canvas.graphics.lineTo(tX,tY);
      }
      
      public static function renderLeftFacingTriangle(canvas:Sprite, color:uint, tX:Number, tY:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var alpha:Number = GraphicUtil.getAlpha(color);
         canvas.graphics.beginFill(color,alpha);
         canvas.graphics.lineStyle(0,0,0);
         canvas.graphics.moveTo(tX,tY);
         canvas.graphics.lineTo(tX,tY + height);
         canvas.graphics.lineTo(tX - width,tY + height / 2);
         canvas.graphics.lineTo(tX,tY);
      }
      
      public static function renderTriangle(canvas:Sprite, color:uint, tX:Number, tY:Number, width:Number, height:Number) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         x = tX;
         y = tY;
         canvas.graphics.beginFill(color,GraphicUtil.getAlpha(color));
         canvas.graphics.moveTo(x,y);
         canvas.graphics.lineTo(x + width,y);
         canvas.graphics.lineTo(x + width / 2,y + height);
         canvas.graphics.lineTo(x,y);
         canvas.graphics.endFill();
      }
      
      public static function createSimpleGradientFill(graphics:Graphics, color:uint, radians:Number, x:Number, y:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var colors:Array = [color,color];
         var alphas:Array = [0,100];
         var ratios:Array = [0,255];
         var matr:Matrix = new Matrix();
         matr.createGradientBox(width,height,radians,x,y);
         graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matr,SpreadMethod.REPEAT);
      }
      
      public static function renderSimpleGradient(canvas:Sprite, color:uint, radians:Number, x:Number, y:Number, width:Number, height:Number, cornerDiameter:* = 0) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         createSimpleGradientFill(canvas.graphics,color,radians,x,y,width,height);
         canvas.graphics.drawRoundRect(x,y,width,height,cornerDiameter,cornerDiameter);
         canvas.graphics.endFill();
      }
      
      public static function createGradientFill(graphics:Graphics, colors:Array, radians:Number, x:Number, y:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var cols:Array = [];
         var alphas:Array = [];
         var ratios:Array = [];
         for(var i:Number = 0; i < colors.length; i++)
         {
            cols.push(colors[i]);
            alphas.push(GraphicUtil.getAlpha(colors[i]));
            ratios.push(Math.floor(i * (255 / (colors.length - 1))));
         }
         var matr:Matrix = new Matrix();
         matr.createGradientBox(width,height,radians,x,y);
         graphics.beginGradientFill(GradientType.LINEAR,cols,alphas,ratios,matr,SpreadMethod.PAD);
      }
      
      public static function renderGradient(canvas:Sprite, colors:Array, radians:Number, x:Number, y:Number, width:Number, height:Number, cornerDiameter:* = 0) : void
      {
         var width:Number = !isNaN(width)?Number(width):Number(10);
         var height:Number = !isNaN(height)?Number(height):Number(10);
         try
         {
            createGradientFill(canvas.graphics,colors,radians,x,y,width,height);
            if(cornerDiameter is Number)
            {
               canvas.graphics.drawRoundRect(x,y,width,height,cornerDiameter,cornerDiameter);
            }
            else if(cornerDiameter is Array)
            {
               drawRoundRectComplex(canvas.graphics,x,y,width,height,cornerDiameter[0] / 2,cornerDiameter[1] / 2,cornerDiameter[2] / 2,cornerDiameter[3] / 2);
            }
            canvas.graphics.endFill();
         }
         catch(e:Error)
         {
            Logger.getLogger("GraphicUtil").error("error rendering gradient");
         }
      }
      
      public static function renderGradientFill(canvas:Sprite, gradientFill:GradientFill, x:Number, y:Number, width:Number, height:Number, cornerDiameter:* = 0) : void
      {
         var width:Number = !isNaN(width)?Number(width):Number(10);
         var height:Number = !isNaN(height)?Number(height):Number(10);
         try
         {
            GradientFill.beginFill(canvas.graphics,gradientFill);
            if(cornerDiameter is Number)
            {
               canvas.graphics.drawRoundRect(x,y,width,height,cornerDiameter,cornerDiameter);
            }
            else if(cornerDiameter is Array)
            {
               drawRoundRectComplex(canvas.graphics,x,y,width,height,cornerDiameter[0] / 2,cornerDiameter[1] / 2,cornerDiameter[2] / 2,cornerDiameter[3] / 2);
            }
            canvas.graphics.endFill();
         }
         catch(e:Error)
         {
            Logger.getLogger("GraphicUtil").error("error rendering gradient");
         }
      }
      
      public static function renderStripes(canvas:Sprite, color:Number, size:uint, x:Number, y:Number, width:Number, height:Number) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         var alpha:Number = GraphicUtil.getAlpha(color);
         var colors:Array = [color,color,color,color];
         var alphas:Array = [alpha,alpha,0,0];
         var ratios:Array = [0,128,128,255];
         var matr:Matrix = new Matrix();
         matr.createGradientBox(size * 2,size * 2,0.25 * Math.PI,x,y);
         canvas.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matr,SpreadMethod.REPEAT);
         canvas.graphics.drawRect(x,y,width,height);
         canvas.graphics.endFill();
      }
      
      public static function renderStripedWindowBackground(canvas:Sprite, width:Number, height:Number, fill:Boolean = true) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         if(fill)
         {
            renderGradient(canvas,[5000268,1579032],Math.PI / 2,0,0,width,height);
         }
         var size:Number = 4;
         var dash:Number = 80;
         var x:Number = 0;
         var y:Number = 0;
         var color:Number = 872415231;
         var colors:Array = [color,color,color,color];
         var alphas:Array = [0.015,0.015,0,0];
         var ratios:Array = [0,dash,dash,255];
         var matr:Matrix = new Matrix();
         matr.createGradientBox(size * 2,size * 2,0.25 * Math.PI,x,y);
         canvas.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matr,SpreadMethod.REPEAT);
         canvas.graphics.drawRect(x,y,width,height);
         canvas.graphics.endFill();
      }
      
      public static function renderRoundBorderBox(canvas:Sprite, style:Style, width:Number, height:Number, cornerRadius:Number = 14) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         canvas.graphics.lineStyle(3,style.border1Color,GraphicUtil.getAlpha(style.border1Color));
         canvas.graphics.drawRoundRect(1.5,1.5,width - 3,height - 3,cornerRadius - 2);
         canvas.graphics.lineStyle(1,style.border2Color,GraphicUtil.getAlpha(style.border2Color));
         canvas.graphics.drawRoundRect(2.5,2.5,width - 5,height - 5,cornerRadius - 4);
         canvas.graphics.endFill();
         canvas.graphics.lineStyle();
         UiRender.renderRoundRect(canvas,style.backgroundColor,3,3,width - 6,height - 6,cornerRadius - 3);
         if(style.backgroundGradient != null)
         {
            UiRender.renderGradient(canvas,style.backgroundGradient,0.5 * Math.PI,5,5,width - 10,height - 10,cornerRadius - 7);
         }
         canvas.graphics.lineStyle();
      }
      
      public static function renderBorderBox(canvas:Sprite, style:Style, width:Number, height:Number, cornerDiameter:Number = 0) : void
      {
         width = !isNaN(width)?Number(width):Number(10);
         height = !isNaN(height)?Number(height):Number(10);
         if(cornerDiameter > 0)
         {
            UiRender.renderRoundRect(canvas,style.border1Color,0,0,width,height,cornerDiameter);
            UiRender.renderRoundRect(canvas,style.border2Color,2,2,width - 4,height - 4,cornerDiameter);
            UiRender.renderRoundRect(canvas,style.backgroundColor,3,3,width - 6,height - 6,cornerDiameter);
         }
         else
         {
            UiRender.renderRect(canvas,style.border1Color,0,0,width,height);
            UiRender.renderRect(canvas,style.border2Color,2,2,width - 4,height - 4);
            UiRender.renderRect(canvas,style.backgroundColor,3,3,width - 6,height - 6);
         }
      }
      
      public static function renderPartition(canvas:Sprite, style:Style, x:Number, y:Number, height:Number) : void
      {
         height = !isNaN(height)?Number(height):Number(10);
         UiRender.renderRect(canvas,style.border2Color,x,y,1,height);
         UiRender.renderRect(canvas,style.backgroundColor,x + 1,y,2,height);
      }
      
      public static function createScale9RoundRect(color:Number, cornerDiameter:Number) : Scale9Image
      {
         var rect:Sprite = new Sprite();
         UiRender.renderRoundRect(rect,color,0,0,100,100,cornerDiameter);
         var img:Scale9Image = new Scale9Image(rect,Math.ceil(cornerDiameter / 2),Math.ceil(cornerDiameter / 2),100 - Math.ceil(cornerDiameter / 2),100 - Math.ceil(cornerDiameter / 2));
         return img;
      }
      
      public static function createScale9RoundRectLine(color:Number, thickness:Number, cornerDiameter:Number, fillcol:Number = -1) : Scale9Image
      {
         var rect:Sprite = new Sprite();
         rect.graphics.lineStyle(thickness,color);
         if(fillcol != -1)
         {
            rect.graphics.beginFill(fillcol);
         }
         rect.graphics.drawRoundRect(0,0,100,100,cornerDiameter,cornerDiameter);
         rect.graphics.endFill();
         var img:Scale9Image = new Scale9Image(rect,Math.ceil(cornerDiameter / 2),Math.ceil(cornerDiameter / 2),100 - Math.ceil(cornerDiameter / 2),100 - Math.ceil(cornerDiameter / 2));
         return img;
      }
      
      public static function createPointSticker(graphic:Class, size:Number, color1:Number, color2:Number = undefined) : BitmapData
      {
         var canvas:Sprite = new Sprite();
         var fill:Sprite = new Sprite();
         canvas.addChild(fill);
         var mask:Sprite = new graphic();
         mask.width = size;
         mask.height = size;
         canvas.addChild(mask);
         fill.mask = mask;
         renderRect(fill,color1,0,0,size,size);
         if(!isNaN(color2))
         {
            renderStripes(fill,color2,5,0,0,size,size);
         }
         var data:BitmapData = new BitmapData(size,size,true,16777215);
         data.draw(canvas);
         return data;
      }
   }
}
