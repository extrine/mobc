package iilwygames.baloono.gameplay.player
{
   import com.partlyhuman.debug.Console;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbilityChangeCommand;
   import iilwygames.baloono.commands.AddBombCommand;
   import iilwygames.baloono.commands.CommandDispatcher;
   import iilwygames.baloono.commands.KickBombCommand;
   import iilwygames.baloono.commands.PickupRemoveCommand;
   import iilwygames.baloono.commands.PlayerDieCommand;
   import iilwygames.baloono.commands.PlayerMoveCommand;
   import iilwygames.baloono.commands.PlayerMovePlanCommand;
   import iilwygames.baloono.commands.PlayerSoftDieCommand;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.gameplay.bomb.Bomb;
   import iilwygames.baloono.gameplay.bomb.Explosion;
   import iilwygames.baloono.gameplay.input.PlayerKeyboardInputMap;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.tiles.BlockTile;
   import iilwygames.baloono.gameplay.tiles.ExplosionTile;
   import iilwygames.baloono.gameplay.tiles.PowerupTile;
   import iilwygames.baloono.managers.KeyboardInputManager;

   public class MyPlayer extends Player
   {

      private static const MAX_SPEEDMULT:int = 10;


      public var myDroppedBombs:int;

      protected const BOMB_DROP_RADIUS:Number = 0.3;

      private var _currSpeedMult:int = 0;

      protected var underfire:Boolean;

      private var directions:Array;

      protected var keymap:PlayerKeyboardInputMap;

      protected var keyboard:KeyboardInputManager;

      private var KICK_ENABLED:Boolean = false;

      protected var taggedByExplosion:Boolean;

      private var tentativeMoves:Array;

      protected const BOMB_ID_MODULO:int = 500;

      public function MyPlayer(param1:int, param2:GamenetPlayerData)
      {
         this.directions = [];
         super(param1,param2);
         this.taggedByExplosion = false;
      }

      public function die() : void
      {
         BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid),true,true);
      }

      protected function assignTimesToMovementPlan(param1:PlayerMovePlanCommand) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:PlayerMoveCommand = null;
         if(!param1 || !param1.moves || param1.moves.length < 1)
         {
            return;
         }
         _loc2_ = BaloonoGame.time;
         _loc3_ = graphics.x;
         _loc4_ = graphics.y;
         var _loc7_:int = 0;
         while(_loc7_ < param1.moves.length)
         {
            _loc6_ = param1.moves[_loc7_];
            _loc5_ = Math.abs(_loc6_.occurX - _loc3_) + Math.abs(_loc6_.occurY - _loc4_);
            _loc2_ = _loc2_ + Math.floor(_loc5_ / (movementAbility.speed * 1));
            _loc6_.occurTime = _loc2_;
            _loc7_++;
         }
      }

      override public function destroy() : void
      {
         super.destroy();
      }

      override protected function initialize() : void
      {
         super.initialize();
         var _loc1_:BaloonoGame = BaloonoGame.instance;
         this.myDroppedBombs = 0;
         this.keymap = PlayerKeyboardInputMap.instance;
         this.keyboard = _loc1_.keyboard;
         this.underfire = false;
         this._currSpeedMult = 0;
      }

      override public function updatePosition(param1:uint) : void
      {
         var _loc10_:Explosion = null;
         var _loc11_:int = 0;
         var _loc12_:ExplosionTile = null;
         var _loc13_:Array = null;
         var _loc14_:Player = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         if(state.inactive)
         {
            return;
         }
         super.updatePosition(param1);
         var _loc2_:int = Math.round(graphics.x);
         var _loc3_:int = Math.round(graphics.y);
         var _loc4_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         var _loc5_:Vector.<Explosion> = BaloonoGame.instance.explosionManager.explosions;
         var _loc6_:int = _loc5_.length;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc10_ = _loc5_[_loc8_];
            if(_loc10_ && _loc10_.tiles)
            {
               _loc7_ = _loc10_.tiles.length;
               _loc11_ = 0;
               while(_loc11_ < _loc7_)
               {
                  _loc12_ = _loc10_.tiles[_loc11_];
                  if(_loc12_ && _loc12_.x == _loc2_ && _loc12_.y == _loc3_)
                  {
                     this.taggedByExplosion = true;
                     break;
                  }
                  _loc11_++;
               }
            }
            if(this.taggedByExplosion)
            {
               break;
            }
            _loc8_++;
         }
         if(this.taggedByExplosion)
         {
            this.taggedByExplosion = false;
            if(_bubbleEnabled && !this.underfire)
            {
               this.underfire = true;
               if(!softDeath)
               {
                  softDeath = true;
                  trace("bomb detect soft");
                  BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerSoftDieCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid),true,true);
               }
               else
               {
                  trace("bomb detect hard");
                  BaloonoGame.instance.gamenetController.selfNotification("You\'ve been splashed!");
                  BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid),true,true);
               }
               return;
            }
            BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid),true,true);
         }
         else
         {
            this.underfire = false;
         }
         if(softDeath)
         {
            _loc13_ = BaloonoGame.instance.playerManager.activePlayers;
            _loc8_ = 0;
            while(_loc8_ < _loc13_.length)
            {
               _loc14_ = _loc13_[_loc8_];
               if(_loc14_ != this && _loc14_.graphicEntity && graphics)
               {
                  _loc15_ = Math.abs(graphics.x - _loc14_.graphicEntity.x);
                  _loc16_ = Math.abs(graphics.y - _loc14_.graphicEntity.y);
                  if(_loc15_ < 1 && _loc16_ < 1)
                  {
                     trace("============ TAGGED!!!!!");
                     BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid),true,true);
                  }
               }
               _loc8_++;
            }
         }
         var _loc9_:PowerupTile = _loc4_.powerups.get(_loc2_,_loc3_) as PowerupTile;
         if(_loc9_)
         {
            BaloonoGame.instance.commandDispatcher.enqueueCommand(new PickupRemoveCommand(BaloonoGame.time,_loc2_,_loc3_),true,true);
            if(!(_loc9_.ability is MovementAbility) || _loc9_.ability is MovementAbility && this._currSpeedMult < MAX_SPEEDMULT)
            {
               addedAbilities.push(_loc9_.ability);
               validateAbilities();
               BaloonoGame.instance.commandDispatcher.enqueueCommand(new AbilityChangeCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid,bombAbility,movementAbility,kickAbility),false,true);
               if(_loc9_.ability is MovementAbility)
               {
                  this._currSpeedMult++;
               }
            }
         }
         if(lastDirection != direction)
         {
            graphics.playAnimation(direction.toAssetName());
         }
         lastDirection = direction;
      }

      public function sendMyAbilities() : void
      {
         BaloonoGame.instance.commandDispatcher.enqueueCommand(new AbilityChangeCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid,bombAbility,movementAbility,kickAbility),false,true);
      }

      public function processInput(param1:CoreGameEvent) : void
      {
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:PlayerMoveCommand = null;
         var _loc12_:PlayerMovePlanCommand = null;
         var _loc13_:int = 0;
         var _loc14_:PlayerDirection = null;
         var _loc15_:MovementPlan = null;
         var _loc16_:MapModel = null;
         var _loc17_:Bomb = null;
         var _loc18_:BlockTile = null;
         var _loc19_:Bomb = null;
         var _loc20_:Bomb = null;
         var _loc21_:BlockTile = null;
         var _loc22_:KickBombCommand = null;
         if(_state.inactive)
         {
            return;
         }
         if(_playerState == PlayerState.COUNTDOWN || _playerState == PlayerState.DEAD || _playerState == PlayerState.FROZEN)
         {
            return;
         }
         var _loc2_:CommandDispatcher = BaloonoGame.instance.commandDispatcher;
         if(softDeath)
         {
            if(direction.isMoving)
            {
               this.tentativeMoves = [this.makeMoveCommand(direction.toStoppedVersion())];
               if(this.tentativeMoves && this.tentativeMoves.length > 0)
               {
                  _loc11_ = PlayerMoveCommand(this.tentativeMoves[0]);
                  if(this.tentativeMoves.length > 0)
                  {
                     _loc12_ = new PlayerMovePlanCommand(this.tentativeMoves);
                     this.assignTimesToMovementPlan(_loc12_);
                     if(!_loc12_.equals(currentMovementPlan))
                     {
                        _loc2_.enqueueCommand(_loc12_,true,true);
                     }
                  }
               }
            }
            return;
         }
         this.tentativeMoves = null;
         var _loc3_:Array = this.keymap.processInput(this.keyboard);
         if(this.directions.length > 0)
         {
            this.directions.splice(0);
         }
         var _loc4_:Boolean = false;
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_ is PlayerDirection)
            {
               this.directions.push(_loc6_);
            }
            else if(_loc6_ == PlayerKeyboardInputMap.DROP_BOMB)
            {
               _loc4_ = true;
            }
         }
         _loc7_ = Math.round(graphics.x);
         _loc8_ = Math.round(graphics.y);
         _loc9_ = graphics.x - _loc7_;
         _loc10_ = graphics.y - _loc8_;
         if(this.directions.length == 0)
         {
            if(direction.isMoving)
            {
               this.tentativeMoves = [this.makeMoveCommand(direction.toStoppedVersion())];
            }
         }
         else if(this.directions.length == 1)
         {
            this.tentativeMoves = this.evaluateDirection(this.directions[0],_loc7_,_loc8_,_loc9_,_loc10_).moves;
         }
         else
         {
            _loc13_ = -1;
            for each(_loc14_ in this.directions)
            {
               _loc15_ = this.evaluateDirection(_loc14_,_loc7_,_loc8_,_loc9_,_loc10_);
               if(_loc15_)
               {
                  if(_loc15_.score > _loc13_)
                  {
                     _loc13_ = _loc15_.score;
                     this.tentativeMoves = _loc15_.moves;
                  }
                  if(_loc13_ == MovementPlan.BEST_SCORE)
                  {
                     break;
                  }
               }
            }
         }
         if(this.KICK_ENABLED)
         {
            _loc16_ = BaloonoGame.instance.mapManager.currentMap;
            _loc17_ = _loc16_.bombs.get(_loc7_,_loc8_) as Bomb;
            _loc18_ = _loc16_.blocks.get(_loc7_,_loc8_) as BlockTile;
            _loc19_ = _loc16_.bombs.get(_loc7_ + direction.getFacingDirection().dx,_loc8_ + direction.getFacingDirection().dy) as Bomb;
            if(kickAbility.canKick && _loc19_ is Bomb && !_loc19_.flying)
            {
               _loc20_ = _loc16_.bombs.get(_loc19_.graphicEntity.x + direction.getFacingDirection().dx,_loc19_.graphicEntity.y + direction.getFacingDirection().dy) as Bomb;
               _loc21_ = _loc16_.blocks.get(_loc19_.graphicEntity.x + direction.getFacingDirection().dx,_loc19_.graphicEntity.y + direction.getFacingDirection().dy) as BlockTile;
               trace("bomb: " + _loc20_ + " box: " + _loc21_);
               if(!_loc20_ && !_loc21_)
               {
                  _loc22_ = new KickBombCommand(_loc19_.id,true,direction.getFacingDirection().dx,direction.getFacingDirection().dy);
                  BaloonoGame.instance.commandDispatcher.enqueueCommand(_loc22_,true,true);
               }
            }
         }
         if(_loc4_ && activeBombs.size < bombAbility.bombCount && (_loc18_ == null || _loc18_.state.inactive) && (_loc17_ == null || _loc17_.state.inactive))
         {
            if(!direction.isMoving || Math.abs(_loc9_) < this.BOMB_DROP_RADIUS && Math.abs(_loc10_) < this.BOMB_DROP_RADIUS)
            {
               this.dropBomb(_loc7_,_loc8_);
            }
         }
         if(this.tentativeMoves && this.tentativeMoves.length > 0)
         {
            _loc11_ = PlayerMoveCommand(this.tentativeMoves[0]);
            if(this.tentativeMoves.length > 0)
            {
               _loc12_ = new PlayerMovePlanCommand(this.tentativeMoves);
               this.assignTimesToMovementPlan(_loc12_);
               if(!_loc12_.equals(currentMovementPlan))
               {
                  _loc2_.enqueueCommand(_loc12_,true,true);
                  if(BaloonoGame.instance.DEBUG_VISUAL)
                  {
                     BaloonoGame.instance.screen.red.flash();
                  }
               }
            }
         }
      }

      protected function evaluateDirection(param1:PlayerDirection, param2:int, param3:int, param4:Number, param5:Number) : MovementPlan
      {
         var otherAxis:Directional = null;
         var offsetsInOtherDirections:Directional = null;
         var slideDirection:PlayerDirection = null;
         var requestedDirection:PlayerDirection = param1;
         var roundx:int = param2;
         var roundy:int = param3;
         var offsetx:Number = param4;
         var offsety:Number = param5;
         var dirx:int = requestedDirection.dx;
         var diry:int = requestedDirection.dy;
         var offsets:Directional = new Directional(offsetx < 0,offsetx > 0,offsety < 0,offsety > 0);
         if(!isBlocked(roundx + dirx,roundy + diry))
         {
            otherAxis = Directional.generateOrthogonalAxis(requestedDirection);
            offsetsInOtherDirections = offsets.and(otherAxis);
            if(offsetsInOtherDirections.areAny() && isBlocked(roundx + offsetsInOtherDirections.dx + requestedDirection.dx,roundy + offsetsInOtherDirections.dy + requestedDirection.dy))
            {
               slideDirection = offsetsInOtherDirections.toDirection().toOpposite();
               return new MovementPlan([this.makeMoveCommand(requestedDirection,roundx,roundy)],1);
            }
            return new MovementPlan([this.makeMoveCommand(requestedDirection)],10);
         }
         if(!offsets.areAny())
         {
            return new MovementPlan([this.makeMoveCommand(requestedDirection.toStoppedVersion())],1);
         }
         if(offsets.getAtOppositeOfDirection(requestedDirection))
         {
            return new MovementPlan([this.makeMoveCommand(requestedDirection),this.makeMoveCommand(requestedDirection.toStoppedVersion(),requestedDirection.dx == 0?Number(graphics.x):Number(roundx),requestedDirection.dy == 0?Number(graphics.y):Number(roundy))],9);
         }
         if(offsets.getAtDirection(requestedDirection))
         {
            return new MovementPlan([this.makeMoveCommand(requestedDirection.toStoppedVersion(),roundx,roundy)],0);
         }
         var sign:Function = function(param1:Number):int
         {
            return param1 < 0?-1:param1 > 0?1:0;
         };
         var snapx:int = roundx + sign(offsetx);
         var snapy:int = roundy + sign(offsety);
         if(isBlocked(snapx + dirx,snapy + diry))
         {
            return new MovementPlan([this.makeMoveCommand(requestedDirection.toStoppedVersion())],1);
         }
         return new MovementPlan([this.makeMoveCommand(PlayerDirection.fromVector(snapx - roundx,snapy - roundy)),this.makeMoveCommand(requestedDirection,snapx,snapy)],8);
      }

      protected function makeMoveCommand(param1:PlayerDirection, param2:Number = NaN, param3:Number = NaN) : PlayerMoveCommand
      {
         if(isNaN(param2))
         {
            param2 = graphics.x;
         }
         if(isNaN(param3))
         {
            param3 = graphics.y;
         }
         return new PlayerMoveCommand(BaloonoGame.time,id,iilwyPlayerData.playerJid,param1,param2,param3);
      }

      override protected function assignNewPlan(param1:PlayerMovePlanCommand) : void
      {
         indexInPlan = 0;
         currentMovementPlan = param1;
      }

      protected function dropBomb(param1:int, param2:int) : void
      {
         var _loc3_:Object = BaloonoGame.instance.mapManager.currentMap.bombs.get(param1,param2);
         if(_loc3_ is Bomb && Bomb(_loc3_).state.active)
         {
            Console.warn("You tried to drop a bomb where there was one. That\'s bad.");
            return;
         }
         var _loc4_:int = this._id * this.BOMB_ID_MODULO + ++this.myDroppedBombs % this.BOMB_ID_MODULO;
         var _loc5_:uint = BaloonoGame.time + 3000;
         trace("DROPPING BOMB",_loc4_,"AT TIME",BaloonoGame.time,"POS",param1,param2);
         var _loc6_:AddBombCommand = new AddBombCommand(_loc4_,_loc5_,_id,iilwyPlayerData.playerJid,bombAbility,param1,param2);
         BaloonoGame.instance.commandDispatcher.enqueueCommand(_loc6_,true,true);
      }

      override public function toString() : String
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            return "[MyPlayer]";
         }
         return null;
      }
   }
}

