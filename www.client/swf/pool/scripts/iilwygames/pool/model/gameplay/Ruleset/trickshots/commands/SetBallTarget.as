package iilwygames.pool.model.gameplay.Ruleset.trickshots.commands
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class SetBallTarget extends EditorCommand
   {
       
      
      private var _pocketX:Number;
      
      private var _pocketY:Number;
      
      private var _startX:Number;
      
      private var _startY:Number;
      
      private var _hadTarget:Boolean;
      
      private var _ballIndex:int;
      
      private var _removeTarget:Boolean;
      
      public function SetBallTarget()
      {
         super();
      }
      
      override public function execute() : void
      {
         var ball:Ball = null;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         for(var i:int = 0; i < balls.length; i++)
         {
            if(balls[i].ballNumber == this._ballIndex)
            {
               ball = balls[i];
               break;
            }
         }
         if(ball)
         {
            if(this._removeTarget)
            {
               ball.hasTarget = false;
            }
            else
            {
               ball.hasTarget = true;
               ball.targetPocket.x = this._pocketX;
               ball.targetPocket.y = this._pocketY;
            }
         }
      }
      
      override public function undo() : void
      {
         var ball:Ball = null;
         var balls:Vector.<Ball> = Globals.model.ruleset.balls;
         for(var i:int = 0; i < balls.length; i++)
         {
            if(balls[i].ballNumber == this._ballIndex)
            {
               ball = balls[i];
               break;
            }
         }
         if(ball)
         {
            ball.hasTarget = this._hadTarget;
            ball.targetPocket.x = this._startX;
            ball.targetPocket.y = this._startY;
         }
      }
      
      public function init(ball:Ball, startx:Number, starty:Number, hadTarget:Boolean) : void
      {
         var closestPocket:Point = null;
         var pocket:Point = null;
         var xdiff:Number = NaN;
         var ydiff:Number = NaN;
         var distSquared:Number = NaN;
         this._removeTarget = false;
         this._ballIndex = ball.ballNumber;
         this._hadTarget = hadTarget;
         this._startX = startx;
         this._startY = starty;
         var rs:Ruleset = Globals.model.ruleset;
         var pockets:Vector.<Vector3D> = rs.pocketPositions;
         var closestDistance:Number = Number.MAX_VALUE;
         var distance:Number = ball.targetPocket.subtract(ball.position).length;
         if(distance < ball.radius)
         {
            this._removeTarget = true;
         }
         else
         {
            for each(pocket in pockets)
            {
               xdiff = pocket.x - ball.targetPocket.x;
               ydiff = pocket.y - ball.targetPocket.y;
               distSquared = xdiff * xdiff + ydiff * ydiff;
               if(distSquared < closestDistance)
               {
                  closestDistance = distSquared;
                  closestPocket = pocket;
               }
            }
         }
         if(closestPocket)
         {
            this._pocketX = closestPocket.x;
            this._pocketY = closestPocket.y;
         }
      }
   }
}
