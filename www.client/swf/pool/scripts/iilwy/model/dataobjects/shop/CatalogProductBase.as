package iilwy.model.dataobjects.shop
{
   public class CatalogProductBase
   {
       
      
      public var id:int;
      
      public var name:String;
      
      public var collectionName:String;
      
      public var collectionID:int = -1;
      
      public var collectionKey:String;
      
      public var category:ProductCategory;
      
      public var categoryID:int;
      
      public var categoryKey:String;
      
      public var categoryName:String;
      
      public var tags:Array;
      
      public var description:String;
      
      public var imageURL:String;
      
      public var assetURL:String;
      
      public var meta:ProductMetadata;
      
      public var minimumPremiumLevel:int;
      
      public var minimumExperienceLevel:int;
      
      public var minimumGameExperienceLevel:int;
      
      public var minimumFriendCount:int;
      
      public var minimumRecruits:int;
      
      public var minimumGameFriends:int;
      
      public var facebookFanRequired:Boolean;
      
      public var popText:String;
      
      public var products:Array;
      
      public var purchasable:Boolean;
      
      public var defaultProduct:CatalogProduct;
      
      public function CatalogProductBase()
      {
         super();
      }
      
      public function clone() : CatalogProductBase
      {
         var clonedProduct:CatalogProductBase = new CatalogProductBase();
         clonedProduct.id = this.id;
         clonedProduct.name = this.name;
         clonedProduct.collectionName = this.collectionName;
         clonedProduct.collectionID = this.collectionID;
         clonedProduct.collectionKey = this.collectionKey;
         clonedProduct.categoryID = this.categoryID;
         clonedProduct.categoryKey = this.categoryKey;
         clonedProduct.categoryName = this.categoryName;
         if(this.tags)
         {
            clonedProduct.tags = this.tags.concat();
         }
         clonedProduct.description = this.description;
         clonedProduct.imageURL = this.imageURL;
         clonedProduct.assetURL = this.assetURL;
         if(this.meta)
         {
            clonedProduct.meta = this.meta.clone();
         }
         clonedProduct.minimumPremiumLevel = this.minimumPremiumLevel;
         clonedProduct.minimumExperienceLevel = this.minimumExperienceLevel;
         clonedProduct.minimumGameExperienceLevel = this.minimumGameExperienceLevel;
         clonedProduct.minimumGameFriends = this.minimumGameFriends;
         clonedProduct.minimumRecruits = this.minimumRecruits;
         clonedProduct.minimumFriendCount = this.minimumFriendCount;
         clonedProduct.facebookFanRequired = this.facebookFanRequired;
         clonedProduct.popText = this.popText;
         if(this.products)
         {
            clonedProduct.products = this.products.concat();
         }
         clonedProduct.purchasable = this.purchasable;
         if(this.defaultProduct)
         {
            clonedProduct.defaultProduct = this.defaultProduct.clone() as CatalogProduct;
         }
         return clonedProduct;
      }
      
      public function getProductByProductID(id:int) : CatalogProduct
      {
         var product:CatalogProduct = null;
         for each(product in this.products)
         {
            if(product.id == id)
            {
               return product;
            }
         }
         return null;
      }
      
      public function getTagsByTagTypeName(name:String) : Array
      {
         var tag:ProductTag = null;
         var filteredTags:Array = [];
         for each(tag in this.tags)
         {
            if(tag.type.name == name)
            {
               filteredTags.push(tag);
            }
         }
         return filteredTags;
      }
      
      public function get shopURL() : String
      {
         var url:String = "/shops/shop/" + this.collectionKey + "/category/" + this.categoryKey + "/product/" + this.id;
         return url;
      }
      
      public function get contextString() : String
      {
         var url:String = null;
         var str:String = null;
         var result:String = "";
         url = "http://www.omgpop.com/shops/";
         if(this.collectionKey && this.collectionName)
         {
            result = result + "In ";
            url = url + ("shop/" + this.collectionKey);
            str = this.collectionName;
            result = result + ("<u><a href=\"" + url + "\">" + str + "</a></u>");
            if(this.categoryKey && this.collectionName)
            {
               result = result + " / ";
               url = url + ("/category/" + this.categoryKey);
               str = this.categoryName;
               result = result + ("<u><a href=\'" + url + "\'>" + str + "</a></u>");
            }
         }
         return result;
      }
      
      public function get stockQuantity() : Number
      {
         if(this.products && this.products.length > 0)
         {
            return CatalogProduct(this.products[0]).stockQuantity;
         }
         return undefined;
      }
      
      public function get stockQuantityString() : String
      {
         if(this.products && this.products.length > 0)
         {
            return CatalogProduct(this.products[0]).stockQuantityString;
         }
         return null;
      }
      
      public function get displayPrice() : int
      {
         return Boolean(this.defaultProduct)?int(this.defaultProduct.price):int(-1);
      }
      
      public function get displayCurrencyType() : String
      {
         return Boolean(this.defaultProduct)?this.defaultProduct.currencyType:null;
      }
      
      public function hasTag(tagID:int) : Boolean
      {
         var pTag:ProductTag = null;
         for each(pTag in this.tags)
         {
            if(pTag.id == tagID)
            {
               return true;
            }
         }
         return false;
      }
   }
}
