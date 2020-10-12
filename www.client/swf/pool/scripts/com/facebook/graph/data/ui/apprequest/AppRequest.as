package com.facebook.graph.data.ui.apprequest
{
   public class AppRequest
   {
       
      
      public var message:String;
      
      public var to:Array;
      
      public var filters:Array;
      
      public var app_data:String;
      
      public var title:String;
      
      public function AppRequest()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var filter:* = undefined;
         var object:Object = {};
         if(this.message)
         {
            object.message = this.message;
         }
         if(this.to && this.to.length > 0)
         {
            object.to = this.to.join(",");
         }
         if(this.filters && this.filters.length > 0)
         {
            object.filters = [];
            for each(filter in this.filters)
            {
               object.filters.push(filter);
            }
         }
         if(this.app_data)
         {
            object.app_data = this.app_data;
         }
         if(this.title)
         {
            object.title = this.title;
         }
         return object;
      }
   }
}
