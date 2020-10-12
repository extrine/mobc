package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import iilwygames.pool.model.gameplay.GameObject;
   import iilwygames.pool.util.MathUtil;
   
   public class BallView extends Sprite
   {
      
      protected static const MATH2PI:Number = Math.PI * 2;
       
      
      public var ball:Ball;
      
      public var ballShadow:Bitmap;
      
      protected var ballTexture:BitmapData;
      
      protected var sourceTexture:BitmapData;
      
      protected var transformMatrix:Matrix;
      
      protected var pocketTransformMat:Matrix;
      
      protected var forceRender:Boolean;
      
      protected var textureName:String;
      
      protected var BALL_TEXTURE_SIZE:int = 9;
      
      protected var ballOverlay:Bitmap;
      
      protected var ballGlow2:Bitmap;
      
      protected var pointInCartesian:Vector3D;
      
      protected var saveX:Number;
      
      protected var saveY:Number;
      
      protected const lightingOffset:Number = -0.5;
      
      protected var focusGlow:Sprite;
      
      protected var glowTimer:Number;
      
      protected const DEBUG:Boolean = false;
      
      protected const test_up:Vector3D = new Vector3D(0,-1,0);
      
      protected const test_right:Vector3D = new Vector3D(1,0,0);
      
      private var _gv:Vector.<uint>;
      
      private var _sv:Vector.<uint>;
      
      private var _points:Vector.<Vector3D>;
      
      private var _pixelCoord:Vector.<Point>;
      
      public function BallView()
      {
         super();
         this.transformMatrix = new Matrix();
         this.pocketTransformMat = new Matrix();
         this.forceRender = false;
         this.sourceTexture = null;
         this.ballOverlay = new Bitmap(null,PixelSnapping.NEVER,false);
         addChild(this.ballOverlay);
         this.ballGlow2 = new Bitmap(null);
         addChild(this.ballGlow2);
         this.ballGlow2.visible = false;
         this.ballShadow = new Bitmap();
         this.pointInCartesian = new Vector3D();
         this.ballTexture = new BitmapData(2 * this.BALL_TEXTURE_SIZE,2 * this.BALL_TEXTURE_SIZE,false,0);
         this.focusGlow = new Sprite();
         addChild(this.focusGlow);
         this.pocketTransformMat.translate(-this.BALL_TEXTURE_SIZE - 0.5,-this.BALL_TEXTURE_SIZE - 0.5);
         this.pocketTransformMat.scale(8.5 / this.BALL_TEXTURE_SIZE * 1.13,8.5 / this.BALL_TEXTURE_SIZE * 1.13);
         this.glowTimer = 0;
         this._sv = new Vector.<uint>(this.ballTexture.width * this.ballTexture.height,true);
         this._gv = null;
         for(var i:int = 0; i < this._sv.length; i++)
         {
            this._sv[i] = 255;
         }
         this.precalculatePoints();
      }
      
      public function destroy() : void
      {
         if(this.ballGlow2.bitmapData)
         {
            this.ballGlow2.bitmapData.dispose();
            this.ballGlow2.bitmapData = null;
         }
         this.ballTexture.dispose();
         removeChild(this.ballOverlay);
         removeChild(this.ballGlow2);
         removeChild(this.focusGlow);
         this.ballTexture = null;
         this.ballOverlay = null;
         this.pointInCartesian = null;
         this.sourceTexture = null;
         this.transformMatrix = null;
         this.ball = null;
         this.transformMatrix = null;
         this.pocketTransformMat = null;
         this.ballShadow = null;
         this.ballGlow2 = null;
         this._gv = null;
         this._sv = null;
         this._points = null;
         this._pixelCoord = null;
      }
      
      public function stop() : void
      {
         this.ball = null;
         this.textureName = null;
         this.sourceTexture = null;
         this.forceRender = false;
         visible = false;
         this.ballShadow.visible = false;
      }
      
      public function attachObject(go:GameObject) : void
      {
         this.ball = go as Ball;
         this.forceRender = true;
         var type:int = (this.ball as Ball).ballType;
         var number:int = (this.ball as Ball).ballNumber;
         if(type == Ball.BALL_EXTRA)
         {
            this.textureName = "extra_ball";
         }
         else if(number < 9)
         {
            this.textureName = "solid_" + number.toString();
         }
         else if(number >= 9)
         {
            this.textureName = "stripe_" + number.toString();
         }
         this.ballGlow2.visible = false;
         this.ballOverlay.visible = true;
         this.ballShadow.visible = true;
         visible = true;
         if(this.textureName != null && !this.sourceTexture)
         {
            this.resizeAssets();
         }
      }
      
      public function update(et:Number) : void
      {
         var transform:Matrix = null;
         var radius:Number = NaN;
         var scale:Number = NaN;
         var xoffset:Number = NaN;
         var yoffset:Number = NaN;
         var glowAlpha:Number = NaN;
         if(!this.ball)
         {
            return;
         }
         var myball:Ball = this.ball as Ball;
         var needToRender:Boolean = false;
         var isCueBall:Boolean = myball.ballType == Ball.BALL_CUE;
         if(isCueBall)
         {
            needToRender = true;
         }
         if(myball.hasFocusIndicator)
         {
            if(this.focusGlow.visible == false)
            {
               this.focusGlow.visible = true;
               this.glowTimer = 0;
            }
            needToRender = true;
         }
         if(!myball.hasFocusIndicator && this.focusGlow.visible)
         {
            this.focusGlow.visible = false;
         }
         var ballState:int = myball.ballState;
         if(ballState == Ball.BALL_STATE_DONOTRENDER)
         {
            if(visible)
            {
               visible = false;
               this.ballShadow.visible = false;
            }
            return;
         }
         if(!visible)
         {
            visible = true;
         }
         if(this.saveX != this.ball.position.x)
         {
            this.saveX = this.ball.position.x;
            needToRender = true;
         }
         if(this.saveY != this.ball.position.y)
         {
            this.saveY = this.ball.position.y;
            needToRender = true;
         }
         if(this.forceRender || needToRender)
         {
            if(ballState >= Ball.BALL_STATE_ROLLINGONRAIL)
            {
               radius = 8.5;
               transform = this.pocketTransformMat;
               scale = 318;
               xoffset = Globals.view.bottomBar.x + 74 - Globals.view.table.x;
               yoffset = Globals.view.bottomBar.y + 24 - Globals.view.table.y;
               x = this.ball.position.x * scale + xoffset;
               y = this.ball.position.y * scale + yoffset;
               if(!this.ballGlow2.visible)
               {
                  this.ballGlow2.visible = true;
               }
               if(this.ballOverlay.visible)
               {
                  this.ballOverlay.visible = false;
               }
               if(this.ballShadow.visible)
               {
                  this.ballShadow.visible = false;
               }
            }
            else
            {
               scale = Globals.view.table.playFieldWidth / Globals.model.ruleset.tableWidth;
               xoffset = Globals.view.table.playFieldOffsetX;
               yoffset = Globals.view.table.playFieldOffsetY;
               x = this.ball.position.x * scale + xoffset;
               y = this.ball.position.y * scale + yoffset;
               this.ballShadow.x = this.lightingOffset * this.ballShadow.width + x;
               this.ballShadow.y = this.lightingOffset * this.ballShadow.height + y;
               radius = this.ball.radius * scale;
               transform = this.transformMatrix;
               if(this.ballGlow2.visible)
               {
                  this.ballGlow2.visible = false;
               }
               if(!this.ballOverlay.visible)
               {
                  this.ballOverlay.visible = true;
               }
               if(!this.ballShadow.visible)
               {
                  this.ballShadow.visible = true;
               }
            }
            if(this.ballTexture && this.sourceTexture)
            {
               this.buildBallTexture();
               graphics.clear();
               graphics.beginBitmapFill(this.ballTexture,transform,false,true);
               graphics.drawCircle(0,0,radius);
               graphics.endFill();
               this.forceRender = false;
            }
            if(myball.hasFocusIndicator)
            {
               glowAlpha = Math.sin(this.glowTimer * 4 - Math.PI * 0.5);
               glowAlpha = (glowAlpha + 1) * 0.5;
               this.focusGlow.graphics.clear();
               this.focusGlow.graphics.lineStyle(2,13882323,glowAlpha);
               this.focusGlow.graphics.drawCircle(0,0,radius * 1.2);
               this.glowTimer = this.glowTimer + et;
               this.focusGlow.graphics.lineStyle();
            }
         }
      }
      
      protected function buildBallTexture() : void
      {
         var pixelCoord:Point = null;
         var phi:Number = NaN;
         var theta:Number = NaN;
         var u:Number = NaN;
         var v:Number = NaN;
         var pixelX:int = 0;
         var pixelY:int = 0;
         var index:int = 0;
         var sampleIndex:int = 0;
         var W:int = this.ballTexture.width;
         var H:int = this.ballTexture.height;
         var up:Vector3D = this.ball.upVector;
         var right:Vector3D = this.ball.rightVector;
         var orth:Vector3D = up.crossProduct(right);
         var color:uint = 0;
         var textureWidth:Number = this.sourceTexture.width;
         var textureHeight:Number = this.sourceTexture.height;
         var divTwoPi:Number = 1 / MathUtil.MATH_TWOPI;
         var divPi:Number = 1 / Math.PI;
         var length:int = this._points.length;
         for(var i:int = 0; i < length; i++)
         {
            this.pointInCartesian = this._points[i];
            pixelCoord = this._pixelCoord[i];
            phi = Math.acos(-up.dotProduct(this.pointInCartesian));
            theta = Math.acos(this.pointInCartesian.dotProduct(right) / Math.sin(-phi));
            u = theta * divTwoPi;
            v = phi * divPi;
            if(orth.dotProduct(this.pointInCartesian) > 0)
            {
               v = 1 - v;
            }
            pixelX = int(u * textureWidth);
            pixelY = int(v * textureHeight);
            if(this.pointInCartesian.z == 0)
            {
               color = 0;
            }
            else
            {
               sampleIndex = pixelY * textureWidth + pixelX;
               color = this._gv[sampleIndex];
            }
            index = pixelCoord.y * W + pixelCoord.x;
            this._sv[index] = color;
         }
         this.ballTexture.setVector(this.ballTexture.rect,this._sv);
      }
      
      protected function buildBallTexture2() : void
      {
         var xpos:Number = NaN;
         var xposSquared:Number = NaN;
         var xScaled:Number = NaN;
         var xScaledSquared:Number = NaN;
         var index:int = 0;
         var ypos:Number = NaN;
         var zSquared:int = 0;
         var yScaled:Number = NaN;
         var root:Number = NaN;
         var zScaled:Number = NaN;
         var phi:Number = NaN;
         var theta:Number = NaN;
         var u:Number = NaN;
         var v:Number = NaN;
         var pixelX:int = 0;
         var pixelY:int = 0;
         var sampleIndex:int = 0;
         var W:int = this.ballTexture.width;
         var H:int = this.ballTexture.height;
         var i:int = 0;
         var j:int = 0;
         var radius:Number = this.BALL_TEXTURE_SIZE;
         var radiusSquared:Number = radius * radius;
         var invRadius:Number = 1 / radius;
         this.pointInCartesian.x = 0;
         this.pointInCartesian.y = 0;
         this.pointInCartesian.z = 0;
         var up:Vector3D = this.ball.upVector;
         var right:Vector3D = this.ball.rightVector;
         if(this.DEBUG)
         {
            up = this.test_up;
            right = this.test_right;
         }
         var orth:Vector3D = up.crossProduct(right);
         var color:uint = 0;
         var textureWidth:Number = this.sourceTexture.width;
         var textureHeight:Number = this.sourceTexture.height;
         var divTwoPi:Number = 1 / MathUtil.MATH_TWOPI;
         var divPi:Number = 1 / Math.PI;
         while(i < W)
         {
            j = 0;
            xpos = i - radius;
            xposSquared = xpos * xpos;
            xScaled = xpos * invRadius;
            xScaledSquared = xScaled * xScaled;
            while(j < H)
            {
               index = j * W + i;
               if(this._sv[index] == 0)
               {
                  j++;
               }
               else
               {
                  ypos = j - radius;
                  zSquared = xposSquared + ypos * ypos;
                  color = 0;
                  if(zSquared < radiusSquared)
                  {
                     yScaled = ypos * invRadius;
                     root = 1 - xScaledSquared - yScaled * yScaled;
                     zScaled = 0;
                     if(root > 0)
                     {
                        zScaled = Math.sqrt(root);
                     }
                     this.pointInCartesian.x = xScaled;
                     this.pointInCartesian.y = yScaled;
                     this.pointInCartesian.z = zScaled;
                     phi = Math.acos(-up.dotProduct(this.pointInCartesian));
                     theta = Math.acos(this.pointInCartesian.dotProduct(right) / Math.sin(-phi));
                     u = theta * divTwoPi;
                     v = phi * divPi;
                     if(orth.dotProduct(this.pointInCartesian) > 0)
                     {
                        v = 1 - v;
                     }
                     pixelX = int(u * textureWidth);
                     pixelY = int(v * textureHeight);
                     if(zScaled == 0)
                     {
                        color = 0;
                     }
                     else
                     {
                        sampleIndex = pixelY * textureWidth + pixelX;
                        color = this._gv[sampleIndex];
                     }
                  }
                  this._sv[index] = color;
                  j++;
               }
            }
            i++;
         }
         this.ballTexture.setVector(this.ballTexture.rect,this._sv);
      }
      
      public function resizeAssets() : void
      {
         var tableWidth:Number = NaN;
         var radius:Number = NaN;
         var specular:BitmapData = null;
         var shadow:BitmapData = null;
         var type:int = 0;
         var bglow:BitmapData = null;
         var ppoint:Point = null;
         if(this.ball)
         {
            tableWidth = Globals.view.table.playFieldWidth;
            radius = this.ball.radius * tableWidth / Globals.model.ruleset.tableWidth;
            specular = Globals.resourceManager.getTexture("pool_glow");
            shadow = Globals.resourceManager.getTexture("pool_shadow");
            if(shadow)
            {
               this.ballShadow.bitmapData = shadow;
               this.ballShadow.x = this.lightingOffset * shadow.width;
               this.ballShadow.y = this.lightingOffset * shadow.height;
            }
            if(specular)
            {
               this.ballOverlay.bitmapData = specular;
               this.ballOverlay.x = this.lightingOffset * specular.width;
               this.ballOverlay.y = this.lightingOffset * specular.height;
            }
            specular = Globals.resourceManager.getTexture("pool_glow_fixed");
            shadow = Globals.resourceManager.getTexture("pool_shadow_fixed");
            if(specular)
            {
               if(this.ballGlow2.bitmapData)
               {
                  this.ballGlow2.bitmapData.dispose();
                  this.ballGlow2.bitmapData = null;
               }
               bglow = new BitmapData(specular.width,specular.height);
               ppoint = new Point(0,0);
               bglow.copyPixels(specular,specular.rect,ppoint);
               bglow.copyPixels(shadow,shadow.rect,ppoint,null,null,true);
               this.ballGlow2.bitmapData = bglow;
               this.ballGlow2.x = this.lightingOffset * bglow.width;
               this.ballGlow2.y = this.lightingOffset * bglow.height;
            }
            type = (this.ball as Ball).ballType;
            if(type == Ball.BALL_CUE)
            {
               this.sourceTexture = Globals.resourceManager.getBallTexture("cueball");
            }
            else
            {
               this.sourceTexture = Globals.resourceManager.getBallTexture(this.textureName);
            }
            this.forceRender = true;
            this.transformMatrix.identity();
            this.transformMatrix.translate(-this.BALL_TEXTURE_SIZE - 0.5,-this.BALL_TEXTURE_SIZE - 0.5);
            this.transformMatrix.scale(radius / this.BALL_TEXTURE_SIZE * 1.13,radius / this.BALL_TEXTURE_SIZE * 1.13);
            if(this.sourceTexture)
            {
               this._gv = this.sourceTexture.getVector(this.sourceTexture.rect);
            }
         }
      }
      
      public function resize(tableWidth:Number) : void
      {
         var scale:Number = NaN;
         var radius:Number = NaN;
         if(this.ball)
         {
            this.forceRender = true;
            scale = tableWidth / Globals.model.ruleset.tableWidth;
            radius = this.ball.radius * scale;
            this.transformMatrix.identity();
            this.transformMatrix.translate(-this.BALL_TEXTURE_SIZE - 0.5,-this.BALL_TEXTURE_SIZE - 0.5);
            this.transformMatrix.scale(radius / this.BALL_TEXTURE_SIZE * 1.13,radius / this.BALL_TEXTURE_SIZE * 1.13);
         }
      }
      
      private function precalculatePoints() : void
      {
         var xpos:Number = NaN;
         var xposSquared:Number = NaN;
         var xScaled:Number = NaN;
         var xScaledSquared:Number = NaN;
         var ypos:Number = NaN;
         var zSquared:int = 0;
         var yScaled:Number = NaN;
         var root:Number = NaN;
         var zScaled:Number = NaN;
         var pointC:Vector3D = null;
         var pixelP:Point = null;
         this._points = new Vector.<Vector3D>();
         this._pixelCoord = new Vector.<Point>();
         var W:int = this.ballTexture.width;
         var H:int = this.ballTexture.height;
         var i:int = 0;
         var j:int = 0;
         var radius:Number = this.BALL_TEXTURE_SIZE;
         var radiusSquared:Number = radius * radius;
         var invRadius:Number = 1 / radius;
         this.pointInCartesian.x = 0;
         this.pointInCartesian.y = 0;
         this.pointInCartesian.z = 0;
         while(i < W)
         {
            j = 0;
            xpos = i - radius;
            xposSquared = xpos * xpos;
            xScaled = xpos * invRadius;
            xScaledSquared = xScaled * xScaled;
            while(j < H)
            {
               ypos = j - radius;
               zSquared = xposSquared + ypos * ypos;
               if(zSquared < radiusSquared)
               {
                  yScaled = ypos * invRadius;
                  root = 1 - xScaledSquared - yScaled * yScaled;
                  zScaled = 0;
                  if(root > 0)
                  {
                     zScaled = Math.sqrt(root);
                  }
                  this.pointInCartesian.x = xScaled;
                  this.pointInCartesian.y = yScaled;
                  this.pointInCartesian.z = zScaled;
                  pointC = new Vector3D(xScaled,yScaled,zScaled);
                  pixelP = new Point(i,j);
                  this._points.push(pointC);
                  this._pixelCoord.push(pixelP);
               }
               j++;
            }
            i++;
         }
      }
   }
}
