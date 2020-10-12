package iilwy.model.dataobjects.user
{
   public class LoginStreak
   {
       
      
      public var streak:int;
      
      public var coins:int;
      
      public function LoginStreak()
      {
         super();
         this.streak = -1;
         this.coins = -1;
      }
      
      public function clear() : void
      {
         this.streak = -1;
         this.coins = -1;
      }
   }
}
