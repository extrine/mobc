package iilwygames.pool.model.physics
{
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.GameObject;
   import iilwygames.pool.model.gameplay.Obstacle;
   
   public class World
   {
      
      public static const GRAVITY:Number = 9.8;
       
      
      public const WORLD_WIDTH:Number = 2.54;
      
      public const WORLD_HEIGHT:Number = 1.27;
      
      public var gameObjects:Vector.<GameObject>;
      
      public var balls:Vector.<GameObject>;
      
      public var walls:Vector.<Wall>;
      
      public var obstacles:Vector.<GameObject>;
      
      private var _genericVector3D:Vector3D;
      
      private var xScale:Number;
      
      private var yScale:Number;
      
      private const COLLISION_ITERATIONS:int = 5;
      
      private var bbPair:BallBallPair;
      
      private var bwPair:BallWallPair;
      
      private var boPair:BallObstaclePair;
      
      private var owPair:ObstacleWallPair;
      
      private var minbbPair:BallBallPair;
      
      private var minbwPair:BallWallPair;
      
      private var minboPair:BallObstaclePair;
      
      private var minowPair:ObstacleWallPair;
      
      public function World()
      {
         super();
         this.gameObjects = new Vector.<GameObject>();
         this.obstacles = new Vector.<GameObject>();
         this.balls = new Vector.<GameObject>();
         this.walls = new Vector.<Wall>();
         this._genericVector3D = new Vector3D();
         this.xScale = this.yScale = 0;
         this.bbPair = new BallBallPair(null,null);
         this.bwPair = new BallWallPair(null,null);
         this.boPair = new BallObstaclePair(null,null);
         this.minbbPair = new BallBallPair(null,null);
         this.minbwPair = new BallWallPair(null,null);
         this.minboPair = new BallObstaclePair(null,null);
         this.owPair = new ObstacleWallPair(null,null);
         this.minowPair = new ObstacleWallPair(null,null);
      }
      
      public function stop() : void
      {
         var go:GameObject = null;
         var wall:Wall = null;
         for each(go in this.gameObjects)
         {
            go.destroy();
         }
         for each(wall in this.walls)
         {
            wall.destroy();
         }
         this.gameObjects.length = 0;
         this.balls.length = 0;
         this.walls.length = 0;
         this.obstacles.length = 0;
      }
      
      public function destroy() : void
      {
         this.stop();
         this.gameObjects = null;
         this.balls = null;
         this.walls = null;
         this.obstacles = null;
         this._genericVector3D = null;
         this.bbPair = null;
         this.bwPair = null;
         this.boPair = null;
         this.minbbPair = null;
         this.minbwPair = null;
         this.minboPair = null;
         this.owPair = null;
         this.minowPair = null;
      }
      
      public function addGameObject(go:GameObject) : void
      {
         this.gameObjects.push(go);
         if(go is Ball)
         {
            this.balls.push(go);
         }
         else if(go is Obstacle)
         {
            this.obstacles.push(go);
         }
      }
      
      public function removeGameObject(go:GameObject) : void
      {
         var indexOf:int = 0;
         if(go is Ball)
         {
            indexOf = this.balls.indexOf(go);
            if(indexOf > -1)
            {
               this.balls.splice(indexOf,1);
            }
         }
         else if(go is Obstacle)
         {
            indexOf = this.obstacles.indexOf(go);
            if(indexOf > -1)
            {
               this.obstacles.splice(indexOf,1);
            }
         }
         indexOf = this.gameObjects.indexOf(go);
         if(indexOf > -1)
         {
            this.gameObjects.splice(indexOf,1);
         }
      }
      
      public function addWall(wall:Wall) : void
      {
         this.walls.push(wall);
      }
      
      public function update(et:Number) : void
      {
         var go:GameObject = null;
         var i:int = 0;
         var len:int = this.gameObjects.length;
         for(i = 0; i < len; i++)
         {
            go = this.gameObjects[i];
            go.update(et);
            go.integrateForces(et);
         }
         this.ccd(et);
      }
      
      public function ccd(et:Number) : void
      {
         var dt:Number = NaN;
         var iter:int = 0;
         var i:int = 0;
         var j:int = 0;
         var goa:GameObject = null;
         var gob:GameObject = null;
         var wall:Wall = null;
         var minT:Number = NaN;
         var minPair:ICollidablePair = null;
         var wallPair:BallWallPair = null;
         var pair:BallBallPair = null;
         var MAX_ITER:int = 100;
         var t:Number = 0;
         var numBalls:int = this.balls.length;
         var numWalls:int = this.walls.length;
         var numObstacles:int = this.obstacles.length;
         var timeSlice:Number = et;
         while(t < timeSlice && ++iter <= MAX_ITER)
         {
            dt = timeSlice - t;
            minT = Number.MAX_VALUE;
            minPair = null;
            for(i = 0; i < numBalls; i++)
            {
               goa = this.balls[i];
               goa.updateAABB(dt);
               if(!(goa.velocity.x == 0 && goa.velocity.y == 0))
               {
                  for(j = 0; j < numWalls; j++)
                  {
                     wall = this.walls[j];
                     if(goa.velocity.dotProduct(wall.normal) < 0 && this.aabbCollide(goa.boundingBox,wall.aabb))
                     {
                        wallPair = this.bwPair;
                        this.bwPair.ball = goa;
                        this.bwPair.wall = wall;
                        if(wallPair.willCollideIn(dt))
                        {
                           if(wallPair.toc < minT)
                           {
                              minT = wallPair.toc;
                              this.minbwPair.copy(this.bwPair);
                              minPair = this.minbwPair;
                           }
                        }
                     }
                  }
               }
            }
            for(i = 0; i < numBalls; i++)
            {
               goa = this.balls[i];
               if(goa.active != false)
               {
                  for(j = 0; j < numBalls; j++)
                  {
                     gob = this.balls[j];
                     if(gob.active != false)
                     {
                        if(this.aabbCollide(goa.boundingBox,gob.boundingBox))
                        {
                           pair = this.bbPair;
                           this.bbPair.goa = goa;
                           this.bbPair.gob = gob;
                           if(pair.willCollideIn(dt))
                           {
                              if(pair.toc < minT)
                              {
                                 minT = pair.toc;
                                 this.minbbPair.copy(this.bbPair);
                                 minPair = this.minbbPair;
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(minT < Number.MAX_VALUE)
            {
               dt = minT;
            }
            for(i = 0; i < numBalls; i++)
            {
               goa = this.balls[i];
               goa.integrateVelocity(dt);
            }
            if(minPair != null)
            {
               minPair.resolve();
            }
            t = t + dt;
         }
      }
      
      public function ballwallCollision(ball:Ball, wall:Wall) : Boolean
      {
         this._genericVector3D.x = ball.position.x - wall.pointA.x;
         this._genericVector3D.y = ball.position.y - wall.pointA.y;
         var dotprod:Number = this._genericVector3D.dotProduct(wall.normal);
         if(dotprod < 0)
         {
            return true;
         }
         var ballProjWall:Number = this._genericVector3D.dotProduct(wall.vectorAB);
         var posX:Number = wall.vectorAB.x * ballProjWall + wall.pointA.x;
         var posY:Number = wall.vectorAB.y * ballProjWall + wall.pointA.y;
         var vecX:Number = ball.position.x - posX;
         var vecY:Number = ball.position.y - posY;
         var distanceSquared:Number = vecX * vecX + vecY * vecY;
         if(distanceSquared < ball.radiusSquared)
         {
            return true;
         }
         return false;
      }
      
      private function aabbCollide(a:Rectangle, b:Rectangle) : Boolean
      {
         if(a.right < b.left)
         {
            return false;
         }
         if(a.left > b.right)
         {
            return false;
         }
         if(a.top > b.bottom)
         {
            return false;
         }
         if(a.bottom < b.top)
         {
            return false;
         }
         return true;
      }
      
      public function circleCollision(goa:GameObject, gob:GameObject) : Boolean
      {
         var collthreshSquared:Number = goa.radius + gob.radius;
         var atob:Vector3D = goa.position.subtract(gob.position);
         var lengthSquared:Number = atob.lengthSquared;
         collthreshSquared = collthreshSquared * collthreshSquared;
         if(lengthSquared >= collthreshSquared)
         {
            return false;
         }
         return true;
      }
      
      public function onScreenResize(tableWidth:Number, tableHeight:Number) : void
      {
         this.xScale = tableWidth / this.WORLD_WIDTH;
         this.yScale = tableHeight / this.WORLD_HEIGHT;
      }
      
      public function screenToWorldSpace(x:Number, y:Number) : Vector3D
      {
         var vec:Vector3D = new Vector3D();
         vec.x = x / this.xScale;
         vec.y = y / this.yScale;
         return vec;
      }
      
      public function worldToScreenSpace(x:Number, y:Number) : Vector3D
      {
         var vec:Vector3D = new Vector3D();
         vec.x = x * this.xScale;
         vec.y = y * this.yScale;
         return vec;
      }
      
      public function worldToScreenLength(size:Number) : Number
      {
         return size * this.xScale;
      }
      
      public function screenToWorldLength(value:Number) : Number
      {
         var normalize:Number = (value - Globals.view.table.playFieldOffsetX) / this.xScale;
         return normalize;
      }
   }
}
