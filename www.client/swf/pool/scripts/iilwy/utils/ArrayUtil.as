package iilwy.utils
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function findIndexOfElementBasedOnParameter(arr:Array, paramName:String, value:*) : int
      {
         var element:* = findElementBasedOnParameter(arr,paramName,value);
         if(element)
         {
            return arr.indexOf(element);
         }
         return -1;
      }
      
      public static function findElementBasedOnParameter(arr:Array, paramName:String, value:*) : *
      {
         var element:* = undefined;
         for each(element in arr)
         {
            try
            {
               if(element[paramName] == value)
               {
                  return element;
               }
            }
            catch(e:Error)
            {
               continue;
            }
         }
         return null;
      }
      
      public static function copyAndRandomizeArray(arr:Array) : Array
      {
         var removed:* = undefined;
         var copy:Array = arr.concat();
         var result:Array = [];
         var newArray:Array = new Array();
         while(copy.length > 0)
         {
            removed = copy.splice(Math.floor(Math.random() * copy.length),1);
            result.push(removed[0]);
         }
         return result;
      }
      
      public static function createUniqueCopyFromArray1NotInArray2(arr1:Array, arr2:Array) : Array
      {
         var arr1Obj:* = undefined;
         var index:int = 0;
         var uniqueArr:Array = [];
         for each(arr1Obj in arr1)
         {
            index = arr2.indexOf(arr1Obj);
            if(index == -1)
            {
               uniqueArr.push(arr1Obj);
            }
         }
         return uniqueArr;
      }
      
      public static function sortArrayByArray(arr:Array, orderArr:Array, fieldNames:Array = null) : Array
      {
         var arrFieldName:* = undefined;
         var orderArrFieldName:* = undefined;
         var orderArrLen:int = 0;
         var i:int = 0;
         var arrLen:int = 0;
         var j:int = 0;
         var arrObj:* = undefined;
         var orderArrObj:* = undefined;
         var obj:* = undefined;
         var sortedArr:Array = [];
         if(fieldNames && fieldNames.length > 0)
         {
            arrFieldName = fieldNames[0];
            orderArrFieldName = Boolean(fieldNames[1])?fieldNames[1]:null;
            orderArrLen = orderArr.length;
            for(i = 0; i < orderArrLen; i++)
            {
               arrLen = arr.length;
               for(j = 0; j < arrLen; j++)
               {
                  arrObj = Boolean(arrFieldName)?arr[j][arrFieldName]:arr[j];
                  orderArrObj = Boolean(orderArrFieldName)?orderArr[i][orderArrFieldName]:orderArr[i];
                  if(arrObj === orderArrObj)
                  {
                     sortedArr.push(arr[j]);
                  }
               }
            }
         }
         else
         {
            for each(obj in orderArr)
            {
               if(ArrayUtil.arrayContainsValue(arr,obj))
               {
                  sortedArr.push(obj);
               }
            }
         }
         return sortedArr;
      }
      
      public static function createFieldArray(field:String, sourceArray:Array) : Array
      {
         var item:* = undefined;
         var fieldArray:Array = [];
         for each(item in sourceArray)
         {
            if(Object(item).hasOwnProperty(field))
            {
               fieldArray.push(item[field]);
            }
         }
         return fieldArray;
      }
   }
}
