package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import iilwy.ui.themes.Style;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class LiteButton extends AbstractButton
   {
       
      
      protected var background:Sprite;
      
      protected var field:TextField;
      
      protected var backgroundValid:Boolean = false;
      
      public function LiteButton(label:String = "", x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 16, styleID:String = "simpleButton")
      {
         super(label,x,y,width,height,styleID);
         this.background = new Sprite();
         addChild(this.background);
         this.field = new TextField();
         addChild(this.field);
         setPadding(0,3);
      }
      
      override public function set style(value:Style) : void
      {
         super.style = value;
         this.backgroundValid = false;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         this.backgroundValid = false;
      }
      
      override public function measure() : void
      {
         var w:Number = 0;
         var pl:Number = getValidValue(style.paddingLeft,padding.left,0);
         var pr:Number = getValidValue(style.paddingRight,padding.right,0);
         if(label != null)
         {
            this.field.defaultTextFormat = style.textFormat;
            this.field.autoSize = TextFieldAutoSize.LEFT;
            this.field.embedFonts = true;
            this.field.antiAliasType = AntiAliasType.ADVANCED;
            this.field.text = label;
            w = w + Math.ceil(this.field.width + pr + pl);
         }
         measuredWidth = w;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var radius:Number = NaN;
         if(focused && useFocusGlow)
         {
            if(!AbstractButton.focusFilter)
            {
               AbstractButton.focusFilter = new GlowFilter(13093089,0.4,5,5,4,1,false,false);
            }
            this.background.filters = [AbstractButton.focusFilter];
         }
         else
         {
            this.background.filters = [];
         }
         if(!this.backgroundValid)
         {
            this.background.graphics.clear();
            this.backgroundValid = true;
            radius = getValidValue(cornerRadius,style.cornerRadius,height);
            UiRender.renderRoundRect(this.background,0,0,0,100,height,radius);
            if(radius > 0)
            {
               this.background.scale9Grid = new Rectangle(radius / 2,2,100 - radius,4);
            }
            else
            {
               this.background.scale9Grid = null;
            }
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.background.width = unscaledWidth;
         this.background.height = unscaledHeight;
      }
      
      override protected function applySubStyle(... options) : void
      {
         var style:Style = null;
         var textConstraint:Rectangle = null;
         for(var i:Number = 0; i < options.length; i++)
         {
            if(options[i] != null)
            {
               style = options[i];
               break;
            }
         }
         if(style == null)
         {
            style = this.style;
         }
         if(!isNaN(style.backgroundColor))
         {
            this.background.visible = true;
            GraphicUtil.setColor(this.background,style.backgroundColor);
         }
         else
         {
            this.background.visible = false;
         }
         var pl:Number = getValidValue(style.paddingLeft,padding.left,0);
         var pr:Number = getValidValue(style.paddingRight,padding.right,0);
         textConstraint = new Rectangle(0,0,width,height);
         textConstraint.x = textConstraint.x + pl;
         textConstraint.width = textConstraint.width - pl;
         textConstraint.width = textConstraint.width - pr;
         this.field.defaultTextFormat = style.textFormat;
         this.field.autoSize = TextFieldAutoSize.LEFT;
         this.field.embedFonts = true;
         this.field.antiAliasType = AntiAliasType.ADVANCED;
         this.field.alpha = GraphicUtil.getAlpha(style.fontColor);
         this.field.text = label;
         var h:Number = this.field.height;
         this.field.autoSize = TextFieldAutoSize.NONE;
         this.field.x = textConstraint.x;
         this.field.width = textConstraint.width;
         this.field.height = h;
         this.field.y = Math.ceil((height - h) / 2);
      }
   }
}
