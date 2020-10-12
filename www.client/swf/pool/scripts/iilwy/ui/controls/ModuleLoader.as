package iilwy.ui.controls
{
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import iilwy.net.MerbProxyProperties;
   
   public class ModuleLoader extends EventDispatcher
   {
       
      
      private var loader:Loader;
      
      private var urlLoader:URLLoader;
      
      private var loaderContext:LoaderContext;
      
      public var moduleID:String;
      
      public var cacheBust:Boolean = true;
      
      public function ModuleLoader(target:IEventDispatcher = null)
      {
         super(target);
         this.loaderContext = new LoaderContext();
         this.loaderContext.applicationDomain = ApplicationDomain.currentDomain;
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onURLLoadComplete);
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
      }
      
      public function load(url:String) : void
      {
         if(this.cacheBust)
         {
            url = url + ("?" + "v=" + String(Math.floor(MerbProxyProperties.serverNowInMS / (1000 * 60))));
         }
         var request:URLRequest = new URLRequest(url);
         this.urlLoader.load(request);
      }
      
      private function onURLLoadComplete(event:Event) : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleLoad);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onModuleLoadError);
         this.loader.loadBytes(this.urlLoader.data,this.loaderContext);
      }
      
      protected function onModuleLoad(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onModuleLoadError(event:IOErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      public function getClass(className:String) : Class
      {
         try
         {
            return this.loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
         }
         catch(error:Error)
         {
            trace(className + " definition not found");
         }
         return null;
      }
   }
}
