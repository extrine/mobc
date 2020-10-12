package iilwy.model.dataobjects.shop
{
   import iilwy.collections.PagingArrayCollection;
   
   public class ProductPage
   {
       
      
      public var numPages:uint;
      
      public var page:uint;
      
      public var items:PagingArrayCollection;
      
      public function ProductPage()
      {
         super();
      }
   }
}
