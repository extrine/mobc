package iilwy.net
{
   import be.boulevart.as3.security.MD5;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.utils.logging.Logger;
   
   public class MerbPool extends EventDispatcher
   {
      
      protected static var timeoutCount:int = 0;
       
      
      private var _requestIds:Array;
      
      private var _timeStamp:Number;
      
      private var _requestJson:String;
      
      private var _sessionID:String;
      
      private var _loader:URLLoader;
      
      private var _response;
      
      private var _rawResponse:String;
      
      private var _commandString:String;
      
      private var _attempts:int = 0;
      
      private var _logger:Logger;
      
      protected var _isSecure:Boolean;
      
      protected var _isSecureProtocol:Boolean;
      
      protected var _startTime:Date;
      
      protected var _endTime:Date;
      
      protected var _timeoutTimer:Timer;
      
      protected var _checkedSecurity:Boolean;
      
      protected var _securityPassed:Boolean;
      
      public function MerbPool(requests:Array, timeStamp:Number, sessionID:String)
      {
         var req:MerbRequest = null;
         super();
         this._timeStamp = timeStamp;
         this._requestIds = new Array();
         this._sessionID = sessionID;
         var rawPool:Array = new Array();
         var commands:Array = new Array();
         for(var i:int = 0; i < requests.length; i++)
         {
            req = requests[i];
            rawPool.push(req.asObject());
            commands.push(req.command);
            this._requestIds.push(req.id);
            if(req.settings.secure)
            {
               this._isSecure = true;
            }
            if(req.settings.secureProtocol)
            {
               this._isSecureProtocol = true;
            }
         }
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.WARN;
         this._requestJson = JSON.serialize({"pool":rawPool});
         this._commandString = commands.toString();
         var timeoutDelay:int = 100;
         if(MerbProxyProperties.timeoutSeconds > 0)
         {
            timeoutDelay = MerbProxyProperties.timeoutSeconds;
         }
         this._timeoutTimer = new Timer(1000,timeoutDelay);
         this._timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeoutTimerComplete,false,0,true);
      }
      
      public static function checkPoolHashAgainstResponse(checkHash:String, rawResponse:String) : Boolean
      {
         var startIndex:int = rawResponse.indexOf("{",1);
         var endIndex:int = rawResponse.lastIndexOf("}",rawResponse.length - 2) + 1;
         var checkResponse:String = rawResponse.substring(startIndex,endIndex);
         checkResponse = checkResponse + "defenceme!";
         var hash:String = MD5.calculate(checkResponse);
         if(checkHash && checkHash != hash)
         {
            return false;
         }
         return true;
      }
      
      public function destroy() : void
      {
         this._loader.data = null;
         this._loader = null;
         this._commandString = null;
         this._requestJson = null;
         this._requestIds = null;
         this._response = null;
         this._timeoutTimer.stop();
         this._timeoutTimer = null;
      }
      
      public function set timeStamp(n:Number) : void
      {
         this._timeStamp = n;
      }
      
      public function get attempts() : int
      {
         return this._attempts;
      }
      
      protected function generateKey(pool:String, ts:Number) : String
      {
         var combined:String = pool + ts + "your mother";
         var result:String = MD5.calculate(combined);
         return result;
      }
      
      public function send() : void
      {
         this._response = null;
         this._rawResponse = null;
         this._attempts++;
         var key:String = this.generateKey(this._requestJson,this._timeStamp);
         var vars:URLVariables = new URLVariables();
         vars.pool_request_json = this._requestJson;
         vars.pool_request_ts = this._timeStamp;
         vars.pool_request_key = key;
         if(this._isSecure)
         {
            vars.secure = true;
         }
         if(this._sessionID)
         {
            vars.session_id = this._sessionID;
         }
         var base:String = !!this._isSecureProtocol?MerbProxyProperties.secureLocation:MerbProxyProperties.location;
         if(this._commandString != "event_controller/get_events")
         {
            this._logger.log("Send",this._commandString);
         }
         var cs:String = this._commandString.substr(0,128);
         var poolRequest:URLRequest = new URLRequest(base + "api/pool" + "?commands=" + cs);
         poolRequest.method = URLRequestMethod.POST;
         poolRequest.data = vars;
         this._loader = new URLLoader();
         this._loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError,false,0,true);
         this._loader.load(poolRequest);
         this._startTime = new Date();
         if(MerbProxyProperties.timeoutSeconds > 0)
         {
            this._timeoutTimer.reset();
            this._timeoutTimer.start();
         }
      }
      
      protected function onComplete(event:Event) : void
      {
         var startTime:int = 0;
         var elapsed:int = 0;
         this._timeoutTimer.stop();
         var valid:Boolean = false;
         try
         {
            startTime = getTimer();
            this._response = JSON.deserialize(this._loader.data);
            elapsed = getTimer() - startTime;
            this._logger.log("Parsing result: " + elapsed + " ms, " + this._commandString);
            this._rawResponse = this._loader.data;
         }
         catch(error:Error)
         {
            _logger.error("Merb Pool, onComplete, error: syntax error");
            MerbProxyProperties.trackDiagnostic("merbError/syntax/" + _commandString);
         }
         if(this._response)
         {
            valid = true;
         }
         this._endTime = new Date();
         if(valid)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            this.simulateError();
         }
      }
      
      protected function onTimeoutTimerComplete(event:TimerEvent) : void
      {
         MerbProxyProperties.trackDiagnostic("merbError/timeout/occur");
         MerbProxyProperties.trackDiagnostic("merbError/timeout/count/" + timeoutCount++);
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
         }
         this._timeoutTimer.stop();
         this._response = {"timeout":true};
         this._endTime = new Date();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onIoError(event:IOErrorEvent) : void
      {
         this._timeoutTimer.stop();
         MerbProxyProperties.trackDiagnostic("merbError/flash_io");
         this.simulateError();
      }
      
      protected function onSecurityError(event:SecurityErrorEvent) : void
      {
         this._timeoutTimer.stop();
         MerbProxyProperties.trackDiagnostic("merbError/flash_security");
         this.simulateError();
      }
      
      protected function simulateError() : void
      {
         this._response = {"success":0};
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get data() : *
      {
         return this._response;
      }
      
      public function get requestIds() : Array
      {
         return this._requestIds;
      }
      
      public function get securityPassed() : Boolean
      {
         if(!this._isSecure)
         {
            return true;
         }
         if(this._checkedSecurity)
         {
            return this._securityPassed;
         }
         this._checkedSecurity = true;
         this._securityPassed = true;
         if(this._response && !checkPoolHashAgainstResponse(this._response.secure_hash,this._rawResponse))
         {
            this._logger.error("Security Error on MerbPool");
            MerbProxyProperties.trackDiagnostic("merbError/security_hash/" + this._commandString);
            this._securityPassed = false;
         }
         return this._securityPassed;
      }
      
      public function getDuration() : Number
      {
         if(!this._endTime || !this._startTime)
         {
            return 0;
         }
         return this._endTime.time - this._startTime.time;
      }
   }
}
