package de.polygonal.ds
{
   import flash.utils.Dictionary;
   
   public class HashMap implements Collection
   {
       
      
      private var _maxSize:int;
      
      private var _initSize:int;
      
      private var _pair:PairNode;
      
      private var _keyMap:Dictionary;
      
      private var _size:int;
      
      private var _tail:PairNode;
      
      private var _dupMap:Dictionary;
      
      private var _head:PairNode;
      
      public function HashMap(param1:int = 500)
      {
         super();
         this._initSize = this._maxSize = Math.max(10,param1);
         this._keyMap = new Dictionary(true);
         this._dupMap = new Dictionary(true);
         this._size = 0;
         var _loc2_:PairNode = new PairNode();
         this._head = this._tail = _loc2_;
         var _loc3_:int = this._initSize + 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.next = new PairNode();
            _loc2_ = _loc2_.next;
            _loc4_++;
         }
         this._tail = _loc2_;
      }
      
      public function containsKey(param1:*) : Boolean
      {
         return this._keyMap[param1] != undefined;
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function isEmpty() : Boolean
      {
         return this._size == 0;
      }
      
      public function remove(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:PairNode = this._keyMap[param1];
         if(_loc2_)
         {
            _loc3_ = _loc2_.obj;
            delete this._keyMap[param1];
            if(_loc2_.prev)
            {
               _loc2_.prev.next = _loc2_.next;
            }
            if(_loc2_.next)
            {
               _loc2_.next.prev = _loc2_.prev;
            }
            if(_loc2_ == this._pair)
            {
               this._pair = _loc2_.next;
            }
            _loc2_.prev = null;
            _loc2_.next = null;
            this._tail.next = _loc2_;
            this._tail = _loc2_;
            if(--this._dupMap[_loc3_] <= 0)
            {
               delete this._dupMap[_loc3_];
            }
            if(--this._size <= this._maxSize - this._initSize)
            {
               _loc4_ = (this._maxSize = this._maxSize - this._initSize) + 1;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  this._head = this._head.next;
                  _loc5_++;
               }
            }
            return _loc3_;
         }
         return null;
      }
      
      public function find(param1:*) : *
      {
         var _loc2_:PairNode = this._keyMap[param1];
         if(_loc2_)
         {
            return _loc2_.obj;
         }
         return null;
      }
      
      public function clear() : void
      {
         var _loc1_:PairNode = null;
         this._keyMap = new Dictionary(true);
         this._dupMap = new Dictionary(true);
         var _loc2_:PairNode = this._pair;
         while(_loc2_)
         {
            _loc1_ = _loc2_.next;
            _loc2_.prev = null;
            _loc2_.next = null;
            _loc2_.key = null;
            _loc2_.obj = null;
            this._tail.next = _loc2_;
            this._tail = this._tail.next;
            _loc2_ = _loc1_;
         }
         this._pair = null;
         this._size = 0;
      }
      
      public function getKeySet() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:PairNode = null;
         var _loc1_:Array = new Array(this._size);
         for each(_loc3_ in this._keyMap)
         {
            _loc1_[_loc2_++] = _loc3_.key;
         }
         return _loc1_;
      }
      
      public function getIterator() : Iterator
      {
         return new HashMapIterator(this._pair);
      }
      
      public function toArray() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:PairNode = null;
         var _loc1_:Array = new Array(this._size);
         for each(_loc3_ in this._keyMap)
         {
            _loc1_[_loc2_++] = _loc3_.obj;
         }
         return _loc1_;
      }
      
      public function contains(param1:*) : Boolean
      {
         return this._dupMap[param1] > 0;
      }
      
      public function toString() : String
      {
         return "[HashMap, size=" + this.size + "]";
      }
      
      public function dump() : String
      {
         var _loc2_:PairNode = null;
         var _loc1_:String = "HashMap:\n";
         for each(_loc2_ in this._keyMap)
         {
            _loc1_ = _loc1_ + ("[key: " + _loc2_.key + ", val:" + _loc2_.obj + "]\n");
         }
         return _loc1_;
      }
      
      public function insert(param1:*, param2:*) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            return false;
         }
         if(this._keyMap[param1])
         {
            return false;
         }
         if(this._size++ == this._maxSize)
         {
            _loc4_ = (this._maxSize = this._maxSize + this._initSize) + 1;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this._tail.next = new PairNode();
               this._tail = this._tail.next;
               _loc5_++;
            }
         }
         var _loc3_:PairNode = this._head;
         this._head = this._head.next;
         _loc3_.key = param1;
         _loc3_.obj = param2;
         _loc3_.next = this._pair;
         if(this._pair)
         {
            this._pair.prev = _loc3_;
         }
         this._pair = _loc3_;
         this._keyMap[param1] = _loc3_;
         if(this._dupMap[param2])
         {
            this._dupMap[param2]++;
         }
         else
         {
            this._dupMap[param2] = 1;
         }
         return true;
      }
   }
}

class PairNode
{
    
   
   public var prev:PairNode;
   
   public var obj;
   
   public var next:PairNode;
   
   public var key;
   
   function PairNode()
   {
      super();
   }
}

import de.polygonal.ds.Iterator;

class HashMapIterator implements Iterator
{
    
   
   private var _walker:PairNode;
   
   private var _pair:PairNode;
   
   function HashMapIterator(param1:PairNode)
   {
      super();
      this._pair = this._walker = param1;
   }
   
   public function start() : void
   {
      this._walker = this._pair;
   }
   
   public function get data() : *
   {
      return this._walker.obj;
   }
   
   public function hasNext() : Boolean
   {
      return this._walker != null;
   }
   
   public function set data(param1:*) : void
   {
      this._walker.obj = param1;
   }
   
   public function next() : *
   {
      var _loc1_:* = this._walker.obj;
      this._walker = this._walker.next;
      return _loc1_;
   }
}
