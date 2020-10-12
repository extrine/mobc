package iilwy.net
{
   import flash.display.AVM1Movie;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.getTimer;
   
   public class MediaRequest extends EventDispatcher
   {
      
      public static const LOAD_STATE_LOADING:String = "loading";
      
      public static const LOAD_STATE_NONE:String = "none";
      
      public static const LOAD_STATE_LOADED:String = "loaded";
      
      public static const LOAD_STATE_KILLED:String = "killed";
      
      public static const DATA_LOADED_EVENT:String = "data_loaded_event";
      
      public static const REQUEST_KILLED_EVENT:String = "request_killed_event";
      
      public static var totalRequestsEver:int = 0;
       
      
      private var _url:String = "";
      
      private var _callback:Function;
      
      private var _args;
      
      private var _loader:URLLoader;
      
      private var _requestTime:Number = 0;
      
      private var _state:String;
      
      private var _this;
      
      private var _pictLdr:Loader;
      
      private var _requestIsPending:Boolean = false;
      
      private var _killMe:Boolean = false;
      
      public var info:String = "Nothing has happened";
      
      public function MediaRequest(url:String, callback:Function, ... args)
      {
         super();
         this._url = url;
         this._callback = callback;
         this._args = args;
         this._this = this;
         this.info = "Constructed";
      }
      
      public function getRequestTime() : Number
      {
         return getTimer() - this._requestTime;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set state(st:String) : void
      {
         this._state = st;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function killRequest() : void
      {
         this.info = "Kill request has been called";
         if(this._requestIsPending == true)
         {
            try
            {
               this._pictLdr.close();
            }
            catch(err:Error)
            {
               _killMe = true;
            }
            MediaProxy.totalRequests--;
            this.removeListeners();
            this._pictLdr = null;
            this._state = LOAD_STATE_KILLED;
            this._requestIsPending = false;
            this._this.dispatchEvent(new Event(REQUEST_KILLED_EVENT));
         }
         else
         {
            this._killMe = true;
         }
      }
      
      private function removeListeners() : void
      {
         this._pictLdr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.imgLoaded);
      }
      
      private function securityErrorHandler(evt:SecurityErrorEvent) : void
      {
         trace("security Error");
      }
      
      private function ioErrorHandler(evt:IOErrorEvent) : void
      {
         trace("IO Error: " + evt.text + " " + evt.type);
         this.removeListeners();
         this._state = LOAD_STATE_KILLED;
         this._requestIsPending = false;
      }
      
      private function httpStatusHandler(evt:HTTPStatusEvent) : void
      {
      }
      
      private function progressHandler(evt:ProgressEvent) : void
      {
      }
      
      private function loaderOpen(evt:Event) : void
      {
         this.info = "Loader open";
         this._requestIsPending = true;
         if(this._killMe)
         {
            try
            {
               this._pictLdr.close();
            }
            catch(err:Error)
            {
            }
            this.removeListeners();
            this._pictLdr = null;
            MediaProxy.totalRequests--;
            this._state = LOAD_STATE_KILLED;
            this._requestIsPending = false;
            this._this.dispatchEvent(new Event(REQUEST_KILLED_EVENT));
         }
      }
      
      private function imgLoaded(e:Event) : void
      {
         var b:Bitmap = null;
         var c:AVM1Movie = null;
         this.info = "Image loaded";
         if(this._killMe == true)
         {
            return;
         }
         this._state = LOAD_STATE_LOADED;
         this._requestIsPending = false;
         MediaProxy.totalRequests--;
         var obj:Object = new Object();
         try
         {
            if(this._pictLdr.content is Bitmap)
            {
               b = Bitmap(this._pictLdr.content);
               obj.photo = b;
            }
            if(this._pictLdr.content is AVM1Movie)
            {
               c = AVM1Movie(this._pictLdr.content);
               obj.photo = c;
            }
         }
         catch(e:Error)
         {
         }
         obj.url = this._url;
         obj.args = this._args;
         this._callback(obj);
         obj.photo = null;
         this._pictLdr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.imgLoaded);
         this._this.dispatchEvent(new Event(DATA_LOADED_EVENT));
         delete obj.photo;
         delete obj.url;
         delete obj.args;
         this._pictLdr.unload();
         this._pictLdr = null;
         b = null;
         obj = null;
      }
      
      public function request() : void
      {
         this.info = "request made";
         this._state = LOAD_STATE_LOADING;
         this._pictLdr = new Loader();
         var moded:String = this._url;
         if(this._url && this._url.charAt(0) == "/")
         {
            moded = ApiProxy.location + this._url;
         }
         var pictURLReq:URLRequest = new URLRequest(moded);
         var context:LoaderContext = new LoaderContext();
         this._pictLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.ioErrorHandler);
         this._pictLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imgLoaded);
         this._pictLdr.contentLoaderInfo.addEventListener(Event.OPEN,this.loaderOpen);
         try
         {
            context.checkPolicyFile = true;
            if(!this._killMe)
            {
               MediaRequest.totalRequestsEver++;
               this._pictLdr.load(pictURLReq,context);
               MediaProxy.totalRequests++;
            }
         }
         catch(err:Error)
         {
            info = "caught an error";
            trace("Loader Error:" + err);
         }
      }
   }
}
