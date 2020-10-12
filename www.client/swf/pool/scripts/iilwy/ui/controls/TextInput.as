package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   import iilwy.display.core.TooltipManager;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.ControlState;
   import iilwy.ui.utils.Skin;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class TextInput extends UiElement
   {
      
      public static var embeddingEnabled:Boolean = true;
      
      public static var deviceFont:String;
      
      protected static var _focusFilter:GlowFilter;
       
      
      public var tooltip:String;
      
      public var tooltipAlign:String;
      
      public var fontSize:Number;
      
      public var allowAutoFill:Boolean = false;
      
      public var useFocusGlow:Boolean = false;
      
      public var cornerRadius:Number;
      
      protected var _field:TextField;
      
      protected var _helpField:TextField;
      
      protected var _skin:Skin;
      
      protected var _focused:Boolean = false;
      
      protected var _iconAsset:Class;
      
      protected var _iconHolder:Sprite;
      
      protected var _iconSprite:Sprite;
      
      protected var _iconValid:Boolean = true;
      
      private var AppComponents;
      
      private var _tabEnabled:Boolean;
      
      private var _embedFonts:Boolean = true;
      
      private var _textFieldValid:Boolean = false;
      
      private var _currentState:String;
      
      private var _enabled:Boolean = true;
      
      private var _helpTip:ITooltip;
      
      private var _helpText:String;
      
      public function TextInput(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 30, styleId:String = "textInput")
      {
         this.tooltipAlign = ControlAlign.RIGHT;
         super();
         try
         {
            this.AppComponents = getDefinitionByName("iilwy.application.AppComponents") as Class;
         }
         catch(error:Error)
         {
         }
         setStyleById(styleId);
         this._skin = new Skin();
         addChild(this._skin);
         this._skin.renderMethod = this.renderSkinState;
         this.createTextField();
         this._iconHolder = new Sprite();
         addChild(this._iconHolder);
         this._field.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this._field.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         addEventListener(FocusEvent.FOCUS_IN,this.onSelfFocusIn);
         addEventListener(Event.CHANGE,this.onChanged);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.setState(ControlState.UNFOCUSED);
         this.tabEnabled = true;
         mouseEnabled = true;
         mouseChildren = true;
         setPadding(5,0,0,5);
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
      }
      
      public static function disableEmbedding() : void
      {
         var match:Font = null;
         var font:Font = null;
         embeddingEnabled = false;
         var allFonts:Array = Font.enumerateFonts(true);
         var matches:Array = [];
         for each(font in allFonts)
         {
            if(font.fontName.toLowerCase() == "arial" || font.fontName.toLowerCase() == "verdana")
            {
               matches.push(font);
            }
         }
         if(matches.length < 1)
         {
            TextInput.deviceFont = "_sans";
         }
         else
         {
            TextInput.deviceFont = Font(matches[0]).fontName;
         }
         trace("disabled embedding",TextInput.deviceFont);
      }
      
      override public function get tabIndex() : int
      {
         return this._field.tabIndex;
      }
      
      override public function set tabIndex(value:int) : void
      {
         this._field.tabIndex = value;
      }
      
      override public function get tabEnabled() : Boolean
      {
         return this._tabEnabled;
      }
      
      override public function set tabEnabled(value:Boolean) : void
      {
         tabChildren = value;
         if(this._field != null)
         {
            this._field.tabEnabled = value;
         }
         this._tabEnabled = value;
      }
      
      override public function set style(value:Style) : void
      {
         if(value && value.type == "simple")
         {
            this.useFocusGlow = true;
         }
         else
         {
            this.useFocusGlow = false;
         }
         super.style = value;
      }
      
      override public function set width(value:Number) : void
      {
         if(!isNaN(value))
         {
            this._field.width = value - 6;
            if(this._helpField)
            {
               this._helpField.width = this._field.width;
            }
         }
         super.width = value;
      }
      
      override public function set height(value:Number) : void
      {
         if(!isNaN(value))
         {
            this._field.height = value - 6;
            if(this._helpField)
            {
               this._helpField.height = this._field.height;
            }
         }
         super.height = value;
      }
      
      override public function destroy() : void
      {
         if(this._helpTip)
         {
            this._helpTip.destroy();
         }
         this._skin.destroy();
         super.destroy();
      }
      
      override public function commitProperties() : void
      {
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var iconPadding:Number = NaN;
         if(!this._iconValid)
         {
            this._iconValid = true;
            if(this._iconSprite && this._iconHolder.contains(this._iconSprite))
            {
               this._iconHolder.removeChild(this._iconSprite);
            }
            if(this._iconAsset)
            {
               this._iconSprite = new this._iconAsset();
               this._iconHolder.addChild(this._iconSprite);
               GraphicUtil.setColor(this._iconHolder,getValidValue(style.iconColor,10066329));
            }
         }
         if(this._iconAsset)
         {
            iconPadding = 10;
            GraphicUtil.fitInto(this._iconHolder,0,iconPadding,unscaledHeight - iconPadding - iconPadding,unscaledHeight - iconPadding - iconPadding);
            this._iconHolder.x = unscaledWidth - iconPadding - this._iconHolder.width;
         }
         this.updateTextField(unscaledWidth,unscaledHeight);
         this.setState(this._currentState);
      }
      
      public function get icon() : Class
      {
         return this._iconAsset;
      }
      
      public function set icon(value:Class) : void
      {
         this._iconAsset = value;
         this._iconValid = false;
         invalidateDisplayList();
      }
      
      public function get text() : String
      {
         return this._field.text;
      }
      
      public function set text(value:String) : void
      {
         try
         {
            this._field.text = value;
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function get htmlText() : String
      {
         return this._field.htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         try
         {
            this._field.text = value;
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function get helpText() : String
      {
         return this._helpText;
      }
      
      public function set helpText(value:String) : void
      {
         this._helpText = value;
         if(this._helpText != null)
         {
            if(this._helpField == null)
            {
               this._helpField = new TextField();
               this._helpField.embedFonts = this._embedFonts;
               this._helpField.antiAliasType = AntiAliasType.ADVANCED;
               this._helpField.selectable = false;
               this._helpField.mouseEnabled = false;
               this._helpField.width = 200;
               this._helpField.height = 200;
               this._helpField.alpha = 0.6;
               addChild(this._helpField);
            }
         }
         this._helpField.text = value;
         invalidateDisplayList();
      }
      
      public function get length() : Number
      {
         return this._field.length;
      }
      
      public function get maxChars() : Number
      {
         return this._field.maxChars;
      }
      
      public function set maxChars(value:Number) : void
      {
         this._field.maxChars = value;
      }
      
      public function get multiline() : Boolean
      {
         return this._field.multiline;
      }
      
      public function set multiline(value:Boolean) : void
      {
         this._field.multiline = value;
         this._field.wordWrap = value;
         invalidateDisplayList();
      }
      
      public function get restrict() : String
      {
         return this._field.restrict;
      }
      
      public function set restrict(value:String) : void
      {
         this._field.restrict = value;
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(value:Boolean) : void
      {
         this._embedFonts = value;
         this._textFieldValid = false;
         invalidateDisplayList();
      }
      
      public function get topTextPadding() : int
      {
         return padding.top;
      }
      
      public function set topTextPadding(value:int) : void
      {
         padding.top = value;
         invalidateDisplayList();
      }
      
      public function get value() : String
      {
         return this._field.text;
      }
      
      public function set value(value:String) : void
      {
         this._field.text = value;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(value)
         {
            this.setState(ControlState.UNFOCUSED);
            this._focused = false;
            this._field.selectable = true;
            mouseChildren = true;
         }
         else
         {
            this.setState(ControlState.DISABLED);
            this._field.selectable = false;
            mouseChildren = false;
         }
      }
      
      public function get field() : TextField
      {
         return this._field;
      }
      
      public function clear() : void
      {
         this.text = "";
      }
      
      public function setFocus() : void
      {
         stage.focus = this;
      }
      
      public function showError(str:String) : void
      {
         var TooltipClass:Class = null;
         if(stage == null)
         {
            return;
         }
         if(str == null)
         {
            return;
         }
         if(!this._helpTip)
         {
            try
            {
               TooltipClass = getDefinitionByName("iilwy.ui.controls.Tooltip") as Class;
            }
            catch(error:Error)
            {
            }
            if(TooltipClass)
            {
               this._helpTip = new TooltipClass();
               this._helpTip.constrainTo = new Rectangle(-9999,-9999,99999999,9999999);
               this._helpTip.setStyleById("errorTooltip");
            }
         }
         try
         {
            this.AppComponents.popupManager.addInfoWindow(this._helpTip as Sprite);
            this._helpTip.showText(str,this,this.tooltipAlign,0,0,100);
            this.AppComponents.tooltipManager.hideTooltip();
         }
         catch(error:Error)
         {
         }
      }
      
      public function hideError() : void
      {
         try
         {
            this.AppComponents.popupManager.removeInfoWindow(this._helpTip as Sprite);
         }
         catch(error:Error)
         {
         }
      }
      
      public function saveAutoFill() : void
      {
         if(!this.allowAutoFill)
         {
            return;
         }
         try
         {
            this.AppComponents.localStore.saveFormValue(this.name,this.value);
         }
         catch(error:Error)
         {
         }
      }
      
      public function autoFill() : void
      {
         if(!this.allowAutoFill)
         {
            return;
         }
         try
         {
            this.value = this.AppComponents.localStore.getFormValue(this.name)[0];
         }
         catch(error:Error)
         {
         }
      }
      
      protected function createTextField() : void
      {
         this._field = new TextField();
         addChild(this._field);
         this._field.x = 3;
         this._field.y = 0;
         this._field.type = TextFieldType.INPUT;
      }
      
      protected function updateTextField(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._field.width = unscaledWidth - 6;
         if(this._field.multiline)
         {
            this._field.x = padding.left;
            this._field.y = padding.top;
            this._field.height = unscaledHeight - 6;
         }
         else
         {
            this._field.x = padding.left;
            this._field.height = getValidValue(this.fontSize,style.fontSize) * 1.5;
            this._field.y = Math.floor((unscaledHeight - this._field.height) / 2);
         }
         if(this._helpField)
         {
            this._helpField.x = this._field.x;
            this._helpField.y = this._field.y;
            this._helpField.height = this._field.height;
         }
         if(this._textFieldValid == false)
         {
            if(TextInput.embeddingEnabled)
            {
               this._field.embedFonts = this._embedFonts;
               this._field.antiAliasType = AntiAliasType.ADVANCED;
            }
            else
            {
               this._field.embedFonts = false;
            }
            this._textFieldValid = true;
         }
      }
      
      protected function setState(state:String) : void
      {
         if(this.useFocusGlow)
         {
            if(this._focused)
            {
               if(!TextInput._focusFilter)
               {
                  TextInput._focusFilter = new GlowFilter(13093089,0.4,5,5,4,1,false,false);
               }
               this._skin.filters = [TextInput._focusFilter];
            }
            else
            {
               this._skin.filters = [];
            }
         }
         var fmt:TextFormat = style.textFormat;
         if(state == ControlState.FOCUSED)
         {
            this._skin.setStyle(style.focused);
            fmt = style.focused.textFormat;
         }
         else if(state == ControlState.UNFOCUSED)
         {
            this._skin.setStyle(style.unfocused);
            fmt = style.unfocused.textFormat;
         }
         else if(state == ControlState.ERROR)
         {
            this._skin.setStyle(style.error);
            fmt = style.error.textFormat;
         }
         else if(state == ControlState.DISABLED)
         {
            this._skin.setStyle(style.disabled);
            fmt = style.disabled.textFormat;
         }
         if(this._helpField)
         {
            this._helpField.defaultTextFormat = fmt;
            this._helpField.setTextFormat(fmt);
         }
         if(!TextInput.embeddingEnabled && this._embedFonts == true)
         {
            fmt.font = TextInput.deviceFont;
         }
         fmt.size = getValidValue(this.fontSize,fmt.size);
         this._field.defaultTextFormat = fmt;
         this._field.setTextFormat(fmt);
         this._field.alpha = GraphicUtil.getAlpha(style.fontColor);
         if(this._helpField)
         {
            this._helpField.visible = !this._focused && this.text.length < 1;
         }
         if(this._focused)
         {
            if(this.tooltip != null)
            {
               try
               {
                  this.AppComponents.tooltipManager.showTooltip(this.tooltip,this,this.tooltipAlign,TooltipManager.DELAY_MINIMUM);
               }
               catch(error:Error)
               {
               }
            }
         }
         else if(this.tooltip != null)
         {
            try
            {
               this.AppComponents.tooltipManager.hideTooltip();
            }
            catch(error:Error)
            {
            }
         }
         this._currentState = state;
      }
      
      protected function renderSkinState(style:Style) : BitmapData
      {
         var radius:Number = NaN;
         var fill:Array = null;
         var stroke:Number = NaN;
         var canvas:Sprite = new Sprite();
         if(style.type == "simple")
         {
            radius = getValidValue(this.cornerRadius,style.cornerRadius,height);
            if(!isNaN(style.backgroundColor))
            {
               fill = [style.backgroundColor,style.backgroundColor];
            }
            else if(style.backgroundGradient != null)
            {
               fill = style.backgroundGradient;
            }
            UiRender.renderGradient(canvas,fill,0.5 * Math.PI,0,0,width,height,radius);
            if(!isNaN(style.borderColor))
            {
               stroke = !isNaN(style.borderSize)?Number(style.borderSize):Number(1);
               canvas.graphics.lineStyle(stroke,style.borderColor,GraphicUtil.getAlpha(style.borderColor),false);
               canvas.graphics.drawRoundRect(stroke / 2,stroke / 2,width - stroke,height - stroke,radius,radius);
            }
         }
         else
         {
            UiRender.renderBorderBox(canvas,style,width,height);
            if(!isNaN(style.accentColor))
            {
               UiRender.renderStripes(canvas,style.accentColor,10,5,5,width - 10,height - 10);
            }
            UiRender.renderSimpleGradient(canvas,style.gradientColor,1.5 * Math.PI,5,5,width - 10,20);
         }
         return GraphicUtil.makeBitmapData(canvas,width,height);
      }
      
      public function onChanged(event:Event) : void
      {
         if(this._helpTip)
         {
            this.hideError();
         }
         if(this._helpField)
         {
            this._helpField.visible = !this._focused && this.text.length < 1;
         }
      }
      
      public function onRemovedFromStage(event:Event) : void
      {
         this.hideError();
         if(this._helpField)
         {
            this._helpField.visible = !this._focused && this.text.length < 1;
         }
      }
      
      protected function onSelfFocusIn(event:FocusEvent) : void
      {
         if(event.target == this && stage != null)
         {
            stage.focus = this._field;
         }
      }
      
      protected function onFocusIn(event:FocusEvent) : void
      {
         this._focused = true;
         this.setState(ControlState.FOCUSED);
         this.hideError();
      }
      
      protected function onFocusOut(event:FocusEvent) : void
      {
         this._focused = false;
         this.setState(ControlState.UNFOCUSED);
      }
   }
}
