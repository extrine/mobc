package iilwygames.pool.model.gameplay.Ruleset
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.physics.World;
   import iilwygames.pool.util.MathUtil;
   
   public class EightballBlitz extends Ruleset
   {
       
      
      public var score:Number;
      
      public var scoreMultiplier:Number;
      
      public var speedBonus:Number;
      
      public var gameTimer:Number;
      
      private var setCueBall:Boolean;
      
      public var consecutiveBallPocket:int;
      
      public var ballQueue:Vector.<Ball>;
      
      private var timeToShoot:Number;
      
      private var shotStartTime:Number;
      
      private var shotEndTime:Number;
      
      private var speedBonusLevel:int;
      
      private const SHOT_SCORE:int = 250;
      
      private var _round:int;
      
      private var _totalRound:int;
      
      public function EightballBlitz(rngSeed:uint = 0, teamCount:int = 1)
      {
         super(rngSeed,teamCount);
         this.score = 0;
         this.scoreMultiplier = 1;
         this.gameTimer = 360;
         this.setCueBall = true;
         this.consecutiveBallPocket = 0;
         this.timeToShoot = 0;
         this.shotStartTime = 0;
         this.shotEndTime = 0;
         this.speedBonusLevel = 0;
         this.speedBonus = 0;
         this._round = 0;
         this._totalRound = 0;
         this.ballQueue = new Vector.<Ball>();
         gameType = GAMETYPE_EIGHTBALLBLITZ;
      }
      
      override public function destroy() : void
      {
         this.ballQueue = null;
         super.destroy();
      }
      
      override protected function createBalls() : void
      {
         var newBall:Ball = null;
         cueBall = new Ball();
         cueBall.ballType = Ball.BALL_CUE;
         cueBall.position.x = tableWidth * 0.25;
         cueBall.position.y = tableHeight * 0.5;
         Globals.model.world.addGameObject(cueBall);
         for(var i:int = 0; i < 23; i++)
         {
            newBall = new Ball();
            newBall.ballNumber = i + 1;
            if(newBall.ballNumber > 8)
            {
               newBall.ballType = Ball.BALL_STRIPE;
            }
            else
            {
               newBall.ballType = Ball.BALL_SOLID;
            }
            newBall.ballState = Ball.BALL_STATE_DONOTRENDER;
            newBall.active = false;
            Globals.model.world.addGameObject(newBall);
            balls.push(newBall);
         }
         super.createBalls();
      }
      
      override protected function rackSet() : void
      {
         var ball:Ball = null;
         var roundIndex:int = 0;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         if(this.setCueBall)
         {
            cueBall.resetBall();
            cueBall.position.x = tableWidth * 0.25;
            cueBall.position.y = tableHeight * 0.5;
         }
         for each(ball in balls)
         {
            ball.ballState = Ball.BALL_STATE_DONOTRENDER;
            ball.active = false;
         }
         roundIndex = this._round % 4;
         xPos = tableWidth * 0.75;
         yPos = tableHeight * 0.5;
         if(roundIndex == 0)
         {
            this.rackSeven(xPos,yPos);
         }
         else if(roundIndex == 1)
         {
            this.rackNine(xPos,yPos);
         }
         else if(roundIndex == 2)
         {
            this.rackTen(xPos,yPos);
         }
         else if(roundIndex == 3)
         {
            this.rackFifteen(xPos,yPos);
         }
         this._round++;
         super.rackSet();
      }
      
      override protected function startTurn() : void
      {
         var b:Ball = null;
         var world:World = null;
         var j:int = 0;
         var currball:Ball = null;
         super.startTurn();
         if(playState == Ruleset.PLAYSTATE_GAMEOVER)
         {
            return;
         }
         var len:int = balls.length;
         var ballsActive:Boolean = false;
         for(var i:int = 0; i < len; i++)
         {
            b = balls[i];
            if(b.active)
            {
               ballsActive = true;
               break;
            }
         }
         if(!ballsActive)
         {
            this.setCueBall = false;
            this.rackSet();
            world = Globals.model.world;
            for(j = 0; j < len; j++)
            {
               currball = balls[j];
               if(world.circleCollision(currball,cueBall))
               {
                  cueBall.resetBall();
                  cueBall.position.x = tableWidth * 0.25;
                  cueBall.position.y = tableHeight * 0.5;
                  break;
               }
            }
         }
         this.shotStartTime = Globals.netController.syncedTime;
      }
      
      override public function turnInPlay() : void
      {
         var shotTime:Number = NaN;
         super.turnInPlay();
         if(playState == PLAYSTATE_IN_MOTION)
         {
            this.shotEndTime = Globals.netController.syncedTime;
            shotTime = this.shotEndTime - this.shotStartTime;
            if(shotTime < 1000)
            {
               this.speedBonusLevel++;
            }
            else
            {
               this.speedBonusLevel = 0;
            }
         }
      }
      
      override protected function evaluateTeamUp() : void
      {
         var focusBall:Ball = null;
         var i:int = 0;
         var numberOfBallsSank:int = ballsSankThisTurn.length;
         var eightBallActive:Boolean = true;
         var scratch:Boolean = false;
         var ballRailContact:int = MathUtil.bitCount(numOfRailsHit);
         var currentPlayer:Player = currentTeam.getCurrentPlayerUp();
         var firstValidBall:int = Ball.BALL_NONE;
         legalBreak = true;
         ballInHand = false;
         if(numberOfBallsSank > 0)
         {
            for(i = 0; i < numberOfBallsSank; i++)
            {
               focusBall = ballsSankThisTurn[i] as Ball;
               if(focusBall.ballType == Ball.BALL_CUE)
               {
                  ballInHand = true;
                  scratch = true;
               }
               else if(firstValidBall == Ball.BALL_NONE)
               {
                  firstValidBall = focusBall.ballType;
               }
            }
         }
         else
         {
            this.consecutiveBallPocket = 0;
            this.speedBonusLevel = 0;
            this.ballQueue.length = 0;
            Globals.view.blitzBottomBar.onViewChange();
         }
         if(scratch)
         {
            this.consecutiveBallPocket = 0;
            this.ballQueue.length = 0;
            Globals.view.blitzBottomBar.onViewChange();
            if(this.scoreMultiplier > 1)
            {
               this.scoreMultiplier--;
            }
            Globals.netController.selfNotification("Foul! Scratch!");
         }
         else if(firstValidBall == Ball.BALL_NONE && !ballInHand)
         {
            if(ballRailContact == 0 || !firstBallHit)
            {
               if(!firstBallHit)
               {
                  Globals.netController.selfNotification("Foul! No contact!");
                  if(this.scoreMultiplier > 1)
                  {
                     this.scoreMultiplier--;
                  }
               }
               else
               {
                  Globals.netController.selfNotification("Foul! No rail after contact!");
                  if(this.scoreMultiplier > 1)
                  {
                     this.scoreMultiplier--;
                  }
               }
            }
         }
      }
      
      override public function update(et:Number) : void
      {
         super.update(et);
         if(this.gameTimer > 0)
         {
            this.gameTimer = this.gameTimer - et;
            if(this.gameTimer <= 0)
            {
               this.gameTimer = 0;
               cueStick.forfeitTurn();
               this.endGamePlay();
            }
         }
      }
      
      override protected function evaluateGame() : int
      {
         return TEAM_NONE;
      }
      
      override public function endGamePlay(timerOverride:Number = 4.0) : void
      {
         super.endGamePlay(timerOverride);
         Globals.netController.selfNotification("Score: " + this.score);
      }
      
      override protected function onBallPocketed(ball:Ball, pocket:Vector3D) : void
      {
         super.onBallPocketed(ball,pocket);
         if(ball.ballType != Ball.BALL_CUE)
         {
            this.consecutiveBallPocket++;
            this.ballQueue.push(ball);
            if(this.consecutiveBallPocket == 5)
            {
               this.scoreMultiplier++;
               this.consecutiveBallPocket = 0;
               this.ballQueue.length = 0;
            }
            if(this.speedBonusLevel >= 3)
            {
               this.speedBonus = (this.speedBonusLevel - 2) * 200;
               if(this.speedBonus < 0)
               {
                  this.speedBonus = 0;
               }
               else if(this.speedBonus > 1000)
               {
                  this.speedBonus = 1000;
               }
            }
            this.score = this.score + this.SHOT_SCORE * this.scoreMultiplier;
            this.score = this.score + this.speedBonus;
            this.gameTimer = this.gameTimer + 4;
            Globals.netController.selfNotification("+" + this.score);
         }
         else
         {
            this.consecutiveBallPocket = 0;
            this.speedBonusLevel = 0;
            if(this.scoreMultiplier > 1)
            {
               this.scoreMultiplier--;
            }
         }
         Globals.view.blitzBottomBar.onViewChange();
      }
      
      public function getTimeLeftAsString() : String
      {
         var mins:int = this.gameTimer / 60;
         var seconds:int = this.gameTimer - 60 * mins;
         var stringSeconds:String = seconds < 10?"0" + String(seconds):String(seconds);
         var timeAsString:String = mins + ":" + stringSeconds;
         return timeAsString;
      }
      
      protected function rackSeven(x:Number, y:Number) : void
      {
         var testBall:Ball = null;
         var increment:Number = Math.PI / 3;
         var radius:Number = cueBall.radius;
         var doubleRadius:Number = radius * 2;
         var centerX:Number = tableWidth * 0.75;
         var centerY:Number = tableHeight * 0.5;
         centerX = x;
         centerY = y;
         var angle:Number = Math.PI;
         for(var i:int = 0; i < 7; i++)
         {
            testBall = balls[i];
            if(testBall.ballNumber == 7)
            {
               testBall.position.x = centerX;
               testBall.position.y = centerY;
            }
            else
            {
               testBall.position.x = Math.cos(angle) * doubleRadius + centerX;
               testBall.position.y = Math.sin(angle) * doubleRadius + centerY;
               angle = angle + increment;
            }
            testBall.resetBall();
         }
      }
      
      protected function rackNine(x:Number, y:Number) : void
      {
         var testBall:Ball = null;
         var oneBall:Ball = null;
         var nineBall:Ball = null;
         var fb:Ball = null;
         var xPosition:Number = tableWidth * 0.75;
         var yPosition:Number = tableHeight * 0.5;
         xPosition = x;
         yPosition = y;
         var doubleRadius:Number = cueBall.radius * 2;
         var j:int = 0;
         var numPerColumn:int = 1;
         var value:Number = 30 * Math.PI / 180;
         var xInc:Number = Math.cos(value) / Math.sin(value) * cueBall.radius;
         var tempArray:Array = [];
         for(j = 0; j < 9; j++)
         {
            fb = balls[j];
            if(fb.ballNumber == 1)
            {
               oneBall = fb;
            }
            else if(fb.ballNumber == 9)
            {
               nineBall = fb;
            }
            else
            {
               tempArray.push(fb);
            }
         }
         var k:int = 0;
         for(var i:int = 0; i < 5; i++)
         {
            for(j = 0; j < numPerColumn; j++)
            {
               if(i == 0 && j == 0)
               {
                  testBall = oneBall;
               }
               else if(i == 2 && j == 1)
               {
                  testBall = nineBall;
               }
               else
               {
                  testBall = tempArray.splice(int(rng.nextDouble() * tempArray.length),1)[0];
               }
               testBall.resetBall();
               testBall.position.x = xPosition;
               testBall.position.y = yPosition + j * doubleRadius;
            }
            if(i > 1)
            {
               numPerColumn--;
               yPosition = yPosition + doubleRadius * 0.5;
            }
            else
            {
               numPerColumn++;
               yPosition = yPosition - doubleRadius * 0.5;
            }
            xPosition = xPosition + xInc;
         }
         tempArray = null;
      }
      
      protected function rackTen(x:Number, y:Number) : void
      {
         var testBall:Ball = null;
         var oneBall:Ball = null;
         var tenBall:Ball = null;
         var fb:Ball = null;
         var xPosition:Number = tableWidth * 0.75;
         var yPosition:Number = tableHeight * 0.5;
         xPosition = x;
         yPosition = y;
         var doubleRadius:Number = cueBall.radius * 2;
         var j:int = 0;
         var numPerColumn:int = 1;
         var value:Number = 30 * Math.PI / 180;
         var xInc:Number = Math.cos(value) / Math.sin(value) * cueBall.radius;
         var tempArray:Array = [];
         for(j = 0; j < 10; j++)
         {
            fb = balls[j];
            if(fb.ballNumber == 1)
            {
               oneBall = fb;
            }
            else if(fb.ballNumber == 10)
            {
               tenBall = fb;
            }
            else
            {
               tempArray.push(fb);
            }
         }
         var k:int = 0;
         for(var i:int = 0; i < 4; i++)
         {
            for(j = 0; j < numPerColumn; j++)
            {
               if(i == 0 && j == 0)
               {
                  testBall = oneBall;
               }
               else if(i == 2 && j == 1)
               {
                  testBall = tenBall;
               }
               else
               {
                  testBall = tempArray.splice(int(rng.nextDouble() * tempArray.length),1)[0];
               }
               testBall.resetBall();
               testBall.position.x = xPosition;
               testBall.position.y = yPosition + j * doubleRadius;
            }
            numPerColumn++;
            yPosition = yPosition - doubleRadius * 0.5;
            xPosition = xPosition + xInc;
         }
         tempArray = null;
      }
      
      protected function rackFifteen(x:Number, y:Number) : void
      {
         var testBall:Ball = null;
         var randomSolid:Ball = null;
         var randomStripe:Ball = null;
         var eightBall:Ball = null;
         var randomBall1:Ball = null;
         var randomBall2:Ball = null;
         var fb:Ball = null;
         var xPosition:Number = tableWidth * 0.75;
         var yPosition:Number = tableHeight * 0.5;
         xPosition = x;
         yPosition = y;
         var doubleRadius:Number = cueBall.radius * 2;
         var j:int = 0;
         var numPerColumn:int = 1;
         var value:Number = 30 * Math.PI / 180;
         var xInc:Number = Math.cos(value) / Math.sin(value) * cueBall.radius;
         var tempArray:Array = [];
         var randomSolidNumber:int = rng.nextIntRange(1,7);
         var randomStripeNumber:int = rng.nextIntRange(9,15);
         for(j = 0; j < 15; j++)
         {
            fb = balls[j];
            if(fb.ballNumber == randomSolidNumber)
            {
               randomSolid = fb;
            }
            else if(fb.ballNumber == randomStripeNumber)
            {
               randomStripe = fb;
            }
            else if(fb.ballNumber == 8)
            {
               eightBall = fb;
            }
            else
            {
               tempArray.push(fb);
            }
         }
         if(rng.nextDouble() < 0.5)
         {
            randomBall1 = randomSolid;
            randomBall2 = randomStripe;
         }
         else
         {
            randomBall1 = randomStripe;
            randomBall2 = randomSolid;
         }
         var k:int = 0;
         for(var i:int = 0; i < 5; i++)
         {
            for(j = 0; j < numPerColumn; j++)
            {
               if(i == 2 && j == 1)
               {
                  testBall = eightBall;
               }
               else if(i == 4 && j == 0)
               {
                  testBall = randomBall1;
               }
               else if(i == 4 && j == 4)
               {
                  testBall = randomBall2;
               }
               else
               {
                  testBall = tempArray.splice(int(rng.nextDouble() * tempArray.length),1)[0];
               }
               testBall.resetBall();
               testBall.position.x = xPosition;
               testBall.position.y = yPosition + j * doubleRadius;
            }
            numPerColumn++;
            xPosition = xPosition + xInc;
            yPosition = yPosition - doubleRadius * 0.5;
         }
         tempArray = null;
      }
   }
}
