package iilwy.display.context
{
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.AutoScrollLabel;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.TextBlock;
   import iilwy.utils.TextUtil;
   
   public class MiniProductContextMenu extends UiModule
   {
       
      
      private var nameLabel:AutoScrollLabel;
      
      private var descriptionBlock:TextBlock;
      
      private var priceLabel:Label;
      
      private var _inventoryProduct:InventoryProduct;
      
      private var _catalogProductBase:CatalogProductBase;
      
      public function MiniProductContextMenu()
      {
         super();
         setPadding(0);
         _wantsFocus = false;
         width = 100;
      }
      
      public function set inventoryProduct(value:InventoryProduct) : void
      {
         this._inventoryProduct = value;
         this._catalogProductBase = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set catalogProductBase(value:CatalogProductBase) : void
      {
         this._catalogProductBase = value;
         this._inventoryProduct = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function createChildren() : void
      {
         this.nameLabel = new AutoScrollLabel();
         this.nameLabel.label.setStyleById("strongWhite");
         this.nameLabel.label.fontSize = 11;
         this.nameLabel.label.selectable = false;
         this.nameLabel.idleScroll = true;
         this.nameLabel.idleScrollDelay = 400;
         addContentChild(this.nameLabel);
         this.descriptionBlock = new TextBlock();
         this.descriptionBlock.setStyleById("white");
         this.descriptionBlock.fontSize = 9;
         addContentChild(this.descriptionBlock);
         this.priceLabel = new Label();
         this.priceLabel.fontColor = 1895935;
         this.priceLabel.fontSize = 9;
         this.priceLabel.selectable = false;
         addContentChild(this.priceLabel);
      }
      
      override public function commitProperties() : void
      {
         var price:int = 0;
         var currency:String = null;
         this.descriptionBlock.visible = false;
         this.descriptionBlock.includeInLayout = false;
         if(this._catalogProductBase)
         {
            this.nameLabel.text = this._catalogProductBase.name.toUpperCase();
            this.nameLabel.reset();
            if(this._catalogProductBase.description)
            {
               this.descriptionBlock.visible = true;
               this.descriptionBlock.includeInLayout = true;
               this.descriptionBlock.text = TextUtil.clipText(this._catalogProductBase.description,85,true);
            }
            price = this._catalogProductBase.defaultProduct.price;
            currency = CurrencyType.getById(this._catalogProductBase.defaultProduct.currencyType).title;
            this.priceLabel.text = price + " " + TextUtil.makePlural(currency,price);
         }
      }
      
      override public function measure() : void
      {
         measuredHeight = 0;
         measuredHeight = measuredHeight + (this.nameLabel.height + 2);
         if(this.descriptionBlock.includeInLayout && this.descriptionBlock.text != "")
         {
            measuredHeight = measuredHeight + (this.descriptionBlock.height + 2);
         }
         measuredHeight = measuredHeight + (this.priceLabel.height + 10);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xPos:int = 0;
         var yPos:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         xPos = padding.left;
         yPos = padding.top;
         this.nameLabel.x = xPos;
         this.nameLabel.y = yPos;
         this.nameLabel.width = unscaledWidth - padding.horizontal;
         yPos = yPos + (this.nameLabel.height + 2);
         this.descriptionBlock.x = xPos;
         this.descriptionBlock.y = yPos;
         this.descriptionBlock.width = unscaledWidth - padding.horizontal;
         yPos = yPos + (this.descriptionBlock.height + 2);
         this.priceLabel.x = xPos;
         this.priceLabel.y = yPos;
         this.priceLabel.width = unscaledWidth - padding.horizontal;
      }
   }
}
