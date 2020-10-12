package iilwy.abtest
{
   import iilwy.events.AsyncEvent;
   import iilwy.utils.logging.Logger;
   
   public class ABTest
   {
       
      
      public var startSuperContext:String;
      
      public var startSubContext:String;
      
      public var completeSuperContext:String;
      
      public var completeSubContext:String;
      
      public var cohortID:int = -1;
      
      public var startedInstanceID:int = -1;
      
      public var values;
      
      protected var logger:Logger;
      
      protected var _complete:Boolean;
      
      public function ABTest()
      {
         this.values = {};
         super();
         this.logger = Logger.getLogger(this);
      }
      
      public static function create(data:*) : ABTest
      {
         var result:ABTest = new ABTest();
         result.startSubContext = data.subcontext_start;
         result.startSuperContext = data.supercontext_start;
         result.completeSubContext = data.subcontext_end;
         result.completeSuperContext = data.supercontext_end;
         result.cohortID = data.id;
         if(data.values)
         {
            result.values = data.values;
         }
         return result;
      }
      
      public function copy(other:ABTest) : void
      {
         this.startSuperContext = other.startSuperContext;
         this.startSubContext = other.startSubContext;
         this.completeSuperContext = other.completeSuperContext;
         this.completeSubContext = other.completeSubContext;
         this.cohortID = other.cohortID;
         this.startedInstanceID = other.startedInstanceID;
         this.values = other.values;
      }
      
      public function clone() : ABTest
      {
         var result:ABTest = new ABTest();
         result.copy(this);
         return result;
      }
      
      public function hasValue(id:String) : Boolean
      {
         var p:* = null;
         for(p in this.values)
         {
            if(p == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getValue(id:String) : *
      {
         var val:* = undefined;
         if(this.hasValue(id))
         {
            val = this.values[id];
            return val;
         }
         return null;
      }
      
      public function getBooleanValue(id:String) : Boolean
      {
         var val:* = undefined;
         if(this.hasValue(id))
         {
            val = this.values[id];
            return val == "true" || val == "1";
         }
         return false;
      }
      
      public function get isStarted() : Boolean
      {
         return this.startedInstanceID >= 0;
      }
      
      public function get isComplete() : Boolean
      {
         return this._complete;
      }
      
      public function onStartTestSuccess(event:AsyncEvent) : void
      {
         if(event.data.ab_test_result_id)
         {
            this.startedInstanceID = event.data.ab_test_result_id;
            this.logger.log("started",this);
         }
      }
      
      public function onStartTestError(event:AsyncEvent) : void
      {
         this.logger.log("error starting",this);
      }
      
      public function onCompleteTestSuccess(event:AsyncEvent) : void
      {
         this._complete = true;
         this.logger.log("completed",this);
      }
      
      public function onCompleteTestError(event:AsyncEvent) : void
      {
         this.logger.log("error completing",this);
      }
   }
}
