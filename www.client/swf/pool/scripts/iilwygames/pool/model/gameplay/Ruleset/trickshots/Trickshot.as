package iilwygames.pool.model.gameplay.Ruleset.trickshots
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.PlayerLocal;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class Trickshot extends Ruleset
   {
       
      
      protected var _levelManager:LevelManager;
      
      protected var _level:Level;
      
      protected var _maxShots:int;
      
      protected var _timeLimit:Number;
      
      protected var _shotIndex:int;
      
      public var gameTimer:Number;
      
      public function Trickshot(rngSeed:uint = 0, teamCount:int = 1)
      {
         super(rngSeed,teamCount);
         this._levelManager = Globals.levelManager;
         this._maxShots = 1;
         this._timeLimit = -1;
         this._shotIndex = 0;
      }
      
      override public function destroy() : void
      {
      }
      
      override public function initialize() : void
      {
         this._levelManager.loadLevels();
         teamTurn = Globals.model.breakingTeam;
         this._shotIndex = 0;
      }
      
      override protected function createBalls() : void
      {
         cueBall = new Ball();
         cueBall.ballType = Ball.BALL_CUE;
         cueBall.position.x = tableWidth * 0.25;
         cueBall.position.y = tableHeight * 0.5;
         Globals.model.world.addGameObject(cueBall);
      }
      
      override protected function rackSet() : void
      {
         super.rackSet();
         breakHit = false;
         suppressSounds = false;
      }
      
      protected function loadLevel(level:Level) : void
      {
         cueBall.resetBall();
         level.loadLevel(this);
         this.gameTimer = level.shotLimit;
         this._timeLimit = level.shotLimit;
         Globals.view.table.initModels();
         if(this._timeLimit > 0)
         {
            Globals.view.startClock(this._timeLimit * 0.001);
         }
      }
      
      public function loadLevelByName(name:String) : void
      {
         var level:Level = this._levelManager.getLevel(name);
         this.loadLevel(level);
      }
      
      override protected function startTurn() : void
      {
         var b:Ball = null;
         ballsSankThisTurn.length = 0;
         currentTeam = teams[teamTurn];
         playState = PLAYSTATE_SHOOTING;
         firstBallHit = null;
         numOfRailsHit = 0;
         this._shotIndex++;
         var currPlayer:PlayerLocal = getCurrentPlayerUp() as PlayerLocal;
         if(currPlayer)
         {
            Globals.productManager.onTurnStart(currPlayer);
            initTurnForPlayer(currPlayer);
         }
         for(var i:int = 0; i < balls.length; i++)
         {
            b = balls[i];
            b.railsHit = 0;
            b.railsHitBeforeFirstHit = 0;
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
               endGamePlay();
            }
         }
      }
      
      override protected function endTurn() : void
      {
         Globals.productManager.onTurnEnd();
         winnerIndex = this.evaluateGame();
         if(winnerIndex == TEAM_NONE)
         {
            this.startTurn();
         }
         else
         {
            endGamePlay();
         }
      }
      
      override protected function evaluateGame() : int
      {
         var b:Ball = null;
         var correctPocket:Boolean = false;
         if(firstBallHit && firstBallHit.ballType == Ball.BALL_STRIPE)
         {
            return teamTurn + 1;
         }
         if(!cueBall.active)
         {
            return teamTurn + 1;
         }
         var activeCount:int = 0;
         for(var i:int = 0; i < balls.length; i++)
         {
            b = balls[i];
            if(b.ballType != Ball.BALL_STRIPE)
            {
               if(b.active)
               {
                  activeCount++;
               }
               else if(b.hasTarget)
               {
                  correctPocket = b.checkValidPocket();
                  if(!correctPocket)
                  {
                     return teamTurn + 1;
                  }
               }
            }
         }
         if(activeCount == 0)
         {
            return teamTurn;
         }
         if(this._shotIndex == this._maxShots)
         {
            return teamTurn + 1;
         }
         return TEAM_NONE;
      }
      
      override public function processEndGame() : void
      {
         if(winnerIndex == teamTurn)
         {
         }
      }
   }
}
