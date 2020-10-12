package iilwy.collections
{
   import flash.events.IEventDispatcher;
   
   public interface ICollection extends IEventDispatcher
   {
       
      
      function get length() : int;
      
      function getItemAt(index:int) : *;
      
      function setItemAt(item:*, index:int) : *;
      
      function getItemIndex(item:*) : int;
      
      function removeItem(item:*) : Boolean;
      
      function removeItemAt(index:int) : *;
      
      function removeAll() : void;
      
      function clearSource() : void;
      
      function contains(item:*) : Boolean;
      
      function itemUpdated(item:*) : void;
      
      function toString() : String;
   }
}
