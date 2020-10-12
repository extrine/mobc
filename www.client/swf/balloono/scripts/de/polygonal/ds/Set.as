package de.polygonal.ds
{
   import flash.utils.Dictionary;
   
   public class Set implements Collection
   {
       
      
      private var _size:int;
      
      private var _set:Dictionary;
      
      public function Set()
      {
         this._set = new Dictionary(true);
         super();
         this._set = new Dictionary();
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function set(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 == undefined)
         {
            return;
         }
         if(this._set[param1])
         {
            return;
         }
         this._set[param1] = param1;
         this._size++;
      }
      
      public function remove(param1:*) : Boolean
      {
         if(this._set[param1] != undefined)
         {
            delete this._set[param1];
            this._size--;
            return true;
         }
         return false;
      }
      
      public function isEmpty() : Boolean
      {
         return this._size == 0;
      }
      
      public function getIterator() : Iterator
      {
         return new SetIterator(this);
      }
      
      public function toString() : String
      {
         return "[Set, size=" + this.size + "]";
      }
      
      public function contains(param1:*) : Boolean
      {
         return this._set[param1] != undefined;
      }
      
      public function clear() : void
      {
         this._set = new Dictionary();
         this._size = 0;
      }
      
      public function get(param1:*) : *
      {
         var _loc2_:* = this._set[param1];
         return _loc2_ != undefined?_loc2_:null;
      }
      
      public function dump() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:String = "Set:\n";
         for each(_loc2_ in this._set)
         {
            _loc1_ = _loc1_ + ("[val: " + _loc2_ + "]\n");
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc1_:Array = new Array(this._size);
         for(_loc3_ in this._set)
         {
            _loc1_[_loc2_++] = _loc3_;
         }
         return _loc1_;
      }
   }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Set;

class SetIterator implements Iterator
{
    
   
   private var _size:int;
   
   private var _a:Array;
   
   private var _s:Set;
   
   private var _cursor:int;
   
   function SetIterator(param1:Set)
   {
      super();
      this._s = param1;
      this._a = param1.toArray();
      this._cursor = 0;
      this._size = param1.size;
   }
   
   public function start() : void
   {
      this._cursor = 0;
   }
   
   public function next() : *
   {
      return this._a[this._cursor++];
   }
   
   public function hasNext() : Boolean
   {
      return this._cursor < this._size;
   }
   
   public function get data() : *
   {
      return this._a[this._cursor];
   }
   
   public function set data(param1:*) : void
   {
      this._s.remove(this._a[this._cursor]);
      this._s.set(param1);
   }
}
