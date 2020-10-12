package iilwygames.baloono.gameplay.player
{
   import flash.net.registerClassAlias;
   import iilwygames.baloono.gameplay.IAbility;
   
   public class BombAbility implements IAbility
   {
      
      protected static const REGISTERED = registerClassAlias(TYPE_ALIAS,BombAbility);
      
      protected static const TYPE_ALIAS:String = "iilwygames.baloono.gameplay.player.BombAbility";
       
      
      public var explosionExpansionDelay:uint;
      
      public var _expiresAt:int;
      
      public var bombCount:int;
      
      public var explosionSize:int;
      
      public var explosionMaxSizeHoldTime:uint;
      
      public function BombAbility(param1:int = -1, param2:int = 0, param3:int = 0, param4:uint = 0, param5:uint = 0)
      {
         super();
         this._expiresAt = param1;
         this.bombCount = param2;
         this.explosionSize = param3;
         this.explosionMaxSizeHoldTime = param4;
         this.explosionExpansionDelay = param5;
      }
      
      public static function get DEFAULT() : BombAbility
      {
         return new BombAbility(-1,1,1,400,15);
      }
      
      public function get expiresAt() : int
      {
         return this._expiresAt;
      }
      
      public function mergeAbility(param1:IAbility) : void
      {
         var _loc2_:BombAbility = BombAbility(param1);
         if(_loc2_.bombCount != -1)
         {
            this.bombCount = this.bombCount + _loc2_.bombCount;
         }
         if(_loc2_.explosionSize != -1)
         {
            this.explosionSize = this.explosionSize + _loc2_.explosionSize;
         }
         if(_loc2_.explosionExpansionDelay != -1)
         {
            this.explosionExpansionDelay = this.explosionExpansionDelay + _loc2_.explosionExpansionDelay;
         }
      }
   }
}
