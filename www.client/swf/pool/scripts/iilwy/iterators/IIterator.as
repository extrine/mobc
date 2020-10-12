package iilwy.iterators
{
   public interface IIterator
   {
       
      
      function get index() : int;
      
      function hasNext() : Boolean;
      
      function next() : *;
      
      function reset() : void;
   }
}
