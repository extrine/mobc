package com.facebook.graph.data.fql.user
{
   import com.facebook.graph.data.api.user.FacebookUser;
   import com.facebook.graph.utils.FacebookDataUtils;
   
   public class FQLUser
   {
       
      
      public var uid:Number;
      
      public var first_name:String;
      
      public var middle_name:String;
      
      public var last_name:String;
      
      public var name:String;
      
      public var pic_small:String;
      
      public var pic_big:String;
      
      public var pic_square:String;
      
      public var pic:String;
      
      public var affiliations:Array;
      
      public var profile_update_time:Date;
      
      public var timezone:String;
      
      public var religion:String;
      
      public var birthday:String;
      
      public var birthday_date:Date;
      
      public var sex:String;
      
      public var hometown_location:Array;
      
      public var meeting_sex:Array;
      
      public var meeting_for:Array;
      
      public var relationship_status:String;
      
      public var significant_other_id:Number;
      
      public var political:String;
      
      public var current_location:Array;
      
      public var activities:String;
      
      public var interests:String;
      
      public var is_app_user:Boolean;
      
      public var music:String;
      
      public var tv:String;
      
      public var movies:String;
      
      public var books:String;
      
      public var quotes:String;
      
      public var about_me:String;
      
      public var hs_info:Array;
      
      public var education_history:Array;
      
      public var work_history:Array;
      
      public var notes_count:int;
      
      public var wall_count:int;
      
      public var status:String;
      
      public var has_added_app:Boolean;
      
      public var online_presence:String;
      
      public var locale:String;
      
      public var proxied_email:String;
      
      public var profile_url:String;
      
      public var email_hashes:Array;
      
      public var pic_small_with_logo:String;
      
      public var pic_big_with_logo:String;
      
      public var pic_square_with_logo:String;
      
      public var pic_with_logo:String;
      
      public var allowed_restrictions:String;
      
      public var verified:Boolean;
      
      public var profile_blurb:String;
      
      public var family:Array;
      
      public var username:String;
      
      public var website:String;
      
      public var is_blocked:Boolean;
      
      public var contact_email:String;
      
      public var email:String;
      
      public var third_party_id:String;
      
      public function FQLUser()
      {
         super();
      }
      
      public function fromJSON(result:Object) : void
      {
         var property:String = null;
         if(result != null)
         {
            for(var _loc5_ in result)
            {
               switch(_loc5_)
               {
                  case "profile_update_time":
                  case "birthday_date":
                     if(hasOwnProperty(property))
                     {
                        this[property] = FacebookDataUtils.stringToDate(result[property]);
                     }
                     continue;
                  default:
                     if(hasOwnProperty(property))
                     {
                        this[property] = result[property];
                     }
                     continue;
               }
            }
         }
      }
      
      public function toFacebookUser() : FacebookUser
      {
         var facebookUser:FacebookUser = null;
         facebookUser = new FacebookUser();
         facebookUser.id = !isNaN(this.uid)?this.uid.toString():null;
         facebookUser.first_name = this.first_name;
         facebookUser.last_name = this.last_name;
         facebookUser.name = this.name;
         facebookUser.picture = Boolean(this.pic_square)?this.pic_square:Boolean(this.pic_square_with_logo)?this.pic_square_with_logo:Boolean(this.pic_small)?this.pic_small:Boolean(this.pic_small_with_logo)?this.pic_small_with_logo:Boolean(this.pic)?this.pic:Boolean(this.pic_with_logo)?this.pic_with_logo:Boolean(this.pic_big)?this.pic_big:Boolean(this.pic_big_with_logo)?this.pic_big_with_logo:null;
         facebookUser.link = this.profile_url;
         facebookUser.about = this.about_me;
         facebookUser.birthday = this.birthday;
         facebookUser.work = Boolean(this.work_history)?this.work_history.concat():null;
         facebookUser.education = Boolean(this.education_history)?this.education_history.concat():null;
         facebookUser.email = this.email;
         facebookUser.website = this.website;
         facebookUser.hometown = this.hometown_location && this.hometown_location.length > 0?this.hometown_location[0]:null;
         facebookUser.location = this.current_location && this.current_location.length > 0?this.current_location[0]:null;
         facebookUser.quotes = this.quotes;
         facebookUser.gender = this.sex;
         facebookUser.interested_in = this.meeting_sex && this.meeting_sex.length > 0?this.meeting_sex.join(","):null;
         facebookUser.meeting_for = this.meeting_for && this.meeting_for.length > 0?this.meeting_for.join(","):null;
         facebookUser.relationship_status = this.relationship_status;
         facebookUser.religion = this.religion;
         facebookUser.political = this.political;
         facebookUser.verified = this.verified;
         if(!isNaN(this.significant_other_id))
         {
            facebookUser.significant_other = new FacebookUser();
            facebookUser.significant_other.id = this.significant_other_id.toString();
         }
         facebookUser.timezone = Boolean(this.timezone)?Number(parseInt(this.timezone)):Number(0);
         facebookUser.locale = this.locale;
         facebookUser.updated_time = this.profile_update_time;
         return facebookUser;
      }
      
      public function toString() : String
      {
         return "[ uid: " + this.uid + ", name: " + this.name + " ]";
      }
   }
}
