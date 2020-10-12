package iilwy.model.dataobjects.shop
{
   public class CatalogProduct extends AbstractProduct
   {
       
      
      public var name:String;
      
      public var acquirable:Boolean;
      
      public var acquireLimit:int;
      
      public var price:int;
      
      public var productType:String;
      
      public var purchasable:Boolean;
      
      public var purchaseLimit:int;
      
      public var stockQuantity:Number;
      
      public var currencyType:String;
      
      public var imageURL:String;
      
      public function CatalogProduct()
      {
         super();
      }
      
      override public function clone() : AbstractProduct
      {
         var clonedProduct:CatalogProduct = new CatalogProduct();
         clonedProduct.id = id;
         clonedProduct.packQuantity = packQuantity;
         clonedProduct.units = units;
         clonedProduct.purchaseType = purchaseType;
         clonedProduct.sellbackSoftAmount = sellbackSoftAmount;
         clonedProduct.sellbackCurrencyType = sellbackCurrencyType;
         clonedProduct.name = this.name;
         clonedProduct.acquirable = this.acquirable;
         clonedProduct.acquireLimit = this.acquireLimit;
         clonedProduct.price = this.price;
         clonedProduct.productType = this.productType;
         clonedProduct.purchasable = this.purchasable;
         clonedProduct.purchaseLimit = this.purchaseLimit;
         clonedProduct.stockQuantity = this.stockQuantity;
         clonedProduct.currencyType = this.currencyType;
         clonedProduct.imageURL = this.imageURL;
         return clonedProduct;
      }
      
      public function get stockQuantityString() : String
      {
         var result:String = null;
         if(!isNaN(this.stockQuantity))
         {
            if(this.stockQuantity <= 0)
            {
               result = "Sold Out";
            }
            else
            {
               result = this.stockQuantity + " In Stock";
            }
         }
         return result;
      }
   }
}
