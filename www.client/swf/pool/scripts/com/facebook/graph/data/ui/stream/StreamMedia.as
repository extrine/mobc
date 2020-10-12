package com.facebook.graph.data.ui.stream
{
   public class StreamMedia
   {
       
      
      public var type:String;
      
      public function StreamMedia()
      {
         super();
      }
      
      public function toObject() : Object
      {
         return {"type":this.type};
      }
   }
}
