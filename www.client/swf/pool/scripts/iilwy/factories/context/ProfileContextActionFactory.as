package iilwy.factories.context
{
   import iilwy.model.dataobjects.ProfileData;
   
   public class ProfileContextActionFactory extends AbstractUserContextActionFactory
   {
       
      
      public function ProfileContextActionFactory(profileData:ProfileData)
      {
         super(profileData);
      }
   }
}
