package iilwygames.pool.model.physics
{
   import flash.geom.Vector3D;
   import iilwygames.pool.model.gameplay.GameObject;
   
   public class ObstacleWallPair implements ICollidablePair
   {
       
      
      public var obstacle:GameObject;
      
      public var wall:Wall;
      
      public var t:Number;
      
      public function ObstacleWallPair(o:GameObject, w:Wall)
      {
         super();
         this.obstacle = o;
         this.wall = w;
      }
      
      public function get toc() : Number
      {
         return 0;
      }
      
      public function copy(pair:ObstacleWallPair) : void
      {
         this.obstacle = pair.obstacle;
         this.wall = pair.wall;
         this.t = pair.t;
      }
      
      public function willCollideIn(dt:Number) : Boolean
      {
         var cdlen:Number = NaN;
         var centerToTail:Vector3D = null;
         var adotb:Number = NaN;
         var div:Number = NaN;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var negVelocity:Vector3D = null;
         var rayStartPoint:Vector3D = null;
         var rayPointToCircle:Vector3D = null;
         var qa:Number = NaN;
         var k:Number = NaN;
         var qc:Number = NaN;
         var qd:Number = NaN;
         var param:Number = NaN;
         var normal:Vector3D = this.wall.normal.clone();
         var normScaledRadius:Vector3D = this.wall.normal.clone();
         normScaledRadius.scaleBy(-this.obstacle.radius);
         var A:Vector3D = this.obstacle.position.add(normScaledRadius);
         var B:Vector3D = A.add(this.obstacle.velocity);
         var AB:Vector3D = B.subtract(A);
         var C:Vector3D = this.wall.pointA;
         var D:Vector3D = this.wall.pointB;
         var AC:Vector3D = C.subtract(A);
         var CD:Vector3D = D.subtract(C);
         var test:Number = normal.dotProduct(AB);
         this.t = normal.dotProduct(AC) / test;
         if(test == 0)
         {
            this.t = 0;
         }
         if(this.t <= dt)
         {
            AB.scaleBy(this.t);
            AB.incrementBy(A);
            cdlen = CD.lengthSquared;
            centerToTail = AB.subtract(C);
            adotb = centerToTail.dotProduct(CD);
            div = adotb / cdlen;
            div = div < 0?Number(0):div > 1?Number(1):Number(div);
            if(div > 0 && div < 1 && this.t >= 0)
            {
               return true;
            }
            xpos = C.x + CD.x * div;
            ypos = C.y + CD.y * div;
            negVelocity = this.obstacle.velocity.clone();
            negVelocity.scaleBy(-1);
            rayStartPoint = new Vector3D(xpos,ypos);
            rayPointToCircle = this.obstacle.position.subtract(rayStartPoint);
            qa = negVelocity.dotProduct(negVelocity);
            k = rayPointToCircle.dotProduct(negVelocity);
            qc = rayPointToCircle.dotProduct(rayPointToCircle) - this.obstacle.radiusSquared;
            qd = k * k - qa * qc;
            if(qd < 0)
            {
               return false;
            }
            param = (k - Math.sqrt(qd)) / qa;
            if(param <= 1)
            {
               negVelocity.scaleBy(param);
               rayStartPoint.incrementBy(negVelocity);
               A = rayStartPoint;
               AC = C.subtract(A);
               this.t = normal.dotProduct(AC) / test;
               if(test == 0)
               {
                  this.t = 0;
               }
               if(this.t <= dt && this.t >= 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function resolve() : void
      {
         var dir:Vector3D = null;
         var diff:Number = NaN;
         var n:Vector3D = this.wall.normal.clone();
         var obstacleToWall:Vector3D = this.obstacle.position.subtract(this.wall.pointA);
         var wallVector:Vector3D = this.wall.fullVector;
         var obstacleToWallProj:Number = this.wall.fullVector.dotProduct(obstacleToWall) / wallVector.lengthSquared;
         if(obstacleToWallProj > 1)
         {
            dir = this.obstacle.position.subtract(this.wall.pointB);
            dir.normalize();
            n = dir;
         }
         else if(obstacleToWallProj < 0)
         {
            dir = this.obstacle.position.subtract(this.wall.pointA);
            dir.normalize();
            n = dir;
         }
         else
         {
            dir = n;
         }
         var r:Vector3D = n.clone();
         r.scaleBy(-this.obstacle.radius);
         var ima:Number = this.obstacle.invMass;
         var e:Number = 0.2;
         var Vab:Vector3D = this.obstacle.velocity.clone();
         ima = ima * n.dotProduct(n);
         var j:Number = -(1 + e) * Vab.dotProduct(n) / ima;
         dir.scaleBy(j * ima);
         this.obstacle.velocity.incrementBy(dir);
      }
   }
}
