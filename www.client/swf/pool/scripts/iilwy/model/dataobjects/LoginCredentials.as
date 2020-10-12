package iilwy.model.dataobjects
{
   public class LoginCredentials
   {
       
      
      public var username:String;
      
      public var password:String;
      
      public var remember:Boolean;
      
      public var anonymousId:Number;
      
      public function LoginCredentials(username:String = null, password:String = null)
      {
         super();
         this.username = username;
         this.password = password;
      }
   }
}
