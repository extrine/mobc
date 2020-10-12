package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.utils.MathUtil;
   
   public class TextBlock extends UiElement implements IScrollable
   {
       
      
      public var _field:TextField;
      
      private var _viewableLines:Number;
      
      private var _text:String;
      
      protected var _backgroundColor:Number;
      
      protected var _borderColor:Number;
      
      private var _styleSheet:StyleSheet;
      
      public var fontSize:Number;
      
      public var fontAlign:String;
      
      public var fontColor:Number;
      
      public var fontFace:String;
      
      public var fontLeading:Number;
      
      public var fixScrollPosition:Boolean;
      
      private var _scrollAmount:Number = 0;
      
      private var _scrollWheelEnabled:Boolean = false;
      
      public var defaultLinkHandling:Boolean = true;
      
      private var _cachePolicy:Boolean = false;
      
      public function TextBlock(text:String = null, x:Number = 0, y:Number = 0, width:Number = 200, height:Number = undefined, styleId:String = "p")
      {
         super();
         this.x = x;
         this.y = y;
         setStyleById(styleId);
         this._text = text;
         this._field = new TextField();
         addChild(this._field);
         this._field.antiAliasType = AntiAliasType.ADVANCED;
         this._field.embedFonts = true;
         this._field.multiline = true;
         this._field.wordWrap = true;
         this._field.addEventListener(Event.SCROLL,this.onFieldScroll);
         this._field.addEventListener(TextEvent.LINK,this.linkHandler);
         this.width = width;
         this.height = height;
         mouseChildren = true;
         mouseEnabled = true;
      }
      
      override public function destroy() : void
      {
         if(this._scrollWheelEnabled)
         {
            this._styleSheet = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onWaitFrameToUpdate);
         this._field.removeEventListener(Event.SCROLL,this.onFieldScroll);
         removeChild(this._field);
         this._text = null;
         this._field = null;
         super.destroy();
      }
      
      public function enableScrollWheel() : void
      {
         if(!this._scrollWheelEnabled)
         {
            this.listenForMouseWheel();
         }
         this._scrollWheelEnabled = true;
      }
      
      public function disableScrollWheel() : void
      {
         if(this._scrollWheelEnabled)
         {
            this._scrollWheelEnabled = false;
         }
      }
      
      override public function measure() : void
      {
         if(isNaN(explicitHeight))
         {
            this.updateTextField();
            measuredHeight = this._field.height;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._field.cacheAsBitmap = false;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.updateTextField();
         addEventListener(Event.ENTER_FRAME,this.onWaitFrameToUpdate);
      }
      
      private function onWaitFrameToUpdate(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onWaitFrameToUpdate);
         if(!isNaN(explicitHeight))
         {
            this._viewableLines = this._field.bottomScrollV - this._field.scrollV;
         }
         if(this._cachePolicy)
         {
            this._field.cacheAsBitmap = true;
         }
         if(!this.fixScrollPosition || this.scrollAmount >= 0.99)
         {
            this.scrollAmount = this._scrollAmount;
         }
         this.dispatchContentChangedEvent();
      }
      
      public function updateTextField() : void
      {
         var tmpBorderColor:Number = NaN;
         var fmt:TextFormat = null;
         this._field.htmlText = "";
         this._field.embedFonts = style.embedFonts;
         if(this._styleSheet != null)
         {
            this._field.styleSheet = this._styleSheet;
         }
         else if(style.styleSheet != null)
         {
            this._field.styleSheet = style.styleSheet;
         }
         else
         {
            this._field.styleSheet = null;
         }
         if(this._text != null)
         {
            this._field.htmlText = this._text;
         }
         else
         {
            this._field.htmlText = "";
         }
         if(this._field.styleSheet == null)
         {
            fmt = style.textFormat;
            if(!isNaN(this.fontColor))
            {
               fmt.color = this.fontColor;
            }
            if(!isNaN(this.fontSize))
            {
               fmt.size = this.fontSize;
            }
            if(this.fontAlign != null)
            {
               fmt.align = this.fontAlign;
            }
            if(this.fontFace != null)
            {
               fmt.font = this.fontFace;
            }
            if(!isNaN(this.fontLeading))
            {
               fmt.leading = this.fontLeading;
            }
            this._field.setTextFormat(fmt);
            this._field.defaultTextFormat = fmt;
         }
         if(isNaN(style.borderColor))
         {
            tmpBorderColor = style.borderColor;
         }
         if(!isNaN(this._borderColor))
         {
            tmpBorderColor = this._borderColor;
         }
         if(!isNaN(tmpBorderColor))
         {
            this._field.border = true;
            this._field.borderColor = tmpBorderColor;
         }
         if(!this.fixScrollPosition || this.scrollAmount >= 0.99)
         {
            this.scrollAmount = this._scrollAmount;
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
      
      protected function onFieldScroll(event:Event) : void
      {
         event.stopImmediatePropagation();
         this.dispatchScrollEvent();
      }
      
      public function get htmlText() : String
      {
         return this._text;
      }
      
      public function set htmlText(s:String) : void
      {
         this._text = s;
         if(isNaN(explicitHeight))
         {
            invalidateSize();
         }
         invalidateDisplayList();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(s:String) : void
      {
         this._text = s;
         if(isNaN(explicitHeight))
         {
            invalidateSize();
         }
         invalidateDisplayList();
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(stylesheet:StyleSheet) : void
      {
         this._styleSheet = stylesheet;
         invalidateDisplayList();
      }
      
      public function get borderColor() : Number
      {
         return this._borderColor;
      }
      
      public function set borderColor(n:Number) : void
      {
         this._borderColor = n;
      }
      
      public function get backgroundColor() : Number
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(n:Number) : void
      {
         this._backgroundColor = n;
         invalidateDisplayList();
      }
      
      public function get selectable() : Boolean
      {
         return this._field.selectable;
      }
      
      public function set selectable(b:Boolean) : void
      {
         this._field.selectable = b;
      }
      
      public function get field() : TextField
      {
         return this._field;
      }
      
      public function dispatchContentChangedEvent() : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_CHANGE));
      }
      
      public function dispatchScrollEvent() : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
      }
      
      public function getConcreteDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getWindowToContentRatio() : Number
      {
         var w:Number = this._viewableLines;
         var c:Number = this._field.maxScrollV + this._viewableLines;
         var ratio:Number = w / c;
         if(this._field.maxScrollV <= 1)
         {
            ratio = 1;
         }
         return Math.max(0,ratio);
      }
      
      public function set scrollAmount(amount:Number) : void
      {
         this._scrollAmount = MathUtil.clamp(0,1,amount);
         this._field.scrollV = this._field.maxScrollV * this._scrollAmount;
         this.dispatchScrollEvent();
      }
      
      public function get scrollAmount() : Number
      {
         return this._scrollAmount;
      }
      
      public function listenForMouseWheel() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var value:Number = event.delta < 0?Number(1):Number(-1);
         this.incrementScrollAmount(value);
      }
      
      public function incrementScrollAmount(direction:Number, multiple:Number = 1) : void
      {
         var percent:Number = 1 / this._field.maxScrollV;
         this.scrollAmount = this.scrollAmount + percent * direction * multiple;
      }
      
      override public function set width(n:Number) : void
      {
         if(!isNaN(n))
         {
            this._field.width = n;
         }
         super.width = n;
      }
      
      override public function set height(n:Number) : void
      {
         if(!isNaN(n))
         {
            this._field.autoSize = TextFieldAutoSize.NONE;
            this._field.height = n;
         }
         else
         {
            this._field.autoSize = TextFieldAutoSize.LEFT;
         }
         super.height = n;
      }
      
      public function get cachePolicy() : Boolean
      {
         return this._cachePolicy;
      }
      
      public function set cachePolicy(b:Boolean) : void
      {
         this._cachePolicy = b;
         this._field.cacheAsBitmap = b;
      }
   }
}
