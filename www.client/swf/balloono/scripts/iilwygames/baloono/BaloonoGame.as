package iilwygames.baloono
{
   import com.partlyhuman.debug.Console;
   import de.polygonal.math.PM_PRNG;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.IGamenetGame;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwy.gamenet.developer.RoundResults;
   import iilwygames.baloono.commands.AbstractCommand;
   import iilwygames.baloono.commands.BackToLobbyCommand;
   import iilwygames.baloono.commands.CommandDispatcher;
   import iilwygames.baloono.commands.GameBeginCommand;
   import iilwygames.baloono.commands.GameOverCommand;
   import iilwygames.baloono.commands.ICommandResponder;
   import iilwygames.baloono.commands.MapRequestCommand;
   import iilwygames.baloono.commands.MapSendCommand;
   import iilwygames.baloono.commands.RequestVersionCommand;
   import iilwygames.baloono.commands.SendVersionCommand;
   import iilwygames.baloono.commands.SuddenDeathCommand;
   import iilwygames.baloono.core.CoreGameEvent;
   import iilwygames.baloono.effects.CacheBitmaps;
   import iilwygames.baloono.embedded.GraphicAssets;
   import iilwygames.baloono.embedded.SoundAssets;
   import iilwygames.baloono.gamedisplay.MainBaloonoScreen;
   import iilwygames.baloono.gameplay.PowerupFactory;
   import iilwygames.baloono.gameplay.bomb.BombManager;
   import iilwygames.baloono.gameplay.bomb.ExplosionManager;
   import iilwygames.baloono.gameplay.map.MapManager;
   import iilwygames.baloono.gameplay.map.MapView;
   import iilwygames.baloono.gameplay.player.NullPlayer;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.player.PlayerManager;
   import iilwygames.baloono.gameplay.player.PlayerState;
   import iilwygames.baloono.gameplay.tiles.TileState;
   import iilwygames.baloono.graphics.AssetManager;
   import iilwygames.baloono.graphics.FramerateMonitor;
   import iilwygames.baloono.managers.KeyboardInputManager;
   import iilwygames.baloono.util.CountdownPopup;
   import iilwygames.ui.partials.GameOverPopup;

   public class BaloonoGame extends Sprite implements IGamenetGame, ICommandResponder
   {

      public static var time:uint;

      public static var instance:BaloonoGame;


      public var powerupFactory:PowerupFactory;

      public var graphicAssets:GraphicAssets;

      public var playerManager:PlayerManager;

      protected var gameRootDisplayObject:DisplayObject;

      private var lastUpdateTime:uint;

      public var assetManager:AssetManager;

      public var mapView:MapView;

      public var blockThresh:Number = 0.8;

      public var bombManager:BombManager;

      public var mapManager:MapManager;

      public var DEBUG_LOGGING:Boolean = false;

      private var _isRunning:Boolean;

      public var suddenDeathRNG:PM_PRNG;

      public var random:PM_PRNG;

      public var cachedWidth:Number = 1;

      protected var startGameOnAssetLoad:Boolean = false;

      public var DEBUG_VISUAL:Boolean = false;

      public var framerateMonitor:FramerateMonitor;

      public var cacheBitmaps:CacheBitmaps;

      public var commandDispatcher:CommandDispatcher;

      public var explosionManager:ExplosionManager;

      public var itemExistRand:PM_PRNG;

      public var gamenetController:GamenetController;

      public var itemRand:PM_PRNG;

      public var soundAssets:SoundAssets;

      public var screen:MainBaloonoScreen;

      public var keyboard:KeyboardInputManager;

      public var DEBUG_ERRORS:Boolean = false;

      public var cachedHeight:Number = 1;

      public var version:String = "4.1";

      protected var areAssetsReady:Boolean = false;

      public var bombDropRand:PM_PRNG;

      public function BaloonoGame()
      {
         super();
         BaloonoGame.instance = this;
         this.initialize();
      }

      public function destroy() : void
      {
      }

      public function stop() : void
      {
         this._isRunning = false;
         this.bombManager.clear();
         this.explosionManager.clear();
         removeEventListener(Event.ENTER_FRAME,this.tick);
         dispatchEvent(new CoreGameEvent(CoreGameEvent.GAME_STOP));
      }

      public function setSize(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.cachedWidth = param1;
         this.cachedHeight = param2;
         if(this.screen)
         {
            this.screen.resize(param1,param2);
            this.cacheBitmaps.resize(param1,param2);
         }
         if(this.mapView.cachedHeight == 0 && this.mapView.cachedWidth == 0)
         {
            if(this.gamenetController.playerList.length <= 4)
            {
               _loc3_ = 17;
               _loc4_ = 15;
            }
            else
            {
               _loc3_ = 21;
               _loc4_ = 15;
            }
            _loc5_ = int(param1 / _loc3_);
            _loc6_ = int(param2 / _loc4_);
            if(_loc5_ < _loc6_)
            {
               _loc6_ = _loc5_;
            }
            else
            {
               _loc5_ = _loc6_;
            }
            _loc7_ = _loc5_ * _loc3_;
            _loc8_ = _loc6_ * _loc4_;
            return new Rectangle(0,0,_loc7_,_loc8_);
         }
         return new Rectangle(0,0,this.mapView.cachedWidth,this.mapView.cachedHeight);
      }

      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }

      protected function initialize() : void
      {
         XML.ignoreComments = true;
         XML.ignoreWhitespace = false;
         this.keyboard = new KeyboardInputManager();
         this.framerateMonitor = new FramerateMonitor(this);
         this.assetManager = new AssetManager();
         this.mapManager = new MapManager();
         this.playerManager = new PlayerManager();
         this.bombManager = new BombManager();
         this.explosionManager = new ExplosionManager();
         this.powerupFactory = new PowerupFactory();
         this.commandDispatcher = new CommandDispatcher();
         this.soundAssets = new SoundAssets();
         this.graphicAssets = new GraphicAssets();
         this.cacheBitmaps = new CacheBitmaps();
         this.cacheBitmaps.init();
         this.cacheBitmaps.cache("droplet",new this.graphicAssets.droplet(),150,50,50);
         this.screen = new MainBaloonoScreen();
         addChild(this.screen);
         this.mapView = this.screen.mapView;
         this.assetManager.addEventListener(Event.COMPLETE,this.onAssetsReady);
         this._isRunning = false;
      }

      protected function onAssetsReady(param1:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this.areAssetsReady = true;
         Console.info("Assets loaded...");
         trace("+++++++++++++++++++++++  Assets loaded");
         if(this.startGameOnAssetLoad)
         {
            this.offsetStart();
         }
      }

      public function offsetStart() : void
      {
         var _loc2_:MapRequestCommand = null;
         var _loc1_:CoreGameEvent = new CoreGameEvent(CoreGameEvent.GAME_START);
         _loc1_.gamenetController = this.gamenetController;
         dispatchEvent(_loc1_);
         this.screen.reset();
         Console.log("rand seed set to",this.random.seed);
         this.keyboard.assignEventSource(this.gameRootDisplayObject);
         if(this.gamenetController.playerRole != PlayerRoles.SPECTATOR)
         {
            if(this.mapManager.filterMap)
            {
               trace("filter map left over from spectator mode?");
               this.mapManager.filterMap = null;
            }
            this.mapManager.setRandomMap();
            this.setMapAndStart();
         }
         else
         {
            _loc2_ = new MapRequestCommand(this.gamenetController.syncedTime);
            this.commandDispatcher.sendImmediate(_loc2_);
         }
         this.explosionManager.init();
      }

      protected function tick(param1:Event) : void
      {
         if(!this._isRunning)
         {
            if(this.DEBUG_LOGGING)
            {
               Console.error("BalloonoGame::tick() when stopped");
            }
            return;
         }
         BaloonoGame.time = this.gamenetController.syncedTime;
         var _loc2_:uint = getTimer();
         var _loc3_:uint = _loc2_ - this.lastUpdateTime;
         this.lastUpdateTime = _loc2_;
         if(this.playerManager.me)
         {
            this.playerManager.me.processInput(null);
         }
         this.commandDispatcher.onTickInteractions(null);
         this.mapManager.update(_loc3_);
         this.bombManager.updateBombs(_loc3_);
         this.explosionManager.updateExplosions();
         this.playerManager.updatePlayers(_loc3_);
         this.commandDispatcher.onTickNetSend(null);
         // this.screen.psystem.update(_loc3_);
         // this.screen.redraw(null);
         this.mapView.redraw(time);
      }

      public function setMapAndStart() : void
      {
         var _loc4_:CountdownPopup = null;
         var _loc5_:Number = NaN;
         this.mapView.setMap(this.mapManager.currentMap);
         this.mapView.resize(this.cachedWidth,this.cachedHeight);
         var _loc1_:Number = this.gamenetController.startTime ;
         var _loc2_:GameBeginCommand = new GameBeginCommand(_loc1_);
         this.commandDispatcher.enqueueCommand(_loc2_,false,false);
         if(!this.playerManager.isSpectator)
         {
            _loc4_ = new CountdownPopup();
           // this.screen.setPopup(_loc4_,false);
            _loc5_ = _loc1_ - this.gamenetController.syncedTime;
            _loc4_.start(getTimer() + _loc5_);
         }
         removeEventListener(Event.ENTER_FRAME,this.tick);
         addEventListener(Event.ENTER_FRAME,this.tick);
         this._isRunning = true;
         this.lastUpdateTime = getTimer();
         // trace("====== YOU HAVE version: " + this.version);
         // trace("requesting other players....");
         var _loc3_:RequestVersionCommand = new RequestVersionCommand(this.gamenetController.syncedTime);
         this.commandDispatcher.sendImmediate(_loc3_);
      }

      public function restartGame(param1:TimerEvent) : void
      {
         this.stop();
         this.offsetStart();
      }

      public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         var _loc2_:GameOverCommand = null;
         var _loc3_:RoundResults = null;
         var _loc4_:GameOverPopup = null;
         var _loc5_:MapSendCommand = null;
         var _loc6_:Player = null;
         var _loc7_:* = null;
         var _loc8_:MapSendCommand = null;
         var _loc9_:Player = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:SendVersionCommand = null;
         var _loc13_:SuddenDeathCommand = null;
         if(param1 is GameOverCommand)
         {
            this.soundAssets.playSound(SoundAssets.GAMEOVER);
           /* _loc2_ = GameOverCommand(param1);
            _loc3_ = _loc2_.getRoundResults();
            if(this.playerManager.isHost)
            {
               this.gamenetController.recordRound(_loc3_);
            }
            _loc4_ = new GameOverPopup();
            _loc4_.data = _loc3_;
            this.screen.setPopup(_loc4_,true);
            this.commandDispatcher.enqueueCommand(new BackToLobbyCommand(),false,false);
            */
            this.mapManager.endSuddenDeath();
         }
         else if(param1 is BackToLobbyCommand)
         {
            this.stop();
            this.screen.setPopup(null,false);
            this.gamenetController.sendMatchBackToReady();
         }
         else if(param1 is GameBeginCommand)
         {
            trace("Got Game Start Command at ",getTimer()," aka ",this.gamenetController.syncedTime);
            this.screen.setPopup(null,false);
            this.playerManager.respondToCommand(param1);
         }
         else if(param1 is MapRequestCommand)
         {
            if(this.gamenetController.playerRole == PlayerRoles.HOST)
            {
               _loc5_ = new MapSendCommand(this.gamenetController.syncedTime,this.mapManager.currentMap);
               _loc5_.mapNum = this.mapManager.mapNum;
               for(_loc7_ in this.playerManager.activePlayers)
               {
                  _loc6_ = this.playerManager.activePlayers[_loc7_] as Player;
                  if(!(!_loc6_ || _loc6_ is NullPlayer))
                  {
                     if(_loc6_.playerState.equals(PlayerState.DEAD))
                     {
                        _loc5_.playersDead.push(_loc6_.jid);
                     }
                  }
               }
               if(this.mapManager._suddenDeathMode)
               {
                  _loc5_.suddenDeathInitTime = this.mapManager._suddenDeathStartInitTime;
                  _loc5_.dropBlockCount = this.mapManager._droppedBlockCount;
                  _loc5_.suddenDeathMode = 1;
               }
               this.commandDispatcher.sendImmediate(_loc5_);
            }
            if(this.playerManager && this.playerManager.me)
            {
               this.playerManager.me.sendMyAbilities();
            }
         }
         else if(param1 is MapSendCommand)
         {
            _loc8_ = param1 as MapSendCommand;
            if(this.gamenetController.playerRole == PlayerRoles.SPECTATOR)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc8_.playersDead.length)
               {
                  _loc10_ = _loc8_.playersDead[_loc11_] as String;
                  _loc9_ = this.playerManager.getPlayerByJid(_loc10_);
                  if(_loc9_)
                  {
                     _loc9_.playerState = PlayerState.DEAD;
                     _loc9_.state = TileState.INACTIVE;
                  }
                  else
                  {
                     trace("player is no longer in the game!");
                  }
                  _loc11_++;
               }
               this.mapManager.filterMap = _loc8_.boxExist;
               this.mapManager.setRandomMap(_loc8_.mapNum);
               if(_loc8_.suddenDeathMode)
               {
                  this.mapManager.initSpectatorSuddenDeath(_loc8_.suddenDeathInitTime,_loc8_.dropBlockCount);
               }
               this.setMapAndStart();
            }
            else
            {
               trace("I\'m not a spectator but I recieved a MapSendCommand");
            }
         }
         else if(param1 is RequestVersionCommand)
         {
            _loc12_ = new SendVersionCommand(this.gamenetController.syncedTime);
            _loc12_.version = this.version;
            this.commandDispatcher.sendImmediate(_loc12_);
         }
         else if(param1 is SuddenDeathCommand)
         {
            if(this.gamenetController.playerRole != PlayerRoles.HOST)
            {
               _loc13_ = param1 as SuddenDeathCommand;
               this.mapManager._suddenDeathStartInitTime = _loc13_.suddenDeathInitTime;
            }
         }
         return true;
      }

      public function testTimer(param1:TimerEvent) : void
      {
         trace("test timer");
      }

      public function start(param1:DisplayObject, param2:GamenetController) : void
      {
         this.itemRand = new PM_PRNG();
         this.itemRand.seed = param2.randomSeed;
         this.itemExistRand = new PM_PRNG();
         this.itemExistRand.seed = param2.randomSeed;
         this.random = new PM_PRNG();
         this.random.seed = param2.randomSeed;
         this.suddenDeathRNG = new PM_PRNG();
         this.suddenDeathRNG.seed = param2.randomSeed;
         this.startGameOnAssetLoad = false;
         if(!this.areAssetsReady)
         {
            this.startGameOnAssetLoad = true;
         }
         this.gameRootDisplayObject = param1;
         this.gamenetController = param2;
         if(this.areAssetsReady)
         {
            this.offsetStart();
         }
      }
   }
}
