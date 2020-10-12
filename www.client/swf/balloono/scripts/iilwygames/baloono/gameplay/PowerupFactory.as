package iilwygames.baloono.gameplay
{
   import de.polygonal.ds.HashMap;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.player.BombAbility;
   import iilwygames.baloono.gameplay.player.KickAbility;
   import iilwygames.baloono.gameplay.player.MovementAbility;
   import iilwygames.baloono.gameplay.tiles.PowerupTile;
   import flash.external.ExternalInterface;

   public class PowerupFactory
   {


      protected var allPowerupsAsArray:Array;

      protected var allPowerups:HashMap;


      public function PowerupFactory()
      {
         super();

         this.allPowerups = new HashMap(3);
         this.allPowerups.insert("MoreBombs",new PowerupInfo(function():IAbility
         {
            return new BombAbility(-1,1);
         },"moreBombsPowerup",true,false));
         this.allPowerups.insert("SpeedBoost",new PowerupInfo(function():IAbility
         {
            return new MovementAbility(-1,1 / 1000);
         },"speedBoostPowerup",true,false));
         this.allPowerups.insert("ExplosionExtend",new PowerupInfo(function():IAbility
         {
            return new BombAbility(-1,0,1);
         },"explosionExtendPowerup",true,false));
         if(ExternalInterface.call('swf.name','') == 'balloonoboot')
         {
            this.allPowerups.insert("KickBomb",new PowerupInfo(function():IAbility
            {
               return new KickAbility(-1,true);
            },"kickPowerup",true,false));
         }
         if(ExternalInterface.call('swf.name','') == 'balloonoboot')
         {
            this.allPowerupsAsArray = [new PowerupInfo(function():IAbility
            {
               return new BombAbility(-1,1);
            },"moreBombsPowerup",true,false),new PowerupInfo(function():IAbility
            {
               return new MovementAbility(-1,1 / 1000);
            },"speedBoostPowerup",true,false),new PowerupInfo(function():IAbility
            {
               return new BombAbility(-1,0,1);
            },"explosionExtendPowerup",true,false),new PowerupInfo(function():IAbility
            {
               return new KickAbility(-1,true);
            },"kickPowerup",true,false)];
         }
         else
         {
            this.allPowerupsAsArray = [new PowerupInfo(function():IAbility
            {
               return new BombAbility(-1,1);
            },"moreBombsPowerup",true,false),new PowerupInfo(function():IAbility
            {
               return new MovementAbility(-1,1 / 1000);
            },"speedBoostPowerup",true,false),new PowerupInfo(function():IAbility
            {
               return new BombAbility(-1,0,1);
            },"explosionExtendPowerup",true,false)];
         }
      }

      public function get availablePowerupNames() : Array
      {
         return this.allPowerups.getKeySet();
      }

      protected function createTile(param1:PowerupInfo) : PowerupTile
      {
         var _loc2_:PowerupTile = new PowerupTile(param1.abilityFactory());
         _loc2_.setArt(BaloonoGame.instance.assetManager.getGraphicSet(param1.assetName));
         return _loc2_;
      }

      public function createRandomPowerup() : PowerupTile
      {
         var _loc1_:int = BaloonoGame.instance.itemRand.nextIntRange(0,this.allPowerupsAsArray.length - 1);
         return this.createTile(this.allPowerupsAsArray[_loc1_]);
      }

      public function createPowerup(param1:String = null) : PowerupTile
      {
         return !!param1?this.createTile(this.allPowerups.find(param1)):this.createRandomPowerup();
      }
   }
}

class PowerupInfo
{


   public var abilityFactory:Function;

   public var assetName:String;

   public var naturalItem:Boolean;

   public var paidItem:Boolean;

   function PowerupInfo(param1:Function, param2:String, param3:Boolean, param4:Boolean = false)
   {
      super();
      this.abilityFactory = param1;
      this.assetName = param2;
      this.naturalItem = param3;
      this.paidItem = param4;
   }
}
