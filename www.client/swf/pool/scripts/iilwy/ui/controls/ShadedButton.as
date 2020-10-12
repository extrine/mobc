package iilwy.ui.controls
{
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.CapType;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class ShadedButton extends DisplayButton
   {
       
      
      public function ShadedButton(label:String = "", x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 37, styleID:String = "shadedButton")
      {
         super(label,x,y,width,height,styleID);
         tabEnabled = true;
         setPadding(8,8);
      }
      
      override protected function renderSkinStateBackground(canvas:Sprite, style:Style) : void
      {
         var corners:Array = null;
         var border1:Array = null;
         var border2:Array = null;
         var border3:Array = null;
         var h:Number = NaN;
         var radius:Number = getValidValue(cornerRadius,14);
         var cornersLookup:Object = new Object();
         cornersLookup[CapType.NONE] = [0,0,0,0];
         cornersLookup[CapType.ROUND] = [radius,radius,radius,radius];
         cornersLookup[CapType.ROUND_LEFT] = [radius,0,radius,0];
         cornersLookup[CapType.ROUND_RIGHT] = [0,radius,0,radius];
         cornersLookup[CapType.TAB] = [radius,radius,radius,radius];
         cornersLookup[CapType.TAB_LEFT] = [radius,0,0,0];
         cornersLookup[CapType.TAB_RIGHT] = [0,radius,0,0];
         var border1Lookup:Object = new Object();
         border1Lookup[CapType.NONE] = [0,0];
         border1Lookup[CapType.ROUND] = [2,2];
         border1Lookup[CapType.ROUND_LEFT] = [2,0];
         border1Lookup[CapType.ROUND_RIGHT] = [0,2];
         var border2Lookup:Object = new Object();
         border2Lookup[CapType.NONE] = [0,1];
         border2Lookup[CapType.ROUND] = [1,1];
         border2Lookup[CapType.ROUND_LEFT] = [1,1];
         border2Lookup[CapType.ROUND_RIGHT] = [0,1];
         var border3Lookup:Object = new Object();
         border3Lookup[CapType.NONE] = [2,0];
         border3Lookup[CapType.ROUND] = [2,2];
         border3Lookup[CapType.ROUND_LEFT] = [2,0];
         border3Lookup[CapType.ROUND_RIGHT] = [2,2];
         var ctype:String = getValidValue(capType,CapType.ROUND);
         corners = CapType.getCornersForType(ctype,radius);
         border1 = border1Lookup[ctype];
         border2 = border2Lookup[ctype];
         border3 = border3Lookup[ctype];
         var b1:Array = border1;
         var b2:Array = border2;
         var b3:Array = border3;
         h = height;
         canvas.graphics.beginFill(style.border1Color,GraphicUtil.getAlpha(style.border1Color));
         UiRender.drawRoundRectComplex(canvas.graphics,0,0,width,height,Math.min(h,corners[0]) / 2,Math.min(h,corners[1]) / 2,Math.min(h,corners[2]) / 2,Math.min(h,corners[3]) / 2);
         h = height - 4;
         canvas.graphics.beginFill(style.border2Color,GraphicUtil.getAlpha(style.border2Color));
         UiRender.drawRoundRectComplex(canvas.graphics,b1[0],2,width - b1[0] - b1[1],height - 4,Math.min(h,corners[0] - 2) / 2,Math.min(h,corners[1] - 2) / 2,Math.min(h,corners[2] - 2) / 2,Math.min(h,corners[3] - 2) / 2);
         h = height - 6;
         canvas.graphics.beginFill(style.backgroundColor,GraphicUtil.getAlpha(style.backgroundColor));
         UiRender.drawRoundRectComplex(canvas.graphics,b1[0] + b2[0],3,width - b1[0] - b1[1] - b2[0] - b2[1],height - 6,Math.min(h,corners[0] - 2) / 2,Math.min(h,corners[1] - 2) / 2,Math.min(h,corners[2] - 2) / 2,Math.min(h,corners[3] - 2) / 2);
         var cols:Array = [];
         var alphas:Array = [];
         var ratios:Array = [];
         var w:Number = width - b1[0] - b1[1] - b2[0] - b2[1] - b3[0] - b3[1];
         h = height - 10;
         for(var i:Number = 0; i < style.backgroundGradient.length; i++)
         {
            cols.push(style.backgroundGradient[i]);
            alphas.push(GraphicUtil.getAlpha(style.backgroundGradient[i]));
            ratios.push(Math.floor(i * (255 / (style.backgroundGradient.length - 1))));
         }
         var matr:Matrix = new Matrix();
         matr.createGradientBox(w,h,Math.PI * 0.5,5,0);
         canvas.graphics.beginGradientFill(GradientType.LINEAR,cols,alphas,ratios,matr);
         UiRender.drawRoundRectComplex(canvas.graphics,b1[0] + b2[0] + b3[0],5,w,h,Math.min(h,corners[0] - 4) / 2,Math.min(h,corners[1] - 4) / 2,Math.min(h,corners[2] - 4) / 2,Math.min(h,corners[3] - 4) / 2);
      }
   }
}
