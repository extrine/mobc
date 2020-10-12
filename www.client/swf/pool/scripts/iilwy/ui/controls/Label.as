package iilwy.ui.controls
{
   import flash.events.TextEvent;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import iilwy.utils.GraphicUtil;
   
   public class Label extends UiElement
   {
      
      private static var staticCount:int = 0;
       
      
      public var defaultLinkHandling:Boolean = true;
      
      private var _styleSheet:StyleSheet;
      
      private var _fontFamily:String;
      
      private var _fontSize:Number;
      
      private var _fontColor:Number;
      
      private var _fontLeading:Number = 0;
      
      private var _fontThickness:Number;
      
      private var _text:String;
      
      private var _field:TextField;
      
      private var _cachePolicy:Boolean = false;
      
      public function Label(text:String = "", x:Number = 0, y:Number = 0, styleId:String = "p")
      {
         super();
         this.x = x;
         this.y = y;
         setStyleById(styleId);
         this._text = text;
         this._field = new TextField();
         addChild(this._field);
         this._field.antiAliasType = AntiAliasType.ADVANCED;
         this._field.wordWrap = false;
         this._field.multiline = false;
         this._field.embedFonts = true;
         this._field.addEventListener(TextEvent.LINK,this.linkHandler);
         this._field.autoSize = TextFieldAutoSize.LEFT;
         this.selectable = false;
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      override public function destroy() : void
      {
         this._styleSheet = null;
         this._text = null;
         super.destroy();
      }
      
      override public function measure() : void
      {
         var format:TextFormat = null;
         this._field.cacheAsBitmap = false;
         this._field.embedFonts = style.embedFonts;
         if(style.styleSheet != null)
         {
            this._field.styleSheet = style.styleSheet;
         }
         if(this._styleSheet != null)
         {
            this._field.styleSheet = this._styleSheet;
         }
         else
         {
            this._field.styleSheet = null;
         }
         if(this._field.styleSheet == null)
         {
            format = style.textFormat;
            if(this.fontFamily)
            {
               format.font = this.fontFamily;
            }
            if(!isNaN(this.fontSize))
            {
               format.size = this.fontSize;
            }
            if(!isNaN(this.fontColor))
            {
               format.color = this.fontColor;
            }
            if(!isNaN(this.fontLeading))
            {
               format.leading = this.fontLeading;
            }
            this._field.thickness = getValidValue(this.fontThickness,style.fontThickness,0);
            this._field.defaultTextFormat = format;
            this._field.setTextFormat(format);
            this._field.alpha = GraphicUtil.getAlpha(getValidValue(this.fontColor,style.fontColor));
         }
         if(this._text != null)
         {
            this._field.htmlText = this.text;
         }
         measuredWidth = this._field.width;
         measuredHeight = this._field.height;
         if(this._cachePolicy)
         {
            this._field.cacheAsBitmap = true;
         }
      }
      
      private function linkHandler(evt:flash.events.TextEvent) : void
      {
         if(!this.defaultLinkHandling)
         {
            return;
         }
         this.dispatchTextEvent(evt.text);
      }
      
      public function dispatchTextEvent(text:String) : void
      {
         var textEvent:iilwy.events.TextEvent = new iilwy.events.TextEvent(TextEvent.TEXT_LINK_CLICKED,true,true);
         textEvent.text = text;
         this.dispatchEvent(textEvent);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(this._cachePolicy)
         {
            this._field.cacheAsBitmap = true;
         }
         if(this._field.autoSize != TextFieldAutoSize.NONE)
         {
            return;
         }
         this._field.width = unscaledWidth;
         this._field.height = unscaledHeight;
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(value:StyleSheet) : void
      {
         this._styleSheet = value;
         invalidateDisplayList();
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(value:String) : void
      {
         this._fontFamily = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get fontSize() : Number
      {
         return this._fontSize;
      }
      
      public function set fontSize(value:Number) : void
      {
         this._fontSize = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get fontColor() : Number
      {
         return this._fontColor;
      }
      
      public function set fontColor(value:Number) : void
      {
         this._fontColor = value;
         invalidateDisplayList();
         invalidateSize();
      }
      
      public function get fontLeading() : Number
      {
         return this._fontLeading;
      }
      
      public function set fontLeading(value:Number) : void
      {
         this._fontLeading = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get fontThickness() : Number
      {
         return this._fontThickness;
      }
      
      public function set fontThickness(value:Number) : void
      {
         this._fontThickness = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         this._field.text = "";
         this._text = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get htmlText() : String
      {
         return this._text;
      }
      
      public function set htmlText(value:String) : void
      {
         this._field.text = "";
         this._text = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get selectable() : Boolean
      {
         return this._field.selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         this._field.selectable = value;
      }
      
      public function get autoSize() : String
      {
         return this._field.autoSize;
      }
      
      public function set autoSize(value:String) : void
      {
         this._field.autoSize = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get field() : TextField
      {
         return this._field;
      }
      
      public function get cachePolicy() : Boolean
      {
         return this._cachePolicy;
      }
      
      public function set cachePolicy(value:Boolean) : void
      {
         this._cachePolicy = value;
         this._field.cacheAsBitmap = value;
      }
   }
}
