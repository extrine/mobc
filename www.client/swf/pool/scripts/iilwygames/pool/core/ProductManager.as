package iilwygames.pool.core
{
   import com.omgpop.game.fbpool.model.enum.shop.CatalogMetaKeys;
   import com.omgpop.game.fbpool.model.enum.shop.CatalogMetaValues;
   import com.omgpop.game.fbpool.model.enum.shop.CategoryKeys;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.powerups.BankLaser;
   import iilwygames.pool.model.gameplay.powerups.GuideLine;
   import iilwygames.pool.model.gameplay.powerups.Powerup;
   import iilwygames.pool.model.gameplay.powerups.ShotPower;
   import iilwygames.pool.model.gameplay.powerups.TimeExtend;
   
   public class ProductManager
   {
       
      
      private var _gnc:GamenetController;
      
      private const SHOP_ID:int = 15;
      
      private var _powers:Vector.<Powerup>;
      
      private const DEBUG:Boolean = true;
      
      public function ProductManager()
      {
         super();
         this._powers = new Vector.<Powerup>();
      }
      
      public function destroy() : void
      {
         var power:Powerup = null;
         this._gnc = null;
         for each(power in this._powers)
         {
            power.destroy();
         }
         this._powers = null;
      }
      
      public function stop() : void
      {
         var power:Powerup = null;
         for each(power in this._powers)
         {
            power.destroy();
         }
         this._powers.length = 0;
      }
      
      public function initialize(gnc:GamenetController) : void
      {
         var productId:String = null;
         var categoryId:String = null;
         var meta:* = undefined;
         var pdata:GamenetPlayerData = null;
         var gameProducts:* = undefined;
         var shopID:int = 0;
         var obj:* = undefined;
         var powerType:String = null;
         var powerup:Powerup = null;
         var timeextend:TimeExtend = null;
         this._gnc = gnc;
         var playerList:Array = gnc.playerList;
         var localPlayerData:GamenetPlayerData = gnc.playerData;
         for(var i:int = 0; i < playerList.length; i++)
         {
            pdata = playerList[i];
            if(pdata.equals(localPlayerData))
            {
               gameProducts = null;
               if(pdata.activeProductData)
               {
                  shopID = gnc.shopId;
                  if(shopID == -1)
                  {
                     shopID = this.SHOP_ID;
                  }
                  gameProducts = pdata.activeProductData[shopID];
               }
               if(gameProducts)
               {
                  for each(obj in gameProducts)
                  {
                     productId = null;
                     categoryId = null;
                     meta = null;
                     if(obj.base && obj.base.meta)
                     {
                        productId = obj.base.id;
                        categoryId = obj.base.category;
                        meta = obj.base.meta;
                     }
                     if(productId == CategoryKeys.POWERS)
                     {
                        powerType = meta[CatalogMetaKeys.KEY];
                        if(powerType == CatalogMetaValues.KEY_POWER_GUIDES)
                        {
                           powerup = new GuideLine();
                        }
                        else if(powerType == CatalogMetaValues.KEY_POWER_SHOT_TIME)
                        {
                           timeextend = new TimeExtend();
                           timeextend.timeIncrements = meta[CatalogMetaKeys.POWER_LEVELS];
                           powerup = timeextend;
                        }
                        else if(powerType == CatalogMetaValues.KEY_POWER_BANK_LASER)
                        {
                           powerup = new BankLaser();
                        }
                        if(powerup)
                        {
                           powerup.power_type = meta[CatalogMetaKeys.POWER_TYPE];
                           this._powers.push(powerup);
                        }
                     }
                  }
               }
               break;
            }
         }
         if(this.DEBUG)
         {
            this.testPowerups();
         }
      }
      
      public function onTurnStart(player:Player) : void
      {
         var pu:Powerup = null;
         for each(pu in this._powers)
         {
            pu.onTurnStart(player);
         }
      }
      
      public function onTurnEnd() : void
      {
         var pu:Powerup = null;
         for each(pu in this._powers)
         {
            pu.onTurnEnd();
         }
      }
      
      public function activatePower(player:Player, key:String) : void
      {
         var pu:Powerup = null;
         for(var i:int = 0; i < this._powers.length; i++)
         {
            pu = this._powers[i];
            if(pu.power_type == key)
            {
               pu.activate(player);
               break;
            }
         }
      }
      
      private function testPowerups() : void
      {
         var pu:Powerup = new ShotPower();
         pu = new BankLaser();
         pu.power_level = 3;
         pu.power_type = CatalogMetaValues.POWER_TYPE_GAME_SPECIFIC;
         this._powers.push(pu);
         pu = new GuideLine();
         pu.power_level = 5;
         pu.power_type = CatalogMetaValues.POWER_TYPE_GAME_SPECIFIC;
         this._powers.push(pu);
      }
   }
}
