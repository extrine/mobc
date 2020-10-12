package iilwy.model.dataobjects.market.product
{
   import iilwy.model.dataobjects.market.product.searchcommand.ColorMatch;
   import iilwy.model.dataobjects.market.product.searchcommand.PhraseMatch;
   import iilwy.model.dataobjects.market.product.searchcommand.StringMatch;
   
   public class ProductMetadata
   {
      
      public static const COLOR:Object = {
         "name":"color",
         "searchCommand":ColorMatch
      };
      
      public static const STYLE:Object = {
         "name":"style",
         "searchCommand":StringMatch
      };
      
      public static const ITEMNAME:Object = {
         "name":"itemname",
         "searchCommand":StringMatch
      };
      
      public static const CATEGORY:Object = {
         "name":"category",
         "searchCommand":StringMatch
      };
      
      public static const PURCHASEDATE:Object = {
         "name":"purchasedTime",
         "searchCommand":StringMatch
      };
      
      public static const SUBCATEGORY:Object = {
         "name":"subcategory",
         "searchCommand":StringMatch
      };
      
      public static const SHORTMEMO:Object = {
         "name":"shortmemo",
         "searchCommand":StringMatch
      };
      
      public static const LONGMEMO:Object = {
         "name":"longmemo",
         "searchCommand":PhraseMatch
      };
       
      
      public var data:Object;
      
      public function ProductMetadata(name:String, metadata:Object)
      {
         this.data = {};
         super();
         this.data = metadata;
         this.data.itemname = name;
      }
      
      public function setParam(type:String, value:*) : void
      {
         this.data[type] = value;
      }
      
      public function getParamValue(type:String) : *
      {
         if(this.data[type])
         {
            return this.data[type];
         }
         return null;
      }
      
      public function clone() : ProductMetadata
      {
         var type:* = null;
         var clonedProductMetadata:ProductMetadata = null;
         var clonedMetadata:Object = new Object();
         for(type in this.data)
         {
            clonedMetadata[type] = this.data[type];
         }
         clonedProductMetadata = new ProductMetadata(clonedMetadata.itemname,clonedMetadata);
         return clonedProductMetadata;
      }
      
      public function getJSON() : String
      {
         return JSON.serialize(this.data);
      }
   }
}
