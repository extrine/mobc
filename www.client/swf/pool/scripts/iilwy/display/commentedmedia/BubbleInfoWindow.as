package iilwy.display.commentedmedia
{
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import iilwy.ui.containers.InfoWindow;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class BubbleInfoWindow extends InfoWindow
   {
       
      
      public function BubbleInfoWindow(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200, styleId:String = "bubbleInfoWindow")
      {
         super(x,y,width,height,styleId);
         setChromePadding(4);
         setPadding(6);
         var filter:DropShadowFilter = new DropShadowFilter(2,90,0,0.1,10,10,1,1);
         filters = [filter];
         _arrowPadding = 20;
      }
      
      override protected function renderBackground() : void
      {
         var alpha:Number = NaN;
         var matr:Matrix = null;
         var bgCols:Array = this.backgroundColors;
         var bgCol:Number = this.backgroundColors[this.backgroundColors.length - 1];
         var r1:Number = 30;
         var r2:Number = Math.max(0,r1 - 3);
         UiRender.renderRoundRect(_background,bgCol,0,0,100,100,26);
         if(bgCols.length > 1)
         {
            UiRender.renderGradient(_background,bgCols,Math.PI / 2,4,4,92,92,20);
         }
         else
         {
            alpha = GraphicUtil.getAlpha(bgCol);
            matr = new Matrix();
            matr.createGradientBox(100,100,Math.PI / 2,0,0);
            _background.graphics.beginGradientFill(GradientType.LINEAR,[bgCol,bgCol],[alpha * 1.2,0],[0,255],matr);
            _background.graphics.drawRoundRect(4,4,92,92,20,20);
         }
         _background.scale9Grid = new Rectangle(20,20,60,60);
         _shadowCaster.graphics.clear();
         UiRender.renderRoundRect(_shadowCaster,16711680,0,0,100,100,30);
         _shadowCaster.scale9Grid = new Rectangle(20,20,60,60);
      }
      
      override protected function renderArrow() : Sprite
      {
         var canvas:Sprite = new Sprite();
         var inner:Sprite = new Sprite();
         canvas.addChild(inner);
         var bgCols:Array = this.backgroundColors;
         var bgCol:Number = this.backgroundColors[this.backgroundColors.length - 1];
         UiRender.renderTriangle(inner,bgCol,0,4,12,6);
         UiRender.renderTriangle(inner,style.iconColor,2,2,8,4);
         inner.rotation = 90;
         inner.x = 9;
         return canvas;
      }
      
      protected function get backgroundColors() : Array
      {
         var bgGradient:Array = getValidValue(backgroundGradient,style.backgroundGradient);
         var bgColor:Number = getValidValue(backgroundColor,style.backgroundColor,16777215);
         return Boolean(bgGradient)?bgGradient:[bgColor];
      }
   }
}
