package iilwy.model.dataobjects.shop
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.shop.enum.SharedShop;
   import iilwy.utils.ArrayUtil;
   
   public class GlobalProductShopModel extends EventDispatcher
   {
      
      public static var getShopsSortedByFavoriteGame_gameCollection:Array;
       
      
      private var _shopCollection:ProductShopCollection;
      
      private var _productCollection:ArrayCollection;
      
      public var lastSelectedShop:ProductShop;
      
      public var instantPurchaseFailures:int;
      
      public var staticProductCollectionLoaded:Boolean;
      
      public function GlobalProductShopModel()
      {
         super();
         this.shopCollection = new ProductShopCollection();
      }
      
      public static function getShopsSortedByFavoriteGame_sort(a:ProductShop, b:ProductShop) : int
      {
         var indexA:int = ArrayUtil.findIndexOfElementBasedOnParameter(getShopsSortedByFavoriteGame_gameCollection,"uid",a.gameUID);
         var indexB:int = ArrayUtil.findIndexOfElementBasedOnParameter(getShopsSortedByFavoriteGame_gameCollection,"uid",b.gameUID);
         var result:int = indexA == indexB?int(0):indexA > indexB?int(1):int(-1);
         return result;
      }
      
      public function getDisplayShops() : ProductShopCollection
      {
         var shop:ProductShop = null;
         var result:ProductShopCollection = new ProductShopCollection();
         for each(shop in this.shopCollection.source)
         {
            if(shop.listed && shop.minimumPremiumLevel <= AppComponents.model.privateUser.profile.premiumLevel)
            {
               result.source.push(shop);
            }
            else if(!shop.listed)
            {
               if(SharedShop.shouldIncludeShop(shop.key,AppComponents.model.arcade.catalog))
               {
                  result.source.push(shop);
               }
            }
         }
         return result;
      }
      
      public function getShopsSortedByFavoriteGame() : ProductShopCollection
      {
         var gameCollection:ArrayCollection = null;
         if(AppComponents.model.privateUser.isLoggedIn)
         {
            gameCollection = AppComponents.model.arcade.catalogSortedByFavorite;
         }
         else
         {
            gameCollection = AppComponents.model.arcade.catalogPopular;
         }
         var sorted:ProductShopCollection = new ProductShopCollection();
         sorted.source = this.getDisplayShops().source.concat();
         var profileShop:ProductShop = sorted.source.shift();
         getShopsSortedByFavoriteGame_gameCollection = gameCollection.source;
         sorted.source.sort(getShopsSortedByFavoriteGame_sort);
         sorted.source.unshift(profileShop);
         return sorted;
      }
      
      public function getDisplayShopIDs() : Array
      {
         return [1,2,3,5,6,7,8,9,15];
      }
      
      public function get productCollectionStatic() : ArrayCollection
      {
         return this._productCollection;
      }
      
      public function set productCollectionStatic(value:ArrayCollection) : void
      {
         this._productCollection = value;
      }
      
      public function get shopCollection() : ProductShopCollection
      {
         return this._shopCollection;
      }
      
      public function set shopCollection(value:ProductShopCollection) : void
      {
         this._shopCollection = value;
      }
   }
}
