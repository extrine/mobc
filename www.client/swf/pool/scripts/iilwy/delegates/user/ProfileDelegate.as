package iilwy.delegates.user
{
   import iilwy.application.AppComponents;
   import iilwy.delegates.MerbRequestDelegate;
   import iilwy.model.dataobjects.user.PrivateUserData;
   import iilwy.net.MerbRequest;
   
   public class ProfileDelegate extends MerbRequestDelegate
   {
       
      
      public function ProfileDelegate(success:Function = null, fail:Function = null, timeout:Function = null)
      {
         super();
         _success = success;
         _fail = fail;
         _timeout = timeout;
      }
      
      public function getProfilePhotos(profileId:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"profile_id":profileId};
         req = getMerbProxy().requestQueued("profile_controller/get_photos_by_profile_id",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getProfile(profileId:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"user":{"profile_id":profileId}};
         req = getMerbProxy().requestQueued("profile_controller/show",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getProfileByUserID(userID:int) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"user":{"user_id":userID}};
         req = getMerbProxy().requestQueued("profile_controller/show",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getProfileByProfileName(profileName:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"user":{"profile_name":profileName}};
         req = getMerbProxy().requestQueued("profile_controller/show",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function invalidatePhotoCache(userId:int) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:* = {"user_id":userId};
         req = getMerbProxy().requestQueued("profile_controller/delete_photos_cache",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function updateProfile(userId:Number, user:PrivateUserData) : MerbRequest
      {
         var backgroundId:String = null;
         var req:MerbRequest = null;
         var prop:* = null;
         if(user.profile && user.profile.background)
         {
            for(prop in AppComponents.model.standardBackgrounds)
            {
               if(AppComponents.model.standardBackgrounds[prop] == user.profile.background)
               {
                  backgroundId = prop;
               }
            }
         }
         var params:* = {
            "user":{"user_id":userId},
            "profile":{
               "profile_name":user.profile.profile_name,
               "clan_name":user.profile.clan_name,
               "catch_phrase":user.profile.catch_phrase,
               "first_name":user.firstName,
               "last_name":user.lastName,
               "bio":user.profile.bio,
               "dob_year":user.birthYear,
               "dob_month":user.birthMonth,
               "dob_day":user.birthDay,
               "background_image_id":backgroundId,
               "gender":(user.gender >= 0?user.gender:1),
               "email_address":user.email,
               "aim_username":user.aimUsername,
               "state":user.state,
               "city":user.city,
               "country":user.country,
               "zipcode":user.zipcode
            }
         };
         for(prop in params.profile)
         {
            if(params.profile[prop] == null)
            {
               delete params.profile[prop];
            }
            if(params.profile[prop] is Number && isNaN(params.profile[prop]))
            {
               delete params.profile[prop];
            }
         }
         req = getMerbProxy().requestQueued("profile_controller/update",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function updateProfileName(profileName:String) : MerbRequest
      {
         var req:MerbRequest = null;
         var params:Object = {};
         params.profile_name = profileName;
         req = getMerbProxy().requestQueued("profile_controller/update_profile_name_new",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function getProfileNameUpdateStatus() : MerbRequest
      {
         var req:MerbRequest = null;
         var params:Object = {};
         req = getMerbProxy().requestQueued("profile_controller/profile_name_change_status",params);
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
      
      public function changeEmailAccessCode() : MerbRequest
      {
         var req:MerbRequest = null;
         req = getMerbProxy().requestQueued("profile_controller/change_email_access_code");
         req.setListeners(_success,_fail,_timeout);
         return req;
      }
   }
}
