package de.polygonal.ds
{
   public interface Iterator
   {
       
      
      function start() : void;
      
      function set data(param1:*) : void;
      
      function get data() : *;
      
      function next() : *;
      
      function hasNext() : Boolean;
   }
}
