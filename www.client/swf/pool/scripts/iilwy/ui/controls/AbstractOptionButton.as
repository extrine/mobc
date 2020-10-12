package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class AbstractOptionButton extends SkinButton
   {
       
      
      public var iconClass:Class;
      
      public var iconPadding:Margin;
      
      protected var renderField:TextField;
      
      protected var _value:String;
      
      protected var _size:Number;
      
      protected var _buttonGroup:AbstractOptionButtonGroup;
      
      public function AbstractOptionButton(x:Number = 0, y:Number = 0, styleID:String = "checkBox")
      {
         super(label,x,y,undefined,20,styleID);
         this._size = 20;
         toggle = true;
         tabEnabled = true;
         _skin.useStaticCache = true;
      }
      
      override public function set enabled(b:Boolean) : void
      {
         super.enabled = b;
      }
      
      public function get value() : String
      {
         if(this._value)
         {
            return this._value;
         }
         return _label;
      }
      
      public function set value(value:String) : void
      {
         this._value = value;
      }
      
      public function set size(n:Number) : void
      {
         this._size = n;
         height = n;
      }
      
      omgpop_internal function get buttonGroup() : AbstractOptionButtonGroup
      {
         return this._buttonGroup;
      }
      
      omgpop_internal function set buttonGroup(value:AbstractOptionButtonGroup) : void
      {
         if(this._buttonGroup)
         {
            this._buttonGroup.removeButton(this);
         }
         if(value)
         {
            this._buttonGroup = value;
            this._buttonGroup.addButton(this);
         }
      }
      
      override public function set label(s:String) : void
      {
         super.label = s;
         if(_skin)
         {
            _skin.useStaticCache = false;
         }
         if(!this.renderField)
         {
            this.renderField = new TextField();
         }
      }
      
      override public function set style(s:Style) : void
      {
         if(s && s.type == "simple")
         {
            useFocusGlow = true;
         }
         else
         {
            useFocusGlow = false;
         }
         super.style = s;
      }
      
      override public function measure() : void
      {
         var fmt:TextFormat = null;
         if(label != null && label != "")
         {
            fmt = style.textFormat;
            this.renderField.defaultTextFormat = fmt;
            this.renderField.autoSize = TextFieldAutoSize.LEFT;
            this.renderField.embedFonts = true;
            this.renderField.antiAliasType = AntiAliasType.ADVANCED;
            this.renderField.text = label;
            measuredWidth = this._size + this.renderField.width + 5;
         }
         else
         {
            measuredWidth = this._size;
         }
      }
      
      protected function renderSkinBackground(canvas:Sprite, style:Style, w:Number, h:Number) : void
      {
         var radius:Number = NaN;
         var fill:Array = null;
         var stroke:Number = NaN;
         if(style.type == "simple")
         {
            radius = !!isNaN(style.cornerRadius)?Number(h):Number(style.cornerRadius);
            if(!isNaN(style.backgroundColor))
            {
               fill = [style.backgroundColor,style.backgroundColor];
            }
            else if(style.backgroundGradient != null)
            {
               fill = style.backgroundGradient;
            }
            UiRender.renderGradient(canvas,fill,0.5 * Math.PI,0,0,w,h,radius);
            if(!isNaN(style.borderColor))
            {
               stroke = !isNaN(style.borderSize)?Number(style.borderSize):Number(1);
               canvas.graphics.lineStyle(stroke,style.borderColor,GraphicUtil.getAlpha(style.borderColor),false);
               canvas.graphics.drawRoundRect(stroke / 2,stroke / 2,w - stroke,h - stroke,radius,radius);
            }
         }
         else
         {
            UiRender.renderBorderBox(canvas,style,w,h);
         }
      }
      
      override protected function renderSkinState(style:Style) : BitmapData
      {
         var canvas:Sprite = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var check:Sprite = null;
         var fmt:TextFormat = null;
         canvas = new Sprite();
         w = height;
         h = height;
         this.renderSkinBackground(canvas,style,w,h);
         if(style == this.style.selected || style == this.style.selectedOver || style == this.style.disabledSelected || style == this.style.disabledSelectedOver)
         {
            check = new this.iconClass();
            check.x = this.iconPadding.left;
            check.y = this.iconPadding.top;
            check.width = w - this.iconPadding.horizontal;
            check.height = h - this.iconPadding.vertical;
            GraphicUtil.setColor(check,style.iconColor);
            canvas.addChild(check);
         }
         if(label != null && label != "")
         {
            fmt = style.textFormat;
            if(!isNaN(fontSize))
            {
               fmt.size = fontSize;
            }
            if(!isNaN(fontColor))
            {
               fmt.color = fontColor;
            }
            this.renderField.defaultTextFormat = fmt;
            this.renderField.autoSize = TextFieldAutoSize.LEFT;
            this.renderField.embedFonts = true;
            this.renderField.antiAliasType = AntiAliasType.ADVANCED;
            this.renderField.text = label;
            this.renderField.x = height + 5;
            this.renderField.y = height / 2 - this.renderField.height / 2;
            canvas.addChild(this.renderField);
         }
         return GraphicUtil.makeBitmapData(canvas,width,height);
      }
   }
}
