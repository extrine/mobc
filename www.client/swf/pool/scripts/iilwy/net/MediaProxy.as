package iilwy.net
{
   import flash.utils.Timer;
   import iilwy.utils.TextUtil;
   
   public final class MediaProxy
   {
      
      private static var _instance:MediaProxy = new MediaProxy();
      
      public static var totalRequests:int = 0;
      
      public static const SIZE_ORIGINAL:Number = 0;
      
      public static const SIZE_TINY_THUMB:Number = 1;
      
      public static const SIZE_SMALL_THUMB:Number = 2;
      
      public static const SIZE_MEDIUM_THUMB:Number = 3;
      
      public static const SIZE_LARGE_THUMB:Number = 4;
      
      public static const SIZE_SMALL:Number = 5;
      
      public static const SIZE_MEDIUM:Number = 6;
      
      public static const SIZE_LARGE:Number = 7;
      
      public static const DRAWING_SIZE_TINY_THUMB:Number = 1;
      
      public static const DRAWING_SIZE_SMALL_THUMB:Number = 2;
      
      public static const DRAWING_SIZE_MEDIUM_THUMB:Number = 3;
      
      public static const DRAWING_SIZE_LARGE:Number = 0;
       
      
      private var _baseUrl:String = "";
      
      private var _requestArray:Array;
      
      private var _pendingRequests:int = 0;
      
      private var _numConcurrentRequests:int = 18;
      
      private var _connectedToInternet:Boolean = false;
      
      private var _requestTimer:Timer;
      
      public function MediaProxy()
      {
         this._requestArray = new Array();
         super();
      }
      
      public static function init() : MediaProxy
      {
         if(_instance == null)
         {
         }
         return _instance;
      }
      
      public static function url(url:String, size:int, forceExtension:Boolean = false) : String
      {
         if(url == null)
         {
            return null;
         }
         var internalSearch:Array = url.match(TextUtil.internalURLPattern);
         if(internalSearch.length == 0)
         {
            return url;
         }
         var sizes:Array = ["","_tinythumb","_smallthumb","_mediumthumb","_largethumb","_smallver","_mediumver","_largever"];
         var extSearch:RegExp = /\.\w{3,4}$/;
         var extension:String = ".jpg";
         try
         {
            extension = !!forceExtension?extSearch.exec(url)[0]:".jpg";
         }
         catch(e:Error)
         {
         }
         var stripExt:String = url.replace(extSearch,"");
         var toStrip:String = sizes.slice(1,sizes.length - 1).join("|");
         var reg:RegExp = new RegExp("(" + toStrip + ")$","g");
         var strp:String = stripExt.replace(reg,"");
         return strp + sizes[size] + extension;
      }
      
      public static function drawing_url(url:String, size:int) : String
      {
         if(!url)
         {
            return null;
         }
         var sizes:Array = ["","_80","_160","_320"];
         var stripped:String = url.replace(/(\/[^\/_]*?)([\_\.][\w\.]*?$)/,"$1");
         return stripped + sizes[size] + ".jpg";
      }
      
      public static function request(url:String, callback:Function, priority:int, ... args) : MediaRequest
      {
         return _instance.singleRequest(url,callback,priority,args);
      }
      
      public static function set location(url:String) : void
      {
         _instance._baseUrl = url;
      }
      
      public static function get location() : String
      {
         return _instance._baseUrl;
      }
      
      public static function get instance() : MediaProxy
      {
         init();
         return _instance;
      }
      
      private static function sortOnPriority(itemA:Object, itemB:Object) : int
      {
         var aPr:Number = itemA.priority;
         var bPr:Number = itemB.priority;
         if(aPr > bPr)
         {
            return 1;
         }
         if(aPr < bPr)
         {
            return -1;
         }
         return 0;
      }
      
      public static function killRequest(url:String) : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < _instance._requestArray.length; i++)
         {
            obj = _instance._requestArray[i];
            if(obj.requestObject.url == url)
            {
               if(obj.requestObject.state == MediaRequest.LOAD_STATE_LOADING)
               {
                  obj.requestObject.killRequest();
                  obj.requestObject = null;
                  _instance._requestArray.splice(i,1);
                  _instance._pendingRequests--;
                  i--;
               }
               else if(obj.requestObject.state == MediaRequest.LOAD_STATE_NONE)
               {
                  obj.requestObject = null;
                  _instance._requestArray.splice(i,1);
                  i--;
               }
            }
         }
      }
      
      public static function killRequestByLabels(label:String) : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < _instance._requestArray.length; i++)
         {
            obj = _instance._requestArray[i];
            if(obj.requestObject.label == label)
            {
               if(obj.requestObject.state == MediaRequest.LOAD_STATE_LOADING)
               {
                  obj.requestObject.killRequest();
                  obj.requestObject = null;
                  _instance._requestArray.splice(i,1);
                  _instance._pendingRequests--;
                  i--;
               }
               else if(obj.requestObject.state == MediaRequest.LOAD_STATE_NONE)
               {
                  obj.requestObject = null;
                  _instance._requestArray.splice(i,1);
                  i--;
               }
            }
         }
      }
      
      public static function killAllRequestss() : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < _instance._requestArray.length; i++)
         {
            obj = _instance._requestArray[i];
            if(obj.requestObject.state == MediaRequest.LOAD_STATE_LOADING)
            {
               obj.requestObject.killRequest();
               obj.requestObject = null;
               _instance._requestArray.splice(i,1);
               _instance._pendingRequests--;
               i--;
            }
            else if(obj.requestObject.state == MediaRequest.LOAD_STATE_NONE)
            {
               obj.requestObject = null;
               _instance._requestArray.splice(i,1);
               i--;
            }
         }
      }
      
      private function singleRequest(url:String, callback:Function, priority:int, ... args) : MediaRequest
      {
         var lab:String = null;
         var mediaRequest:MediaRequest = new MediaRequest(url,callback,args);
         mediaRequest.state = MediaRequest.LOAD_STATE_NONE;
         if(args.label != null)
         {
            lab = args.label;
         }
         else
         {
            lab = "";
         }
         this._requestArray.push({
            "requestObject":mediaRequest,
            "priority":priority,
            "label":lab
         });
         mediaRequest.addEventListener(MediaRequest.DATA_LOADED_EVENT,this.checkForRequestsToLoad,false,0,true);
         if(priority != 1)
         {
            this._requestArray.sort(sortOnPriority);
         }
         this.checkForRequestsToLoad();
         return mediaRequest;
      }
      
      private function checkForRequestsToLoad(... args) : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < this._requestArray.length; i++)
         {
            obj = this._requestArray[i];
            if(obj.requestObject.state == MediaRequest.LOAD_STATE_NONE && this._pendingRequests < this._numConcurrentRequests)
            {
               obj.requestObject.request();
               this._pendingRequests++;
            }
            if(obj.requestObject.state == MediaRequest.LOAD_STATE_LOADED || obj.requestObject.state == MediaRequest.LOAD_STATE_KILLED)
            {
               obj.requestObject = null;
               this._requestArray.splice(i,1);
               this._pendingRequests--;
               i--;
            }
         }
      }
   }
}
