package iilwygames.baloono.gameplay.player
{
   import flash.net.registerClassAlias;
   import iilwygames.baloono.gameplay.IAbility;
   
   public class KickAbility implements IAbility
   {
      
      protected static const REGISTERED = registerClassAlias(TYPE_ALIAS,KickAbility);
      
      protected static const TYPE_ALIAS:String = "iilwygames.baloono.gameplay.player.KickAbility";
       
      
      public var canKick:Boolean = false;
      
      public var _expiresAt:int;
      
      public function KickAbility(param1:int = -1, param2:Boolean = false)
      {
         super();
         this._expiresAt = param1;
         this.canKick = param2;
      }
      
      public static function get DEFAULT() : KickAbility
      {
         return new KickAbility(-1);
      }
      
      public function mergeAbility(param1:IAbility) : void
      {
         var _loc2_:KickAbility = KickAbility(param1);
         if(_loc2_.canKick)
         {
            this.canKick = true;
         }
      }
      
      public function get expiresAt() : int
      {
         return this._expiresAt;
      }
   }
}
