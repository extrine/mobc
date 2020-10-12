package org.igniterealtime.xiff.util
{
   public class DateTimeParser
   {
       
      
      public function DateTimeParser()
      {
         super();
      }
      
      public static function date2string(date:Date) : String
      {
         var value:String = date.getUTCFullYear() + "-";
         value = value + ((date.getUTCMonth() < 9?"0":"") + (date.getUTCMonth() + 1) + "-");
         value = value + ((date.getUTCDate() < 10?"0":"") + date.getUTCDate());
         return value;
      }
      
      public static function string2date(stamp:String) : Date
      {
         var date:Date = new Date();
         date.setUTCFullYear(stamp.substr(0,4));
         date.setUTCMonth(parseInt(stamp.substr(5,2)) - 1);
         date.setUTCDate(stamp.substr(8,2));
         return date;
      }
      
      public static function time2string(time:Date, ms:Boolean = false) : String
      {
         var value:String = (time.getUTCHours() < 10?"0":"") + time.getUTCHours() + ":";
         value = value + ((time.getUTCMinutes() < 10?"0":"") + time.getUTCMinutes() + ":");
         value = value + ((time.getUTCSeconds() < 10?"0":"") + time.getUTCSeconds());
         if(ms)
         {
            value = value + ("." + (time.getUTCMilliseconds() < 10?"0":"") + (time.getUTCMilliseconds() < 100?"0":"") + time.getUTCMilliseconds());
         }
         return value;
      }
      
      public static function string2time(stamp:String) : Date
      {
         var date:Date = new Date();
         date.setUTCHours(stamp.substr(0,2));
         date.setUTCMinutes(stamp.substr(3,2));
         date.setUTCSeconds(stamp.substr(6,2));
         if(stamp.length > 10)
         {
            date.setUTCMilliseconds(parseInt(stamp.substr(10,3)));
         }
         return date;
      }
      
      public static function dateTime2string(dateTime:Date, ms:Boolean = false) : String
      {
         var value:String = date2string(dateTime) + "T";
         value = value + time2string(dateTime,ms);
         return value;
      }
      
      public static function string2dateTime(stamp:String) : Date
      {
         var date:Date = string2date(stamp.substring(0,stamp.indexOf("T")));
         var time:Date = string2time(stamp.substring(stamp.indexOf("T") + 1));
         date.setUTCHours(time.getUTCHours(),time.getUTCMinutes(),time.getUTCSeconds(),time.getUTCMilliseconds());
         return date;
      }
   }
}
