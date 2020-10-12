package com.facebook.graph.utils
{
   import flash.net.URLVariables;
   
   public class FacebookDataUtils
   {
       
      
      public function FacebookDataUtils()
      {
         super();
      }
      
      public static function stringToDate(value:String) : Date
      {
         var datePeices:Array = null;
         if(value == null)
         {
            return null;
         }
         if(/[^0-9]/g.test(value) == false)
         {
            return new Date(parseInt(value) * 1000);
         }
         if(/(\d\d)\/(\d\d)(\/\d+)?/ig.test(value))
         {
            datePeices = value.split("/");
            if(datePeices.length == 3)
            {
               return new Date(datePeices[2],Number(datePeices[0]) - 1,datePeices[1]);
            }
            return new Date(0,Number(datePeices[1]) - 1,datePeices[0]);
         }
         if(/\d{4}-\d\d-\d\d[\sT]\d\d:\d\d(:\d\d)?[\.\-Z\+]?(\d{0,4})?(\:)?(\-\d\d:)?/ig.test(value))
         {
            return iso8601ToDate(value);
         }
         return new Date(value);
      }
      
      protected static function iso8601ToDate(value:String) : Date
      {
         var index:int = 0;
         var temp:Number = NaN;
         var offset:String = null;
         var userOffset:Number = NaN;
         var parts:Array = value.toUpperCase().split("T");
         var date:Array = parts[0].split("-");
         var time:Array = parts.length <= 1?[]:parts[1].split(":");
         var year:uint = date[0] == ""?uint(0):uint(Number(date[0]));
         var month:uint = date[1] == ""?uint(0):uint(Number(date[1] - 1));
         var day:uint = date[2] == ""?uint(1):uint(Number(date[2]));
         var hour:int = time[0] == ""?int(0):int(Number(time[0]));
         var minute:uint = time[1] == ""?uint(0):uint(Number(time[1]));
         var second:uint = 0;
         var millisecond:uint = 0;
         if(time[2] != null)
         {
            index = time[2].length;
            if(time[2].indexOf("+") > -1)
            {
               index = time[2].indexOf("+");
            }
            else if(time[2].indexOf("-") > -1)
            {
               index = time[2].indexOf("-");
            }
            else if(time[2].indexOf("Z") > -1)
            {
               index = time[2].indexOf("Z");
            }
            if(isNaN(index))
            {
               temp = Number(time[2].slice(0,index));
               second = temp << 0;
               millisecond = 1000 * (temp % 1 / 1);
            }
            if(index != time[2].length)
            {
               offset = time[2].slice(index);
               userOffset = new Date(year,month,day).getTimezoneOffset() / 60;
               switch(offset.charAt(0))
               {
                  case "+":
                  case "-":
                     hour = hour - (userOffset + Number(offset.slice(0)));
                     break;
                  case "Z":
                     hour = hour - userOffset;
               }
            }
         }
         return new Date(year,month,day,hour,minute,second,millisecond);
      }
      
      public static function dateToUnixTimeStamp(date:Date) : uint
      {
         return date.time / 1000;
      }
      
      public static function flattenArray(source:Array) : Array
      {
         if(source == null)
         {
            return [];
         }
         return FacebookDataUtils.internalFlattenArray(source);
      }
      
      public static function getURLVariables(url:String) : URLVariables
      {
         var params:String = null;
         if(url.indexOf("#") != -1)
         {
            params = url.slice(url.indexOf("#") + 1);
         }
         else if(url.indexOf("?") != -1)
         {
            params = url.slice(url.indexOf("?") + 1);
         }
         var vars:URLVariables = new URLVariables();
         vars.decode(params);
         return vars;
      }
      
      private static function internalFlattenArray(source:Array, destination:Array = null) : Array
      {
         var item:Object = null;
         if(destination == null)
         {
            destination = [];
         }
         var l:uint = source.length;
         for(var i:uint = 0; i < l; i++)
         {
            item = source[i];
            if(item is Array)
            {
               FacebookDataUtils.internalFlattenArray(item as Array,destination);
            }
            else
            {
               destination.push(item);
            }
         }
         return destination;
      }
   }
}
