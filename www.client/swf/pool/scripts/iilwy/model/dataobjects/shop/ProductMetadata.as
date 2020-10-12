package iilwy.model.dataobjects.shop
{
   public class ProductMetadata
   {
       
      
      public var data:Object;
      
      public function ProductMetadata(name:String, metadata:Object)
      {
         this.data = {};
         super();
         this.data = metadata;
         if(this.data)
         {
            this.data.name = name;
         }
      }
      
      public function setParam(name:String, value:*) : void
      {
         this.data[name] = value;
      }
      
      public function getParamValue(name:String) : *
      {
         if(this.data && this.data[name])
         {
            return this.data[name];
         }
         return null;
      }
      
      public function clone() : ProductMetadata
      {
         var name:* = null;
         var clonedProductMetadata:ProductMetadata = null;
         var clonedMetadata:Object = new Object();
         for(name in this.data)
         {
            clonedMetadata[name] = this.data[name];
         }
         clonedProductMetadata = new ProductMetadata(clonedMetadata.name,clonedMetadata);
         return clonedProductMetadata;
      }
   }
}
