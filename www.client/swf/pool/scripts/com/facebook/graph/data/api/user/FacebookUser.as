package com.facebook.graph.data.api.user
{
   import com.facebook.graph.core.facebook_internal;
   import com.facebook.graph.data.api.core.AbstractFacebookGraphObject;
   
   use namespace facebook_internal;
   
   public class FacebookUser extends AbstractFacebookGraphObject
   {
       
      
      public var name:String;
      
      public var first_name:String;
      
      public var last_name:String;
      
      public var gender:String;
      
      public var locale:String;
      
      public var link:String;
      
      public var third_party_id:String;
      
      public var timezone:Number;
      
      public var updated_time:Date;
      
      public var verified:Boolean;
      
      public var about:String;
      
      public var bio:String;
      
      public var birthday:String;
      
      public var education:Array;
      
      public var email:String;
      
      public var hometown:Object;
      
      public var interested_in:String;
      
      public var location:Object;
      
      public var meeting_for:String;
      
      public var political:String;
      
      public var quotes:String;
      
      public var relationship_status:String;
      
      public var religion:String;
      
      public var significant_other:FacebookUser;
      
      public var website:String;
      
      public var work:Array;
      
      public var picture:String;
      
      public function FacebookUser()
      {
         super();
      }
      
      public static function fromJSON(result:Object) : FacebookUser
      {
         var user:FacebookUser = new FacebookUser();
         user.fromJSON(result);
         return user;
      }
      
      override protected function setPropertyValue(property:String, value:*) : void
      {
         switch(property)
         {
            case FacebookUserField.SIGNIFICANT_OTHER:
               this.significant_other = FacebookUser.fromJSON(value);
               break;
            default:
               super.setPropertyValue(property,value);
         }
      }
      
      override public function toString() : String
      {
         return toString([FacebookUserField.ID,FacebookUserField.NAME]);
      }
   }
}
