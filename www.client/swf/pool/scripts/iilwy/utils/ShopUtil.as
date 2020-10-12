package iilwy.utils
{
   import iilwy.application.AppComponents;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.ProductShop;
   import iilwy.model.dataobjects.user.PrivateUserData;
   
   public class ShopUtil
   {
      
      public static const LOCKED_ITEM_MIN_XP:int = 5;
      
      public static var REASON_SOLD_OUT:String = "This Item Is Sold Out";
       
      
      public function ShopUtil()
      {
         super();
      }
      
      public static function canCurrentUserGiftProductBasedOnExperience(base:CatalogProductBase) : Boolean
      {
         if(!base || !base.category)
         {
            return false;
         }
         if(!base.category.isGiftable)
         {
            return false;
         }
         var str:String = canCurrentUserBuyProductBasedOnExperienceReason(base);
         if(str)
         {
            return false;
         }
         if(AppComponents.model.privateUser.profile.experience.level < LOCKED_ITEM_MIN_XP)
         {
            return false;
         }
         return true;
      }
      
      public static function canCurrentUserBuyProductBasedOnExperience(base:CatalogProductBase) : Boolean
      {
         var str:String = canCurrentUserBuyProductBasedOnExperienceReason(base);
         if(str)
         {
            return false;
         }
         return true;
      }
      
      public static function canCurrentUserBuyProductBasedOnExperienceReason(base:CatalogProductBase) : String
      {
         var shop:ProductShop = null;
         var catalogPack:ArcadeGamePackData = null;
         var pertinentGameLevel:int = 0;
         var user:PrivateUserData = AppComponents.model.privateUser;
         if(!base)
         {
            return null;
         }
         try
         {
            shop = AppComponents.model.shop.shopCollection.getShopByID(base.collectionID);
            catalogPack = AppComponents.model.arcade.getCatalogItemByUid(shop.gameUID);
            pertinentGameLevel = user.getGameLevelHash()[catalogPack.id];
         }
         catch(e:Error)
         {
         }
         if(!isNaN(base.stockQuantity) && base.stockQuantity <= 0)
         {
            return ShopUtil.REASON_SOLD_OUT;
         }
         if(user.isLoggedIn && base.minimumExperienceLevel > user.profile.experience.level || !user.isLoggedIn && base.minimumExperienceLevel > 0)
         {
            return "Need OMGPOP Level " + base.minimumExperienceLevel;
         }
         if(user.isLoggedIn && base.minimumGameExperienceLevel > pertinentGameLevel || !user.isLoggedIn && base.minimumGameExperienceLevel > 0)
         {
            return "Need Game Level " + base.minimumGameExperienceLevel;
         }
         if(user.isLoggedIn && base.minimumFriendCount > AppComponents.chatManager.numFriends || !user.isLoggedIn && base.minimumFriendCount > 0)
         {
            return base.minimumFriendCount + " Friends Needed";
         }
         return null;
      }
   }
}
