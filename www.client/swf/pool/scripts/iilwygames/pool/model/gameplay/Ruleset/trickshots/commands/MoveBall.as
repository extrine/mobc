package iilwygames.pool.model.gameplay.Ruleset.trickshots.commands
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class MoveBall extends EditorCommand
   {
       
      
      private var ballNumber:int;
      
      private var loc:Vector3D;
      
      private var startLoc:Vector3D;
      
      public function MoveBall()
      {
         super();
         this.loc = new Vector3D();
         this.startLoc = new Vector3D();
      }
      
      override public function destroy() : void
      {
         this.loc = null;
         this.startLoc = null;
      }
      
      override public function execute() : void
      {
         var ball:Ball = null;
         var i:int = 0;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         if(this.ballNumber > 0)
         {
            for(i = 0; i < balls.length; i++)
            {
               ball = balls[i];
               if(ball.ballNumber == this.ballNumber)
               {
                  this.moveBall(ball,this.loc);
                  break;
               }
            }
         }
         else
         {
            ball = Globals.model.ruleset.cueBall;
            this.moveBall(ball,this.loc);
         }
      }
      
      override public function undo() : void
      {
         var ball:Ball = null;
         var i:int = 0;
         var test:Ball = null;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         if(this.ballNumber > 0)
         {
            for(i = 0; i < balls.length; i++)
            {
               test = balls[i];
               if(test.ballNumber == this.ballNumber)
               {
                  ball = test;
                  break;
               }
            }
         }
         else
         {
            ball = Globals.model.ruleset.cueBall;
         }
         if(ball)
         {
            ball.position.x = this.startLoc.x;
            ball.position.y = this.startLoc.y;
         }
      }
      
      public function init(bn:int, x:Number, y:Number) : void
      {
         var b:Ball = null;
         var i:int = 0;
         var test:Ball = null;
         this.ballNumber = bn;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         if(bn > 0)
         {
            for(i = 0; i < balls.length; i++)
            {
               test = balls[i];
               if(test.ballNumber == bn)
               {
                  b = test;
                  break;
               }
            }
         }
         else
         {
            b = Globals.model.ruleset.cueBall;
         }
         if(b)
         {
            this.loc.x = b.position.x;
            this.loc.y = b.position.y;
            this.startLoc.x = x;
            this.startLoc.y = y;
         }
      }
      
      protected function moveBall(ball:Ball, loc:Vector3D) : void
      {
         var i:int = 0;
         var b:Ball = null;
         var vec:Vector3D = null;
         var scale:Number = NaN;
         var radiusSquared:Number = ball.radiusSquared * 4;
         var moveVector:Vector3D = new Vector3D();
         var doubleRadius:Number = ball.radius * 2;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         var cb:Ball = Globals.model.ruleset.cueBall;
         var iter:int = 100;
         var check:Boolean = true;
         while(iter >= 0 && check)
         {
            check = false;
            moveVector.x = 0;
            moveVector.y = 0;
            for(i = -1; i < balls.length; i++)
            {
               if(i == -1)
               {
                  b = cb;
               }
               else
               {
                  b = balls[i];
               }
               if(b != ball)
               {
                  vec = loc.subtract(b.position);
                  if(vec.lengthSquared < radiusSquared)
                  {
                     scale = doubleRadius / vec.length - 1;
                     vec.scaleBy(scale);
                     moveVector.x = moveVector.x + vec.x;
                     moveVector.y = moveVector.y + vec.y;
                     check = true;
                  }
               }
            }
            loc.x = loc.x + moveVector.x;
            loc.y = loc.y + moveVector.y;
            iter = iter - 1;
         }
         ball.position.x = loc.x;
         ball.position.y = loc.y;
      }
   }
}
