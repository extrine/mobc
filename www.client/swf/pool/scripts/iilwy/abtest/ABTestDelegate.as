package iilwy.abtest
{
   import iilwy.delegates.MerbRequestDelegate;
   import iilwy.net.MerbRequest;
   
   public class ABTestDelegate extends MerbRequestDelegate
   {
       
      
      public function ABTestDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         super(success,fail,timeout);
      }
      
      public function getTests(id:Number, isVisitor:Boolean, superContext:String = null) : MerbRequest
      {
         var request:MerbRequest = null;
         var params:Object = {
            "user_id":id,
            "is_visitor":isVisitor
         };
         request = getMerbProxy().requestImmediate("a_b_test_controller/get_tests",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function startTest(cohortID:int) : MerbRequest
      {
         var request:MerbRequest = null;
         var params:Object = {"ab_test_group_id":cohortID};
         request = getMerbProxy().requestImmediate("a_b_test_controller/start_test",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
      
      public function completeTest(testInstanceID:int) : MerbRequest
      {
         var request:MerbRequest = null;
         var params:Object = {"ab_test_result_id":testInstanceID};
         request = getMerbProxy().requestImmediate("a_b_test_controller/end_test",params);
         request.setListeners(_success,_fail,_timeout);
         return request;
      }
   }
}
