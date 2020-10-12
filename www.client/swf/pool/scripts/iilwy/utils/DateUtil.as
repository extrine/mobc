package iilwy.utils
{
   public class DateUtil
   {
      
      public static const MILLISECOND:Number = 1;
      
      public static const SECOND:Number = MILLISECOND * 1000;
      
      public static const MINUTE:Number = SECOND * 60;
      
      public static const HOUR:Number = MINUTE * 60;
      
      public static const DAY:Number = HOUR * 24;
      
      public static const WEEK:Number = DAY * 7;
       
      
      public function DateUtil()
      {
         super();
      }
      
      public static function getDateAndTimeString(date:Date) : String
      {
         return getDateString(date) + " at " + getTimeString(date) + DateUtil.getAMPM(date).toLowerCase();
      }
      
      public static function getDateString(date:Date, showHoursOrMinutes:Boolean = false, hourThreshold:int = 12) : String
      {
         var dateString:String = null;
         var currentYear:Boolean = false;
         var now:Date = new Date();
         var span:TimeSpan = TimeSpan.fromDates(now,date);
         var recent:Boolean = span.totalMilliseconds < 0 && (span.days >= -4 && span.days < -1);
         var yesterday:Boolean = span.totalMilliseconds < 0 && (span.days == 0 || span.days == -1) && date.date != now.date;
         var today:Boolean = span.days == 0 && date.date == now.date;
         var tomorrow:Boolean = span.totalMilliseconds > 0 && span.days == 0 && date.date != now.date;
         var soon:Boolean = span.totalMilliseconds > 0 && (span.days < 4 && span.days >= 1);
         var hourDifference:Number = Math.abs(span.totalHours);
         var minuteDifference:Number = Math.abs(span.totalMinutes);
         if(showHoursOrMinutes && hourDifference < hourThreshold)
         {
            dateString = hourDifference > 0?hourDifference + " " + TextUtil.makePlural("hour",hourDifference):minuteDifference + " " + TextUtil.makePlural("minute",minuteDifference);
         }
         else if(tomorrow)
         {
            dateString = "Tomorrow";
         }
         else if(today)
         {
            dateString = "Today";
         }
         else if(yesterday)
         {
            dateString = "Yesterday";
         }
         else if(recent || soon)
         {
            dateString = DateUtil.getFullDayName(date);
         }
         else
         {
            currentYear = now.fullYear == date.fullYear;
            dateString = DateUtil.getFullMonthName(date);
            dateString = dateString + " ";
            dateString = dateString + date.date;
            if(!currentYear)
            {
               dateString = dateString + (", " + date.fullYear.toString());
            }
         }
         return dateString;
      }
      
      public static function getTimeString(date:Date) : String
      {
         var timeString:String = null;
         timeString = DateUtil.getShortHour(date).toString();
         timeString = timeString + ":";
         timeString = timeString + (date.minutes < 10?"0" + date.minutes.toString():date.minutes.toString());
         return timeString;
      }
      
      public static function getMySQLDate(date:Date) : String
      {
         var s:String = date.fullYear + "-";
         if(date.month < 10)
         {
            s = s + ("0" + (date.month + 1) + "-");
         }
         else
         {
            s = s + (date.month + 1 + "-");
         }
         if(date.date < 10)
         {
            s = s + ("0" + date.date);
         }
         else
         {
            s = s + date.date;
         }
         s = s + " ";
         if(date.hours < 10)
         {
            s = s + ("0" + date.hours + ":");
         }
         else
         {
            s = s + (date.hours + ":");
         }
         if(date.minutes < 10)
         {
            s = s + ("0" + date.minutes + ":");
         }
         else
         {
            s = s + (date.minutes + ":");
         }
         if(date.seconds < 10)
         {
            s = s + ("0" + date.seconds);
         }
         else
         {
            s = s + date.seconds;
         }
         return s;
      }
   }
}
