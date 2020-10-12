package iilwygames.pool.view
{
   import flash.display.Sprite;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.Ruleset.EightballBlitz;
   
   public class SerialBallView extends Sprite
   {
       
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var ballViews:Array;
      
      public function SerialBallView()
      {
         var bv:BallDisplayView = null;
         super();
         this.ballViews = [];
         for(var i:int = 0; i < 5; i++)
         {
            bv = new BallDisplayView();
            addChild(bv);
            this.ballViews.push(bv);
            bv.visible = false;
         }
      }
      
      public function destroy() : void
      {
         var bv:BallDisplayView = null;
         for each(bv in this.ballViews)
         {
            bv.destroy();
         }
         this.ballViews = null;
      }
      
      private function clearViews() : void
      {
         var bv:BallDisplayView = null;
         for(var i:int = 0; i < this.ballViews.length; i++)
         {
            bv = this.ballViews[i];
            bv.visible = false;
         }
      }
      
      public function onViewChange() : void
      {
         var bv:BallDisplayView = null;
         var ball:Ball = null;
         var balls:Vector.<Ball> = (Globals.model.ruleset as EightballBlitz).ballQueue;
         if(balls.length == 0)
         {
            this.clearViews();
         }
         for(var i:int = 0; i < balls.length; i++)
         {
            bv = this.ballViews[i];
            ball = balls[i];
            if(bv && bv.visible == false)
            {
               bv.visible = true;
               bv.setTexture(ball.ballNumber);
            }
         }
      }
      
      public function resize() : void
      {
         var bv:BallDisplayView = null;
         var spacing:Number = 24;
         for(var i:int = 0; i < this.ballViews.length; i++)
         {
            bv = this.ballViews[i];
            if(bv)
            {
               bv.x = i * spacing;
            }
         }
      }
   }
}
