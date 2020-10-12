package iilwy.application
{
   import flash.external.ExternalInterface;
   
   public final class AppProperties
   {
      
      public static var serverLocation:String = SERVER_LIVE;
      
      public static var serverLocationUseJS:Boolean = false;
      
      public static var serverLocationJS:String = "";
      
      public static var rootParameters:Object;
      
      public static var parentParameters:Object;
      
      public static var compileParameters:Object;
      
      public static var merbLocation:String = MERB_SERVER_LIVE;
      
      public static var merbSecureLocation:String = MERB_SERVER_LIVE_SECURE;
      
      public static var environment:String = AppProperties.ENV_PRODUCTION;
      
      public static var debugMode:String = AppProperties.MODE_NOT_DEBUGGING;
      
      public static var mediaServer:String = MEDIA_SERVER_LIVE;
      
      public static var fileServerItems:String = "http://itemscdn.iminlikewithyou.com/";
      
      public static var fileServerMedia:String = "http://mediacdn.iminlikewithyou.com/";
      
      public static var fileServerFlashDev:String = "http://flash.dev.iminlikewithyou.com/";
      
      public static var fileServerGames:String = "http://gamenetgamescdn.iminlikewithyou.com/";
      
      public static var fileServerGamesDev:String = "http://gamenetgames.dev.iminlikewithyou.com/";
      
      public static var fileServerCachedCalls:String = "http://cccdn.omgpop.com/a/";
      
      public static var buildVersion:String;
      
      public static var appVersion:String = VERSION_WEBSITE;
      
      public static var sessionType:String = SESSION_EMAIL_AIM;
      
      public static var origin:String = "omgpop";
      
      public static var docLocation:String;
      
      public static var referrer:String;
      
      public static var embeddedGameID:String;
      
      public static var embeddedShopID:int;
      
      public static var authToken:String;
      
      public static var localStaticDir:String = "../../../buckets/static/";
      
      public static var localFlashDir:String = "../../../buckets/flash/";
      
      public static var localGamesDir:String = "../../games/";
      
      public static var arcadeTesterConfigOverride:String;
      
      public static var arcadeTesterLibraryOverride:String;
      
      public static var swfObjectID:String = ExternalInterface.objectID;
      
      public static var itemPrefix:String = "";
      
      public static const ENV_PRODUCTION:String = "production";
      
      public static const ENV_DEVELOPMENT:String = "development";
      
      public static const EXTERNAL_BLOG:String = "http://blog.omgpop.com/";
      
      public static const EXTERNAL_FORUMS:String = "http://forums.omgpop.com/";
      
      public static const EXTERNAL_SHOP:String = "https://shop.omgpop.com/";
      
      public static const MODE_LOCAL_DEBUGGING:String = "mode_LocalDebugging";
      
      public static const MODE_REMOTE_DEBUGGING:String = "mode_Remote_Debugging";
      
      public static const MODE_NOT_DEBUGGING:String = "mode_NotDebugging";
      
      public static const MEDIA_SERVER_DEV:String = "http://192.168.1.186:10000/";
      
      public static const MEDIA_SERVER_LIVE:String = "http://mediafarm.omgpop.com/";
      
      public static const MERB_SERVER_DEV:String = "http://192.168.1.186:4000/";
      
      public static const MERB_SERVER_TEST:String = "http://testapi.iminlikewithyou.com/";
      
      public static const MERB_SERVER_LIVE:String = "http://api.omgpop.com/";
      
      public static const MERB_SERVER_LIVE_SECURE:String = "https://api.omgpop.com/";
      
      public static const MERB_SERVER_LOCAL:String = "http://localhost:4000/";
      
      public static const SERVER_CHARLES:String = "http://setpixelmbp.local:4000/";
      
      public static const SERVER_DEV:String = "http://192.168.1.186:5000/";
      
      public static const SERVER_LIVE:String = "http://iminlikewithyou.com/";
      
      public static const SERVER_LOCAL:String = "http://localhost:4000/";
      
      public static const SESSION_EMAIL_AIM:String = "emailAIM";
      
      public static const SESSION_FACEBOOK:String = "facebook";
      
      public static const SESSION_MYSPACE:String = "myspace";
      
      public static const SESSION_PARTNER:String = "partner";
      
      public static const VERSION_WEBSITE:String = "website";
      
      public static const VERSION_AIR:String = "air";
      
      public static const VERSION_EXTERNAL_ARCADE:String = "externalArcade";
      
      public static const VERSION_FACEBOOK_ARCADE:String = "facebookArcade";
      
      public static const VERSION_MYSPACE_ARCADE:String = "myspaceArcade";
      
      public static const VERSION_ARCADE_TESTER:String = "arcadeTester";
       
      
      public function AppProperties()
      {
         super();
      }
      
      public static function get itemBucketURL() : String
      {
         trace("AppProperties: itemBucketURL is deprecated");
         return null;
      }
      
      public static function get selfPlayerPhoto() : String
      {
         return AppProperties.fileServerStatic + "default_thumbnails/you_largethumb.jpg";
      }
      
      public static function get fileServerStaticOrLocal() : String
      {
         if(AppProperties.debugMode == MODE_LOCAL_DEBUGGING)
         {
            return localStaticDir;
         }
         return fileServerStatic;
      }
      
      public static function get fileServerStatic() : String
      {
         if(AppProperties.debugMode == MODE_LOCAL_DEBUGGING || AppProperties.debugMode == MODE_REMOTE_DEBUGGING)
         {
            return "http://static.iminlikewithyou.com/";
         }
         return "http://staticcdn.iminlikewithyou.com/";
      }
      
      public static function get fileServerFlashOrLocal() : String
      {
         if(AppProperties.debugMode == MODE_LOCAL_DEBUGGING)
         {
            return localFlashDir;
         }
         return fileServerFlash;
      }
      
      public static function get fileServerFlash() : String
      {
         if(AppProperties.debugMode == MODE_LOCAL_DEBUGGING || AppProperties.debugMode == MODE_REMOTE_DEBUGGING)
         {
            return "http://flash.iminlikewithyou.com/";
         }
         return "http://flashcdn.iminlikewithyou.com/";
      }
      
      public static function get appVersionIsWebsiteOrAIR() : Boolean
      {
         return appVersion == VERSION_WEBSITE || appVersion == VERSION_AIR;
      }
      
      public static function get notAvailablePhoto() : String
      {
         return fileServerStaticOrLocal + "gfx/system_photo/male/base_largethumb.jpg";
      }
      
      public static function get jsEnabled() : Boolean
      {
         var js:String = "function() { return typeof( window ); }";
         var windowType:String = "undefined";
         try
         {
            windowType = ExternalInterface.call(js);
         }
         catch(error:Error)
         {
         }
         return windowType != "undefined";
      }
      
      public static function get fbDefined() : Boolean
      {
         if(appVersion == VERSION_AIR)
         {
            return true;
         }
         var js:String = "function() { return typeof( FB ); }";
         var fbType:String = "undefined";
         try
         {
            fbType = ExternalInterface.call(js);
         }
         catch(error:Error)
         {
         }
         return fbType != "undefined";
      }
   }
}
