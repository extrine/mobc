package iilwy.application.analytics
{
   import flash.display.Stage;
   
   public class AnalyticsSettings
   {
       
      
      public var googleEnabled:Boolean = true;
      
      public var iilwyEnabled:Boolean = true;
      
      public var quantcastEnabled:Boolean = true;
      
      public var kontagentEnabled:Boolean = false;
      
      public var mochiEnabled:Boolean = false;
      
      public var debug:Boolean = true;
      
      public var mochiAccount:String = "ccf0050d";
      
      public var googleAccount:String = "UA-501228-3";
      
      public var googleUserVar:String;
      
      public var quantcastOptions;
      
      public var kontagentKey:String;
      
      public var stage:Stage;
      
      public var exchangeRates;
      
      public var currencyTitles;
      
      public function AnalyticsSettings()
      {
         this.exchangeRates = {
            "coins":7000,
            "site_hard":10
         };
         this.currencyTitles = {};
         super();
         this.quantcastOptions = createQuantcastOptions("omgpop","omgpop");
      }
      
      public static function createQuantcastOptions(mediaID:String, labels:String) : *
      {
         var result:* = {
            "publisherId":"p-c6wKoqrBKxbSo",
            "media":"flash",
            "videoId":mediaID,
            "title":mediaID,
            "labels":labels
         };
         return result;
      }
      
      public function getInternalTrackingObject(type:String, path:String) : Object
      {
         var obj:* = {
            "type":type,
            "path":path
         };
         return obj;
      }
   }
}
