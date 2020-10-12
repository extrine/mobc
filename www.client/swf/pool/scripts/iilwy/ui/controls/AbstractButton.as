package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import iilwy.display.core.TooltipManager;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class AbstractButton extends UiElement
   {
      
      protected static var focusFilter:GlowFilter;
       
      
      public var useFocusGlow:Boolean = false;
      
      public var tooltip:String;
      
      public var tooltipAlign:String;
      
      public var tooltipDelay:Number = 600;
      
      public var repeat:Boolean = false;
      
      public var repeatRate:Number = 100;
      
      public var repeatDelay:Number = 400;
      
      protected var currentState:String;
      
      protected var focused:Boolean = false;
      
      protected var tooltipManager:TooltipManager;
      
      protected var tooltipAutoDisabled:Boolean;
      
      protected var repeatTimer:Timer;
      
      protected var _hit:Sprite;
      
      protected var _label:String;
      
      protected var _sublabel:String;
      
      protected var _countLabel:String;
      
      protected var _fontSize:Number;
      
      protected var _fontColor:Number;
      
      protected var _fontThickness:Number;
      
      protected var _fontAlign:String;
      
      protected var _fontLeading:Number;
      
      protected var _subFontSize:Number;
      
      protected var _subFontColor:Number;
      
      protected var _subFontThickness:Number;
      
      protected var _subFontAlign:String;
      
      protected var _icon:Class;
      
      protected var _iconColor:Number;
      
      protected var _iconAlign:String;
      
      protected var _itemPadding:Number;
      
      protected var _cornerRadius:Number;
      
      protected var _borderSize:Number;
      
      protected var _capType:String;
      
      protected var _toggle:Boolean = false;
      
      protected var _enabled:Boolean = true;
      
      protected var _selected:Boolean = false;
      
      public function AbstractButton(label:String, x:Number, y:Number, width:Number, height:Number, styleID:String)
      {
         var AppComponents:* = undefined;
         this.tooltipAlign = ControlAlign.RIGHT;
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         try
         {
            AppComponents = getDefinitionByName("iilwy.application.AppComponents") as Class;
         }
         catch(error:Error)
         {
         }
         this.tooltipManager = AppComponents && AppComponents.tooltipManager?AppComponents.tooltipManager:null;
         setStyleById(styleID);
         this.label = label;
         this._hit = new Sprite();
         addChild(this._hit);
         UiRender.renderRect(this._hit,33488896,0,0,1,1);
         this._hit.width = width;
         this._hit.height = height;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.setState(ControlState.DEFAULT);
         mouseChildren = false;
         mouseEnabled = true;
         useHandCursor = true;
         buttonMode = true;
         this.enabled = true;
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         if(this.repeatTimer != null)
         {
            this.repeatTimer.removeEventListener(TimerEvent.TIMER,this.onRepeat);
         }
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._hit.width = unscaledWidth;
         this._hit.height = unscaledHeight;
         this.updateState(this.currentState);
      }
      
      public function get hit() : Sprite
      {
         return this._hit;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get sublabel() : String
      {
         return this._sublabel;
      }
      
      public function set sublabel(value:String) : void
      {
         this._sublabel = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get countLabel() : String
      {
         return this._countLabel;
      }
      
      public function set countLabel(value:String) : void
      {
         this._countLabel = value;
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
      
      public function get fontAlign() : String
      {
         return this._fontAlign;
      }
      
      public function set fontAlign(value:String) : void
      {
         this._fontAlign = value;
         invalidateDisplayList();
      }
      
      public function get fontLeading() : Number
      {
         return this._fontLeading;
      }
      
      public function set fontLeading(value:Number) : void
      {
         this._fontLeading = value;
         invalidateDisplayList();
      }
      
      public function get subFontSize() : Number
      {
         return this._subFontSize;
      }
      
      public function set subFontSize(value:Number) : void
      {
         this._subFontSize = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get subFontColor() : Number
      {
         return this._subFontColor;
      }
      
      public function set subFontColor(value:Number) : void
      {
         this._subFontColor = value;
         invalidateDisplayList();
      }
      
      public function get subFontThickness() : Number
      {
         return this._subFontThickness;
      }
      
      public function set subFontThickness(value:Number) : void
      {
         this._subFontThickness = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get subFontAlign() : String
      {
         return this._subFontAlign;
      }
      
      public function set subFontAlign(value:String) : void
      {
         this._subFontAlign = value;
         invalidateDisplayList();
      }
      
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(value:Class) : void
      {
         this._icon = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get iconColor() : Number
      {
         return this._iconColor;
      }
      
      public function set iconColor(value:Number) : void
      {
         this._iconColor = value;
         invalidateDisplayList();
      }
      
      public function get iconAlign() : String
      {
         return this._iconAlign;
      }
      
      public function set iconAlign(value:String) : void
      {
         this._iconAlign = value;
         invalidateDisplayList();
         invalidateSize();
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(value:Number) : void
      {
         this._itemPadding = value;
         invalidateDisplayList();
         invalidateSize();
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(value:Number) : void
      {
         this._cornerRadius = value;
         invalidateDisplayList();
      }
      
      public function get borderSize() : Number
      {
         return this._borderSize;
      }
      
      public function set borderSize(value:Number) : void
      {
         this._borderSize = value;
         invalidateDisplayList();
      }
      
      public function get capType() : String
      {
         return this._capType;
      }
      
      public function set capType(value:String) : void
      {
         this._capType = value;
         invalidateDisplayList();
      }
      
      public function get toggle() : Boolean
      {
         return this._toggle;
      }
      
      public function set toggle(value:Boolean) : void
      {
         this._toggle = value;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(value)
         {
            useHandCursor = true;
         }
         else
         {
            useHandCursor = false;
         }
         this._enabled = value;
         invalidateDisplayList();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         var rect:Rectangle = new Rectangle(0,0,width,height);
         if(!rect.contains(mouseX,mouseY))
         {
            this.setState(ControlState.DEFAULT);
         }
         invalidateDisplayList();
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.setState(ControlState.DOWN);
         }
      }
      
      protected function onKeyUp(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.onClick(null);
         }
      }
      
      protected function onFocusIn(event:FocusEvent) : void
      {
         var rect:Rectangle = new Rectangle(0,0,width,height);
         if(rect.contains(mouseX,mouseY))
         {
         }
         this.focused = true;
         invalidateDisplayList();
      }
      
      protected function onFocusOut(event:FocusEvent) : void
      {
         this.focused = false;
         invalidateDisplayList();
      }
      
      public function showTooltip() : void
      {
         if(this.tooltipManager && this.tooltip)
         {
            this.tooltipManager.showTooltip(this.tooltip,this,this.tooltipAlign,this.tooltipDelay);
         }
      }
      
      protected function onMouseEvent(event:MouseEvent) : void
      {
         if(event.type == MouseEvent.MOUSE_OVER)
         {
            this.setState(ControlState.OVER);
            dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER,this));
            if(!event.buttonDown)
            {
               this.showTooltip();
            }
         }
         else if(event.type == MouseEvent.MOUSE_OUT)
         {
            this.setState(ControlState.DEFAULT);
            dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT,this));
            if(this.tooltipManager && this.tooltip)
            {
               this.tooltipManager.hideTooltip();
            }
            this.tooltipAutoDisabled = false;
         }
         else if(event.type == MouseEvent.MOUSE_DOWN)
         {
            this.setState(ControlState.DOWN);
            dispatchEvent(new ButtonEvent(ButtonEvent.DOWN,this));
            StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
            if(this.tooltipManager && this.tooltip)
            {
               this.tooltipManager.hideTooltip();
            }
            this.startRepeat();
         }
         else if(event.type == MouseEvent.MOUSE_UP)
         {
            dispatchEvent(new ButtonEvent(ButtonEvent.UP,this));
            StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
            this.stopRepeat();
         }
      }
      
      protected function onStageUp(event:MouseEvent) : void
      {
      }
      
      public function onClick(event:MouseEvent) : void
      {
         var rect:Rectangle = null;
         if(this._enabled)
         {
            if(this._toggle)
            {
               this._selected = !this._selected;
               this.setState(ControlState.DEFAULT);
               dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED,this,this._selected));
            }
            else
            {
               dispatchEvent(new ButtonEvent(ButtonEvent.CLICK,this));
               rect = new Rectangle(0,0,width,height);
               if(rect.contains(mouseX,mouseY))
               {
                  this.setState(ControlState.OVER);
               }
               else
               {
                  this.setState(ControlState.DEFAULT);
               }
            }
         }
      }
      
      public function startRepeat() : void
      {
         if(this.repeat)
         {
            if(this.repeatTimer == null)
            {
               this.repeatTimer = new Timer(100);
               this.repeatTimer.addEventListener(TimerEvent.TIMER,this.onRepeat);
            }
            this.repeatTimer.reset();
            this.repeatTimer.delay = this.repeatDelay;
            this.repeatTimer.start();
         }
      }
      
      public function stopRepeat() : void
      {
         if(this.repeat)
         {
            if(this.repeatTimer)
            {
               this.repeatTimer.stop();
            }
         }
      }
      
      public function onRepeat(event:TimerEvent) : void
      {
         if(this.repeatTimer.currentCount == 1)
         {
            this.repeatTimer.delay = this.repeatRate;
         }
         else if(this.repeatTimer.currentCount > 3)
         {
            this.repeatTimer.delay = this.repeatRate / 2;
         }
         var rect:Rectangle = new Rectangle(0,0,width,height);
         if(rect.contains(mouseX,mouseY))
         {
            dispatchEvent(new ButtonEvent(ButtonEvent.REPEAT,this));
         }
      }
      
      public function setState(state:String) : void
      {
         this.currentState = state;
         invalidateDisplayList();
      }
      
      protected function updateState(state:String) : void
      {
         if(state == ControlState.FOCUSED)
         {
            if(this.enabled)
            {
               if(this.selected)
               {
                  this.applySubStyle(style.focused,style.selectedOver,style.selected,style.down);
               }
               else
               {
                  this.applySubStyle(style.focused,style.over);
               }
            }
         }
         else if(state == ControlState.OVER)
         {
            if(!this.enabled)
            {
               if(this.selected)
               {
                  this.applySubStyle(style.disabledSelectedOver,style.disabledSelected,style.disabled);
               }
               else
               {
                  this.applySubStyle(style.disabledOver,style.disabled);
               }
            }
            else if(this.selected)
            {
               this.applySubStyle(style.selectedOver,style.selected,style.down);
            }
            else if(this.focused)
            {
               this.applySubStyle(style.focusedOver,style.over);
            }
            else
            {
               this.applySubStyle(style.over);
            }
         }
         else if(state == ControlState.DEFAULT)
         {
            if(!this.enabled)
            {
               if(this.selected)
               {
                  this.applySubStyle(style.disabledSelected,style.disabled);
               }
               else
               {
                  this.applySubStyle(style.disabled);
               }
            }
            else if(this.selected)
            {
               this.applySubStyle(style.selected,style.down);
            }
            else if(this.focused)
            {
               this.applySubStyle(style.focused,style.over);
            }
            else
            {
               this.applySubStyle(style.up);
            }
         }
         else if(state == ControlState.UP)
         {
            this.applySubStyle(style.up);
         }
         else if(state == ControlState.DOWN)
         {
            if(this.enabled)
            {
               this.applySubStyle(style.down);
            }
         }
         else
         {
            this.applySubStyle(style);
         }
      }
      
      protected function applySubStyle(... options) : void
      {
      }
   }
}
