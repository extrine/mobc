package iilwygames.pool.model
{
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwy.gamenet.developer.RoundResults;
   import iilwygames.pool.core.GameState;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ruleset.Eightball;
   import iilwygames.pool.model.gameplay.Ruleset.EightballBlitz;
   import iilwygames.pool.model.gameplay.Ruleset.FreePlay;
   import iilwygames.pool.model.gameplay.Ruleset.FreePlayNineBall;
   import iilwygames.pool.model.gameplay.Ruleset.NineBall;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.Editor;
   import iilwygames.pool.model.gameplay.Team;
   import iilwygames.pool.model.physics.World;
   import iilwygames.pool.network.MessageTypes;
   import iilwygames.pool.network.NetworkMessage;
   import flash.external.ExternalInterface;

   public class GameModel
   {


      public var world:World;

      public var ruleset:Ruleset;

      public var players:Vector.<Player>;

      public var localPlayer:PlayerLocal;

      public var vsCPU:Boolean;

      public var quitgameNextUpdate:Boolean;

      public var markedAsCheating:Boolean;

      public var darkFelt:Boolean;

      public var hasFeltProperty:Boolean;

      public var breakingTeam:int;

      protected var accumulator:Number;

      public const TICK_TIME:Number = 0.01;

      protected const LOBBY_TIME:uint = 4000;

      protected var backToLobbyTime:uint;

      private var _spectatorWaitingSnapshot:Boolean;

      public function GameModel()
      {
         super();
         this.world = new World();
         this.players = new Vector.<Player>();
         this.accumulator = 0;
         Globals.gameState = GameState.IDLE;
         this._spectatorWaitingSnapshot = false;
         this.markedAsCheating = false;
         this.darkFelt = false;
         this.hasFeltProperty = false;
         this.vsCPU = false;
      }

      public function destroy() : void
      {
         this.world.destroy();
         this.players = null;
         this.world = null;
      }

      public function stop() : void
      {
         var focusPlayer:Player = null;
         this.world.stop();
         if(this.ruleset)
         {
            this.ruleset.destroy();
         }
         this.ruleset = null;
         for each(focusPlayer in this.players)
         {
            focusPlayer.destroy();
         }
         this.players.length = 0;
         this.localPlayer = null;
         Globals.gameState = GameState.IDLE;
         this.quitgameNextUpdate = false;
      }

      public function initialize(gnc:GamenetController) : void
      {
         var pdata:GamenetPlayerData = null;
         var player:Player = null;
         var cpuPlayer:PlayerCPU = null;
         var stateRequest:NetworkMessage = null;
         var localPlayerData:GamenetPlayerData = gnc.playerData;
         var playerList:Array = gnc.playerList;
         var numPlayers:int = playerList.length;
         this.quitgameNextUpdate = false;
         this.vsCPU = false;

         if(ExternalInterface.call("swf.name","") != "pool")
         {
            gnc.gameType = "nineball";
         }

          if(Globals.EDITOR_MODE)
         {
            this.ruleset = new Editor(gnc.randomSeed);
         }
         else if(numPlayers == 1)
         {
            if(Globals.FACEBOOK_BUILD)
            {
               this.ruleset = new EightballBlitz(gnc.randomSeed,1);
            }
            else if(gnc.gameType == "nineball")
            {
               this.ruleset = new FreePlayNineBall(gnc.randomSeed);
            }
            else if(Globals.CPU_PLAYER_ENABLED)
            {
               this.ruleset = new Eightball(gnc.randomSeed);
               this.vsCPU = true;
            }
            else
            {
               this.ruleset = new FreePlay(gnc.randomSeed);
            }
            if(!this.vsCPU)
            {
               this.ruleset.singlePlayer = true;
            }

         }
         else
         {

            if(gnc.gameType == "nineball")
            {
               this.ruleset = new NineBall(gnc.randomSeed);
            }
            else
            {
               this.ruleset = new Eightball(gnc.randomSeed);
            }
            this.ruleset.singlePlayer = false;
         }

         this.breakingTeam = gnc.roundIndex % this.ruleset.numberOfTeams;
         for(var i:int = 0; i < numPlayers; i++)
         {
            pdata = playerList[i];
            player = null;
            if(localPlayerData && localPlayerData.equals(pdata))
            {
               player = new PlayerLocal();
               this.localPlayer = player as PlayerLocal;
               this.localPlayer.initNumberStore(gnc);
               if(Globals.FACEBOOK_BUILD)
               {
                  this.localPlayer.initPowerups();
               }
            }
            else
            {
               player = new PlayerRemote();
            }
            if(gnc.hostData.equals(pdata))
            {
               this.ruleset.addPlayerToTeam(player,0);
            }
            else
            {
               this.ruleset.addPlayerToTeam(player,1);
            }
            if(player)
            {
               player.playerData = pdata;
               this.players.push(player);
            }
         }
         if(this.vsCPU)
         {
            cpuPlayer = new PlayerCPU();
            cpuPlayer.setRngSeed(gnc.randomSeed);
            player = cpuPlayer;
            this.players.push(player);
            this.ruleset.addPlayerToTeam(player,1);
         }
         this.accumulator = 0;
         this.ruleset.initialize();
         this.backToLobbyTime = uint.MAX_VALUE;
         Globals.gameState = GameState.PLAY;
         Globals.view.initModels();
         if(gnc.playerRole == PlayerRoles.SPECTATOR)
         {
            this._spectatorWaitingSnapshot = true;
            stateRequest = new NetworkMessage(MessageTypes.MSG_SPECTATOR_REQUEST_GAMESTATE);
            Globals.netMediator.sendNetworkMessage(stateRequest,gnc.hostData.playerJid);
         }
      }

      public function update(et:Number) : void
      {
         var player:Player = null;
         var msg:NetworkMessage = null;
         if(this._spectatorWaitingSnapshot)
         {
            return;
         }
         if(Globals.gameState == GameState.PLAY)
         {
            if(this.ruleset.isGameOver())
            {
               if(Globals.netController.playerRole == PlayerRoles.HOST)
               {
                  Globals.gameState = GameState.GAMEOVER;
                  msg = new NetworkMessage(MessageTypes.MSG_END_GAME);
                  msg.data = {"lobbyTime":Globals.netController.syncedTime + this.LOBBY_TIME};
                  Globals.netMediator.sendNetworkMessage(msg);
               }
            }
         }
         else if(Globals.gameState == GameState.GAMEOVER)
         {
            if(Globals.netController.syncedTime >= this.backToLobbyTime && Globals.netController.playerRole == PlayerRoles.HOST)
            {
               Globals.netController.sendMatchBackToReady();
               Globals.gameState = GameState.PENDING_LOBBY;
            }
         }
         this.accumulator = this.accumulator + et;
         for each(player in this.players)
         {
            if(player)
            {
               player.update(et);
            }
         }
         if(this.ruleset)
         {
            this.ruleset.update(et);
            while(this.accumulator >= this.TICK_TIME)
            {
               this.world.update(this.TICK_TIME);
               this.ruleset.updateFixed(this.TICK_TIME);
               this.accumulator = this.accumulator - this.TICK_TIME;
            }
         }
      }

      public function getPlayerByJID(jid:String) : Player
      {
         var focusPlayer:Player = null;
         for(var i:int = 0; i < this.players.length; i++)
         {
            focusPlayer = this.players[i];
            if(focusPlayer.playerData.playerJid == jid)
            {
               return focusPlayer;
            }
         }
         return null;
      }

      public function endGame() : void
      {
         if(Globals.gameState != GameState.GAMEOVER)
         {
            Globals.gameState = GameState.GAMEOVER;
         }
         if(this.ruleset.winnerIndex == Ruleset.TEAM_NONE)
         {
            return;
         }
         this.ruleset.processEndGame();
      }

      public function createRoundResults(winnderIndex:int, record:Boolean) : RoundResults
      {
         var player:Player = null;
         var result:RoundResults = new RoundResults();
         var winningTeam:Team = this.ruleset.teams[winnderIndex];
         var losingTeam:Team = this.ruleset.teams[this.ruleset.getNextTeamIDFrom(winnderIndex)];
         var position:int = 1;
         for each(player in winningTeam.players)
         {
            result.addResult(position,player.playerData);
            position++;
         }
         if(this.ruleset.singlePlayer == false)
         {
            for each(player in losingTeam.players)
            {
               result.addResult(position,player.playerData);
               position++;
            }
         }
         if(record && !this.ruleset.gameDesynced && !this.markedAsCheating)
         {
            Globals.netController.recordRound(result);
         }
         return result;
      }

      public function handlePlayerLeave(jid:String) : void
      {
         var player:Player = this.getPlayerByJID(jid);
         var team:Team = this.ruleset.getTeamFromID(player.teamID);
         if(Globals.CPU_TAKEOVER)
         {
            if(player)
            {
               this.ruleset.winnerOverride = this.ruleset.getNextTeamIDFrom(player.teamID);
               team.subPlayerWithAI(player);
               if(player)
               {
                  Globals.netController.selfNotification("Panda is taking over for " + player.playerData.profileName);
               }
               this.createRoundResults(this.ruleset.winnerOverride,true);
            }
         }
         else
         {
            if(player && Globals.gameState != GameState.GAMEOVER)
            {
               this.ruleset.winnerIndex = this.ruleset.getNextTeamIDFrom(player.teamID);
               this.ruleset.endGamePlay(0);
            }
            if(player)
            {
               // ExternalInterface.call('u.log', player.playerData.profileName + " forfeits the match.");
               this.endGame()
            }
         }
      }

      public function handleHostChange() : void
      {
         if(Globals.netController.playerRole == PlayerRoles.HOST && Globals.gameState != GameState.GAMEOVER)
         {
            this.ruleset.winnerIndex = this.localPlayer.teamID;
            this.ruleset.endGamePlay(0);
         }
      }

      public function processNetworkMessage(msg:NetworkMessage) : Boolean
      {
         var player:Player = this.getPlayerByJID(msg.fromPlayerJID);
         var selfMessage:Boolean = player == this.localPlayer;
         if(msg.msgID != MessageTypes.MSG_START_GAME)
         {
            if(msg.msgID == MessageTypes.MSG_END_GAME)
            {
               this.backToLobbyTime = msg.data.lobbyTime;
               this.endGame();
            }
            else
            {
               if(msg.msgID == MessageTypes.MSG_SPECTATOR_REQUEST_GAMESTATE && Globals.netController.playerRole == PlayerRoles.HOST)
               {
                  this.ruleset.sendSnapGameSnapshot(msg.fromPlayerJID);
                  return true;
               }
               if(msg.msgID == MessageTypes.MSG_HOST_RESPONSE_GAMESTATE)
               {
                  this.ruleset.applySnapShot(msg);
                  this._spectatorWaitingSnapshot = false;
               }
            }
         }
         this.ruleset.processNetworkMessage(msg);
         var messageHandled:Boolean = false;
         if(player)
         {
            messageHandled = player.processNetworkMessage(msg);
         }
         return messageHandled;
      }

      public function quitGame() : void
      {
         Globals.gameState = GameState.GAMEOVER;
         Globals.netController.quit();
      }
   }
}
