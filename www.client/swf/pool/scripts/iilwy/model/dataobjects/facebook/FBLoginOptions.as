package iilwy.model.dataobjects.facebook
{
   public class FBLoginOptions
   {
       
      
      public var permissions:Array;
      
      public function FBLoginOptions()
      {
         this.permissions = [];
         super();
      }
      
      public function toObject() : Object
      {
         return {"perms":this.permissions.join(",")};
      }
   }
}
