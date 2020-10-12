package iilwy.ui.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.GraphicUtil;
   
   public class DisplayButton extends SkinButton
   {
       
      
      protected var processingIndicator:ProcessingIndicator;
      
      protected var _renderField:TextField;
      
      public function DisplayButton(label:String = null, x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = undefined, styleID:String = "displayButton")
      {
         super(label,x,y,width,height,styleID);
         this._renderField = new TextField();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function measure() : void
      {
         var fmt:TextFormat = null;
         var w:Number = 0;
         var pl:Number = getValidValue(style.paddingLeft,padding.left,0);
         var pr:Number = getValidValue(style.paddingRight,padding.right,0);
         if(label != null && label != "")
         {
            fmt = style.textFormat;
            if(!isNaN(fontSize))
            {
               fmt.size = fontSize;
            }
            this._renderField.defaultTextFormat = fmt;
            this._renderField.autoSize = TextFieldAutoSize.LEFT;
            this._renderField.embedFonts = true;
            this._renderField.antiAliasType = AntiAliasType.ADVANCED;
            this._renderField.text = label;
            w = w + Math.ceil(this._renderField.width + pr + pl);
         }
         if(_icon != null)
         {
            w = w + explicitHeight;
            if(label != null)
            {
               w = w - 3;
            }
         }
         if(countLabel != null && countLabel != "" && countLabel != "0")
         {
            this._renderField.defaultTextFormat = style.textFormat;
            this._renderField.autoSize = TextFieldAutoSize.LEFT;
            this._renderField.embedFonts = true;
            this._renderField.antiAliasType = AntiAliasType.ADVANCED;
            this._renderField.text = countLabel;
            w = w + Math.ceil(this._renderField.width + pl);
         }
         measuredWidth = w;
      }
      
      protected function renderSkinStateBackground(canvas:Sprite, style:Style) : void
      {
      }
      
      override protected function renderSkinState(style:Style) : BitmapData
      {
         var tIcon:DisplayObject = null;
         var field:TextField = null;
         var iconSize:Number = NaN;
         var ialign:String = null;
         var ipadding:Number = NaN;
         var validIconColor:Number = NaN;
         var subfield:TextField = null;
         var leading:Number = NaN;
         var canvas:Sprite = new Sprite();
         var textConstraint:Rectangle = new Rectangle(0,0,width,height);
         var pl:Number = getValidValue(style.paddingLeft,padding.left,0);
         var pr:Number = getValidValue(style.paddingRight,padding.right,0);
         var pt:Number = getValidValue(style.paddingTop,padding.top,0);
         var pb:Number = getValidValue(style.paddingBottom,padding.bottom,0);
         var padding:Margin = new Margin(pl,pt,pr,pb);
         this.renderSkinStateBackground(canvas,style);
         if(_icon != null)
         {
            tIcon = new _icon();
            tIcon.blendMode = BlendMode.LAYER;
            try
            {
               Bitmap(icon).smoothing = true;
            }
            catch(e:Error)
            {
            }
            iconSize = Math.min(width,height);
            if(tIcon.height < this.height)
            {
               GraphicUtil.centerInto(tIcon,pl,pt,width - pr - pl,height - pb - pt);
            }
            else
            {
               GraphicUtil.fitInto(tIcon,pl,pt,width - pr - pl,height - pb - pt);
            }
            ialign = getValidValue(iconAlign,style.iconAlign,TextFormatAlign.LEFT);
            ipadding = getValidValue(itemPadding,style.itemPadding,0);
            if(ialign == TextFormatAlign.CENTER)
            {
               tIcon.x = int(pl + (width - pr - pl) / 2 - tIcon.width / 2);
            }
            else if(ialign == TextFormatAlign.LEFT)
            {
               tIcon.x = pl;
               textConstraint.x = textConstraint.x + (tIcon.width + ipadding);
               textConstraint.width = textConstraint.width - (tIcon.width + ipadding);
            }
            else if(ialign == TextFormatAlign.RIGHT)
            {
               tIcon.x = int(width - ipadding - tIcon.width - pr);
               textConstraint.width = textConstraint.width - (ipadding + tIcon.width + pr);
            }
            validIconColor = getValidValue(iconColor,style.iconColor);
            if(validIconColor)
            {
               GraphicUtil.setColor(tIcon,validIconColor);
            }
            canvas.addChild(tIcon);
         }
         if(countLabel != null && countLabel != "" && countLabel != "0")
         {
            field = this.getSkinStateCountLabelField(style,textConstraint,padding);
            canvas.addChild(field);
            textConstraint.width = textConstraint.width - field.width;
         }
         if(label != "" && label != null)
         {
            textConstraint.x = textConstraint.x + pl;
            textConstraint.width = textConstraint.width - pl;
            textConstraint.width = textConstraint.width - pr;
            field = this.getSkinStateLabelField(style,textConstraint,padding);
            canvas.addChild(field);
         }
         if(sublabel != "" && sublabel != null)
         {
            textConstraint.x = textConstraint.x + pl;
            textConstraint.width = textConstraint.width - pl;
            textConstraint.width = textConstraint.width - pr;
            subfield = this.getSkinStateSublabelField(style,textConstraint,padding);
            canvas.addChild(subfield);
            leading = getValidValue(fontLeading,style.fontLeading,0);
            field.y = field.y - (subfield.textHeight / 2 + leading / 2);
            subfield.y = subfield.y + (subfield.textHeight / 2 + leading / 2);
         }
         var bd:BitmapData = GraphicUtil.makeBitmapData(canvas,width,height);
         return bd;
      }
      
      protected function getSkinStateCountLabelField(style:Style, textConstraint:Rectangle, padding:Margin) : TextField
      {
         var field:TextField = new TextField();
         var ifmt:TextFormat = style.textFormat;
         ifmt.align = TextFormatAlign.LEFT;
         field.defaultTextFormat = style.textFormat;
         field.autoSize = TextFieldAutoSize.LEFT;
         field.embedFonts = true;
         field.antiAliasType = AntiAliasType.ADVANCED;
         field.alpha = GraphicUtil.getAlpha(getValidValue(fontColor,style.fontColor));
         field.text = countLabel;
         field.x = width - field.width - padding.right;
         field.y = Math.ceil((height - field.height) / 2);
         return field;
      }
      
      protected function getSkinStateLabelField(style:Style, textConstraint:Rectangle, padding:Margin) : TextField
      {
         var field:TextField = new TextField();
         field.autoSize = TextFieldAutoSize.LEFT;
         field.embedFonts = true;
         field.antiAliasType = AntiAliasType.ADVANCED;
         var fmt:TextFormat = style.textFormat;
         var align:String = Boolean(_fontAlign)?_fontAlign:fmt.align;
         if(!isNaN(fontSize))
         {
            fmt.size = fontSize;
         }
         if(!isNaN(fontColor))
         {
            fmt.color = fontColor;
         }
         fmt.align = TextFormatAlign.LEFT;
         field.defaultTextFormat = fmt;
         field.setTextFormat(fmt);
         field.text = label;
         field.alpha = GraphicUtil.getAlpha(getValidValue(fontColor,style.fontColor));
         var h:Number = field.height;
         if(align == TextFormatAlign.RIGHT)
         {
            field.x = textConstraint.x + textConstraint.width - field.width;
         }
         else if(align == TextFormatAlign.CENTER)
         {
            GraphicUtil.centerInto(field,textConstraint.x,0,textConstraint.width,height);
         }
         else
         {
            field.x = textConstraint.x;
         }
         field.y = Math.ceil((height - h) / 2);
         return field;
      }
      
      protected function getSkinStateSublabelField(style:Style, textConstraint:Rectangle, padding:Margin) : TextField
      {
         var field:TextField = new TextField();
         field.autoSize = TextFieldAutoSize.LEFT;
         field.embedFonts = true;
         field.antiAliasType = AntiAliasType.ADVANCED;
         var fmt:TextFormat = style.subTextFormat;
         var align:String = Boolean(_subFontAlign)?_subFontAlign:fmt.align;
         if(!isNaN(subFontSize))
         {
            fmt.size = subFontSize;
         }
         if(!isNaN(subFontColor))
         {
            fmt.color = subFontColor;
         }
         fmt.align = TextFormatAlign.LEFT;
         field.defaultTextFormat = fmt;
         field.setTextFormat(fmt);
         field.text = sublabel;
         field.alpha = GraphicUtil.getAlpha(getValidValue(subFontColor,style.subFontColor));
         var h:Number = field.height;
         if(align == TextFormatAlign.RIGHT)
         {
            field.x = textConstraint.x + textConstraint.width - field.width;
         }
         else if(align == TextFormatAlign.CENTER)
         {
            GraphicUtil.centerInto(field,textConstraint.x,0,textConstraint.width,height);
         }
         else
         {
            field.x = textConstraint.x;
         }
         field.y = Math.ceil((height - h) / 2);
         return field;
      }
      
      public function set processing(value:Boolean) : void
      {
         if(value)
         {
            enabled = false;
            if(this.processingIndicator == null)
            {
               this.processingIndicator = new ProcessingIndicator(0,0);
            }
            this.processingIndicator.animate = true;
            this.processingIndicator.visible = false;
            if(this.processingIndicator.stage == null)
            {
               addChild(this.processingIndicator);
            }
         }
         else
         {
            enabled = true;
            if(this.processingIndicator != null)
            {
               this.processingIndicator.animate = false;
               if(contains(this.processingIndicator))
               {
                  removeChild(this.processingIndicator);
               }
            }
         }
         invalidateDisplayList();
      }
      
      public function get renderField() : TextField
      {
         return this._renderField;
      }
   }
}
