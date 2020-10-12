package iilwygames.baloono.gameplay.player
{
   import com.partlyhuman.debug.Console;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbstractCommand;
   import iilwygames.baloono.commands.GameBeginCommand;
   import iilwygames.baloono.commands.GameOverCommand;
   import iilwygames.baloono.commands.ICommandResponder;
   import iilwygames.baloono.commands.PlayerCommand;
   import iilwygames.baloono.commands.PlayerDieCommand;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.core.IGameStoppable;
   import iilwygames.baloono.embedded.SoundAssets;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class PlayerManager implements IGameStoppable, ICommandResponder
   {
       
      
      protected var gamenetController:GamenetController;
      
      public var activePlayers:Array;
      
      protected var _me:MyPlayer;
      
      protected var playersByJid:Object;
      
      public function PlayerManager()
      {
         super();
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_STOP,this.gameStop,false,0,true);
         BaloonoGame.instance.addEventListener(CoreGameEvent.GAME_START,this.gameStart,false,0,true);
      }
      
      public function updatePlayers(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Player = null;
         var _loc4_:int = 0;
         if(this.activePlayers)
         {
            _loc2_ = this.activePlayers.length;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = this.activePlayers[_loc4_];
               if(_loc3_)
               {
                  _loc3_.updatePosition(param1);
               }
               _loc4_++;
            }
         }
      }
      
      public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         var player:Player = null;
         var index:String = null;
         var pc:PlayerCommand = null;
         var target:Player = null;
         var livingPlayerCount:int = 0;
         var lastPlayerStanding:Player = null;
         var deadPlayers:Array = null;
         var abstractCommand:AbstractCommand = param1;
         if(abstractCommand is PlayerCommand)
         {
            pc = PlayerCommand(abstractCommand);
            target = this.getPlayerByJid(pc.playerJid);
            if(!target)
            {
               return false;
            }
            target.respondToCommand(pc);
            if(this.isHost && pc is PlayerDieCommand)
            {
               BaloonoGame.instance.soundAssets.playSound(SoundAssets.DIE);
               livingPlayerCount = 0;
               lastPlayerStanding = null;
               deadPlayers = new Array();
               for(index in this.activePlayers)
               {
                  player = this.activePlayers[index] as Player;
                  if(!(!player || player is NullPlayer))
                  {
                     if(player.playerState.equals(PlayerState.DEAD))
                     {
                        deadPlayers.push(player);
                     }
                     else
                     {
                        livingPlayerCount++;
                        lastPlayerStanding = player;
                     }
                  }
               }
               if(livingPlayerCount <= 1)
               {
                  deadPlayers.sortOn("timeOfDeath",Array.DESCENDING | Array.NUMERIC);
                  if(lastPlayerStanding)
                  {
                     deadPlayers.unshift(lastPlayerStanding);
                  }
                  deadPlayers = deadPlayers.map(function(param1:Player, param2:int, param3:Array):int
                  {
                     return param1.id;
                  });
                  BaloonoGame.instance.commandDispatcher.enqueueCommand(new GameOverCommand(abstractCommand.occurTime,deadPlayers),true,true);
               }
            }
         }
         else if(abstractCommand is GameBeginCommand)
         {
            for(index in this.activePlayers)
            {
               player = this.activePlayers[index] as Player;
               if(player.playerState == PlayerState.COUNTDOWN)
               {
                  player.playerState = PlayerState.ALIVE;
               }
            }
         }
         else if(abstractCommand is GameOverCommand)
         {
            for(index in this.activePlayers)
            {
               player = this.activePlayers[index] as Player;
               player.playerState = PlayerState.COUNTDOWN;
            }
         }
         return true;
      }
      
      public function getPlayerByIndex(param1:int) : Player
      {
         return this.activePlayers[param1] as Player;
      }
      
      public function get isSpectator() : Boolean
      {
         return this.gamenetController.playerRole == PlayerRoles.SPECTATOR;
      }
      
      protected function generateAndInsertGamePlayer(param1:GamenetPlayerData) : Player
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:int = this.activePlayers.length;
         var _loc3_:Player = null;
         if(param1.equals(this.gamenetController.playerData))
         {
            _loc3_ = new MyPlayer(_loc2_,param1);
            if(this._me)
            {
               if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.error("New \'me\' player added in a game... ignoring");
               }
               return null;
            }
            this._me = MyPlayer(_loc3_);
         }
         else
         {
            _loc3_ = new Player(_loc2_,param1);
         }
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:GraphicSet = BaloonoGame.instance.assetManager.getGraphicSet("player" + _loc2_);
         if(_loc4_ == null)
         {
            trace("does not exist");
         }
         _loc3_.setArt(_loc4_);
         this.activePlayers[_loc2_] = _loc3_;
         this.playersByJid[param1.playerJid] = _loc3_;
         return _loc3_;
      }
      
      public function gameStart(param1:CoreGameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GamenetPlayerData = null;
         this.gamenetController = param1.gamenetController;
         this.gamenetController.addEventListener(GamenetEvent.PLAYER_LEFT,this.onPlayerLeft);
         this.gamenetController.addEventListener(GamenetEvent.HOST_CHANGED,this.onHostChanged);
         this.activePlayers = new Array();
         this.playersByJid = new Object();
         if(this.gamenetController.playerList)
         {
            _loc2_ = 0;
            while(_loc2_ < this.gamenetController.playerList.length)
            {
               _loc3_ = this.gamenetController.playerList[_loc2_] as GamenetPlayerData;
               this.generateAndInsertGamePlayer(_loc3_);
               _loc2_++;
            }
         }
      }
      
      protected function onHostChanged(param1:GamenetEvent) : void
      {
      }
      
      public function get isHost() : Boolean
      {
         return this.gamenetController.playerRole == PlayerRoles.HOST;
      }
      
      public function gameStop(param1:CoreGameEvent) : void
      {
         var _loc2_:Player = null;
         for each(_loc2_ in this.activePlayers)
         {
            _loc2_.destroy();
         }
         if(this.gamenetController)
         {
            this.gamenetController.removeEventListener(GamenetEvent.PLAYER_LEFT,this.onPlayerLeft);
            this.gamenetController.removeEventListener(GamenetEvent.HOST_CHANGED,this.onHostChanged);
         }
         this._me = null;
         this.activePlayers = null;
         this.playersByJid = null;
      }
      
      public function get playerCount() : int
      {
         return !!this.activePlayers?int(this.activePlayers.length):0;
      }
      
      protected function onPlayerLeft(param1:GamenetEvent) : void
      {
         var _loc2_:Player = Player(this.playersByJid[param1.data.jid]);
         BaloonoGame.instance.commandDispatcher.enqueueCommand(new PlayerDieCommand(BaloonoGame.time,_loc2_.id,_loc2_.iilwyPlayerData.playerJid),true,false);
      }
      
      public function get me() : MyPlayer
      {
         return this._me;
      }
      
      public function getPlayerByJid(param1:String) : Player
      {
         return this.playersByJid[param1] as Player;
      }
   }
}
