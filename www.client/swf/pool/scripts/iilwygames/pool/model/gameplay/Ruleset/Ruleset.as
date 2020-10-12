package iilwygames.pool.model.gameplay.Ruleset
{
   import de.polygonal.math.PM_PRNG;
   import flash.geom.Vector3D;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwy.gamenet.developer.RoundResults;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerRemote;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.CueStick;
   import iilwygames.pool.model.gameplay.GameSnapshot;
   import iilwygames.pool.model.gameplay.PocketData;
   import iilwygames.pool.model.gameplay.Team;
   import iilwygames.pool.model.gameplay.TurnConfirmation;
   import iilwygames.pool.model.gameplay.TurnData;
   import iilwygames.pool.model.gameplay.TurnRequest;
   import iilwygames.pool.model.physics.Body;
   import iilwygames.pool.model.physics.Wall;
   import iilwygames.pool.model.physics.World;
   import iilwygames.pool.network.MessageTypes;
   import iilwygames.pool.network.NetworkMessage;
   import flash.external.ExternalInterface;

   public class Ruleset
   {

      public static const TEAM_NONE:int = -1;

      public static const PLAYSTATE_IDLE:int = 0;

      public static const PLAYSTATE_SHOOTING:int = 2;

      public static const PLAYSTATE_IN_MOTION:int = 3;

      public static const PLAYSTATE_TURN_END:int = 4;

      public static const PLAYSTATE_GAMEOVER:int = 5;

      public static const GAMETYPE_EIGHTBALL:int = 0;

      public static const GAMETYPE_NINEBALL:int = 1;

      public static const GAMETYPE_EIGHTBALLBLITZ:int = 2;

      public static const GAMETYPE_FREEPLAY:int = 3;

      public static const GAMETYPE_FREEPLAY_NINEBALL:int = 4;

      public static const GAMETYPE_TUTORIAL_AIMING:int = 5;

      public static const GAMETYPE_TUTORIAL_BREAKSHOT:int = 6;

      public static const GAMETYPE_TRICKSHOTS:int = 7;

      public static const GAMETYPE_TRICKSHOTS_EDITOR:int = 8;

      public static const GAMETYPE_EDITOR:int = 9;


      public var playState:int;

      public var singlePlayer:Boolean;

      public var tableWidth:Number;

      public var tableHeight:Number;

      public var cueBall:Ball;

      public var firstBallHit:Ball;

      public var numOfRailsHit:uint;

      public var legalBreak:Boolean;

      public var breakHit:Boolean;

      public var suppressSounds:Boolean;

      public var turnNumber:int;

      public var pocketPositions:Vector.<Vector3D>;

      public var pocketRadius:Number;

      public var pocketRadiusSquared:Number;

      public var rails:Vector.<Wall>;

      public var numberOfTeams:int;

      public var teams:Vector.<Team>;

      public var currentTeam:Team;

      public var teamTurn:int;

      public var balls:Vector.<Ball>;

      public var quickWallCheck:Vector.<Wall>;

      public var cueStick:CueStick;

      public var winnerIndex:int;

      public var winnerOverride:int;

      public var rng:PM_PRNG;

      public var ballInHand:Boolean;

      public var choosingPocket:Boolean;

      public var ballsSankThisTurn:Vector.<Ball>;

      public var inputHistory:Vector.<InputData>;

      public var gameDesynced:Boolean;

      public var gameType:int;

      protected var _endGameTimer:Number;

      private var railSize:Number;

      protected var ballsPocketed:int;

      protected var snapShot:GameSnapshot;

      protected var turnConfirmations:Vector.<TurnConfirmation>;

      protected var turnRequests:Vector.<TurnRequest>;

      protected var gameStartTime:Number;

      protected var gameEndTime:Number;

      protected var currentTurnData:TurnData;

      protected var turnDataHistory:Vector.<TurnData>;

      private const POCKET_SIDE:int = 0;

      private const POCKET_CORNER:int = 1;

      private var _startTurnTimer:Number;

      private const TURN_START_DELAY:Number = 1.0;

      public function Ruleset(rngSeed:uint = 0, teamCount:int = 2)
      {
         super();
         this.numberOfTeams = teamCount;
         this.tableWidth = 2.54;
         this.tableHeight = 1.27;
         this.railSize = 0.01905 * 10;
         this.pocketRadius = 0.05715 * 0.5 * 1.5 * 1.15;
         this.pocketRadiusSquared = this.pocketRadius * this.pocketRadius;
         this.balls = new Vector.<Ball>();
         this.pocketPositions = new Vector.<Vector3D>();
         this.quickWallCheck = new Vector.<Wall>();
         this.ballsSankThisTurn = new Vector.<Ball>();
         this.rails = new Vector.<Wall>();
         this.cueStick = new CueStick();
         this.teams = new Vector.<Team>();
         for(var i:int = 0; i < this.numberOfTeams; i++)
         {
            this.teams[i] = new Team(i);
         }
         this.currentTeam = null;
         this.firstBallHit = null;
         this._endGameTimer = -1;
         this.numOfRailsHit = 0;
         this.turnNumber = 0;
         this.rng = new PM_PRNG();
         this.rng.seed = rngSeed;
         this.singlePlayer = false;
         this.ballInHand = false;
         this.choosingPocket = false;
         this.winnerIndex = TEAM_NONE;
         this.winnerOverride = TEAM_NONE;
         this.playState = PLAYSTATE_IDLE;
         this.breakHit = true;
         this.suppressSounds = true;
         this.ballsPocketed = 0;
         this.snapShot = new GameSnapshot();
         this.inputHistory = new Vector.<InputData>();
         this.legalBreak = false;
         this.gameDesynced = false;
         this.turnConfirmations = new Vector.<TurnConfirmation>();
         this.turnRequests = new Vector.<TurnRequest>();
         this.gameStartTime = 0;
         this.gameEndTime = 0;
         this._startTurnTimer = 0;
         this.turnDataHistory = new Vector.<TurnData>();
         this.initTable();
      }

      public function destroy() : void
      {
         var wall:Wall = null;
         var team:Team = null;
         var td:TurnData = null;
         for each(wall in this.quickWallCheck)
         {
            wall.destroy();
         }
         for each(team in this.teams)
         {
            team.destroy();
         }
         for each(td in this.turnDataHistory)
         {
            td.destroy();
         }
         this.snapShot.destroy();
         this.currentTeam = null;
         this.teams = null;
         this.rng = null;
         this.balls = null;
         this.cueBall = null;
         this.pocketPositions = null;
         this.quickWallCheck = null;
         this.ballsSankThisTurn = null;
         this.snapShot = null;
         this.inputHistory = null;
         this.turnConfirmations = null;
         this.turnRequests = null;
         this.rails = null;
         this.turnDataHistory = null;
      }

      public function stop() : void
      {
         this.inputHistory.length = 0;
         this.turnConfirmations.length = 0;
         this.turnRequests.length = 0;
      }

      public function initialize() : void
      {
         this.createBalls();
         this.teamTurn = Globals.model.breakingTeam;
         this._endGameTimer = -1;
         this.turnNumber = 0;
         this.ballInHand = true;
         Globals.soundManager.playSound("rack");
         this.gameStartTime = Globals.netController.syncedTime;
         this.startTurn();
      }

      public function addPlayerToTeam(player:Player, teamIndex:int) : void
      {
         var team:Team = null;
         if(teamIndex >= 0 && teamIndex < this.numberOfTeams)
         {
            team = this.teams[teamIndex];
            if(team)
            {
               team.addPlayer(player);
            }
         }
      }

      protected function initTable() : void
      {
         var wall:Wall = null;
         var i:int = 0;
         var j:int = 0;
         var pocket:Vector3D = null;
         var pocket2:Vector3D = null;
         var a:Number = 0.0808;
         var b:Number = 1.125;
         var c:Number = 1.108;
         var d:Number = 0.127;
         var wallX:Number = a;
         var wallY:Number = 0;
         var dX:Number = b + d;
         var dY:Number = this.tableHeight;
         for(i = 0; i < 2; i++)
         {
            for(j = 0; j < 2; j++)
            {
               wall = new Wall(wallX + i * dX + b * j,wallY + j * dY,wallX + i * dX + b * (1 - j),wallY + j * dY,false,true);
               Globals.model.world.addWall(wall);
               this.rails.push(wall);
            }
         }
         wallX = 0;
         wallY = a;
         dX = this.tableWidth;
         for(i = 0; i < 2; i++)
         {
            wall = new Wall(wallX + i * dX,wallY + (1 - i) * c,wallX + i * dX,wallY + c * i,false,true);
            Globals.model.world.addWall(wall);
            this.rails.push(wall);
         }
         var pocketLength:Number = this.pocketRadius * 2.5;
         var angle:Number = 2 * Math.PI - 142 * Math.PI / 180;
         var pocketVector:Vector3D = new Vector3D(Math.cos(angle),Math.sin(angle));
         pocketVector.normalize();
         var wallA:Wall = new Wall(a + pocketVector.x * pocketLength,pocketVector.y * pocketLength,a,0);
         angle = 142 * Math.PI / 180 + Math.PI / 2;
         var pocketVector2:Vector3D = new Vector3D(Math.cos(angle),Math.sin(angle));
         var wallB:Wall = new Wall(0,a,pocketVector2.x * pocketLength,a + pocketVector2.y * pocketLength);
         wall = new Wall(wallB.pointB.x,wallB.pointB.y,wallA.pointA.x,wallA.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         pocketVector.scaleBy(-pocketLength);
         pocketVector2.scaleBy(-pocketLength);
         wallA = new Wall(this.tableWidth,a + c,this.tableWidth + pocketVector2.x,a + c + pocketVector2.y);
         wallB = new Wall(this.tableWidth - a + pocketVector.x,this.tableHeight + pocketVector.y,this.tableWidth - a,this.tableHeight);
         wall = new Wall(wallA.pointB.x,wallA.pointB.y,wallB.pointA.x,wallB.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         angle = 142 * Math.PI / 180 + Math.PI;
         pocketVector = new Vector3D(Math.cos(angle),Math.sin(angle));
         angle = 5 * Math.PI / 2 - 142 * Math.PI / 180;
         pocketVector2 = new Vector3D(Math.cos(angle),Math.sin(angle));
         pocketVector.scaleBy(pocketLength);
         pocketVector2.scaleBy(pocketLength);
         wallA = new Wall(this.tableWidth - a,0,this.tableWidth - a + pocketVector.x,pocketVector.y);
         wallB = new Wall(this.tableWidth + pocketVector2.x,a + pocketVector2.y,this.tableWidth,a);
         wall = new Wall(wallA.pointB.x,wallA.pointB.y,wallB.pointA.x,wallB.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         pocketVector.scaleBy(-1);
         pocketVector2.scaleBy(-1);
         wallA = new Wall(pocketVector2.x,pocketVector2.y + this.tableHeight - a,0,this.tableHeight - a);
         wallB = new Wall(a,this.tableHeight,a + pocketVector.x,this.tableHeight + pocketVector.y);
         wall = new Wall(wallB.pointB.x,wallB.pointB.y,wallA.pointA.x,wallA.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         angle = 104 * Math.PI / 180 + Math.PI;
         pocketVector = new Vector3D(Math.cos(angle),Math.sin(angle));
         angle = 2 * Math.PI - 104 * Math.PI / 180;
         pocketVector2 = new Vector3D(Math.cos(angle),Math.sin(angle));
         pocketVector.scaleBy(pocketLength);
         pocketVector2.scaleBy(pocketLength);
         wallA = new Wall(a + b,0,a + b + pocketVector.x,pocketVector.y);
         wallB = new Wall(a + b + d + pocketVector2.x,pocketVector2.y,a + b + d,0);
         wall = new Wall(wallA.pointB.x,wallA.pointB.y,wallB.pointA.x,wallB.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         pocketVector.scaleBy(-1);
         pocketVector2.scaleBy(-1);
         wallA = new Wall(a + b + pocketVector2.x,this.tableHeight + pocketVector2.y,a + b,this.tableHeight);
         wallB = new Wall(a + b + d,this.tableHeight,a + b + d + pocketVector.x,pocketVector.y + this.tableHeight);
         wall = new Wall(wallB.pointB.x,wallB.pointB.y,wallA.pointA.x,wallA.pointA.y,true);
         Globals.model.world.addWall(wallA);
         Globals.model.world.addWall(wallB);
         Globals.model.world.addWall(wall);
         var pocketX:Number = 0;
         var pocketY:Number = 0;
         var dx:Number = this.tableWidth;
         var dy:Number = this.tableHeight;
         for(i = 0; i < 2; i++)
         {
            for(j = 0; j < 2; j++)
            {
               pocket = new Vector3D(pocketX + dx * j,pocketY + dy * i,0,this.POCKET_CORNER);
               this.pocketPositions.push(pocket);
            }
         }
         pocketX = this.tableWidth * 0.5;
         pocketY = -this.pocketRadius;
         dy = 2 * this.pocketRadius + this.tableHeight;
         for(i = 0; i < 2; i++)
         {
            pocket2 = new Vector3D(pocketX,pocketY + dy * i,0,this.POCKET_SIDE);
            this.pocketPositions.push(pocket2);
         }
         wall = new Wall(0,0,this.tableWidth,0);
         this.quickWallCheck.push(wall);
         wall = new Wall(this.tableWidth,0,this.tableWidth,this.tableHeight);
         this.quickWallCheck.push(wall);
         wall = new Wall(this.tableWidth,this.tableHeight,0,this.tableHeight);
         this.quickWallCheck.push(wall);
         wall = new Wall(0,this.tableHeight,0,0);
         this.quickWallCheck.push(wall);
      }

      protected function createBalls() : void
      {
         this.rackSet();
      }

      protected function rackSet() : void
      {
         this.breakHit = true;
         this.suppressSounds = true;
         this.legalBreak = false;
         this.ballsPocketed = 0;
         this.ballsSankThisTurn.length = 0;
      }

      protected function spotBall(ballNumber:int) : void
      {
         var spottedBall:Ball = null;
         var currentBall:Ball = null;
         var collision:Boolean = false;
         var yval:Number = NaN;
         var xdiff:Number = NaN;
         var numBalls:int = this.balls.length;
         var desiredX:Number = this.tableWidth * 0.75;
         var desiredY:Number = this.tableHeight * 0.5;
         var world:World = Globals.model.world;
         var validPosition:Boolean = false;
         var directionX:Number = 1.00005;
         for(var i:int = 0; i < numBalls; i++)
         {
            currentBall = this.balls[i];
            if(currentBall.ballNumber == ballNumber)
            {
               currentBall.active = true;
               currentBall.resetBall();
               spottedBall = currentBall;
            }
         }
         spottedBall.position.x = desiredX;
         spottedBall.position.y = desiredY;
         this.balls.push(this.cueBall);
         while(validPosition == false)
         {
            validPosition = true;
            collision = false;
            for(i = 0; i < numBalls; i++)
            {
               currentBall = this.balls[i];
               if(currentBall != spottedBall && currentBall.active)
               {
                  collision = world.circleCollision(currentBall,spottedBall);
                  if(collision)
                  {
                     validPosition = false;
                     yval = desiredY - currentBall.position.y;
                     yval = yval * yval;
                     xdiff = 4 * currentBall.radiusSquared - yval;
                     xdiff = Math.sqrt(xdiff);
                     desiredX = currentBall.position.x + xdiff * directionX;
                     if(desiredX > this.tableWidth - spottedBall.radius)
                     {
                        directionX = -directionX;
                        desiredX = this.tableWidth * 0.75;
                     }
                     spottedBall.position.x = desiredX;
                     break;
                  }
               }
            }
            if(validPosition)
            {
               trace("hooray! found a spot");
            }
         }
         this.balls.pop();
      }

      public function getCurrentPlayerUp() : Player
      {
         return this.teams[this.teamTurn].getCurrentPlayerUp();
      }

      protected function startTurn() : void
      {
         var b:Ball = null;
         if(this.playState == Ruleset.PLAYSTATE_GAMEOVER)
         {
            return;
         }
         this.ballsSankThisTurn.length = 0;
         this.currentTeam = this.teams[this.teamTurn];
         if(0)
         {
            this._startTurnTimer = this.TURN_START_DELAY;
         }
         this.playState = PLAYSTATE_SHOOTING;
         this.firstBallHit = null;
         this.numOfRailsHit = 0;
         this.turnNumber++;

         if(this.cueBall.active == false)
         {
            this.cueBall.active = true;
            this.cueBall.position.x = this.tableWidth * 0.25;
            this.cueBall.position.y = this.tableHeight * 0.5;
            this.cueBall.reset();
            this.cueBall.bodyState = Body.STATE_REST;
            this.cueBall.ballState = Ball.BALL_STATE_ACTIVE;
            Globals.view.table.resetBall(this.cueBall);
         }
         var currPlayer:Player = this.getCurrentPlayerUp();
         if(currPlayer)
         {
            if(Globals.FACEBOOK_BUILD)
            {
               Globals.productManager.onTurnStart(currPlayer);
            }
            if(this._startTurnTimer == 0)
            {
               this.initTurnForPlayer(currPlayer);
            }
         }
         this.snapShot.storeSnapshot(this);
         for(var i:int = 0; i < this.balls.length; i++)
         {
            b = this.balls[i];
            b.railsHit = 0;
            b.railsHitBeforeFirstHit = 0;
         }
         this.currentTurnData = new TurnData();
         this.currentTurnData.turnIndex = this.turnNumber;
         this.currentTurnData.ballType = this.currentTeam.teamBallType;
         if(!this.legalBreak)
         {
            this.currentTurnData.isBreak = true;
         }
         if(currPlayer)
         {
            this.currentTurnData.playerID = currPlayer.playerData.playerJid;
         }
      }

      protected function initTurnForPlayer(player:Player) : void
      {
         var name:String = null;
         this.cueStick.startTurnFor(player);
         player.startPlayerTurn(this.singlePlayer);
         if(player.playerData)
         {
            name = player.playerData.profileName;
         }
         if(name && !Globals.FACEBOOK_BUILD)
         {
         if(Globals.netController.playerRole == PlayerRoles.HOST){

             ExternalInterface.call("emit",{
               "id":"pool",
               "f":"chat",
               "d":{'turn':name }
            });
          }
         }
      }

      protected function endTurn() : void
      {
         var turnEndRequest:NetworkMessage = null;
         var data:* = undefined;
         if(!this.singlePlayer)
         {
            this.playState = PLAYSTATE_TURN_END;
         }
         if(Globals.FACEBOOK_BUILD)
         {
            Globals.productManager.onTurnEnd();
         }
         this.winnerIndex = this.evaluateGame();
         if(this.winnerIndex == TEAM_NONE)
         {
            this.evaluateTeamUp();
            if(this.singlePlayer || Globals.model.vsCPU)
            {
               this.processTurnData();
               this.startTurn();
            }
         }
         else if(this.singlePlayer || Globals.model.vsCPU)
         {
            this.processTurnData();
            this.endGamePlay();
         }
         if(Globals.netController.playerRole == PlayerRoles.PLAYER && !this.singlePlayer)
         {
            turnEndRequest = new NetworkMessage(MessageTypes.MSG_TURN_REQUEST);
            data = new Object();
            data.tn = this.turnNumber;
            data.tt = this.teamTurn;
            data.wi = this.winnerIndex;
            data.cpx = this.cueBall.position.x;
            data.cpy = this.cueBall.position.y;
            turnEndRequest.data = data;
            Globals.netMediator.sendNetworkMessage(turnEndRequest);
         }
      }

      protected function getNextTeamID() : int
      {
         var inc:int = this.teamTurn + 1;
         var nextTeamID:int = inc % this.numberOfTeams;
         return nextTeamID;
      }

      public function getNextTeamIDFrom(teamID:int) : int
      {
         var inc:int = teamID + 1;
         var next:int = inc % this.numberOfTeams;
         return next;
      }

      public function getTeamFromID(teamID:int) : Team
      {
         var team:Team = this.teams[teamID];
         return team;
      }

      protected function evaluateTeamUp() : void
      {
      }

      protected function evaluateGame() : int
      {
         return TEAM_NONE;
      }

      public function endGamePlay(timerOverride:Number = 4.0) : void
      {
         if(this.playState == PLAYSTATE_GAMEOVER)
         {
            return;
         }
         this._endGameTimer = timerOverride;
         this.playState = PLAYSTATE_GAMEOVER;
         this.gameEndTime = Globals.netController.syncedTime;
      }

      protected function processTurnData() : void
      {
         if(Globals.EDITOR_MODE)
         {
            return;
         }
         this.currentTurnData.ballsPocketed;
         var resultFlag:int = TurnData.RESULT_SUCCESS;
         if(this.winnerIndex != Ruleset.TEAM_NONE)
         {
            resultFlag = TurnData.RESULT_WINNER;
         }
         else if(this.ballInHand)
         {
            resultFlag = TurnData.RESULT_FOUL;
         }
         else if(this.ballsSankThisTurn.length == 0)
         {
            resultFlag = TurnData.RESULT_NO_POCKET;
         }
         this.currentTurnData.turnResult = resultFlag;
         this.turnDataHistory.push(this.currentTurnData);
         this.currentTurnData = null;
      }

      public function processEndGame() : void
      {
         var record:Boolean = true;
         if(this.winnerOverride != Ruleset.TEAM_NONE)
         {
            this.winnerIndex = this.winnerOverride;
            record = false;
         }
         var result:RoundResults = Globals.model.createRoundResults(this.winnerIndex,record);
         var winningTeam:Team = this.teams[this.winnerIndex];
         var name:String = winningTeam.getCurrentPlayerUp().playerData.profileName;
         if(name  && !this.singlePlayer )
         {
            var losingTeam:Team = this.teams[this.getNextTeamID()];
            var loser:String = losingTeam.getCurrentPlayerUp().playerData.profileName;

            ExternalInterface.call("emit",{
               "id":"pool",
               "f":"chat",
               "d":{'wins':name, 'loser': loser}
            });

         }

         //Globals.view.showGameOver(result);
      }

      public function isGameOver() : Boolean
      {
         return this._endGameTimer == 0;
      }

      public function turnInPlay() : void
      {
         if(this.playState != PLAYSTATE_GAMEOVER)
         {
            this.playState = PLAYSTATE_IN_MOTION;
         }
      }

      public function update(et:Number) : void
      {
         var inMotion:Boolean = false;
         var ball:Ball = null;
         var tr:TurnRequest = null;
         var synced:Boolean = false;
         var response:NetworkMessage = null;
         var tc:TurnConfirmation = null;
         var player:Player = null;
         this.cueStick.update(et);
         if(this.playState == PLAYSTATE_IN_MOTION)
         {
            inMotion = false;
            for each(ball in Globals.model.world.balls)
            {
               if(ball.bodyState != Body.STATE_REST && ball.ballState < Ball.BALL_STATE_ROLLINGONRAIL)
               {
                  inMotion = true;
                  break;
               }
            }
            if(!inMotion)
            {
               this.endTurn();
            }
         }
         else if(this.playState == PLAYSTATE_TURN_END)
         {
            if(Globals.netController.playerRole == PlayerRoles.HOST && this.turnRequests.length)
            {
               tr = this.turnRequests.shift();
               synced = true;
               if(tr.turnNumber != this.turnNumber || tr.teamTurn != this.teamTurn || tr.winnerIndex != this.winnerIndex)
               {
                  synced = false;
               }
               if(!synced)
               {
                  this.gameDesynced = true;
                  this.sendSnapGameSnapshot();
               }
               else
               {
                  response = new NetworkMessage(MessageTypes.MSG_TURN_RESPONSE);
                  response.data = new Object();
                  response.data.valid = true;
                  response.data.tn = this.turnNumber;
                  response.data.tt = this.teamTurn;
                  response.data.wi = this.winnerIndex;
                  Globals.netMediator.sendNetworkMessage(response);
               }
            }
            else if(this.turnConfirmations.length)
            {
               tc = this.turnConfirmations[0];
               if(tc.turnNumber == this.turnNumber && tc.teamTurn == this.teamTurn && tc.winnerIndex == this.winnerIndex)
               {
                  this.turnConfirmations.shift();
                  this.processTurnData();
                  if(this.winnerIndex == TEAM_NONE)
                  {
                     this.startTurn();
                  }
                  else
                  {
                     this.endGamePlay();
                  }
               }
            }
         }
         else if(this.playState == PLAYSTATE_GAMEOVER)
         {
            if(this._endGameTimer > 0)
            {
               this._endGameTimer = this._endGameTimer - et;
               if(this._endGameTimer < 0)
               {
                  this._endGameTimer = 0;
               }
            }
         }
         if(this.breakHit == false)
         {
            this.suppressSounds = false;
         }
         if(this._startTurnTimer > 0)
         {
            this._startTurnTimer = this._startTurnTimer - et;
            if(this._startTurnTimer <= 0)
            {
               this._startTurnTimer = 0;
               player = this.currentTeam.getCurrentPlayerUp();
               if(player)
               {
                  this.initTurnForPlayer(player);
               }
            }
         }
      }

      public function updateFixed(et:Number) : void
      {
         var pocket:Vector3D = null;
         var ball:Ball = null;
         var i:int = 0;
         var j:int = 0;
         var xterm:Number = NaN;
         var yterm:Number = NaN;
         var distSquared:Number = NaN;
         var numBalls:int = this.balls.length;
         if(this.playState == PLAYSTATE_IN_MOTION)
         {
            for(i = 0; i <= numBalls; i++)
            {
               if(i < numBalls)
               {
                  ball = this.balls[i];
               }
               else
               {
                  ball = this.cueBall;
               }
               if(ball.active != false)
               {
                  for(j = 0; j < 6; j++)
                  {
                     pocket = this.pocketPositions[j];
                     xterm = pocket.x - ball.position.x;
                     yterm = pocket.y - ball.position.y;
                     distSquared = xterm * xterm + yterm * yterm;
                     if(distSquared < this.pocketRadiusSquared)
                     {
                        ball.pocketBall(pocket,this.ballsPocketed);
                        this.onBallPocketed(ball,pocket);
                     }
                  }
               }
            }
         }
      }

      protected function onBallPocketed(ball:Ball, pocket:Vector3D) : void
      {
         ball.active = false;
         this.ballsSankThisTurn.push(ball);
         Globals.soundManager.playSound("pocket1",0.5);
         var pocketData:PocketData = new PocketData();
         pocketData.ballNumber = ball.ballNumber;
         pocketData.pocketType = pocket.w;
         if(!Globals.EDITOR_MODE)
         {
            this.currentTurnData.ballsPocketed.push(pocketData);
         }
         if(ball.ballType != Ball.BALL_CUE)
         {
            this.ballsPocketed++;
         }
      }

      public function insertInputData(id:InputData) : void
      {
         id.turnIndex = this.turnNumber;
         id.inputIndex = this.inputHistory.length;
         this.inputHistory.push(id);
      }

      public function sendSnapGameSnapshot(playerJID:String = null) : void
      {
         var id:InputData = null;
         var data:* = undefined;
         var msg:NetworkMessage = this.snapShot.packageSnapShot();
         var idArray:Array = [];
         for(var i:int = 0; i < this.inputHistory.length; i++)
         {
            id = this.inputHistory[i];
            if(id.turnIndex == this.turnNumber)
            {
               data = new Object();
               data.type = id.type;
               data.mx = id.mouseX;
               data.my = id.mouseY;
               data.cx = id.cueX;
               data.cy = id.cueY;
               data.ti = id.turnIndex;
               data.ii = id.inputIndex;
               idArray.push(data);
            }
         }
         msg.data.inputData = idArray;
         Globals.netMediator.sendNetworkMessage(msg,playerJID);
      }

      public function applySnapShot(msg:NetworkMessage) : void
      {
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var isActive:Boolean = false;
         var ball:Ball = null;
         var idArray:Array = null;
         var j:int = 0;
         var data:* = undefined;
         var idata:InputData = null;
         var positions:Array = msg.data.pos;
         var ballIndex:int = 0;
         for(var i:int = 0; i < positions.length; i = i + 3)
         {
            xpos = positions[i];
            ypos = positions[i + 1];
            isActive = positions[i + 2] > 0?Boolean(true):Boolean(false);
            if(ballIndex < this.balls.length)
            {
               ball = this.balls[ballIndex];
               ball.resetBall();
               ball.position.x = xpos;
               ball.position.y = ypos;
               ball.active = isActive;
               if(!isActive)
               {
                  ball.initPocketBall(this.ballsPocketed++);
               }
            }
            else
            {
               this.cueBall.position.x = xpos;
               this.cueBall.position.y = ypos;
            }
            ballIndex++;
         }
         this.teamTurn = msg.data.tu;
         this.ballInHand = msg.data.ih > 0?Boolean(true):Boolean(false);
         var pl:PlayerRemote = this.getCurrentPlayerUp() as PlayerRemote;
         if(pl)
         {
            idArray = msg.data.inputData;
            for(j = 0; j < idArray.length; j++)
            {
               data = idArray[j] as Object;
               if(data)
               {
                  idata = new InputData(data.type);
                  idata.mouseX = data.mx;
                  idata.mouseY = data.my;
                  idata.cueX = data.cx;
                  idata.cueY = data.cy;
                  idata.turnIndex = data.ti;
                  idata.inputIndex = data.ii;
                  pl.addToInputQueue(idata);
               }
            }
         }
         this.turnNumber = msg.data.ti - 1;
         this.startTurn();
      }

      public function processNetworkMessage(msg:NetworkMessage) : void
      {
         var data:* = undefined;
         var tr:TurnRequest = null;
         var tc:TurnConfirmation = null;
         if(msg.msgID == MessageTypes.MSG_TURN_REQUEST && Globals.netController.playerRole == PlayerRoles.HOST)
         {
            data = msg.data;
            tr = new TurnRequest();
            tr.teamTurn = data.tt;
            tr.turnNumber = data.tn;
            tr.winnerIndex = data.wi;
            tr.cueX = data.cueX;
            tr.cueY = data.cueY;
            this.turnRequests.push(tr);
         }
         else if(msg.msgID == MessageTypes.MSG_TURN_RESPONSE)
         {
            tc = new TurnConfirmation();
            tc.teamTurn = msg.data.tt;
            tc.turnNumber = msg.data.tn;
            tc.winnerIndex = msg.data.wi;
            this.turnConfirmations.push(tc);
         }
         else if(msg.msgID == MessageTypes.MSG_HOST_RESPONSE_GAMESTATE && Globals.netController.playerRole != PlayerRoles.SPECTATOR)
         {
            this.gameDesynced = true;
            this.winnerIndex = TEAM_NONE;
            // ExternalInterface.call("u.log", 'There was a problem with the game! 1');
            // ExternalInterface.call("u.log","There was a problem with the game. The last turn will be retaken. Final game results will not be recorded so no coins will be lost. Sorry for the inconvenience.");
            // ExternalInterface.call("u.log", 'There was a problem with the game! 2');
         }
      }

      public function processUserInput(idata:InputData) : void
      {
         var mousedownMSG:NetworkMessage = null;
         var mouseupMSG:NetworkMessage = null;
         var sendDataX:Number = int(idata.mouseX * 10000);
         var sendDataY:Number = int(idata.mouseY * 10000);
         var cueDataX:Number = int(idata.cueX * 10000);
         var cueDataY:Number = int(idata.cueY * 10000);
         idata.mouseX = sendDataX / 10000;
         idata.mouseY = sendDataY / 10000;
         idata.cueX = cueDataX / 10000;
         idata.cueY = cueDataY / 10000;
         var validInput:Boolean = this.cueStick.processInputData(idata);
         if(validInput)
         {
            Globals.model.ruleset.insertInputData(idata);
            if(idata.type == InputData.ID_MOUSE_DOWN)
            {
               mousedownMSG = new NetworkMessage(MessageTypes.MSG_MOUSE_DOWN);
               mousedownMSG.data = {
                  "x":sendDataX,
                  "y":sendDataY,
                  "ti":idata.turnIndex
               };
               Globals.netMediator.sendNetworkMessage(mousedownMSG);
            }
            else if(idata.type == InputData.ID_MOUSE_UP)
            {
               mouseupMSG = new NetworkMessage(MessageTypes.MSG_MOUSE_UP);
               mouseupMSG.data = {
                  "x":sendDataX,
                  "y":sendDataY,
                  "cx":cueDataX,
                  "cy":cueDataY,
                  "ti":idata.turnIndex
               };
               Globals.netMediator.sendNetworkMessage(mouseupMSG);
            }
         }
      }
   }
}
