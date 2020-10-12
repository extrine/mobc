package iilwygames.pool.model
{
   import de.polygonal.math.PM_PRNG;
   import flash.geom.Vector3D;
   import iilwy.gamenet.model.PlayerData;
   import iilwygames.pool.ai.Move;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Eightball;
   import iilwygames.pool.model.gameplay.Ruleset.NineBall;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.model.gameplay.Team;
   import iilwygames.pool.model.physics.Wall;
   
   public class PlayerCPU extends Player
   {
       
      
      private var _mouseDown:InputData;
      
      private var _mouseUp:InputData;
      
      private var _moveCache:Vector.<Move>;
      
      private var _pockets:Vector.<Vector3D>;
      
      private var _railNormals:Vector.<Vector3D>;
      
      private var _moveCanidates:Vector.<Move>;
      
      private var _ghostBallPosition:Vector3D;
      
      private var _bestMove:Move;
      
      private var _secondBestMove:Move;
      
      private var _balls:Vector.<Ball>;
      
      private var _cueBall:Ball;
      
      private var _ballRadius:Number;
      
      private var _ballDiameter:Number;
      
      private var _ballDiameterSquared:Number;
      
      private const MOVE_CACHE_SIZE:int = 375;
      
      private const POCKET_SIDE:int = 0;
      
      private const POCKET_CORNER:int = 1;
      
      private const RAIL_OFFSET:Number = 0.028575;
      
      private const DEBUG_MODE:Boolean = false;
      
      private const SAFETY_DIRECT:int = 0;
      
      private const SAFETY_KICK:int = 1;
      
      private var _rng:PM_PRNG;
      
      private var _gaussianNumCache:Boolean;
      
      private var _nextGaussianNumber:Number;
      
      private var _shotVariance:Number;
      
      private const SAMPLE_SIZE:Number = 0.1143;
      
      private var _cuePositionScores:Vector.<Number>;
      
      private var _numColumns:int;
      
      private var _numRows:int;
      
      private const PI:Number = 3.141592653589793;
      
      private const TWO_PI:Number = 6.283185307179586;
      
      private const STATE_IDLE:int = -1;
      
      private const STATE_TABLE_EVAL:int = 0;
      
      private const STATE_BALLINHAND:int = 1;
      
      private const STATE_AIMING:int = 2;
      
      private const STATE_SHOOTING_DOWN:int = 3;
      
      private const STATE_SHOOTING_UP:int = 4;
      
      private const STATE_WANDER:int = 5;
      
      private const STATE_WAITING:int = 6;
      
      private var _currentState:int;
      
      protected var desiredBoardMouseX:Number;
      
      protected var desiredBoardMouseY:Number;
      
      private var _tableWidth:Number;
      
      private var _tableHeight:Number;
      
      private var _biaCuePos:Vector3D;
      
      private var _timer:Number;
      
      private var _randomCount:Number;
      
      private var _theta:Number;
      
      private var _desiredTheta:Number;
      
      private var _mouseUpdateTimer:Number;
      
      private const MOUSE_UPDATE_INTERVAL:Number = 0.25;
      
      public function PlayerCPU()
      {
         var i:int = 0;
         var j:int = 0;
         var move:Move = null;
         var rail_value:Number = NaN;
         var railNormalVector:Vector3D = null;
         var padding:Number = NaN;
         var pocket:Vector3D = null;
         var cornerPocket:Vector3D = null;
         super();
         this._mouseDown = new InputData(InputData.ID_MOUSE_DOWN);
         this._mouseUp = new InputData(InputData.ID_MOUSE_UP);
         playerData = new PlayerData();
         if(playerData)
         {
            playerData.profileName = "Deep Green";
            playerData.playerJid = "0";
            playerData.profileAge = "42";
            playerData.gameLevels = {};
            playerData.gameRatings = "2000";
            playerData.profileLocation = "NYC";
         }
         this._moveCache = new Vector.<Move>();
         this._moveCanidates = new Vector.<Move>();
         this._pockets = new Vector.<Vector3D>();
         this._railNormals = new Vector.<Vector3D>();
         for(i = 0; i < this.MOVE_CACHE_SIZE; i++)
         {
            move = new Move();
            this._moveCache.push(move);
         }
         var rs:Ruleset = Globals.model.ruleset;
         var tableWidth:Number = rs.tableWidth;
         var tableHeight:Number = rs.tableHeight;
         var ballRadius:Number = 0.05715 * 0.5;
         this._tableWidth = tableWidth;
         this._tableHeight = tableHeight;
         this._numColumns = int(tableWidth / this.SAMPLE_SIZE);
         this._numRows = int(tableHeight / this.SAMPLE_SIZE);
         this._cuePositionScores = new Vector.<Number>(this._numRows * this._numColumns);
         for(i = 0; i < 2; i++)
         {
            for(j = 0; j < 2; j++)
            {
               rail_value = (1 - i) * (j * tableWidth) + i * (j * tableHeight);
               railNormalVector = new Vector3D(i - j,1 - (j + i),0,rail_value);
               padding = (railNormalVector.x + railNormalVector.y) * this.RAIL_OFFSET;
               railNormalVector.w = railNormalVector.w + padding;
               this._railNormals.push(railNormalVector);
            }
         }
         var pocket_x:Number = ballRadius;
         var pocket_y:Number = 0;
         for(i = 0; i < 2; i++)
         {
            pocket = new Vector3D(0.5 * tableWidth,i * tableHeight,0,this.POCKET_SIDE);
            this._pockets.push(pocket);
         }
         tableHeight = tableHeight - 2 * ballRadius;
         tableWidth = tableWidth - 2 * ballRadius;
         pocket_y = ballRadius;
         for(i = 0; i < 2; i++)
         {
            for(j = 0; j < 2; j++)
            {
               cornerPocket = new Vector3D(pocket_x + i * tableWidth,pocket_y + j * tableHeight,0,this.POCKET_CORNER);
               this._pockets.push(cornerPocket);
            }
         }
         this._ghostBallPosition = new Vector3D();
         this._biaCuePos = new Vector3D();
         this._balls = rs.balls;
         this._cueBall = rs.cueBall;
         this._ballRadius = this._cueBall.radius;
         this._ballDiameter = this._cueBall.radius * 2;
         this._ballDiameterSquared = this._cueBall.radiusSquared * 4;
         this._rng = new PM_PRNG();
         this._gaussianNumCache = false;
         this._nextGaussianNumber = 0;
         this._shotVariance = 0;
         this._currentState = this.STATE_IDLE;
         this.desiredBoardMouseX = 0;
         this.desiredBoardMouseY = 0;
         this._timer = 0;
         this._randomCount = 0;
         this._bestMove = null;
         this._theta = Math.random() * this.TWO_PI;
         this._theta = this.normalizeAngleRadians(this._theta);
         this._desiredTheta = this._theta;
         this._mouseUpdateTimer = 0;
      }
      
      public function setRngSeed(seed:int) : void
      {
         this._rng.seed = seed;
      }
      
      override public function destroy() : void
      {
         var m:Move = null;
         var move:Move = null;
         for each(m in this._moveCanidates)
         {
            this.returnMoveToCache(m);
         }
         for each(move in this._moveCache)
         {
            move.destroy();
         }
         this._pockets.length = 0;
         this._railNormals.length = 0;
         this._railNormals = null;
         this._pockets = null;
         this._mouseDown = null;
         this._mouseUp = null;
         this._moveCache = null;
         this._moveCanidates = null;
         this._ghostBallPosition = null;
         this._balls = null;
         this._cueBall = null;
         this._rng = null;
         this._cuePositionScores = null;
         this._biaCuePos = null;
         this._bestMove = null;
         this._secondBestMove = null;
         super.destroy();
      }
      
      protected function updateMouse(et:Number) : void
      {
         var angleDifference:Number = this._desiredTheta - this._theta;
         angleDifference = this.normalizeAngleRadians(angleDifference);
         this._theta = this._theta + angleDifference * et * 6;
         this._theta = this.normalizeAngleRadians(this._theta);
         mousePosition.x = mousePosition.x + (this.desiredBoardMouseX - mousePosition.x) * et * 5;
         mousePosition.y = mousePosition.y + (this.desiredBoardMouseY - mousePosition.y) * et * 5;
         this._mouseUpdateTimer = this._mouseUpdateTimer + et;
         if(this._mouseUpdateTimer > this.MOUSE_UPDATE_INTERVAL)
         {
            this._mouseUpdateTimer = 0;
            if(this._currentState != this.STATE_BALLINHAND && this._currentState != this.STATE_SHOOTING_DOWN && this._currentState != this.STATE_SHOOTING_UP)
            {
               this.desiredBoardMouseX = this.getMouseXfrom(this._theta);
               this.desiredBoardMouseY = this.getMouseYfrom(this._theta);
            }
         }
      }
      
      override public function update(et:Number) : void
      {
         var difference:Number = NaN;
         var rt:Number = NaN;
         var move:Move = null;
         var wholeValue:int = 0;
         var randomBall:Ball = null;
         var count:int = 0;
         var randomTime:Number = NaN;
         var range:Number = NaN;
         this.updateMouse(et);
         if(this._timer > 0)
         {
            this._timer = this._timer - et;
            if(this._timer < 0)
            {
               this._timer = 0;
            }
         }
         if(this._currentState == this.STATE_BALLINHAND)
         {
            this.desiredBoardMouseX = this._biaCuePos.x;
            this.desiredBoardMouseY = this._biaCuePos.y;
            if(this._timer == 0)
            {
               this._mouseDown.turnIndex = Globals.model.ruleset.turnNumber;
               this._mouseDown.mouseX = this._biaCuePos.x;
               this._mouseDown.mouseY = this._biaCuePos.y;
               Globals.model.ruleset.cueStick.processInputData(this._mouseDown);
               this._currentState = this.STATE_AIMING;
               this.evaluateMoves();
               this.calculateCueVelocity(this._bestMove);
               this.calculateShotNoise(this._bestMove);
               this.rotateVectorBy(this._shotVariance,this._bestMove.cueVelocity);
               this.generateInputs(this._bestMove.cueVelocity);
               this._desiredTheta = this.getCueAngleFromMousePos(this._mouseDown.mouseX,this._mouseDown.mouseY);
               this._timer = 1.5;
            }
         }
         else if(this._currentState == this.STATE_WAITING)
         {
            if(this._timer == 0)
            {
               difference = -1;
               if(this._secondBestMove)
               {
                  difference = this._bestMove.moveScore - this._secondBestMove.moveScore;
               }
               if(this._bestMove.moveScore > 5 || !this._secondBestMove)
               {
                  this._currentState = this.STATE_TABLE_EVAL;
                  this._timer = 1.5 + Math.random();
               }
               else
               {
                  this._currentState = this.STATE_WANDER;
                  rt = Math.random() * 2 / this._bestMove.moveScore;
                  rt = rt > 4?Number(4):Number(rt);
                  this._timer = 1.25 + rt;
               }
            }
         }
         else if(this._currentState == this.STATE_WANDER)
         {
            move = this._secondBestMove;
            if(!move)
            {
               move = this._moveCanidates[int(Math.random() * this._moveCanidates.length)];
            }
            if(move.shotType == Move.TYPE_DIRECT)
            {
               this.generateInputs(move.cueVelocity);
               this._desiredTheta = this.getCueAngleFromMousePos(this._mouseDown.mouseX,this._mouseDown.mouseY);
            }
            else
            {
               wholeValue = int(this._timer);
               if(wholeValue & 1)
               {
                  randomBall = this._balls[int(Math.random() * this._balls.length)];
                  count = 0;
                  while(!randomBall.active && count < 100)
                  {
                     randomBall = this._balls[int(Math.random() * this._balls.length)];
                     count++;
                  }
                  this._desiredTheta = this.getCueAngleFromMousePos(randomBall.position.x,randomBall.position.y);
               }
            }
            if(this._timer == 0)
            {
               this._currentState = this.STATE_TABLE_EVAL;
               this._timer = 0.5;
            }
         }
         else if(this._currentState == this.STATE_TABLE_EVAL)
         {
            if(this._timer == 0)
            {
               this._currentState = this.STATE_AIMING;
               this.calculateCueVelocity(this._bestMove);
               this.calculateShotNoise(this._bestMove);
               this.rotateVectorBy(this._shotVariance,this._bestMove.cueVelocity);
               this.generateInputs(this._bestMove.cueVelocity);
               this._desiredTheta = this.normalizeAngleRadians(this.getCueAngleFromMousePos(this._mouseDown.mouseX,this._mouseDown.mouseY) + this.getValueWithGaussianNoise(0,0.25));
               randomTime = Math.random() * 2 / this._bestMove.moveScore;
               randomTime = randomTime > 4?Number(4):Number(randomTime);
               this._timer = 1.75 + randomTime;
            }
         }
         else if(this._currentState == this.STATE_AIMING)
         {
            if(this._timer == 0)
            {
               this._currentState = this.STATE_SHOOTING_DOWN;
               this._timer = 0.5 + Math.random();
            }
            else if(this._timer <= 0.75)
            {
               this._desiredTheta = this.getCueAngleFromMousePos(this._mouseDown.mouseX,this._mouseDown.mouseY);
            }
            else if(this._timer <= 2)
            {
               range = Math.random() * 0.4 - 0.2;
               this._desiredTheta = this.normalizeAngleRadians(this.getCueAngleFromMousePos(this._mouseDown.mouseX,this._mouseDown.mouseY) + range);
            }
         }
         else if(this._currentState == this.STATE_SHOOTING_DOWN)
         {
            if(this._timer == 0)
            {
               mousePosition.x = this._mouseDown.mouseX;
               mousePosition.y = this._mouseDown.mouseY;
               Globals.model.ruleset.cueStick.processInputData(this._mouseDown);
               this._timer = 0.5 + Math.random();
               this._currentState = this.STATE_SHOOTING_UP;
            }
            else
            {
               this.desiredBoardMouseX = this._mouseDown.mouseX;
               this.desiredBoardMouseY = this._mouseDown.mouseY;
            }
         }
         else if(this._currentState == this.STATE_SHOOTING_UP)
         {
            if(this._timer == 0)
            {
               Globals.model.ruleset.cueStick.processInputData(this._mouseUp);
               this._currentState = this.STATE_IDLE;
               this.clearMoves();
            }
            else
            {
               this.desiredBoardMouseX = this._mouseUp.mouseX;
               this.desiredBoardMouseY = this._mouseUp.mouseY;
            }
         }
      }
      
      private function clearMoves() : void
      {
         var move:Move = null;
         for each(move in this._moveCanidates)
         {
            this.returnMoveToCache(move);
         }
         this._moveCanidates.length = 0;
      }
      
      override public function startPlayerTurn(isSinglePlayer:Boolean) : void
      {
         super.startPlayerTurn(isSinglePlayer);
         var rs:Ruleset = Globals.model.ruleset;
         this._bestMove = null;
         this._secondBestMove = null;
         if(rs.breakHit)
         {
            this.breakShot();
            this.evaluateMoves();
            this._currentState = this.STATE_WAITING;
            this._timer = 1 + Math.random() * 2;
         }
         else if(rs.ballInHand)
         {
            this.placeCueBallPosition();
            this._currentState = this.STATE_BALLINHAND;
            this._timer = 1.2 + Math.random();
         }
         else
         {
            this.makeShotDecision();
            this.evaluateMoves();
            this._timer = Math.random() * 2;
            this._currentState = this.STATE_WAITING;
         }
      }
      
      override public function endPlayerTurn(withHit:Boolean) : void
      {
         super.endPlayerTurn(withHit);
      }
      
      private function placeCueBallPosition() : void
      {
         var ball:Ball = null;
         var bestScore:Number = NaN;
         var bestIndex:int = 0;
         var x:int = 0;
         var grid_x:int = 0;
         var grid_y:int = 0;
         var i:int = 0;
         var j:int = 0;
         var grid_index:int = 0;
         var y:int = 0;
         var index:int = 0;
         var value:Number = NaN;
         var bestMove:Move = null;
         var move:Move = null;
         var rs:Ruleset = Globals.model.ruleset;
         var isEightball:Boolean = rs.gameType == Ruleset.GAMETYPE_EIGHTBALL;
         for each(ball in this._balls)
         {
            if(ball.active)
            {
               grid_x = int(ball.position.x / this.SAMPLE_SIZE);
               grid_y = int(ball.position.y / this.SAMPLE_SIZE);
               for(i = 0; i < 2; i++)
               {
                  for(j = 0; j < 2; j++)
                  {
                     if(grid_x < this._numColumns - 1 && grid_y < this._numRows - 1)
                     {
                        grid_index = (grid_x + i) * this._numRows + (grid_y + j);
                        this._cuePositionScores[grid_index] = -1;
                     }
                  }
               }
               continue;
            }
         }
         bestScore = 0;
         bestIndex = 0;
         for(x = 2; x < this._numColumns - 1; x++)
         {
            for(y = 2; y < this._numRows - 1; y++)
            {
               index = x * this._numRows + y;
               value = this._cuePositionScores[index];
               if(value != -1)
               {
                  this._cueBall.position.x = x * this.SAMPLE_SIZE;
                  this._cueBall.position.y = y * this.SAMPLE_SIZE;
                  if(isEightball)
                  {
                     this.eightBallDirectOnly();
                  }
                  else
                  {
                     this.nineBallCueControlShot();
                  }
                  for each(move in this._moveCanidates)
                  {
                     if(move.moveScore > bestScore)
                     {
                        bestScore = move.moveScore;
                        bestMove = move;
                        bestIndex = index;
                     }
                  }
                  if(bestMove)
                  {
                     this._cuePositionScores[index] = bestMove.moveScore;
                  }
                  this.clearMoves();
               }
            }
         }
         var column:int = int(bestIndex / this._numRows);
         var row:int = bestIndex - column * this._numRows;
         this._cueBall.position.x = column * this.SAMPLE_SIZE;
         this._cueBall.position.y = row * this.SAMPLE_SIZE;
         this._biaCuePos.x = column * this.SAMPLE_SIZE;
         this._biaCuePos.y = row * this.SAMPLE_SIZE;
         if(isEightball)
         {
            this.eightBallDirectOnly();
         }
         else
         {
            this.nineBallCueControlShot();
         }
      }
      
      private function makeShotDecision() : void
      {
         if(Globals.model.ruleset.gameType == Ruleset.GAMETYPE_EIGHTBALL)
         {
            this.generateMovesEightBall();
         }
         else
         {
            this.generateMovesNineBall();
         }
      }
      
      private function breakShot() : void
      {
         var move:Move = this.getMoveFromCache();
         move.cueVelocity.x = 50;
         move.cueVelocity.y = 0;
         move.moveScore = 1;
         this._moveCanidates.push(move);
         this._currentState = this.STATE_TABLE_EVAL;
         this._timer = 0.5;
      }
      
      private function generateMovesEightBall() : void
      {
         var b:Ball = null;
         var rs:Eightball = Globals.model.ruleset as Eightball;
         var team:Team = Globals.model.ruleset.teams[teamID];
         var teamColor:int = team.teamBallType;
         var tableOpen:Boolean = teamColor == Ball.BALL_NONE;
         var numBallsLeft:int = rs.getNumOfBallType(teamColor);
         for each(b in this._balls)
         {
            if(b.active && (tableOpen && b.ballNumber != 8 || b.ballType == team.teamBallType && numBallsLeft > 0 && b.ballNumber != 8 || !tableOpen && numBallsLeft == 0 && b.ballNumber == 8))
            {
               this.findDirectShots(b);
               this.findBankShots(b);
               this.findKickShots(b);
               this.findComboShotsEightBall(b);
            }
         }
         if(this._moveCanidates.length == 0)
         {
            for each(b in this._balls)
            {
               if(b.active && (tableOpen && b.ballNumber != 8 || b.ballType == team.teamBallType && numBallsLeft > 0 && b.ballNumber != 8 || !tableOpen && numBallsLeft == 0 && b.ballNumber == 8))
               {
                  this.findSafetyShot(b);
               }
            }
         }
         if(this._moveCanidates.length == 0)
         {
            this.failSafeShot();
         }
      }
      
      private function eightBallDirectOnly() : void
      {
         var b:Ball = null;
         var rs:Eightball = Globals.model.ruleset as Eightball;
         var team:Team = Globals.model.ruleset.teams[teamID];
         var teamColor:int = team.teamBallType;
         var tableOpen:Boolean = teamColor == Ball.BALL_NONE;
         var numBallsLeft:int = rs.getNumOfBallType(teamColor);
         for each(b in this._balls)
         {
            if(b.active && (tableOpen && b.ballNumber != 8 || b.ballType == team.teamBallType && numBallsLeft > 0 && b.ballNumber != 8 || !tableOpen && numBallsLeft == 0 && b.ballNumber == 8))
            {
               this.findDirectShots(b);
            }
         }
         if(this._moveCanidates.length == 0)
         {
            for each(b in this._balls)
            {
               if(b.active && (tableOpen && b.ballNumber != 8 || b.ballType == team.teamBallType && numBallsLeft > 0 && b.ballNumber != 8 || !tableOpen && numBallsLeft == 0 && b.ballNumber == 8))
               {
                  this.findSafetyShot(b);
               }
            }
         }
      }
      
      private function nineBallCueControlShot() : void
      {
         var b:Ball = null;
         var rs:NineBall = Globals.model.ruleset as NineBall;
         var lowestValueBall:Ball = null;
         for each(b in this._balls)
         {
            if(lowestValueBall == null && b.active)
            {
               lowestValueBall = b;
            }
            if(b.active && b.ballNumber < lowestValueBall.ballNumber)
            {
               lowestValueBall = b;
            }
         }
         this.findDirectShots(lowestValueBall);
         this.findComboShotsNineBall(lowestValueBall);
         if(this._moveCanidates.length == 0)
         {
            this.findSafetyShot(lowestValueBall);
         }
      }
      
      private function generateMovesNineBall() : void
      {
         var b:Ball = null;
         var rs:NineBall = Globals.model.ruleset as NineBall;
         var lowestValueBall:Ball = null;
         for each(b in this._balls)
         {
            if(lowestValueBall == null && b.active)
            {
               lowestValueBall = b;
            }
            if(b.active && b.ballNumber < lowestValueBall.ballNumber)
            {
               lowestValueBall = b;
            }
         }
         this.findDirectShots(lowestValueBall);
         this.findComboShotsNineBall(lowestValueBall);
         this.findBankShots(lowestValueBall);
         if(this._moveCanidates.length == 0)
         {
            this.findKickShots(lowestValueBall);
            this.findSafetyShot(lowestValueBall);
         }
         if(this._moveCanidates.length == 0)
         {
            this.failSafeShot();
         }
      }
      
      private function findDirectShots(ob:Ball) : void
      {
         var move:Move = null;
         var pocket:Vector3D = null;
         var validPocket:Boolean = false;
         var ray:Vector3D = null;
         var direction:Vector3D = null;
         var cueVelocity:Vector3D = null;
         var dotProd:Number = NaN;
         var rs:Ruleset = Globals.model.ruleset;
         for each(pocket in this._pockets)
         {
            validPocket = this.checkLosToTarget(ob,pocket);
            if(validPocket)
            {
               ray = pocket.subtract(ob.position);
               direction = ray.clone();
               direction.normalize();
               this._ghostBallPosition.x = ob.position.x - direction.x * this._ballDiameter;
               this._ghostBallPosition.y = ob.position.y - direction.y * this._ballDiameter;
               if(this.checkLosToTarget(this._cueBall,this._ghostBallPosition) && this.checkValidGhostPosition(this._ghostBallPosition))
               {
                  cueVelocity = new Vector3D(this._ghostBallPosition.x - this._cueBall.position.x,this._ghostBallPosition.y - this._cueBall.position.y);
                  dotProd = direction.dotProduct(cueVelocity);
                  if(dotProd > 0)
                  {
                     move = this.getMoveFromCache();
                     move.objectBall = ob;
                     move.targetPos.x = this._ghostBallPosition.x;
                     move.targetPos.y = this._ghostBallPosition.y;
                     move.pocket = pocket;
                     move.obVector.x = ray.x;
                     move.obVector.y = ray.y;
                     move.cueVelocity.x = cueVelocity.x;
                     move.cueVelocity.y = cueVelocity.y;
                     move.shotType = Move.TYPE_DIRECT;
                     this.calculateMoveScore(move);
                     this._moveCanidates.push(move);
                  }
               }
            }
         }
      }
      
      private function findKickShots(ob:Ball) : void
      {
         var move:Move = null;
         var pocket:Vector3D = null;
         var validPocket:Boolean = false;
         var ray:Vector3D = null;
         var direction:Vector3D = null;
         var railNormal:Vector3D = null;
         var a:Number = NaN;
         var b:Number = NaN;
         var diff:Number = NaN;
         var rail_y:Number = NaN;
         var rail_x:Number = NaN;
         var rs:Ruleset = Globals.model.ruleset;
         var railTargetPos:Vector3D = new Vector3D();
         for each(pocket in this._pockets)
         {
            validPocket = this.checkLosToTarget(ob,pocket);
            if(validPocket)
            {
               ray = pocket.subtract(ob.position);
               direction = ray.clone();
               direction.normalize();
               this._ghostBallPosition.x = ob.position.x - direction.x * this._ballDiameter;
               this._ghostBallPosition.y = ob.position.y - direction.y * this._ballDiameter;
               if(this.checkValidGhostPosition(this._ghostBallPosition))
               {
                  for each(railNormal in this._railNormals)
                  {
                     if(railNormal.dotProduct(ray) > 0)
                     {
                        if(railNormal.y)
                        {
                           rail_y = railNormal.w;
                           a = this._cueBall.position.y - rail_y;
                           b = this._ghostBallPosition.y - rail_y;
                           diff = this._ghostBallPosition.x - this._cueBall.position.x;
                           railTargetPos.x = this._cueBall.position.x + a * diff / (a + b / 0.7);
                           railTargetPos.y = rail_y;
                        }
                        else
                        {
                           rail_x = railNormal.w;
                           a = this._cueBall.position.x - rail_x;
                           b = this._ghostBallPosition.x - rail_x;
                           diff = this._ghostBallPosition.y - this._cueBall.position.y;
                           railTargetPos.y = this._cueBall.position.y + a * diff / (a + b / 0.7);
                           railTargetPos.x = rail_x;
                        }
                        if(this.checkValidRailTarget(this._cueBall,railTargetPos) && this.checkLosToTarget(this._cueBall,railTargetPos) && this.checkLosBetweenPoints(this._ghostBallPosition,railTargetPos))
                        {
                           move = this.getMoveFromCache();
                           move.objectBall = ob;
                           move.targetPos.x = this._ghostBallPosition.x;
                           move.targetPos.y = this._ghostBallPosition.y;
                           move.pocket = pocket;
                           move.obVector.x = ray.x;
                           move.obVector.y = ray.y;
                           move.cueVelocity.x = railTargetPos.x - this._cueBall.position.x;
                           move.cueVelocity.y = railTargetPos.y - this._cueBall.position.y;
                           move.railTargetPos.x = railTargetPos.x;
                           move.railTargetPos.y = railTargetPos.y;
                           move.shotType = Move.TYPE_KICK;
                           this.calculateMoveScore(move);
                           this._moveCanidates.push(move);
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function findBankShots(ob:Ball) : void
      {
         var move:Move = null;
         var pocket:Vector3D = null;
         var pocketVector:Vector3D = null;
         var railNormal:Vector3D = null;
         var a:Number = NaN;
         var b:Number = NaN;
         var diff:Number = NaN;
         var rail_y:Number = NaN;
         var rail_x:Number = NaN;
         var ray:Vector3D = null;
         var length:Number = NaN;
         var rs:Ruleset = Globals.model.ruleset;
         var railTargetPos:Vector3D = new Vector3D();
         var tableCenter:Vector3D = new Vector3D(rs.tableWidth * 0.5,rs.tableHeight * 0.5);
         for each(pocket in this._pockets)
         {
            pocketVector = tableCenter.subtract(pocket);
            for each(railNormal in this._railNormals)
            {
               if(railNormal.dotProduct(pocketVector) <= 0)
               {
                  if(railNormal.y)
                  {
                     rail_y = railNormal.w;
                     a = ob.position.y - rail_y;
                     b = pocket.y - rail_y;
                     diff = pocket.x - ob.position.x;
                     railTargetPos.x = ob.position.x + a * diff / (a + b / 0.7);
                     railTargetPos.y = rail_y;
                  }
                  else
                  {
                     rail_x = railNormal.w;
                     a = ob.position.x - rail_x;
                     b = pocket.x - rail_x;
                     diff = pocket.y - ob.position.y;
                     railTargetPos.y = ob.position.y + a * diff / (a + b / 0.7);
                     railTargetPos.x = rail_x;
                  }
                  if(this.checkValidRailTarget(ob,railTargetPos) && this.checkLosToTarget(ob,railTargetPos) && this.checkLosBetweenPoints(pocket,railTargetPos))
                  {
                     ray = railTargetPos.subtract(ob.position);
                     length = ray.normalize();
                     this._ghostBallPosition.x = ob.position.x - ray.x * this._ballDiameter;
                     this._ghostBallPosition.y = ob.position.y - ray.y * this._ballDiameter;
                     ray.scaleBy(length);
                     if(this.checkLosToTarget(this._cueBall,this._ghostBallPosition) && this.checkValidGhostPosition(this._ghostBallPosition))
                     {
                        move = this.getMoveFromCache();
                        move.objectBall = ob;
                        move.targetPos.x = this._ghostBallPosition.x;
                        move.targetPos.y = this._ghostBallPosition.y;
                        move.pocket = pocket;
                        move.obVector.x = ray.x;
                        move.obVector.y = ray.y;
                        move.cueVelocity.x = this._ghostBallPosition.x - this._cueBall.position.x;
                        move.cueVelocity.y = this._ghostBallPosition.y - this._cueBall.position.y;
                        move.railTargetPos.x = railTargetPos.x;
                        move.railTargetPos.y = railTargetPos.y;
                        move.shotType = Move.TYPE_BANK;
                        this.calculateMoveScore(move);
                        this._moveCanidates.push(move);
                     }
                  }
               }
            }
         }
      }
      
      private function findComboShotsEightBall(ob:Ball) : void
      {
         var pocket:Vector3D = null;
         var validPocket:Boolean = false;
         var maxDepth:int = 1;
         var rs:Eightball = Globals.model.ruleset as Eightball;
         var team:Team = Globals.model.ruleset.teams[teamID];
         var teamColor:int = team.teamBallType;
         var tableOpen:Boolean = teamColor == Ball.BALL_NONE;
         var ballOrder:Vector.<Ball> = new Vector.<Ball>();
         var targetOrder:Vector.<Vector3D> = new Vector.<Vector3D>();
         for each(pocket in this._pockets)
         {
            validPocket = this.checkLosToTarget(ob,pocket);
            if(validPocket)
            {
               ballOrder.push(ob);
               targetOrder.push(pocket);
               this.comboFinder(ob,pocket,maxDepth,pocket,teamColor,ballOrder,targetOrder);
               ballOrder.length = 0;
               targetOrder.length = 0;
            }
         }
         ballOrder = null;
         targetOrder = null;
      }
      
      private function findComboShotsNineBall(ob:Ball) : void
      {
         var ball:Ball = null;
         var pocket:Vector3D = null;
         var validPocket:Boolean = false;
         var maxDepth:int = 1;
         var rs:Eightball = Globals.model.ruleset as Eightball;
         var team:Team = Globals.model.ruleset.teams[teamID];
         var teamColor:int = team.teamBallType;
         var tableOpen:Boolean = teamColor == Ball.BALL_NONE;
         var ballOrder:Vector.<Ball> = new Vector.<Ball>();
         var targetOrder:Vector.<Vector3D> = new Vector.<Vector3D>();
         for each(ball in this._balls)
         {
            if(ball.active && ball != ob)
            {
               for each(pocket in this._pockets)
               {
                  validPocket = this.checkLosToTarget(ball,pocket);
                  if(validPocket)
                  {
                     ballOrder.push(ball);
                     targetOrder.push(pocket);
                     this.comboFinderWithConstraint(ball,pocket,maxDepth,pocket,ob,ballOrder,targetOrder);
                     ballOrder.length = 0;
                     targetOrder.length = 0;
                  }
               }
            }
         }
         ballOrder = null;
         targetOrder = null;
      }
      
      private function comboFinder(ob:Ball, target:Vector3D, depth:int, pocket:Vector3D, teamType:int, ballOrder:Vector.<Ball>, targetOrder:Vector.<Vector3D>) : void
      {
         var ball:Ball = null;
         var comboRay:Vector3D = null;
         var targetPos:Vector3D = null;
         var cueVelocity:Vector3D = null;
         var dotProd:Number = NaN;
         var move:Move = null;
         depth = depth - 1;
         var rs:Ruleset = Globals.model.ruleset;
         var ray:Vector3D = target.subtract(ob.position);
         var direction:Vector3D = ray.clone();
         direction.normalize();
         var gbp:Vector3D = new Vector3D();
         gbp.x = ob.position.x - direction.x * this._ballDiameter;
         gbp.y = ob.position.y - direction.y * this._ballDiameter;
         if(this.checkValidGhostPosition(gbp) == false)
         {
            return;
         }
         for each(ball in this._balls)
         {
            if(ball.active && ball != ob)
            {
               comboRay = gbp.subtract(ball.position);
               if(comboRay.dotProduct(ray) > 0 && this.checkLosToTarget(ball,gbp))
               {
                  ballOrder.push(ball);
                  targetOrder.push(gbp);
                  direction = comboRay.clone();
                  direction.normalize();
                  targetPos = new Vector3D(ball.position.x - direction.x * this._ballDiameter,ball.position.y - direction.y * this._ballDiameter);
                  if(this.checkLosToTarget(this._cueBall,targetPos) && this.checkValidGhostPosition(targetPos) && (ball.ballType == teamType || teamType == Ball.BALL_NONE) && ball.ballNumber != 8)
                  {
                     cueVelocity = targetPos.subtract(this._cueBall.position);
                     dotProd = comboRay.dotProduct(cueVelocity);
                     if(dotProd > 0)
                     {
                        move = this.getMoveFromCache();
                        move.pocket = pocket;
                        move.targetPos.x = targetPos.x;
                        move.targetPos.y = targetPos.y;
                        move.cueVelocity.x = targetPos.x - this._cueBall.position.x;
                        move.cueVelocity.y = targetPos.y - this._cueBall.position.y;
                        move.shotType = Move.TYPE_COMBO;
                        move.objectBall = ballOrder[0];
                        move.comboBallOrder = ballOrder.concat();
                        move.comboTargetOrder = targetOrder.concat();
                        this.calculateMoveScore(move);
                        this._moveCanidates.push(move);
                     }
                  }
                  else if(depth > 0)
                  {
                     this.comboFinder(ball,targetPos,depth,pocket,teamType,ballOrder,targetOrder);
                  }
                  ballOrder.pop();
                  targetOrder.pop();
               }
            }
         }
      }
      
      private function comboFinderWithConstraint(ob:Ball, target:Vector3D, depth:int, pocket:Vector3D, constraint:Ball, ballOrder:Vector.<Ball>, targetOrder:Vector.<Vector3D>) : void
      {
         var ball:Ball = null;
         var comboRay:Vector3D = null;
         var targetPos:Vector3D = null;
         var cueVelocity:Vector3D = null;
         var dotProd:Number = NaN;
         var move:Move = null;
         depth = depth - 1;
         var rs:Ruleset = Globals.model.ruleset;
         var ray:Vector3D = target.subtract(ob.position);
         var direction:Vector3D = ray.clone();
         direction.normalize();
         var gbp:Vector3D = new Vector3D();
         gbp.x = ob.position.x - direction.x * this._ballDiameter;
         gbp.y = ob.position.y - direction.y * this._ballDiameter;
         if(this.checkValidGhostPosition(gbp) == false)
         {
            return;
         }
         for each(ball in this._balls)
         {
            if(ball.active && ball != ob)
            {
               comboRay = gbp.subtract(ball.position);
               if(comboRay.dotProduct(ray) > 0 && this.checkLosToTarget(ball,gbp))
               {
                  ballOrder.push(ball);
                  targetOrder.push(gbp);
                  direction = comboRay.clone();
                  direction.normalize();
                  targetPos = new Vector3D(ball.position.x - direction.x * this._ballDiameter,ball.position.y - direction.y * this._ballDiameter);
                  if(ball == constraint && this.checkLosToTarget(this._cueBall,targetPos) && this.checkValidGhostPosition(targetPos))
                  {
                     cueVelocity = targetPos.subtract(this._cueBall.position);
                     dotProd = comboRay.dotProduct(cueVelocity);
                     if(dotProd > 0)
                     {
                        move = this.getMoveFromCache();
                        move.pocket = pocket;
                        move.targetPos.x = targetPos.x;
                        move.targetPos.y = targetPos.y;
                        move.cueVelocity.x = targetPos.x - this._cueBall.position.x;
                        move.cueVelocity.y = targetPos.y - this._cueBall.position.y;
                        move.shotType = Move.TYPE_COMBO;
                        move.objectBall = ballOrder[0];
                        move.comboBallOrder = ballOrder.concat();
                        move.comboTargetOrder = targetOrder.concat();
                        this.calculateMoveScore(move);
                        this._moveCanidates.push(move);
                     }
                  }
                  else if(depth > 0)
                  {
                     this.comboFinderWithConstraint(ball,targetPos,depth,pocket,constraint,ballOrder,targetOrder);
                  }
                  ballOrder.pop();
                  targetOrder.pop();
               }
            }
         }
      }
      
      private function findSafetyShot(ob:Ball) : void
      {
         var move:Move = null;
         var wall:Wall = null;
         var AC:Vector3D = null;
         var proj:Number = NaN;
         var vectorProj:Vector3D = null;
         var closestPoint:Vector3D = null;
         var ray:Vector3D = null;
         var cueVelocity:Vector3D = null;
         var dotProd:Number = NaN;
         var railNormal:Vector3D = null;
         var a:Number = NaN;
         var b:Number = NaN;
         var diff:Number = NaN;
         var rail_y:Number = NaN;
         var rail_x:Number = NaN;
         var rs:Ruleset = Globals.model.ruleset;
         var rails:Vector.<Wall> = rs.quickWallCheck;
         var railTargetPos:Vector3D = new Vector3D();
         for each(wall in rails)
         {
            AC = ob.position.subtract(wall.pointA);
            proj = AC.dotProduct(wall.fullVector) / wall.fullVector.dotProduct(wall.fullVector);
            vectorProj = wall.fullVector.clone();
            vectorProj.scaleBy(proj);
            closestPoint = wall.pointA.add(vectorProj);
            ray = closestPoint.subtract(ob.position);
            ray.normalize();
            this._ghostBallPosition.x = ob.position.x - ray.x * this._ballDiameter;
            this._ghostBallPosition.y = ob.position.y - ray.y * this._ballDiameter;
            if(this.checkLosToTarget(this._cueBall,this._ghostBallPosition) && this.checkValidGhostPosition(this._ghostBallPosition))
            {
               cueVelocity = new Vector3D(this._ghostBallPosition.x - this._cueBall.position.x,this._ghostBallPosition.y - this._cueBall.position.y);
               dotProd = ray.dotProduct(cueVelocity);
               if(dotProd > 0)
               {
                  move = this.getMoveFromCache();
                  move.objectBall = ob;
                  move.targetPos.x = this._ghostBallPosition.x;
                  move.targetPos.y = this._ghostBallPosition.y;
                  move.railTargetPos.x = closestPoint.x;
                  move.railTargetPos.y = closestPoint.y;
                  move.railTargetPos.w = this.SAFETY_DIRECT;
                  move.obVector.x = ray.x;
                  move.obVector.y = ray.y;
                  move.cueVelocity.x = cueVelocity.x;
                  move.cueVelocity.y = cueVelocity.y;
                  move.shotType = Move.TYPE_SAFETY;
                  this.calculateMoveScore(move);
                  this._moveCanidates.push(move);
               }
            }
            else if(this.checkValidGhostPosition(this._ghostBallPosition))
            {
               for each(railNormal in this._railNormals)
               {
                  if(railNormal.dotProduct(ray) > 0)
                  {
                     if(railNormal.y)
                     {
                        rail_y = railNormal.w;
                        a = this._cueBall.position.y - rail_y;
                        b = this._ghostBallPosition.y - rail_y;
                        diff = this._ghostBallPosition.x - this._cueBall.position.x;
                        railTargetPos.x = this._cueBall.position.x + a * diff / (a + b / 0.7);
                        railTargetPos.y = rail_y;
                     }
                     else
                     {
                        rail_x = railNormal.w;
                        a = this._cueBall.position.x - rail_x;
                        b = this._ghostBallPosition.x - rail_x;
                        diff = this._ghostBallPosition.y - this._cueBall.position.y;
                        railTargetPos.y = this._cueBall.position.y + a * diff / (a + b / 0.7);
                        railTargetPos.x = rail_x;
                     }
                     if(this.checkValidRailTarget(this._cueBall,railTargetPos) && this.checkLosToTarget(this._cueBall,railTargetPos) && this.checkLosToTarget(ob,railTargetPos))
                     {
                        move = this.getMoveFromCache();
                        move.objectBall = ob;
                        move.targetPos.x = this._ghostBallPosition.x;
                        move.targetPos.y = this._ghostBallPosition.y;
                        move.obVector.x = ray.x;
                        move.obVector.y = ray.y;
                        move.cueVelocity.x = railTargetPos.x - this._cueBall.position.x;
                        move.cueVelocity.y = railTargetPos.y - this._cueBall.position.y;
                        move.railTargetPos.x = railTargetPos.x;
                        move.railTargetPos.y = railTargetPos.y;
                        move.railTargetPos.w = this.SAFETY_KICK;
                        move.shotType = Move.TYPE_SAFETY;
                        this.calculateMoveScore(move);
                        this._moveCanidates.push(move);
                     }
                  }
               }
            }
         }
      }
      
      public function failSafeShot() : void
      {
         var rs:Ruleset = Globals.model.ruleset;
         var randomTarget:Vector3D = new Vector3D();
         var validShot:Boolean = false;
         var shotAttempts:int = 1;
         while(!validShot)
         {
            randomTarget.x = Math.random() * rs.tableWidth;
            randomTarget.y = Math.random() * rs.tableHeight;
            shotAttempts--;
            if(shotAttempts == 0)
            {
               validShot = true;
            }
         }
         randomTarget.normalize();
         randomTarget.scaleBy(20);
         var move:Move = this.getMoveFromCache();
         move.objectBall = null;
         move.cueVelocity.x = randomTarget.x - this._cueBall.position.x;
         move.cueVelocity.y = randomTarget.y - this._cueBall.position.y;
         move.moveScore = 1;
         move.shotType = Move.TYPE_FAILSAFE;
         this._moveCanidates.push(move);
      }
      
      private function evaluateMoves() : void
      {
         var move:Move = null;
         var bestScore:Number = 0;
         this._bestMove = null;
         this._secondBestMove = null;
         for each(move in this._moveCanidates)
         {
            if(move.moveScore > bestScore)
            {
               bestScore = move.moveScore;
               this._secondBestMove = this._bestMove;
               this._bestMove = move;
            }
         }
      }
      
      private function calculateMoveScore(move:Move) : void
      {
         var denom:Number = NaN;
         var v1:Vector3D = null;
         var v2:Vector3D = null;
         var v3:Vector3D = null;
         var ballOrder:Vector.<Ball> = null;
         var targetOrder:Vector.<Vector3D> = null;
         var comboLength:int = 0;
         var target:Vector3D = null;
         var gbt:Vector3D = null;
         var ball:Ball = null;
         var i:int = 0;
         var pocketNormal:Vector3D = null;
         var gamma:Number = NaN;
         var ob:Ball = move.objectBall;
         var kickShotPenalty:Number = 0.85;
         var bankShotPenalty:Number = 0.85;
         var comboShotPenalty:Number = 1;
         var safetyPenalty:Number = 0.01;
         if(move.shotType == Move.TYPE_DIRECT)
         {
            denom = move.cueVelocity.dotProduct(move.cueVelocity) * move.obVector.dotProduct(move.obVector);
            move.moveScore = move.obVector.dotProduct(move.cueVelocity) / denom;
            v3 = move.obVector;
         }
         else if(move.shotType == Move.TYPE_KICK)
         {
            v1 = move.railTargetPos.subtract(this._cueBall.position);
            v2 = move.targetPos.subtract(move.railTargetPos);
            v3 = move.obVector;
            denom = v1.length + v2.dotProduct(v2) * v3.dotProduct(v3);
            move.moveScore = kickShotPenalty * v2.dotProduct(v3) / denom;
         }
         else if(move.shotType == Move.TYPE_BANK)
         {
            v1 = move.targetPos.subtract(this._cueBall.position);
            v2 = move.obVector;
            v3 = move.pocket.subtract(move.railTargetPos);
            denom = v1.dotProduct(v1) * v2.dotProduct(v2) + v3.length;
            move.moveScore = bankShotPenalty * v1.dotProduct(v2) / denom;
         }
         else if(move.shotType == Move.TYPE_COMBO)
         {
            ballOrder = move.comboBallOrder;
            targetOrder = move.comboTargetOrder;
            comboLength = ballOrder.length;
            denom = 0;
            move.moveScore = 1;
            for(i = 0; i < comboLength - 1; i++)
            {
               target = targetOrder[i];
               ob = ballOrder[i];
               gbt = targetOrder[i + 1];
               ball = ballOrder[i + 1];
               v1 = target.subtract(ob.position);
               v2 = gbt.subtract(ball.position);
               denom = denom + v1.dotProduct(v1) * v2.dotProduct(v2);
               move.moveScore = move.moveScore * v1.dotProduct(v2);
               if(i == 0)
               {
                  v3 = v1;
               }
            }
            v1 = move.targetPos.subtract(this._cueBall.position);
            denom = denom + v1.dotProduct(v1) * v2.dotProduct(v2);
            move.moveScore = move.moveScore * (v1.dotProduct(v2) * comboShotPenalty / denom);
         }
         else if(move.shotType == Move.TYPE_SAFETY)
         {
            if(move.railTargetPos.w == this.SAFETY_DIRECT)
            {
               denom = move.cueVelocity.dotProduct(move.cueVelocity) * move.obVector.dotProduct(move.obVector);
               move.moveScore = safetyPenalty * move.obVector.dotProduct(move.cueVelocity) / denom;
            }
            else
            {
               v1 = move.railTargetPos.subtract(this._cueBall.position);
               v2 = move.targetPos.subtract(move.railTargetPos);
               v3 = move.obVector;
               denom = v1.length + v2.dotProduct(v2) * v3.dotProduct(v3);
               move.moveScore = safetyPenalty * kickShotPenalty * v2.dotProduct(v3) / denom;
               v3 = null;
            }
         }
         if(v3 && move.pocket.w == this.POCKET_SIDE)
         {
            pocketNormal = new Vector3D(0,-1,0);
            if(v3.y > 0)
            {
               pocketNormal.y = 1;
            }
            v3.normalize();
            gamma = v3.dotProduct(pocketNormal);
            if(gamma < 0.45)
            {
               gamma = 0.0001;
            }
            move.moveScore = move.moveScore * gamma;
            move.obVector.w = gamma;
         }
      }
      
      private function calculateCueVelocity(move:Move) : void
      {
         var cueLength:Number = NaN;
         var obLength:Number = NaN;
         var denom:Number = NaN;
         var scalar:Number = NaN;
         var obSpeed:Number = NaN;
         var cueSpeed:Number = NaN;
         var railToGhost:Vector3D = null;
         var cueToRail:Vector3D = null;
         var railToPocket:Vector3D = null;
         var ballOrder:Vector.<Ball> = null;
         var targetOrder:Vector.<Vector3D> = null;
         var comboLength:int = 0;
         var target:Vector3D = null;
         var gbt:Vector3D = null;
         var ball:Ball = null;
         var ob:Ball = null;
         var minObSpeed:Number = NaN;
         var minCueSpeed:Number = NaN;
         var speedSum:Number = NaN;
         var obToTarget:Vector3D = null;
         var balltoGhostTarget:Vector3D = null;
         var i:int = 0;
         var vFinal:Number = 2 * 0.0056 * 9.8 / 0.028575;
         var e:Number = (1 + 0.93) / 2;
         var railShotScaling:Number = 8;
         if(move.shotType == Move.TYPE_DIRECT)
         {
            cueLength = move.cueVelocity.normalize();
            obLength = move.obVector.normalize();
            denom = e * move.cueVelocity.dotProduct(move.obVector);
            scalar = Math.sqrt(obLength * vFinal);
            obSpeed = scalar / denom;
            cueSpeed = Math.sqrt(cueLength * vFinal);
            obSpeed = obSpeed > cueSpeed?Number(obSpeed):Number(cueSpeed);
            move.cueVelocity.scaleBy(obSpeed);
         }
         else if(move.shotType == Move.TYPE_KICK)
         {
            railToGhost = move.targetPos.subtract(move.railTargetPos);
            cueToRail = move.railTargetPos.subtract(this._cueBall.position);
            move.cueVelocity.normalize();
            cueLength = railToGhost.normalize() + cueToRail.normalize();
            obLength = move.obVector.normalize();
            denom = e * move.obVector.dotProduct(railToGhost);
            scalar = Math.sqrt(obLength * vFinal);
            obSpeed = scalar / denom;
            cueSpeed = Math.sqrt(cueLength * vFinal);
            obSpeed = obSpeed > cueSpeed?Number(obSpeed):Number(cueSpeed);
            move.cueVelocity.scaleBy(obSpeed * railShotScaling);
         }
         else if(move.shotType == Move.TYPE_BANK)
         {
            railToPocket = move.pocket.subtract(move.railTargetPos);
            cueLength = move.cueVelocity.normalize();
            obLength = move.obVector.normalize() + railToPocket.normalize();
            denom = e * move.obVector.dotProduct(move.cueVelocity);
            scalar = Math.sqrt(obLength * vFinal);
            obSpeed = scalar / denom;
            cueSpeed = Math.sqrt(cueLength * vFinal);
            if(obSpeed > cueSpeed)
            {
               move.cueVelocity.scaleBy(obSpeed * railShotScaling);
            }
            else
            {
               move.cueVelocity.scaleBy(cueSpeed * railShotScaling);
            }
         }
         else if(move.shotType == Move.TYPE_COMBO)
         {
            ballOrder = move.comboBallOrder;
            targetOrder = move.comboTargetOrder;
            comboLength = ballOrder.length;
            denom = 0;
            move.moveScore = 1;
            minObSpeed = 0;
            minCueSpeed = 0;
            speedSum = 0;
            for(i = 0; i < comboLength; i++)
            {
               target = targetOrder[i];
               ob = ballOrder[i];
               if(i + 1 >= comboLength)
               {
                  gbt = move.targetPos;
                  ball = this._cueBall;
                  move.cueVelocity.normalize();
               }
               else
               {
                  gbt = targetOrder[i + 1];
                  ball = ballOrder[i + 1];
               }
               obToTarget = target.subtract(ob.position);
               balltoGhostTarget = gbt.subtract(ball.position);
               cueLength = balltoGhostTarget.normalize();
               obLength = obToTarget.normalize();
               denom = e * obToTarget.dotProduct(balltoGhostTarget);
               scalar = Math.sqrt(obLength * vFinal);
               obSpeed = scalar / denom;
               cueSpeed = Math.sqrt(cueLength * vFinal);
               if(minObSpeed < obSpeed)
               {
                  minObSpeed = obSpeed;
               }
               if(minCueSpeed < cueSpeed)
               {
                  minCueSpeed = cueSpeed;
               }
            }
            if(minObSpeed > minCueSpeed)
            {
               move.cueVelocity.scaleBy(minObSpeed);
            }
            else
            {
               move.cueVelocity.scaleBy(minCueSpeed);
            }
         }
         else if(move.shotType == Move.TYPE_SAFETY)
         {
            if(move.railTargetPos.w == this.SAFETY_DIRECT)
            {
               cueLength = move.cueVelocity.normalize();
               obLength = move.obVector.normalize();
               denom = e * move.cueVelocity.dotProduct(move.obVector);
               scalar = Math.sqrt(obLength * vFinal * 0.75);
               obSpeed = scalar / denom;
               cueSpeed = Math.sqrt(cueLength * vFinal * 0.75);
               obSpeed = obSpeed > cueSpeed?Number(obSpeed):Number(cueSpeed);
               move.cueVelocity.scaleBy(obSpeed);
            }
            else
            {
               railToGhost = move.targetPos.subtract(move.railTargetPos);
               cueToRail = move.railTargetPos.subtract(this._cueBall.position);
               move.cueVelocity.normalize();
               cueLength = railToGhost.normalize() + cueToRail.normalize();
               obLength = move.obVector.normalize();
               denom = e * move.obVector.dotProduct(railToGhost);
               scalar = Math.sqrt(obLength * vFinal);
               obSpeed = scalar / denom;
               cueSpeed = Math.sqrt(cueLength * vFinal);
               obSpeed = obSpeed > cueSpeed?Number(obSpeed):Number(cueSpeed);
               move.cueVelocity.scaleBy(obSpeed * railShotScaling);
            }
         }
         else
         {
            move.cueVelocity.scaleBy(8);
         }
      }
      
      private function calculateShotNoise(move:Move) : void
      {
         var obToPocket:Vector3D = null;
         var distance:Number = NaN;
         var gamma:Number = NaN;
         this._shotVariance = 0;
         var noise:Number = 0;
         var maxNoise:Number = 0.075;
         var maxTableDistance:Number = 2.86;
         if(move.shotType == Move.TYPE_DIRECT)
         {
            obToPocket = move.obVector;
            distance = obToPocket.length;
            noise = distance / maxTableDistance;
            noise = noise * (noise * noise * maxNoise);
            if(move.pocket.w == this.POCKET_SIDE)
            {
               gamma = move.obVector.w;
               gamma = 1 - gamma;
               gamma = Math.pow(gamma,2) * maxNoise;
               noise = noise + gamma;
            }
         }
         else if(move.shotType != Move.TYPE_SAFETY)
         {
            noise = 0.005;
         }
         this._shotVariance = noise;
      }
      
      private function generateInputs(ballVel:Vector3D) : void
      {
         var cueBall:Ball = this._cueBall;
         var x_mouseDown:Number = cueBall.position.x + ballVel.x;
         var y_mouseDown:Number = cueBall.position.y + ballVel.y;
         var ballMass:Number = cueBall.mass;
         var hitVector:Vector3D = ballVel.clone();
         hitVector.scaleBy(ballMass * 0.5);
         var x_mouseUp:Number = x_mouseDown - hitVector.x;
         var y_mouseUp:Number = y_mouseDown - hitVector.y;
         this._mouseDown.turnIndex = Globals.model.ruleset.turnNumber;
         this._mouseDown.mouseX = x_mouseDown;
         this._mouseDown.mouseY = y_mouseDown;
         this._mouseUp.turnIndex = Globals.model.ruleset.turnNumber;
         this._mouseUp.mouseX = x_mouseUp;
         this._mouseUp.mouseY = y_mouseUp;
      }
      
      private function getMoveFromCache() : Move
      {
         var move:Move = this._moveCache.pop();
         move.shotType = Move.TYPE_NONE;
         move.moveScore = 0;
         move.railTargetPos.x = 0;
         move.railTargetPos.y = 0;
         move.railTargetPos.w = 0;
         return move;
      }
      
      private function returnMoveToCache(move:Move) : void
      {
         move.reset();
         this._moveCache.push(move);
      }
      
      private function checkLosToTarget(object:Ball, targetPosition:Vector3D, targetBall:Ball = null) : Boolean
      {
         var testVec:Vector3D = null;
         var numerator:Number = NaN;
         var projValue:Number = NaN;
         var closestPoint:Vector3D = null;
         var testToRay:Vector3D = null;
         var balls:Vector.<Ball> = this._balls;
         var cueBall:Ball = this._cueBall;
         var diameterSquared:Number = this._ballDiameterSquared;
         var ray:Vector3D = targetPosition.subtract(object.position);
         var denominator:Number = ray.dotProduct(ray);
         var numBalls:int = balls.length;
         var test:Ball = cueBall;
         for(var i:int = -1; i < numBalls; i++)
         {
            if(i > -1)
            {
               test = balls[i];
            }
            if(test.active && test != object && test != targetBall)
            {
               testVec = test.position.subtract(object.position);
               numerator = testVec.dotProduct(ray);
               if(numerator > 0)
               {
                  projValue = numerator / denominator;
                  if(projValue > 0 && projValue < 1)
                  {
                     closestPoint = new Vector3D(object.position.x + ray.x * projValue,object.position.y + ray.y * projValue);
                     testToRay = closestPoint.subtract(test.position);
                     if(testToRay.lengthSquared < diameterSquared)
                     {
                        return false;
                     }
                  }
                  else if(projValue >= 1)
                  {
                     testVec.x = targetPosition.x - test.position.x;
                     testVec.y = targetPosition.y - test.position.y;
                     if(diameterSquared - testVec.lengthSquared > 0.001)
                     {
                        return false;
                     }
                  }
               }
            }
         }
         return true;
      }
      
      private function checkLosBetweenPoints(start:Vector3D, end:Vector3D) : Boolean
      {
         var testVec:Vector3D = null;
         var numerator:Number = NaN;
         var projValue:Number = NaN;
         var closestPoint:Vector3D = null;
         var testToRay:Vector3D = null;
         var balls:Vector.<Ball> = this._balls;
         var cueBall:Ball = this._cueBall;
         var diameterSquared:Number = this._ballDiameterSquared;
         var ray:Vector3D = end.subtract(start);
         var denominator:Number = ray.dotProduct(ray);
         var numBalls:int = balls.length;
         var test:Ball = cueBall;
         for(var i:int = -1; i < numBalls; i++)
         {
            if(i > -1)
            {
               test = balls[i];
            }
            if(test.active)
            {
               testVec = test.position.subtract(start);
               numerator = testVec.dotProduct(ray);
               if(numerator > 0)
               {
                  projValue = numerator / denominator;
                  if(projValue > 0 && projValue < 1)
                  {
                     closestPoint = new Vector3D(start.x + ray.x * projValue,start.y + ray.y * projValue);
                     testToRay = closestPoint.subtract(test.position);
                     if(testToRay.lengthSquared < diameterSquared)
                     {
                        return false;
                     }
                  }
                  else if(projValue >= 1)
                  {
                     testVec.x = end.x - test.position.x;
                     testVec.y = end.y - test.position.y;
                     if(diameterSquared - testVec.lengthSquared > 0.001)
                     {
                        return false;
                     }
                  }
               }
            }
         }
         return true;
      }
      
      private function checkValidGhostPosition(targetPosition:Vector3D) : Boolean
      {
         var wall:Wall = null;
         var AC:Vector3D = null;
         var proj:Number = NaN;
         var vectorProj:Vector3D = null;
         var closestPoint:Vector3D = null;
         var difference:Vector3D = null;
         var rs:Ruleset = Globals.model.ruleset;
         var rails:Vector.<Wall> = rs.quickWallCheck;
         for each(wall in rails)
         {
            AC = targetPosition.subtract(wall.pointA);
            proj = AC.dotProduct(wall.fullVector) / wall.fullVector.dotProduct(wall.fullVector);
            vectorProj = wall.fullVector.clone();
            vectorProj.scaleBy(proj);
            closestPoint = wall.pointA.add(vectorProj);
            difference = targetPosition.subtract(closestPoint);
            if(difference.length < this._ballRadius)
            {
               return false;
            }
         }
         return true;
      }
      
      private function checkValidRailTarget(ob:Ball, targetPosition:Vector3D) : Boolean
      {
         var rail:Wall = null;
         var AC:Vector3D = null;
         var proj:Number = NaN;
         var rs:Ruleset = Globals.model.ruleset;
         var rails:Vector.<Wall> = rs.rails;
         var direction:Vector3D = targetPosition.subtract(ob.position);
         for each(rail in rails)
         {
            if(rail.normal.dotProduct(direction) < 0)
            {
               AC = targetPosition.subtract(rail.pointA);
               proj = AC.dotProduct(rail.fullVector) / rail.fullVector.dotProduct(rail.fullVector);
               if(proj > 0 && proj < 1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function getNextGaussian() : Number
      {
         var v1:Number = NaN;
         var v2:Number = NaN;
         var s:Number = NaN;
         if(this._gaussianNumCache)
         {
            this._gaussianNumCache = false;
            return this._nextGaussianNumber;
         }
         do
         {
            v1 = 2 * this._rng.nextDouble() - 1;
            v2 = 2 * this._rng.nextDouble() - 1;
            s = v1 * v1 + v2 * v2;
         }
         while(s >= 1 || s == 0);
         
         s = Math.sqrt(-2 * Math.log(s) / s);
         this._nextGaussianNumber = v1 * s;
         this._gaussianNumCache = true;
         return v2 * s;
      }
      
      private function getValueWithGaussianNoise(mean:Number, stdDeviation:Number) : Number
      {
         var gaussian:Number = this.getNextGaussian();
         return mean + gaussian * stdDeviation;
      }
      
      private function rotateVectorBy(radians:Number, vector:Vector3D) : void
      {
         var x:Number = vector.x;
         var y:Number = vector.y;
         var cos:Number = Math.cos(radians);
         var sin:Number = Math.sin(radians);
         vector.x = x * cos - y * sin;
         vector.y = y * cos + x * sin;
      }
      
      private function normalizeAngleRadians(angle:Number) : Number
      {
         var normalizedAngle:Number = angle;
         while(normalizedAngle > this.PI)
         {
            normalizedAngle = normalizedAngle - this.TWO_PI;
         }
         while(normalizedAngle < -this.PI)
         {
            normalizedAngle = normalizedAngle + this.TWO_PI;
         }
         return normalizedAngle;
      }
      
      private function getCueAngleFromMousePos(mouseX:Number, mouseY:Number) : Number
      {
         var cuepos:Vector3D = this._cueBall.position;
         var xdiff:Number = mouseX - cuepos.x;
         var ydiff:Number = mouseY - cuepos.y;
         return Math.atan2(ydiff,xdiff);
      }
      
      private function getMouseXfrom(angle:Number) : Number
      {
         var cuepos:Vector3D = this._cueBall.position;
         return Math.cos(angle) + cuepos.x;
      }
      
      private function getMouseYfrom(angle:Number) : Number
      {
         var cuepos:Vector3D = this._cueBall.position;
         return Math.sin(angle) + cuepos.y;
      }
   }
}
