package iilwy.display.shop
{
   import flash.display.Sprite;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   import iilwy.model.dataobjects.shop.enum.ProductCategoryKey;
   import iilwy.model.dataobjects.shop.enum.ProductPurchaseType;
   import iilwy.ui.containers.IListItem;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AbstractButton;
   import iilwy.ui.controls.AutoScrollLabel;
   import iilwy.ui.controls.BevelButton;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.TextUtil;
   
   public class CatalogProductListItem extends UiContainer implements IListItem
   {
      
      public static const TYPE_BUTTON:String = "buttonType";
      
      public static const TYPE_CONTEXT:String = "contextType";
      
      public static const TYPE_DEEPLINK:String = "deepLinkType";
      
      public static const LABEL_LIFE:String = "Life";
      
      public static const LABEL_PRICE:String = "Price";
      
      public static const LABEL_BUY:String = "BUY";
       
      
      public var button:BevelButton;
      
      public var priceLabel:PriceIndicator;
      
      public var actionLabel:Label;
      
      private var divider:Divider;
      
      private var quantityUnitsLabel:AutoScrollLabel;
      
      private var check:Sprite;
      
      private var productData:CatalogProduct;
      
      private var _type:String = "contextType";
      
      private var _useDivider:Boolean;
      
      private var _hilightButton:Boolean;
      
      private var _actionText:String;
      
      private var _categoryKey:String;
      
      public var idToMatch:int = -1;
      
      public function CatalogProductListItem()
      {
         super();
         this.button = new BevelButton("",0,0,undefined,50,"bevelButtonColor");
         this.priceLabel = new PriceIndicator();
         this._categoryKey = null;
         setPadding(6,0);
      }
      
      override public function createChildren() : void
      {
         super.createChildren();
         this.button.setPadding(0,30);
         this.button.addEventListener(ButtonEvent.CLICK,this.onButtonClick);
         addContentChild(this.button);
         this.divider = new Divider(0,0,100,1);
         addContentChild(this.divider);
         this.quantityUnitsLabel = new AutoScrollLabel();
         addContentChild(this.quantityUnitsLabel);
         addContentChild(this.priceLabel);
         this.actionLabel = new Label("",0,0,"strong");
         this.actionLabel.fontSize = 9;
         addContentChild(this.actionLabel);
         this.check = Sprite(new GraphicManager.iconCheck2());
         this.check.visible = false;
         this.check.scaleX = this.check.scaleY = 0.16;
         GraphicUtil.setColor(this.check,15527148);
         addContentChild(this.check);
      }
      
      override public function commitProperties() : void
      {
         var qtyLabel:String = null;
         var currencyType:CurrencyType = null;
         var color:uint = 0;
         super.commitProperties();
         if(this.productData)
         {
            if(this.productData.purchaseType == ProductPurchaseType.EXPIRABLE)
            {
               qtyLabel = this.productData.packQuantity + " " + TextUtil.makePlural(this.productData.units,this.productData.packQuantity);
            }
            else if(this.productData.purchaseType == ProductPurchaseType.PERMANENT_QUANTITY && this.productData.packQuantity == 1 && this._categoryKey && this._categoryKey == ProductCategoryKey.POWERUP)
            {
               qtyLabel = LABEL_LIFE;
            }
            else if(this._type == TYPE_BUTTON)
            {
               qtyLabel = LABEL_BUY;
            }
            else
            {
               qtyLabel = LABEL_PRICE;
               if(this.productData.stockQuantityString)
               {
                  qtyLabel = this.productData.stockQuantityString;
               }
            }
            if(this._type == TYPE_BUTTON)
            {
               qtyLabel = qtyLabel.toUpperCase();
               this.button.hilight = this._hilightButton;
               this.button.label = qtyLabel;
            }
            else
            {
               this.quantityUnitsLabel.text = qtyLabel;
            }
            this.button.visible = this.button.includeInLayout = this._type == TYPE_BUTTON;
            this.quantityUnitsLabel.visible = this.quantityUnitsLabel.includeInLayout = this._type != TYPE_BUTTON;
            currencyType = CurrencyType.getById(this.productData.currencyType);
            this.priceLabel.amount = this.productData.price;
            this.priceLabel.currencyType = currencyType;
            this.actionLabel.visible = this.actionLabel.includeInLayout = this._actionText != null;
            if(this.actionLabel.visible)
            {
               this.actionLabel.text = this._actionText;
            }
            if(this.button.visible && this.button.hasOwnProperty("color"))
            {
               color = 4285777408;
               this.button.color = color;
               if(this.actionLabel.visible)
               {
                  this.actionLabel.fontColor = color;
               }
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.check.visible = false;
         if(this._type == TYPE_BUTTON)
         {
            this.divider.setStyleById("divider");
            this.priceLabel.setStyleById("p");
         }
         else if(this._type == TYPE_DEEPLINK)
         {
            this.divider.setStyleById("divider");
            this.quantityUnitsLabel.setStyleById("strong");
            this.priceLabel.setStyleById("strong");
         }
         else
         {
            this.divider.setStyleById("dividerWhite");
            this.quantityUnitsLabel.setStyleById("white");
            this.priceLabel.setStyleById("white");
         }
         if(this._type == TYPE_BUTTON)
         {
            this.quantityUnitsLabel.label.fontSize = 12;
         }
         var xPos:Number = padding.left;
         var yPos:Number = padding.top;
         if(this._type == TYPE_BUTTON)
         {
            if(this.actionLabel.visible)
            {
               this.actionLabel.x = unscaledWidth / 2 - this.actionLabel.width / 2;
               this.actionLabel.y = yPos;
               yPos = yPos + this.actionLabel.height;
            }
            this.button.x = unscaledWidth / 2 - this.button.width / 2;
            this.button.y = yPos;
            yPos = yPos + this.button.height;
            this.priceLabel.x = Math.floor(unscaledWidth / 2 - this.priceLabel.width / 2);
            this.priceLabel.y = yPos;
            this.divider.height = unscaledHeight;
         }
         else
         {
            if(this.idToMatch > -1)
            {
               if(this.productData.id == this.idToMatch)
               {
                  this.check.visible = true;
                  this.check.x = xPos + 2;
                  this.check.y = yPos;
               }
               xPos = xPos + 20;
            }
            this.quantityUnitsLabel.x = xPos;
            this.quantityUnitsLabel.y = unscaledHeight / 2 - this.quantityUnitsLabel.height / 2;
            this.priceLabel.x = unscaledWidth - this.priceLabel.width;
            this.priceLabel.y = Math.ceil(unscaledHeight / 2 - this.priceLabel.height / 2);
            this.quantityUnitsLabel.width = unscaledWidth - (unscaledWidth - this.priceLabel.x) - padding.left;
            this.divider.width = unscaledWidth;
         }
         if(this._useDivider)
         {
            this.divider.visible = true;
         }
         else
         {
            this.divider.visible = false;
         }
      }
      
      override public function measure() : void
      {
         super.measure();
         if(this._type != TYPE_BUTTON)
         {
            measuredHeight = 24;
         }
         else if(this._type == TYPE_BUTTON)
         {
            measuredWidth = this.button.width;
            measuredHeight = this.button.height + this.priceLabel.height;
         }
      }
      
      public function get data() : CatalogProduct
      {
         return this.productData;
      }
      
      public function set data(value:CatalogProduct) : void
      {
         this.idToMatch = -1;
         this.productData = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         this._type = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set useDivider(value:Boolean) : void
      {
         if(this._useDivider != value)
         {
            this._useDivider = value;
            invalidateDisplayList();
         }
      }
      
      public function onButtonClick(event:ButtonEvent) : void
      {
         var multiSelect:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.SELECT,true);
         multiSelect.label = (event.target as AbstractButton).label;
         multiSelect.value = this.productData.id;
         dispatchEvent(multiSelect);
      }
      
      public function set selected(value:Boolean) : void
      {
      }
      
      public function set hilightButton(value:Boolean) : void
      {
         this._hilightButton = value;
         invalidateProperties();
      }
      
      public function set categoryKey(value:String) : void
      {
         this._categoryKey = value;
         invalidateProperties();
      }
      
      public function set actionText(value:String) : void
      {
         this._actionText = value;
         invalidateProperties();
      }
      
      public function asUiElement() : UiElement
      {
         return this as UiElement;
      }
   }
}
