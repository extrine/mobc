package com.google.analytics.core
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Protocols;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.v4.Configuration;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class GIFRequest
   {
       
      
      private var _config:Configuration;
      
      private var _debug:DebugConfiguration;
      
      private var _buffer:Buffer;
      
      private var _info:Environment;
      
      private var _utmac:String;
      
      private var _lastRequest:URLRequest;
      
      private var _count:int;
      
      private var _alertcount:int;
      
      private var _requests:Array;
      
      public function GIFRequest(config:Configuration, debug:DebugConfiguration, buffer:Buffer, info:Environment)
      {
         super();
         this._config = config;
         this._debug = debug;
         this._buffer = buffer;
         this._info = info;
         this._count = 0;
         this._alertcount = 0;
         this._requests = [];
      }
      
      public function get utmac() : String
      {
         return this._utmac;
      }
      
      public function get utmwv() : String
      {
         return this._config.version;
      }
      
      public function get utmn() : String
      {
         return Utils.generate32bitRandom() as String;
      }
      
      public function get utmhn() : String
      {
         return this._info.domainName;
      }
      
      public function get utmsp() : String
      {
         return this._config.sampleRate * 100 as String;
      }
      
      public function get utmcc() : String
      {
         var cookies:Array = [];
         if(this._buffer.hasUTMA())
         {
            cookies.push(this._buffer.utma.toURLString() + ";");
         }
         if(this._buffer.hasUTMZ())
         {
            cookies.push(this._buffer.utmz.toURLString() + ";");
         }
         if(this._buffer.hasUTMV())
         {
            cookies.push(this._buffer.utmv.toURLString() + ";");
         }
         return cookies.join("+");
      }
      
      public function updateToken() : void
      {
         var tokenDelta:Number = NaN;
         var timestamp:Number = new Date().getTime();
         tokenDelta = (timestamp - this._buffer.utmb.lastTime) * (this._config.tokenRate / 1000);
         if(this._debug.verbose)
         {
            this._debug.info("tokenDelta: " + tokenDelta,VisualDebugMode.geek);
         }
         if(tokenDelta >= 1)
         {
            this._buffer.utmb.token = Math.min(Math.floor(this._buffer.utmb.token + tokenDelta),this._config.bucketCapacity);
            this._buffer.utmb.lastTime = timestamp;
            if(this._debug.verbose)
            {
               this._debug.info(this._buffer.utmb.toString(),VisualDebugMode.geek);
            }
         }
      }
      
      private function _debugSend(request:URLRequest) : void
      {
         var url:String = null;
         var data:String = "";
         switch(this._debug.mode)
         {
            case VisualDebugMode.geek:
               data = "Gif Request #" + this._alertcount + ":\n" + request.url;
               break;
            case VisualDebugMode.advanced:
               url = request.url;
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = this._shortenURL(url);
               data = "Send Gif Request #" + this._alertcount + ":\n" + url + " ?";
               break;
            case VisualDebugMode.basic:
            default:
               data = "Send " + this._config.serverMode.toString() + " Gif Request #" + this._alertcount + " ?";
         }
         this._debug.alertGifRequest(data,request,this);
         this._alertcount++;
      }
      
      private function _shortenURL(url:String) : String
      {
         var paths:Array = null;
         if(url.length > 60)
         {
            paths = url.split("/");
            while(url.length > 60)
            {
               paths.shift();
               url = "../" + paths.join("/");
            }
         }
         return url;
      }
      
      public function onSecurityError(event:SecurityErrorEvent) : void
      {
         if(this._debug.GIFRequests)
         {
            this._debug.failure(event.text);
         }
      }
      
      public function onIOError(event:IOErrorEvent) : void
      {
         var url:String = this._lastRequest.url;
         var id:String = String(this._requests.length - 1);
         var msg:String = "Gif Request #" + id + " failed";
         if(this._debug.GIFRequests)
         {
            if(!this._debug.verbose)
            {
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = this._shortenURL(url);
            }
            if(int(this._debug.mode) > int(VisualDebugMode.basic))
            {
               msg = msg + (" \"" + url + "\" does not exists or is unreachable");
            }
            this._debug.failure(msg);
         }
         else
         {
            this._debug.warning(msg);
         }
         this._removeListeners(event.target);
      }
      
      public function onComplete(event:Event) : void
      {
         var id:String = event.target.loader.name;
         this._requests[id].complete();
         var msg:String = "Gif Request #" + id + " sent";
         var url:String = this._requests[id].request.url;
         if(this._debug.GIFRequests)
         {
            if(!this._debug.verbose)
            {
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = this._shortenURL(url);
            }
            if(int(this._debug.mode) > int(VisualDebugMode.basic))
            {
               msg = msg + (" to \"" + url + "\"");
            }
            this._debug.success(msg);
         }
         else
         {
            this._debug.info(msg);
         }
         this._removeListeners(event.target);
      }
      
      private function _removeListeners(target:Object) : void
      {
         target.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         target.removeEventListener(Event.COMPLETE,this.onComplete);
      }
      
      public function sendRequest(request:URLRequest) : void
      {
         var loader:Loader = new Loader();
         loader.name = String(this._count++);
         var context:LoaderContext = new LoaderContext(false);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this._lastRequest = request;
         this._requests[loader.name] = new RequestObject(request);
         try
         {
            loader.load(request,context);
         }
         catch(e:Error)
         {
            _debug.failure("\"Loader.load()\" could not instanciate Gif Request");
         }
      }
      
      public function send(account:String, variables:Variables = null, force:Boolean = false, rateLimit:Boolean = false) : void
      {
         var localPath:String = null;
         var localImage:URLRequest = null;
         var remoteImage:URLRequest = null;
         this._utmac = account;
         if(!variables)
         {
            variables = new Variables();
         }
         variables.URIencode = false;
         variables.pre = ["utmwv","utmn","utmhn","utmt","utme","utmcs","utmsr","utmsc","utmul","utmje","utmfl","utmdt","utmhid","utmr","utmp"];
         variables.post = ["utmcc"];
         if(this._debug.verbose)
         {
            this._debug.info("tracking: " + this._buffer.utmb.trackCount + "/" + this._config.trackingLimitPerSession,VisualDebugMode.geek);
         }
         if(this._buffer.utmb.trackCount < this._config.trackingLimitPerSession || force)
         {
            if(rateLimit)
            {
               this.updateToken();
            }
            if(force || !rateLimit || this._buffer.utmb.token >= 1)
            {
               if(!force && rateLimit)
               {
                  this._buffer.utmb.token = this._buffer.utmb.token - 1;
               }
               this._buffer.utmb.trackCount = this._buffer.utmb.trackCount + 1;
               if(this._debug.verbose)
               {
                  this._debug.info(this._buffer.utmb.toString(),VisualDebugMode.geek);
               }
               variables.utmwv = this.utmwv;
               variables.utmn = Utils.generate32bitRandom();
               if(this._info.domainName != "")
               {
                  variables.utmhn = this._info.domainName;
               }
               if(this._config.sampleRate < 1)
               {
                  variables.utmsp = this._config.sampleRate * 100;
               }
               if(this._config.serverMode == ServerOperationMode.local || this._config.serverMode == ServerOperationMode.both)
               {
                  localPath = this._info.locationSWFPath;
                  if(localPath.lastIndexOf("/") > 0)
                  {
                     localPath = localPath.substring(0,localPath.lastIndexOf("/"));
                  }
                  localImage = new URLRequest();
                  if(this._config.localGIFpath.indexOf("http") == 0)
                  {
                     localImage.url = this._config.localGIFpath;
                  }
                  else
                  {
                     localImage.url = localPath + this._config.localGIFpath;
                  }
                  localImage.url = localImage.url + ("?" + variables.toString());
                  if(this._debug.active && this._debug.GIFRequests)
                  {
                     this._debugSend(localImage);
                  }
                  else
                  {
                     this.sendRequest(localImage);
                  }
               }
               if(this._config.serverMode == ServerOperationMode.remote || this._config.serverMode == ServerOperationMode.both)
               {
                  remoteImage = new URLRequest();
                  if(this._info.protocol == Protocols.HTTPS)
                  {
                     remoteImage.url = this._config.secureRemoteGIFpath;
                  }
                  else if(this._info.protocol == Protocols.HTTP)
                  {
                     remoteImage.url = this._config.remoteGIFpath;
                  }
                  else
                  {
                     remoteImage.url = this._config.remoteGIFpath;
                  }
                  variables.utmac = this.utmac;
                  variables.utmcc = encodeURIComponent(this.utmcc);
                  remoteImage.url = remoteImage.url + ("?" + variables.toString());
                  if(this._debug.active && this._debug.GIFRequests)
                  {
                     this._debugSend(remoteImage);
                  }
                  else
                  {
                     this.sendRequest(remoteImage);
                  }
               }
            }
         }
      }
   }
}
