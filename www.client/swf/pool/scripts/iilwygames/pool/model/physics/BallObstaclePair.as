package iilwygames.pool.model.physics
{
   import flash.geom.Vector3D;
   import iilwygames.pool.model.gameplay.GameObject;
   
   public class BallObstaclePair implements ICollidablePair
   {
       
      
      public var goa:GameObject;
      
      public var gob:GameObject;
      
      public var t:Number;
      
      private var vDiff:Vector3D;
      
      private var pDiff:Vector3D;
      
      public function BallObstaclePair(a:GameObject, b:GameObject)
      {
         super();
         this.t = 0;
         this.goa = a;
         this.gob = b;
         this.vDiff = new Vector3D();
         this.pDiff = new Vector3D();
      }
      
      public function destroy() : void
      {
         this.vDiff = null;
         this.pDiff = null;
         this.goa = null;
         this.gob = null;
      }
      
      public function copy(pair:BallObstaclePair) : void
      {
         this.goa = pair.goa;
         this.gob = pair.gob;
         this.t = pair.t;
      }
      
      public function get toc() : Number
      {
         return this.t;
      }
      
      public function willCollideIn(dt:Number) : Boolean
      {
         this.vDiff.x = this.goa.velocity.x - this.gob.velocity.x;
         this.vDiff.y = this.goa.velocity.y - this.gob.velocity.y;
         var a:Number = this.vDiff.dotProduct(this.vDiff);
         if(a < 0)
         {
            return false;
         }
         this.pDiff.x = this.goa.position.x - this.gob.position.x;
         this.pDiff.y = this.goa.position.y - this.gob.position.y;
         var b:Number = this.pDiff.dotProduct(this.vDiff);
         if(b >= 0)
         {
            return false;
         }
         var c:Number = this.pDiff.dotProduct(this.pDiff) - 4 * this.goa.radiusSquared;
         var d:Number = b * b - a * c;
         if(d < 0)
         {
            return false;
         }
         this.t = (-b - Math.sqrt(d)) / a;
         return this.t <= dt;
      }
      
      public function resolve() : void
      {
         var n:Vector3D = null;
         var ima:Number = NaN;
         var imb:Number = NaN;
         var e:Number = NaN;
         var Vab:Vector3D = null;
         var ims:Number = NaN;
         var a:GameObject = this.goa;
         var b:GameObject = this.gob;
         var vectorBetweenAB:Vector3D = a.position.subtract(b.position);
         ima = a.invMass;
         imb = b.invMass;
         ims = ima + imb;
         e = 0.93;
         Vab = a.velocity.subtract(b.velocity);
         n = vectorBetweenAB.clone();
         ims = ims * n.dotProduct(n);
         var value:Number = Vab.dotProduct(n);
         if(value >= 0)
         {
            return;
         }
         var jj:Number = -(1 + e) * value / ims;
         n.scaleBy(jj * ima);
         a.velocity.incrementBy(n);
         n.scaleBy(-1);
         b.velocity.incrementBy(n);
         a.bodyState = Body.STATE_SLIDING;
         b.bodyState = Body.STATE_SLIDING;
      }
   }
}
