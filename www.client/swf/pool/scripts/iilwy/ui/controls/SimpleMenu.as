package iilwy.ui.controls
{
   import flash.events.FocusEvent;
   import iilwy.display.core.FocusManager;
   import iilwy.ui.containers.ListView;
   import iilwy.ui.containers.ListViewDataProvider;
   import iilwy.ui.containers.ListViewDataWrapper;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.events.ListViewEvent;
   import iilwy.ui.events.MultiSelectEvent;
   
   public class SimpleMenu extends UiModule
   {
       
      
      public var _list:ListView;
      
      private var _scrollbar:Scrollbar;
      
      public function SimpleMenu()
      {
         super();
         this._list = new ListView(SimpleMenuItem);
         this._list.setStyleById("simpleMenu");
         addContentChild(this._list);
         this._list.itemPadding = 1;
         this._list.itemHeight = 24;
         defaultFocus = this._list;
         this._list.addEventListener(ListViewEvent.SELECT,this.onItemSelect);
         addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
      }
      
      override public function destroy() : void
      {
         this._list.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var sbw:Number = 0;
         if(this._scrollbar != null)
         {
            this._scrollbar.x = unscaledWidth - this._scrollbar.width;
            this._scrollbar.height = unscaledHeight;
            if(this._scrollbar.stage != null)
            {
               sbw = this._scrollbar.width + 5;
            }
         }
         this._list.height = unscaledHeight;
         this._list.width = unscaledWidth - sbw;
      }
      
      public function listenForMouseWheel() : void
      {
         this._list.listenForMouseWheel();
      }
      
      override public function measure() : void
      {
         measuredHeight = this._list.contentHeight;
         if(measuredHeight > maxHeight)
         {
            this.enableScrollbar();
         }
         else
         {
            this.disableScrollbar();
         }
      }
      
      public function set data(d:ListViewDataProvider) : void
      {
         this._list.data = d;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get data() : ListViewDataProvider
      {
         return this._list.data;
      }
      
      public function enableScrollbar() : void
      {
         if(this._scrollbar == null)
         {
            this._scrollbar = new Scrollbar();
            this._scrollbar.setScrollableTarget(this._list);
         }
         addChild(this._scrollbar);
         invalidateDisplayList();
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
         invalidateDisplayList();
      }
      
      private function onItemSelect(event:ListViewEvent) : void
      {
         this.dispatchSelectEvent(event.dataWrapper);
      }
      
      private function dispatchSelectEvent(wrapper:ListViewDataWrapper) : void
      {
         var data:Object = wrapper.data;
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.SELECT,true,true);
         evt.value = data.value;
         evt.label = data.label;
         evt.selected = this._list.data.indexOf(wrapper.uid);
         dispatchEvent(evt);
      }
      
      public function onFocusIn(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            FocusManager.getInstance().setStageFocus(this._list);
         }
      }
   }
}
