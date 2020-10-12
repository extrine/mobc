package iilwygames.baloono.effects
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   
   public class SingleParticle extends Sprite
   {
       
      
      public var modelAccelX:Number = 0;
      
      public var cache:Object;
      
      public var modelPosX:Number = 0;
      
      public var modelPosY:Number = 0;
      
      public var percentLife:Number;
      
      public var modelVelX:Number = 0;
      
      public var modelVelY:Number = 0;
      
      public var currentTime:int;
      
      public var dead:Boolean;
      
      public var birthTime:int;
      
      public var manager:ParticleSystem;
      
      public var bitmap:Bitmap;
      
      public var dampY:Number = 0.83;
      
      public var modelAccelY:Number = 0;
      
      public var life:int;
      
      public var dampX:Number = 0.83;
      
      public function SingleParticle()
      {
         super();
         this.dead = true;
      }
      
      public function init(param1:int, param2:int, param3:Object) : void
      {
         this.dead = false;
         this.birthTime = param1;
         this.life = param2;
         this.currentTime = 0;
         this.percentLife = 0;
         this.bitmap = new Bitmap(param3.bitmap);
         this.cache = param3;
         param3.inuse = true;
         addChild(this.bitmap);
      }
      
      public function destroy() : void
      {
         this.dead = true;
         try
         {
            if(parent)
            {
               parent.removeChild(this);
            }
         }
         catch(error:Error)
         {
            trace("child does not exist ");
         }
         if(this.cache)
         {
            this.cache.inuse = false;
         }
      }
      
      public function update(param1:int) : void
      {
         this.bitmap.x = -(this.bitmap.width * 0.5);
         this.bitmap.y = -(this.bitmap.height * 0.5);
         this.currentTime = getTimer() - this.birthTime;
         this.percentLife = this.currentTime / this.life;
         this.modelVelX = this.modelVelX + this.modelAccelX * param1;
         this.modelVelY = this.modelVelY + this.modelAccelY * param1;
         this.modelVelX = this.modelVelX * this.dampX;
         this.modelVelY = this.modelVelY * this.dampY;
         this.modelPosX = this.modelPosX + this.modelVelX * param1;
         this.modelPosY = this.modelPosY + this.modelVelY * param1;
         if(this.percentLife > 1 || this.modelPosX > this.manager.worldWidth || this.modelPosX < 0 || this.modelPosY > this.manager.worldHeight || this.modelPosY < 0)
         {
            this.dead = true;
            this.destroy();
         }
      }
   }
}
