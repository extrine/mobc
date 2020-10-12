package iilwygames.baloono.effects
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Matrix;
   import iilwygames.baloono.BaloonoGame;
   
   public class CacheBitmaps
   {
       
      
      public var byName:Object;
      
      public function CacheBitmaps()
      {
         super();
      }
      
      public function init() : void
      {
         if(this.byName)
         {
            this.clear();
         }
         else
         {
            this.byName = new Object();
         }
      }
      
      public function cache(param1:String, param2:DisplayObjectContainer, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:Array = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:BitmapData = null;
         var _loc16_:Object = null;
         if(!this.byName[param1])
         {
            _loc6_ = new Array();
            _loc7_ = param2.getChildByName("ref") as DisplayObject;
            _loc8_ = param2.getChildByName("content") as DisplayObject;
            _loc9_ = param4 / _loc7_.width;
            _loc10_ = param5 / _loc7_.height;
            _loc11_ = _loc8_.width * _loc9_;
            _loc12_ = _loc8_.height * _loc10_;
            _loc13_ = 0;
            while(_loc13_ < param3)
            {
               _loc15_ = new BitmapData(_loc11_,_loc12_,true,16711680);
               _loc15_.draw(param2,new Matrix(_loc9_,0,0,_loc10_,0,0));
               _loc16_ = {
                  "bitmap":_loc15_,
                  "inuse":false
               };
               _loc6_.push(_loc16_);
               _loc13_++;
            }
            _loc14_ = {
               "original":param2,
               "cache":_loc6_
            };
            this.byName[param1] = _loc14_;
         }
      }
      
      public function getNext(param1:String) : Object
      {
         var _loc3_:int = 0;
         var _loc2_:Array = this.byName[param1].cache;
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].inuse == false)
               {
                  return _loc2_[_loc3_];
               }
               _loc3_++;
            }
            return null;
         }
         trace("couldn\'t find cache for " + param1);
         return null;
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc5_:* = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc3_:int = BaloonoGame.instance.mapView.tileWidth;
         var _loc4_:int = BaloonoGame.instance.mapView.tileHeight;
         for(_loc5_ in this.byName)
         {
            _loc6_ = this.byName[_loc5_].original;
            _loc7_ = _loc6_.getChildByName("ref") as DisplayObject;
            _loc8_ = _loc6_.getChildByName("content") as DisplayObject;
            _loc9_ = _loc3_ / _loc7_.width;
            _loc10_ = _loc4_ / _loc7_.height;
            _loc11_ = _loc8_.width * _loc9_;
            _loc12_ = _loc8_.height * _loc10_;
            _loc13_ = this.byName[_loc5_].cache;
            _loc14_ = 0;
            while(_loc14_ < _loc13_.length)
            {
               _loc13_[_loc14_].bitmap.dispose();
               _loc13_[_loc14_].bitmap = new BitmapData(Math.max(1,_loc11_),Math.max(1,_loc12_),true,16711680);
               _loc13_[_loc14_].bitmap.draw(_loc6_,new Matrix(_loc9_,0,0,_loc10_,0,0));
               _loc14_++;
            }
         }
      }
      
      public function clear() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         for(_loc1_ in this.byName)
         {
            _loc2_ = this.byName[_loc1_].cache;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].bitmap.dispose();
               _loc2_[_loc3_].bitmap = null;
               _loc3_++;
            }
         }
         this.byName = new Object();
      }
   }
}
