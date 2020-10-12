package iilwygames.pool.model.gameplay.Ruleset
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.util.MathUtil;
   
   public class NineBall extends Ruleset
   {
       
      
      public var pushShot:Boolean;
      
      protected var lowestValueBall:Ball;
      
      protected var nineBallActive:Boolean;
      
      public function NineBall(rngSeed:uint = 0, teamCount:int = 2)
      {
         super(rngSeed,teamCount);
         this.pushShot = false;
         this.lowestValueBall = null;
         this.nineBallActive = true;
         gameType = GAMETYPE_NINEBALL;
      }
      
      override protected function rackSet() : void
      {
         var testBall:Ball = null;
         var oneBall:Ball = null;
         var nineBall:Ball = null;
         var fb:Ball = null;
         cueBall.resetBall();
         cueBall.position.x = tableWidth * 0.25;
         cueBall.position.y = tableHeight * 0.5;
         var xPosition:Number = tableWidth * 0.75;
         var yPosition:Number = tableHeight * 0.5;
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
         super.rackSet();
      }
      
      override protected function createBalls() : void
      {
         var newBall:Ball = null;
         cueBall = new Ball();
         cueBall.ballType = Ball.BALL_CUE;
         cueBall.position.x = tableWidth * 0.25;
         cueBall.position.y = tableHeight * 0.5;
         Globals.model.world.addGameObject(cueBall);
         for(var i:int = 0; i < 9; i++)
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
            Globals.model.world.addGameObject(newBall);
            balls.push(newBall);
         }
         super.createBalls();
      }
      
      override public function initialize() : void
      {
         super.initialize();
         Globals.netController.selfNotification("RULES:");
         Globals.netController.selfNotification("1) In all shots including the break, the player must hit the lowest numbered ball on the table.");
         Globals.netController.selfNotification("2) If a player fouls, the opponent will be able to play the cue ball anywhere on the table.");
         Globals.netController.selfNotification("3) Player wins when the nine ball is pocketed with a legal shot.");
      }
      
      override protected function startTurn() : void
      {
         var b:Ball = null;
         super.startTurn();
         if(playState == Ruleset.PLAYSTATE_GAMEOVER)
         {
            return;
         }
         this.lowestValueBall = null;
         if(!this.nineBallActive)
         {
            spotBall(9);
            this.nineBallActive = true;
         }
         for(var i:int = 0; i < balls.length; i++)
         {
            b = balls[i];
            if(b.active)
            {
               if(!this.lowestValueBall || this.lowestValueBall.ballNumber > b.ballNumber)
               {
                  this.lowestValueBall = b;
               }
            }
         }
         if(this.lowestValueBall)
         {
            this.lowestValueBall.hasFocusIndicator = true;
         }
      }
      
      override public function turnInPlay() : void
      {
         this.lowestValueBall.hasFocusIndicator = false;
         super.turnInPlay();
      }
      
      override protected function evaluateTeamUp() : void
      {
         var b:Ball = null;
         var i:int = 0;
         var count:int = ballsSankThisTurn.length;
         var scratch:Boolean = false;
         var ballRailContact:int = MathUtil.bitCount(numOfRailsHit);
         var isBreakShot:Boolean = !legalBreak;
         var currentPlayer:Player = currentTeam.getCurrentPlayerUp();
         var validBallPocketed:Boolean = false;
         if(isBreakShot)
         {
            legalBreak = true;
         }
         var currentTeamIndex:int = teamTurn;
         ballInHand = false;
         if(count > 0)
         {
            for(i = 0; i < count; i++)
            {
               b = ballsSankThisTurn[i];
               if(b.ballType == Ball.BALL_CUE)
               {
                  scratch = true;
               }
               else
               {
                  validBallPocketed = true;
               }
            }
            if(isBreakShot && (scratch && ballRailContact < 4 && count == 1 || this.lowestValueBall != firstBallHit))
            {
               this.rackSet();
            }
            else if(!this.nineBallActive || scratch || this.lowestValueBall != firstBallHit)
            {
               teamTurn = getNextTeamID();
            }
         }
         else if(isBreakShot && (ballRailContact < 4 || this.lowestValueBall != firstBallHit))
         {
            this.rackSet();
         }
         else
         {
            teamTurn = getNextTeamID();
         }
         if(!legalBreak)
         {
            currentPlayer.consecutiveFouls++;
            ballInHand = true;
            Globals.netController.selfNotification("Illegal break " + currentPlayer.consecutiveFouls.toString() + "!");
         }
         else if(scratch)
         {
            currentPlayer.consecutiveFouls++;
            ballInHand = true;
            Globals.netController.selfNotification("Foul! Cue ball scratch!");
         }
         else if(this.lowestValueBall != firstBallHit)
         {
            currentPlayer.consecutiveFouls++;
            ballInHand = true;
            if(firstBallHit == null)
            {
               Globals.netController.selfNotification("Foul! No contact!");
            }
            else
            {
               Globals.netController.selfNotification("Foul! Wrong Ball First!");
            }
         }
         else if(!validBallPocketed && ballRailContact == 0)
         {
            currentPlayer.consecutiveFouls++;
            ballInHand = true;
            Globals.netController.selfNotification("Foul! No rail after contact!");
         }
         else
         {
            currentPlayer.consecutiveFouls = 0;
         }
         if(currentPlayer.consecutiveFouls == 3)
         {
            Globals.netController.selfNotification("Three consecutive fouls! Auto loss!");
            winnerIndex = getNextTeamIDFrom(currentTeamIndex);
            endGamePlay();
         }
      }
      
      override protected function evaluateGame() : int
      {
         var i:int = 0;
         var b:Ball = null;
         var count:int = ballsSankThisTurn.length;
         var scratch:Boolean = false;
         this.nineBallActive = true;
         if(count > 0)
         {
            for(i = 0; i < count; i++)
            {
               b = ballsSankThisTurn[i];
               if(b.ballNumber == 9)
               {
                  this.nineBallActive = false;
               }
               if(b.ballType == Ball.BALL_CUE)
               {
                  scratch = true;
               }
            }
            if(this.lowestValueBall.ballNumber == 9 && scratch)
            {
               return getNextTeamID();
            }
            if(!this.nineBallActive && !scratch)
            {
               if(firstBallHit == this.lowestValueBall)
               {
                  return currentTeam.teamID;
               }
            }
         }
         return TEAM_NONE;
      }
   }
}
