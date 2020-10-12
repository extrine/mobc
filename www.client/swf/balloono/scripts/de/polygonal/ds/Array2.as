package de.polygonal.ds
{
   public class Array2 implements Collection
   {
       
      
      private var _a:Array;
      
      private var _h:int;
      
      private var _w:int;
      
      public function Array2(param1:int, param2:int)
      {
         super();
         this._a = new Array((this._w = param1) * (this._h = param2));
         this.fill(null);
         this._a.sort();
      }
      
      public function get size() : int
      {
         return this._w * this._h;
      }
      
      public function fill(param1:*) : void
      {
         var _loc2_:int = this._w * this._h;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._a[_loc3_] = param1;
            _loc3_++;
         }
      }
      
      public function get width() : int
      {
         return this._w;
      }
      
      public function getCol(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._h)
         {
            _loc2_[_loc3_] = this._a[int(_loc3_ * this._w + param1)];
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function shiftDown() : void
      {
         if(this._h == 1)
         {
            return;
         }
         var _loc1_:int = (this._h - 1) * this._w;
         this._a = this._a.slice(_loc1_,_loc1_ + this._w).concat(this._a);
         this._a.splice(this._h * this._w,this._w);
      }
      
      public function set width(param1:int) : void
      {
         this.resize(param1,this._h);
      }
      
      public function appendCol(param1:Array) : void
      {
         param1.length = this._h;
         var _loc2_:int = 0;
         while(_loc2_ < this._h)
         {
            this._a.splice(_loc2_ * this._w + this._w + _loc2_,0,param1[_loc2_]);
            _loc2_++;
         }
         this._w++;
      }
      
      public function set height(param1:int) : void
      {
         this.resize(this._w,param1);
      }
      
      public function clear() : void
      {
         this._a = new Array(this.size);
      }
      
      public function get(param1:int, param2:int) : *
      {
         return this._a[int(param2 * this._w + param1)];
      }
      
      public function prependCol(param1:Array) : void
      {
         param1.length = this._h;
         var _loc2_:int = 0;
         while(_loc2_ < this._h)
         {
            this._a.splice(_loc2_ * this._w + _loc2_,0,param1[_loc2_]);
            _loc2_++;
         }
         this._w++;
      }
      
      public function isEmpty() : Boolean
      {
         return false;
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = this._a.concat();
         var _loc2_:int = this.size;
         if(_loc1_.length > _loc2_)
         {
            _loc1_.length = _loc2_;
         }
         return _loc1_;
      }
      
      public function contains(param1:*) : Boolean
      {
         var _loc2_:int = this.size;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._a[_loc3_] === param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function appendRow(param1:Array) : void
      {
         param1.length = this._w;
         this._a = this._a.concat(param1);
         this._h++;
      }
      
      public function dump() : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc5_:int = 0;
         var _loc1_:* = "Array2\n{";
         var _loc4_:int = 0;
         while(_loc4_ < this._h)
         {
            _loc1_ = _loc1_ + ("\n" + "\t");
            _loc2_ = _loc4_ * this._w;
            _loc5_ = 0;
            while(_loc5_ < this._w)
            {
               _loc3_ = this._a[int(_loc2_ + _loc5_)];
               _loc1_ = _loc1_ + ("[" + (_loc3_ != undefined?_loc3_:"?") + "]");
               _loc5_++;
            }
            _loc4_++;
         }
         _loc1_ = _loc1_ + "\n}";
         return _loc1_;
      }
      
      public function getArray() : Array
      {
         return this._a;
      }
      
      public function getRow(param1:int) : Array
      {
         var _loc2_:int = param1 * this._w;
         return this._a.slice(_loc2_,_loc2_ + this._w);
      }
      
      public function get height() : int
      {
         return this._h;
      }
      
      public function shiftLeft() : void
      {
         var _loc2_:int = 0;
         if(this._w == 1)
         {
            return;
         }
         var _loc1_:int = this._w - 1;
         var _loc3_:int = 0;
         while(_loc3_ < this._h)
         {
            _loc2_ = _loc3_ * this._w + _loc1_;
            this._a.splice(_loc2_,0,this._a.splice(_loc2_ - _loc1_,1));
            _loc3_++;
         }
      }
      
      public function getIterator() : Iterator
      {
         return new Array2Iterator(this);
      }
      
      public function prependRow(param1:Array) : void
      {
         param1.length = this._w;
         this._a = param1.concat(this._a);
         this._h++;
      }
      
      public function set(param1:int, param2:int, param3:*) : void
      {
         this._a[int(param2 * this._w + param1)] = param3;
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 <= 0)
         {
            param1 = 1;
         }
         if(param2 <= 0)
         {
            param2 = 1;
         }
         var _loc3_:Array = this._a.concat();
         this._a.length = 0;
         this._a.length = param1 * param2;
         var _loc4_:int = param1 < this._w?int(param1):int(this._w);
         var _loc5_:int = param2 < this._h?int(param2):int(this._h);
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _loc7_ * param1;
            _loc9_ = _loc7_ * this._w;
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               this._a[int(_loc8_ + _loc6_)] = _loc3_[int(_loc9_ + _loc6_)];
               _loc6_++;
            }
            _loc7_++;
         }
         this._w = param1;
         this._h = param2;
      }
      
      public function transpose() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = this._a.concat();
         var _loc2_:int = 0;
         while(_loc2_ < this._h)
         {
            _loc3_ = 0;
            while(_loc3_ < this._w)
            {
               this._a[int(_loc3_ * this._w + _loc2_)] = _loc1_[int(_loc2_ * this._w + _loc3_)];
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function shiftRight() : void
      {
         var _loc2_:int = 0;
         if(this._w == 1)
         {
            return;
         }
         var _loc1_:int = this._w - 1;
         var _loc3_:int = 0;
         while(_loc3_ < this._h)
         {
            _loc2_ = _loc3_ * this._w + _loc1_;
            this._a.splice(_loc2_ - _loc1_,0,this._a.splice(_loc2_,1));
            _loc3_++;
         }
      }
      
      public function toString() : String
      {
         return "[Array2, width=" + this.width + ", height=" + this.height + "]";
      }
      
      public function shiftUp() : void
      {
         if(this._h == 1)
         {
            return;
         }
         this._a = this._a.concat(this._a.slice(0,this._w));
         this._a.splice(0,this._w);
      }
   }
}

import de.polygonal.ds.Array2;
import de.polygonal.ds.Iterator;

class Array2Iterator implements Iterator
{
    
   
   private var _xCursor:int;
   
   private var _a2:Array2;
   
   private var _yCursor:int;
   
   function Array2Iterator(param1:Array2)
   {
      super();
      this._a2 = param1;
      this._yCursor = 0;
      this._xCursor = 0;
   }
   
   public function start() : void
   {
      this._yCursor = 0;
      this._xCursor = 0;
   }
   
   public function hasNext() : Boolean
   {
      return this._yCursor * this._a2.width + this._xCursor < this._a2.size;
   }
   
   public function get data() : *
   {
      return this._a2.get(this._xCursor,this._yCursor);
   }
   
   public function set data(param1:*) : void
   {
      this._a2.set(this._xCursor,this._yCursor,param1);
   }
   
   public function next() : *
   {
      var _loc1_:* = this.data;
      if(++this._xCursor == this._a2.width)
      {
         this._yCursor++;
         this._xCursor = 0;
      }
      return _loc1_;
   }
}
