package com.partlyhuman.types
{
   public class TypedIterator extends FilteredIterator
   {
       
      
      public function TypedIterator(param1:IIterator, param2:Class)
      {
         var unfilteredCollection:IIterator = param1;
         var type:Class = param2;
         super(unfilteredCollection,function(param1:*):Boolean
         {
            return param1 is type;
         });
      }
   }
}
