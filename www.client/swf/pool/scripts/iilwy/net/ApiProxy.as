package iilwy.net
{
   import iilwy.utils.sha1.SHA1;
   
   public final class ApiProxy
   {
      
      private static var _instance:ApiProxy = new ApiProxy();
       
      
      private var _baseUrl:String = "";
      
      private var _requestArray:Array;
      
      private var _pendingRequests:int = 0;
      
      private var _numConcurrentRequests:int = 15;
      
      private var _connectedToInternet:Boolean = false;
      
      public function ApiProxy()
      {
         this._requestArray = new Array();
         super();
      }
      
      public static function request(url:String, callback:Function, params:*, priority:int, extra_params:Object = null) : ApiRequest
      {
         return _instance.singleRequest(url,callback,params,priority,extra_params);
      }
      
      public static function set location(url:String) : void
      {
         _instance._baseUrl = url;
      }
      
      public static function get location() : String
      {
         return _instance._baseUrl;
      }
      
      public static function get instance() : ApiProxy
      {
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
               else if(obj.requestObject.state == ApiRequest.LOAD_STATE_NONE)
               {
                  obj.requestObject = null;
                  _instance._requestArray.splice(i,1);
                  i--;
               }
            }
         }
      }
      
      public static function killAllRequests() : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < _instance._requestArray.length; i++)
         {
            obj = _instance._requestArray[i];
            if(obj.requestObject.state == ApiRequest.LOAD_STATE_LOADING)
            {
               obj.requestObject.killRequest();
               obj.requestObject = null;
               _instance._requestArray.splice(i,1);
               _instance._pendingRequests--;
               i--;
            }
            else if(obj.requestObject.state == ApiRequest.LOAD_STATE_NONE)
            {
               obj.requestObject = null;
               _instance._requestArray.splice(i,1);
               i--;
            }
         }
      }
      
      public static function spaceEscape(name:String) : String
      {
         var spacePattern:RegExp = /\s/gi;
         return name.replace(spacePattern,"+");
      }
      
      public static function isSuccessfulResponse(response:*) : Boolean
      {
         var success:Boolean = false;
         if(response.success != null && response.success == 1)
         {
            success = true;
         }
         return success;
      }
      
      public static function addObjectAsRubyPropertyList(storage:Object, obj:Object, name:String) : void
      {
         var prop:* = null;
         for(prop in obj)
         {
            storage[name + "[" + prop + "]"] = obj[prop];
         }
      }
      
      private function getKeyaxxx(url:String) : String
      {
         var salt:String = "You ain\'t got no defenses!";
         var key:String = SHA1.encrypt(url + salt);
         return key;
      }
      
      private function singleRequest(url:String, callback:Function, params:*, priority:int, extra_params:Object = null) : ApiRequest
      {
         var apiRequest:ApiRequest = new ApiRequest(url,params,callback,extra_params);
         apiRequest.state = ApiRequest.LOAD_STATE_NONE;
         this._requestArray.push({
            "requestObject":apiRequest,
            "priority":priority
         });
         apiRequest.addEventListener(ApiRequest.DATA_LOADED_EVENT,this.checkForRequestsToLoad);
         this.checkForRequestsToLoad();
         return apiRequest;
      }
      
      private function checkForRequestsToLoad(... args) : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < this._requestArray.length; i++)
         {
            obj = this._requestArray[i];
            if(obj.requestObject.state == ApiRequest.LOAD_STATE_NONE && this._pendingRequests < this._numConcurrentRequests)
            {
               obj.requestObject.request();
               this._pendingRequests++;
            }
            if(obj.requestObject.state == ApiRequest.LOAD_STATE_LOADED || obj.requestObject.state == ApiRequest.LOAD_STATE_KILLED)
            {
               obj.requestObject = null;
               this._requestArray.splice(i,1);
               this._pendingRequests--;
               i--;
            }
            else if(obj.requestObject.state == ApiRequest.LOAD_STATE_KILL_PENDING)
            {
               obj.requestObject = null;
               this._requestArray.splice(i,1);
            }
         }
      }
   }
}
