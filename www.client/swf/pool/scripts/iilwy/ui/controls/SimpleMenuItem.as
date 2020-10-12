package iilwy.ui.controls
{
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import iilwy.display.core.FocusManager;
   import iilwy.ui.containers.IListViewItem;
   import iilwy.ui.containers.ListViewDataWrapper;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ListViewEvent;
   
   public class SimpleMenuItem extends UiElement implements IListViewItem
   {
       
      
      protected var _dataWrapper:ListViewDataWrapper;
      
      protected var _button:AbstractButton;
      
      protected var _divider:Divider;
      
      public function SimpleMenuItem()
      {
         super();
         this._button = new LiteButton();
         this._button.setStyleById(styleID);
         this._button.useFocusGlow = false;
         addEventListener(ButtonEvent.UP,this.onButtonUp);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         mouseChildren = true;
      }
      
      override public function destroy() : void
      {
         this._button.destroy();
         this._divider.destroy();
         super.destroy();
      }
      
      override public function commitProperties() : void
      {
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(this._dataWrapper && this._dataWrapper.data)
         {
            if(this._dataWrapper.data.label == Divider.LIST_IDENTIFIER)
            {
               if(this._divider == null)
               {
                  this._divider = new Divider();
               }
               addChild(this._divider);
               if(this._button.stage != null)
               {
                  removeChild(this._button);
               }
               this._divider.width = unscaledWidth - 6;
               this._divider.x = 3;
               this._divider.y = Math.floor(unscaledHeight / 2);
               this._divider.setStyleById(styleID);
            }
            else
            {
               addChild(this._button);
               if(this._divider && contains(this._divider))
               {
                  removeChild(this._divider);
               }
               this._button.label = this._dataWrapper.data.label;
               this._button.width = unscaledWidth;
               this._button.height = unscaledHeight;
               this._button.setStyleById(styleID);
            }
         }
      }
      
      public function setListViewData(wrapper:ListViewDataWrapper) : void
      {
         this._dataWrapper = wrapper;
         invalidateProperties();
         this.invalidateDisplayList();
      }
      
      override public function setStyleById(s:String) : void
      {
         if(this._button != null)
         {
            this._button.setStyleById(s);
         }
         if(this._divider != null)
         {
            this._divider.setStyleById(s);
         }
         super.setStyleById(s);
      }
      
      public function get selected() : Boolean
      {
         return this._button.selected;
      }
      
      public function set selected(b:Boolean) : void
      {
         this._button.selected = b;
      }
      
      public function asUiElement() : UiElement
      {
         return this;
      }
      
      public function onButtonUp(event:ButtonEvent) : void
      {
         var evt:ListViewEvent = new ListViewEvent(ListViewEvent.SELECT,true);
         evt.dataWrapper = this._dataWrapper;
         dispatchEvent(evt);
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         var evt:ListViewEvent = null;
         if(event.keyCode == Keyboard.ENTER)
         {
            evt = new ListViewEvent(ListViewEvent.SELECT,true);
            evt.dataWrapper = this._dataWrapper;
            dispatchEvent(evt);
         }
      }
      
      private function onFocusIn(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            if(this._button.stage != null)
            {
               FocusManager.getInstance().setStageFocus(this._button);
            }
         }
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
      }
   }
}
