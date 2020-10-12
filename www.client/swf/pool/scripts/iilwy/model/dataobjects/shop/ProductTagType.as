package iilwy.model.dataobjects.shop
{
   public class ProductTagType
   {
       
      
      public var id:int;
      
      public var name:String;
      
      public function ProductTagType()
      {
         super();
      }
      
      public function clone() : ProductTagType
      {
         var clonedTagType:ProductTagType = new ProductTagType();
         clonedTagType.id = this.id;
         clonedTagType.name = this.name;
         return clonedTagType;
      }
   }
}
