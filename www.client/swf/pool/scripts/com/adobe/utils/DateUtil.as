package com.adobe.utils
{
   import mx.formatters.DateBase;
   
   public class DateUtil
   {
       
      
      public function DateUtil()
      {
         super();
      }
      
      public static function getShortMonthName(d:Date) : String
      {
         return DateBase.monthNamesShort[d.getMonth()];
      }
      
      public static function getShortMonthIndex(m:String) : int
      {
         return DateBase.monthNamesShort.indexOf(m);
      }
      
      public static function getFullMonthName(d:Date) : String
      {
         return DateBase.monthNamesLong[d.getMonth()];
      }
      
      public static function getFullMonthIndex(m:String) : int
      {
         return DateBase.monthNamesLong.indexOf(m);
      }
      
      public static function getShortDayName(d:Date) : String
      {
         return DateBase.dayNamesShort[d.getDay()];
      }
      
      public static function getShortDayIndex(d:String) : int
      {
         return DateBase.dayNamesShort.indexOf(d);
      }
      
      public static function getFullDayName(d:Date) : String
      {
         return DateBase.dayNamesLong[d.getDay()];
      }
      
      public static function getFullDayIndex(d:String) : int
      {
         return DateBase.dayNamesLong.indexOf(d);
      }
      
      public static function getShortYear(d:Date) : String
      {
         var dStr:String = String(d.getFullYear());
         if(dStr.length < 3)
         {
            return dStr;
         }
         return dStr.substr(dStr.length - 2);
      }
      
      public static function compareDates(d1:Date, d2:Date) : int
      {
         var d1ms:Number = d1.getTime();
         var d2ms:Number = d2.getTime();
         if(d1ms > d2ms)
         {
            return -1;
         }
         if(d1ms < d2ms)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getShortHour(d:Date) : int
      {
         var h:int = d.hours;
         if(h == 0 || h == 12)
         {
            return 12;
         }
         if(h > 12)
         {
            return h - 12;
         }
         return h;
      }
      
      public static function getAMPM(d:Date) : String
      {
         return d.hours > 11?"PM":"AM";
      }
      
      public static function parseRFC822(str:String) : Date
      {
         var finalDate:Date = null;
         var dateParts:Array = null;
         var day:String = null;
         var date:Number = NaN;
         var month:Number = NaN;
         var year:Number = NaN;
         var timeParts:Array = null;
         var hour:Number = NaN;
         var minute:Number = NaN;
         var second:Number = NaN;
         var milliseconds:Number = NaN;
         var timezone:String = null;
         var offset:Number = NaN;
         var multiplier:Number = NaN;
         var oHours:Number = NaN;
         var oMinutes:Number = NaN;
         var eStr:String = null;
         try
         {
            dateParts = str.split(" ");
            day = null;
            if(dateParts[0].search(/\d/) == -1)
            {
               day = dateParts.shift().replace(/\W/,"");
            }
            date = Number(dateParts.shift());
            month = Number(DateUtil.getShortMonthIndex(dateParts.shift()));
            year = Number(dateParts.shift());
            timeParts = dateParts.shift().split(":");
            hour = int(timeParts.shift());
            minute = int(timeParts.shift());
            second = timeParts.length > 0?Number(int(timeParts.shift())):Number(0);
            milliseconds = Date.UTC(year,month,date,hour,minute,second,0);
            timezone = dateParts.shift();
            offset = 0;
            if(timezone.search(/\d/) == -1)
            {
               switch(timezone)
               {
                  case "UT":
                     offset = 0;
                     break;
                  case "UTC":
                     offset = 0;
                     break;
                  case "GMT":
                     offset = 0;
                     break;
                  case "EST":
                     offset = -5 * 3600000;
                     break;
                  case "EDT":
                     offset = -4 * 3600000;
                     break;
                  case "CST":
                     offset = -6 * 3600000;
                     break;
                  case "CDT":
                     offset = -5 * 3600000;
                     break;
                  case "MST":
                     offset = -7 * 3600000;
                     break;
                  case "MDT":
                     offset = -6 * 3600000;
                     break;
                  case "PST":
                     offset = -8 * 3600000;
                     break;
                  case "PDT":
                     offset = -7 * 3600000;
                     break;
                  case "Z":
                     offset = 0;
                     break;
                  case "A":
                     offset = -1 * 3600000;
                     break;
                  case "M":
                     offset = -12 * 3600000;
                     break;
                  case "N":
                     offset = 1 * 3600000;
                     break;
                  case "Y":
                     offset = 12 * 3600000;
                     break;
                  default:
                     offset = 0;
               }
            }
            else
            {
               multiplier = 1;
               oHours = 0;
               oMinutes = 0;
               if(timezone.length != 4)
               {
                  if(timezone.charAt(0) == "-")
                  {
                     multiplier = -1;
                  }
                  timezone = timezone.substr(1,4);
               }
               oHours = Number(timezone.substr(0,2));
               oMinutes = Number(timezone.substr(2,2));
               offset = (oHours * 3600000 + oMinutes * 60000) * multiplier;
            }
            finalDate = new Date(milliseconds - offset);
            if(finalDate.toString() == "Invalid Date")
            {
               throw new Error("This date does not conform to RFC822.");
            }
         }
         catch(e:Error)
         {
            eStr = "Unable to parse the string [" + str + "] into a date. ";
            eStr = eStr + ("The internal error was: " + e.toString());
            throw new Error(eStr);
         }
         return finalDate;
      }
      
      public static function toRFC822(d:Date) : String
      {
         var date:Number = d.getUTCDate();
         var hours:Number = d.getUTCHours();
         var minutes:Number = d.getUTCMinutes();
         var seconds:Number = d.getUTCSeconds();
         var sb:String = new String();
         sb = sb + DateBase.dayNamesShort[d.getUTCDay()];
         sb = sb + ", ";
         if(date < 10)
         {
            sb = sb + "0";
         }
         sb = sb + date;
         sb = sb + " ";
         sb = sb + DateBase.monthNamesShort[d.getUTCMonth()];
         sb = sb + " ";
         sb = sb + d.getUTCFullYear();
         sb = sb + " ";
         if(hours < 10)
         {
            sb = sb + "0";
         }
         sb = sb + hours;
         sb = sb + ":";
         if(minutes < 10)
         {
            sb = sb + "0";
         }
         sb = sb + minutes;
         sb = sb + ":";
         if(seconds < 10)
         {
            sb = sb + "0";
         }
         sb = sb + seconds;
         sb = sb + " GMT";
         return sb;
      }
      
      public static function parseW3CDTF(str:String) : Date
      {
         var finalDate:Date = null;
         var dateStr:String = null;
         var timeStr:String = null;
         var dateArr:Array = null;
         var year:Number = NaN;
         var month:Number = NaN;
         var date:Number = NaN;
         var multiplier:Number = NaN;
         var offsetHours:Number = NaN;
         var offsetMinutes:Number = NaN;
         var offsetStr:String = null;
         var timeArr:Array = null;
         var hour:Number = NaN;
         var minutes:Number = NaN;
         var secondsArr:Array = null;
         var seconds:Number = NaN;
         var milliseconds:Number = NaN;
         var utc:Number = NaN;
         var offset:Number = NaN;
         var eStr:String = null;
         try
         {
            dateStr = str.substring(0,str.indexOf("T"));
            timeStr = str.substring(str.indexOf("T") + 1,str.length);
            dateArr = dateStr.split("-");
            year = Number(dateArr.shift());
            month = Number(dateArr.shift());
            date = Number(dateArr.shift());
            if(timeStr.indexOf("Z") != -1)
            {
               multiplier = 1;
               offsetHours = 0;
               offsetMinutes = 0;
               timeStr = timeStr.replace("Z","");
            }
            else if(timeStr.indexOf("+") != -1)
            {
               multiplier = 1;
               offsetStr = timeStr.substring(timeStr.indexOf("+") + 1,timeStr.length);
               offsetHours = Number(offsetStr.substring(0,offsetStr.indexOf(":")));
               offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1,offsetStr.length));
               timeStr = timeStr.substring(0,timeStr.indexOf("+"));
            }
            else
            {
               multiplier = -1;
               offsetStr = timeStr.substring(timeStr.indexOf("-") + 1,timeStr.length);
               offsetHours = Number(offsetStr.substring(0,offsetStr.indexOf(":")));
               offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1,offsetStr.length));
               timeStr = timeStr.substring(0,timeStr.indexOf("-"));
            }
            timeArr = timeStr.split(":");
            hour = Number(timeArr.shift());
            minutes = Number(timeArr.shift());
            secondsArr = timeArr.length > 0?String(timeArr.shift()).split("."):null;
            seconds = secondsArr != null && secondsArr.length > 0?Number(Number(secondsArr.shift())):Number(0);
            milliseconds = secondsArr != null && secondsArr.length > 0?Number(1000 * parseFloat("0." + secondsArr.shift())):Number(0);
            utc = Date.UTC(year,month - 1,date,hour,minutes,seconds,milliseconds);
            offset = (offsetHours * 3600000 + offsetMinutes * 60000) * multiplier;
            finalDate = new Date(utc - offset);
            if(finalDate.toString() == "Invalid Date")
            {
               throw new Error("This date does not conform to W3CDTF.");
            }
         }
         catch(e:Error)
         {
            eStr = "Unable to parse the string [" + str + "] into a date. ";
            eStr = eStr + ("The internal error was: " + e.toString());
            throw new Error(eStr);
         }
         return finalDate;
      }
      
      public static function toW3CDTF(d:Date, includeMilliseconds:Boolean = false) : String
      {
         var date:Number = d.getUTCDate();
         var month:Number = d.getUTCMonth();
         var hours:Number = d.getUTCHours();
         var minutes:Number = d.getUTCMinutes();
         var seconds:Number = d.getUTCSeconds();
         var milliseconds:Number = d.getUTCMilliseconds();
         var sb:String = new String();
         sb = sb + d.getUTCFullYear();
         sb = sb + "-";
         if(month + 1 < 10)
         {
            sb = sb + "0";
         }
         sb = sb + (month + 1);
         sb = sb + "-";
         if(date < 10)
         {
            sb = sb + "0";
         }
         sb = sb + date;
         sb = sb + "T";
         if(hours < 10)
         {
            sb = sb + "0";
         }
         sb = sb + hours;
         sb = sb + ":";
         if(minutes < 10)
         {
            sb = sb + "0";
         }
         sb = sb + minutes;
         sb = sb + ":";
         if(seconds < 10)
         {
            sb = sb + "0";
         }
         sb = sb + seconds;
         if(includeMilliseconds && milliseconds > 0)
         {
            sb = sb + ".";
            sb = sb + milliseconds;
         }
         sb = sb + "-00:00";
         return sb;
      }
      
      public static function makeMorning(d:Date) : Date
      {
         d = new Date(d.time);
         d.hours = 0;
         d.minutes = 0;
         d.seconds = 0;
         d.milliseconds = 0;
         return d;
      }
      
      public static function makeNight(d:Date) : Date
      {
         d = new Date(d.time);
         d.hours = 23;
         d.minutes = 59;
         d.seconds = 59;
         d.milliseconds = 999;
         return d;
      }
      
      public static function getUTCDate(d:Date) : Date
      {
         var nd:Date = new Date();
         var offset:Number = d.getTimezoneOffset() * 60 * 1000;
         nd.setTime(d.getTime() + offset);
         return nd;
      }
   }
}
