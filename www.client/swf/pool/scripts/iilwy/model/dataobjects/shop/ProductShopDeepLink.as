package iilwy.model.dataobjects.shop
{
   import iilwy.data.PageCommand;
   
   public class ProductShopDeepLink
   {
       
      
      private var _basePath:String;
      
      public var shopKey:String;
      
      public var categoryKey:String;
      
      public var productID:int = -1;
      
      public var page:int = 1;
      
      public var sortKey:String;
      
      public var filterKey:String;
      
      public function ProductShopDeepLink()
      {
         super();
      }
      
      public static function createFromPageCommand(pageCommand:PageCommand) : ProductShopDeepLink
      {
         var shopDeepLink:ProductShopDeepLink = null;
         var productID:* = undefined;
         var page:* = undefined;
         var deepLink:Array = pageCommand.subPath;
         if(deepLink && deepLink.length > 0 && deepLink[0] == "shop" || pageCommand.path[pageCommand.path.length - 1] == "shop")
         {
            shopDeepLink = new ProductShopDeepLink();
            shopDeepLink.basePath = pageCommand.path.join("/");
            shopDeepLink.shopKey = getDeepLinkValue("shop",deepLink);
            shopDeepLink.categoryKey = getDeepLinkValue("category",deepLink);
            shopDeepLink.sortKey = getDeepLinkValue("sort",deepLink);
            shopDeepLink.filterKey = getDeepLinkValue("filters",deepLink);
            productID = getDeepLinkValue("product",deepLink);
            shopDeepLink.productID = Boolean(productID)?int(int(productID)):int(-1);
            page = getDeepLinkValue("page",deepLink);
            shopDeepLink.page = Boolean(page)?int(int(page)):int(1);
         }
         return shopDeepLink;
      }
      
      private static function getDeepLinkValue(key:String, deepLink:Array) : *
      {
         var value:* = undefined;
         var len:int = deepLink.length;
         for(var i:int = 0; i < len; i++)
         {
            if(deepLink[i] == key)
            {
               value = deepLink[i + 1];
               break;
            }
         }
         return value;
      }
      
      public function get basePath() : String
      {
         return this._basePath;
      }
      
      public function set basePath(s:String) : void
      {
         if(s.indexOf("shop") >= 0)
         {
            this._basePath = s;
         }
         else
         {
            this._basePath = "shops";
         }
      }
   }
}
