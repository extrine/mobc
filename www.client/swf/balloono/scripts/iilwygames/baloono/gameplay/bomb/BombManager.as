package iilwygames.baloono.gameplay.bomb
{
   import com.partlyhuman.util.Assert;
   import de.polygonal.math.PM_PRNG;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbstractCommand;
   import iilwygames.baloono.commands.AddBombCommand;
   import iilwygames.baloono.commands.ICommandResponder;
   import iilwygames.baloono.commands.KickBombCommand;
   import iilwygames.baloono.embedded.SoundAssets;
   import iilwygames.baloono.gameplay.map.MapManager;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.player.BombAbility;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.NullTile;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.GraphicEntity;
   
   public class BombManager implements ICommandResponder
   {
       
      
      private var _suddenDeathMode:Boolean;
      
      public var bombs:Vector.<Bomb>;
      
      private var bombDropTimer:int;
      
      private var _suddenDeathStartInitTime:uint;
      
      private var dropTime:int;
      
      private var myDroppedBombs:int;
      
      public function BombManager()
      {
         super();
         this._suddenDeathMode = false;
         this._suddenDeathStartInitTime = 0;
         this.myDroppedBombs = 0;
         this.bombDropTimer = 0;
         this.dropTime = 2000;
         this.bombs = new Vector.<Bomb>();
      }
      
      public function startBombExplosion(param1:Bomb, param2:uint) : void
      {
         BaloonoGame.instance.soundAssets.playSound(SoundAssets.EXPLODE);
         var _loc3_:Explosion = param1.explosionEgg;
         var _loc4_:GraphicEntity = param1.graphicEntity;
         _loc3_.startExplosion(param2,int(_loc4_.x),int(_loc4_.y));
      }
      
      public function clear() : void
      {
         var _loc1_:Bomb = null;
         var _loc2_:int = 0;
         this._suddenDeathMode = false;
         this.myDroppedBombs = 0;
         this._suddenDeathStartInitTime = 0;
         this.bombDropTimer = 0;
         this.dropTime = 2000;
         if(this.bombs)
         {
            _loc2_ = 0;
            while(_loc2_ < this.bombs.length)
            {
               _loc1_ = this.bombs[_loc2_];
               if(_loc1_.owner)
               {
                  _loc1_.owner.deregisterBomb(_loc1_);
               }
               _loc1_.destroy();
               _loc2_++;
            }
            this.bombs.splice(0,this.bombs.length);
         }
      }
      
      public function removeBomb(param1:Bomb) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.bombs.length)
         {
            if(this.bombs[_loc2_] == param1)
            {
               this.bombs.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function updateSuddenDeath(param1:uint) : void
      {
         var _loc2_:MapManager = null;
         var _loc3_:PM_PRNG = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:BlockTile = null;
         var _loc7_:Bomb = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:BombAbility = null;
         var _loc11_:AddBombCommand = null;
         if(BaloonoGame.time - this._suddenDeathStartInitTime >= 5000)
         {
            if(this.bombDropTimer)
            {
               this.bombDropTimer = this.bombDropTimer - param1;
               if(this.bombDropTimer <= 0)
               {
                  this.bombDropTimer = 0;
               }
            }
            if(this.bombDropTimer == 0)
            {
               this.bombDropTimer = this.dropTime;
               this.dropTime = this.dropTime * 0.9;
               if(this.dropTime < 400)
               {
                  this.dropTime = 400;
               }
               _loc2_ = BaloonoGame.instance.mapManager;
               _loc3_ = BaloonoGame.instance.bombDropRand;
               trace("bomb drops!");
               _loc4_ = Math.round(_loc2_.currentMap.width * _loc3_.nextDouble());
               _loc5_ = Math.round(_loc2_.currentMap.height * _loc3_.nextDouble());
               _loc6_ = _loc2_.currentMap.blocks.get(_loc4_,_loc5_) as BlockTile;
               _loc7_ = _loc2_.currentMap.bombs.get(_loc4_,_loc5_) as Bomb;
               while(_loc6_ || _loc7_)
               {
                  _loc4_ = Math.round(_loc2_.currentMap.width * _loc3_.nextDouble());
                  _loc5_ = Math.round(_loc2_.currentMap.height * _loc3_.nextDouble());
                  _loc6_ = _loc2_.currentMap.blocks.get(_loc4_,_loc5_) as BlockTile;
                  _loc7_ = _loc2_.currentMap.bombs.get(_loc4_,_loc5_) as Bomb;
               }
               _loc8_ = 10 * 500 + ++this.myDroppedBombs % 500;
               _loc9_ = BaloonoGame.time + 3000;
               _loc10_ = new BombAbility(0,999,30,400,15);
               _loc11_ = new AddBombCommand(_loc8_,_loc9_,0,null,_loc10_,_loc4_,_loc5_);
               BaloonoGame.instance.commandDispatcher.enqueueCommand(_loc11_,true,true);
            }
         }
      }
      
      public function updateBombs(param1:uint) : void
      {
         var _loc2_:Bomb = null;
         var _loc3_:int = 0;
         if(this.bombs)
         {
            _loc3_ = 0;
            while(_loc3_ < this.bombs.length)
            {
               _loc2_ = this.bombs[_loc3_];
               if(_loc2_ && _loc2_.update(param1))
               {
                  _loc3_++;
               }
            }
         }
         if(this._suddenDeathMode)
         {
            this.updateSuddenDeath(param1);
         }
      }
      
      public function registerBomb(param1:Bomb) : void
      {
         this.bombs[this.bombs.length] = param1;
         if(param1.owner)
         {
            param1.owner.registerBomb(param1);
         }
      }
      
      public function removeExplodedBombAnimation(param1:Bomb) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1 && param1.graphicEntity)
         {
            _loc2_ = BaloonoGame.instance.mapManager.currentMap.bombs.getArray();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_] is Bomb && Bomb(_loc2_[_loc3_]).id == param1.id)
               {
                  _loc2_[_loc3_] = NullTile.NULL_TILE;
               }
               _loc3_++;
            }
            BaloonoGame.instance.mapView.removeTile(param1);
         }
         else
         {
            trace("REMOVE EXPLODED ON EMPTY TILE");
         }
      }
      
      public function getById(param1:int) : Bomb
      {
         var _loc2_:Bomb = null;
         var _loc3_:int = 0;
         var _loc4_:int = this.bombs.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.bombs[_loc3_];
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function initSuddenDeath() : void
      {
         if(BaloonoGame.instance.gamenetController.playerRole == PlayerRoles.HOST)
         {
            this._suddenDeathMode = true;
            this._suddenDeathStartInitTime = BaloonoGame.time;
            this.bombDropTimer = this.dropTime;
         }
      }
      
      public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         var _loc3_:Bomb = null;
         var _loc4_:AddBombCommand = null;
         var _loc5_:Object = null;
         var _loc6_:Player = null;
         var _loc7_:KickBombCommand = null;
         var _loc8_:Bomb = null;
         var _loc2_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(param1 is AddBombCommand)
         {
            BaloonoGame.instance.soundAssets.playSound(SoundAssets.DROP);
            _loc4_ = AddBombCommand(param1);
            trace("STARTING BOMB ADD FROM COMMAND FOR BOMBID",_loc4_.id);
            _loc5_ = _loc2_.bombs.get(_loc4_.x,_loc4_.y);
            if(_loc5_ is Bomb)
            {
               if(Bomb(_loc5_).state == TileState.ACTIVE)
               {
                  trace("bomb that\'s there now:",Bomb(_loc5_).id,"bomb being dropped:",_loc4_.id);
                  if(BaloonoGame.instance.DEBUG_ERRORS)
                  {
                     Assert.fail("OH CRAP there was an active bomb there already!");
                  }
                  return true;
               }
               this.removeExplodedBombAnimation(Bomb(_loc5_));
            }
            _loc6_ = BaloonoGame.instance.playerManager.getPlayerByJid(_loc4_.ownerPlayerJid);
            _loc3_ = new Bomb(_loc4_.id,_loc4_.occurTime,_loc4_.detonateTime,_loc6_,_loc4_.bombAbility);
            _loc2_.bombs.set(_loc4_.x,_loc4_.y,_loc3_);
            _loc3_.setPosition(_loc4_.x,_loc4_.y);
            BaloonoGame.instance.mapView.addBomb(_loc3_);
         }
         else if(param1 is KickBombCommand)
         {
            _loc7_ = KickBombCommand(param1);
            _loc8_ = this.getById(_loc7_.bombID);
            if(_loc8_)
            {
               _loc8_.flying = _loc7_.kicked;
               _loc8_.dx = _loc7_.dx;
               _loc8_.dy = _loc7_.dy;
            }
         }
         return true;
      }
      
      public function deregisterBomb(param1:Bomb) : void
      {
         if(param1.owner)
         {
            param1.owner.deregisterBomb(param1);
         }
      }
   }
}
