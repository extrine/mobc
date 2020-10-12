package de.polygonal.ds
{
   public interface Collection
   {
       
      
      function get size() : int;
      
      function isEmpty() : Boolean;
      
      function getIterator() : Iterator;
      
      function clear() : void;
      
      function toArray() : Array;
      
      function contains(param1:*) : Boolean;
   }
}
