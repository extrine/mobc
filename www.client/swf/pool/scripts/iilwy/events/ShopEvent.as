package iilwy.events
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import iilwy.data.PageCommand;
   import iilwy.display.popups.shop.AbstractCurrencyPack;
   import iilwy.display.popups.shop.ISecurePopupView;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.model.dataobjects.shop.InventoryProductCollection;
   import iilwy.model.dataobjects.shop.ProductShopDeepLink;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   import iilwy.model.dataobjects.shop.enum.PartnerCurrency;
   import iilwy.model.dataobjects.user.CurrencyData;
   import iilwy.utils.Responder;
   
   public class ShopEvent extends DataResponderEvent
   {
      
      public static const GET_PRODUCT:String = "iilwy.events.ShopEvent.GET_PRODUCT";
      
      public static const GET_PRODUCTS:String = "iilwy.events.ShopEvent.GET_PRODUCTS";
      
      public static const GET_FEATURED_PRODUCTS:String = "iilwy.events.ShopEvent.GET_FEATURED_PRODUCTS";
      
      public static const GET_RANDOMIZE_PREVIEW_PRODUCTS:String = "iilwy.events.ShopEvent.GET_RANDOMIZE_PREVIEW_PRODUCTS";
      
      public static const GET_RECOMMENDED_PRODUCTS:String = "iilwy.events.ShopEvent.GET_RECOMMENDED_PRODUCTS";
      
      public static const GET_SHOP:String = "iilwy.events.ShopEvent.GET_SHOP";
      
      public static const GET_SHOPS:String = "iilwy.events.ShopEvent.GET_SHOPS";
      
      public static const NAVIGATE_TO_SHOP_URL:String = "iilwy.events.ShopEvent.NAVIGATE_TO_SHOP_URL";
      
      public static const OPEN_BUY_POPUP:String = "iilwy.events.ShopEvent.OPEN_BUY_POPUP";
      
      public static const OPEN_COINSHOP:String = "iilwy.events.ShopEvent.OPEN_COINSHOP";
      
      public static const OPEN_CASHSHOP:String = "iilwy.events.ShopEvent.OPEN_CASHSHOP";
      
      public static const OPEN_CURRENCY_EXCHANGE:String = "iilwy.events.ShopEvent.OPEN_CURRENCY_EXCHANGE";
      
      public static const OPEN_PARTNER_CURRENCY_EXCHANGE:String = "iilwy.events.ShopEvent.OPEN_PARTNER_CURRENCY_EXCHANGE";
      
      public static const OPEN_SECURE_POPUP:String = "iilwy.events.ShopEvent.OPEN_SECURE_POPUP";
      
      public static const OPEN_PRODUCT_SHOP_POPUP:String = "iilwy.events.ShopEvent.OPEN_PRODUCT_SHOP_POPUP";
      
      public static const UPDATE_PRODUCTS:String = "iilwy.events.ShopEvent.UPDATE_PRODUCTS";
      
      public static const PRODUCTS_UPDATED:String = "iilwy.events.ShopEvent.PRODUCTS_UPDATED";
      
      public static const BUY_PRODUCT:String = "iilwy.events.ShopEvent.BUY_PRODUCT";
      
      public static const BUY_PRODUCTS:String = "iilwy.events.ShopEvent.BUY_PRODUCTS";
      
      public static const GRANT_FREE_ITEM:String = "iilwy.events.ShopEvent.GRANT_FREE_ITEM";
      
      public static const GET_INVENTORY:String = "iilwy.events.ShopEvent.GET_INVENTORY";
      
      public static const ADD_CURRENCY:String = "iilwy.events.ShopEvent.ADD_CURRENCY";
      
      public static const EXCHANGE_CURRENCY:String = "iilwy.events.ShopEvent.EXCHANGE_CURRENCY";
      
      public static const EXCHANGE_PARTNER_CURRENCY:String = "iilwy.events.ShopEvent.EXCHANGE_PARTNER_CURRENCY";
      
      public static const UPDATE_PRODUCT:String = "iilwy.events.ShopEvent.UPDATE_PRODUCT";
      
      public static const DEEP_LINK_TO_PRODUCT:String = "iilwy.events.ShopEvent.DEEP_LINK_TO_PRODUCT";
      
      public static const TRACK_PURCHASE_CONTEXT:String = "iilwy.events.ShopEvent.TRACK_PURCHASE_CONTEXT";
      
      public static const TRACK_TOP_UP_CONTEXT:String = "iilwy.events.ShopEvent.TRACK_TOP_UP_CONTEXT";
      
      public static const PREVIEW_PRODUCT:String = "iilwy.events.ShopEvent.PREVIEW_PRODUCT";
      
      public static const SHOP_CHANGED:String = "iilwy.events.ShopEvent.SHOP_CHANGED";
      
      public static const SELL_INVENTORY_ITEM:String = "iilwy.events.ShopEvent.SELL_INVENTORY_ITEM";
      
      public static const GET_ALL_PRODUCTS_STATIC:String = "iilwy.events.ShopEvent.GET_ALL_PRODUCTS_STATIC";
      
      public static const INVENTORY_ITEM_UPDATED:String = "iilwy.events.ShopEvent.INVENTORY_ITEM_UPDATED";
      
      public static const NUM_PER_PAGE:int = 10;
       
      
      public var userID:int = -1;
      
      public var shopID:int = -1;
      
      public var shopIDs:Array;
      
      public var categoryID:int = -1;
      
      public var productID:int = -1;
      
      public var tagIDs:Array;
      
      public var catalogProductBase:CatalogProductBase;
      
      public var inventoryProduct:InventoryProduct;
      
      public var inventoryProductCollection:InventoryProductCollection;
      
      public var deepLink:ProductShopDeepLink;
      
      public var quantity:int;
      
      public var active:Boolean;
      
      public var renew:Boolean;
      
      public var forceAll:Boolean;
      
      public var forcePurchase:Boolean;
      
      public var page:uint = 1;
      
      public var purchasableFilter:String;
      
      public var sortFilter:String;
      
      public var minRequiredGameLevel:int = 0;
      
      public var maxRequiredGameLevel:int = 2.147483647E9;
      
      public var minRequiredSiteLevel:int = 0;
      
      public var maxRequiredSiteLevel:int = 2.147483647E9;
      
      public var updateCollectionOnGotten:Boolean;
      
      public var url:String;
      
      public var limit:int = -1;
      
      public var pageCommand:PageCommand;
      
      public var securePopupView:ISecurePopupView;
      
      public var currencyPack:AbstractCurrencyPack;
      
      public var currencyData:CurrencyData;
      
      public var currencyType:CurrencyType;
      
      public var partnerCurrency:PartnerCurrency;
      
      public var exchangeAmount:Number;
      
      public var showPurchaseConfirmations:Boolean = true;
      
      public var context:String;
      
      public var useCache:Boolean = false;
      
      public function ShopEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         this.tagIDs = [];
         super(type,bubbles,cancelable,data);
      }
      
      public static function dispatch(type:String, eventDispatcher:EventDispatcher, responder:Responder = null, userID:int = -1, shopID:int = -1, categoryID:int = -1, page:uint = 1, sortFilter:String = null, tagIDs:Array = null) : Boolean
      {
         var event:ShopEvent = new ShopEvent(type,true);
         event.responder = responder;
         event.userID = userID;
         event.shopID = shopID;
         event.categoryID = categoryID;
         event.page = page;
         event.sortFilter = sortFilter;
         event.tagIDs = Boolean(tagIDs)?tagIDs:[];
         var b:Boolean = eventDispatcher.dispatchEvent(event);
         return b;
      }
      
      override public function clone() : Event
      {
         var copy:ShopEvent = new ShopEvent(type,bubbles,cancelable,data);
         copy.responder = responder;
         copy.userID = this.userID;
         copy.shopID = this.shopID;
         copy.categoryID = this.categoryID;
         copy.productID = this.productID;
         copy.tagIDs = this.tagIDs.concat();
         copy.catalogProductBase = this.catalogProductBase.clone();
         copy.inventoryProductCollection = this.inventoryProductCollection.clone();
         copy.deepLink = this.deepLink;
         copy.quantity = this.quantity;
         copy.active = this.active;
         copy.renew = this.renew;
         copy.forceAll = this.forceAll;
         copy.forcePurchase = this.forcePurchase;
         copy.page = this.page;
         copy.purchasableFilter = this.purchasableFilter;
         copy.sortFilter = this.sortFilter;
         copy.updateCollectionOnGotten = this.updateCollectionOnGotten;
         copy.url = this.url;
         copy.pageCommand = Boolean(this.pageCommand)?this.pageCommand.clone():null;
         copy.securePopupView = this.securePopupView;
         copy.currencyPack = this.currencyPack;
         copy.currencyData = this.currencyData;
         copy.currencyType = this.currencyType;
         copy.partnerCurrency = this.partnerCurrency;
         copy.exchangeAmount = this.exchangeAmount;
         copy.showPurchaseConfirmations = this.showPurchaseConfirmations;
         copy.context = this.context;
         copy.useCache = this.useCache;
         return copy;
      }
      
      override public function toString() : String
      {
         return formatToString("ShopEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
