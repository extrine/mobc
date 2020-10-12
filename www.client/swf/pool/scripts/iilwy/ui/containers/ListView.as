package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import iilwy.display.core.FocusManager;
   import iilwy.ui.controls.IScrollable;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ListViewEvent;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.MathUtil;
   
   public class ListView extends UiContainer implements IScrollable
   {
       
      
      protected var _itemFactory:ItemFactory;
      
      protected var _data:ListViewDataProvider;
      
      public var _items:Array;
      
      protected var _itemHolder:Sprite;
      
      protected var _itemHeight:Number = 50;
      
      protected var _itemPadding:Number = 2;
      
      protected var _renderingInvalid:Boolean = true;
      
      protected var _listSizeChanged:Boolean = true;
      
      protected var _listScrollChanged:Boolean = true;
      
      protected var _renderedListDimensions:Rectangle;
      
      private var _topScroll:Number = 0;
      
      private var _scrollPos:Number = 0;
      
      private var _scrollAmount:Number = 0;
      
      public var scrollIncrement:Number = 52;
      
      private var _createdItemLookup:Object;
      
      public var _focused:Number = -1;
      
      public var _focusChanged:Boolean;
      
      public var renderItemMethod:Function;
      
      public var clearItemMethod:Function;
      
      public function ListView(itemClass:Class, styleId:String = "simpleMenu")
      {
         this._renderedListDimensions = new Rectangle();
         this._createdItemLookup = {};
         super();
         this.x = 0;
         this.y = 0;
         this.width = 150;
         this.height = 300;
         this._items = new Array();
         this._itemFactory = new ItemFactory(itemClass);
         addContainerBackground();
         maskContents = true;
         this.data = new ListViewDataProvider();
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(Event.ADDED,this.onAdded);
         this._itemHolder = new Sprite();
         addContentChild(this._itemHolder);
         setStyleById(styleId);
         addEventListener(ListViewEvent.SELECT,this.onListViewSelect);
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      override public function destroy() : void
      {
         this._data.removeEventListener(Event.CHANGE,this.onDataChanged);
         this._data = null;
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         for(var i:Number = 0; i < this._items.length; i++)
         {
            this._items[i].destroy();
         }
         this._createdItemLookup = null;
         this._itemFactory.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var shouldRender:Boolean = false;
         if(this._renderingInvalid)
         {
            shouldRender = true;
            this._renderingInvalid = false;
         }
         this._scrollPos = (this.contentHeight - unscaledHeight) * -this._scrollAmount;
         if(isNaN(this._scrollPos))
         {
            this._scrollPos = 0;
         }
         if(this._listSizeChanged)
         {
            this._listSizeChanged = false;
            shouldRender = true;
            if(Math.abs(this._scrollPos) > this.contentHeight - height)
            {
               this._scrollPos = -Math.max(0,this.contentHeight - unscaledHeight);
            }
            this._scrollAmount = Math.abs(this._scrollPos) / (this.contentHeight - height);
            this.dispatchContentChangedEvent();
         }
         if(this._listScrollChanged)
         {
            this._listScrollChanged = false;
            shouldRender = true;
         }
         if(shouldRender)
         {
            this.clearItems();
            this.renderItems(unscaledWidth,unscaledHeight);
         }
         this._itemHolder.y = Math.round(this._scrollPos % (this.itemHeight + this.itemPadding));
      }
      
      public function scrollToItem(n:Number) : void
      {
         var newtop:Number = NaN;
         var val:Number = NaN;
         var top:Number = -Math.floor((this.contentHeight - height) * -this._scrollAmount / (this.itemHeight + this.itemPadding));
         var itemWindow:Number = Math.floor(height / (this.itemHeight + this.itemPadding));
         if(n >= 0)
         {
            if(this._focused >= top + itemWindow - 3)
            {
               newtop = n - (itemWindow - 3);
            }
            else if(this._focused < top + 2)
            {
               newtop = n - 2;
            }
         }
         if(!isNaN(newtop))
         {
            newtop = MathUtil.clamp(0,this._data.length - itemWindow,newtop);
            val = newtop * (this.itemHeight + this.itemPadding);
            this.setScrollAmount(val / (this.contentHeight - height));
         }
      }
      
      protected function clearItems(remove:Boolean = false) : void
      {
         var item:UiElement = null;
         if(this._items.length > 0)
         {
            do
            {
               item = this._items.shift();
               item.visible = false;
               if(remove)
               {
                  if(this._itemHolder.contains(item))
                  {
                     this._itemHolder.removeChild(item);
                  }
               }
            }
            while(this._items.length > 0);
            
         }
      }
      
      protected function renderItems(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var item:IListViewItem = null;
         var prop:* = null;
         var data:ListViewDataWrapper = null;
         var pos:Number = 0;
         this._topScroll = Math.floor(-this._scrollPos / (this.itemHeight + this.itemPadding));
         var dataIndex:Number = this._topScroll;
         var tempLookup:Object = {};
         do
         {
            data = this._data.getItemAt(dataIndex);
            if(data == null)
            {
               break;
            }
            if(this._createdItemLookup[data.uid] != null)
            {
               item = this._createdItemLookup[data.uid.toString()];
               tempLookup[data.uid.toString()] = item;
               delete this._createdItemLookup[data.uid.toString()];
            }
            else
            {
               item = this._itemFactory.createItem();
               if(!item is IListViewItem)
               {
                  throw new Error("Not an IListViewItem");
               }
               item.asUiElement().setStyleById(style.itemStyleId);
               tempLookup[data.uid.toString()] = item;
               item.setListViewData(data);
               if(this.renderItemMethod != null)
               {
                  item.asUiElement().validate();
                  this.renderItemMethod(item,data);
               }
            }
            item.asUiElement().y = pos;
            item.asUiElement().height = this._itemHeight;
            item.asUiElement().width = unscaledWidth;
            if(this._data.isSelected(data.uid))
            {
               item.selected = true;
            }
            else if(!this._data.isSelected(data.uid))
            {
               item.selected = false;
            }
            item.asUiElement().visible = true;
            if(!this._itemHolder.contains(item.asUiElement()))
            {
               this._itemHolder.addChild(item.asUiElement());
            }
            pos = pos + (item.asUiElement().height + this.itemPadding);
            if(dataIndex == this._focused)
            {
               FocusManager.getInstance().setStageFocus(item.asUiElement());
            }
            dataIndex++;
            this._items.push(item);
            this._renderedListDimensions.y = this._scrollPos;
            this._renderedListDimensions.height = pos;
         }
         while(pos < unscaledHeight + this.itemHeight && dataIndex < this._data.length);
         
         for(prop in this._createdItemLookup)
         {
            IListViewItem(this._createdItemLookup[prop]).setListViewData(null);
            this._itemFactory.recycleItem(this._createdItemLookup[prop]);
            delete this._createdItemLookup[prop];
         }
         this._createdItemLookup = tempLookup;
      }
      
      public function set data(d:ListViewDataProvider) : void
      {
         if(this.data != null)
         {
            this._data.removeEventListener(Event.CHANGE,this.onDataChanged);
         }
         this._data = d;
         this._data.addEventListener(Event.CHANGE,this.onDataChanged);
         this._renderingInvalid = true;
         this._listSizeChanged = true;
         this.scrollAmount = 0;
         if(!this.data.allowMultipleSelection && !isNaN(this.data.selectedIndex) && this.data.selectedIndex > 0)
         {
            this._focused = this.data.selectedIndex;
         }
         else
         {
            this._focused = -1;
         }
         invalidateSize();
         invalidateProperties();
         this.invalidateDisplayList();
      }
      
      public function get data() : ListViewDataProvider
      {
         return this._data;
      }
      
      protected function onDataChanged(event:Event) : void
      {
         this._renderingInvalid = true;
         this.dispatchContentChangedEvent();
         invalidateProperties();
         this.invalidateDisplayList();
      }
      
      protected function onAdded(event:Event) : void
      {
         if(event.target == this)
         {
            this.scrollToItem(this._focused);
         }
      }
      
      override public function set width(n:Number) : void
      {
         this._listSizeChanged = true;
         super.width = n;
      }
      
      override public function set height(n:Number) : void
      {
         this._listSizeChanged = true;
         super.height = n;
      }
      
      public function get itemHeight() : Number
      {
         return this._itemHeight;
      }
      
      public function set itemHeight(n:Number) : void
      {
         this._itemHeight = n;
         this._renderingInvalid = true;
         invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(n:Number) : void
      {
         this._itemPadding = n;
         this._renderingInvalid = true;
         invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function get contentHeight() : Number
      {
         return this._data.length * (this.itemHeight + this.itemPadding) - this.itemPadding;
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         if(event.keyCode == Keyboard.DOWN)
         {
            this._focused = this._focused + 1;
         }
         else if(event.keyCode == Keyboard.UP)
         {
            this._focused = this._focused - 1;
         }
         this._focused = MathUtil.clamp(0,this._data.length - 1,this._focused);
         this.scrollToItem(this._focused);
         this._renderingInvalid = true;
         this.invalidateDisplayList();
      }
      
      public function get focused() : Number
      {
         return this._focused;
      }
      
      public function set focused(n:Number) : void
      {
         this._focused = MathUtil.clamp(-1,this._data.length - 1,n);
         this.scrollToItem(this._focused);
         this._renderingInvalid = true;
         this.invalidateDisplayList();
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
      
      public function getWindowToRangeRatio() : Number
      {
         var window:Number = Math.floor(height / this.itemHeight);
         return Math.max(0,window / (this._data.length - window));
      }
      
      public function getWindowToContentRatio() : Number
      {
         var window:Number = Math.floor(height / this.itemHeight);
         return Math.max(0,window / this._data.length);
      }
      
      private function setScrollAmount(amount:Number) : void
      {
         var window:Number = Math.floor(height / this.itemHeight);
         if(this._data.length > window)
         {
            this._scrollAmount = MathUtil.clamp(0,1,amount);
         }
         else
         {
            this._scrollAmount = 0;
         }
         this._listScrollChanged = true;
         this.dispatchScrollEvent();
         this.invalidateDisplayList();
      }
      
      public function set scrollAmount(amount:Number) : void
      {
         this._focused = -1;
         this.setScrollAmount(amount);
      }
      
      public function get scrollAmount() : Number
      {
         return this._scrollAmount;
      }
      
      public function listenForMouseWheel() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function incrementScrollAmount(direction:Number, multiple:Number = 1) : void
      {
         var percent:Number = this.scrollIncrement / (this.contentHeight - height);
         this.scrollAmount = this.scrollAmount + percent * direction * multiple;
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var dir:Number = event.delta < 0?Number(1):Number(-1);
         this.focused = -1;
         this.incrementScrollAmount(dir);
      }
      
      protected function onListViewSelect(event:ListViewEvent) : void
      {
         if(this._data.allowMultipleSelection)
         {
            if(this._data.isSelected(event.dataWrapper.uid))
            {
               this._data.deselectItem(event.dataWrapper.uid);
            }
            else
            {
               this._data.selectItem(event.dataWrapper.uid);
            }
         }
         else
         {
            this._data.selectedUid = event.dataWrapper.uid;
         }
      }
   }
}
