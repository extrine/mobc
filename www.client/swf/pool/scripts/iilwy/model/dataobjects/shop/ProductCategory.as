package iilwy.model.dataobjects.shop
{
   public class ProductCategory
   {
       
      
      public var id:int;
      
      public var key:String;
      
      public var name:String;
      
      public var description:String;
      
      public var iconURL:String;
      
      public var selectionLimit:int;
      
      public var deselectable:Boolean;
      
      public var tagTypes:Array;
      
      public var tags:Array;
      
      public var isPreviewable:Boolean;
      
      public var isGiftable:Boolean;
      
      public function ProductCategory()
      {
         super();
      }
      
      public function clone() : ProductCategory
      {
         var clonedCategory:ProductCategory = new ProductCategory();
         clonedCategory.id = this.id;
         clonedCategory.key = this.key;
         clonedCategory.name = this.name;
         clonedCategory.description = this.description;
         clonedCategory.iconURL = this.iconURL;
         clonedCategory.selectionLimit = this.selectionLimit;
         clonedCategory.deselectable = this.deselectable;
         if(this.tagTypes)
         {
            clonedCategory.tagTypes = this.tagTypes.concat();
         }
         if(this.tags)
         {
            clonedCategory.tags = this.tags.concat();
         }
         return clonedCategory;
      }
   }
}
