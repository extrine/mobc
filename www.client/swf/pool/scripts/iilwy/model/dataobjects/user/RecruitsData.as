package iilwy.model.dataobjects.user
{
   import iilwy.collections.ArrayCollection;
   import iilwy.events.CollectionEvent;
   import iilwy.model.dataobjects.ProfileData;
   
   public class RecruitsData
   {
       
      
      public var status:RecruitsStatus;
      
      public var recruits:ArrayCollection;
      
      public var achievedRecruits:ArrayCollection;
      
      public var pendingInvites:ArrayCollection;
      
      public function RecruitsData()
      {
         super();
         this.status = new RecruitsStatus();
         this.recruits = new ArrayCollection();
         this.recruits.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRecruitsCollectionChange);
         this.achievedRecruits = new ArrayCollection();
         this.pendingInvites = new ArrayCollection();
         this.pendingInvites.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPendingInvitesCollectionChange);
      }
      
      public function clear() : void
      {
         this.status.clear();
         this.recruits.removeAll();
         this.achievedRecruits.removeAll();
         this.pendingInvites.removeAll();
      }
      
      private function onRecruitsCollectionChange(event:CollectionEvent) : void
      {
         var recruit:ProfileData = null;
         var achieved:Array = [];
         for each(recruit in this.recruits.source)
         {
            if(recruit.experience.level >= 10)
            {
               achieved.push(recruit);
            }
         }
         this.achievedRecruits.source = achieved;
      }
      
      private function onPendingInvitesCollectionChange(event:CollectionEvent) : void
      {
      }
   }
}
