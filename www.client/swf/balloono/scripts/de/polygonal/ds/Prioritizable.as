package de.polygonal.ds
{
   public class Prioritizable
   {
       
      
      protected var _priority:int;
      
      public function Prioritizable(param1:int = -1)
      {
         super();
         this._priority = param1;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function toString() : String
      {
         return "[Prioritizable, priority=" + this.priority + "]";
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
   }
}
