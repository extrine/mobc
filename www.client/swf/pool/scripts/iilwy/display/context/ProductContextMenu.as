package iilwy.display.context
{
   import iilwy.collections.ArrayCollection;
   import iilwy.display.shop.MiniProductGrid;
   import iilwy.display.shop.ProductDetail;
   import iilwy.events.ShopEvent;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.events.UiEvent;
   
   public class ProductContextMenu extends UiModule
   {
       
      
      private var productDetail:ProductDetail;
      
      private var productSelector:MiniProductGrid;
      
      private var _inventoryProduct:InventoryProduct;
      
      private var _catalogProductBase:CatalogProductBase;
      
      protected var _pendingDetailLayout:String;
      
      protected var _productSelections:Array;
      
      protected var _selectionsValid:Boolean;
      
      protected var _styleValid:Boolean;
      
      public function ProductContextMenu()
      {
         super();
         setPadding(0);
         _wantsFocus = false;
      }
      
      override public function set height(n:Number) : void
      {
      }
      
      public function set productSelections(array:Array) : void
      {
         this._selectionsValid = false;
         this._productSelections = array;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set inventoryProduct(value:InventoryProduct) : void
      {
         width = 300;
         this._pendingDetailLayout = ProductDetail.LAYOUT_INVENTORY_CONTEXT;
         this._inventoryProduct = value;
         this._catalogProductBase = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set detailLayout(str:String) : void
      {
         this._pendingDetailLayout = str;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set catalogProductBase(value:CatalogProductBase) : void
      {
         this._pendingDetailLayout = ProductDetail.LAYOUT_SHOP_CONTEXT;
         width = 350;
         this._catalogProductBase = value;
         this._inventoryProduct = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function createChildren() : void
      {
         this.productDetail = new ProductDetail();
         this.productDetail.addEventListener(UiEvent.INVALIDATE_SIZE,this.onDetailInvalidateSize,false,0,true);
         addContentChild(this.productDetail);
         this.productSelector = new MiniProductGrid();
         this.productSelector.setMargin(10,0,0,0);
         this.productSelector.height = 40;
         this.productSelector.useAutoScroller = true;
         this.productSelector.contextButtonVisible = false;
         this.productSelector.contextMenuEnabled = false;
         this.productSelector.deepLinkEnabled = true;
         this.productSelector.addEventListener(ShopEvent.DEEP_LINK_TO_PRODUCT,this.onSelectProduct);
         addContentChild(this.productSelector);
      }
      
      override public function commitProperties() : void
      {
         this.productDetail.clear();
         if(this._inventoryProduct)
         {
            this.productDetail.inventoryProduct = this._inventoryProduct;
         }
         else
         {
            this.productDetail.catalogProductBase = this._catalogProductBase;
         }
         this.productDetail.layout = this._pendingDetailLayout;
         if(!this._selectionsValid)
         {
            this._selectionsValid = true;
            if(this._productSelections && this._productSelections.length > 0)
            {
               this.productSelector.dataProvider = new ArrayCollection(this._productSelections);
               this.productSelector.visible = true;
            }
            else
            {
               this.productSelector.dataProvider = null;
               this.productSelector.visible = false;
            }
         }
      }
      
      override public function measure() : void
      {
         measuredWidth = 400;
         measuredHeight = this.productDetail.height + padding.vertical;
         if(this.productSelector.visible)
         {
            measuredHeight = measuredHeight + (this.productSelector.height + this.productSelector.margin.vertical);
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var yPos:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var xPos:int = padding.left;
         yPos = padding.top;
         this.productDetail.x = xPos;
         this.productDetail.y = yPos;
         this.productDetail.width = unscaledWidth - padding.horizontal;
         yPos = yPos + this.productDetail.height;
         yPos = yPos + this.productSelector.margin.top;
         this.productSelector.y = yPos;
         this.productSelector.width = unscaledWidth - padding.horizontal;
      }
      
      protected function onDetailInvalidateSize(event:UiEvent) : void
      {
         if(!validating && event.target == this.productDetail)
         {
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      protected function onSelectProduct(event:ShopEvent) : void
      {
         event.stopImmediatePropagation();
         this.productDetail.catalogProductBase = event.catalogProductBase;
      }
   }
}
