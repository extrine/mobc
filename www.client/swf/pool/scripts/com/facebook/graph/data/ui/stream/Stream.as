package com.facebook.graph.data.ui.stream
{
   public class Stream
   {
       
      
      public var message:String;
      
      public var attachment:StreamAttachment;
      
      public var action_links:Array;
      
      public var target_id:String;
      
      public var uid:String;
      
      public var privacy:StreamPrivacy;
      
      public function Stream()
      {
         super();
      }
      
      public function toObject() : Object
      {
         var streamActionLink:StreamActionLink = null;
         var object:Object = {};
         if(this.message)
         {
            object.message = this.message;
         }
         if(this.attachment)
         {
            object.attachment = this.attachment.toObject();
         }
         if(this.action_links && this.action_links.length > 0)
         {
            object.action_links = [];
            for each(streamActionLink in this.action_links)
            {
               object.action_links.push(streamActionLink.toObject());
            }
         }
         if(this.target_id)
         {
            object.target_id = this.target_id;
         }
         if(this.uid)
         {
            object.uid = this.uid;
         }
         if(this.privacy)
         {
            object.privacy = this.privacy.toObject();
         }
         return object;
      }
   }
}
