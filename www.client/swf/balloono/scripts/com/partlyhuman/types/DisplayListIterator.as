package com.partlyhuman.types
{
   import com.partlyhuman.debug.Console;
   import flash.display.DisplayObjectContainer;
   
   public class DisplayListIterator implements IIterator
   {
       
      
      private var index:int;
      
      private var displayContainer:DisplayObjectContainer;
      
      public function DisplayListIterator(param1:DisplayObjectContainer)
      {
         super();
         this.displayContainer = param1;
         this.index = 0;
      }
      
      public function peek() : Object
      {
         if(this.hasNext())
         {
            try
            {
               return this.displayContainer.getChildAt(this.index);
            }
            catch(error:RangeError)
            {
               Console.error("DisplayListIterator unexpectedly caught a RangeError accessing child " + index + " of " + displayContainer.numChildren);
            }
         }
         return null;
      }
      
      public function next() : Object
      {
         if(this.hasNext())
         {
            return this.displayContainer.getChildAt(this.index++);
         }
         return null;
      }
      
      public function hasNext() : Boolean
      {
         return this.index < this.displayContainer.numChildren;
      }
   }
}
