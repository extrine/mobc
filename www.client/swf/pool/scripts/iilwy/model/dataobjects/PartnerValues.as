package iilwy.model.dataobjects
{
   public class PartnerValues
   {
       
      
      public var origin:String;
      
      public var token:String;
      
      public var anonymousID:String;
      
      public function PartnerValues(origin:String, token:String, anonymousID:String)
      {
         super();
         this.origin = origin;
         this.token = token;
         this.anonymousID = anonymousID;
      }
   }
}
