package iilwygames.baloono.gameplay.player
{
   import flash.net.registerClassAlias;
   import iilwygames.baloono.gameplay.IAbility;
   
   public class MovementAbility implements IAbility
   {
      
      protected static const REGISTERED = registerClassAlias(TYPE_ALIAS,MovementAbility);
      
      protected static const TYPE_ALIAS:String = "iilwygames.baloono.gameplay.player.MovementAbility";
       
      
      public var speed:Number;
      
      protected var _expiresAt:int;
      
      public function MovementAbility(param1:int = -1, param2:Number = 0)
      {
         super();
         this._expiresAt = param1;
         this.speed = param2;
      }
      
      public static function get DEFAULT() : MovementAbility
      {
         return new MovementAbility(-1,4 / 1000);
      }
      
      public static function consume(param1:Object) : MovementAbility
      {
         return new MovementAbility(param1.expiresAt,param1.speed);
      }
      
      public function mergeAbility(param1:IAbility) : void
      {
         this.speed = this.speed + MovementAbility(param1).speed;
      }
      
      public function export() : Object
      {
         return {
            "type":TYPE_ALIAS,
            "expiresAt":this.expiresAt,
            "speed":this.speed
         };
      }
      
      public function set expiresAt(param1:int) : void
      {
         this._expiresAt = param1;
      }
      
      public function get expiresAt() : int
      {
         return this._expiresAt;
      }
   }
}
