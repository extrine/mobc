package iilwygames.pool.model.gameplay.Ruleset.trickshots
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.core.KeyListener;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.commands.AddBall;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.commands.EditorCommand;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.commands.MoveBall;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.commands.RemoveBall;
   import iilwygames.pool.model.gameplay.Ruleset.trickshots.commands.SetBallTarget;
   import iilwygames.pool.util.MathUtil;
   
   public class Editor extends Trickshot
   {
      
      protected static const MODE_EDIT:int = 0;
      
      protected static const MODE_TEST:int = 1;
       
      
      protected var mode:int;
      
      private var _ballLock:Ball;
      
      private var _startPos:Vector3D;
      
      private var _targetLock:Vector3D;
      
      private var _startTarget:Vector3D;
      
      private var _hadTarget:Boolean;
      
      private const KEYCODE_O:int = 79;
      
      private const KEYCODE_B:int = 66;
      
      private const KEYCODE_Z:int = 90;
      
      private const KEYCODE_Y:int = 89;
      
      private const KEYCODE_D:int = 68;
      
      private const KEYCODE_CTRL:int = 17;
      
      private const KEYCODE_SHIFT:int = 16;
      
      private const KEYCODE_1:int = 49;
      
      private const KEYCODE_2:int = 50;
      
      private const KEYCODE_3:int = 51;
      
      private const KEYCODE_4:int = 52;
      
      private const KEYCODE_5:int = 53;
      
      private const KEYCODE_6:int = 54;
      
      private const KEYCODE_7:int = 55;
      
      private const KEYCODE_8:int = 56;
      
      private const KEYCODE_9:int = 57;
      
      private var _commandHistory:Vector.<EditorCommand>;
      
      private var _commandIndex:int;
      
      private var _ballAvailable:Array;
      
      private var _currentLevel:Level;
      
      private var _blockerBallIndex:int;
      
      private const BLOCKER_BALL_START_INDEX:int = 32;
      
      public function Editor(rngSeed:uint = 0, teamCount:int = 1)
      {
         super(rngSeed,teamCount);
         gameType = GAMETYPE_EDITOR;
         this.mode = MODE_EDIT;
         this._ballLock = null;
         this._startPos = new Vector3D();
         this._startTarget = new Vector3D();
         this._commandHistory = new Vector.<EditorCommand>();
         this._commandIndex = 0;
         this._ballAvailable = [];
         for(var i:int = 0; i < 16; i++)
         {
            this._ballAvailable[i] = true;
         }
      }
      
      override public function destroy() : void
      {
         var cmd:EditorCommand = null;
         super.destroy();
         for each(cmd in this._commandHistory)
         {
            cmd.destroy();
         }
         this._commandHistory = null;
         this._startPos = null;
         this._ballLock = null;
         this._ballAvailable = null;
         this._startTarget = null;
      }
      
      override public function initialize() : void
      {
         _levelManager.loadLevels();
         this.createBalls();
         this.newLevel();
         teamTurn = Globals.model.breakingTeam;
         this.startTurn();
      }
      
      override protected function createBalls() : void
      {
         super.createBalls();
      }
      
      override protected function rackSet() : void
      {
      }
      
      override protected function startTurn() : void
      {
         if(this.mode == MODE_EDIT)
         {
            Globals.model.localPlayer.startPlayerTurn(true);
         }
         else
         {
            super.startTurn();
         }
      }
      
      override public function update(et:Number) : void
      {
         var worldCoord:Vector3D = null;
         var key:KeyListener = null;
         var deleteBall:RemoveBall = null;
         var ballNumber:int = 0;
         if(this.mode == MODE_EDIT)
         {
            worldCoord = Globals.model.localPlayer.mousePosition;
            if(this._targetLock)
            {
               this._targetLock.x = worldCoord.x;
               this._targetLock.y = worldCoord.y;
            }
            else if(this._ballLock)
            {
               this._ballLock.position.x = worldCoord.x;
               this._ballLock.position.y = worldCoord.y;
            }
            else
            {
               key = Globals.keyListener;
               this.userInputUpdate();
               if(key.isKeyDown_ThisFrame(this.KEYCODE_D))
               {
                  deleteBall = new RemoveBall();
                  ballNumber = deleteBall.init(worldCoord.x,worldCoord.y);
                  if(ballNumber > 0)
                  {
                     this.executeCommand(deleteBall);
                     this._ballAvailable[ballNumber] = true;
                  }
               }
               else if(key.isKeyDown_ThisFrame(this.KEYCODE_Z) && key.isKeyDown(this.KEYCODE_CTRL))
               {
                  this.undoCommand();
               }
               else if(key.isKeyDown_ThisFrame(this.KEYCODE_Y) && key.isKeyDown(this.KEYCODE_CTRL))
               {
                  this.redoCommand();
               }
            }
         }
         else if(this.mode == MODE_TEST)
         {
            super.update(et);
         }
      }
      
      private function userInputUpdate() : void
      {
         var addObject:AddBall = null;
         var key:KeyListener = Globals.keyListener;
         var ballIndex:int = -1;
         var worldCoord:Vector3D = Globals.model.localPlayer.mousePosition;
         if(key.isKeyDown_ThisFrame(this.KEYCODE_1))
         {
            ballIndex = 1;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_2))
         {
            ballIndex = 2;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_3))
         {
            ballIndex = 3;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_4))
         {
            ballIndex = 4;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_5))
         {
            ballIndex = 5;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_6))
         {
            ballIndex = 6;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_7))
         {
            ballIndex = 7;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_8))
         {
            ballIndex = 8;
         }
         else if(key.isKeyDown_ThisFrame(this.KEYCODE_9))
         {
            ballIndex = 9;
         }
         if(ballIndex > 0)
         {
            if(key.isKeyDown(this.KEYCODE_SHIFT))
            {
               if(ballIndex <= 6)
               {
                  ballIndex = ballIndex + 9;
               }
            }
            if(this._ballAvailable[ballIndex])
            {
               this._ballAvailable[ballIndex] = false;
               addObject = new AddBall();
               addObject.init(ballIndex,worldCoord.x,worldCoord.y);
               this.executeCommand(addObject);
            }
         }
      }
      
      public function newLevel(resetCommands:Boolean = true) : void
      {
         if(this.mode == MODE_EDIT)
         {
            this.clearLevel();
            cueBall.position.x = tableWidth * 0.25;
            cueBall.position.y = tableHeight * 0.5;
            cueBall.resetBall();
            Globals.view.table.initModels();
            if(resetCommands)
            {
               this.clearHistory();
               this._currentLevel = null;
            }
         }
      }
      
      override protected function loadLevel(level:Level) : void
      {
         this.clearLevel();
         this.clearHistory();
         this._currentLevel = level;
         super.loadLevel(level);
      }
      
      public function saveCurrentLevel(name:String) : void
      {
         var level:Level = null;
         if(this.mode == MODE_EDIT)
         {
            level = new Level();
            level.saveLevel(this);
            level.name = name;
            _levelManager.saveLevel(level);
            this._currentLevel = level;
         }
      }
      
      public function getLevelNames() : Array
      {
         return _levelManager.getLevelNames();
      }
      
      private function clearLevel() : void
      {
         var ball:Ball = null;
         for each(ball in balls)
         {
            Globals.model.world.removeGameObject(ball);
            ball.destroy();
         }
         balls.length = 0;
         Globals.view.table.initModels();
      }
      
      private function clearHistory() : void
      {
         var cmd:EditorCommand = null;
         var i:int = 0;
         for each(cmd in this._commandHistory)
         {
            cmd.destroy();
         }
         this._commandHistory.length = 0;
         this._commandIndex = 0;
         for(i = 0; i < this._ballAvailable.length; i++)
         {
            this._ballAvailable[i] = true;
         }
      }
      
      public function runLevel() : void
      {
         if(this.mode == MODE_EDIT)
         {
            this.mode = MODE_TEST;
            _maxShots = Globals.view.editorView.getShotLimit();
            _timeLimit = Globals.view.editorView.getTimeLimit();
            gameTimer = _timeLimit;
            if(_timeLimit > 0)
            {
               Globals.view.startClock(_timeLimit * 0.001);
            }
            this.startTurn();
         }
      }
      
      override public function processUserInput(idata:InputData) : void
      {
         var magSquared:Number = NaN;
         var clickOnBall:Boolean = false;
         var clickPosition:Vector3D = null;
         var ball:Ball = null;
         var setTarget:SetBallTarget = null;
         var moveBall:MoveBall = null;
         if(this.mode == MODE_EDIT)
         {
            if(idata.type == InputData.ID_MOUSE_DOWN)
            {
               this._targetLock = null;
               clickOnBall = false;
               clickPosition = new Vector3D(idata.mouseX,idata.mouseY);
               for each(ball in balls)
               {
                  magSquared = MathUtil.distanceBetweenPointsSquared(clickPosition,ball.position);
                  if(magSquared < ball.radiusSquared)
                  {
                     clickOnBall = true;
                     this._ballLock = ball;
                     break;
                  }
               }
               if(!this._ballLock)
               {
                  magSquared = MathUtil.distanceBetweenPointsSquared(clickPosition,cueBall.position);
                  if(magSquared < cueBall.radiusSquared)
                  {
                     this._ballLock = cueBall;
                  }
               }
               if(this._ballLock)
               {
                  this._startPos.x = this._ballLock.position.x;
                  this._startPos.y = this._ballLock.position.y;
                  if(idata.isShiftDown && this._ballLock.ballType != Ball.BALL_CUE)
                  {
                     this._hadTarget = this._ballLock.hasTarget;
                     this._startTarget.x = this._ballLock.targetPocket.x;
                     this._startTarget.y = this._ballLock.targetPocket.y;
                     this._targetLock = this._ballLock.targetPocket;
                     this._targetLock.x = idata.mouseX;
                     this._targetLock.y = idata.mouseY;
                     this._ballLock.hasTarget = true;
                  }
                  else if(idata.isShiftDown)
                  {
                     this._ballLock = null;
                  }
               }
            }
            else if(this._targetLock)
            {
               setTarget = new SetBallTarget();
               setTarget.init(this._ballLock,this._startTarget.x,this._startTarget.y,this._hadTarget);
               this.executeCommand(setTarget);
               this._targetLock = null;
               this._ballLock = null;
            }
            else if(this._ballLock)
            {
               moveBall = new MoveBall();
               this._ballLock.position.x = idata.mouseX;
               this._ballLock.position.y = idata.mouseY;
               moveBall.init(this._ballLock.ballNumber,this._startPos.x,this._startPos.y);
               this.executeCommand(moveBall);
               this._ballLock = null;
            }
         }
         else
         {
            super.processUserInput(idata);
         }
      }
      
      override protected function endTurn() : void
      {
         super.endTurn();
      }
      
      override public function endGamePlay(timerOverride:Number = 4.0) : void
      {
         var cmd:EditorCommand = null;
         this.mode = MODE_EDIT;
         this.newLevel(false);
         if(this._currentLevel)
         {
            super.loadLevel(this._currentLevel);
         }
         for(var i:int = 0; i < this._commandIndex; i++)
         {
            cmd = this._commandHistory[i];
            cmd.execute();
         }
         this.startTurn();
         winnerIndex = TEAM_NONE;
         _shotIndex = 0;
         ballsPocketed = 0;
      }
      
      public function executeCommand(cmd:EditorCommand) : void
      {
         var i:int = 0;
         var orphanCmd:EditorCommand = null;
         this._commandHistory[this._commandIndex] = cmd;
         cmd.execute();
         this._commandIndex++;
         if(this._commandHistory.length - this._commandIndex > 0)
         {
            for(i = this._commandIndex; i < this._commandHistory.length; i++)
            {
               orphanCmd = this._commandHistory[i];
               orphanCmd.destroy();
            }
            this._commandHistory.splice(this._commandIndex,this._commandHistory.length - this._commandIndex);
         }
      }
      
      public function undoCommand() : void
      {
         var cmd:EditorCommand = null;
         if(this._commandIndex > 0)
         {
            this._commandIndex--;
            cmd = this._commandHistory[this._commandIndex];
            cmd.undo();
         }
      }
      
      public function redoCommand() : void
      {
         var cmd:EditorCommand = null;
         if(this._commandIndex < this._commandHistory.length)
         {
            cmd = this._commandHistory[this._commandIndex];
            cmd.execute();
            this._commandIndex++;
         }
      }
      
      public function getLevelName() : String
      {
         var name:String = null;
         if(this._currentLevel)
         {
            name = this._currentLevel.name;
         }
         return name;
      }
      
      public function getCurrentLevel() : Level
      {
         return this._currentLevel;
      }
   }
}
