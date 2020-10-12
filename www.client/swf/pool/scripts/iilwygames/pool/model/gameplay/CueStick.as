package iilwygames.pool.model.gameplay
{
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerLocal;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.model.physics.Wall;
   import iilwygames.pool.util.MathUtil;
   
   public class CueStick
   {
      
      public static const STATE_AIMING:int = 1;
      
      public static const STATE_SHOOTING:int = 2;
      
      public static const STATE_WAITING:int = 3;
      
      public static const STATE_BALLINHAND:int = 4;
      
      public static const STATE_CUEINHAND_START:int = 5;
      
      public static const STATE_HITTING:int = 6;
      
      public static const STATE_POCKET_CHOICE:int = 7;
       
      
      public var angle:Number;
      
      public var power:Number;
      
      public var tipPosition:Vector3D;
      
      public var aimVector:Vector3D;
      
      public var cueDotControl:Vector3D;
      
      public var ghostBall:GhostBall;
      
      public var ballHit:Boolean;
      
      public var wallHit:Boolean;
      
      public var normalResult:Vector3D;
      
      public var tangentResult:Vector3D;
      
      public var cueBallCollisions:Vector.<Vector3D>;
      
      public var active:Boolean;
      
      public var showGuide:Boolean;
      
      public var useHand:Boolean;
      
      public var state:int;
      
      public var currentPlayer:Player;
      
      public var alpha:Number;
      
      public var guideLevel:int;
      
      public var bounceLevel:int;
      
      public var powerLevel:int;
      
      private var _powerMultiplier:Number;
      
      private const MAX_POWER:Number = 0.5;
      
      private const FLIP_AIM:Boolean = true;
      
      private var targetBall:Ball;
      
      private var savePosition:Vector3D;
      
      private var saveCuePosition:Vector3D;
      
      private var stickHittingPos:Number;
      
      private var generalVector:Vector3D;
      
      public function CueStick()
      {
         super();
         this.alpha = 0;
         this.angle = -1;
         this.power = 0;
         this.aimVector = new Vector3D();
         this.cueDotControl = new Vector3D();
         this.generalVector = new Vector3D();
         this.normalResult = new Vector3D();
         this.savePosition = new Vector3D();
         this.saveCuePosition = new Vector3D();
         this.tangentResult = new Vector3D();
         this.tipPosition = new Vector3D();
         this.cueBallCollisions = new Vector.<Vector3D>();
         this.currentPlayer = null;
         this.ghostBall = new GhostBall();
         this.targetBall = null;
         this.ballHit = false;
         this.wallHit = false;
         this.showGuide = false;
         this.useHand = false;
         this.guideLevel = 1;
         this.bounceLevel = 0;
         this.powerLevel = 0;
         this._powerMultiplier = 1;
      }
      
      public function destroy() : void
      {
         this.ghostBall.destroy();
         this.aimVector = null;
         this.cueDotControl = null;
         this.generalVector = null;
         this.normalResult = null;
         this.savePosition = null;
         this.saveCuePosition = null;
         this.tangentResult = null;
         this.tipPosition = null;
         this.currentPlayer = null;
         this.ghostBall = null;
         this.targetBall = null;
         this.cueBallCollisions = null;
      }
      
      public function setGuideLevel(level:int) : void
      {
         this.guideLevel = level;
      }
      
      public function setBounceLevel(level:int) : void
      {
         this.bounceLevel = level;
      }
      
      public function setPowerLevel(level:int) : void
      {
         this.powerLevel = level;
         if(this.powerLevel == 0)
         {
            this._powerMultiplier = 1;
         }
         else
         {
            this._powerMultiplier = 1 + this.powerLevel * 0.35;
         }
      }
      
      public function startTurnFor(player:Player) : void
      {
         var cueBall:Ball = null;
         var rs:Ruleset = Globals.model.ruleset;
         this.useHand = false;
         if(this.currentPlayer != player)
         {
            if(this.currentPlayer)
            {
               this.currentPlayer.tableRelenquished = true;
            }
            this.currentPlayer = player;
         }
         this.state = STATE_AIMING;
         this.angle = 0;
         this.cueDotControl.x = 0;
         this.cueDotControl.y = 0;
         if(this.currentPlayer)
         {
            this.active = true;
         }
         else
         {
            this.active = false;
         }
         if(this.currentPlayer is PlayerLocal)
         {
            this.showGuide = true;
         }
         else
         {
            this.showGuide = false;
         }
         if(rs.choosingPocket)
         {
            this.state = STATE_POCKET_CHOICE;
            this.active = false;
         }
         else if(rs.ballInHand && rs.legalBreak)
         {
            this.state = STATE_CUEINHAND_START;
            this.active = false;
            if(this.showGuide)
            {
               this.useHand = true;
            }
            cueBall = Globals.model.ruleset.cueBall;
            cueBall.position.x = this.currentPlayer.mousePosition.x;
            cueBall.position.y = this.currentPlayer.mousePosition.y;
         }
         Globals.view.cueStickView.redrawCue();
      }
      
      public function processInputData(id:InputData) : Boolean
      {
         var clickOnBall:Boolean = false;
         var magSquared:Number = NaN;
         var shootVector:Vector3D = null;
         var clickPosition:Vector3D = this.generalVector;
         clickPosition.x = id.mouseX;
         clickPosition.y = id.mouseY;
         var rs:Ruleset = Globals.model.ruleset;
         var playState:int = rs.playState;
         var cueBall:Ball = rs.cueBall;
         if(playState == Ruleset.PLAYSTATE_IN_MOTION)
         {
            return false;
         }
         if(id.turnIndex != rs.turnNumber)
         {
            return false;
         }
         if(id.type == InputData.ID_MOUSE_DOWN)
         {
            if(this.state == STATE_AIMING)
            {
               clickOnBall = false;
               magSquared = MathUtil.distanceBetweenPointsSquared(clickPosition,cueBall.position);
               if(magSquared < cueBall.radiusSquared)
               {
                  clickOnBall = true;
               }
               if(rs.ballInHand && clickOnBall)
               {
                  this.state = STATE_BALLINHAND;
                  this.savePosition.x = cueBall.position.x;
                  this.savePosition.y = cueBall.position.y;
                  this.active = false;
                  if(Globals.model.ruleset.breakHit)
                  {
                     Globals.view.table.showKitchenArea();
                  }
               }
               else
               {
                  this.state = STATE_SHOOTING;
                  this.savePosition.x = clickPosition.x;
                  this.savePosition.y = clickPosition.y;
                  if(this.FLIP_AIM)
                  {
                     this.aimVector.x = clickPosition.x - cueBall.position.x;
                     this.aimVector.y = clickPosition.y - cueBall.position.y;
                  }
                  else
                  {
                     this.aimVector.x = cueBall.position.x - clickPosition.x;
                     this.aimVector.y = cueBall.position.y - clickPosition.y;
                  }
                  this.aimVector.normalize();
               }
               return true;
            }
            if(this.state == STATE_CUEINHAND_START)
            {
               if(this.dropCueBall(clickPosition.x,clickPosition.y))
               {
                  this.state = STATE_AIMING;
                  this.active = true;
               }
               else
               {
                  trace("no can do, but where is the cue ball now?");
               }
               return true;
            }
            if(this.state == STATE_POCKET_CHOICE)
            {
               if(rs.ballInHand)
               {
                  this.state = STATE_CUEINHAND_START;
               }
               else
               {
                  this.state = STATE_AIMING;
                  this.active = true;
               }
               return true;
            }
         }
         else if(id.type == InputData.ID_MOUSE_UP)
         {
            if(this.state == STATE_SHOOTING)
            {
               shootVector = clickPosition.subtract(this.savePosition);
               this.power = shootVector.dotProduct(this.aimVector) / this.aimVector.dotProduct(this.aimVector);
               this.saveCuePosition.x = id.cueX;
               this.saveCuePosition.y = id.cueY;
               if(this.power >= 0)
               {
                  this.state = STATE_AIMING;
               }
               else
               {
                  this.hitCue();
               }
               return true;
            }
            if(this.state == STATE_BALLINHAND)
            {
               if(this.dropCueBall(clickPosition.x,clickPosition.y) == false)
               {
                  cueBall.position.x = this.savePosition.x;
                  cueBall.position.y = this.savePosition.y;
               }
               this.state = STATE_AIMING;
               this.active = true;
               this.useHand = false;
               Globals.view.table.hideKitchenArea();
               return true;
            }
         }
         return false;
      }
      
      public function update(et:Number) : void
      {
         var newAngle:Number = NaN;
         var worldCoord:Vector3D = null;
         var savedWorldCoord:Vector3D = null;
         var magSquared:Number = NaN;
         var shootVector:Vector3D = null;
         var temppower:Number = NaN;
         var tipMag:Number = NaN;
         var closestPosition:Vector3D = null;
         var closestDistance:Number = NaN;
         var maxLength:Number = NaN;
         var aimVectorLength:Number = NaN;
         var normalScale:Number = NaN;
         var tanScale:Number = NaN;
         var cueBall:Ball = Globals.model.ruleset.cueBall;
         var rs:Ruleset = Globals.model.ruleset;
         if(this.currentPlayer)
         {
            if(this.state == STATE_AIMING)
            {
               worldCoord = this.currentPlayer.mousePosition;
               if(this.FLIP_AIM)
               {
                  this.aimVector.x = worldCoord.x - cueBall.position.x;
                  this.aimVector.y = worldCoord.y - cueBall.position.y;
               }
               else
               {
                  this.aimVector.x = cueBall.position.x - worldCoord.x;
                  this.aimVector.y = cueBall.position.y - worldCoord.y;
               }
               this.aimVector.normalize();
               newAngle = Math.atan2(this.aimVector.y,this.aimVector.x);
               this.tipPosition.x = cueBall.position.x + this.aimVector.x * -cueBall.radius;
               this.tipPosition.y = cueBall.position.y + this.aimVector.y * -cueBall.radius;
               magSquared = MathUtil.distanceBetweenPointsSquared(worldCoord,cueBall.position);
               if(magSquared < cueBall.radiusSquared && rs.ballInHand && this.currentPlayer is PlayerLocal)
               {
                  this.active = false;
                  this.useHand = true;
               }
               else if(!this.active && !Globals.movieClipPlayer.mouseTakeover)
               {
                  this.active = true;
                  this.useHand = false;
               }
            }
            else if(this.state == STATE_CUEINHAND_START)
            {
               worldCoord = this.currentPlayer.mousePosition;
               cueBall.position.x = worldCoord.x;
               cueBall.position.y = worldCoord.y;
            }
            else if(this.state == STATE_BALLINHAND)
            {
               worldCoord = this.currentPlayer.mousePosition;
               cueBall.position.x = worldCoord.x;
               cueBall.position.y = worldCoord.y;
            }
            else if(this.state == STATE_SHOOTING)
            {
               newAngle = Math.atan2(this.aimVector.y,this.aimVector.x);
               worldCoord = this.currentPlayer.mousePosition;
               savedWorldCoord = this.savePosition;
               shootVector = worldCoord.subtract(savedWorldCoord);
               temppower = shootVector.dotProduct(this.aimVector) / this.aimVector.dotProduct(this.aimVector);
               if(temppower < -this.MAX_POWER)
               {
                  temppower = -this.MAX_POWER;
               }
               tipMag = Math.min(0,temppower) - cueBall.radius;
               this.tipPosition.x = cueBall.position.x + this.aimVector.x * tipMag;
               this.tipPosition.y = cueBall.position.y + this.aimVector.y * tipMag;
            }
            else if(this.state == STATE_HITTING)
            {
               this.stickHittingPos = this.stickHittingPos + (-cueBall.radius - this.stickHittingPos) * et * 20;
               this.tipPosition.x = cueBall.position.x + this.aimVector.x * this.stickHittingPos;
               this.tipPosition.y = cueBall.position.y + this.aimVector.y * this.stickHittingPos;
               if(this.stickHittingPos > -cueBall.radius * 1.2)
               {
                  this.onHit();
               }
            }
            if(this.angle != newAngle && (this.state == STATE_AIMING || this.state == STATE_SHOOTING))
            {
               this.angle = newAngle;
               this.cueBallCollisions.length = 0;
               this.wallHit = false;
               this.ballHit = false;
               this.findCueCollisions(this.bounceLevel + 1,cueBall.position,this.aimVector);
               if(this.ballHit)
               {
                  closestPosition = this.cueBallCollisions[this.cueBallCollisions.length - 1];
                  closestDistance = closestPosition.subtract(cueBall.position).length;
                  this.ghostBall.position.x = closestPosition.x;
                  this.ghostBall.position.y = closestPosition.y;
                  this.normalResult.x = this.targetBall.position.x - this.ghostBall.position.x;
                  this.normalResult.y = this.targetBall.position.y - this.ghostBall.position.y;
                  maxLength = 6 * cueBall.radius;
                  aimVectorLength = -1 / 4 * Globals.model.ruleset.tableWidth * closestDistance + 1;
                  this.normalResult.normalize();
                  this.tangentResult.x = this.normalResult.y;
                  this.tangentResult.y = -this.normalResult.x;
                  normalScale = this.normalResult.dotProduct(this.aimVector);
                  tanScale = this.tangentResult.dotProduct(this.aimVector);
                  if(this.guideLevel == 0)
                  {
                     aimVectorLength = -1 / 2 * Globals.model.ruleset.tableWidth * closestDistance + 1;
                  }
                  else if(this.guideLevel == 1)
                  {
                     aimVectorLength = -1 / 4 * Globals.model.ruleset.tableWidth * closestDistance + 1;
                  }
                  else if(this.guideLevel == 2)
                  {
                     aimVectorLength = -1 / 8 * Globals.model.ruleset.tableWidth * closestDistance + 1;
                  }
                  else if(this.guideLevel == 3)
                  {
                     maxLength = 8 * cueBall.radius;
                     aimVectorLength = -1 / (8 * Globals.model.ruleset.tableWidth * closestDistance) + 1;
                  }
                  else if(this.guideLevel == 4)
                  {
                     maxLength = 12 * cueBall.radius;
                     aimVectorLength = 1;
                  }
                  if(aimVectorLength > 1)
                  {
                     aimVectorLength = 1;
                  }
                  else if(aimVectorLength < 0)
                  {
                     aimVectorLength = 0;
                  }
                  aimVectorLength = aimVectorLength * maxLength;
                  this.normalResult.scaleBy(normalScale * aimVectorLength);
                  this.tangentResult.scaleBy(tanScale * aimVectorLength);
                  this.normalResult.incrementBy(this.ghostBall.position);
                  this.tangentResult.incrementBy(this.ghostBall.position);
               }
            }
         }
         if(this.active)
         {
            if(this.alpha < 1)
            {
               this.alpha = this.alpha + et * 10;
               if(this.alpha >= 1)
               {
                  this.alpha = 1;
               }
            }
         }
      }
      
      private function findCueCollisions(depth:int, start:Vector3D, direction:Vector3D) : void
      {
         var i:int = 0;
         var B:Vector3D = null;
         var C:Vector3D = null;
         var AB:Vector3D = null;
         var AC:Vector3D = null;
         var focusBall:Ball = null;
         var ACdotAB:Number = NaN;
         var BC:Vector3D = null;
         var D:Number = NaN;
         var focusWall:Wall = null;
         var wallNormal:Vector3D = null;
         var wallNormalScaled:Vector3D = null;
         var test:Number = NaN;
         var scale:Number = NaN;
         if(depth == 0)
         {
            return;
         }
         depth = depth - 1;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         var cueBall:Ball = Globals.model.ruleset.cueBall;
         var numObjects:int = balls.length;
         var radiusCheck:Number = cueBall.radius * cueBall.radius * 4;
         this.targetBall = null;
         var closestPosition:Vector3D = new Vector3D();
         var closestDistance:Number = Number.MAX_VALUE;
         var A:Vector3D = start;
         for(i = 0; i < numObjects; i++)
         {
            focusBall = balls[i];
            if(focusBall.active != false)
            {
               B = focusBall.position;
               AB = B.subtract(A);
               AC = direction;
               ACdotAB = AB.dotProduct(AC);
               if(ACdotAB > 0)
               {
                  C = new Vector3D(AC.x * ACdotAB + A.x,AC.y * ACdotAB + A.y);
                  BC = C.subtract(B);
                  if(BC.lengthSquared < radiusCheck * 0.99)
                  {
                     D = radiusCheck - BC.lengthSquared;
                     D = Math.sqrt(D);
                     C = new Vector3D(C.x - AC.x * D,C.y - AC.y * D);
                     AC = C.subtract(A);
                     if(AC.length < closestDistance)
                     {
                        closestDistance = AC.length;
                        closestPosition.x = C.x;
                        closestPosition.y = C.y;
                        this.targetBall = focusBall;
                        this.ballHit = true;
                     }
                  }
               }
            }
         }
         var walls:Vector.<Wall> = Globals.model.ruleset.quickWallCheck;
         numObjects = walls.length;
         for(i = 0; i < numObjects; i++)
         {
            focusWall = walls[i];
            wallNormal = focusWall.normal.clone();
            wallNormalScaled = focusWall.normal.clone();
            wallNormalScaled.scaleBy(cueBall.radius);
            C = focusWall.pointA.add(wallNormalScaled);
            AC = C.subtract(A);
            test = direction.dotProduct(wallNormal);
            if(test < 0)
            {
               scale = AC.dotProduct(wallNormal) / test;
               B = new Vector3D(A.x + direction.x * scale,A.y + direction.y * scale);
               AB = B.subtract(A);
               if(AB.length < closestDistance)
               {
                  closestDistance = AB.length;
                  closestPosition.x = B.x;
                  closestPosition.y = B.y;
                  this.wallHit = true;
                  this.ballHit = false;
                  this.normalResult.x = wallNormal.x;
                  this.normalResult.y = wallNormal.y;
               }
            }
         }
         if(this.ballHit)
         {
            this.cueBallCollisions.push(closestPosition);
            return;
         }
         this.normalResult.scaleBy(-1.7 * this.normalResult.dotProduct(direction));
         this.tangentResult = direction.add(this.normalResult);
         this.tangentResult.normalize();
         this.cueBallCollisions.push(closestPosition);
         this.findCueCollisions(depth,closestPosition,this.tangentResult);
      }
      
      public function dropCueBall(xpos:Number, ypos:Number) : Boolean
      {
         var focusBall:Ball = null;
         var pocket:Vector3D = null;
         var j:int = 0;
         var xterm:Number = NaN;
         var yterm:Number = NaN;
         var distSquared:Number = NaN;
         var numWalls:int = 0;
         var wall:Wall = null;
         var isbreak:Boolean = Globals.model.ruleset.legalBreak == false;
         var cueBall:Ball = Globals.model.ruleset.cueBall;
         cueBall.position.x = xpos;
         cueBall.position.y = ypos;
         var collidingWithBall:Boolean = false;
         var collidingWithWall:Boolean = false;
         var pastLine:Boolean = isbreak && cueBall.position.x > 0.25 * Globals.model.ruleset.tableWidth;
         var tooCloseToPocket:Boolean = false;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         var numBalls:int = balls.length;
         for(var i:int = 0; i < numBalls; i++)
         {
            focusBall = balls[i];
            if(focusBall.active && Globals.model.world.circleCollision(cueBall,focusBall))
            {
               collidingWithBall = true;
               break;
            }
         }
         if(!collidingWithBall && !pastLine)
         {
            for(j = 0; j < 6; j++)
            {
               pocket = Globals.model.ruleset.pocketPositions[j];
               xterm = pocket.x - cueBall.position.x;
               yterm = pocket.y - cueBall.position.y;
               distSquared = xterm * xterm + yterm * yterm;
               if(distSquared < Globals.model.ruleset.pocketRadiusSquared)
               {
                  tooCloseToPocket = true;
                  break;
               }
            }
         }
         var walls:Vector.<Wall> = Globals.model.ruleset.quickWallCheck;
         if(!collidingWithBall && !pastLine && !tooCloseToPocket)
         {
            numWalls = walls.length;
            for(i = 0; i < numWalls; i++)
            {
               wall = walls[i];
               if(Globals.model.world.ballwallCollision(cueBall,wall))
               {
                  collidingWithWall = true;
                  break;
               }
            }
         }
         if(collidingWithBall || pastLine || collidingWithWall || tooCloseToPocket)
         {
            return false;
         }
         return true;
      }
      
      public function forfeitTurn() : void
      {
         var tg:Ruleset = Globals.model.ruleset;
         this.state = STATE_WAITING;
         this.active = false;
         tg.turnInPlay();
         if(Globals.model.ruleset.singlePlayer == false)
         {
            this.currentPlayer.endPlayerTurn(false);
         }
      }
      
      private function hitCue() : void
      {
         this.state = STATE_HITTING;
         this.stickHittingPos = this.power;
         if(Globals.model.ruleset.singlePlayer == false)
         {
            this.currentPlayer.endPlayerTurn(true);
         }
      }
      
      public function onHit() : void
      {
         this.state = STATE_WAITING;
         var tg:Ruleset = Globals.model.ruleset;
         this.power = Math.max(this.power,-this.MAX_POWER);
         this.power = MathUtil.correctFloatingPointError(this.power);
         if(this.power > -this.MAX_POWER)
         {
            this.currentPlayer.fullPowerPlay = false;
         }
         else
         {
            this.currentPlayer.maxPowerUsed = true;
         }
         this.power = this.power * this._powerMultiplier;
         var hitVector:Vector3D = this.aimVector.clone();
         var torqueVec:Vector3D = hitVector.clone();
         hitVector.scaleBy(this.power * -2);
         torqueVec.scaleBy(-tg.cueBall.radius);
         var matrix:Matrix3D = new Matrix3D();
         matrix.appendRotation(this.saveCuePosition.x * -Math.PI,new Vector3D(0,0,1));
         torqueVec = matrix.transformVector(torqueVec);
         torqueVec.scaleBy(4);
         torqueVec.z = tg.cueBall.radius * this.saveCuePosition.y / 2;
         hitVector.x = MathUtil.correctFloatingPointError(hitVector.x);
         hitVector.y = MathUtil.correctFloatingPointError(hitVector.y);
         torqueVec.x = MathUtil.correctFloatingPointError(torqueVec.x);
         torqueVec.y = MathUtil.correctFloatingPointError(torqueVec.y);
         torqueVec.z = MathUtil.correctFloatingPointError(torqueVec.z);
         tg.cueBall.addImpulse(hitVector,torqueVec);
         tg.turnInPlay();
         this.active = false;
         this.alpha = 0;
         Globals.soundManager.playSound("strike5",this.power * -1.6);
      }
   }
}
