package iilwy.model.dataobjects.shop
{
   public class ProductTag
   {
       
      
      public var id:int;
      
      public var name:String;
      
      public var type:ProductTagType;
      
      public var description:String;
      
      public var meta:ProductMetadata;
      
      public function ProductTag()
      {
         super();
      }
      
      public function clone() : ProductTag
      {
         var clonedTag:ProductTag = new ProductTag();
         clonedTag.id = this.id;
         clonedTag.name = this.name;
         clonedTag.type = this.type.clone();
         clonedTag.description = this.description;
         if(this.meta)
         {
            clonedTag.meta = this.meta.clone();
         }
         return clonedTag;
      }
   }
}
