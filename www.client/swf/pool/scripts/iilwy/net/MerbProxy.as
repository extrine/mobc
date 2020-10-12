package iilwy.net
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.utils.logging.Logger;
   
   public class MerbProxy
   {
      
      private static var _instance:MerbProxy;
      
      public static const QUEUE_TYPE_IMMEDIATE:String = "queueType.immediate";
      
      public static const QUEUE_TYPE_QUEUED:String = "queueType.queued";
      
      public static const QUEUE_TYPE_DEFERRED:String = "queueType.deferred";
       
      
      private var _queue:Array;
      
      private var _lazyQueue:Array;
      
      private var _pendingRequests:Array;
      
      private var _queueTimer:Timer;
      
      private var _lazyTimer:Timer;
      
      public var _pools:Array;
      
      protected var _logger:Logger;
      
      protected var _timestampSetOnce:Boolean;
      
      public function MerbProxy()
      {
         super();
         this._queue = new Array();
         this._lazyQueue = new Array();
         this._pendingRequests = new Array();
         this._pools = new Array();
         this._queueTimer = new Timer(1000 / 30,1);
         this._queueTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onQueueTimerComplete);
         this._lazyTimer = new Timer(5000,1);
         this._lazyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLazyQueueTimerComplete);
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.WARN;
      }
      
      public static function getInstance() : MerbProxy
      {
         if(!_instance)
         {
            _instance = new MerbProxy();
         }
         return _instance;
      }
      
      public function timeSync() : void
      {
      }
      
      public function request(queueType:String, command:String, params:* = null, success:Function = null, fail:Function = null, timeout:Function = null, settings:MerbRequestSettings = null) : MerbRequest
      {
         var req:MerbRequest = null;
         if(queueType == QUEUE_TYPE_IMMEDIATE)
         {
            req = this.requestImmediate(command,params,success,fail,timeout,settings);
         }
         else if(queueType == QUEUE_TYPE_QUEUED)
         {
            req = this.requestQueued(command,params,success,fail,timeout,settings);
         }
         else if(queueType == QUEUE_TYPE_DEFERRED)
         {
            req = this.requestDeferred(command,params,success,fail,timeout,settings);
         }
         return req;
      }
      
      public function requestImmediate(command:String, params:* = null, success:Function = null, fail:Function = null, timeout:Function = null, settings:MerbRequestSettings = null) : MerbRequest
      {
         var req:MerbRequest = new MerbRequest(command,params,success,fail,timeout,settings);
         var pool:MerbPool = this.poolRequests([req]);
         pool.send();
         return req;
      }
      
      public function requestQueued(command:String, params:* = null, success:Function = null, fail:Function = null, timeout:Function = null, settings:MerbRequestSettings = null) : MerbRequest
      {
         var req:MerbRequest = new MerbRequest(command,params,success,fail,timeout,settings);
         this._queue.push(req);
         if(!this._queueTimer.running)
         {
            this._queueTimer.start();
         }
         return req;
      }
      
      public function requestDeferred(command:String, params:*, success:Function = null, fail:Function = null, timeout:Function = null, settings:MerbRequestSettings = null) : MerbRequest
      {
         var req:MerbRequest = new MerbRequest(command,params,success,fail,timeout,settings);
         this._lazyQueue.push(req);
         if(!this._lazyTimer.running)
         {
            this._lazyTimer.start();
         }
         return req;
      }
      
      public function sendQueue() : void
      {
         this.onQueueTimerComplete(null);
      }
      
      protected function onQueueTimerComplete(event:TimerEvent) : void
      {
         var pool:MerbPool = null;
         this._queueTimer.stop();
         this._lazyTimer.stop();
         var list:Array = [];
         list = list.concat(this._lazyQueue);
         list = list.concat(this._queue);
         if(list.length > 0)
         {
            pool = this.poolRequests(list);
            pool.send();
            this._logger.log("Sending pool",this._queue.length);
         }
         this._queue = new Array();
         this._lazyQueue = new Array();
      }
      
      protected function onLazyQueueTimerComplete(event:TimerEvent) : void
      {
         var pool:MerbPool = this.poolRequests(this._lazyQueue);
         pool.send();
         this._logger.log("Sending deferred pool",this._lazyQueue.length);
         this._lazyQueue = new Array();
      }
      
      public function poolRequests(requests:Array) : MerbPool
      {
         var ts:Number = NaN;
         var req:MerbRequest = null;
         for(var i:int = 0; i < requests.length; i++)
         {
            req = requests[i];
            this._pendingRequests[req.id] = req;
         }
         ts = Math.floor(MerbProxyProperties.serverNow.time / 1000);
         var pool:MerbPool = new MerbPool(requests,ts,MerbProxyProperties.sessionID);
         pool.addEventListener(Event.COMPLETE,this.onPoolLoaded,false,0,true);
         this._pools.push(pool);
         return pool;
      }
      
      protected function onPoolLoaded(event:Event) : void
      {
         var pool:MerbPool = MerbPool(event.target);
         this.processResponse(pool);
      }
      
      protected function removePool(pool:MerbPool) : void
      {
         var index:int = this._pools.indexOf(pool);
         if(index > -1)
         {
            this._pools.splice(index,1);
         }
         pool.removeEventListener(Event.COMPLETE,this.onPoolLoaded);
         pool.destroy();
      }
      
      protected function processResponse(pool:MerbPool) : void
      {
         var i:int = 0;
         var id:String = null;
         var req:MerbRequest = null;
         var response:* = undefined;
         var ts:Number = NaN;
         var dur:Number = NaN;
         var retry:Boolean = false;
         var errorMsg:String = null;
         var errorType:String = null;
         var l:int = pool.requestIds.length;
         var serverNow:Number = pool.data.ts * 1000;
         if(pool.data.ts)
         {
            ts = pool.data.ts * 1000;
            dur = pool.getDuration();
            this._logger.log("Merb pool duration:",dur);
            if(true && dur > 0)
            {
               ts = ts + Math.floor(dur / 2);
            }
            if(dur < 10000 || !this._timestampSetOnce)
            {
               this._logger.log("Setting merb timestamp",ts);
               MerbProxyProperties.setServerNow(ts);
               this._timestampSetOnce = true;
            }
         }
         if(!MerbProxyProperties.sessionID)
         {
            MerbProxyProperties.sessionID = pool.data.session_id;
         }
         if(pool.data.success == 1 && pool.securityPassed)
         {
            this._logger.log("Successful pool",pool.requestIds.toString());
            for(i = 0; i < l; i++)
            {
               id = pool.requestIds[i];
               req = this._pendingRequests[id];
               delete this._pendingRequests[id];
               response = pool.data.response[id];
               req.handleResponse(response);
               req.destroy();
            }
            this.removePool(pool);
         }
         else
         {
            retry = false;
            errorMsg = "Error";
            errorType = MerbRequest.ERROR_TYPE_FATAL;
            this._logger.log("Unsuccessful pool");
            if(pool.data && pool.data.error && pool.data.error.type == "stale")
            {
               errorMsg = pool.data.error.msg;
               this._logger.warn("Stale pool");
               retry = true;
               this._timestampSetOnce = false;
            }
            else if(pool.data.timeout == true)
            {
               errorMsg = "Time Out";
               errorType = MerbRequest.ERROR_TYPE_TIMEOUT;
               retry = true;
            }
            else if(!pool.data || !pool.data.error)
            {
               errorMsg = "Pool Error";
               this._logger.warn("Total fail, maybe 500");
               retry = true;
            }
            if(pool.attempts >= 3)
            {
               retry = false;
            }
            if(pool.data.success == 1 && !pool.securityPassed)
            {
               errorMsg = "Unpassed Error";
               retry = false;
            }
            if(retry)
            {
               pool.timeStamp = Math.floor(MerbProxyProperties.serverNow.time / 1000);
               pool.send();
            }
            else
            {
               for(i = 0; i < l; i++)
               {
                  id = pool.requestIds[i];
                  req = this._pendingRequests[id];
                  delete this._pendingRequests[id];
                  req.handleResponse({
                     "success":0,
                     "error":{
                        "type":errorType,
                        "msg":errorMsg
                     }
                  });
                  req.destroy();
               }
               this.removePool(pool);
            }
         }
      }
   }
}
