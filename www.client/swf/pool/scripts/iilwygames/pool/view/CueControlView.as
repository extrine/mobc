package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import iilwy.utils.StageReference;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerLocal;
   import iilwygames.pool.model.gameplay.CueStick;
   
   public class CueControlView extends Sprite
   {
       
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _radius:Number;
      
      private var cueDotControl:Sprite;
      
      private var cueBallBM:Bitmap;
      
      private var dragging:Boolean;
      
      private var _model:CueStick;
      
      public function CueControlView()
      {
         super();
         this.cueBallBM = new Bitmap();
         addChild(this.cueBallBM);
         this.cueDotControl = new Sprite();
         addChild(this.cueDotControl);
         this.cueDotControl.mouseEnabled = true;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function destroy() : void
      {
         this._model = null;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      public function setStick(stick:CueStick) : void
      {
         this._model = stick;
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
      }
      
      public function update() : void
      {
         var dotPosition:Vector3D = null;
         var player:Player = null;
         var max:Number = NaN;
         var maxSquared:Number = NaN;
         var magnitudeSquared:Number = NaN;
         var magnitude:Number = NaN;
         if(this._model)
         {
            dotPosition = this._model.cueDotControl;
            player = this._model.currentPlayer;
            if(this.dragging && player is PlayerLocal)
            {
               dotPosition.x = mouseX / this._radius;
               dotPosition.y = mouseY / this._radius;
               max = 0.7;
               maxSquared = max * max;
               magnitudeSquared = dotPosition.lengthSquared;
               if(magnitudeSquared > maxSquared)
               {
                  magnitude = Math.sqrt(magnitudeSquared);
                  dotPosition.normalize();
                  dotPosition.scaleBy(max);
               }
            }
            this.cueDotControl.x = dotPosition.x * this._radius;
            this.cueDotControl.y = dotPosition.y * this._radius;
         }
      }
      
      private function onMouseDown(me:MouseEvent) : void
      {
         this.dragging = true;
      }
      
      private function onMouseUp(me:MouseEvent) : void
      {
         this.dragging = false;
      }
      
      private function redraw() : void
      {
         graphics.clear();
         var radius:Number = this._radius;
         radius = radius * 0.15;
         this.cueDotControl.graphics.clear();
         this.cueDotControl.graphics.lineStyle(2,0,1,false);
         this.cueDotControl.graphics.beginFill(248,0.85);
         this.cueDotControl.graphics.drawCircle(0,0,radius);
         this.cueDotControl.graphics.endFill();
      }
      
      public function resize(width:Number, height:Number) : void
      {
         this._width = width;
         this._height = this._width;
         this._radius = this._width * 0.5;
         this.redraw();
      }
      
      public function resizeAssets() : void
      {
         this.cueBallBM.bitmapData = Globals.resourceManager.getTexture("cueBall");
         this.cueBallBM.x = -this.cueBallBM.width * 0.46;
         this.cueBallBM.y = -this.cueBallBM.height * 0.46;
      }
   }
}
