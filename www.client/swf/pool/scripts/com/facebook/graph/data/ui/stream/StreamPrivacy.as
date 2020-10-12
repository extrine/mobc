package com.facebook.graph.data.ui.stream
{
   public class StreamPrivacy
   {
       
      
      public var value:String;
      
      public var friends:String;
      
      public var networks:Array;
      
      public var allow:Array;
      
      public var deny:Array;
      
      public function StreamPrivacy()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var object:Object = {};
         object.value = this.value;
         if(this.friends)
         {
            object.friends = this.friends;
         }
         if(this.networks && this.networks.length > 0)
         {
            object.networks = this.networks.join(",");
         }
         if(this.allow && this.allow.length > 0)
         {
            object.allow = this.allow.join(",");
         }
         if(this.deny && this.deny.length > 0)
         {
            object.deny = this.deny.join(",");
         }
         return object;
      }
   }
}
