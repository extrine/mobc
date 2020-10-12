package iilwy.model.dataobjects.avatar
{
   public class AvatarInfo
   {
       
      
      public const GENDER_MALE:String = "avatar.gender.male";
      
      public const GENDER_FEMALE:String = "avatar.gender.female";
      
      public var avatarID:String;
      
      public var avatarName:String;
      
      public var avatarGender:String;
      
      public var filename:String;
      
      public function AvatarInfo()
      {
         super();
      }
      
      public function clone() : AvatarInfo
      {
         var copy:AvatarInfo = new AvatarInfo();
         copy.avatarID = this.avatarID;
         copy.avatarName = this.avatarName;
         copy.avatarGender = this.avatarGender;
         return copy;
      }
      
      public function get imageUrl() : String
      {
         return this.filename;
      }
      
      public function get headImageUrl() : String
      {
         var result:String = null;
         if(this.filename)
         {
            result = this.filename;
            result = this.filename.replace(/(\.\w+$)/,"_head$1");
         }
         return result;
      }
   }
}
