package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.CapType;
   import iilwy.utils.UiRender;
   
   public class Canvas extends UiContainer
   {
       
      
      private var _cornerRadius:Number;
      
      public var capType:String;
      
      public function Canvas(x:Number = 0, y:Number = 0, styleId:String = "canvas")
      {
         this.capType = CapType.ROUND;
         super();
         this.x = x;
         this.y = y;
         setStyleById(styleId);
         maskContents = true;
         addContainerBackground();
         content.addEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidateSize);
      }
      
      override public function destroy() : void
      {
         content.removeEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidateSize);
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(maskContents)
         {
            contentMask.x = padding.left;
            contentMask.y = padding.top;
            contentMask.width = unscaledWidth - padding.left - padding.right;
            contentMask.height = unscaledHeight - padding.top - padding.bottom;
         }
         content.x = padding.left;
         content.y = padding.top;
      }
      
      override protected function drawBackground() : void
      {
         var fill:Array = null;
         var rect:Rectangle = null;
         var cRad:Number = getValidValue(this._cornerRadius,style.cornerRadius,0);
         containerBackground.graphics.clear();
         containerBackground.scaleX = 1;
         containerBackground.scaleY = 1;
         var grad:Array = getValidValue(backgroundGradient,style.backgroundGradient);
         var col:Number = getValidValue(backgroundColor,style.backgroundColor,33554431);
         if(grad)
         {
            fill = grad;
         }
         else
         {
            fill = [col,col];
         }
         var angle:Number = getValidValue(backgroundGradientAngle,style.backgroundGradientAngle,90);
         UiRender.renderGradient(containerBackground,fill,angle * Math.PI / 180,0,0,100,100,CapType.getCornersForType(this.capType,cRad));
         if(cRad > 0)
         {
            rect = new Rectangle(cRad / 2,cRad / 2,100 - cRad,100 - cRad);
            containerBackground.scale9Grid = rect;
         }
      }
      
      override public function measure() : void
      {
         var len:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var i:Number = NaN;
         var obj:DisplayObject = null;
         if(isNaN(explicitHeight) || isNaN(explicitWidth))
         {
            len = content.numChildren;
            w = 0;
            h = 0;
            for(i = 0; i < len; i++)
            {
               obj = content.getChildAt(i);
               if(decideToIncludeChildInLayout(obj))
               {
                  w = Math.max(w,obj.x + obj.width);
                  h = Math.max(h,obj.y + obj.height);
               }
            }
            measuredWidth = Math.ceil(w + padding.left + padding.right);
            measuredHeight = Math.ceil(h + padding.top + padding.bottom);
         }
      }
      
      public function onContentInvalidateSize(event:UiEvent) : void
      {
         if(!validating)
         {
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function contentChildrenChanged() : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(n:Number) : void
      {
         this._cornerRadius = n;
         invalidateDisplayList();
      }
   }
}
