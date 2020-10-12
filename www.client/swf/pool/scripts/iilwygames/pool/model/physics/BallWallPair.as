package iilwygames.pool.model.physics
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.GameObject;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class BallWallPair implements ICollidablePair
   {
       
      
      public var ball:GameObject;
      
      public var wall:Wall;
      
      public var t:Number;
      
      public function BallWallPair(b:GameObject, w:Wall)
      {
         super();
         this.ball = b;
         this.wall = w;
      }
      
      public function get toc() : Number
      {
         return this.t;
      }
      
      public function copy(pair:BallWallPair) : void
      {
         this.ball = pair.ball;
         this.wall = pair.wall;
         this.t = pair.t;
      }
      
      public function willCollideIn1(dt:Number) : Boolean
      {
         var cdlen:Number = NaN;
         var centerToTail:Vector3D = null;
         var adotb:Number = NaN;
         var div:Number = NaN;
         var A:Vector3D = this.ball.position;
         var B:Vector3D = this.ball.position.add(this.ball.velocity);
         var AB:Vector3D = B.subtract(A);
         var normal:Vector3D = this.wall.normal.clone();
         var normScaledRadius:Vector3D = this.wall.normal.clone();
         var radiusPadding:Vector3D = this.wall.vectorAB.clone();
         radiusPadding.scaleBy(this.ball.radius);
         normScaledRadius.scaleBy(this.ball.radius);
         var C:Vector3D = this.wall.pointA.add(normScaledRadius);
         var D:Vector3D = this.wall.pointB.add(normScaledRadius);
         D.incrementBy(radiusPadding);
         radiusPadding.scaleBy(-1);
         C.incrementBy(radiusPadding);
         var AC:Vector3D = C.subtract(A);
         var CD:Vector3D = D.subtract(C);
         var test:Number = normal.dotProduct(AB);
         this.t = normal.dotProduct(AC) / test;
         if(isNaN(this.t))
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
            if(div >= 0 && div <= 1 && this.t >= 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function willCollideIn2(dt:Number) : Boolean
      {
         var cdlen:Number = NaN;
         var centerToTail:Vector3D = null;
         var adotb:Number = NaN;
         var div:Number = NaN;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var vec:Vector3D = null;
         var dir:Vector3D = null;
         var APoint:Vector3D = null;
         var newValueT:Number = NaN;
         var point:Vector3D = null;
         var testVec:Vector3D = null;
         var apath:Number = NaN;
         var bpath:Number = NaN;
         var actualPoint:Vector3D = null;
         var newVec:Vector3D = null;
         var testX:Number = NaN;
         var testY:Number = NaN;
         var minRadius:Number = NaN;
         var A:Vector3D = this.ball.position;
         var B:Vector3D = this.ball.position.add(this.ball.velocity);
         var AB:Vector3D = B.subtract(A);
         var normal:Vector3D = this.wall.normal.clone();
         var normScaledRadius:Vector3D = this.wall.normal.clone();
         normScaledRadius.scaleBy(this.ball.radius);
         var C:Vector3D = this.wall.pointA.add(normScaledRadius);
         var D:Vector3D = this.wall.pointB.add(normScaledRadius);
         var AC:Vector3D = C.subtract(A);
         var CD:Vector3D = D.subtract(C);
         var lsquared:Number = CD.lengthSquared;
         var test:Number = normal.dotProduct(AB);
         this.t = normal.dotProduct(AC) / test;
         if(isNaN(this.t))
         {
            this.t = 0;
         }
         if(this.t <= dt)
         {
            AB.scaleBy(this.t);
            AB.incrementBy(A);
            CD = this.wall.pointB.subtract(this.wall.pointA);
            C = this.wall.pointA;
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
            vec = new Vector3D();
            vec.x = xpos - AB.x;
            vec.y = ypos - AB.y;
            if(vec.lengthSquared <= this.ball.radiusSquared && this.t >= 0)
            {
               return true;
            }
            AB = B.subtract(A);
            dir = AB.clone();
            dir.normalize();
            dir.scaleBy(-1);
            APoint = new Vector3D(xpos - A.x,ypos - A.y);
            newValueT = APoint.dotProduct(AB) / AB.dotProduct(AB);
            point = new Vector3D(A.x + AB.x * newValueT,A.y + AB.y * newValueT);
            testVec = new Vector3D(xpos - point.x,ypos - point.y);
            apath = testVec.lengthSquared;
            bpath = this.ball.radiusSquared - apath;
            if(bpath < 0)
            {
               bpath = 0;
            }
            else
            {
               bpath = Math.sqrt(bpath);
            }
            actualPoint = new Vector3D(point.x + dir.x * bpath,point.y + dir.y * bpath);
            newVec = actualPoint.subtract(A);
            this.t = newVec.dotProduct(AB) / AB.dotProduct(AB);
            if(this.t <= dt && this.t >= 0)
            {
               testX = A.x + AB.x * this.t;
               testY = A.y + AB.y * this.t;
               vec.x = testX - xpos;
               vec.y = testY - ypos;
               minRadius = this.ball.radiusSquared * 1001 / 1000;
               if(vec.lengthSquared <= minRadius)
               {
                  return true;
               }
            }
         }
         return false;
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
         normScaledRadius.scaleBy(-this.ball.radius);
         var A:Vector3D = this.ball.position.add(normScaledRadius);
         var B:Vector3D = A.add(this.ball.velocity);
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
            negVelocity = this.ball.velocity.clone();
            negVelocity.scaleBy(-1);
            rayStartPoint = new Vector3D(xpos,ypos);
            rayPointToCircle = this.ball.position.subtract(rayStartPoint);
            qa = negVelocity.dotProduct(negVelocity);
            k = rayPointToCircle.dotProduct(negVelocity);
            qc = rayPointToCircle.dotProduct(rayPointToCircle) - this.ball.radiusSquared;
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
         var ballToWall:Vector3D = this.ball.position.subtract(this.wall.pointA);
         var wallVector:Vector3D = this.wall.fullVector;
         var ballToWallProj:Number = this.wall.fullVector.dotProduct(ballToWall) / wallVector.lengthSquared;
         if(ballToWallProj > 1)
         {
            dir = this.ball.position.subtract(this.wall.pointB);
            dir.normalize();
            n = dir;
         }
         else if(ballToWallProj < 0)
         {
            dir = this.ball.position.subtract(this.wall.pointA);
            dir.normalize();
            n = dir;
         }
         else
         {
            dir = n;
         }
         var r:Vector3D = n.clone();
         r.scaleBy(-this.ball.radius);
         var ima:Number = this.ball.invMass;
         var e:Number = 0.7;
         var Vab:Vector3D = this.ball.velocity.clone();
         var pointVel:Vector3D = this.ball.angularVelocity.crossProduct(r);
         var normal:Vector3D = n.clone();
         normal.scaleBy(pointVel.dotProduct(normal));
         var tangentDirection:Vector3D = pointVel.subtract(normal);
         tangentDirection.normalize();
         var frictionDirection:Vector3D = tangentDirection.clone();
         frictionDirection.scaleBy(-1);
         var tangentSpeed:Number = tangentDirection.dotProduct(pointVel);
         ima = ima * n.dotProduct(n);
         var j:Number = -(1 + e) * Vab.dotProduct(n) / ima;
         dir.scaleBy(j * ima);
         this.ball.velocity.incrementBy(dir);
         frictionDirection.scaleBy(j * ima * 0.16);
         this.ball.velocity.incrementBy(frictionDirection);
         this.ball.velocity.z = 0;
         if(this.ball.bodyState == Body.STATE_ROLLING)
         {
            this.ball.angularVelocity.x = 0;
            this.ball.angularVelocity.y = 0;
            this.ball.angularVelocity.z = this.ball.angularVelocity.z * 0.8;
         }
         else
         {
            this.ball.angularVelocity.scaleBy(0.8);
         }
         this.ball.bodyState = Body.STATE_SLIDING;
         var rs:Ruleset = Globals.model.ruleset;
         if(rs.firstBallHit)
         {
            rs.numOfRailsHit = rs.numOfRailsHit | uint(1 << (this.ball as Ball).ballNumber);
         }
         else
         {
            (this.ball as Ball).railsHitBeforeFirstHit++;
         }
         Globals.soundManager.playSound("wall2",j * 0.65);
         if(this.wall.isBackWall)
         {
            (this.ball as Ball).hitBackWall = true;
         }
         if(this.wall.isRail)
         {
            (this.ball as Ball).railsHit++;
         }
      }
   }
}
