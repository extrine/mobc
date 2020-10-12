package iilwy.display.thumbnails
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.data.PageCommand;
   import iilwy.events.ShopEvent;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.model.dataobjects.shop.ProductShopDeepLink;
   import iilwy.net.MediaProxy;
   import iilwy.ui.controls.Thumbnail;
   import iilwy.ui.partials.ImageSash;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class ProductThumbnail extends Thumbnail
   {
      
      private static var contextButtonArt:BitmapData;
      
      private static var buyButtonArt:BitmapData;
       
      
      public var contextMenuEnabled:Boolean = true;
      
      public var deepLinkEnabled:Boolean = true;
      
      public var contextButtonOverAlpha:Number = 0.9;
      
      public var contextButtonOutAlpha:Number = 0;
      
      public var contextMenuAlign:String;
      
      public var state:String;
      
      private var contextButton:Bitmap;
      
      private var _inventoryProduct:InventoryProduct;
      
      private var _catalogProductBase:CatalogProductBase;
      
      private var _contextButtonAlign:String;
      
      private var _contextButtonVisible:Boolean;
      
      private var _sash:ImageSash;
      
      private var _isPNG:Boolean;
      
      public function ProductThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail", useSash:Boolean = false)
      {
         this.state = ControlState.UP;
         super(x,y,size,styleID);
         this._contextButtonAlign = ControlAlign.CENTER_MIDDLE;
         this.contextMenuAlign = ControlAlign.LEFT_BOTTOM;
         this.contextButton = new Bitmap();
         this.contextButton.bitmapData = ProductThumbnail.createContextButtonArt();
         addChild(this.contextButton);
         if(useSash)
         {
            this.useSash();
         }
         useHandCursor = true;
         buttonMode = true;
         tabEnabled = false;
         addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
      }
      
      private static function createContextButtonArt() : BitmapData
      {
         var canvas:Sprite = null;
         if(!contextButtonArt)
         {
            canvas = new Sprite();
            UiRender.renderRoundRect(canvas,2566914048,0,0,20,16,7);
            UiRender.renderTriangle(canvas,16777215,4,6,12,6);
            contextButtonArt = new BitmapData(20,16,true,16777215);
            contextButtonArt.draw(canvas);
         }
         return contextButtonArt;
      }
      
      public function useBuyContextButton() : void
      {
      }
      
      public function useSash(width:Number = 124, height:Number = 30) : void
      {
         this._sash = new ImageSash(this,"HOT",width,height);
         addChild(this._sash);
      }
      
      public function hideSash() : void
      {
         if(this._sash)
         {
            this._sash.visible = false;
         }
      }
      
      public function showSash(sashLabel:String = null, width:Number = 124, height:Number = 30) : void
      {
         if(!this._sash)
         {
            this.useSash(width,height);
         }
         if(sashLabel)
         {
            this._sash.label = sashLabel;
         }
         this._sash.visible = true;
      }
      
      public function get inventoryProduct() : InventoryProduct
      {
         return this._inventoryProduct;
      }
      
      public function set isPNG(value:Boolean) : void
      {
         this._isPNG = value;
      }
      
      private function setURL(imageURL:String) : void
      {
         var jpgIndex:int = 0;
         var correctFileTypeURL:String = imageURL;
         if(imageURL.indexOf(AppProperties.fileServerStatic) > -1)
         {
            url = imageURL;
            return;
         }
         if(this._isPNG)
         {
            if(correctFileTypeURL != null)
            {
               jpgIndex = correctFileTypeURL.indexOf(".jpg");
               if(jpgIndex > -1)
               {
                  correctFileTypeURL = correctFileTypeURL.replace(".jpg",".png");
               }
            }
         }
         if(width >= 200)
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_MEDIUM,this._isPNG);
         }
         else if(width > 130)
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_SMALL,this._isPNG);
         }
         else if(width >= 80)
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_LARGE_THUMB,this._isPNG);
         }
         else if(width >= 40)
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_MEDIUM_THUMB,this._isPNG);
         }
         else if(width >= 20)
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_SMALL_THUMB,this._isPNG);
         }
         else
         {
            url = MediaProxy.url(correctFileTypeURL,MediaProxy.SIZE_TINY_THUMB,this._isPNG);
         }
      }
      
      public function set inventoryProduct(value:InventoryProduct) : void
      {
         this._inventoryProduct = value;
         if(!value || !value.catalogProductBase || !value.catalogProductBase.imageURL)
         {
            url = null;
         }
         else
         {
            this.setURL(value.catalogProductBase.imageURL);
         }
      }
      
      public function get catalogProductBase() : CatalogProductBase
      {
         return this._catalogProductBase;
      }
      
      public function set catalogProductBase(value:CatalogProductBase) : void
      {
         this._catalogProductBase = value;
         if(!value || !value.imageURL)
         {
            url = null;
         }
         else
         {
            this.setURL(value.imageURL);
         }
      }
      
      public function set contextButtonAlign(value:String) : void
      {
         this._contextButtonAlign = value;
         invalidateDisplayList();
      }
      
      public function set contextButtonVisible(value:Boolean) : void
      {
         this._contextButtonVisible = value;
         invalidateDisplayList();
      }
      
      public function get sash() : ImageSash
      {
         return this._sash;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._contextButtonAlign == ControlAlign.CENTER_MIDDLE)
         {
            GraphicUtil.centerInto(this.contextButton,0,0,unscaledWidth,unscaledHeight,true);
         }
         else if(this._contextButtonAlign == ControlAlign.TOP_LEFT)
         {
            this.contextButton.x = borderSize + 5;
            this.contextButton.y = borderSize + 5;
         }
         if(this._contextButtonVisible)
         {
            if(this.state == ControlState.OVER)
            {
               this.contextButton.visible = true;
               this.contextButton.alpha = this.contextButtonOverAlpha;
            }
            else if(this.state == ControlState.UP)
            {
               this.contextButton.visible = true;
               this.contextButton.alpha = this.contextButtonOutAlpha;
            }
         }
         else
         {
            this.contextButton.visible = false;
         }
      }
      
      protected function onMouseClick(event:MouseEvent) : void
      {
         var shopEvent:ShopEvent = null;
         var currentPageCommand:PageCommand = null;
         if(this.deepLinkEnabled && !this.contextMenuEnabled && this._catalogProductBase)
         {
            shopEvent = new ShopEvent(ShopEvent.DEEP_LINK_TO_PRODUCT,true);
            shopEvent.categoryID = this._catalogProductBase.categoryID;
            shopEvent.deepLink = new ProductShopDeepLink();
            currentPageCommand = AppComponents.stateManager.currentPageCommand;
            shopEvent.deepLink.basePath = currentPageCommand.path.join("/");
            shopEvent.deepLink.categoryKey = this._catalogProductBase.categoryKey;
            shopEvent.productID = this._catalogProductBase.id;
            shopEvent.catalogProductBase = this._catalogProductBase;
            dispatchEvent(shopEvent);
            return;
         }
      }
      
      protected function onMouseDown(event:MouseEvent) : void
      {
         if(this.contextMenuEnabled)
         {
            if(this._inventoryProduct)
            {
               AppComponents.contextMenuManager.showInventoryProductContextMenu(this._inventoryProduct,this,this.contextMenuAlign);
            }
            else if(this._catalogProductBase)
            {
               AppComponents.contextMenuManager.showClickShopContextMenu(this._catalogProductBase,null,this,this.contextMenuAlign);
            }
         }
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.state = ControlState.OVER;
         invalidateDisplayList();
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.state = ControlState.UP;
         invalidateDisplayList();
      }
   }
}
