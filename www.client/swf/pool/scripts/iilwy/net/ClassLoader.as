package iilwy.net
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   import iilwy.application.AppProperties;
   import iilwy.events.AIRApplicationEvent;
   import iilwy.events.AsyncEvent;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   
   public class ClassLoader extends EventDispatcher
   {
      
      public static var CLASS_LOADED:String = "classLoaded";
      
      public static var LOAD_ERROR:String = "loadError";
      
      public static var SECURITY_ERROR:String = "securityError";
      
      public static var LOAD_PROGRESS:String = "load_progress";
       
      
      public var loader:Loader;
      
      private var urlLoader:URLLoader;
      
      private var data:ByteArray;
      
      private var swfLib:String;
      
      private var request:URLRequest;
      
      private var context:LoaderContext;
      
      private var loadedClass:Class;
      
      public var percentLoaded:Number = 0;
      
      public function ClassLoader()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      public function load(lib:String, domain:ApplicationDomain = null) : void
      {
         if(AppProperties.appVersion == AppProperties.VERSION_AIR)
         {
            this.loadForAIR(lib);
            return;
         }
         this.swfLib = lib;
         this.request = new URLRequest(this.swfLib);
         this.context = new LoaderContext();
         this.context.applicationDomain = domain || ApplicationDomain.currentDomain;
         var originalSecurityDomain:SecurityDomain = this.context.securityDomain;
         if(lib.indexOf("http://") > -1)
         {
            this.context.securityDomain = SecurityDomain.currentDomain;
         }
         this.context.checkPolicyFile = true;
         try
         {
            this.loader.load(this.request,this.context);
         }
         catch(error:SecurityError)
         {
            dispatchEvent(new Event(ClassLoader.SECURITY_ERROR));
         }
         catch(error:Error)
         {
         }
      }
      
      public function getClass(className:String) : Class
      {
         try
         {
            return this.loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
         }
         catch(error:Error)
         {
            trace(className + " definition not found in " + swfLib);
         }
         return null;
      }
      
      private function loadForAIR(lib:String) : void
      {
         this.swfLib = lib;
         this.request = new URLRequest(this.swfLib);
         var contextResponder:Responder = new Responder();
         contextResponder.setAsyncListeners(this.onLoaderContextSet);
         var airEvent:AIRApplicationEvent = new AIRApplicationEvent(AIRApplicationEvent.GET_LOADER_CONTEXT,true);
         airEvent.responder = contextResponder;
         StageReference.stage.dispatchEvent(airEvent);
      }
      
      private function onLoadProgress(event:ProgressEvent) : void
      {
         if(this.loader && this.loader.contentLoaderInfo)
         {
            if(this.loader.contentLoaderInfo.bytesTotal == 0)
            {
               this.percentLoaded = 0;
               return;
            }
            this.percentLoaded = this.loader.contentLoaderInfo.bytesLoaded / this.loader.contentLoaderInfo.bytesTotal;
            this.percentLoaded = Math.max(this.percentLoaded,0);
            this.percentLoaded = Math.min(this.percentLoaded,1);
         }
         dispatchEvent(new Event(ClassLoader.LOAD_PROGRESS));
      }
      
      private function onComplete(event:Event) : void
      {
         dispatchEvent(new Event(ClassLoader.CLASS_LOADED));
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         dispatchEvent(new Event(ClassLoader.LOAD_ERROR));
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         dispatchEvent(new Event(ClassLoader.SECURITY_ERROR));
      }
      
      private function onLoaderContextSet(event:AsyncEvent) : void
      {
         this.context = event.data;
         this.urlLoader.load(this.request);
      }
      
      private function onLoadComplete(event:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.data = ByteArray(this.urlLoader.data);
         var writeBytesResponder:Responder = new Responder();
         writeBytesResponder.setAsyncListeners(this.onWriteBytes);
         var airEvent:AIRApplicationEvent = new AIRApplicationEvent(AIRApplicationEvent.WRITEBYTES_APPLICATION_STORAGE_DIRECTORY_FILE,true);
         airEvent.responder = writeBytesResponder;
         airEvent.filePath = "game.swf";
         airEvent.fileData = this.data;
         StageReference.stage.dispatchEvent(airEvent);
      }
      
      private function onWriteBytes(event:AsyncEvent) : void
      {
         this.loader.loadBytes(this.data,this.context);
      }
   }
}