class MovementPlan
{

   public static const BEST_SCORE:int = 10;


   public var score:int;

   public var moves:Array;

   function MovementPlan(param1:Array, param2:int)
   {
      super();
      this.moves = param1;
      this.score = param2;
   }
}

import com.partlyhuman.debug.Console;
import com.partlyhuman.util.Assert;
import iilwygames.baloono.BaloonoGame;
import iilwygames.baloono.gameplay.player.PlayerDirection;

class Directional
{


   public var down:Boolean;

   public var left:Boolean;

   public var up:Boolean;

   public var right:Boolean;

   function Directional(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
   {
      super();
      this.left = param1;
      this.right = param2;
      this.up = param3;
      this.down = param4;
   }

   public static function generateThisAxis(param1:PlayerDirection) : Directional
   {
      switch(param1)
      {
         case PlayerDirection.GO_LEFT:
         case PlayerDirection.GO_RIGHT:
            return new Directional(true,true,false,false);
         case PlayerDirection.GO_UP:
         case PlayerDirection.GO_DOWN:
            return new Directional(false,false,true,true);
         default:
            return null;
      }
   }

   public static function generateOrthogonalAxis(param1:PlayerDirection) : Directional
   {
      switch(param1)
      {
         case PlayerDirection.GO_LEFT:
         case PlayerDirection.GO_RIGHT:
            return new Directional(false,false,true,true);
         case PlayerDirection.GO_UP:
         case PlayerDirection.GO_DOWN:
            return new Directional(true,true,false,false);
         default:
            return null;
      }
   }

   public function or(param1:Directional) : Directional
   {
      return new Directional(param1.left || this.left,param1.right || this.right,param1.up || this.up,param1.down || this.down);
   }

   public function getAtDirection(param1:PlayerDirection) : Boolean
   {
      switch(param1)
      {
         case PlayerDirection.GO_LEFT:
            return this.left;
         case PlayerDirection.GO_RIGHT:
            return this.right;
         case PlayerDirection.GO_UP:
            return this.up;
         case PlayerDirection.GO_DOWN:
            return this.down;
         default:
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("invalid direction!");
            }
            return false;
      }
   }

