package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.display.core.FocusManager;
   import iilwy.display.core.WindowManager;
   import iilwy.ui.containers.InfoWindow;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ComboBoxEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class ComboBox extends UiContainer
   {
      
      private static var staticWindow:InfoWindow;
      
      private static var staticList:SimpleMenu;
      
      private static var staticInit:Boolean = false;
       
      
      private var _button:AbstractButton;
      
      private var _arrow:Sprite;
      
      private var _hit:Sprite;
      
      private var _field:TextField;
      
      private var _state:String;
      
      private var _options:Array;
      
      private var _selected:Number;
      
      private var _constrainMenu:Boolean = true;
      
      private var _label:String;
      
      private var _defaultLabel:String;
      
      private var _buttonInvalid:Boolean = true;
      
      private var _delayedShowMenuTimer:Timer;
      
      public var iconPadding:Number = 15;
      
      protected var _data:SimpleMenuDataProvider;
      
      public var updateLabel:Boolean = true;
      
      public var labelPreText:String = "";
      
      public function ComboBox(defaultLabel:String = null, x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 30, styleId:String = "comboBox")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setPadding(0,6);
         if(!staticInit)
         {
            ComboBox.init();
         }
         setStyleById(styleId);
         this._data = new SimpleMenuDataProvider();
         this._defaultLabel = defaultLabel;
         this._label = defaultLabel;
         this._options = new Array();
         this._hit = new Sprite();
         UiRender.renderRect(this._hit,33554431,0,0,10,height);
         this._hit.mouseEnabled = false;
         addContentChild(this._hit);
         this._field = new TextField();
         addContentChild(this._field);
         this._field.autoSize = TextFieldAutoSize.LEFT;
         this._field.selectable = false;
         this._field.embedFonts = true;
         this._field.antiAliasType = AntiAliasType.ADVANCED;
         this._field.mouseEnabled = false;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onButtonKeyDown);
         this._arrow = new Sprite();
         addContentChild(this._arrow);
         UiRender.renderTriangle(this._arrow,0,0,0,10,5);
         this._arrow.mouseEnabled = false;
         tabEnabled = true;
         tabChildren = false;
         addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this._delayedShowMenuTimer = new Timer(150,1);
         this._delayedShowMenuTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.delayedShowMenu);
         this._state = ControlState.COLLAPSED;
         mouseChildren = true;
         mouseEnabled = true;
      }
      
      private static function init() : void
      {
         staticInit = true;
         staticWindow = new InfoWindow();
         staticList = new SimpleMenu();
         staticList.listenForMouseWheel();
      }
      
      override public function destroy() : void
      {
         this.setState(ControlState.COLLAPSED);
         this._field.removeEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         this._button.removeEventListener(ButtonEvent.DOWN,this.onButtonDown);
         this._button.removeEventListener(KeyboardEvent.KEY_DOWN,this.onButtonKeyDown);
         this._delayedShowMenuTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.delayedShowMenu);
         super.destroy();
      }
      
      override public function measure() : void
      {
         this._field.defaultTextFormat = style.textFormat;
         this._field.setTextFormat(style.textFormat);
         if(isNaN(this.selected) || !this.updateLabel)
         {
            this._field.text = this._defaultLabel;
         }
         else
         {
            this._field.text = this.labelPreText + this._label;
         }
         measuredWidth = Math.ceil(padding.left + this._field.width + this.iconPadding + this._arrow.width + padding.right + 3);
      }
      
      override public function set style(s:Style) : void
      {
         this._buttonInvalid = true;
         super.style = s;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(this._buttonInvalid)
         {
            if(this._button != null)
            {
               this._buttonInvalid = false;
               removeContentChild(this._button);
               this._button.destroy();
            }
            if(style.buttonStyleId == "bevelButton")
            {
               this._button = new BevelButton("",0,0,unscaledWidth,unscaledHeight,style.buttonStyleId);
            }
            else if(style.buttonStyleId.indexOf("simpleButton") >= 0)
            {
               this._button = new LiteButton("",0,0,unscaledWidth,unscaledHeight,style.buttonStyleId);
            }
            else if(style.buttonStyleId == "shadedButton")
            {
               this._button = new ShadedButton("",0,0,unscaledWidth,unscaledHeight,style.buttonStyleId);
            }
            addContentChildAt(this._button,0);
            this._button.tabEnabled = false;
         }
         this._hit.width = unscaledWidth;
         this._hit.height = unscaledHeight;
         this._arrow.x = unscaledWidth - padding.right - 3 - this._arrow.width;
         GraphicUtil.setColor(this._arrow,style.iconColor);
         this._button.height = unscaledHeight;
         this._button.width = unscaledWidth;
         this._field.defaultTextFormat = style.textFormat;
         this._field.setTextFormat(style.textFormat);
         this._field.text = this.labelPreText + this._label;
         this._field.x = padding.left;
         this._field.y = Math.round(unscaledHeight / 2) - Math.round(this._field.height / 2);
         this._arrow.y = Math.round(unscaledHeight / 2) - Math.round(this._arrow.height / 2) + 1;
         var arrowColor:ColorTransform = new ColorTransform();
         arrowColor.color = style.iconColor;
         this._arrow.transform.colorTransform = arrowColor;
      }
      
      private function onFocusIn(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            stage.focus = this._button;
         }
      }
      
      private function onButtonDown(event:Event) : void
      {
         if(event.target == this._button)
         {
            if(this._state == ControlState.COLLAPSED)
            {
               this.setState(ControlState.EXPANDED);
            }
            else if(this._state == ControlState.EXPANDED)
            {
               this.setState(ControlState.COLLAPSED);
            }
         }
      }
      
      private function onButtonKeyDown(event:KeyboardEvent) : void
      {
         if(event.target == this._button)
         {
            if(event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
            {
               if(this._state == ControlState.COLLAPSED)
               {
                  this.setState(ControlState.EXPANDED);
               }
            }
         }
      }
      
      private function onListKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            if(this._state == ControlState.EXPANDED)
            {
               this.setState(ControlState.COLLAPSED);
            }
         }
      }
      
      private function onListSelect(event:MultiSelectEvent) : void
      {
         var evt:ComboBoxEvent = null;
         event.stopImmediatePropagation();
         if(this._state == ControlState.EXPANDED)
         {
            this.setSelected(event.selected);
            evt = new ComboBoxEvent(ComboBoxEvent.CHANGED,true,true);
            evt.value = event.value;
            evt.selected = event.selected;
            evt.name = event.label;
            dispatchEvent(evt);
            this.setState(ControlState.COLLAPSED);
         }
      }
      
      private function onClickOut(event:Event) : void
      {
         var gpoint:Point = new Point();
         gpoint = localToGlobal(gpoint);
         var rect1:Rectangle = new Rectangle(gpoint.x,gpoint.y,width,height);
         gpoint = new Point();
         gpoint = staticWindow.localToGlobal(gpoint);
         var rect2:Rectangle = new Rectangle(gpoint.x,gpoint.y,staticWindow.width,staticWindow.height);
         rect2.inflate(5,5);
         var mpoint:Point = new Point(mouseX,mouseY);
         mpoint = localToGlobal(mpoint);
         if(!rect1.containsPoint(mpoint) && !rect2.containsPoint(mpoint))
         {
            this.setState(ControlState.COLLAPSED);
         }
      }
      
      public function setState(state:String) : void
      {
         if(state == ControlState.EXPANDED)
         {
            this._button.selected = true;
            this._delayedShowMenuTimer.reset();
            this._delayedShowMenuTimer.start();
         }
         else if(state == ControlState.COLLAPSED)
         {
            this._button.selected = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onClickOut);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickOut);
            WindowManager.getInstance().removeEventListener(Event.RESIZE,this.onClickOut);
            this.hideMenu();
         }
         this._state = state;
      }
      
      public function delayedShowMenu(event:TimerEvent) : void
      {
         this.showMenu();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onClickOut,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickOut,false,0,true);
         WindowManager.getInstance().addEventListener(Event.RESIZE,this.onClickOut,false,0,true);
      }
      
      public function get value() : String
      {
         return this._data.value;
      }
      
      public function set value(s:String) : void
      {
         var index:int = 0;
         var item:* = undefined;
         this._data.value = s;
         try
         {
            index = this._data.selectedIndex;
            item = this._data.getItemAt(index);
            if(this.updateLabel)
            {
               this._label = item.data.label;
            }
         }
         catch(e:Error)
         {
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get selected() : Number
      {
         return this._data.selectedIndex;
      }
      
      public function set selected(n:Number) : void
      {
         this._data.selectedIndex = n;
         if(this.updateLabel)
         {
            this._label = this._data.getItemAt(this._data.selectedIndex).data.label;
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get selectedValue() : String
      {
         return this._data.value;
      }
      
      public function set selectedValue(s:String) : void
      {
         this._data.value = s;
         if(this.updateLabel)
         {
            this._label = this._data.getItemAt(this._data.selectedIndex).data.label;
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get constrainMenu() : Boolean
      {
         return this._constrainMenu;
      }
      
      public function set constainMenu(value:Boolean) : void
      {
         this._constrainMenu = value;
      }
      
      public function reset() : void
      {
         this._label = this._defaultLabel;
         invalidateDisplayList();
      }
      
      public function get dataProvider() : SimpleMenuDataProvider
      {
         return this._data;
      }
      
      public function set dataProvider(d:SimpleMenuDataProvider) : void
      {
         this._data = d;
         invalidateDisplayList();
      }
      
      public function setOptions(options:Array) : void
      {
         this._label = this._defaultLabel;
         this._data = new SimpleMenuDataProvider();
         this._data.addItems(options);
      }
      
      override public function commitProperties() : void
      {
      }
      
      protected function setSelected(id:Number) : void
      {
         this.selected = id;
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function showMenu() : void
      {
         staticList.data = this._data;
         staticList.width = Math.max(staticWindow.calculateInnerWidth(width),200);
         staticList.maxHeight = 300;
         staticWindow.setModule(staticList);
         FocusManager.getInstance().addFocusGroup(staticList);
         staticWindow.setStyleById(style.windowStyleId);
         staticWindow.useArrow = false;
         staticList.addEventListener(MultiSelectEvent.SELECT,this.onListSelect);
         staticList.addEventListener(KeyboardEvent.KEY_DOWN,this.onListKeyDown);
         try
         {
            if(AppComponents.popupManager != null)
            {
               AppComponents.popupManager.addComboBoxMenu(staticWindow);
               AppComponents.popupManager.setWindowPosition(staticWindow,0,height + 2,this);
               if(this.constrainMenu)
               {
                  AppComponents.popupManager.constrainComboBoxMenu(staticWindow);
               }
            }
            else
            {
               addContentChild(staticWindow);
               staticWindow.y = height + 2;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function hideMenu() : void
      {
         staticList.removeEventListener(MultiSelectEvent.SELECT,this.onListSelect);
         staticList.removeEventListener(KeyboardEvent.KEY_DOWN,this.onListKeyDown);
         try
         {
            if(AppComponents.popupManager != null)
            {
               AppComponents.popupManager.removeComboBoxMenu(staticWindow);
               FocusManager.getInstance().removeFocusGroup(staticList);
            }
            else
            {
               removeContentChild(staticWindow);
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
