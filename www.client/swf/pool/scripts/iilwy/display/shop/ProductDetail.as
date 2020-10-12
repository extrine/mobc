package iilwy.display.shop
{
   import flash.display.BlendMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import iilwy.application.AppComponents;
   import iilwy.display.thumbnails.ProductThumbnail;
   import iilwy.events.AsyncEvent;
   import iilwy.events.GenericValueEvent;
   import iilwy.events.GiftEvent;
   import iilwy.events.ShopEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   import iilwy.model.dataobjects.shop.enum.ProductPurchaseType;
   import iilwy.model.dataobjects.user.CurrencyData;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoScrollLabel;
   import iilwy.ui.controls.AutoScrollLabelMultiple;
   import iilwy.ui.controls.ButtonSet;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.ProcessingIndicator;
   import iilwy.ui.controls.SimpleCheckBox;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.partials.badges.PremiumBadge;
   import iilwy.ui.utils.CapType;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.DateUtil;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.Responder;
   import iilwy.utils.ShopUtil;
   import iilwy.utils.StageReference;
   import iilwy.utils.TextUtil;
   
   public class ProductDetail extends UiContainer
   {
      
      public static const LAYOUT_CLICK_SHOP:String = "clickShop";
      
      public static const LAYOUT_SHOP_CONTEXT:String = "shopContext";
      
      public static const LAYOUT_SHOP_DEEP_LINK:String = "shopDeepLink";
      
      public static const LAYOUT_INVENTORY_CONTEXT:String = "inventoryContext";
       
      
      private var thumbnail:ProductThumbnail;
      
      private var thumbnailBg:Canvas;
      
      private var nameLabel:AutoScrollLabel;
      
      private var descriptionBlock:TextBlock;
      
      private var infoLabels:AutoScrollLabelMultiple;
      
      private var productList:List;
      
      private var productListDivider:Divider;
      
      private var buttonSet:ButtonSet;
      
      private var productFactory:ItemFactory;
      
      private var closeButton:IconButton;
      
      private var _layout:String;
      
      private var _inventoryProduct:InventoryProduct;
      
      private var _catalogProductBase:CatalogProductBase;
      
      private var processing:ProcessingIndicator;
      
      private var checkBox:SimpleCheckBox;
      
      private var updateInventoryFlag:Boolean;
      
      protected var premiumBadge:PremiumBadge;
      
      protected var lockedIndicator:LockedProductIndicator;
      
      protected var expandDescription:Boolean;
      
      private const THUMBNAIL_CONTEXT_SIZE:Number = 190;
      
      protected var trackedView:Boolean;
      
      public function ProductDetail()
      {
         super();
         this.productFactory = new ItemFactory(CatalogProductListItem);
      }
      
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(value:String) : void
      {
         if(value == this._layout)
         {
            return;
         }
         this._layout = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set inventoryProduct(value:InventoryProduct) : void
      {
         if(value == this._inventoryProduct)
         {
            return;
         }
         this._inventoryProduct = value;
         this._catalogProductBase = null;
         this._layout = Boolean(this._layout)?this._layout:LAYOUT_INVENTORY_CONTEXT;
         this.getFullProductBase();
         this.expandDescription = false;
      }
      
      public function set catalogProductBase(value:CatalogProductBase) : void
      {
         if(!value)
         {
            return;
         }
         if(value == this._catalogProductBase)
         {
            return;
         }
         this._catalogProductBase = value;
         this._inventoryProduct = null;
         this._layout = Boolean(this._layout)?this._layout:LAYOUT_SHOP_CONTEXT;
         invalidateProperties();
         invalidateDisplayList();
         invalidateSize();
         if(!value.products || value.products.length == 0 || value.categoryKey == null || value.collectionKey == null)
         {
            this.getFullProductBase();
         }
         this.expandDescription = false;
      }
      
      override public function createChildren() : void
      {
         this.thumbnailBg = new Canvas();
         addContentChild(this.thumbnailBg);
         this.thumbnailBg.cornerRadius = 10;
         this.thumbnailBg.backgroundGradient = [20132659,2858837606];
         this.processing = new ProcessingIndicator();
         this.processing.visible = false;
         addContentChild(this.processing);
         this.thumbnail = new ProductThumbnail();
         this.thumbnail.setStyleById("clearImage");
         this.thumbnail.contextMenuEnabled = false;
         this.thumbnail.isPNG = true;
         this.thumbnail.size = this.THUMBNAIL_CONTEXT_SIZE;
         this.thumbnail.borderSize = 10;
         this.thumbnail.borderColor = 16777216;
         this.thumbnail.mouseEnabled = false;
         this.thumbnail.addEventListener(UiEvent.LOAD_BEGIN,this.onImageLoadBegin);
         this.thumbnail.addEventListener(UiEvent.LOAD_COMPLETE,this.onImageLoadComplete);
         addContentChild(this.thumbnail);
         this.closeButton = new IconButton(GraphicManager.iconX1,0,0,16,16,"iconButtonWhiteReverse");
         this.closeButton.blendMode = BlendMode.LIGHTEN;
         this.closeButton.addEventListener(ButtonEvent.CLICK,this.onCloseClick);
         addContentChild(this.closeButton);
         this.nameLabel = new AutoScrollLabel();
         this.nameLabel.label.fontSize = 17;
         this.nameLabel.label.selectable = false;
         this.nameLabel.idleScroll = true;
         this.nameLabel.idleScrollDelay = 400;
         this.nameLabel.useHandCursor = true;
         this.nameLabel.addEventListener(MouseEvent.CLICK,this.onNameClick);
         addContentChild(this.nameLabel);
         this.descriptionBlock = new TextBlock();
         this.descriptionBlock.addEventListener(MouseEvent.CLICK,this.onDescriptionClick);
         addContentChild(this.descriptionBlock);
         this.infoLabels = new AutoScrollLabelMultiple(1);
         this.infoLabels.setMargin(0,0,10,0);
         this.infoLabels.alpha = 0.7;
         addContentChild(this.infoLabels);
         this.infoLabels.addEventListener(TextEvent.LINK,this.onCloseClick);
         this.productList = new List();
         this.productList.itemPadding = 0;
         addContentChild(this.productList);
         this.productListDivider = new Divider();
         addContentChild(this.productListDivider);
         this.buttonSet = new ButtonSet();
         this.buttonSet.useStaticCache = true;
         this.buttonSet.size = 32;
         this.buttonSet.cornerRadius = 32;
         this.buttonSet.buttonPadding = new Margin(10,0,10,0);
         this.buttonSet.capType = CapType.ROUND;
         this.buttonSet.itemPadding = 0;
         this.buttonSet.margin.top = 10;
         this.buttonSet.chromePadding = new Margin(5,0,5,0);
         this.buttonSet.setStyleById("shadedButtonDarkSet");
         this.buttonSet.addEventListener(MultiSelectEvent.SELECT,this.onButtonSelect);
         addContentChild(this.buttonSet);
         this.checkBox = new SimpleCheckBox();
         this.checkBox.fontColor = 16777215;
         this.checkBox.label = "Auto Renew";
         this.checkBox.addEventListener(MouseEvent.CLICK,this.onCheckBoxClick,false,0,true);
         this.checkBox.visible = false;
         this.checkBox.includeInLayout = false;
         this.lockedIndicator = new LockedProductIndicator();
         addContentChild(this.lockedIndicator);
         this.premiumBadge = new PremiumBadge();
         addContentChild(this.premiumBadge);
         this.premiumBadge.setMargin(3,3,0,0);
         addContentChild(this.checkBox);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onCheckBoxClick(event:MouseEvent) : void
      {
         var shopEvent:ShopEvent = null;
         if(this._inventoryProduct != null)
         {
            this._inventoryProduct.autoRenew = this.checkBox.selected;
            shopEvent = new ShopEvent(ShopEvent.UPDATE_PRODUCT,true);
            shopEvent.renew = this._inventoryProduct.autoRenew;
            shopEvent.productID = this._inventoryProduct.id;
            dispatchEvent(shopEvent);
         }
      }
      
      override public function set height(n:Number) : void
      {
      }
      
      override public function measure() : void
      {
         measuredWidth = 200;
         measuredHeight = 0;
         measuredHeight = measuredHeight + (this.nameLabel.height + this.nameLabel.margin.vertical);
         if(this.descriptionBlock.includeInLayout && this.descriptionBlock.text != "")
         {
            measuredHeight = measuredHeight + (this.descriptionBlock.height + this.descriptionBlock.margin.vertical);
         }
         if(this.infoLabels.includeInLayout)
         {
            measuredHeight = measuredHeight + (this.infoLabels.height + this.infoLabels.margin.vertical);
            measuredHeight = measuredHeight + this.infoLabels.margin.vertical;
         }
         if(this.productList.includeInLayout)
         {
            measuredHeight = measuredHeight + this.productList.height;
         }
         if(this.buttonSet.includeInLayout)
         {
            measuredHeight = measuredHeight + (this.buttonSet.height + this.buttonSet.margin.vertical);
         }
         if(this.lockedIndicator.includeInLayout)
         {
            measuredHeight = measuredHeight + (this.lockedIndicator.height + this.lockedIndicator.margin.vertical);
         }
         if(this._layout != LAYOUT_INVENTORY_CONTEXT)
         {
            if(this._layout == LAYOUT_SHOP_DEEP_LINK)
            {
               measuredHeight = Math.max(this.calculateFullImageSize(explicitWidth),measuredHeight);
            }
            else
            {
               measuredHeight = Math.max(this.THUMBNAIL_CONTEXT_SIZE,measuredHeight);
            }
         }
      }
      
      override public function commitProperties() : void
      {
         var label1:String = null;
         var label2:String = null;
         var purchaseDate:Date = null;
         var expirationDate:Date = null;
         var now:Date = null;
         var dt:Number = NaN;
         var remaining:Number = NaN;
         var suffix:String = null;
         var evt:GenericValueEvent = null;
         this.premiumBadge.level = PremiumLevels.NONE;
         this.thumbnailBg.backgroundGradient = [20132659,2858837606];
         this.infoLabels.visible = false;
         this.infoLabels.includeInLayout = false;
         this.descriptionBlock.visible = false;
         this.descriptionBlock.includeInLayout = false;
         this.nameLabel.useHandCursor = true;
         this.productList.visible = false;
         this.productList.includeInLayout = false;
         this.lockedIndicator.visible = false;
         this.lockedIndicator.includeInLayout = false;
         this.buttonSet.removeAll();
         this.buttonSet.visible = false;
         this.buttonSet.includeInLayout = false;
         this.checkBox.visible = false;
         this.checkBox.includeInLayout = false;
         this.clearProducts();
         var displayButonSet:Boolean = false;
         if(this._catalogProductBase)
         {
            if(this._inventoryProduct == null)
            {
               this.premiumBadge.level = this._catalogProductBase.minimumPremiumLevel;
               this.thumbnail.catalogProductBase = this._catalogProductBase;
               if(this._catalogProductBase.popText && this._catalogProductBase.popText != "")
               {
                  this.thumbnail.showSash();
                  this.thumbnail.sash.label = this._catalogProductBase.popText;
               }
               else
               {
                  this.thumbnail.hideSash();
               }
               this.infoLabels.visible = true;
               this.infoLabels.includeInLayout = true;
               this.infoLabels.getLabelAt(0).text = TextUtil.eventifyInternalLinks(this._catalogProductBase.contextString);
            }
            this.nameLabel.text = this._catalogProductBase.name;
            this.nameLabel.reset();
            if(this._catalogProductBase.description)
            {
               this.descriptionBlock.visible = true;
               this.descriptionBlock.includeInLayout = true;
               if(this._layout == LAYOUT_SHOP_DEEP_LINK)
               {
                  this.descriptionBlock.text = this._catalogProductBase.description;
               }
               else if(this._layout == LAYOUT_SHOP_CONTEXT)
               {
                  this.descriptionBlock.text = TextUtil.clipText(this._catalogProductBase.description,120,true);
               }
               else
               {
                  this.descriptionBlock.text = TextUtil.clipText(this._catalogProductBase.description,85,true);
               }
            }
            if(ShopUtil.canCurrentUserBuyProductBasedOnExperience(this._catalogProductBase))
            {
               this.buildProducts();
               this.productList.visible = this.productList.includeInLayout = true;
               displayButonSet = true;
            }
            else
            {
               this.lockedIndicator.catalogProductBase = this._catalogProductBase;
               this.lockedIndicator.visible = this.lockedIndicator.includeInLayout = true;
            }
         }
         if(this._inventoryProduct)
         {
            label1 = "";
            label2 = "";
            if(this._inventoryProduct.purchaseDate)
            {
               purchaseDate = this._inventoryProduct.purchaseDate;
               label1 = "Purchased " + DateUtil.getDateString(purchaseDate);
            }
            else
            {
               label1 = "";
            }
            displayButonSet = true;
            if(this._inventoryProduct.purchaseType == ProductPurchaseType.EXPIRABLE)
            {
               if(this._inventoryProduct.isExpired)
               {
                  label2 = "Item Expired";
               }
               else
               {
                  expirationDate = this._inventoryProduct.expirationDate;
                  now = new Date();
                  dt = expirationDate.time - now.time;
                  remaining = int(dt / DateUtil.DAY) + 1;
                  if(remaining == 1)
                  {
                     remaining = int(dt / DateUtil.HOUR);
                     suffix = remaining == 1?" hour remaining":" hours remaining";
                  }
                  else
                  {
                     suffix = " days remaining";
                  }
                  label2 = remaining + suffix;
               }
            }
            else if(this._inventoryProduct.purchaseType == ProductPurchaseType.PERMANENT_QUANTITY)
            {
               label2 = "Quantity: " + this._inventoryProduct.quantity;
            }
            this.infoLabels.visible = true;
            this.infoLabels.includeInLayout = true;
            this.infoLabels.getLabelAt(0).text = label1 != null && label1.length?label1 + " // " + label2:label2;
         }
         if(this._inventoryProduct)
         {
            this.checkBox.selected = this._inventoryProduct.autoRenew;
         }
         if(this._layout == LAYOUT_INVENTORY_CONTEXT && this._inventoryProduct.catalogProduct && this._catalogProductBase)
         {
            if(this._inventoryProduct.purchaseType == ProductPurchaseType.EXPIRABLE && this._catalogProductBase.purchasable)
            {
               this.buttonSet.addItem("REFILL","refill");
            }
            else if(this._inventoryProduct.purchaseType == ProductPurchaseType.PERMANENT_INSTANCE || this._inventoryProduct.purchaseType == ProductPurchaseType.PERMANENT_QUANTITY)
            {
               this.buttonSet.addItem("SELL","sell");
            }
            this.buttonSet.visible = displayButonSet && this.buttonSet.hasItems;
            this.buttonSet.includeInLayout = this.buttonSet.visible;
            this.checkBox.visible = this._inventoryProduct.purchaseType == ProductPurchaseType.EXPIRABLE && this._inventoryProduct.catalogProduct.purchasable && this._inventoryProduct.catalogProduct.acquirable && this._catalogProductBase.purchasable && displayButonSet;
            this.checkBox.includeInLayout = this.checkBox.visible;
         }
         else if(this._layout == LAYOUT_CLICK_SHOP && this._catalogProductBase)
         {
            if(this._catalogProductBase.purchasable)
            {
               this.buttonSet.addItem("BUY","buy");
            }
            if(this._catalogProductBase.purchasable && ShopUtil.canCurrentUserGiftProductBasedOnExperience(this._catalogProductBase))
            {
               this.buttonSet.addItem("GIFT","gift");
            }
            this.buttonSet.includeInLayout = displayButonSet && this.buttonSet.hasItems;
            this.buttonSet.visible = displayButonSet;
         }
         else if(this._layout == LAYOUT_SHOP_DEEP_LINK && this._catalogProductBase)
         {
            if(this._catalogProductBase.purchasable)
            {
               this.buttonSet.addItem("BUY","buy");
            }
            if(ShopUtil.canCurrentUserGiftProductBasedOnExperience(this._catalogProductBase))
            {
               this.buttonSet.addItem("GIFT","gift");
            }
            this.buttonSet.visible = displayButonSet && this.buttonSet.hasItems;
            this.buttonSet.includeInLayout = this.buttonSet.visible;
         }
         if(!this.trackedView)
         {
            this.trackedView = true;
            if(this._layout == LAYOUT_CLICK_SHOP)
            {
               evt = new GenericValueEvent(GenericValueEvent.MODIFY_VALUE,true);
               evt.key = "conversion_viewed_clickshop";
               evt.intValue = 1;
               StageReference.stage.dispatchEvent(evt);
               AppComponents.analytics.trackAction("clickshop/view");
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var itemLength:int = 0;
         var i:int = 0;
         var item:CatalogProductListItem = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var xPos:int = padding.left;
         var yPos:int = padding.top;
         this.thumbnail.x = xPos;
         this.thumbnail.y = yPos;
         this.thumbnailBg.x = this.thumbnail.x;
         this.thumbnailBg.y = this.thumbnail.y;
         GraphicUtil.centerInto(this.processing,this.thumbnailBg.x,this.thumbnailBg.y,this.thumbnail.width,this.thumbnail.height,true);
         this.closeButton.visible = false;
         this.closeButton.x = unscaledWidth - this.closeButton.width;
         this.closeButton.y = 0;
         if(this._layout == LAYOUT_SHOP_CONTEXT || this._layout == LAYOUT_INVENTORY_CONTEXT || this._layout == LAYOUT_CLICK_SHOP)
         {
            this.nameLabel.setStyleById("strongWhite");
            this.descriptionBlock.setStyleById("white");
            this.infoLabels.getLabelAt(0).setStyleById("smallWhite");
            this.productListDivider.setStyleById("dividerWhite");
            this.buttonSet.setStyleById("shadedButtonDarkSet");
         }
         else
         {
            this.nameLabel.setStyleById("strong");
            this.descriptionBlock.setStyleById("p");
            this.infoLabels.getLabelAt(0).setStyleById("p");
            this.productListDivider.setStyleById("divider");
            this.buttonSet.setStyleById("shadedButtonSet");
            this.thumbnailBg.backgroundGradient = [3439329279,3437947628];
         }
         if(this._layout == LAYOUT_SHOP_CONTEXT)
         {
            this.thumbnailBg.visible = true;
            this.thumbnail.visible = true;
            this.thumbnail.includeInLayout = true;
            this.thumbnail.size = this.THUMBNAIL_CONTEXT_SIZE;
            xPos = xPos + (this.thumbnail.width + 10);
            this.closeButton.visible = false;
         }
         else if(this._layout == LAYOUT_CLICK_SHOP)
         {
            this.thumbnailBg.visible = true;
            this.thumbnail.visible = true;
            this.thumbnail.includeInLayout = true;
            this.thumbnail.size = this.THUMBNAIL_CONTEXT_SIZE;
            xPos = xPos + (this.thumbnail.width + 10);
            this.closeButton.visible = true;
         }
         else if(this._layout == LAYOUT_INVENTORY_CONTEXT)
         {
            this.thumbnailBg.visible = false;
            this.thumbnail.visible = false;
            this.thumbnail.includeInLayout = false;
            this.buttonSet.size = 30;
            this.buttonSet.cornerRadius = 30;
            this.closeButton.visible = true;
         }
         else
         {
            this.thumbnail.visible = true;
            this.thumbnail.includeInLayout = true;
            this.thumbnail.size = this.calculateFullImageSize(unscaledWidth);
            xPos = xPos + (this.thumbnail.width + 20);
         }
         this.thumbnailBg.width = this.thumbnailBg.height = this.thumbnail.size;
         this.nameLabel.x = xPos;
         this.nameLabel.y = yPos;
         var w:Number = unscaledWidth - xPos - padding.right;
         if(this.closeButton.visible)
         {
            w = w - (this.closeButton.width + 5);
         }
         this.nameLabel.width = w;
         yPos = yPos + this.nameLabel.height;
         if(this.descriptionBlock.includeInLayout)
         {
            this.descriptionBlock.x = xPos;
            this.descriptionBlock.y = yPos;
            this.descriptionBlock.width = unscaledWidth - xPos - padding.right;
            yPos = yPos + (this.descriptionBlock.height + this.descriptionBlock.margin.bottom);
         }
         if(this.infoLabels.includeInLayout)
         {
            yPos = yPos + this.infoLabels.margin.top;
            this.infoLabels.x = xPos;
            this.infoLabels.y = yPos;
            this.infoLabels.width = unscaledWidth - xPos - padding.right;
            yPos = yPos + (this.infoLabels.height + this.infoLabels.margin.bottom);
         }
         yPos = unscaledHeight;
         if(this.buttonSet.includeInLayout)
         {
            this.buttonSet.x = unscaledWidth - this.buttonSet.width;
            this.buttonSet.y = unscaledHeight - this.buttonSet.height;
            this.checkBox.y = Math.round(this.buttonSet.y + this.buttonSet.height / 2 - this.checkBox.height / 2);
            yPos = yPos - (this.buttonSet.height + this.buttonSet.margin.top);
         }
         this.productListDivider.visible = this.productList.includeInLayout;
         if(this.productList.includeInLayout)
         {
            yPos = yPos - this.productList.margin.bottom;
            yPos + -this.productListDivider.height;
            this.productListDivider.x = xPos;
            this.productListDivider.y = yPos;
            this.productListDivider.width = unscaledWidth - xPos - padding.right;
            yPos = yPos - this.productList.height;
            this.productList.x = xPos;
            this.productList.y = yPos;
            this.productList.width = unscaledWidth - xPos - padding.right;
            itemLength = this.productList.numContentChildren;
            for(i = 0; i < itemLength; i++)
            {
               item = this.productList.getContentChildAt(i) as CatalogProductListItem;
               item.width = this.productList.width;
            }
         }
         if(this.lockedIndicator.includeInLayout)
         {
            yPos = yPos - this.lockedIndicator.margin.bottom;
            yPos = yPos - this.lockedIndicator.height;
            this.lockedIndicator.x = xPos;
            this.lockedIndicator.y = yPos;
            this.lockedIndicator.width = unscaledWidth - xPos - padding.right;
         }
         this.premiumBadge.x = this.thumbnailBg.x + this.thumbnailBg.width - this.premiumBadge.width - this.premiumBadge.margin.right;
         this.premiumBadge.y = this.thumbnailBg.y + this.premiumBadge.margin.top;
      }
      
      private function buildProducts() : void
      {
         var item:CatalogProductListItem = null;
         var catalogProduct:CatalogProduct = null;
         if(!childrenCreated || !this._catalogProductBase.products || this._catalogProductBase.products.length <= 0)
         {
            return;
         }
         for(var i:int = 0; i < this._catalogProductBase.products.length; i++)
         {
            catalogProduct = this._catalogProductBase.products[i] as CatalogProduct;
            item = this.productFactory.createItem();
            item.type = this._layout == LAYOUT_SHOP_DEEP_LINK?CatalogProductListItem.TYPE_DEEPLINK:CatalogProductListItem.TYPE_CONTEXT;
            item.data = catalogProduct;
            item.useDivider = true;
            item.categoryKey = this._catalogProductBase.categoryKey;
            if(this._inventoryProduct != null && this._catalogProductBase.products.length > 1)
            {
               item.idToMatch = this._inventoryProduct.catalogProduct.id;
            }
            this.productList.addContentChild(item as UiContainer);
         }
      }
      
      private function clearProducts() : void
      {
         var item:CatalogProductListItem = null;
         if(!childrenCreated)
         {
            return;
         }
         var items:Array = this.productList.clearContentChildren(false);
         for each(item in items)
         {
            item.data = null;
         }
         this.productFactory.recyleItems(items);
      }
      
      private function onButtonSelect(event:MultiSelectEvent) : void
      {
         var shopEvent:ShopEvent = null;
         var giftEvent:GiftEvent = null;
         if(event.value == "buy" || event.value == "refill")
         {
            shopEvent = new ShopEvent(ShopEvent.OPEN_BUY_POPUP,true,true);
            shopEvent.currencyData = new CurrencyData(CurrencyType.getById(this._catalogProductBase.defaultProduct.currencyType));
            shopEvent.catalogProductBase = this._catalogProductBase;
            dispatchEvent(shopEvent);
         }
         else if(event.value == "sell")
         {
            shopEvent = new ShopEvent(ShopEvent.SELL_INVENTORY_ITEM,true,true);
            shopEvent.inventoryProduct = this._inventoryProduct;
            dispatchEvent(shopEvent);
         }
         else if(event.value == "gift")
         {
            giftEvent = new GiftEvent(GiftEvent.OPEN_SEND_PRODUCT_AS_GIFT_POPUP,true,true);
            giftEvent.catalogProductBase = this._catalogProductBase;
            dispatchEvent(giftEvent);
         }
      }
      
      private function calculateFullImageSize(unscaledWidth:Number) : Number
      {
         return Math.floor(Math.max((unscaledWidth - padding.horizontal) * 0.35,182));
      }
      
      private function getFullProductBase() : void
      {
         var event:ShopEvent = new ShopEvent(ShopEvent.GET_PRODUCT,true);
         if(this._inventoryProduct)
         {
            event.productID = this._inventoryProduct.catalogProductBase.id;
         }
         else if(this._catalogProductBase)
         {
            event.productID = this._catalogProductBase.id;
         }
         var responder:Responder = new Responder();
         responder.setAsyncListeners(this.onProductGotten,this.onProductFailed);
         event.responder = responder;
         dispatchEvent(new ContainerEvent(ContainerEvent.START_PROCESSING,true));
         StageReference.stage.dispatchEvent(event);
      }
      
      private function onProductGotten(event:AsyncEvent) : void
      {
         this.updateInventoryFlag = true;
         this._catalogProductBase = CatalogProductBase(event.data);
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
      }
      
      private function onProductFailed(event:AsyncEvent) : void
      {
         this.updateInventoryFlag = true;
         if(this._inventoryProduct)
         {
            this._catalogProductBase = this._inventoryProduct.catalogProductBase;
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
      }
      
      protected function onCloseClick(event:Event) : void
      {
         AppComponents.contextMenuManager.hide();
      }
      
      public function clear() : void
      {
      }
      
      protected function onImageLoadBegin(event:UiEvent) : void
      {
         this.processing.visible = true;
         this.processing.animate = true;
      }
      
      protected function onImageLoadComplete(event:UiEvent) : void
      {
         this.processing.visible = false;
         this.processing.animate = false;
      }
      
      protected function onRemoved(event:Event) : void
      {
         this.onImageLoadComplete(null);
         this.trackedView = false;
      }
      
      protected function onNameClick(event:MouseEvent) : void
      {
         var url:String = this._catalogProductBase.shopURL;
         AppComponents.stateManager.processURL(url);
         this.onCloseClick(null);
      }
      
      protected function onDescriptionClick(event:MouseEvent) : void
      {
         this.descriptionBlock.text = this._catalogProductBase.description;
         invalidateDisplayList();
         invalidateSize();
      }
   }
}
