package com.google.analytics.core
{
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class RequestObject
   {
       
      
      public var start:int;
      
      public var end:int;
      
      public var request:URLRequest;
      
      public function RequestObject(request:URLRequest)
      {
         super();
         this.start = getTimer();
         this.request = request;
      }
      
      public function get duration() : int
      {
         if(!this.hasCompleted())
         {
            return 0;
         }
         return this.end - this.start;
      }
      
      public function complete() : void
      {
         this.end = getTimer();
      }
      
      public function hasCompleted() : Boolean
      {
         return this.end > 0;
      }
      
      public function toString() : String
      {
         var data:Array = [];
         data.push("duration: " + this.duration + "ms");
         data.push("url: " + this.request.url);
         return "{ " + data.join(", ") + " }";
      }
   }
}
