package iilwy.utils
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import iilwy.application.AppComponents;
   import iilwy.display.core.Popups;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.CompoundPrice;
   import iilwy.model.dataobjects.shop.enum.CurrencyType;
   
   public class CurrencyUtil
   {
       
      
      public function CurrencyUtil()
      {
         super();
      }
      
      public static function getBalance(currencyType:CurrencyType) : Number
      {
         var balance:Number = -1;
         switch(currencyType.id)
         {
            case CurrencyType.SOFT.id:
               balance = AppComponents.model.privateUser.currentBalance.soft;
               break;
            case CurrencyType.HARD.id:
               balance = AppComponents.model.privateUser.currentBalance.hard;
         }
         return balance;
      }
      
      public static function getIcon(currencyType:CurrencyType, size:Number, showDropShadow:Boolean = true) : Sprite
      {
         var icon:Sprite = null;
         var iconId:String = null;
         try
         {
            iconId = currencyType.id == CurrencyType.FB_CREDIT.id?"fbcredit":currencyType.id == CurrencyType.HARD.id?"cash":"coin";
            icon = new GraphicManager[iconId + "DetailSmall"]();
         }
         catch(e:Error)
         {
            throw new Error("No icon found for " + currencyType.id + " currency type at GrahicManager." + currencyType.title + "DetailSmall");
         }
         icon.width = size;
         icon.height = size;
         if(showDropShadow)
         {
            icon.filters = [new DropShadowFilter(2,90,0,0.4,6,6)];
         }
         return icon;
      }
      
      public static function injectCurrency(currencyType:CurrencyType, value:String, sentenceCase:Boolean = false) : String
      {
         if(value)
         {
            value = value.replace(/%CURRENCY_TITLE%/gi,!!sentenceCase?TextUtil.toSentenceCase(currencyType.title):currencyType.title);
            value = value.replace(/%CURRENCY_TITLE_PLURAL%/gi,!!sentenceCase?TextUtil.toSentenceCase(currencyType.titlePlural):currencyType.titlePlural);
         }
         return value;
      }
      
      public static function getTotalBalanceInCurrency(compoundBalance:CompoundPrice, targetCurrency:CurrencyType) : Number
      {
         var totalBalance:Number = NaN;
         if(targetCurrency.id == CurrencyType.SOFT.id)
         {
            totalBalance = compoundBalance.soft + compoundBalance.hard * getExchangeRate(CurrencyType.HARD,CurrencyType.SOFT);
         }
         else if(targetCurrency.id == CurrencyType.HARD.id)
         {
            totalBalance = compoundBalance.hard + compoundBalance.soft * getExchangeRate(CurrencyType.SOFT,CurrencyType.HARD);
         }
         return totalBalance;
      }
      
      public static function getExchangeRate(fromCurrency:CurrencyType, toCurrency:CurrencyType) : Number
      {
         var exchangeRate:Number = 0;
         if(fromCurrency == CurrencyType.HARD && toCurrency == CurrencyType.SOFT)
         {
            exchangeRate = 700;
         }
         else if(fromCurrency == CurrencyType.SOFT && toCurrency == CurrencyType.HARD)
         {
            exchangeRate = 1;
         }
         return exchangeRate;
      }
      
      public static function getCurrencyTypeFromCatalogBase(value:CatalogProductBase) : CurrencyType
      {
         var defaultProduct:CatalogProduct = null;
         if(value && value.products && value.products.length)
         {
            defaultProduct = value.defaultProduct as CatalogProduct;
            return CurrencyType.getById(defaultProduct.currencyType);
         }
         if(value && value.defaultProduct)
         {
            return CurrencyType.getById(value.defaultProduct.currencyType);
         }
         return null;
      }
      
      public static function getColorForCurrency(currencyType:CurrencyType) : uint
      {
         return currencyType.id == CurrencyType.HARD.id?uint(4285777408):uint(4278233087);
      }
      
      public static function getAddCurrencyPopup(currencyType:CurrencyType) : String
      {
         return Popups["ADD_CURRENCY"];
      }
      
      public static function getAnalyticsId(currencyType:CurrencyType) : String
      {
         return currencyType.title.toLowerCase() + "shop";
      }
   }
}
