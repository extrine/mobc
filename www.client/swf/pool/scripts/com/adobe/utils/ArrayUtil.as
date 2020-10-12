package com.adobe.utils
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function arrayContainsValue(arr:Array, value:Object) : Boolean
      {
         return arr.indexOf(value) != -1;
      }
      
      public static function removeValueFromArray(arr:Array, value:Object) : void
      {
         var len:uint = arr.length;
         for(var i:Number = len; i > -1; i--)
         {
            if(arr[i] === value)
            {
               arr.splice(i,1);
            }
         }
      }
      
      public static function createUniqueCopy(a:Array) : Array
      {
         var item:Object = null;
         var newArray:Array = new Array();
         var len:Number = a.length;
         for(var i:uint = 0; i < len; i++)
         {
            item = a[i];
            if(!ArrayUtil.arrayContainsValue(newArray,item))
            {
               newArray.push(item);
            }
         }
         return newArray;
      }
      
      public static function copyArray(arr:Array) : Array
      {
         return arr.slice();
      }
      
      public static function arraysAreEqual(arr1:Array, arr2:Array) : Boolean
      {
         if(arr1.length != arr2.length)
         {
            return false;
         }
         var len:Number = arr1.length;
         for(var i:Number = 0; i < len; i++)
         {
            if(arr1[i] !== arr2[i])
            {
               return false;
            }
         }
         return true;
      }
   }
}
