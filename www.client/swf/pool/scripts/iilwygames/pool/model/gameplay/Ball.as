package iilwygames.pool.model.gameplay
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.physics.Body;
   import iilwygames.pool.model.physics.World;
   
   public class Ball extends GameObject
   {
      
      public static const BALL_NONE:int = -1;
      
      public static const BALL_CUE:int = 0;
      
      public static const BALL_SOLID:int = 1;
      
      public static const BALL_STRIPE:int = 2;
      
      public static const BALL_EXTRA:int = 3;
      
      public static const BALL_BLOCKER:int = 4;
      
      public static const BALL_OBJECT:int = 5;
      
      public static const BALL_STATE_ACTIVE:int = 0;
      
      public static const BALL_STATE_DROPPING:int = 1;
      
      public static const BALL_STATE_POCKETING:int = 2;
      
      public static const BALL_STATE_ROLLINGONRAIL:int = 3;
      
      public static const BALL_STATE_INACTIVE:int = 4;
      
      public static const BALL_STATE_DONOTRENDER:int = 5;
       
      
      public var ballNumber:int;
      
      public var ballType:int;
      
      public var ballState:int;
      
      public var hitBackWall:Boolean;
      
      public var railsHit:int;
      
      public var railsHitBeforeFirstHit:int;
      
      public var hasFocusIndicator:Boolean;
      
      public var ballReturnIndex:int;
      
      private const MU_SLIDE:Number = 0.2;
      
      private const MU_ROLL:Number = 0.0056;
      
      private var contactPoint:Vector3D;
      
      private var pocketTimer:Number;
      
      private var pocketPosition:Vector3D;
      
      private var pocketDirection:Vector3D;
      
      private var pocketIndex:int;
      
      public var targetPocket:Vector3D;
      
      public var hasTarget:Boolean;
      
      public function Ball()
      {
         super();
         radius = 0.05715 * 0.5;
         radiusSquared = radius * radius;
         setMass(0.16);
         var i:Number = 2 / 5 * mass * radius * radius;
         setInertia(i);
         aabbCollision = false;
         this.contactPoint = new Vector3D(0,0,radius);
         this.ballNumber = 0;
         this.ballType = BALL_CUE;
         this.pocketTimer = 0;
         this.ballState = BALL_STATE_ACTIVE;
         this.pocketPosition = new Vector3D();
         this.pocketDirection = new Vector3D();
         this.targetPocket = new Vector3D();
         this.hitBackWall = false;
         this.railsHit = 0;
         this.railsHitBeforeFirstHit = 0;
         this.ballReturnIndex = -1;
         this.hasFocusIndicator = false;
         this.hasTarget = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.pocketDirection = null;
         this.pocketPosition = null;
         this.contactPoint = null;
         this.targetPocket = null;
      }
      
      public function resetBall() : void
      {
         reset();
         this.ballState = BALL_STATE_ACTIVE;
         active = true;
         Globals.view.table.resetBall(this);
      }
      
      public function init(number:int, type:int) : void
      {
         this.ballNumber = number;
         this.ballType = type;
      }
      
      override public function update(et:Number) : Boolean
      {
         var mu:Number = NaN;
         var contactVec:Vector3D = null;
         var vp:Vector3D = null;
         var zDrag:Vector3D = null;
         var distanceCheck:Number = NaN;
         var wi:Number = NaN;
         var hi:Number = NaN;
         var gravity:Number = World.GRAVITY;
         if(this.ballState == BALL_STATE_ACTIVE)
         {
            if(bodyState == STATE_SLIDING)
            {
               contactVec = new Vector3D(0,0,radius);
               vp = angularVelocity.crossProduct(contactVec);
               vp.incrementBy(velocity);
               vp.normalize();
               vp.scaleBy(-this.MU_SLIDE * gravity * mass);
               addForce(vp,contactVec);
            }
            else if(bodyState == STATE_ROLLING)
            {
               contactVec = new Vector3D(0,0,radius);
               vp = angularVelocity.crossProduct(contactVec);
               vp.normalize();
               vp.scaleBy(-this.MU_ROLL * gravity * mass);
               addTorque(contactVec.crossProduct(vp));
            }
            zDrag = new Vector3D(0,0,angularVelocity.z);
            zDrag.normalize();
            if(angularVelocity.z > -0.05 && angularVelocity.z < 0.05)
            {
               zDrag.z = angularVelocity.z;
            }
            zDrag.scaleBy(-this.MU_ROLL * mass * 0.6);
            addTorque(zDrag);
         }
         else if(this.ballState == BALL_STATE_ROLLINGONRAIL)
         {
            this.pocketTimer = this.pocketTimer - et;
            if(this.pocketTimer < 0)
            {
               this.pocketTimer = 0;
               this.ballState = BALL_STATE_INACTIVE;
               bodyState = STATE_REST;
               angularVelocity.y = 0;
            }
         }
         else if(this.ballState == BALL_STATE_DROPPING)
         {
            distanceCheck = this.pocketPosition.subtract(position).length;
            if(distanceCheck < Globals.model.ruleset.pocketRadius - radius || this.hitBackWall)
            {
               this.ballState = BALL_STATE_POCKETING;
               Globals.view.table.pocketBall(this);
            }
            else
            {
               contactVec = new Vector3D(0,0,-radius);
               vp = this.pocketPosition.subtract(position);
               vp.scaleBy(30);
               addForce(vp,contactVec);
               bodyState = Body.STATE_SLIDING;
            }
         }
         else if(this.ballState == BALL_STATE_POCKETING)
         {
            contactVec = new Vector3D(0,0,-radius);
            vp = this.pocketDirection.clone();
            vp.scaleBy(0.085);
            addForce(vp,contactVec);
            wi = Globals.model.ruleset.tableWidth;
            hi = Globals.model.ruleset.tableHeight;
            bodyState = Body.STATE_SLIDING;
            if(position.x > wi * 0.1 && position.x < wi * 0.9 && position.y > 0.1 * hi && position.y < 0.9 * hi)
            {
               this.initPocketBall(this.pocketIndex);
            }
         }
         return active;
      }
      
      public function shoot(cueToBallWorldSpace:Vector3D, r:Vector3D) : void
      {
         var springConstant:Number = -50;
         var deltaTime:Number = 0.005;
         var combinedValue:Number = springConstant * deltaTime;
         cueToBallWorldSpace.scaleBy(combinedValue);
         addImpulse(cueToBallWorldSpace,r);
      }
      
      public function pocketBall2(pocket:Point, index:int) : void
      {
         this.initPocketBall(index);
      }
      
      public function pocketBall(pocket:Vector3D, index:int) : void
      {
         this.ballState = BALL_STATE_DROPPING;
         this.pocketPosition.x = pocket.x;
         this.pocketPosition.y = pocket.y;
         this.pocketIndex = index;
         if(this.pocketPosition.x <= 0)
         {
            this.pocketDirection.x = 1;
         }
         else if(this.pocketPosition.x >= Globals.model.ruleset.tableWidth)
         {
            this.pocketDirection.x = -1;
         }
         if(this.pocketPosition.y <= 0)
         {
            this.pocketDirection.y = 1;
         }
         else if(this.pocketPosition.y >= Globals.model.ruleset.tableHeight)
         {
            this.pocketDirection.y = -1;
         }
         this.pocketDirection.normalize();
         var testVector:Vector3D = this.pocketDirection.clone();
         testVector.scaleBy(-1);
         var dottest:Number = testVector.dotProduct(velocity);
         if(dottest <= 0)
         {
            reset();
         }
         else
         {
            angularVelocity.scaleBy(0.9);
         }
      }
      
      public function initPocketBall(index:int) : void
      {
         reset();
         this.ballReturnIndex = index;
         angularVelocity.x = 0;
         angularVelocity.y = 15;
         angularVelocity.z = 0;
         var startPositionX:Number = 1.2;
         position.x = startPositionX;
         position.y = 0;
         var distanceToTravel:Number = startPositionX - index * 2 * radius;
         this.pocketTimer = distanceToTravel / (angularVelocity.y * radius);
         this.ballState = BALL_STATE_ROLLINGONRAIL;
         bodyState = STATE_ROLLING;
         Globals.view.table.resetBall(this);
      }
      
      public function checkValidPocket() : Boolean
      {
         return this.pocketPosition.x == this.targetPocket.x && this.pocketPosition.y == this.targetPocket.y;
      }
   }
}
