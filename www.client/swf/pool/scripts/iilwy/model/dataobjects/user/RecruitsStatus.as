package iilwy.model.dataobjects.user
{
   public class RecruitsStatus
   {
       
      
      public var activatedRecruitCount:int;
      
      public var recruitCount:int;
      
      public var pendingInviteCount:int;
      
      public function RecruitsStatus()
      {
         super();
      }
      
      public function clear() : void
      {
         this.activatedRecruitCount = 0;
         this.recruitCount = 0;
         this.pendingInviteCount = 0;
      }
   }
}
