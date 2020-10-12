package iilwy.model.dataobjects.shop.enum
{
   import flash.utils.Dictionary;
   
   public class CurrencyType
   {
      
      public static const HARD:CurrencyType = new CurrencyType("site_hard","site_hard","cash","OMGPOP Cash","OMGPOP Cash","OMGPOP Cash gets you power-ups, in game items and great stuff for your profile that you can\'t get with coins.");
      
      public static const SOFT:CurrencyType = new CurrencyType("coins","coins","coin","Coin","Coins","Coins get you power-ups, in game items and great stuff for your profile.");
      
      public static const FB_CREDIT:CurrencyType = new CurrencyType("fb_credit_proxy","fb_credit_proxy","fbcredit","Facebook Credit","Facebook Credits","Facebook Credits get you power-ups, in game items and great stuff for your profile.");
      
      protected static var currencyDict:Dictionary;
       
      
      public var id:String;
      
      public var remoteId:String;
      
      public var historyId:String;
      
      public var title:String;
      
      public var titlePlural:String;
      
      public var description:String;
      
      public function CurrencyType(id:String, remoteId:String, historyId:String, title:String, titlePlural:String, description:String)
      {
         super();
         this.id = id;
         this.remoteId = remoteId;
         this.historyId = historyId;
         this.title = title;
         this.titlePlural = titlePlural;
         this.description = description;
         if(!currencyDict)
         {
            currencyDict = new Dictionary();
         }
         currencyDict[id] = this;
      }
      
      public static function getById(id:String) : CurrencyType
      {
         return CurrencyType(currencyDict[id]);
      }
      
      public static function getAll() : Array
      {
         return [HARD,SOFT];
      }
   }
}
