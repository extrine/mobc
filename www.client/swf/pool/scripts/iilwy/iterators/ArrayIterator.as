package iilwy.iterators
{
   public class ArrayIterator implements IIterator
   {
       
      
      protected var _source:Array;
      
      protected var _index:int;
      
      public function ArrayIterator(source:Array = null)
      {
         super();
         this.source = Boolean(source)?source:[];
         this.reset();
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function set source(value:Array) : void
      {
         this._source = Boolean(value)?value:[];
         this.reset();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function hasNext() : Boolean
      {
         return this.index < this._source.length;
      }
      
      public function next() : *
      {
         return this._source[this._index++];
      }
      
      public function reset() : void
      {
         this._index = 0;
      }
   }
}
