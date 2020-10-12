package com.facebook.graph.data.ui.stream
{
   import flash.utils.Dictionary;
   
   public class StreamAttachment
   {
       
      
      public var name:String;
      
      public var href:String;
      
      public var caption:String;
      
      public var description:String;
      
      public var properties:Dictionary;
      
      public var media:Array;
      
      public var comments_xid:String;
      
      public var keyValuePairs:Dictionary;
      
      public function StreamAttachment()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var prop:* = null;
         var streamMedia:StreamMedia = null;
         var key:* = null;
         var object:Object = {};
         if(this.name)
         {
            object.name = this.name;
         }
         if(this.href)
         {
            object.href = this.href;
         }
         if(this.caption)
         {
            object.caption = this.caption;
         }
         if(this.description)
         {
            object.description = this.description;
         }
         if(this.properties)
         {
            object.properties = {};
            for(prop in this.properties)
            {
               object.properties[prop] = this.properties[prop];
            }
         }
         if(this.media && this.media.length > 0)
         {
            object.media = [];
            for each(streamMedia in this.media)
            {
               object.media.push(streamMedia.toObject());
            }
         }
         if(this.comments_xid)
         {
            object.comments_xid = this.comments_xid;
         }
         if(this.keyValuePairs)
         {
            for(key in this.keyValuePairs)
            {
               object[key] = this.keyValuePairs[key];
            }
         }
         return object;
      }
   }
}
