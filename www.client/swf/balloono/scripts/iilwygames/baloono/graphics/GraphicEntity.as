package iilwygames.baloono.graphics
{
   import com.partlyhuman.debug.Console;
   import com.partlyhuman.types.IDestroyable;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import iilwygames.baloono.BaloonoGame;
   
   public class GraphicEntity extends EventDispatcher implements IDestroyable, IDrawable
   {
       
      
      public var lastW:Number = 0;
      
      public var lastX:Number = 1.7976931348623157E308;
      
      public var lastY:Number = 1.7976931348623157E308;
      
      protected var _x:Number;
      
      public var activeAsset:GraphicAsset;
      
      protected var fpsMultiplier:Number = 1;
      
      public var markForDirtyRect:Boolean;
      
      protected var mspf:int;
      
      protected var _y:Number;
      
      public var gset:GraphicSet;
      
      public var lastH:Number = 0;
      
      public var lastOffsetX:Number = 1.7976931348623157E308;
      
      public var lastOffsetY:Number = 1.7976931348623157E308;
      
      public var tilePositionChanged:Boolean;
      
      protected var fpsMultiplierInverse:Number = 1;
      
      public var positionChanged:Boolean;
      
      protected var activeStartFrame:int;
      
      protected var activeStartTime:uint;
      
      private var lastFrame:Boolean = false;
      
      protected var bitmapData:BitmapData;
      
      public function GraphicEntity()
      {
         super();
         if(!BaloonoGame.instance.DEBUG_ERRORS)
         {
         }
         this._x = this._y = 0;
         this.positionChanged = this.tilePositionChanged = false;
         this.bitmapData = null;
         this.markForDirtyRect = false;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function continueAnimation(param1:String) : void
      {
         var _loc2_:GraphicAsset = this.gset.getAsset(param1);
         if(this.activeAsset)
         {
            this.playAnimation(param1,0,this.activeStartTime);
         }
         else
         {
            this.playAnimation(param1);
         }
      }
      
      public function get isMarkedForDirty() : Boolean
      {
         if(this.markForDirtyRect)
         {
            this.markForDirtyRect = false;
            return true;
         }
         return false;
      }
      
      public function playAnimation(param1:String, param2:int = 0, param3:Object = null) : void
      {
         var _loc4_:GraphicAsset = this.gset.getAsset(param1);
         if(!_loc4_)
         {
            if(BaloonoGame.instance.DEBUG_LOGGING)
            {
               Console.error("Animation not found in set: " + param1);
            }
            return;
         }
         this.activeAsset = _loc4_;
         this.activeStartFrame = param2;
         this.activeStartTime = param3 is uint?uint(uint(param3)):uint(BaloonoGame.time);
         this.mspf = this.activeAsset.defaultmspf;
      }
      
      public function destroy() : void
      {
         this.gset = null;
         this.activeAsset = null;
         this.bitmapData = null;
      }
      
      public function get display() : DisplayObject
      {
         return null;
      }
      
      public function set speedup(param1:Number) : void
      {
         this.fpsMultiplier = param1;
         if(this.fpsMultiplier > 0)
         {
            this.fpsMultiplierInverse = 1 / this.fpsMultiplier;
         }
         else
         {
            this.fpsMultiplierInverse = 1;
         }
      }
      
      public function get isStatic() : Boolean
      {
         return this.activeAsset.isStatic;
      }
      
      public function get bitMapData() : BitmapData
      {
         return this.bitmapData;
      }
      
      public function animationComplete() : void
      {
         dispatchEvent(new AssetEvent(AssetEvent.SEQUENCE_COMPLETE));
         this.lastFrame = true;
      }
      
      public function get drawLayer() : int
      {
         return this.gset.drawLayer;
      }
      
      public function set x(param1:Number) : void
      {
         if(param1 != this._x)
         {
            this.positionChanged = true;
            if(Math.round(this._x) != Math.round(param1))
            {
               this.tilePositionChanged = true;
            }
            this._x = param1;
         }
      }
      
      public function set y(param1:Number) : void
      {
         if(param1 != this._y)
         {
            this.positionChanged = true;
            if(Math.round(this._y) != Math.round(param1))
            {
               this.tilePositionChanged = true;
            }
            this._y = param1;
         }
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function redraw(param1:uint) : void
      {
         var newbmp:BitmapData = null;
         var timestamp:uint = param1;
         if(this.tilePositionChanged || this.positionChanged)
         {
            this.markForDirtyRect = true;
         }
         this.positionChanged = false;
         this.tilePositionChanged = false;
         try
         {
            newbmp = this.activeAsset.getFrame(this.activeStartTime,timestamp,0,this.mspf * this.fpsMultiplierInverse,this);
         }
         catch(e:Error)
         {
            trace("error!");
         }
         if(this.lastFrame && this.activeAsset)
         {
            this.lastFrame = false;
            newbmp = this.activeAsset.getLastFrame();
         }
         if(newbmp != null && this.bitmapData != newbmp)
         {
            this.bitmapData = newbmp;
            this.markForDirtyRect = true;
         }
      }
   }
}
