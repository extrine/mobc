package iilwy.net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.System;
   import flash.utils.getTimer;
   import iilwy.utils.sha1.SHA1;
   
   public class ApiRequest extends EventDispatcher
   {
      
      public static const LOAD_STATE_LOADING:String = "loading";
      
      public static const LOAD_STATE_NONE:String = "none";
      
      public static const LOAD_STATE_LOADED:String = "loaded";
      
      public static const LOAD_STATE_KILLED:String = "killed";
      
      public static const LOAD_STATE_KILL_PENDING:String = "killpending";
      
      public static var totalRequestsEver:int = 0;
      
      public static var authToken:String;
      
      public static const DATA_LOADED_EVENT:String = "data_loaded_event";
       
      
      public var _url:String = "";
      
      private var _callback:Function;
      
      private var _args;
      
      private var _loader:URLLoader;
      
      private var _request:URLRequest;
      
      private var _variables:URLVariables;
      
      private var _requestTime:Number = 0;
      
      private var _state:String;
      
      public var _loaderOpen:Boolean = false;
      
      private var _requestIsPending:Boolean = false;
      
      public var _killMe:Boolean = false;
      
      private var _startMemory:uint;
      
      private var _json:Object;
      
      public function ApiRequest(url:String, params:*, callback:Function, extra_params:Object = null)
      {
         var p_name:* = undefined;
         var isStr:Boolean = false;
         var paramStr:String = null;
         super();
         var _baseUrl:String = ApiProxy.location;
         this._startMemory = System.totalMemory;
         this._callback = callback;
         if(extra_params != null)
         {
            this._args = extra_params;
         }
         var _key:String = this.getKey("/" + url);
         if(this._args != null)
         {
            if(this._args.post == true)
            {
               this._variables = new URLVariables();
               for(p_name in params)
               {
                  this._variables[p_name] = params[p_name];
               }
               this._variables["api_request_key"] = _key;
               if(authToken)
               {
                  this._variables["auth_token"] = authToken;
               }
            }
         }
         if(this._variables != null)
         {
            this._url = _baseUrl + url;
         }
         else
         {
            paramStr = "?api_request_key=" + _key + "&";
            if(authToken)
            {
               paramStr = paramStr + ("auth_token=" + authToken + "&");
            }
            if(params.toString().indexOf("Object") > 0)
            {
               isStr = false;
            }
            else
            {
               isStr = true;
            }
            if(isStr)
            {
               if(params != "")
               {
                  paramStr = paramStr + params;
               }
            }
            if(_baseUrl == "")
            {
            }
            if(!isStr)
            {
               for(p_name in params)
               {
                  paramStr = paramStr + (p_name + "=" + params[p_name] + "&");
               }
            }
            this._url = _baseUrl + url + paramStr;
         }
      }
      
      private function getKey(url:String) : String
      {
         var salt:String = "You ain\'t got no defenses!";
         var key:String = SHA1.encrypt(url + salt);
         return key;
      }
      
      public function getRequestTime() : Number
      {
         return getTimer() - this._requestTime;
      }
      
      public function set state(st:String) : void
      {
         this._state = st;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function unload() : void
      {
      }
      
      public function killRequest() : void
      {
         if(this._requestIsPending)
         {
            if(this._loaderOpen)
            {
               this._loader.close();
               this._loader = null;
               this._state = LOAD_STATE_KILLED;
               this._requestIsPending = false;
            }
            else
            {
               this._killMe = true;
               this._state = LOAD_STATE_KILLED;
            }
         }
         else
         {
            this._killMe = true;
            this._state = LOAD_STATE_KILL_PENDING;
         }
      }
      
      public function request() : void
      {
         if(this._request != null)
         {
            return;
         }
         this._request = new URLRequest(this._url);
         if(this._variables != null)
         {
            this._request.method = URLRequestMethod.POST;
            this._request.data = this._variables;
         }
         this._loader = new URLLoader();
         this._loader.dataFormat = URLLoaderDataFormat.TEXT;
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,false,0,true);
         this._loader.addEventListener(Event.COMPLETE,this.dataLoaded,false,0,true);
         this._loader.addEventListener(Event.OPEN,this.loaderOpen,false,0,true);
         if(!this._killMe)
         {
            ApiRequest.totalRequestsEver++;
            this._loader.load(this._request);
            this._state = ApiRequest.LOAD_STATE_LOADING;
         }
      }
      
      private function loaderOpen(evt:Event) : void
      {
         this._loaderOpen = true;
         this._requestIsPending = true;
         if(this._killMe)
         {
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this._loader.removeEventListener(Event.COMPLETE,this.dataLoaded);
            this._loader.removeEventListener(Event.OPEN,this.loaderOpen);
            this._loader.close();
            this._loader = null;
            this._state = LOAD_STATE_KILLED;
            this._requestIsPending = false;
         }
      }
      
      private function dataLoaded(e:Event) : void
      {
         this._state = LOAD_STATE_LOADED;
         this._requestIsPending = false;
         var str:String = e.target.data;
         if(str.length > 1 && str.substr(0,2).indexOf("{") != -1)
         {
            this._json = JSON.decode(e.target.data);
         }
         else
         {
            this._json = {"bad_json":true};
         }
         if(this._json == null)
         {
            this._json = new Object();
         }
         try
         {
            this._json.args = this._args;
         }
         catch(e:Error)
         {
         }
         this._callback(this._json);
         this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._loader.removeEventListener(Event.COMPLETE,this.dataLoaded);
         this._loader.removeEventListener(Event.OPEN,this.loaderOpen);
         dispatchEvent(new Event(DATA_LOADED_EVENT));
         this._callback = null;
         this._json = null;
         this._loader.data = null;
         this._loader = null;
      }
      
      private function securityErrorHandler(evt:SecurityErrorEvent) : void
      {
      }
      
      private function ioErrorHandler(evt:IOErrorEvent) : void
      {
      }
      
      private function httpStatusHandler(evt:HTTPStatusEvent) : void
      {
      }
      
      private function progressHandler(evt:ProgressEvent) : void
      {
      }
   }
}
