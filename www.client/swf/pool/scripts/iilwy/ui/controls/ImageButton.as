package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import iilwy.ui.themes.Style;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class ImageButton extends AbstractButton
   {
       
      
      protected var background:Sprite;
      
      protected var image:Image;
      
      protected var border:Sprite;
      
      public function ImageButton(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 75, styleID:String = "imageButton")
      {
         this.border = new Sprite();
         super(null,x,y,width,height,styleID);
         this.background = new Sprite();
         UiRender.renderRect(this.background,0,0,0,1,1);
         this.image = new Image(0,0,width,height,"clearImage");
         this.image.resizeMode = Image.RESIZE_FIT;
         addChild(this.background);
         addChild(this.image);
         addChild(this.border);
         tabEnabled = true;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.image.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.image.width = unscaledWidth;
         this.image.height = unscaledHeight;
         var bs:Number = getValidValue(borderSize,style.borderSize,2);
         var cr:Number = getValidValue(cornerRadius,style.cornerRadius,0);
         var bg:Number = getValidValue(style.backgroundColor);
         GraphicUtil.setColor(this.background,bg);
         this.background.width = unscaledWidth;
         this.background.height = unscaledHeight;
         this.border.graphics.clear();
         this.border.graphics.lineStyle(2,0,1,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,255);
         this.border.graphics.drawRoundRect(bs / 2,bs / 2,width - bs,height - bs,cr,cr);
      }
      
      override protected function applySubStyle(... options) : void
      {
         options.push(this.style);
         var s:Style = getValidValue.apply(this,options);
         var col:Number = getValidValue(s.borderColor,16777216);
         GraphicUtil.setColor(this.border,col);
      }
      
      public function set url(value:String) : void
      {
         this.image.url = value;
         invalidateDisplayList();
      }
      
      public function set bitmapData(value:BitmapData) : void
      {
         this.image.bitmapData = value;
      }
      
      public function set resizeMode(value:String) : void
      {
         this.image.resizeMode = value;
      }
   }
}
