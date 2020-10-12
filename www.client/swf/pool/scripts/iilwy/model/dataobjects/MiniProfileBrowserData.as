package iilwy.model.dataobjects
{
   import flash.events.EventDispatcher;
   import iilwy.collections.ArrayCollection;
   import iilwy.gamenet.model.PlayerStatus;
   
   public class MiniProfileBrowserData extends EventDispatcher
   {
       
      
      public var profiles:ArrayCollection;
      
      public var selectedProfileGameStats;
      
      public var selectedProfileStatus:PlayerStatus;
      
      public var selectedProfile:ProfileData;
      
      public var selectedIndex:Number;
      
      public function MiniProfileBrowserData()
      {
         this.profiles = new ArrayCollection();
         super();
      }
      
      public function addProfile(profile:ProfileData) : void
      {
         var exists:Boolean = this.profileIndex(profile) >= 0;
         if(!exists)
         {
            this.profiles.addItem(profile);
         }
      }
      
      public function removeProfile(profile:ProfileData) : void
      {
         var index:int = this.profileIndex(profile);
         if(index >= 0)
         {
            this.profiles.removeItemAt(index);
         }
      }
      
      public function profileIndex(profile:ProfileData) : int
      {
         var item:ProfileData = null;
         var index:int = -1;
         for(var i:int = 0; i < this.profiles.length; i++)
         {
            item = this.profiles.getItemAt(i);
            if(item.id == profile.id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
   }
}
