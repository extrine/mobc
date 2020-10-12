package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.ui.containers.InfoWindow;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class DropDownList extends UiElement
   {
       
      
      private var _hit:Sprite;
      
      private var _menu:Sprite;
      
      private var _pane:InfoWindow;
      
      private var _state:String;
      
      private var _options:Array;
      
      private var _optionsValid:Boolean = false;
      
      private var _menuItems:Array;
      
      private var _selected:Number;
      
      private var _label:String;
      
      public function DropDownList(x:Number, y:Number, width:Number, height:Number = 30, styleId:String = "comboBox")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setStyleById(styleId);
         this._options = new Array();
         this._menuItems = new Array();
         this._menu = new Sprite();
         this._pane = new InfoWindow(0,0,200,200,style.windowStyleId);
         this._pane.useArrow = false;
         this._menu.addChild(this._pane);
         this._menu.addEventListener(ButtonEvent.UP,this.onMenuItemClick);
         this._state = ControlState.COLLAPSED;
      }
      
      override public function destroy() : void
      {
         this.setState(ControlState.COLLAPSED);
         this._menu.removeEventListener(ButtonEvent.UP,this.onMenuItemClick);
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var button:SimpleButton = null;
         var y:Number = 7;
         for(var i:int = 0; i < this._menuItems.length; i++)
         {
            button = this._menuItems[i];
            button.setStyleById(style.itemStyleId);
            button.width = unscaledWidth - 14;
            button.y = y;
            y = y + 25;
         }
         y = y + 7;
         this._pane.width = unscaledWidth;
         this._pane.height = y;
      }
      
      private function onButtonDown(event:Event) : void
      {
         event.stopImmediatePropagation();
         if(this._state == ControlState.COLLAPSED)
         {
            this.setState(ControlState.EXPANDED);
         }
         else if(this._state == ControlState.EXPANDED)
         {
            this.setState(ControlState.COLLAPSED);
         }
      }
      
      private function onMenuItemClick(event:ButtonEvent) : void
      {
         var id:Number = NaN;
         var evt:MultiSelectEvent = null;
         event.stopImmediatePropagation();
         if(this._state == ControlState.EXPANDED)
         {
            id = this._menuItems.indexOf(event.button);
            this.setSelected(id);
            evt = new MultiSelectEvent(MultiSelectEvent.SELECT,true);
            evt.value = this._options[this._selected];
            dispatchEvent(evt);
            this.setState(ControlState.COLLAPSED);
         }
      }
      
      private function onClickOut(event:Event) : void
      {
         if(mouseX < 0 || mouseY < 0 || mouseX > width || mouseY > height + this._menu.height)
         {
            this.setState(ControlState.COLLAPSED);
         }
      }
      
      public function setState(state:String) : void
      {
         if(state == ControlState.EXPANDED)
         {
            this.showMenu();
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onClickOut);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickOut);
         }
         else if(state == ControlState.COLLAPSED)
         {
            StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onClickOut);
            StageReference.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickOut);
            this.hideMenu();
         }
         this._state = state;
      }
      
      public function get length() : int
      {
         return this._options.length;
      }
      
      public function get value() : String
      {
         return this._options[this._selected];
      }
      
      public function get selected() : Number
      {
         return this._selected;
      }
      
      public function set selected(n:Number) : void
      {
         this.setSelected(n);
      }
      
      public function reset() : void
      {
         var button:SimpleButton = null;
         for(var i:int = 0; i < this._menuItems.length; i++)
         {
            button = SimpleButton(this._menuItems[i]);
            button.selected = false;
         }
      }
      
      public function setOptions(options:Array) : void
      {
         this._options = new Array();
         for(var i:int = 0; i < options.length; i++)
         {
            this._options.push(options[i]);
         }
         this.rebuildMenuItems();
      }
      
      private function rebuildMenuItems() : void
      {
         var button:SimpleButton = null;
         var i:Number = NaN;
         var label:String = null;
         for(i = 0; i < this._menuItems.length; i++)
         {
            button = SimpleButton(this._menuItems[i]);
            this._menu.removeChild(button);
         }
         this._menuItems = new Array();
         for(i = 0; i < this._options.length; i++)
         {
            label = this._options[i];
            button = new SimpleButton(label,7,y,100,25,"comboBoxItem");
            this._menu.addChild(button);
            this._menuItems.push(button);
         }
         invalidateDisplayList();
      }
      
      private function setSelected(id:Number) : void
      {
         var button:SimpleButton = null;
         button = SimpleButton(this._menuItems[this._selected]);
         if(button != null)
         {
            button.selected = false;
         }
         button = SimpleButton(this._menuItems[id]);
         if(button != null)
         {
            button.selected = true;
         }
         this._selected = id;
      }
      
      private function renderPane(style:Style, width:Number, height:Number) : Sprite
      {
         var canvas:Sprite = new Sprite();
         UiRender.renderRoundBorderBox(canvas,style,width,height);
         return GraphicUtil.makeBitmapSprite(canvas,width,height);
      }
      
      public function showMenu() : void
      {
         try
         {
            if(AppComponents.popupManager != null)
            {
               AppComponents.popupManager.addComboBoxMenu(this._menu);
               AppComponents.popupManager.setWindowPosition(this._menu,0,height + 2,this);
            }
            else
            {
               addChild(this._menu);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function hideMenu() : void
      {
         try
         {
            if(AppComponents.popupManager != null)
            {
               AppComponents.popupManager.removeComboBoxMenu(this._menu);
            }
            else
            {
               removeChild(this._menu);
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
