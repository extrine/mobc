package iilwy.utils
{
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.user.PrivateUserData;
   
   public class InstantPurchaseUtil
   {
       
      
      public function InstantPurchaseUtil()
      {
         super();
      }
      
      public static function showErrorForBase(baseID:int) : void
      {
         var reason:String = canCurrentPlayerBuyProductReason(baseID);
         if(reason)
         {
            AppComponents.alertManager.showError(reason);
         }
      }
      
      public static function getPriceForBase(baseID:int) : int
      {
         var product:CatalogProduct = getProductForBase(baseID);
         if(product)
         {
            return product.price;
         }
         return 0;
      }
      
      public static function getProductForBase(baseID:int) : CatalogProduct
      {
         var collection:ArrayCollection = null;
         var matchingBase:CatalogProductBase = null;
         var matchingProduct:CatalogProduct = null;
         var base:CatalogProductBase = null;
         try
         {
            collection = AppComponents.model.arcade.currentInstantPuchaseCollection;
         }
         catch(e:Error)
         {
         }
         if(!collection)
         {
            return null;
         }
         for each(base in collection.source)
         {
            if(base.id == baseID)
            {
               matchingBase = base;
               break;
            }
         }
         if(matchingBase && matchingBase.products && matchingBase.products.length > 0)
         {
            matchingProduct = matchingBase.defaultProduct;
         }
         return matchingProduct;
      }
      
      public static function canCurrentPlayerBuyProductReason(baseID:int) : String
      {
         var collection:ArrayCollection = null;
         var matchingBase:CatalogProductBase = null;
         var base:CatalogProductBase = null;
         var matchingProduct:CatalogProduct = null;
         var user:PrivateUserData = AppComponents.model.privateUser;
         if(!user.isLoggedIn)
         {
            return "Please log in to buy this item";
         }
         try
         {
            collection = AppComponents.model.arcade.currentInstantPuchaseCollection;
         }
         catch(e:Error)
         {
         }
         if(!collection)
         {
            return "That item is not available";
         }
         for each(base in collection.source)
         {
            if(base.id == baseID)
            {
               matchingBase = base;
               break;
            }
         }
         matchingProduct = getProductForBase(baseID);
         if(!matchingProduct || !matchingBase)
         {
            return "That item is not available";
         }
         if(user.currentBalance.soft < matchingProduct.price)
         {
            return "Please add more coins to buy this item";
         }
         if(user.profile.premiumLevel < matchingBase.minimumPremiumLevel)
         {
            return "Please upgrade to a STAR account to buy this item";
         }
         if(AppComponents.model.shop.instantPurchaseFailures > 2)
         {
            return "We lost connection to the server. Please refresh";
         }
         return null;
      }
      
      public static function canCurrentPlayerBuyProduct(baseID:int) : Boolean
      {
         var reason:String = canCurrentPlayerBuyProductReason(baseID);
         return !reason;
      }
   }
}
