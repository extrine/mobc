package iilwygames.pool.model.gameplay.Ruleset.trickshots.commands
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class RemoveBall extends EditorCommand
   {
       
      
      private var _ballIndex:int;
      
      private var _posX:Number;
      
      private var _posY:Number;
      
      private var _saveBallX:Number;
      
      private var _saveBallY:Number;
      
      public function RemoveBall()
      {
         super();
      }
      
      override public function destroy() : void
      {
      }
      
      override public function execute() : void
      {
         var ball:Ball = null;
         var i:int = 0;
         var test:Ball = null;
         var rs:Ruleset = Globals.model.ruleset;
         var balls:Vector.<Ball> = rs.balls;
         if(this._ballIndex > 0)
         {
            for(i = 0; i < balls.length; i++)
            {
               test = balls[i];
               if(test.ballNumber == this._ballIndex)
               {
                  ball = test;
                  break;
               }
            }
         }
         if(ball)
         {
            this._saveBallX = ball.position.x;
            this._saveBallY = ball.position.y;
            rs.balls.splice(balls.indexOf(ball),1);
            Globals.model.world.removeGameObject(ball);
            ball.destroy();
            Globals.view.table.initModels();
         }
      }
      
      override public function undo() : void
      {
         var newBall:Ball = new Ball();
         newBall.ballNumber = this._ballIndex;
         if(this._ballIndex > 8)
         {
            newBall.ballType = Ball.BALL_STRIPE;
         }
         else
         {
            newBall.ballType = Ball.BALL_SOLID;
         }
         newBall.position.x = this._saveBallX;
         newBall.position.y = this._saveBallY;
         Globals.model.world.addGameObject(newBall);
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         balls.push(newBall);
         Globals.view.table.initModels();
      }
      
      public function init(x:Number, y:Number) : int
      {
         var b:Ball = null;
         var vecBetween:Vector3D = null;
         var testDistance:Number = NaN;
         var ball:Ball = null;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         var closestDistance:Number = Number.MAX_VALUE;
         var mousePosition:Vector3D = new Vector3D(x,y);
         var closestIndex:int = -1;
         this._ballIndex = -1;
         for(var i:int = 0; i < balls.length; i++)
         {
            b = balls[i];
            vecBetween = b.position.subtract(mousePosition);
            testDistance = vecBetween.lengthSquared;
            if(testDistance < closestDistance)
            {
               closestIndex = i;
               closestDistance = testDistance;
            }
         }
         if(closestIndex > -1)
         {
            ball = balls[closestIndex];
            this._ballIndex = ball.ballNumber;
            this._posX = x;
            this._posY = y;
         }
         return this._ballIndex;
      }
   }
}
