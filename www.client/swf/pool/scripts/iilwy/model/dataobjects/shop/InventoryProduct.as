package iilwy.model.dataobjects.shop
{
   import iilwy.utils.ObjectUtil;
   
   public class InventoryProduct extends AbstractProduct
   {
       
      
      public var active:Boolean;
      
      public var purchaseDate:Date;
      
      public var expirationDate:Date;
      
      public var shopID:int;
      
      public var autoRenew:Boolean;
      
      public var meta:ProductMetadata;
      
      public var quantity:Number;
      
      public var catalogProduct:CatalogProduct;
      
      public var catalogProductBase:CatalogProductBase;
      
      public var inventoryMetadata;
      
      public function InventoryProduct()
      {
         super();
      }
      
      override public function clone() : AbstractProduct
      {
         var clonedProduct:InventoryProduct = new InventoryProduct();
         clonedProduct.id = id;
         clonedProduct.packQuantity = packQuantity;
         clonedProduct.units = units;
         clonedProduct.purchaseType = purchaseType;
         clonedProduct.sellbackSoftAmount = sellbackSoftAmount;
         clonedProduct.sellbackCurrencyType = sellbackCurrencyType;
         clonedProduct.quantity = this.quantity;
         clonedProduct.active = this.active;
         clonedProduct.purchaseDate = this.purchaseDate;
         clonedProduct.expirationDate = this.expirationDate;
         clonedProduct.autoRenew = this.autoRenew;
         if(this.meta)
         {
            clonedProduct.meta = this.meta.clone();
         }
         if(this.catalogProduct)
         {
            clonedProduct.catalogProduct = this.catalogProduct.clone() as CatalogProduct;
         }
         if(this.catalogProductBase)
         {
            clonedProduct.catalogProductBase = this.catalogProductBase.clone() as CatalogProductBase;
         }
         this.inventoryMetadata = ObjectUtil.cloneObject(clonedProduct.inventoryMetadata);
         return clonedProduct;
      }
      
      public function get isExpired() : Boolean
      {
         var now:Date = new Date();
         if(!this.expirationDate)
         {
            return false;
         }
         return now.time > this.expirationDate.time;
      }
   }
}
