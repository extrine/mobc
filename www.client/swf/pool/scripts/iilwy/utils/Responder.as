package iilwy.utils
{
   import flash.events.EventDispatcher;
   import iilwy.events.AsyncEvent;
   
   public class Responder extends EventDispatcher
   {
       
      
      public function Responder()
      {
         super();
      }
      
      public static function createWithAsyncListeners(success:Function, fail:Function = null) : Responder
      {
         var result:Responder = new Responder();
         result.setAsyncListeners(success,fail);
         return result;
      }
      
      public function clearAsyncListeners(success:Function, fail:Function = null) : void
      {
         if(success != null)
         {
            removeEventListener(AsyncEvent.SUCCESS,success);
         }
         if(fail != null)
         {
            removeEventListener(AsyncEvent.FAIL,fail);
         }
      }
      
      public function setAsyncListeners(success:Function, fail:Function = null) : void
      {
         if(success != null)
         {
            this.addEventListener(AsyncEvent.SUCCESS,success);
         }
         if(fail != null)
         {
            this.addEventListener(AsyncEvent.FAIL,fail);
         }
      }
      
      public function dispatchFailEvent(data:* = null) : void
      {
         var failEvent:AsyncEvent = new AsyncEvent(AsyncEvent.FAIL);
         failEvent.data = data;
         dispatchEvent(failEvent);
      }
      
      public function dispatchSuccessEvent(data:* = null) : void
      {
         var successEvent:AsyncEvent = new AsyncEvent(AsyncEvent.SUCCESS);
         successEvent.data = data;
         dispatchEvent(successEvent);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
   }
}
