package iilwy.display.context
{
   import iilwy.factories.context.AbstractUserContextActionFactory;
   import iilwy.factories.context.ProfileContextActionFactory;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.namespaces.omgpop_internal;
   
   use namespace omgpop_internal;
   
   public class ProfileContextMenu extends AbstractUserContextMenu
   {
       
      
      public function ProfileContextMenu()
      {
         super();
      }
      
      public function set profileData(value:ProfileData) : void
      {
         profileData = value;
      }
      
      override protected function createContextActionFactory() : AbstractUserContextActionFactory
      {
         return new ProfileContextActionFactory(_profileData);
      }
   }
}
