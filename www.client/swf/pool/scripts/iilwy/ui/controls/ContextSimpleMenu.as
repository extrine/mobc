package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.ItemFactory;
   
   public class ContextSimpleMenu extends UiModule
   {
       
      
      private var _data:Array;
      
      private var _list:List;
      
      private var _listValid:Boolean = false;
      
      private var _items:Array;
      
      private var _dividers:Array;
      
      protected var _callback:Function;
      
      private var _itemFactory:ItemFactory;
      
      private var _dividerFactory:ItemFactory;
      
      private var _selected:Number;
      
      private var _scroller:ScrollableSprite;
      
      private var _scrollbar:Scrollbar;
      
      private var _focused:AbstractButton;
      
      public function ContextSimpleMenu()
      {
         this._data = [];
         this._items = [];
         this._dividers = [];
         super();
         this._scroller = new ScrollableSprite();
         addChild(this._scroller);
         this._list = new List();
         this._scroller.addContentChild(this._list);
         this._list.itemPadding = 1;
         this._list.addEventListener(FocusEvent.FOCUS_IN,this.onItemFocus);
         this._list.addEventListener(ButtonEvent.ROLL_OVER,this.onItemRollOver);
         this._list.addEventListener(ButtonEvent.UP,this.onItemClick);
         this._list.addEventListener(KeyboardEvent.KEY_DOWN,this.onItemKeyDown);
         this._itemFactory = new ItemFactory(LiteButton);
         this._dividerFactory = new ItemFactory(Divider);
      }
      
      override public function destroy() : void
      {
         this._items = null;
         this._list.removeEventListener(ButtonEvent.UP,this.onItemClick);
         this._itemFactory.destroy();
         this._dividerFactory.destroy();
         this._list.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._scrollbar != null)
         {
            this._scrollbar.x = unscaledWidth - this._scrollbar.width;
            this._scrollbar.height = unscaledHeight;
         }
         this._scroller.height = unscaledHeight;
      }
      
      public function get data() : Array
      {
         return this._data.concat();
      }
      
      public function setData(data:Array) : void
      {
         var opt:Object = null;
         this._selected = undefined;
         this._data = new Array();
         for(var i:int = 0; i < data.length; i++)
         {
            opt = new Object();
            if(data[i] is String)
            {
               opt.label = data[i];
               opt.value = data[i];
            }
            else
            {
               opt.label = data[i].label;
               opt.value = data[i].value;
            }
            this._data.push(opt);
         }
         this._listValid = false;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function measure() : void
      {
         var item:AbstractButton = null;
         var i:int = 0;
         var div:Divider = null;
         var data:Object = null;
         if(!this._listValid)
         {
            this._listValid = true;
            if(this._dividers != null)
            {
            }
            for each(div in this._dividers)
            {
               this._list.removeContentChild(div);
               this._dividerFactory.recycleItem(div);
            }
            for each(item in this._items)
            {
               this._list.removeContentChild(item);
               this._itemFactory.recycleItem(item);
            }
            this._items = new Array();
            this._dividers = new Array();
            for(i = 0; i < this._data.length; i++)
            {
               data = this._data[i];
               if(data.label == Divider.LIST_IDENTIFIER)
               {
                  div = this._dividerFactory.createItem() as Divider;
                  div.setStyleById("dividerWhite");
                  div.width = 180;
                  div.setMargin(5,0);
                  this._dividers.push(div);
                  this._list.addContentChild(div);
               }
               else
               {
                  item = this._itemFactory.createItem();
                  item.label = data.label;
                  item.width = 180;
                  item.height = 25;
                  item.tabEnabled = true;
                  item.selected = false;
                  try
                  {
                     item.useFocusGlow = false;
                  }
                  catch(e:Error)
                  {
                  }
                  item.setStyleById("contextMenuItemDark");
                  this._items.push(item);
                  this._list.addContentChild(item);
               }
            }
            this.selected = this._selected;
         }
         measuredHeight = this._list.height;
         measuredWidth = this._list.width;
         if(this._list.height > maxHeight)
         {
            this.enableScrollbar();
            measuredWidth = measuredWidth + 25;
         }
         else
         {
            this.disableScrollbar();
         }
      }
      
      public function enableScrollbar() : void
      {
         if(this._scrollbar == null)
         {
            this._scrollbar = new Scrollbar();
            this._scrollbar.setScrollableTarget(this._scroller);
            this._scroller.listenForMouseWheel();
         }
         addChild(this._scrollbar);
      }
      
      public function disableScrollbar() : void
      {
         if(this._scrollbar != null)
         {
            try
            {
               removeChild(this._scrollbar);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function onItemKeyDown(event:KeyboardEvent) : void
      {
         var index:Number = NaN;
         if(event.keyCode == Keyboard.ENTER)
         {
            index = this._list.content.getChildIndex(event.target as DisplayObject);
            this.dispatchSelectEvent(index);
         }
      }
      
      private function onItemClick(event:ButtonEvent) : void
      {
         var index:Number = this._list.content.getChildIndex(event.target as DisplayObject);
         this.dispatchSelectEvent(index);
      }
      
      private function onItemRollOver(event:ButtonEvent) : void
      {
         if(this._focused != null && this._focused != event.button)
         {
            this._focused.setState(ControlState.DEFAULT);
         }
         this._focused = event.button;
      }
      
      private function onItemFocus(event:FocusEvent) : void
      {
         if(this._focused != null)
         {
            this._focused.setState(ControlState.DEFAULT);
         }
         this._focused = event.target as AbstractButton;
      }
      
      private function dispatchSelectEvent(index:Number) : void
      {
         var data:Object = this._data[index];
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.SELECT,true,true);
         evt.value = data.value;
         evt.label = data.label;
         evt.selected = index;
         dispatchEvent(evt);
      }
      
      public function get value() : String
      {
         if(this._data[this._selected] == null)
         {
            return "";
         }
         return this._data[this._selected].value;
      }
      
      public function set value(s:String) : void
      {
         var index:Number = -1;
         for(var i:Number = 0; i < this._data.length; i++)
         {
            if(this._data[i].value == s)
            {
               index = i;
            }
         }
         if(index >= 0)
         {
            this.selected = index;
         }
      }
      
      public function get selected() : Number
      {
         return this._selected;
      }
      
      public function set selected(n:Number) : void
      {
         var b:AbstractButton = null;
         if(!isNaN(this._selected))
         {
            try
            {
               b = this._list.content.getChildAt(this._selected) as AbstractButton;
            }
            catch(e:Error)
            {
            }
         }
         if(b != null)
         {
            b.selected = false;
         }
         if(!isNaN(n))
         {
            try
            {
               b = this._list.content.getChildAt(n) as AbstractButton;
            }
            catch(e:Error)
            {
            }
         }
         if(b != null)
         {
            b.selected = true;
         }
         this._selected = n;
      }
      
      override public function get defaultFocus() : InteractiveObject
      {
         var io:InteractiveObject = null;
         if(!isNaN(this._selected))
         {
            io = this._list.content.getChildAt(this._selected) as InteractiveObject;
         }
         return io;
      }
   }
}
