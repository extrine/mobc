package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DateBase
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      private static var initialized:Boolean = false;
      
      private static var _dayNamesLong:Array;
      
      private static var dayNamesLongOverride:Array;
      
      private static var _dayNamesShort:Array;
      
      private static var dayNamesShortOverride:Array;
      
      private static var _monthNamesLong:Array;
      
      private static var monthNamesLongOverride:Array;
      
      private static var _monthNamesShort:Array;
      
      private static var monthNamesShortOverride:Array;
      
      private static var _timeOfDay:Array;
      
      private static var timeOfDayOverride:Array;
       
      
      public function DateBase()
      {
         super();
      }
      
      public static function get dayNamesLong() : Array
      {
         initialize();
         return _dayNamesLong;
      }
      
      public static function set dayNamesLong(value:Array) : void
      {
         dayNamesLongOverride = value;
         _dayNamesLong = value != null?value:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
      }
      
      public static function get dayNamesShort() : Array
      {
         initialize();
         return _dayNamesShort;
      }
      
      public static function set dayNamesShort(value:Array) : void
      {
         dayNamesShortOverride = value;
         _dayNamesShort = value != null?value:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
      }
      
      mx_internal static function get defaultStringKey() : Array
      {
         initialize();
         return monthNamesLong.concat(timeOfDay);
      }
      
      public static function get monthNamesLong() : Array
      {
         initialize();
         return _monthNamesLong;
      }
      
      public static function set monthNamesLong(value:Array) : void
      {
         var monthSymbol:String = null;
         var n:int = 0;
         var i:int = 0;
         monthNamesLongOverride = value;
         _monthNamesLong = value != null?value:["January","February","March","April","May","June","July","August","September","October","November","December"];
         if(value == null)
         {
            monthSymbol = " ";
            if(monthSymbol != " ")
            {
               n = Boolean(_monthNamesLong)?int(_monthNamesLong.length):int(0);
               for(i = 0; i < n; i++)
               {
                  _monthNamesLong[i] = _monthNamesLong[i] + monthSymbol;
               }
            }
         }
      }
      
      public static function get monthNamesShort() : Array
      {
         initialize();
         return _monthNamesShort;
      }
      
      public static function set monthNamesShort(value:Array) : void
      {
         var monthSymbol:String = null;
         var n:int = 0;
         var i:int = 0;
         monthNamesShortOverride = value;
         _monthNamesShort = value != null?value:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
         if(value == null)
         {
            monthSymbol = " ";
            if(monthSymbol != " ")
            {
               n = Boolean(_monthNamesShort)?int(_monthNamesShort.length):int(0);
               for(i = 0; i < n; i++)
               {
                  _monthNamesShort[i] = _monthNamesShort[i] + monthSymbol;
               }
            }
         }
      }
      
      public static function get timeOfDay() : Array
      {
         initialize();
         return _timeOfDay;
      }
      
      public static function set timeOfDay(value:Array) : void
      {
         timeOfDayOverride = value;
         var am:String = "AM";
         var pm:String = "PM";
         _timeOfDay = value != null?value:[am,pm];
      }
      
      private static function initialize() : void
      {
         if(!initialized)
         {
            static_resourcesChanged();
            initialized = true;
         }
      }
      
      private static function static_resourcesChanged() : void
      {
         dayNamesLong = dayNamesLongOverride;
         dayNamesShort = dayNamesShortOverride;
         monthNamesLong = monthNamesLongOverride;
         monthNamesShort = monthNamesShortOverride;
         timeOfDay = timeOfDayOverride;
      }
      
      mx_internal static function extractTokenDate(date:Date, tokenInfo:Object) : String
      {
         var day:int = 0;
         var hours:int = 0;
         var year:String = null;
         var month:int = 0;
         var mins:int = 0;
         var sec:int = 0;
         var ms:int = 0;
         initialize();
         var result:String = "";
         var key:int = int(tokenInfo.end) - int(tokenInfo.begin);
         switch(tokenInfo.token)
         {
            case "Y":
               year = date.getFullYear().toString();
               if(key < 3)
               {
                  return year.substr(2);
               }
               if(key > 4)
               {
                  return setValue(Number(year),key);
               }
               return year;
            case "M":
               month = int(date.getMonth());
               if(key < 3)
               {
                  month++;
                  result = result + setValue(month,key);
                  return result;
               }
               if(key == 3)
               {
                  return monthNamesShort[month];
               }
               return monthNamesLong[month];
            case "D":
               day = int(date.getDate());
               result = result + setValue(day,key);
               return result;
            case "E":
               day = int(date.getDay());
               if(key < 3)
               {
                  result = result + setValue(day,key);
                  return result;
               }
               if(key == 3)
               {
                  return dayNamesShort[day];
               }
               return dayNamesLong[day];
            case "A":
               hours = int(date.getHours());
               if(hours < 12)
               {
                  return timeOfDay[0];
               }
               return timeOfDay[1];
            case "H":
               hours = int(date.getHours());
               if(hours == 0)
               {
                  hours = 24;
               }
               result = result + setValue(hours,key);
               return result;
            case "J":
               hours = int(date.getHours());
               result = result + setValue(hours,key);
               return result;
            case "K":
               hours = int(date.getHours());
               if(hours >= 12)
               {
                  hours = hours - 12;
               }
               result = result + setValue(hours,key);
               return result;
            case "L":
               hours = int(date.getHours());
               if(hours == 0)
               {
                  hours = 12;
               }
               else if(hours > 12)
               {
                  hours = hours - 12;
               }
               result = result + setValue(hours,key);
               return result;
            case "N":
               mins = int(date.getMinutes());
               result = result + setValue(mins,key);
               return result;
            case "S":
               sec = int(date.getSeconds());
               result = result + setValue(sec,key);
               return result;
            case "Q":
               ms = int(date.getMilliseconds());
               result = result + setValue(ms,key);
               return result;
            default:
               return result;
         }
      }
      
      private static function setValue(value:Object, key:int) : String
      {
         var n:int = 0;
         var i:int = 0;
         var result:String = "";
         var vLen:int = value.toString().length;
         if(vLen < key)
         {
            n = key - vLen;
            for(i = 0; i < n; i++)
            {
               result = result + "0";
            }
         }
         result = result + value.toString();
         return result;
      }
   }
}
