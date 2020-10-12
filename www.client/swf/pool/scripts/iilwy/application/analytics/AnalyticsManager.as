package iilwy.application.analytics
{
   import com.google.analytics.GATracker;
   import com.mochi.as3.MochiBot;
   import com.quantcast.as3.QuantcastPixel;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.utils.getTimer;
   import iilwy.delegates.UtilityDelegate;
   import iilwy.model.dataobjects.shop.CatalogProduct;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.ProductTransaction;
   import iilwy.model.dataobjects.shop.enum.ProductPurchaseType;
   import iilwy.tracking.KontagentTracker;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class AnalyticsManager
   {
      
      public static const BRIDGE_MODE:String = "Bridge";
      
      public static const AS3_MODE:String = "AS3";
      
      protected static var VISUAL_DEBUG:Boolean = false;
      
      private static var _instance:AnalyticsManager;
       
      
      private var _initialized:Boolean;
      
      protected var _settings:AnalyticsSettings;
      
      protected var _googleTracker;
      
      protected var _quantcastTracker;
      
      protected var _kontagentTracker;
      
      protected var _kontagentTrackerClass:Class;
      
      protected var _logger:Logger;
      
      protected var _timedDiagnostics;
      
      public function AnalyticsManager()
      {
         this._kontagentTrackerClass = KontagentTracker;
         this._timedDiagnostics = {};
         super();
         this._settings = new AnalyticsSettings();
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.LOG;
      }
      
      public static function getInstance() : AnalyticsManager
      {
         if(!_instance)
         {
            _instance = new AnalyticsManager();
         }
         return _instance;
      }
      
      public function set settings(val:AnalyticsSettings) : void
      {
         this._settings = val;
      }
      
      public function get settings() : AnalyticsSettings
      {
         return this._settings;
      }
      
      public function get kontagentTracker() : KontagentTracker
      {
         return this._kontagentTracker as KontagentTracker;
      }
      
      public function set kontagentTrackerClass(value:Class) : void
      {
         this._kontagentTrackerClass = value;
         if(!this._initialized)
         {
            return;
         }
         if(this._settings.kontagentEnabled)
         {
            try
            {
               this._kontagentTracker = new this._kontagentTrackerClass(this._settings.kontagentKey);
               trace("Kontagent initialized");
            }
            catch(e:Error)
            {
               trace("Error on Kontagent initialization");
               trace(e);
            }
         }
      }
      
      private function initialize() : void
      {
         var stage:Stage = null;
         var mochiSprite:Sprite = null;
         if(this._initialized)
         {
            return;
         }
         if(!this._settings)
         {
            throw new Error("No settings for analytics manager");
         }
         this._initialized = true;
         var account:String = this._settings.googleAccount;
         try
         {
            this._googleTracker = new GATracker(this._settings.stage,account,AS3_MODE,VISUAL_DEBUG);
            this._googleTracker.setDomainName(".omgpop.com");
            if(this._settings.googleUserVar)
            {
               this._googleTracker.setVar(this._settings.googleUserVar);
            }
            trace("Google initialized");
         }
         catch(e:Error)
         {
            trace("Error on Google initialization");
            trace(e);
         }
         if(this._settings.mochiEnabled)
         {
            try
            {
               stage = StageReference.stage;
               mochiSprite = new Sprite();
               mochiSprite.name = "mochiSprite";
               stage.addChild(mochiSprite);
               MochiBot.track(mochiSprite,this._settings.mochiAccount);
            }
            catch(e:Error)
            {
            }
         }
         if(this._settings.quantcastEnabled)
         {
            try
            {
               this._quantcastTracker = new QuantcastPixel(this._settings.quantcastOptions);
               trace("Quantcast initialized");
            }
            catch(e:Error)
            {
               trace("Error on Quantcast initialization");
               trace(e);
            }
         }
         this.kontagentTrackerClass = this._kontagentTrackerClass;
      }
      
      public function trackPageView(path:String) : void
      {
         this.track("page",path);
      }
      
      public function trackDiagnostic(path:String) : void
      {
         this.track("diagnostic",path);
      }
      
      public function trackAction(path:String) : void
      {
         this.track("action",path);
      }
      
      public function trackTest(test:String = "", status:String = "") : void
      {
         this.track("test",test + "/" + status);
      }
      
      public function trackPurchase(transaction:ProductTransaction, productBase:CatalogProductBase, product:CatalogProduct) : void
      {
         var dollarAmount:Number = NaN;
         var currencyString:String = null;
         var shop:String = null;
         var productName:String = null;
         var categoryName:String = null;
         this.initialize();
         if(!this._settings.debug)
         {
            if(this._settings.googleEnabled)
            {
               try
               {
                  currencyString = product.currencyType;
                  if(this._settings.currencyTitles[product.currencyType])
                  {
                     currencyString = this._settings.currencyTitles[product.currencyType];
                  }
                  dollarAmount = product.price / this._settings.exchangeRates[product.currencyType];
                  if(this._settings.exchangeRates[product.currencyType])
                  {
                     dollarAmount = product.price / this._settings.exchangeRates[product.currencyType];
                  }
                  productName = productBase.name;
                  if(product.purchaseType == ProductPurchaseType.EXPIRABLE)
                  {
                     productName = productName + (" / " + product.packQuantity + " days");
                  }
                  productName = productName + (" / " + productBase.collectionID + " / " + productBase.categoryKey);
                  productName = productName + (" / " + currencyString);
                  categoryName = productBase.collectionKey + " / " + productBase.categoryKey;
                  if(product.purchaseType == ProductPurchaseType.EXPIRABLE)
                  {
                     categoryName = categoryName + (" / " + product.packQuantity + " days");
                  }
                  this._googleTracker.addTrans(transaction.id.toString(),currencyString,dollarAmount,0,0,"","","");
                  this._googleTracker.addItem(transaction.id.toString(),product.id.toString(),productName,categoryName,dollarAmount,1);
                  this._googleTracker.trackTrans();
               }
               catch(e:Error)
               {
                  _logger.log("Error tracking purchase",e.toString(),e.message);
               }
            }
         }
      }
      
      public function track(type:String, path:String) : void
      {
         var qtitle:String = null;
         this.initialize();
         if(!this._settings.debug)
         {
            if(this._settings.googleEnabled)
            {
               try
               {
                  if(type == "page")
                  {
                     this._googleTracker.trackPageview("/" + type + this.formatPath(path));
                     this._logger.log("/" + type + this.formatPath(path));
                  }
                  else
                  {
                     this._googleTracker.trackEvent(type,"/" + type + this.formatPath(path));
                     this._logger.log("/" + type + this.formatPath(path));
                  }
               }
               catch(e:Error)
               {
                  _logger.error("error tracking");
               }
            }
            if(this._settings.iilwyEnabled)
            {
               this.iilwyAnalyticsCall(type,path);
            }
            if(this._settings.quantcastEnabled)
            {
               if(type == "page")
               {
                  try
                  {
                     qtitle = path;
                     if(this._quantcastTracker)
                     {
                        this._quantcastTracker.played({
                           "videoId":path,
                           "title":path
                        });
                     }
                  }
                  catch(e:Error)
                  {
                     _logger.error("error tracking");
                  }
               }
            }
         }
         else
         {
            this._logger.log("/" + type + this.formatPath(path));
         }
      }
      
      private function iilwyAnalyticsCall(type:String, path:String) : void
      {
         this.initialize();
         var obj:* = this.settings.getInternalTrackingObject(type,path);
         var del:UtilityDelegate = new UtilityDelegate();
      }
      
      private function formatPath(path:String) : String
      {
         var p:String = path;
         if(p.charAt(0) != "/")
         {
            p = "/" + p;
         }
         if(p.charAt(p.length - 1) == "/")
         {
            p = p.substr(0,p.length - 1);
         }
         return p;
      }
      
      public function startTimedDiagnostic(id:String, reportingFidelity:int = 100) : void
      {
         this._timedDiagnostics[id] = {
            "time":getTimer(),
            "reportingFidelity":reportingFidelity
         };
         this._logger.log("Start timed diagnostic",id);
      }
      
      public function finishTimedDiagnostic(id:String) : void
      {
         var entry:* = this._timedDiagnostics[id];
         if(!entry)
         {
            return;
         }
         var elapsed:Number = getTimer() - entry.time;
         this._logger.log("Finish timed diagnostic: " + id + " : " + elapsed);
         var modTime:Number = elapsed - elapsed % entry.reportingFidelity;
         this.trackDiagnostic("timed/" + id + "/" + modTime);
         delete this._timedDiagnostics[id];
      }
      
      public function updateUserVar() : void
      {
         if(this._settings.googleUserVar)
         {
            try
            {
               this._googleTracker.setVar(this._settings.googleUserVar);
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}
