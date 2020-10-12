package iilwygames.baloono.gameplay.tiles
{
   import com.partlyhuman.util.Assert;
   import flash.utils.Dictionary;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.IPlayer;
   import iilwygames.baloono.gameplay.bomb.Explosion;
   import iilwygames.baloono.gameplay.bomb.ExplosionDirection;
   
   public class ExplosionTile extends AbstractTile
   {
       
      
      private var tileCount:int;
      
      protected var occExplosions:Vector.<Explosion>;
      
      public var isActive:Boolean = false;
      
      protected var occupyingExplosions:Dictionary;
      
      protected var directions:Vector.<ExplosionDirection>;
      
      public var combinedDirections:ExplosionDirection;
      
      private var _useDictionary:Boolean = false;
      
      public function ExplosionTile()
      {
         super();
         this.combinedDirections = new ExplosionDirection();
         if(this._useDictionary)
         {
            this.occupyingExplosions = new Dictionary();
         }
         else
         {
            this.occExplosions = new Vector.<Explosion>();
            this.directions = new Vector.<ExplosionDirection>();
         }
         this.tileCount = 0;
         this.isActive = false;
      }
      
      public function get empty() : Boolean
      {
         if(this._useDictionary)
         {
            return this.tileCount == 0;
         }
         if(!this.occExplosions)
         {
            trace("tile was already destroyed!");
            return false;
         }
         return this.occExplosions.length == 0;
      }
      
      public function registerOccupyingExplosion(param1:Explosion, param2:ExplosionDirection) : void
      {
         var _loc3_:int = 0;
         if(this._useDictionary)
         {
            if(this.occupyingExplosions[param1])
            {
               delete this.occupyingExplosions[param1];
            }
            else
            {
               this.tileCount++;
            }
            this.occupyingExplosions[param1] = param2;
         }
         else
         {
            _loc3_ = this.occExplosions.indexOf(param1);
            if(_loc3_ == -1)
            {
               this.occExplosions[this.occExplosions.length] = param1;
               this.directions[this.directions.length] = param2;
            }
            else
            {
               this.directions[_loc3_] = param2;
            }
         }
         this.isActive = true;
         this.validateAppearance();
      }
      
      public function deregisterOccupyingExplosion(param1:Explosion) : void
      {
         var _loc2_:int = 0;
         if(this._useDictionary)
         {
            if(this.occupyingExplosions[param1])
            {
               delete this.occupyingExplosions[param1];
               this.tileCount--;
            }
         }
         else
         {
            _loc2_ = this.occExplosions.indexOf(param1);
            if(_loc2_ != -1)
            {
               this.occExplosions.splice(_loc2_,1);
               this.directions.splice(_loc2_,1);
            }
         }
         this.validateAppearance();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.tileCount = 0;
         if(this._useDictionary)
         {
            this.occupyingExplosions = new Dictionary();
         }
         else
         {
            if(this.occExplosions)
            {
               this.occExplosions.splice(0,this.occExplosions.length);
            }
            if(this.directions)
            {
               this.directions.splice(0,this.directions.length);
            }
         }
      }
      
      public function reset() : void
      {
         this.tileCount = 0;
         if(this._useDictionary)
         {
            this.occupyingExplosions = new Dictionary();
         }
         else
         {
            if(this.occExplosions)
            {
               this.occExplosions.splice(0,this.occExplosions.length);
            }
            if(this.directions)
            {
               this.directions.splice(0,this.directions.length);
            }
         }
         this.isActive = false;
      }
      
      override public function blocksPlayer(param1:IPlayer) : Boolean
      {
         return false;
      }
      
      public function init() : void
      {
         this.isActive = false;
         this.tileCount = 0;
         setArt(BaloonoGame.instance.assetManager.getGraphicSet("explosion"));
      }
      
      protected function validateAppearance() : void
      {
         var _loc1_:ExplosionDirection = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Explosion = null;
         if(this.empty)
         {
            return;
         }
         this.combinedDirections.code = 0;
         if(this._useDictionary)
         {
            for each(_loc1_ in this.occupyingExplosions)
            {
               this.combinedDirections.merge(_loc1_);
            }
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = this.occExplosions.length;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.occExplosions[_loc2_];
               if(_loc4_)
               {
                  _loc1_ = this.directions[_loc2_];
                  if(_loc1_)
                  {
                     this.combinedDirections.merge(_loc1_);
                  }
               }
               _loc2_++;
            }
         }
         if(this.combinedDirections.isNull)
         {
            Assert.assert(this.empty);
         }
         else
         {
            graphics.continueAnimation(this.combinedDirections.toAssetName());
         }
      }
   }
}
