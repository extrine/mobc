package iilwy.model.dataobjects.shop
{
   public class AbstractProduct
   {
       
      
      public var id:int;
      
      public var packQuantity:int;
      
      public var units:String;
      
      public var purchaseType:String;
      
      public var sellbackSoftAmount:Number;
      
      public var sellbackCurrencyType:String;
      
      public function AbstractProduct()
      {
         super();
      }
      
      public function clone() : AbstractProduct
      {
         var clonedProduct:AbstractProduct = new AbstractProduct();
         clonedProduct.id = this.id;
         clonedProduct.packQuantity = this.packQuantity;
         clonedProduct.units = this.units;
         clonedProduct.purchaseType = this.purchaseType;
         clonedProduct.sellbackSoftAmount = this.sellbackSoftAmount;
         clonedProduct.sellbackCurrencyType = this.sellbackCurrencyType;
         return clonedProduct;
      }
   }
}
