package iilwygames.pool.model.gameplay.Ruleset.trickshots
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class Level
   {
       
      
      public var name:String;
      
      public var levelType:int;
      
      public var shotLimit:int;
      
      public var timeLimit:Number;
      
      private var _ballPositions:Vector.<Vector3D>;
      
      private var _targetPositions:Vector.<Vector3D>;
      
      public function Level()
      {
         super();
         this.name = null;
         this.shotLimit = 0;
         this.timeLimit = 0;
         this._ballPositions = new Vector.<Vector3D>();
         this._targetPositions = new Vector.<Vector3D>();
      }
      
      public function destroy() : void
      {
         this._ballPositions = null;
         this._targetPositions = null;
      }
      
      public function toObject() : *
      {
         var bp:Vector3D = null;
         var tp:Vector3D = null;
         var levelObject:* = new Object();
         var ballData:Array = [];
         var targetData:Array = [];
         for(var i:int = 0; i < this._ballPositions.length; i++)
         {
            bp = this._ballPositions[i];
            ballData.push(bp.x,bp.y,bp.w);
         }
         for(var j:int = 0; j < this._targetPositions.length; j++)
         {
            tp = this._targetPositions[i];
            targetData.push(tp.x,tp.y,tp.w);
         }
         if(ballData.length)
         {
            levelObject.bd = ballData;
         }
         if(targetData.length)
         {
            levelObject.td = targetData;
         }
         levelObject.name = this.name;
         levelObject.sl = this.shotLimit;
         levelObject.tl = this.timeLimit;
         return levelObject;
      }
      
      public function loadFromObject(levelObject:*) : void
      {
         var i:int = 0;
         var bda:Array = levelObject.bd;
         var tda:Array = levelObject.td;
         if(bda)
         {
            for(i = 0; i < bda.length; i = i + 3)
            {
               this._ballPositions.push(new Vector3D(bda[i],bda[i + 1],0,bda[i + 2]));
            }
         }
         if(tda)
         {
            for(i = 0; i < tda.length; i = i + 3)
            {
               this._targetPositions.push(new Vector3D(tda[i],tda[i + 1],0,tda[i + 2]));
            }
         }
         this.name = levelObject.name;
         this.timeLimit = levelObject.tl;
         this.shotLimit = levelObject.sl;
      }
      
      public function saveLevel(rs:Ruleset) : void
      {
         var ball:Ball = null;
         var ballPos:Vector3D = null;
         var targetPos:Vector3D = null;
         this._ballPositions.length = 0;
         this._targetPositions.length = 0;
         var balls:Vector.<Ball> = rs.balls;
         for each(ball in balls)
         {
            ballPos = ball.position.clone();
            ballPos.w = ball.ballNumber;
            this._ballPositions.push(ballPos);
            if(ball.hasTarget)
            {
               targetPos = ball.targetPocket.clone();
               targetPos.w = ball.ballNumber;
               this._targetPositions.push(targetPos);
            }
         }
         ballPos = rs.cueBall.position.clone();
         ballPos.w = 0;
         this._ballPositions.push(ballPos);
         this.shotLimit = Globals.view.editorView.getShotLimit();
         this.timeLimit = Globals.view.editorView.getTimeLimit();
      }
      
      public function loadLevel(rs:Ruleset) : void
      {
         var ball:Ball = null;
         var bp:Vector3D = null;
         for each(bp in this._ballPositions)
         {
            if(bp.w > 0)
            {
               ball = new Ball();
               ball.position.x = bp.x;
               ball.position.y = bp.y;
               ball.ballNumber = bp.w;
               if(ball.ballNumber > 8)
               {
                  ball.ballType = Ball.BALL_STRIPE;
               }
               else
               {
                  ball.ballType = Ball.BALL_SOLID;
               }
               rs.balls.push(ball);
               Globals.model.world.addGameObject(ball);
            }
            else
            {
               rs.cueBall.position.x = bp.x;
               rs.cueBall.position.y = bp.y;
            }
         }
      }
   }
}
