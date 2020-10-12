package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.CueStick;
   import iilwygames.pool.util.MathUtil;
   
   public class CueView extends Sprite
   {
       
      
      public var cueStick:Bitmap;
      
      private var _model:CueStick;
      
      public function CueView()
      {
         super();
         this.cueStick = new Bitmap();
         addChild(this.cueStick);
         this._model = null;
         mouseEnabled = false;
      }
      
      public function destroy() : void
      {
         removeChild(this.cueStick);
         this.cueStick = null;
         this._model = null;
      }
      
      public function stop() : void
      {
         this._model = null;
         if(this.cueStick.bitmapData)
         {
            this.cueStick.bitmapData = null;
         }
      }
      
      public function setStick(stick:CueStick) : void
      {
         this._model = stick;
      }
      
      public function update() : void
      {
         var scale:Number = NaN;
         var cueBall:Ball = null;
         var point:Vector3D = null;
         var offset:Number = NaN;
         var xoffset:Number = NaN;
         var yoffset:Number = NaN;
         if(this._model)
         {
            alpha = this._model.alpha;
            graphics.clear();
            if(this._model.active)
            {
               scale = Globals.model.world.worldToScreenLength(1);
               if(this._model.showGuide)
               {
                  cueBall = Globals.model.ruleset.cueBall;
                  if(this._model.ballHit && !this._model.wallHit)
                  {
                     graphics.beginFill(16777215,0.5);
                     graphics.drawCircle(this._model.ghostBall.position.x * scale,this._model.ghostBall.position.y * scale,Globals.model.ruleset.cueBall.radius * scale);
                     graphics.endFill();
                     graphics.lineStyle(2,16777215,0.5);
                     graphics.moveTo(cueBall.position.x * scale,cueBall.position.y * scale);
                     graphics.lineTo(this._model.ghostBall.position.x * scale,this._model.ghostBall.position.y * scale);
                     graphics.moveTo(this._model.ghostBall.position.x * scale,this._model.ghostBall.position.y * scale);
                     graphics.lineTo(this._model.normalResult.x * scale,this._model.normalResult.y * scale);
                     graphics.moveTo(this._model.ghostBall.position.x * scale,this._model.ghostBall.position.y * scale);
                     graphics.lineTo(this._model.tangentResult.x * scale,this._model.tangentResult.y * scale);
                  }
                  else if(this._model.wallHit)
                  {
                     graphics.lineStyle(2,16777215,0.5);
                     graphics.moveTo(cueBall.position.x * scale,cueBall.position.y * scale);
                     for each(point in this._model.cueBallCollisions)
                     {
                        graphics.lineTo(point.x * scale,point.y * scale);
                        graphics.drawCircle(point.x * scale,point.y * scale,Globals.model.ruleset.cueBall.radius * scale);
                        graphics.moveTo(point.x * scale,point.y * scale);
                     }
                  }
                  graphics.lineStyle();
               }
               if(this.cueStick.bitmapData)
               {
                  offset = this.cueStick.bitmapData.width * 0.5;
                  xoffset = Math.cos(this._model.angle + MathUtil.MATH_HALFPI) * offset;
                  yoffset = Math.sin(this._model.angle + MathUtil.MATH_HALFPI) * offset;
                  this.cueStick.x = this._model.tipPosition.x * scale - xoffset;
                  this.cueStick.y = this._model.tipPosition.y * scale - yoffset;
                  this.cueStick.rotation = MathUtil.radiansToDegrees(this._model.angle) + 90;
               }
            }
            if(this._model.active == false && this.cueStick.visible)
            {
               this.cueStick.visible = false;
            }
            else if(this._model.active && this.cueStick.visible == false)
            {
               this.cueStick.visible = true;
            }
            if(this._model.useHand)
            {
               Globals.view.useHandCursor = true;
               Globals.view.buttonMode = true;
            }
            else
            {
               Globals.view.useHandCursor = false;
               Globals.view.buttonMode = false;
            }
         }
      }
      
      public function redrawCue() : void
      {
         var cuesticktexture:BitmapData = null;
         var jid:String = null;
         if(this._model)
         {
            if(this._model.currentPlayer)
            {
               jid = this._model.currentPlayer.playerData.playerJid;
               if(jid)
               {
                  cuesticktexture = Globals.resourceManager.getTexture("pool_cue",jid);
                  if(cuesticktexture)
                  {
                     this.cueStick.bitmapData = cuesticktexture;
                     this.cueStick.smoothing = true;
                  }
               }
            }
            else
            {
               cuesticktexture = Globals.resourceManager.getTexture("pool_cue");
               if(cuesticktexture)
               {
                  this.cueStick.bitmapData = cuesticktexture;
                  this.cueStick.smoothing = true;
               }
            }
         }
      }
      
      public function resize() : void
      {
         this.redrawCue();
      }
   }
}
