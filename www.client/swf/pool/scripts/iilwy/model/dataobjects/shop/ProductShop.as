package iilwy.model.dataobjects.shop
{
   public class ProductShop
   {
       
      
      public var id:int;
      
      public var key:String;
      
      public var name:String;
      
      public var categories:Array;
      
      public var themeDescriptor:Object;
      
      public var imageURL:String;
      
      public var iconURL:String;
      
      public var gameUID:int = -1;
      
      public var minimumPremiumLevel:int;
      
      public var listed:Boolean = true;
      
      public function ProductShop()
      {
         super();
      }
      
      public function getCategoryByKey(key:String) : ProductCategory
      {
         var cat:ProductCategory = null;
         for each(cat in this.categories)
         {
            if(key == cat.key)
            {
               return cat;
            }
         }
         return null;
      }
      
      public function get hasPreviewableCategories() : Boolean
      {
         var cat:ProductCategory = null;
         for each(cat in this.categories)
         {
            if(cat.isPreviewable)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get hasBrandBoost() : Boolean
      {
         if(this.key == "profile" || this.key == "balloono" || this.key == "hoverkart" || this.key == "drawmything")
         {
            return true;
         }
         return false;
      }
   }
}
