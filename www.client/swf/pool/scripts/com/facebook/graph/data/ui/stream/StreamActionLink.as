package com.facebook.graph.data.ui.stream
{
   public class StreamActionLink
   {
       
      
      public var text:String;
      
      public var href:String;
      
      public function StreamActionLink()
      {
         super();
      }
      
      public function toObject() : Object
      {
         return {
            "text":this.text,
            "href":this.href
         };
      }
   }
}
