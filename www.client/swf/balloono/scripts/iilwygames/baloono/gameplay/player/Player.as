package iilwygames.baloono.gameplay.player
{
   import com.partlyhuman.types.IDestroyable;
   import com.partlyhuman.util.Assert;
   import de.polygonal.ds.Set;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbilityChangeCommand;
   import iilwygames.baloono.commands.AbstractCommand;
   import iilwygames.baloono.commands.ICommandResponder;
   import iilwygames.baloono.commands.PlayerDieCommand;
   import iilwygames.baloono.commands.PlayerMoveCommand;
   import iilwygames.baloono.commands.PlayerMovePlanCommand;
   import iilwygames.baloono.commands.PlayerSoftDieCommand;
   import iilwygames.baloono.gameplay.IAbility;
   import iilwygames.baloono.gameplay.IBomb;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.ITileItem;
   import iilwygames.baloono.gameplay.map.MapModel;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.AssetEvent;
   import iilwygames.baloono.graphics.GraphicEntity;
   import iilwygames.baloono.graphics.GraphicSet;

   public class Player implements IPlayer, ITileItem, IDestroyable, ICommandResponder
   {

      protected static const ANIMATION_DIE:String = "die";

      protected static const UPDATE_PRIORITY:int = 3;

      protected static const ANIMATION_SOFTDIE:String = "bubble";


      protected var softDeathTimer:Timer;

      public var kickAbility:KickAbility;

      protected var lastDirection:PlayerDirection;

      protected var graphics:GraphicEntity;

      protected var currentMovementPlan:PlayerMovePlanCommand;

      protected var _state:TileState;

      public var playerLabel:PlayerLabel;

      public var _bubbleEnabled:Boolean = true;

      public var addedAbilities:Array;

      protected var activeBombs:Set;

      public var bombAbility:BombAbility;

      protected var _id:uint;

      protected var timeYouStartedMoving:uint;

      public var timeOfDeath:uint;

      protected var facing:PlayerDirection;

      protected var indexInPlan:int;

      private var _sinWaveCounter:uint;

      protected var softDeath:Boolean;

      protected var _playerState:PlayerState;

      public var iilwyPlayerData:GamenetPlayerData;

      public var movementAbility:MovementAbility;

      private var _saveY:Number;

      protected var direction:PlayerDirection;

      public function Player(param1:int, param2:GamenetPlayerData)
      {
         super();
         this._id = param1;
         this.iilwyPlayerData = param2;
         this.initialize();
         if(this._bubbleEnabled)
         {
            this.softDeathTimer = new Timer(2000,1);
            this.softDeathTimer.addEventListener(TimerEvent.TIMER,this.recover);
         }
         this.facing = new PlayerDirection();
         this._sinWaveCounter = 0;
      }

      public function destroy() : void
      {
         if(this.playerLabel)
         {
            this.playerLabel.destroy();
         }
         this.playerLabel = null;
         this.graphics = null;
         if(this.softDeathTimer)
         {
            this.softDeathTimer.stop();
            this.softDeathTimer.reset();
            this.softDeathTimer.removeEventListener(TimerEvent.TIMER,this.recover);
         }
      }

      public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return false;
      }

      protected function reverseCollisions() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.graphics.x;
         _loc2_ = this.graphics.y;
         _loc3_ = Math.round(_loc1_);
         _loc4_ = Math.round(_loc2_);
         var _loc5_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(!_loc5_.isInBounds(_loc3_,_loc4_))
         {
            this.graphics.x = Math.min(Math.max(this.graphics.x,0),_loc5_.width);
            this.graphics.y = Math.min(Math.max(this.graphics.y,0),_loc5_.height);
            this.direction = this.direction.toStoppedVersion();
            this.graphics.playAnimation(this.direction.toAssetName());
         }
         var _loc6_:Boolean = this.checkBoxCollision(_loc1_,_loc2_);
         if(_loc6_)
         {
            if(this.direction.dx == 1)
            {
               this.graphics.x = Math.ceil(_loc1_) - this.direction.dx;
            }
            else if(this.direction.dx == -1)
            {
               this.graphics.x = Math.floor(_loc1_) - this.direction.dx;
            }
            if(this.direction.dy == 1)
            {
               this.graphics.y = Math.ceil(_loc2_) - this.direction.dy;
            }
            else if(this.direction.dy == -1)
            {
               this.graphics.y = Math.floor(_loc2_) - this.direction.dy;
            }
            this.direction = this.direction.toStoppedVersion();
            this.graphics.playAnimation(this.direction.toAssetName());
         }
      }

      public function get jid() : String
      {
         return !!this.iilwyPlayerData?this.iilwyPlayerData.playerJid:null;
      }

      protected function isBoxBlocked(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(param1 < 0 || param2 < 0 || param1 > _loc3_.blocks.width - 1 || param2 > _loc3_.blocks.height - 1)
         {
            return true;
         }
         if(ITileItem(_loc3_.blocks.get(param1,param2)).blocksPlayer(this))
         {
            return true;
         }
         return false;
      }

      protected function onDeathAnimationComplete(param1:AssetEvent) : void
      {
         this._state = TileState.INACTIVE;
         BaloonoGame.instance.mapView.removeTile(this);
         this.destroy();
      }

      protected function initialize() : void
      {
         this._state = TileState.ACTIVE;
         this._playerState = PlayerState.COUNTDOWN;
         this.timeOfDeath = 0;
         this.direction = this.lastDirection = PlayerDirection.FACE_DOWN;
         this.graphics = new GraphicEntity();
         this.activeBombs = new Set();
         this.addedAbilities = [];
         this.validateAbilities();
         this.playerLabel = new PlayerLabel(this.iilwyPlayerData);
         this.softDeath = false;
      }

      public function get state() : TileState
      {
         return this._state;
      }

      public function get id() : int
      {
         return this._id;
      }

      public function setArt(param1:GraphicSet) : void
      {
         if(this.graphics == null)
         {
            trace("graphics is null");
         }
         this.graphics.gset = param1;
         this.graphics.playAnimation(this.direction.toAssetName());
      }

      protected function reallyMove(param1:Number) : void
      {
         if(!this.softDeath)
         {
            this.graphics.x = this.graphics.x + this.direction.dx * this.movementAbility.speed * param1;
            this.graphics.y = this.graphics.y + this.direction.dy * this.movementAbility.speed * param1;
         }
      }

      public function get playerState() : PlayerState
      {
         return this._playerState;
      }

      public function set state(param1:TileState) : void
      {
         this._state = param1;
      }

      public function setPosition(param1:Number, param2:Number) : void
      {
         this.graphics.x = param1;
         this.graphics.y = param2;
      }

      public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         var _loc2_:AbilityChangeCommand = null;
         if(param1 is PlayerDieCommand)
         {
            if(this.state.active)
            {
               trace("hard death");
               if(this.softDeath)
               {
                  this.graphicEntity.y = this._saveY;
                  this.softDeath = false;
               }
               if(this.softDeathTimer && this.softDeathTimer.running)
               {
                  this.softDeathTimer.stop();
                  this.softDeathTimer.reset();
               }
               BaloonoGame.instance.gamenetController.selfNotification(this.iilwyPlayerData.profileName + " was splashed!");
               this.timeOfDeath = param1.occurTime;
               this.graphicEntity.speedup = 1;
               this.graphicEntity.playAnimation(ANIMATION_DIE);
               this.graphicEntity.addEventListener(AssetEvent.SEQUENCE_COMPLETE,this.onDeathAnimationComplete);
               this._state = TileState.INACTIVE_ANIMATING;
               this._playerState = PlayerState.DEAD;
            }
            if(BaloonoGame.instance.DEBUG_VISUAL)
            {
               BaloonoGame.instance.screen.blue.flash();
            }
         }
         else if(param1 is PlayerSoftDieCommand)
         {
            trace("soft death");
            this.softDeath = true;
            this.softDeathTimer.start();
            this._saveY = this.graphicEntity.y;
         }
         else if(param1 is PlayerMovePlanCommand)
         {
            this.assignNewPlan(PlayerMovePlanCommand(param1));
            if(BaloonoGame.instance.DEBUG_VISUAL)
            {
               if(!(this is MyPlayer))
               {
                  BaloonoGame.instance.screen.green.flash();
               }
            }
         }
         else if(param1 is AbilityChangeCommand)
         {
            Assert.assert(!(this is MyPlayer));
            _loc2_ = AbilityChangeCommand(param1);
            this.bombAbility = _loc2_.bombAbility;
            this.movementAbility = _loc2_.movementAbility;
            this.kickAbility = _loc2_.kickAbility;
            this.addedAbilities = null;
         }
         return true;
      }

      public function updatePosition(param1:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:PlayerMoveCommand = null;
         var _loc8_:Number = NaN;
         var _loc2_:Number = BaloonoGame.time;
         var _loc3_:int = 1 + Math.ceil(Math.max(Math.abs(this.direction.dx),Math.abs(this.direction.dy)) * this.movementAbility.speed * param1);
         if(this.state == TileState.ACTIVE)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = 0;
               _loc6_ = false;
               if(this.currentMovementPlan && this.currentMovementPlan.moves.length > 0)
               {
                  while(this.indexInPlan < this.currentMovementPlan.moves.length)
                  {
                     _loc7_ = this.currentMovementPlan.moves[this.indexInPlan];
                     if(_loc7_.occurTime <= _loc2_)
                     {
                        this.lastDirection = this.direction;
                        this.direction = _loc7_.direction;
                        this.graphics.x = _loc7_.occurX;
                        this.graphics.y = _loc7_.occurY;
                        _loc5_ = _loc7_.occurTime;
                        if(this.direction.isMoving && !this.lastDirection.isMoving)
                        {
                           this.timeYouStartedMoving = _loc5_;
                        }
                        this.indexInPlan++;
                        _loc6_ = true;
                        continue;
                     }
                     break;
                  }
               }
               if(!_loc6_)
               {
                  this.reallyMove(Math.max(0,Math.ceil(param1 / _loc3_)));
               }
               if(this.softDeath)
               {
                  this.graphicEntity.playAnimation(ANIMATION_SOFTDIE,0,this.timeYouStartedMoving);
               }
               else
               {
                  this.graphics.playAnimation(this.direction.toAssetName(),0,this.timeYouStartedMoving);
               }
               this.reverseCollisions();
               _loc4_++;
            }
         }
         if(this.softDeath)
         {
            this._sinWaveCounter = this._sinWaveCounter + param1;
            _loc8_ = -0.05 * (Math.sin(this._sinWaveCounter * 0.01) + 1);
            this.graphicEntity.y = this._saveY + _loc8_;
         }
      }

      protected function assignNewPlan(param1:PlayerMovePlanCommand) : void
      {
         var _loc3_:PlayerMoveCommand = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         if(!param1 || param1.empty)
         {
            return;
         }
         var _loc2_:uint = uint(20);
         for each(_loc3_ in param1.moves)
         {
            _loc3_.occurTime = _loc3_.occurTime  // + _loc2_;
         }
         if(this.currentMovementPlan && !this.currentMovementPlan.empty)
         {
            _loc4_ = PlayerMoveCommand(param1.moves[0]).occurTime;
            _loc5_ = this.currentMovementPlan.moves.length - 1;
            while(_loc5_ >= this.indexInPlan)
            {
               _loc3_ = PlayerMoveCommand(this.currentMovementPlan.moves[_loc5_]);
               if(_loc3_.occurTime < _loc4_)
               {
                  param1.moves.unshift(_loc3_);
               }
               _loc5_--;
            }
         }
         this.indexInPlan = 0;
         this.currentMovementPlan = param1;
      }

      protected function checkBoxCollision(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.direction.dy == 0)
         {
            if(this.direction.dx == 1)
            {
               _loc3_ = Math.ceil(param1);
               _loc4_ = Math.round(param2);
            }
            else if(this.direction.dx == -1)
            {
               _loc3_ = Math.floor(param1);
               _loc4_ = Math.round(param2);
            }
            else
            {
               _loc3_ = Math.round(param1);
               _loc4_ = Math.round(param2);
            }
         }
         else if(this.direction.dy == 1)
         {
            _loc3_ = Math.round(param1);
            _loc4_ = Math.ceil(param2);
         }
         else if(this.direction.dy == -1)
         {
            _loc3_ = Math.round(param1);
            _loc4_ = Math.floor(param2);
         }
         else
         {
            _loc3_ = Math.round(param1);
            _loc4_ = Math.round(param2);
         }
         var _loc5_:Boolean = this.isBoxBlocked(_loc3_,_loc4_);
         if(!_loc5_)
         {
         }
         return _loc5_;
      }

      public function validateAbilities() : void
      {
         var _loc1_:IAbility = null;
         this.bombAbility = BombAbility.DEFAULT;
         this.movementAbility = MovementAbility.DEFAULT;
         this.kickAbility = KickAbility.DEFAULT;
         for each(_loc1_ in this.addedAbilities)
         {
            if(_loc1_ is BombAbility)
            {
               this.bombAbility.mergeAbility(_loc1_);
            }
            else if(_loc1_ is MovementAbility)
            {
               this.movementAbility.mergeAbility(_loc1_);
            }
            else if(_loc1_ is KickAbility)
            {
               this.kickAbility.mergeAbility(_loc1_);
            }
         }
      }

      protected function recover(param1:TimerEvent) : void
      {
         trace("soft death recover");
         this._state = TileState.ACTIVE;
         this.softDeathTimer.reset();
         this.softDeathTimer.stop();
         this.softDeath = false;
         this.graphicEntity.y = this._saveY;
      }

      public function registerBomb(param1:IBomb) : void
      {
         this.activeBombs.set(param1);
      }

      public function deregisterBomb(param1:IBomb) : void
      {
         this.activeBombs.remove(param1);
      }

      public function set playerState(param1:PlayerState) : void
      {
         this._playerState = param1;
      }

      protected function isBlocked(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:MapModel = BaloonoGame.instance.mapManager.currentMap;
         if(param1 < 0 || param2 < 0 || param1 > _loc3_.blocks.width - 1 || param2 > _loc3_.blocks.height - 1)
         {
            return true;
         }
         if(ITileItem(_loc3_.blocks.get(param1,param2)).blocksPlayer(this))
         {
            return true;
         }
         if(ITileItem(_loc3_.bombs.get(param1,param2)).blocksPlayer(this))
         {
            return true;
         }
         return false;
      }

      public function get graphicEntity() : GraphicEntity
      {
         return this.graphics;
      }

      public function toString() : String
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            return "[Player " + this._id + "]";
         }
         return null;
      }
   }
}
