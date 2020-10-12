package iilwy.ui.partials.badges
{
   import iilwy.model.dataobjects.ProfileData;
   
   public class ProfileBadgeSet extends AbstractBadgeSet
   {
       
      
      protected var _profileData:ProfileData;
      
      public function ProfileBadgeSet()
      {
         super();
      }
      
      public function get profileData() : ProfileData
      {
         return this._profileData;
      }
      
      public function set profileData(value:ProfileData) : void
      {
         this._profileData = value;
         invalidateSize();
         invalidateDisplayList();
      }
   }
}
