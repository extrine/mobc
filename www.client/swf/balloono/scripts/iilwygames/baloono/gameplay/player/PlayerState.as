package iilwygames.baloono.gameplay.player
{
   public class PlayerState
   {
      
      public static const FROZEN:PlayerState = new PlayerState(16);
      
      public static const COUNTDOWN:PlayerState = new PlayerState(1);
      
      public static const DEAD:PlayerState = new PlayerState(4);
      
      public static const ALIVE:PlayerState = new PlayerState(2);
      
      public static const INVINCIBLE:PlayerState = new PlayerState(8);
       
      
      public var code:uint;
      
      public function PlayerState(param1:uint = 0)
      {
         super();
         this.code = param1;
      }
      
      public function equals(param1:PlayerState) : Boolean
      {
         return this.code == param1.code;
      }
   }
}
