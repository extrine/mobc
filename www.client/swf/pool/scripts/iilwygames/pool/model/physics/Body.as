package iilwygames.pool.model.physics
{
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class Body
   {
      
      public static const STATE_REST:int = 0;
      
      public static const STATE_SLIDING:int = 1;
      
      public static const STATE_ROLLING:int = 2;
       
      
      public var position:Vector3D;
      
      public var velocity:Vector3D;
      
      public var angularVelocity:Vector3D;
      
      public var upVector:Vector3D;
      
      public var rightVector:Vector3D;
      
      public var mass:Number;
      
      public var inertia:Number;
      
      public var invMass:Number;
      
      public var invInertia:Number;
      
      public var radius:Number;
      
      public var radiusSquared:Number;
      
      public var bodyState:int;
      
      private var force:Vector3D;
      
      private var acceleration:Vector3D;
      
      private var torque:Vector3D;
      
      private var rotMatrix:Matrix3D;
      
      private const radiansToDegrees:Number = 57.29577951308232;
      
      private const threshold:Number = 0.01;
      
      public function Body()
      {
         super();
         this.position = new Vector3D();
         this.velocity = new Vector3D();
         this.angularVelocity = new Vector3D();
         this.force = new Vector3D();
         this.acceleration = new Vector3D();
         this.torque = new Vector3D();
         this.mass = 1;
         this.inertia = 1;
         this.invMass = 0;
         this.invInertia = 0;
         this.bodyState = STATE_REST;
         this.upVector = new Vector3D(0,-1,0,0);
         this.rightVector = new Vector3D(1,0,0,0);
         this.rotMatrix = new Matrix3D();
      }
      
      public function destroy() : void
      {
         this.position = null;
         this.velocity = null;
         this.angularVelocity = null;
         this.force = null;
         this.acceleration = null;
         this.torque = null;
         this.upVector = null;
         this.rightVector = null;
      }
      
      public function reset() : void
      {
         this.velocity.x = this.velocity.y = this.velocity.z = 0;
         this.angularVelocity.x = this.angularVelocity.y = this.angularVelocity.z = 0;
         this.force.x = this.force.y = this.force.z = 0;
         this.torque.x = this.torque.y = this.torque.z = 0;
         this.bodyState = STATE_REST;
      }
      
      protected function setMass(m:Number) : void
      {
         this.mass = m;
         if(this.mass > 0)
         {
            this.invMass = 1 / this.mass;
         }
         else
         {
            this.invMass = 0;
         }
      }
      
      protected function setInertia(i:Number) : void
      {
         this.inertia = i;
         if(this.inertia > 0)
         {
            this.invInertia = 1 / this.inertia;
         }
         else
         {
            this.inertia = 0;
         }
      }
      
      public function update(et:Number) : Boolean
      {
         return true;
      }
      
      public function addForceComponents(x:Number, y:Number, z:Number) : void
      {
         this.force.x = this.force.x + x;
         this.force.y = this.force.y + y;
         this.force.z = this.force.z + z;
      }
      
      public function addForce(af:Vector3D, point:Vector3D) : void
      {
         this.force.incrementBy(af);
         this.torque.incrementBy(point.crossProduct(af));
      }
      
      public function addTorque(t:Vector3D) : void
      {
         this.torque.incrementBy(t);
      }
      
      public function addImpulse(i:Vector3D, point:Vector3D) : void
      {
         this.velocity.x = this.velocity.x + i.x * this.invMass;
         this.velocity.y = this.velocity.y + i.y * this.invMass;
         this.velocity.z = this.velocity.z + i.z * this.invMass;
         var at:Vector3D = point.crossProduct(i);
         at.scaleBy(this.invInertia);
         this.angularVelocity.incrementBy(at);
         this.bodyState = STATE_SLIDING;
      }
      
      public function integrateForces2(et:Number) : void
      {
         this.force.scaleBy(this.invMass * et);
         this.velocity.incrementBy(this.force);
         this.torque.scaleBy(this.invInertia * et);
         this.angularVelocity.incrementBy(this.torque);
         this.force.x = 0;
         this.force.y = 0;
         this.force.z = 0;
         this.torque.x = 0;
         this.torque.y = 0;
         this.torque.z = 0;
      }
      
      public function integrateForces(et:Number) : void
      {
         var cp:Vector3D = null;
         var av:Vector3D = null;
         var contact:Vector3D = null;
         var rw:Vector3D = null;
         var dotp:Number = NaN;
         var diff:Number = NaN;
         this.torque.scaleBy(this.invInertia * et);
         this.angularVelocity.incrementBy(this.torque);
         if(this.bodyState == STATE_ROLLING)
         {
            cp = new Vector3D(0,0,this.radius);
            av = cp.crossProduct(this.angularVelocity);
            this.velocity.x = av.x;
            this.velocity.y = av.y;
            this.velocity.z = av.z;
         }
         else if(this.bodyState == STATE_SLIDING)
         {
            this.force.scaleBy(this.invMass * et);
            this.velocity.incrementBy(this.force);
            contact = new Vector3D(0,0,this.radius);
            rw = contact.crossProduct(this.angularVelocity);
            dotp = rw.dotProduct(this.velocity);
            diff = rw.subtract(this.velocity).length;
            if(dotp && diff < 0.05)
            {
               this.bodyState = STATE_ROLLING;
               this.velocity.x = rw.x;
               this.velocity.y = rw.y;
               this.velocity.z = rw.z;
            }
         }
         var velSquared:Number = this.velocity.lengthSquared;
         var angSquared:Number = this.angularVelocity.lengthSquared;
         angSquared = angSquared * angSquared;
         if(velSquared < this.threshold && angSquared < this.threshold)
         {
            this.bodyState = STATE_REST;
            this.velocity.x = 0;
            this.velocity.y = 0;
            this.velocity.z = 0;
            this.angularVelocity.x = 0;
            this.angularVelocity.y = 0;
            this.angularVelocity.z = 0;
         }
         this.force.x = 0;
         this.force.y = 0;
         this.force.z = 0;
         this.torque.x = 0;
         this.torque.y = 0;
         this.torque.z = 0;
      }
      
      public function integrateVelocity(et:Number) : void
      {
         var dx:int = 0;
         var dy:int = 0;
         var angularRotation:Vector3D = null;
         if(this.bodyState != STATE_REST)
         {
            dx = int(this.velocity.x * 10000) * int(et * 10000);
            dy = int(this.velocity.y * 10000) * int(et * 10000);
            this.position.x = this.position.x + dx / 100000000;
            this.position.y = this.position.y + dy / 100000000;
            this.rotMatrix.identity();
            angularRotation = this.angularVelocity.clone();
            angularRotation.scaleBy(et);
            this.rotMatrix.appendRotation(this.radiansToDegrees * angularRotation.z,Vector3D.Z_AXIS);
            this.rotMatrix.appendRotation(-this.radiansToDegrees * angularRotation.x,Vector3D.X_AXIS);
            this.rotMatrix.appendRotation(-this.radiansToDegrees * angularRotation.y,Vector3D.Y_AXIS);
            this.upVector = this.rotMatrix.transformVector(this.upVector);
            this.rightVector = this.rotMatrix.transformVector(this.rightVector);
         }
      }
      
      private function normalizeAngle(angle:Number) : Number
      {
         var pi:Number = Math.PI;
         var negpi:Number = -pi;
         var twopi:Number = Math.PI * 2;
         while(angle < negpi)
         {
            angle = angle + twopi;
         }
         while(angle > pi)
         {
            angle = angle - twopi;
         }
         return angle;
      }
   }
}
