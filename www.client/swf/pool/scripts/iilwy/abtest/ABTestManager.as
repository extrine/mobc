package iilwy.abtest
{
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import iilwy.events.AsyncEvent;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class ABTestManager extends EventDispatcher
   {
      
      protected static var _instance:ABTestManager;
       
      
      public var isLoaded:Boolean;
      
      protected var availableTests:Vector.<ABTest>;
      
      protected var startedTests:Vector.<ABTest>;
      
      protected var completedTests:Vector.<ABTest>;
      
      protected var logger:Logger;
      
      protected var lastLoadUserKey:String;
      
      public function ABTestManager()
      {
         super();
         this.logger = Logger.getLogger(this);
         this.availableTests = new Vector.<ABTest>();
         this.startedTests = new Vector.<ABTest>();
         this.completedTests = new Vector.<ABTest>();
      }
      
      public function get currentID() : int
      {
         throw new Error("Must override method");
      }
      
      public function get isVisitor() : Boolean
      {
         throw new Error("Must override method");
      }
      
      public function getTests() : void
      {
         var userKey:String = this.currentID.toString() + "_" + this.isVisitor.toString();
         if(userKey == this.lastLoadUserKey)
         {
            this.logger.log("Already loaded test for user");
            return;
         }
         this.logger.log("Loading tests for ",this.currentID,this.isVisitor);
         this.lastLoadUserKey = userKey;
         this.availableTests = new Vector.<ABTest>();
         this.startedTests = new Vector.<ABTest>();
         this.completedTests = new Vector.<ABTest>();
         this.isLoaded = false;
         var del:ABTestDelegate = new ABTestDelegate(this.onGetTestsSuccess,this.onGetTestsError);
         del.getTests(this.currentID,this.isVisitor);
      }
      
      protected function onGetTestsSuccess(event:AsyncEvent) : void
      {
         var obj:* = undefined;
         var test:ABTest = null;
         var externallyStartedTest:Object = null;
         var started:ABTest = null;
         if(!event.data.tests)
         {
            return;
         }
         this.logger.log("gettests success");
         this.isLoaded = true;
         var externallyStartedTests:Array = this.getExternallyStartedTestIds();
         for each(obj in event.data.tests)
         {
            test = ABTest.create(obj);
            this.availableTests.push(test);
            if(externallyStartedTests)
            {
               for each(externallyStartedTest in externallyStartedTests)
               {
                  if(externallyStartedTest.test_group_id == test.cohortID)
                  {
                     test.startedInstanceID = externallyStartedTest.test_result_id;
                     started = test.clone();
                     this.startedTests.push(started);
                  }
               }
            }
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onGetTestsError(event:AsyncEvent) : void
      {
         this.isLoaded = true;
         this.logger.error("gettests error");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function startAvailableTestForContext(superContext:String, subContext:String) : void
      {
         var test:ABTest = this.getAvailableTestForStartContext(superContext,subContext);
         this.startTest(test);
      }
      
      public function startTest(test:ABTest) : void
      {
         if(!test)
         {
            return;
         }
         var started:ABTest = test.clone();
         var del:ABTestDelegate = new ABTestDelegate(started.onStartTestSuccess,started.onStartTestError);
         del.startTest(started.cohortID);
         this.startedTests.push(started);
      }
      
      public function completeTestForStartContext(superContext:String, subContext:String) : void
      {
         var test:ABTest = this.getStartedTestForStartContext(superContext,subContext);
         this.completeTest(test);
      }
      
      public function completeTestForEndContext(superContext:String, subContext:String) : void
      {
         var test:ABTest = this.getStartedTestForEndContext(superContext,subContext);
         this.completeTest(test);
      }
      
      public function completeTest(test:ABTest) : void
      {
         var index:int = 0;
         var del:ABTestDelegate = null;
         if(!test)
         {
            return;
         }
         if(test.isStarted && !test.isComplete)
         {
            index = this.startedTests.indexOf(test);
            if(index >= 0)
            {
               this.startedTests.splice(index,1);
               this.completedTests.push(test);
               del = new ABTestDelegate(test.onCompleteTestSuccess,test.onCompleteTestError);
               del.completeTest(test.startedInstanceID);
            }
         }
      }
      
      public function getStartedTestForStartContext(superContext:String, subContext:String) : ABTest
      {
         var result:ABTest = null;
         var test:ABTest = null;
         for each(test in this.startedTests)
         {
            if(test.startSubContext == subContext)
            {
               result = test;
               break;
            }
         }
         return result;
      }
      
      public function getStartedTestForEndContext(superContext:String, subContext:String) : ABTest
      {
         var result:ABTest = null;
         var test:ABTest = null;
         for each(test in this.startedTests)
         {
            if(test.completeSubContext == subContext)
            {
               result = test;
               break;
            }
         }
         return result;
      }
      
      public function getAvailableTestForStartContext(superContext:String, subContext:String) : ABTest
      {
         var result:ABTest = null;
         var test:ABTest = null;
         for each(test in this.availableTests)
         {
            if(test.startSubContext == subContext)
            {
               result = test;
               break;
            }
         }
         return result;
      }
      
      private function getExternallyStartedTestIds() : Array
      {
         var id:String = null;
         var flashVars:Object = LoaderInfo(StageReference.stage.root.loaderInfo).parameters;
         var ids:Array = flashVars && flashVars.started_test_ids?flashVars.started_test_ids.split("|"):null;
         var idObjects:Array = new Array();
         if(ids)
         {
            for each(id in ids)
            {
               if(id && id != "")
               {
                  idObjects.push(JSON.decode(id,false));
               }
            }
         }
         if(idObjects)
         {
            return idObjects;
         }
         return null;
      }
   }
}
