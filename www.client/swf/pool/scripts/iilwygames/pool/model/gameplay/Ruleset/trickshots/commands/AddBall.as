package iilwygames.pool.model.gameplay.Ruleset.trickshots.commands
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class AddBall extends MoveBall
   {
       
      
      private var loc:Vector3D;
      
      private var _ballNumber:int;
      
      public function AddBall()
      {
         super();
         this.loc = new Vector3D();
      }
      
      override public function destroy() : void
      {
         this.loc = null;
      }
      
      override public function execute() : void
      {
         this.addBall(this._ballNumber,this.loc);
      }
      
      override public function undo() : void
      {
         var ball:Ball = null;
         var rs:Ruleset = Globals.model.ruleset;
         var balls:Vector.<Ball> = rs.balls;
         for(var i:int = 0; i < balls.length; i++)
         {
            ball = balls[i];
            if(ball.ballNumber == this._ballNumber)
            {
               balls.splice(i,1);
               Globals.model.world.removeGameObject(ball);
               ball.destroy();
               ball = null;
               Globals.view.table.initModels();
               break;
            }
         }
      }
      
      override public function init(ballNumber:int, x:Number, y:Number) : void
      {
         this._ballNumber = ballNumber;
         this.loc.x = x;
         this.loc.y = y;
      }
      
      private function addBall(number:int, loc:Vector3D) : void
      {
         var newBall:Ball = new Ball();
         newBall.ballType = number;
         newBall.ballNumber = number;
         if(number > 8)
         {
            newBall.ballType = Ball.BALL_STRIPE;
         }
         else
         {
            newBall.ballType = Ball.BALL_SOLID;
         }
         moveBall(newBall,loc);
         Globals.model.world.addGameObject(newBall);
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         balls.push(newBall);
         this._ballNumber = newBall.ballNumber;
         Globals.view.table.initModels();
      }
   }
}
