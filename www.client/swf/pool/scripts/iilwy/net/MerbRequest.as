package iilwy.net
{
   import flash.events.EventDispatcher;
   import iilwy.events.AsyncEvent;
   import iilwy.utils.logging.Logger;
   
   public class MerbRequest extends EventDispatcher
   {
      
      private static var _staticLogger:Logger;
      
      private static var idGenerator:Number = 1;
      
      public static const ERROR_TYPE_FATAL:String = "fatal";
      
      public static const ERROR_TYPE_TIMEOUT:String = "timeout";
       
      
      private var _id:String;
      
      private var _command:String;
      
      private var _params;
      
      private var _data;
      
      public var settings:MerbRequestSettings;
      
      public function MerbRequest(command:String, params:*, success:Function = null, fail:Function = null, timeout:Function = null, settings:MerbRequestSettings = null)
      {
         this.settings = new MerbRequestSettings();
         super();
         this._id = command + "/" + (MerbRequest.idGenerator++).toString();
         this._command = command;
         this._params = params;
         this.setListeners(success,fail,timeout);
         if(settings)
         {
            this.settings = settings;
         }
      }
      
      private static function get _logger() : Logger
      {
         if(_staticLogger == null)
         {
            _staticLogger = Logger.getLogger("MerbRequest");
            _staticLogger.level = Logger.ERROR;
         }
         return _staticLogger;
      }
      
      public function destroy() : void
      {
         this._params = null;
      }
      
      public function asObject() : Object
      {
         var result:* = {
            "id":this.id,
            "request":this._command,
            "params":this._params
         };
         return result;
      }
      
      public function setListeners(success:Function = null, fail:Function = null, timeout:Function = null) : void
      {
         if(success != null)
         {
            addEventListener(AsyncEvent.SUCCESS,success,false,0,true);
         }
         if(fail != null)
         {
            addEventListener(AsyncEvent.FAIL,fail,false,0,true);
         }
         if(timeout != null)
         {
            addEventListener(AsyncEvent.TIMEOUT,timeout,false,0,true);
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function handleResponse(response:*) : void
      {
         var evt:AsyncEvent = null;
         var hasTimeout:Boolean = false;
         this._data = response;
         if(response.success == 1)
         {
            _logger.log("Success: ",this._id);
            evt = new AsyncEvent(AsyncEvent.SUCCESS);
            evt.data = response.result;
            dispatchEvent(evt);
         }
         else
         {
            try
            {
               _logger.error(this._id,": ",response.error.type,response.error.msg);
               Logger.getLogger("MerbERROR").info(this._id,": ",response.error.type,response.error.msg);
               hasTimeout = hasEventListener(AsyncEvent.TIMEOUT);
               if(response.error.type == ERROR_TYPE_TIMEOUT && hasTimeout)
               {
                  evt = new AsyncEvent(AsyncEvent.TIMEOUT);
               }
               else
               {
                  evt = new AsyncEvent(AsyncEvent.FAIL);
               }
               evt.data = response.error;
               dispatchEvent(evt);
            }
            catch(error:Error)
            {
               _logger.error(_id,": ERROR IS NOT BEING RETURNED ON RESPONSE OBJECT!");
               evt = new AsyncEvent(AsyncEvent.FAIL);
               evt.data = {"msg":"Unspecified error"};
               dispatchEvent(evt);
            }
         }
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get command() : String
      {
         return this._command;
      }
   }
}
