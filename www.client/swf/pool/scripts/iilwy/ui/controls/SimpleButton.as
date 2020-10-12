package iilwy.ui.controls
{
   import flash.display.Sprite;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.CapType;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class SimpleButton extends DisplayButton
   {
       
      
      public function SimpleButton(label:String = null, x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 16, styleID:String = "simpleButton")
      {
         super(label,x,y,width,height,styleID);
         setPadding(3,3);
         useFocusGlow = true;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(processingIndicator != null && processingIndicator.stage != null)
         {
            processingIndicator.cornerRadius = getValidValue(cornerRadius,style.cornerRadius,height);
            processingIndicator.width = unscaledWidth;
            processingIndicator.height = unscaledHeight;
            processingIndicator.stroke = 0;
            GraphicUtil.setColor(processingIndicator,11184810);
            processingIndicator.alpha = 0.2;
            processingIndicator.visible = true;
         }
      }
      
      override protected function renderSkinStateBackground(canvas:Sprite, style:Style) : void
      {
         var fill:Array = null;
         var corners:Array = null;
         var radius:Number = NaN;
         var ctype:String = null;
         if(!isNaN(style.backgroundColor))
         {
            fill = [style.backgroundColor,style.backgroundColor];
         }
         if(style.backgroundGradient != null)
         {
            fill = style.backgroundGradient;
         }
         if(fill != null)
         {
            radius = getValidValue(cornerRadius,style.cornerRadius,height);
            ctype = getValidValue(capType,CapType.ROUND);
            corners = CapType.getCornersForType(ctype,radius);
            UiRender.renderGradient(canvas,fill,0.5 * Math.PI,0,0,width,height,corners);
         }
      }
   }
}
