package iilwy.delegates
{
   import iilwy.net.MerbProxy;
   import iilwy.net.MerbRequest;
   
   public class MerbRequestDelegate extends Delegate
   {
       
      
      public var queueType:String;
      
      protected var request:MerbRequest;
      
      protected var _success:Function;
      
      protected var _fail:Function;
      
      protected var _timeout:Function;
      
      public function MerbRequestDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         this.queueType = MerbProxy.QUEUE_TYPE_QUEUED;
         super();
         this._success = success;
         this._fail = fail;
         this._timeout = timeout;
      }
      
      protected function getMerbProxy() : MerbProxy
      {
         return MerbProxy.getInstance();
      }
   }
}
