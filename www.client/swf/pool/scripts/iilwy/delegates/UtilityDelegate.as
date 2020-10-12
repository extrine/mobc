package iilwy.delegates
{
   import flash.events.EventDispatcher;
   import iilwy.net.MerbProxy;
   import iilwy.net.MerbRequest;
   
   public class UtilityDelegate extends MerbRequestDelegate
   {
       
      
      public function UtilityDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         super();
         _success = success;
         _fail = fail;
         _timeout = timeout;
      }
      
      public function log(info:*, queueType:String = null) : EventDispatcher
      {
         var req:MerbRequest = null;
         var qtype:String = Boolean(queueType)?queueType:MerbProxy.QUEUE_TYPE_DEFERRED;
         var params:* = {"log_info":info};
         req = getMerbProxy().request(qtype,"gamenet_logger_controller/log",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
   }
}
