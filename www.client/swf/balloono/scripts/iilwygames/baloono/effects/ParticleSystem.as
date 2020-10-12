package iilwygames.baloono.effects
{
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import iilwygames.baloono.BaloonoGame;
   
   public class ParticleSystem extends Sprite
   {
       
      
      public const worldHeight:int = 3000;
      
      protected var particleHolder:Sprite;
      
      protected var particlePool:Vector.<SingleParticle>;
      
      protected const maxparticles:int = 150;
      
      protected var particles:Vector.<SingleParticle>;
      
      public const worldWidth:int = 3000;
      
      public function ParticleSystem()
      {
         this.particles = new Vector.<SingleParticle>();
         this.particlePool = new Vector.<SingleParticle>();
         super();
         var _loc1_:int = 0;
         while(_loc1_ < this.maxparticles)
         {
            this.particlePool[this.particlePool.length] = new SingleDroplet();
            _loc1_++;
         }
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SingleParticle = null;
         if(this.particleHolder)
         {
            _loc1_ = 0;
            while(_loc1_ < this.particles.length)
            {
               _loc2_ = this.particles[_loc1_];
               if(_loc2_)
               {
                  _loc2_.destroy();
                  this.particlePool[this.particlePool.length] = _loc2_;
                  _loc1_++;
               }
            }
            this.particleHolder.parent.removeChild(this.particleHolder);
         }
         this.particleHolder = new Sprite();
         addChild(this.particleHolder);
         this.particles.splice(0,this.particles.length);
      }
      
      public function update(param1:uint) : void
      {
         var _loc3_:SingleParticle = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.particles.length)
         {
            _loc3_ = this.particles[_loc2_];
            if(_loc3_ && !_loc3_.dead)
            {
               _loc3_.update(param1 * 0.2);
               _loc3_.x = Math.round(BaloonoGame.instance.mapView.cachedWidth * _loc3_.modelPosX / this.worldWidth);
               _loc3_.y = Math.round(BaloonoGame.instance.mapView.cachedHeight * _loc3_.modelPosY / this.worldHeight);
               _loc2_++;
            }
            else
            {
               this.particlePool[this.particlePool.length] = _loc3_;
               this.particles.splice(_loc2_,1);
            }
         }
      }
      
      public function makeSplash(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:int = 0;
         while(_loc9_ < 5)
         {
            if(param4 == 0)
            {
               param2 = param2 - BaloonoGame.instance.mapView.tileHeight * 0.4 * 0.5 + BaloonoGame.instance.mapView.tileHeight * 0.4 * Math.random();
               _loc6_ = param3 * (1 + 2 * Math.random());
               _loc7_ = -2 * Math.random();
            }
            else
            {
               param1 = param1 - BaloonoGame.instance.mapView.tileWidth * 0.4 * 0.5 + BaloonoGame.instance.mapView.tileWidth * 0.4 * Math.random();
               _loc6_ = -0.5 + Math.random();
               _loc7_ = param4 * (1 + 2 * Math.random());
            }
            this.makeDroplet(param1,param2,_loc6_,_loc7_);
            _loc9_++;
         }
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
      }
      
      public function makeDroplet(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         var _loc6_:SingleDroplet = null;
         if(this.particlePool.length == 0)
         {
            return;
         }
         var _loc5_:Object = BaloonoGame.instance.cacheBitmaps.getNext("droplet");
         if(!_loc5_)
         {
            return;
         }
         _loc6_ = this.particlePool.pop();
         _loc6_.init(getTimer(),300,_loc5_);
         _loc6_.modelVelX = param3;
         _loc6_.modelVelY = param4;
         _loc6_.modelPosX = this.worldWidth * (param1 / BaloonoGame.instance.mapView.cachedWidth);
         _loc6_.modelPosY = this.worldHeight * (param2 / BaloonoGame.instance.mapView.cachedHeight);
         _loc6_.manager = this;
         this.particleHolder.addChild(_loc6_);
         this.insertParticle(_loc6_);
      }
      
      public function insertParticle(param1:SingleParticle) : void
      {
         this.particles[this.particles.length] = param1;
         this.particleHolder.addChild(param1);
      }
   }
}
