package com.partlyhuman.types
{
   public class FilteredIterator implements IIterator
   {
       
      
      protected var filter:Function;
      
      protected var iterator:IIterator;
      
      public function FilteredIterator(param1:IIterator, param2:Function)
      {
         super();
         this.iterator = param1;
         this.filter = param2;
      }
      
      public function next() : Object
      {
         var _loc1_:* = undefined;
         if(!this.iterator.hasNext())
         {
            return null;
         }
         do
         {
            _loc1_ = this.iterator.next();
         }
         while(_loc1_ != null && this.filter(_loc1_) == false);
         
         return _loc1_;
      }
      
      public function peek() : Object
      {
         var _loc1_:Object = null;
         while(true)
         {
            _loc1_ = this.iterator.peek();
            if(_loc1_ == null)
            {
               break;
            }
            if(Boolean(this.filter(_loc1_)))
            {
               return _loc1_;
            }
            this.iterator.next();
         }
         return null;
      }
      
      public function hasNext() : Boolean
      {
         return this.peek() != null;
      }
   }
}
