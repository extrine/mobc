package iilwygames.baloono.commands
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.types.IDestroyable;
   import flash.net.ObjectEncoding;
   import flash.utils.ByteArray;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.core.IGameStoppable;
   import iilwygames.baloono.gameplay.player.BombAbility;
   import iilwygames.baloono.gameplay.player.MovementAbility;
   import iilwygames.baloono.gameplay.player.PlayerDirection;
   import iilwygames.baloono.net.Serializer;
   import flash.external.ExternalInterface;

   public class CommandDispatcher implements IGameStoppable, IDestroyable
   {

      public static const APPEND_KEY:Boolean = false;

      public static const USENEWSERIALIZER:Boolean = true;


      protected var internalCommandQueue:Vector.<AbstractCommand>;

      protected var gamenetController:GamenetController;

      protected var upcomingCommands:Vector.<AbstractCommand>;

      protected var outgoingCommandQueue:Vector.<AbstractCommand>;

      public function CommandDispatcher()
      {
         super();
         ByteArray.defaultObjectEncoding = ObjectEncoding.AMF3;
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_START,this.gameStart);
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_STOP,this.gameStop);
         this.upcomingCommands = new Vector.<AbstractCommand>();
         this.internalCommandQueue = new Vector.<AbstractCommand>();
         this.outgoingCommandQueue = new Vector.<AbstractCommand>();
           ExternalInterface.addCallback("pnmJS",this.onReceiveGameAction2);
         ExternalInterface.addCallback("uL",this.uL);
      }
      public function uL(some:*) : void
      {
         var _loc2_:* = BaloonoGame.instance.playerManager.getPlayerByJid(some.u);
         this.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,_loc2_.id,some.u),true,false);
      }
      protected function routeCommand(param1:AbstractCommand) : Boolean
      {
         var _loc3_:ICommandResponder = null;
         var _loc2_:BaloonoGame = BaloonoGame.instance;
         if(param1 is PlayerCommand)
         {
            _loc3_ = _loc2_.playerManager;
         }
         else if(param1 is AddBombCommand)
         {
            _loc3_ = _loc2_.bombManager;
         }
         else if(param1 is KickBombCommand)
         {
            _loc3_ = _loc2_.bombManager;
         }
         else if(param1 is TileChangeCommand)
         {
            _loc3_ = _loc2_.mapManager;
         }
         else
         {
            _loc3_ = BaloonoGame.instance;
         }
         var _loc4_:Boolean = _loc3_.respondToCommand(param1);
         if(!_loc4_)
         {
            if(BaloonoGame.time - param1.occurTime > 10000)
            {
               _loc4_ = true;
               trace("command has been removed due to inactivity");
            }
         }
         if(_loc4_)
         {
            param1.destroy();
         }
         return _loc4_;
      }

      public function sendImmediate(param1:AbstractCommand) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(USENEWSERIALIZER)
         {
            _loc3_ = this.createMessageFromCommand(param1,false);
            if(_loc3_)
            {
               // this.gamenetController.sendGameAction(_loc3_);
                ExternalInterface.call("emit",{
                  "id":"blc",
                  "f":"snm",
                  "d":[_loc3_]
               });
            }
            else
            {
               trace("invalid command");
            }
         }
         else
         {
            _loc4_ = Serializer.export(param1);
            this.gamenetController.sendGameAction(_loc4_);
         }
      }

      public function enqueueCommand(param1:AbstractCommand, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(param2)
         {
            this.internalCommandQueue.push(param1);
         }
         if(param3)
         {
            this.outgoingCommandQueue.push(param1);
         }
         if(!param2 && !param3)
         {
            this.upcomingCommands.push(param1);
         }
      }

      protected function onReceiveGameAction2(param1:*) : void
      {
         for(var id in param1){
            this.onReceiveGameAction(param1[id])
         }
      }
      protected function onReceiveGameAction(param1:*) : void
      {
         var cmd:AbstractCommand = null;
         var name:String = null;
         var convertcommand:SendVersionCommand = null;
         var event:* = {
               "data":param1,
               "sender":param1.sender
            };
         if(!BaloonoGame.instance.playerManager.isSpectator && BaloonoGame.instance.playerManager.me.jid == event.sender)
         {
            return;
         }
        /* try
         {*/
            if(USENEWSERIALIZER)
            {
               cmd = this.createCommandFromMessage(event);
               if(cmd)
               {
                  if(cmd is MapSendCommand)
                  {
                     if(this.gamenetController.playerRole == PlayerRoles.SPECTATOR)
                     {
                        this.routeCommand(cmd);
                     }
                  }
                  else if(cmd is SendVersionCommand)
                  {
                     name = BaloonoGame.instance.playerManager.getPlayerByJid(event.sender).iilwyPlayerData.profileName;
                     convertcommand = cmd as SendVersionCommand;
                     trace("========== " + name + " has version: " + convertcommand.version);
                  }
                  else
                  {
                     this.upcomingCommands.push(cmd);
                  }
               }
            }
            else
            {
               cmd = AbstractCommand(Serializer.consume(event.data));
               if(cmd is MapSendCommand)
               {
                  if(this.gamenetController.playerRole == PlayerRoles.SPECTATOR)
                  {
                     this.routeCommand(cmd);
                  }
               }
               else if(cmd is SendVersionCommand)
               {
                  name = BaloonoGame.instance.playerManager.getPlayerByJid(event.sender).iilwyPlayerData.profileName;
                  convertcommand = cmd as SendVersionCommand;
                  trace("========== " + name + " has version: " + convertcommand.version);
               }
               else
               {
                  this.upcomingCommands.push(cmd);
               }
            }
            return;
        /* }
         catch(error:Error)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.dumpStackTrace();
            }
            return;
         }*/
      }

      public function gameStart(param1:CoreGameEvent) : void
      {
         this.gamenetController = param1.gamenetController;
         this.gamenetController.addEventListener(GamenetEvent.GAME_ACTION,this.onReceiveGameAction);
      }

      public function gameStop(param1:CoreGameEvent) : void
      {
         if(this.gamenetController)
         {
            this.gamenetController.removeEventListener(GamenetEvent.GAME_ACTION,this.onReceiveGameAction);
         }
         if(this.internalCommandQueue)
         {
            this.internalCommandQueue.splice(0,this.internalCommandQueue.length);
         }
         if(this.outgoingCommandQueue)
         {
            this.outgoingCommandQueue.splice(0,this.outgoingCommandQueue.length);
         }
         if(this.upcomingCommands)
         {
            this.upcomingCommands.splice(0,this.upcomingCommands.length);
         }
      }

      private function createCommandFromMessage(param1:*) : AbstractCommand
      {
         var _loc2_:Array = null;
         var _loc3_:PlayerMoveCommand = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PlayerMovePlanCommand = null;
         var _loc7_:PlayerDieCommand = null;
         var _loc8_:AbilityChangeCommand = null;
         var _loc9_:AddBombCommand = null;
         var _loc10_:KickBombCommand = null;
         var _loc11_:BlockDamageCommand = null;
         var _loc12_:PickupRemoveCommand = null;
         var _loc13_:GameOverCommand = null;
         var _loc14_:BackToLobbyCommand = null;
         var _loc15_:GameBeginCommand = null;
         var _loc16_:PlayerSoftDieCommand = null;
         var _loc17_:SendVersionCommand = null;
         var _loc18_:RequestVersionCommand = null;
         var _loc19_:MapRequestCommand = null;
         var _loc20_:MapSendCommand = null;
         var _loc21_:SuddenDeathCommand = null;
         if(APPEND_KEY && (param1.data.hash && param1.data.hash != this.gamenetController.randomSeed || param1.data.hash == null))
         {
            return null;
         }
         if(param1.data.pmpc)
         {
            _loc2_ = [];
            _loc4_ = param1.data.pmpc.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = new PlayerMoveCommand();
               if(_loc5_ == 0)
               {
                  _loc3_.occurTime = param1.data.pmpc[_loc5_][0];
                  _loc3_.playerId = param1.data.pmpc[_loc5_][1];
                  _loc3_.playerJid = param1.sender;
                  _loc3_.direction = new PlayerDirection(param1.data.pmpc[_loc5_][2]);
                  _loc3_.occurX = param1.data.pmpc[_loc5_][3];
                  _loc3_.occurY = param1.data.pmpc[_loc5_][4];
               }
               else
               {
                  _loc3_.playerId = param1.data.pmpc[0][1];
                  _loc3_.playerJid = param1.sender;
                  _loc3_.occurTime = param1.data.pmpc[_loc5_][0];
                  _loc3_.direction = new PlayerDirection(param1.data.pmpc[_loc5_][1]);
                  _loc3_.occurX = param1.data.pmpc[_loc5_][2];
                  _loc3_.occurY = param1.data.pmpc[_loc5_][3];
               }
               _loc2_.push(_loc3_);
               _loc5_++;
            }
            _loc6_ = new PlayerMovePlanCommand(_loc2_);
            return _loc6_;
         }
         if(param1.data.pdc)
         {
            ExternalInterface.call("emit",{
               "id":"blc",
               "f":"chat",
               "d":{"died":param1.sender}
            });
            _loc7_ = new PlayerDieCommand();
            _loc7_.occurTime = param1.data.pdc[0];
            _loc7_.playerId = param1.data.pdc[1];
            _loc7_.playerJid = param1.sender;
            return _loc7_;
         }
         if(param1.data.acc)
         {
            _loc8_ = new AbilityChangeCommand();
            _loc8_.occurTime = param1.data.acc[0];
            _loc8_.playerId = param1.data.acc[1];
            _loc8_.playerJid = param1.sender;
            _loc8_.bombAbility = new BombAbility();
            _loc8_.bombAbility._expiresAt = param1.data.acc[2];
            _loc8_.bombAbility.bombCount = param1.data.acc[3];
            _loc8_.bombAbility.explosionExpansionDelay = param1.data.acc[4];
            _loc8_.bombAbility.explosionMaxSizeHoldTime = param1.data.acc[5];
            _loc8_.bombAbility.explosionSize = param1.data.acc[6];
            _loc8_.movementAbility = new MovementAbility();
            _loc8_.movementAbility.speed = param1.data.acc[7];
            _loc8_.movementAbility.expiresAt = param1.data.acc[8];
            return _loc8_;
         }
         if(param1.data.abc)
         {
            _loc9_ = new AddBombCommand();
            _loc9_.detonateTime = param1.data.abc[0];
            _loc9_.ownerPlayerId = param1.data.abc[1];
            _loc9_.ownerPlayerJid = param1.sender;
            _loc9_.x = param1.data.abc[2];
            _loc9_.y = param1.data.abc[3];
            _loc9_.id = param1.data.abc[4];
            _loc9_.bombAbility = new BombAbility();
            _loc9_.bombAbility._expiresAt = param1.data.abc[5];
            _loc9_.bombAbility.bombCount = param1.data.abc[6];
            _loc9_.bombAbility.explosionSize = param1.data.abc[7];
            _loc9_.bombAbility.explosionMaxSizeHoldTime = param1.data.abc[8];
            _loc9_.bombAbility.explosionExpansionDelay = param1.data.abc[9];
            return _loc9_;
         }
         if(param1.data.kbc)
         {
            _loc10_ = new KickBombCommand();
            _loc10_.bombID = param1.data.kbc[0];
            _loc10_.dx = param1.data.kbc[1];
            _loc10_.dy = param1.data.kbc[2];
            _loc10_.kicked = param1.data.kbc[3];
            _loc10_.occurTime = param1.data.kbc[4];
            return _loc10_;
         }
         if(param1.data.bdc)
         {
            _loc11_ = new BlockDamageCommand();
            _loc11_.newStrength = param1.data.bdc[0];
            _loc11_.occurTime = param1.data.bdc[1];
            _loc11_.x = param1.data.bdc[2];
            _loc11_.y = param1.data.bdc[3];
            return _loc11_;
         }
         if(param1.data.prc)
         {
            _loc12_ = new PickupRemoveCommand();
            _loc12_.occurTime = param1.data.prc[0];
            _loc12_.x = param1.data.prc[1];
            _loc12_.y = param1.data.prc[2];
            return _loc12_;
         }
         if(param1.data.goc)
         {
            ExternalInterface.call("emit",{
               "id":"blc",
               "f":"chat",
               "d":{"gameover":1}
            });
            _loc13_ = new GameOverCommand();
            _loc13_.occurTime = param1.data.goc[0];
            _loc13_.orderedPlayerIds = [];
            _loc4_ = param1.data.goc.length;
            _loc5_ = 1;

            while(_loc5_ < _loc4_)
            {
               _loc13_.orderedPlayerIds.push(param1.data.goc[_loc5_]);
               _loc5_++;
            }

            return _loc13_;
         }
         if(param1.data.blc)
         {
            _loc14_ = new BackToLobbyCommand();
            _loc14_.occurTime = param1.data.blc;
            return _loc14_;
         }
         if(param1.data.gbc)
         {
            _loc15_ = new GameBeginCommand(param1.data.gbc);
            return _loc15_;
         }
         if(param1.data.psd)
         {


            _loc16_ = new PlayerSoftDieCommand();
            _loc16_.occurTime = param1.data.psd[0];
            _loc16_.playerId = param1.data.psd[1];
            _loc16_.playerJid = param1.sender;
            return _loc16_;
         }
         if(param1.data.svc)
         {
            _loc17_ = new SendVersionCommand();
            _loc17_.occurTime = param1.data.svc[0];
            _loc17_.version = param1.data.svc[1];
            return _loc17_;
         }
         if(param1.data.rvc)
         {
            _loc18_ = new RequestVersionCommand(param1.data.rvc);
            return _loc18_;
         }
         if(param1.data.mrc)
         {
            _loc19_ = new MapRequestCommand(param1.data.mrc);
            return _loc19_;
         }
         if(param1.data.msc)
         {
            _loc20_ = new MapSendCommand(param1.data.msc[0]);
            _loc20_.mapNum = param1.data.msc[1];
            _loc20_.boxExist = param1.data.msc[2];
            _loc20_.playersDead = param1.data.msc[3];
            _loc20_.suddenDeathMode = param1.data.msc[4];
            if(_loc20_.suddenDeathMode)
            {
               _loc20_.dropBlockCount = param1.data.msc[5];
               _loc20_.suddenDeathInitTime = param1.data.msc[6];
            }
            return _loc20_;
         }
         if(param1.data.sdc)
         {
            _loc21_ = new SuddenDeathCommand();
            _loc21_.suddenDeathInitTime = param1.data.sdc;
            return _loc21_;
         }
         return null;
      }

      private function createMessageFromCommand(param1:AbstractCommand, param2:Boolean) : *
      {
         var _loc4_:PlayerMovePlanCommand = null;
         var _loc5_:Array = null;
         var _loc6_:PlayerMoveCommand = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:PlayerDieCommand = null;
         var _loc10_:AbilityChangeCommand = null;
         var _loc11_:AddBombCommand = null;
         var _loc12_:KickBombCommand = null;
         var _loc13_:BlockDamageCommand = null;
         var _loc14_:PickupRemoveCommand = null;
         var _loc15_:GameOverCommand = null;
         var _loc16_:int = 0;
         var _loc17_:BackToLobbyCommand = null;
         var _loc18_:GameBeginCommand = null;
         var _loc19_:PlayerSoftDieCommand = null;
         var _loc20_:SendVersionCommand = null;
         var _loc21_:RequestVersionCommand = null;
         var _loc22_:MapRequestCommand = null;
         var _loc23_:MapSendCommand = null;
         var _loc24_:SuddenDeathCommand = null;
         var _loc3_:* = null;
         param2 = true;
         if(param1 is PlayerMovePlanCommand)
         {
            _loc4_ = param1 as PlayerMovePlanCommand;
            _loc5_ = _loc4_.moves;
            _loc3_ = {}
            _loc3_.pmpc = [];
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc8_] as PlayerMoveCommand;
               if(_loc8_ == 0)
               {
                  _loc7_ = [_loc6_.occurTime,_loc6_.playerId,_loc6_.direction.code,_loc6_.occurX,_loc6_.occurY ];
               }
               else
               {
                  _loc7_ = [_loc6_.occurTime,_loc6_.direction.code,_loc6_.occurX ,_loc6_.occurY ];
               }
               _loc3_.pmpc.push(_loc7_);
               _loc8_++;
            }
            param2 = false;
         }
         else if(param1 is PlayerDieCommand)
         {
            _loc9_ = param1 as PlayerDieCommand;
            _loc3_ = {}
            _loc3_.pdc = [_loc9_.occurTime,_loc9_.playerId];
            ExternalInterface.call("emit",{
               "id":"blc",
               "f":"chat",
               "d":{"died":_loc9_.playerJid}
            });
         }
         else if(param1 is AbilityChangeCommand)
         {
            _loc10_ = param1 as AbilityChangeCommand;
            _loc3_ = {}
            _loc3_.acc = [_loc10_.occurTime,_loc10_.playerId,_loc10_.bombAbility._expiresAt,_loc10_.bombAbility.bombCount,_loc10_.bombAbility.explosionExpansionDelay,_loc10_.bombAbility.explosionMaxSizeHoldTime,_loc10_.bombAbility.explosionSize,_loc10_.movementAbility.speed,_loc10_.movementAbility.expiresAt];
         }
         else if(param1 is AddBombCommand)
         {
            _loc11_ = param1 as AddBombCommand;
            _loc3_ = {}
            _loc3_.abc = [_loc11_.detonateTime,_loc11_.ownerPlayerId,_loc11_.x,_loc11_.y,_loc11_.id,_loc11_.bombAbility._expiresAt,_loc11_.bombAbility.bombCount,_loc11_.bombAbility.explosionSize,_loc11_.bombAbility.explosionMaxSizeHoldTime,_loc11_.bombAbility.explosionExpansionDelay];
         }
         else if(param1 is KickBombCommand)
         {
            _loc12_ = param1 as KickBombCommand;
            _loc3_ = {}
            _loc3_.kbc = [_loc12_.bombID,_loc12_.dx,_loc12_.dy,_loc12_.kicked,_loc12_.occurTime];
         }
         else if(param1 is BlockDamageCommand)
         {
            _loc13_ = param1 as BlockDamageCommand;
            _loc3_ = {}
            _loc3_.bdc = [_loc13_.newStrength,_loc13_.occurTime,_loc13_.x,_loc13_.y];
         }
         else if(param1 is PickupRemoveCommand)
         {
            _loc14_ = param1 as PickupRemoveCommand;
            _loc3_ = {}
            _loc3_.prc = [_loc14_.occurTime,_loc14_.x,_loc14_.y];
         }
         else if(param1 is GameOverCommand)
         {
            ExternalInterface.call("emit",{
               "id":"blc",
               "f":"chat",
               "d":{"gameover":1}
            });
            _loc15_ = param1 as GameOverCommand;
            _loc3_ = {}
            _loc3_.goc = [];
            _loc3_.goc.push(_loc15_.occurTime);
            for each(_loc16_ in _loc15_.orderedPlayerIds)
            {
               _loc3_.goc.push(_loc16_);
            }
         }
         else if(param1 is BackToLobbyCommand)
         {
            _loc17_ = param1 as BackToLobbyCommand;
            _loc3_ = {}
            _loc3_.blc = _loc17_.occurTime;
         }
         else if(param1 is GameBeginCommand)
         {
            _loc18_ = param1 as GameBeginCommand;
            _loc3_ = {}
            _loc3_.gbc = _loc18_.occurTime;
         }
         else if(param1 is PlayerSoftDieCommand)
         {
            _loc19_ = param1 as PlayerSoftDieCommand;
            _loc3_ = {}
            _loc3_.psd = [_loc19_.occurTime,_loc19_.playerId];
         }
         else if(param1 is SendVersionCommand)
         {
            _loc20_ = param1 as SendVersionCommand;
            _loc3_ = {}
            _loc3_.svc = [_loc20_.occurTime,_loc20_.version];
         }
         else if(param1 is RequestVersionCommand)
         {
            _loc21_ = param1 as RequestVersionCommand;
            _loc3_ = {}
            _loc3_.rvc = _loc21_.occurTime;
         }
         else if(param1 is MapRequestCommand)
         {
            _loc22_ = param1 as MapRequestCommand;
            _loc3_ = {}
            _loc3_.mrc = _loc22_.occurTime;
         }
         else if(param1 is MapSendCommand)
         {
            _loc23_ = param1 as MapSendCommand;
            _loc3_ = {}
            _loc3_.msc = [];
            _loc3_.msc.push(_loc23_.occurTime);
            _loc3_.msc.push(_loc23_.mapNum);
            _loc3_.msc.push(_loc23_.boxExist);
            _loc3_.msc.push(_loc23_.playersDead);
            _loc3_.msc.push(_loc23_.suddenDeathMode);
            if(_loc23_.suddenDeathMode)
            {
               _loc3_.msc.push(_loc23_.dropBlockCount);
               _loc3_.msc.push(_loc23_.suddenDeathInitTime);
            }
         }
         else if(param1 is SuddenDeathCommand)
         {
            _loc24_ = param1 as SuddenDeathCommand;
            _loc3_ = {}
            _loc3_.sdc = _loc24_.suddenDeathInitTime;
         }
         if(_loc3_ && APPEND_KEY)
         {
            _loc3_.hash = this.gamenetController.randomSeed;
         }
         return _loc3_;
      }

      public function onTickNetSend(param1:CoreGameEvent) : void
      {
         var _loc2_:AbstractCommand = null;
         var _loc4_:* = undefined;
         var commands:Array = [];

         while(_loc2_ = this.outgoingCommandQueue.pop())
         {
            if(this.gamenetController.playerRole != PlayerRoles.SPECTATOR)
            {
               if(USENEWSERIALIZER)
               {
                  _loc4_ = this.createMessageFromCommand(_loc2_,false);
                  if(_loc4_)
                  {
                     // this.gamenetController.sendGameAction(_loc4_);
                     commands.push(_loc4_);
                  }
               }
               else
               {
                  this.gamenetController.sendGameAction(Serializer.export(_loc2_));
               }
            }
         }
         this.outgoingCommandQueue.splice(0,this.outgoingCommandQueue.length);
         if(commands.length)
         {
               ExternalInterface.call("emit",{
                  "id":"blc",
                  "f":"snm",
                  "d":commands
               });
         }

      }

      public function destroy() : void
      {
         BaloonoGame.instance.removeEventListener(CoreGameEvent.GAME_START,this.gameStart);
         BaloonoGame.instance.removeEventListener(CoreGameEvent.GAME_STOP,this.gameStop);
         this.gamenetController = null;
      }

      public function onTickInteractions(param1:CoreGameEvent) : void
      {
         var _loc2_:AbstractCommand = null;
         var _loc3_:uint = BaloonoGame.time;
         var _loc4_:int = 0;
         if(this.internalCommandQueue)
         {
            _loc4_ = 0;
            while(_loc4_ < this.internalCommandQueue.length)
            {
               _loc2_ = AbstractCommand(this.internalCommandQueue[_loc4_]);
               if(this.routeCommand(_loc2_))
               {
                  this.internalCommandQueue.splice(_loc4_,1);
               }
               else
               {
                  //trace("Could not process internal command");
                  _loc4_++;
               }
            }
         }
         if(this.upcomingCommands)
         {
            _loc4_ = 0;
            while(_loc4_ < this.upcomingCommands.length)
            {
               _loc2_ = AbstractCommand(this.upcomingCommands[_loc4_]);
               if(_loc2_.occurTime > _loc3_)
               {
                  _loc4_++;
               }
               else if(this.routeCommand(_loc2_))
               {
                  this.upcomingCommands.splice(_loc4_,1);
               }
               else
               {
                  _loc4_++;
               }
            }
         }
      }
   }
}
