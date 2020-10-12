package iilwy.model.dataobjects.shop.enum
{
   import flash.utils.Dictionary;
   import iilwy.collections.ArrayCollection;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   
   public class SharedShop
   {
      
      protected static const CHECKERS:SharedShop = new SharedShop("checkers",["fourplay"]);
      
      protected static const POOL:SharedShop = new SharedShop("pool",["nineballpool"]);
      
      protected static const HOVERKART:SharedShop = new SharedShop("hoverkart",["hoverkartbattle"]);
      
      protected static var dictionary:Dictionary;
       
      
      public var parentShopKey:String;
      
      public var childShopKeys:Array;
      
      public function SharedShop(parentShopKey:String, childShopKeys:Array)
      {
         super();
         this.parentShopKey = parentShopKey;
         this.childShopKeys = childShopKeys;
         if(!dictionary)
         {
            dictionary = new Dictionary();
         }
         dictionary[parentShopKey] = this;
      }
      
      public static function shouldIncludeShop(parentShopKey:String, catalog:ArrayCollection) : Boolean
      {
         var game:ArcadeGamePackData = null;
         var sharedShop:SharedShop = getShopByParentKey(parentShopKey);
         if(!sharedShop)
         {
            return false;
         }
         if(!catalog)
         {
            return false;
         }
         for each(game in catalog.source)
         {
            if(sharedShop.childShopKeys.indexOf(game.id) > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getShopByParentKey(parentShopKey:String) : SharedShop
      {
         return dictionary[parentShopKey];
      }
      
      public static function getShopByChildKey(childShopKey:String) : SharedShop
      {
         var sharedShop:SharedShop = null;
         for each(sharedShop in dictionary)
         {
            if(sharedShop.childShopKeys.indexOf(childShopKey) > -1)
            {
               return sharedShop;
            }
         }
         return null;
      }
   }
}
