package iilwygames.baloono.gameplay.bomb
{
   import iilwygames.baloono.gameplay.tiles.ExplosionTile;
   
   public class ExplosionManager
   {
       
      
      public var etcacheSize:int = 400;
      
      public var explosions:Vector.<Explosion>;
      
      public var explosionTilePool:Vector.<ExplosionTile>;
      
      public function ExplosionManager()
      {
         super();
         this.explosions = new Vector.<Explosion>();
         this.explosionTilePool = new Vector.<ExplosionTile>();
         var _loc1_:int = 0;
         while(_loc1_ < this.etcacheSize)
         {
            this.explosionTilePool[_loc1_] = new ExplosionTile();
            _loc1_++;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:Explosion = null;
         var _loc2_:int = 0;
         if(this.explosions)
         {
            _loc2_ = 0;
            while(_loc2_ < this.explosions.length)
            {
               _loc1_ = this.explosions[_loc2_];
               _loc1_.destroy();
               _loc2_++;
            }
            this.explosions.splice(0,this.explosions.length);
         }
      }
      
      public function updateExplosions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Explosion = null;
         var _loc3_:int = 0;
         if(this.explosions)
         {
            _loc1_ = 0;
            while(_loc1_ < this.explosions.length)
            {
               _loc2_ = this.explosions[_loc1_];
               if(_loc2_ && _loc2_.markedForRemoval)
               {
                  this.explosions.splice(_loc1_,1);
                  _loc2_.destroy();
               }
               else
               {
                  _loc1_++;
               }
            }
            _loc3_ = this.explosions.length;
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc2_ = this.explosions[_loc1_];
               if(_loc2_)
               {
                  _loc2_.update(null);
               }
               _loc1_++;
            }
         }
      }
      
      public function getExplosionTile() : ExplosionTile
      {
         if(this.explosionTilePool.length > 0)
         {
            return this.explosionTilePool.pop();
         }
         return null;
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.etcacheSize)
         {
            (this.explosionTilePool[_loc1_] as ExplosionTile).init();
            _loc1_++;
         }
      }
      
      public function registerExplosion(param1:Explosion) : void
      {
         this.explosions[this.explosions.length] = param1;
      }
      
      public function returnExplosionTile(param1:ExplosionTile) : void
      {
         this.explosionTilePool.push(param1);
      }
   }
}
