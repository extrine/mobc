package iilwy.display.core
{
   import iilwy.iterators.ArrayIterator;
   
   public class PopupQueue
   {
       
      
      private var iterator:ArrayIterator;
      
      public function PopupQueue(source:Array = null)
      {
         super();
         this.iterator = new ArrayIterator(source);
      }
      
      public function get source() : Array
      {
         return this.iterator.source;
      }
      
      public function set source(value:Array) : void
      {
         this.iterator.source = value;
      }
      
      public function get index() : int
      {
         return this.iterator.index;
      }
      
      public function hasNext() : Boolean
      {
         return this.iterator.hasNext();
      }
      
      public function next() : PopupQueueItem
      {
         return this.iterator.next() as PopupQueueItem;
      }
      
      public function reset() : void
      {
         this.iterator.reset();
      }
   }
}
