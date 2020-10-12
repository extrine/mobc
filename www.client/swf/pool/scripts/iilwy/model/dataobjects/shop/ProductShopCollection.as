package iilwy.model.dataobjects.shop
{
   import iilwy.collections.ArrayCollection;
   
   public class ProductShopCollection extends ArrayCollection
   {
       
      
      public function ProductShopCollection()
      {
         super();
      }
      
      public function getShopByID(id:int) : ProductShop
      {
         for(var i:int = 0; i < length; i++)
         {
            if(ProductShop(_source[i]).id && ProductShop(_source[i]).id == id)
            {
               return ProductShop(_source[i]);
            }
         }
         return null;
      }
      
      public function getShopByName(name:String) : ProductShop
      {
         for(var i:int = 0; i < length; i++)
         {
            if(ProductShop(_source[i]).name && ProductShop(_source[i]).name == name)
            {
               return ProductShop(_source[i]);
            }
         }
         return null;
      }
      
      public function removeShopByID(id:int) : void
      {
         for(var i:int = 0; i < length; i++)
         {
            if(ProductShop(_source[i]).id == id)
            {
               removeItemAt(i);
            }
         }
      }
   }
}
