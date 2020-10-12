package iilwy.display.shop
{
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.ui.containers.AutoScroller;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.containers.Grid;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.controls.ScrollableSprite;
   import iilwy.ui.controls.Scrollbar;
   import iilwy.utils.ItemFactory;
   
   public class MiniProductGrid extends Canvas
   {
       
      
      protected var scrollable:ScrollableSprite;
      
      protected var autoScroller:AutoScroller;
      
      protected var grid:Grid;
      
      protected var scrollbar:Scrollbar;
      
      protected var _dataProvider:ArrayCollection;
      
      protected var _dataValid:Boolean;
      
      protected var itemFactory:ItemFactory;
      
      public var styleValid:Boolean;
      
      public var useAutoScroller:Boolean = false;
      
      public var useScroller:Boolean = true;
      
      public var contextMenuEnabled:Boolean = true;
      
      public var deepLinkEnabled:Boolean = false;
      
      public var contextButtonVisible:Boolean = true;
      
      public var maxItems:int = 10000;
      
      public var itemSize:int = 40;
      
      public var gridSize:int = 1;
      
      public var itemPadding:int = 5;
      
      public var miniScrollbar:Boolean = true;
      
      public var deferredLoadImages:Boolean;
      
      public function MiniProductGrid()
      {
         super();
         this.setStyleById("miniProductGrid");
         width = 100;
         height = 60;
         this.dataProvider = new ArrayCollection();
      }
      
      override public function createChildren() : void
      {
         this.scrollable = new ScrollableSprite();
         this.scrollable.direction = ListDirection.HORIZONTAL;
         this.scrollable.pixelSnapScrolling = true;
         this.autoScroller = new AutoScroller();
         this.autoScroller.autoReturn = false;
         this.scrollbar = new Scrollbar(0,0,100,false);
         this.scrollbar.thickness = 12;
         this.scrollbar.setMargin(5,0,0,0);
         this.scrollbar.visible = false;
         this.scrollbar.includeInLayout = false;
         this.scrollbar.setScrollableTarget(this.scrollable);
         this.grid = new Grid(-this.itemPadding,0,this.gridSize,ListDirection.HORIZONTAL);
         this.grid.itemPadding = this.itemPadding;
         this.itemFactory = new ItemFactory(MiniProductGridItem);
         if(this.useAutoScroller)
         {
            addContentChild(this.autoScroller);
            this.autoScroller.addContentChild(this.grid);
         }
         else if(this.useScroller)
         {
            addContentChild(this.scrollable);
            this.scrollbar.visible = true;
            this.scrollbar.includeInLayout = true;
            this.scrollable.addContentChild(this.grid);
            addContentChild(this.scrollbar);
         }
         else
         {
            addContentChild(this.grid);
         }
      }
      
      override public function commitProperties() : void
      {
         var item:MiniProductGridItem = null;
         var data:CatalogProductBase = null;
         if(!this._dataValid)
         {
            this.scrollable.removeMouseWheel();
            while(this.grid.numContentChildren)
            {
               item = this.grid.removeContentChildAt(0) as MiniProductGridItem;
               item.catalogProductBase = null;
               this.itemFactory.recycleItem(item);
            }
            if(this._dataProvider)
            {
               for each(data in this._dataProvider.source)
               {
                  item = this.itemFactory.createItem();
                  item.deferredLoad = this.deferredLoadImages;
                  item.deepLinkEnabled = this.deepLinkEnabled;
                  item.contextMenuEnabled = this.contextMenuEnabled;
                  item.contextButtonVisible = this.contextButtonVisible;
                  item.size = this.itemSize;
                  item.catalogProductBase = data;
                  this.grid.addContentChild(item);
               }
               this.grid.validate();
               this.scrollbar.updateThumb();
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var yPos:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var availHeight:int = unscaledHeight - padding.vertical;
         yPos = 0;
         if(this.scrollbar.includeInLayout)
         {
            this.scrollbar.size = unscaledWidth - padding.horizontal;
            this.scrollbar.thickness = !!this.miniScrollbar?Number(12):Number(19);
            this.scrollbar.y = unscaledHeight - this.scrollbar.height - padding.vertical;
            availHeight = availHeight - (this.scrollbar.height + this.scrollbar.padding.vertical);
         }
         this.scrollable.y = yPos;
         this.scrollable.width = unscaledWidth - padding.horizontal;
         this.scrollable.height = availHeight;
         this.autoScroller.y = yPos;
         this.autoScroller.width = unscaledWidth - padding.horizontal;
         this.autoScroller.height = availHeight;
         if(!this.styleValid)
         {
            this.styleValid = true;
            this.scrollbar.setStyleById(style.scrollBarStyleId);
         }
      }
      
      public function get dataProvider() : ArrayCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(array:ArrayCollection) : void
      {
         this._dataProvider = array;
         this._dataValid = false;
         invalidateProperties();
      }
      
      override public function setStyleById(styleID:String) : void
      {
         this.styleValid = false;
         super.setStyleById(styleID);
      }
      
      public function appendItem(base:CatalogProductBase) : void
      {
         if(!this.containsItem(base))
         {
            this._dataProvider.addItem(base);
            if(this._dataProvider.length > this.maxItems)
            {
               this._dataProvider.removeItemAt(0);
            }
            invalidateProperties();
         }
      }
      
      public function prependItem(base:CatalogProductBase) : void
      {
         if(!this.containsItem(base))
         {
            this._dataProvider.addItemAt(base,0);
            if(this._dataProvider.length > this.maxItems)
            {
               this._dataProvider.removeItemAt(this._dataProvider.length - 1);
            }
            invalidateProperties();
         }
      }
      
      public function appendItems(array:Array) : void
      {
         var base:CatalogProductBase = null;
         for each(base in array)
         {
            this.appendItem(base);
         }
      }
      
      public function prependItems(array:Array) : void
      {
         var base:CatalogProductBase = null;
         for each(base in array)
         {
            this.prependItem(base);
         }
      }
      
      public function containsItem(base:CatalogProductBase) : Boolean
      {
         var existing:CatalogProductBase = null;
         var result:Boolean = false;
         for each(existing in this._dataProvider.source)
         {
            if(existing.id == base.id)
            {
               result = true;
               break;
            }
         }
         return result;
      }
   }
}
