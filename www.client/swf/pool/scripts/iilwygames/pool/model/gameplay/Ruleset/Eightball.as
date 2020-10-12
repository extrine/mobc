package iilwygames.pool.model.gameplay.Ruleset
{
   import iilwygames.pool.achievements.AchievementManager;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerRemote;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Team;
   import iilwygames.pool.network.NetworkMessage;
   import iilwygames.pool.util.MathUtil;
   
   public class Eightball extends Ruleset
   {
       
      
      public function Eightball(rngSeed:uint, teamCount:int = 2)
      {
         var t:Team = null;
         super(rngSeed,teamCount);
         for each(t in teams)
         {
            t.teamBallType = Ball.BALL_NONE;
         }
         gameType = GAMETYPE_EIGHTBALL;
      }
      
      override protected function rackSet() : void
      {
         var testBall:Ball = null;
         var randomSolid:Ball = null;
         var randomStripe:Ball = null;
         var eightBall:Ball = null;
         var randomBall1:Ball = null;
         var randomBall2:Ball = null;
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
         for(var i:int = 0; i < 15; i++)
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
      
      override protected function startTurn() : void
      {
         super.startTurn();
         if(playState == Ruleset.PLAYSTATE_GAMEOVER)
         {
            return;
         }
         if(currentTeam)
         {
            if(this.getNumOfBallType(currentTeam.teamBallType) > 0)
            {
               choosingPocket = false;
            }
         }
      }
      
      public function getNumOfBallType(type:int) : int
      {
         var focusBall:Ball = null;
         var numballs:int = 0;
         for(var i:int = 0; i < balls.length; i++)
         {
            focusBall = balls[i];
            if(focusBall.ballType == type && focusBall.active && focusBall.ballNumber != 8)
            {
               numballs++;
            }
         }
         return numballs;
      }
      
      override protected function evaluateTeamUp() : void
      {
         var focusBall:Ball = null;
         var i:int = 0;
         var currentPlayer:Player = null;
         var nextTeamUp:Team = null;
         var playerA:Player = null;
         var playerB:Player = null;
         var am:AchievementManager = null;
         var numberOfBallsSank:int = ballsSankThisTurn.length;
         var teamColor:int = currentTeam.teamBallType;
         var eightBallActive:Boolean = true;
         var scratch:Boolean = false;
         var ballRailContact:int = MathUtil.bitCount(numOfRailsHit);
         currentPlayer = currentTeam.getCurrentPlayerUp();
         ballInHand = false;
         var tableOpen:Boolean = teamColor == Ball.BALL_NONE;
         var firstValidBall:int = Ball.BALL_NONE;
         var numTeamBallsPocketed:int = 0;
         var isBreakShot:Boolean = !legalBreak;
         if(isBreakShot)
         {
            legalBreak = true;
         }
         if(numberOfBallsSank > 0)
         {
            for(i = 0; i < numberOfBallsSank; i++)
            {
               focusBall = ballsSankThisTurn[i] as Ball;
               if(focusBall.ballType == Ball.BALL_CUE)
               {
                  scratch = true;
               }
               else if(firstValidBall == Ball.BALL_NONE)
               {
                  firstValidBall = focusBall.ballType;
               }
               if(focusBall.ballType == teamColor && focusBall.ballNumber != 8)
               {
                  numTeamBallsPocketed++;
               }
               if(focusBall.ballNumber == 8)
               {
                  eightBallActive = false;
               }
            }
            if(!eightBallActive && isBreakShot)
            {
               this.rackSet();
               if(scratch)
               {
                  teamTurn = getNextTeamID();
               }
            }
            else if(scratch)
            {
               if(isBreakShot && ballRailContact < 4 && numberOfBallsSank == 1)
               {
                  this.rackSet();
               }
               else
               {
                  teamTurn = getNextTeamID();
               }
            }
            else if(tableOpen && !isBreakShot && firstBallHit.ballNumber != 8)
            {
               currentTeam.teamBallType = firstValidBall;
               nextTeamUp = teams[getNextTeamID()];
               if(firstValidBall == Ball.BALL_SOLID)
               {
                  nextTeamUp.teamBallType = Ball.BALL_STRIPE;
               }
               else
               {
                  nextTeamUp.teamBallType = Ball.BALL_SOLID;
               }
               playerA = currentTeam.getCurrentPlayerUp();
               if(currentTeam.teamBallType == Ball.BALL_STRIPE)
               {
                  Globals.netController.selfNotification(playerA.playerData.profileName + " is Stripes");
               }
               else
               {
                  Globals.netController.selfNotification(playerA.playerData.profileName + " is Solids");
               }
               playerB = nextTeamUp.getCurrentPlayerUp();
               if(nextTeamUp.teamBallType == Ball.BALL_STRIPE)
               {
                  Globals.netController.selfNotification(playerB.playerData.profileName + " is Stripes");
               }
               else
               {
                  Globals.netController.selfNotification(playerB.playerData.profileName + " is Solids");
               }
               Globals.view.bottomBar.setTeamType();
            }
            else if(tableOpen && firstBallHit.ballNumber == 8)
            {
               teamTurn = getNextTeamID();
            }
            else if(!tableOpen)
            {
               if(firstBallHit && firstBallHit.ballType != teamColor || numTeamBallsPocketed == 0)
               {
                  teamTurn = getNextTeamID();
               }
               else if(firstBallHit && firstBallHit.ballNumber == 8 && (this.getNumOfBallType(teamColor) > 0 || numTeamBallsPocketed))
               {
                  teamTurn = getNextTeamID();
               }
            }
         }
         else if(isBreakShot && ballRailContact < 4)
         {
            this.rackSet();
         }
         else
         {
            teamTurn = getNextTeamID();
         }
         if(!legalBreak)
         {
            ballInHand = true;
            currentPlayer.consecutiveFouls++;
            Globals.netController.selfNotification("Illegal break!");
         }
         else if(scratch)
         {
            ballInHand = true;
            Globals.netController.selfNotification("Foul! Cue ball scratch!");
         }
         else if(firstBallHit && firstBallHit.ballNumber == 8)
         {
            if(tableOpen || this.getNumOfBallType(teamColor) > 0 || numTeamBallsPocketed)
            {
               ballInHand = true;
               Globals.netController.selfNotification("Foul! Wrong ball first!");
            }
         }
         else if(firstBallHit && firstBallHit.ballType != teamColor && !tableOpen)
         {
            ballInHand = true;
            Globals.netController.selfNotification("Foul! Wrong ball first!");
         }
         if(firstValidBall == Ball.BALL_NONE && !ballInHand)
         {
            if(ballRailContact == 0 || !firstBallHit)
            {
               ballInHand = true;
               if(!firstBallHit)
               {
                  Globals.netController.selfNotification("Foul! No contact!");
               }
               else
               {
                  Globals.netController.selfNotification("Foul! No rail after contact!");
               }
            }
         }
         if(currentPlayer.consecutiveFouls == 5)
         {
            Globals.netController.selfNotification("Five consecutive illegal breaks! Auto loss!");
            winnerIndex = getNextTeamID();
            this.endGamePlay();
            return;
         }
         if(teamTurn == currentTeam.teamID && legalBreak)
         {
            currentTeam.consecutiveTurns++;
         }
         else
         {
            currentTeam.consecutiveTurns = 0;
         }
         if(Globals.model.localPlayer && Globals.model.localPlayer.teamID == currentTeam.teamID)
         {
            am = Globals.achievementManager;
            if(isBreakShot && legalBreak)
            {
               am.testAchievement("ninja_breaker");
               am.testAchievement("break_down");
            }
            if(scratch)
            {
               numberOfBallsSank = numberOfBallsSank - 1;
            }
            Globals.model.localPlayer.ballsPocketed = Globals.model.localPlayer.ballsPocketed + numberOfBallsSank;
            Globals.netController.incrementGenericNumber("total_pocketed",numberOfBallsSank);
            am.testAchievement("on_a_roll");
            am.testAchievement("two_fer");
            am.testAchievement("i_meant_to_do_that");
            am.testAchievement("balls_to_the_wall");
            am.testAchievement("baller");
            am.testAchievement("ball_assassin");
            am.testAchievement("ball_buster");
         }
      }
      
      override public function endGamePlay(timerOverride:Number = 4.0) : void
      {
         var winningTeam:Team = null;
         if(playState == PLAYSTATE_GAMEOVER)
         {
            return;
         }
         var localPlayer:Player = Globals.model.localPlayer;
         if(localPlayer && !singlePlayer)
         {
            if(localPlayer.teamID == winnerIndex)
            {
               localPlayer.winStreak++;
               localPlayer.winsCount++;
               Globals.netController.incrementGenericNumber("total_wins",1);
               Globals.netController.incrementGenericNumber("win_streak",1);
               winningTeam = teams[winnerIndex];
               if(winningTeam.teamBallType == Ball.BALL_SOLID)
               {
                  localPlayer.winsAsSolids++;
                  Globals.netController.incrementGenericNumber("solid_wins",1);
               }
               else
               {
                  localPlayer.winsAsStripes++;
                  Globals.netController.incrementGenericNumber("stripe_wins",1);
               }
            }
            else
            {
               localPlayer.winStreak = 0;
               Globals.netController.setGenericNumber("win_streak",0);
            }
            Globals.achievementManager.postGameAchievementTests();
         }
         super.endGamePlay(timerOverride);
      }
      
      override protected function evaluateGame() : int
      {
         var am:AchievementManager = null;
         var active_Stripes:int = 0;
         var active_Solids:int = 0;
         var stripes_pocketed:int = 0;
         var solids_pocketed:int = 0;
         var numberBalls:int = balls.length;
         var ballsSunk:int = ballsSankThisTurn.length;
         var focusBall:Ball = null;
         var eightBallActive:Boolean = true;
         var teamBallType:int = currentTeam.teamBallType;
         var foul:Boolean = false;
         if(Globals.model.localPlayer && Globals.model.localPlayer.teamID == currentTeam.teamID)
         {
            am = Globals.achievementManager;
            am.testAchievement("black_death");
         }
         if(!legalBreak)
         {
            return TEAM_NONE;
         }
         for(var i:int = 0; i < numberBalls; i++)
         {
            focusBall = balls[i];
            if(focusBall.ballNumber == 8)
            {
               if(!focusBall.active)
               {
                  eightBallActive = false;
               }
            }
            else if(focusBall.ballType == Ball.BALL_SOLID && focusBall.active)
            {
               active_Solids++;
            }
            else if(focusBall.ballType == Ball.BALL_STRIPE && focusBall.active)
            {
               active_Stripes++;
            }
         }
         for(i = 0; i < ballsSunk; i++)
         {
            focusBall = ballsSankThisTurn[i];
            if(focusBall.ballNumber != 8)
            {
               if(focusBall.ballType == Ball.BALL_SOLID)
               {
                  solids_pocketed++;
               }
               else
               {
                  stripes_pocketed++;
               }
            }
         }
         if(ballsSunk == 1 && !eightBallActive)
         {
            if(firstBallHit.ballNumber != 8)
            {
               return getNextTeamID();
            }
            if(teamBallType == Ball.BALL_SOLID && active_Solids == 0 || teamBallType == Ball.BALL_STRIPE && active_Stripes == 0)
            {
               return currentTeam.teamID;
            }
            return getNextTeamID();
         }
         if(ballsSunk > 0)
         {
            if(!eightBallActive)
            {
               if(!cueBall.active || firstBallHit.ballNumber != 8)
               {
                  return getNextTeamID();
               }
               if(teamBallType == Ball.BALL_SOLID && solids_pocketed == 0 && active_Solids == 0)
               {
                  return currentTeam.teamID;
               }
               if(teamBallType == Ball.BALL_STRIPE && stripes_pocketed == 0 && active_Stripes == 0)
               {
                  return currentTeam.teamID;
               }
               return getNextTeamID();
            }
         }
         return TEAM_NONE;
      }
      
      override public function sendSnapGameSnapshot(playerJID:String = null) : void
      {
         var id:InputData = null;
         var data:* = undefined;
         var msg:NetworkMessage = snapShot.packageSnapShot();
         var idArray:Array = [];
         for(var i:int = 0; i < inputHistory.length; i++)
         {
            id = inputHistory[i];
            if(id.turnIndex == turnNumber)
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
         msg.data.ta = teams[0].teamBallType;
         if(numberOfTeams > 1)
         {
            msg.data.tb = teams[1].teamBallType;
         }
         Globals.netMediator.sendNetworkMessage(msg,playerJID);
      }
      
      override public function applySnapShot(msg:NetworkMessage) : void
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
            if(ballIndex < balls.length)
            {
               ball = balls[ballIndex];
               ball.resetBall();
               ball.position.x = xpos;
               ball.position.y = ypos;
               ball.active = isActive;
               if(!isActive)
               {
                  ball.initPocketBall(ballsPocketed++);
               }
            }
            else
            {
               cueBall.position.x = xpos;
               cueBall.position.y = ypos;
            }
            ballIndex++;
         }
         teamTurn = msg.data.tu;
         ballInHand = msg.data.ih > 0?Boolean(true):Boolean(false);
         var pl:PlayerRemote = getCurrentPlayerUp() as PlayerRemote;
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
         turnNumber = msg.data.ti - 1;
         if(isNaN(msg.data.ta) == false)
         {
            teams[0].teamBallType = msg.data.ta;
         }
         if(isNaN(msg.data.tb) == false)
         {
            teams[1].teamBallType = msg.data.tb;
         }
         if(teams[0].teamBallType != Ball.BALL_NONE)
         {
            Globals.view.bottomBar.setTeamType();
         }
         this.startTurn();
      }
   }
}