   public function setAtDirection(param1:PlayerDirection, param2:Boolean) : void
   {
      switch(param1)
      {
         case PlayerDirection.GO_LEFT:
            this.left = param2;
            break;
         case PlayerDirection.GO_RIGHT:
            this.right = param2;
            break;
         case PlayerDirection.GO_UP:
            this.up = param2;
            break;
         case PlayerDirection.GO_DOWN:
            this.down = param2;
      }
   }

   public function toDirection() : PlayerDirection
   {
      Assert.assert(this.howMany() == 1);
      if(this.left)
      {
         return PlayerDirection.GO_LEFT;
      }
      if(this.right)
      {
         return PlayerDirection.GO_RIGHT;
      }
      if(this.up)
      {
         return PlayerDirection.GO_UP;
      }
      if(this.down)
      {
         return PlayerDirection.GO_DOWN;
      }
      Assert.fail();
      return null;
   }

   public function clone() : Directional
   {
      return new Directional(this.left,this.right,this.up,this.down);
   }

   public function areAll() : Boolean
   {
      return this.left && this.right && this.up && this.down;
   }

   public function howMany() : int
   {
      return 0 + this.left + this.right + this.up + this.down;
   }

   public function getAtOppositeOfDirection(param1:PlayerDirection) : Boolean
   {
      switch(param1)
      {
         case PlayerDirection.GO_LEFT:
            return this.right;
         case PlayerDirection.GO_RIGHT:
            return this.left;
         case PlayerDirection.GO_UP:
            return this.down;
         case PlayerDirection.GO_DOWN:
            return this.up;
         default:
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("invalid direction !");
            }
            return false;
      }
   }

   public function get dx() : int
   {
      return !!this.left?-1:!!this.right?1:0;
   }

   public function get dy() : int
   {
      return !!this.up?-1:!!this.down?1:0;
   }

   public function and(param1:Directional) : Directional
   {
      return new Directional(param1.left && this.left,param1.right && this.right,param1.up && this.up,param1.down && this.down);
   }

   public function toString() : String
   {
      return "" + "    " + (!!this.up?"X":"^") + "    " + "\n" + "  " + (!!this.left?"X":"<") + "   " + (!!this.right?"X":">") + "\n" + "    " + (!!this.down?"X":"v") + "    " + "\n";
   }

   public function toOppositeDirection() : PlayerDirection
   {
      Assert.assert(this.howMany() == 1);
      if(this.left)
      {
         return PlayerDirection.GO_RIGHT;
      }
      if(this.right)
      {
         return PlayerDirection.GO_LEFT;
      }
      if(this.up)
      {
         return PlayerDirection.GO_DOWN;
      }
      if(this.down)
      {
         return PlayerDirection.GO_UP;
      }
      Assert.fail();
      return null;
   }

   public function areAny() : Boolean
   {
      return this.left || this.right || this.up || this.down;
   }
}
