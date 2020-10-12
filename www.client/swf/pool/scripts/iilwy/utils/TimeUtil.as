package iilwy.utils
{
   public class TimeUtil
   {
      
      public static const MILLISECOND:Number = 1;
      
      public static const SECOND:Number = MILLISECOND * 1000;
      
      public static const MINUTE:Number = SECOND * 60;
      
      public static const HOUR:Number = MINUTE * 60;
      
      public static const DAY:Number = HOUR * 24;
      
      public static const WEEK:Number = DAY * 7;
       
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function timeLeftInWords(endTime:Date) : String
      {
         var timeNow:Date = new Date();
         var timeDiff:Number = Math.abs(endTime.getTime() - timeNow.getTime());
         var distanceInMinutes:int = timeDiff / MINUTE;
         var distanceInSeconds:int = timeDiff / (MINUTE / 60);
         var timeLeft:String = "";
         if(0 <= distanceInMinutes && distanceInMinutes <= 1)
         {
            if(0 <= distanceInSeconds && distanceInSeconds <= 5)
            {
               timeLeft = "less than 5 seconds";
            }
            else if(6 <= distanceInSeconds && distanceInSeconds <= 10)
            {
               timeLeft = "less than 10 seconds";
            }
            else if(11 <= distanceInSeconds && distanceInSeconds <= 20)
            {
               timeLeft = "less than 20 seconds";
            }
            else if(21 <= distanceInSeconds && distanceInSeconds <= 40)
            {
               timeLeft = "half a minute";
            }
            else if(41 <= distanceInSeconds && distanceInSeconds <= 59)
            {
               timeLeft = "less than 1 minute";
            }
            else
            {
               timeLeft = "1 minute";
            }
         }
         else if(2 <= distanceInMinutes && distanceInMinutes < 60)
         {
            timeLeft = distanceInMinutes + " minutes";
         }
         else if(distanceInMinutes == 60)
         {
            timeLeft = "1 hour";
         }
         else if(60 < distanceInMinutes && distanceInMinutes <= 1440)
         {
            timeLeft = Math.round(distanceInMinutes / 60) == 1?"1 hour":Math.round(distanceInMinutes / 60).toString() + " hours";
         }
         else if(1440 < distanceInMinutes && distanceInMinutes <= 2880)
         {
            timeLeft = "1 day";
         }
         else
         {
            timeLeft = Math.round(distanceInMinutes / 1440) + " days";
         }
         return timeLeft;
      }
      
      public static function timeAgoInWords(date:Date) : void
      {
      }
      
      public static function formatTime(date:Date, includeLocaleDateString:Boolean = true) : String
      {
         var formattedTime:String = !!includeLocaleDateString?date.toLocaleDateString() + " at ":"";
         formattedTime = formattedTime + (DateUtil.getTimeString(date) + " " + DateUtil.getAMPM(date));
         return formattedTime;
      }
      
      public static function getPercentElapsed(now:Date, start:Date, end:Date) : Number
      {
         var duration:Number = end.time - start.time;
         var elapsed:Number = now.time - start.time;
         if(end.time < now.time)
         {
            return 100;
         }
         return elapsed / duration * 100;
      }
      
      public static function getCountdownString(now:Date, end:Date) : String
      {
         var nowSeconds:int = now.getTime() / SECOND;
         var endSeconds:int = end.getTime() / SECOND;
         return returnCountString(endSeconds - nowSeconds);
      }
      
      public static function returnCountString(diff:int) : String
      {
         var oneMinute:int = 60;
         var oneDay:int = oneMinute * 60 * 24;
         var days:int = diff / oneDay;
         var hours:int = Math.floor(diff / 3600) % 24;
         var minutes:int = Math.floor(diff / oneMinute) % 60;
         var seconds:int = Math.floor(diff) % 60;
         var day1:int = Math.floor(days / 100);
         var day2:int = Math.floor(days % 100 / 10);
         var day3:int = days % 10;
         var hour1:int = Math.floor(hours / 10);
         var hour2:int = hours % 10;
         var min1:int = Math.floor(minutes / 10);
         var min2:int = minutes % 10;
         var sec1:int = Math.floor(seconds / 10);
         var sec2:int = seconds % 10;
         var cText:String = "";
         if(day1 > 0)
         {
            cText = cText + day1.toString();
         }
         if(day2 > 0)
         {
            cText = cText + day2.toString();
         }
         if(day3 > 0)
         {
            if(day3 == 1 && day2 == 0)
            {
               cText = cText + (day3.toString() + " day and ");
            }
            else
            {
               cText = cText + (day3.toString() + " days and ");
            }
         }
         if(hour1 > 0)
         {
            cText = cText + hour1.toString();
         }
         cText = cText + (hour2.toString() + ":" + min1.toString() + min2.toString() + ":" + sec1.toString() + sec2.toString());
         return cText;
      }
      
      public static function gameExpireTimeFormat(date:Date) : String
      {
         var stDay:String = null;
         var amPM:String = null;
         var day:Number = date.getDay();
         var hours:Number = date.getHours();
         var minutes:Number = date.getMinutes();
         var mStr:String = "";
         if(minutes < 10)
         {
            mStr = "0";
         }
         if(hours > 12)
         {
            amPM = "PM";
            hours = hours - 12;
         }
         else
         {
            if(hours == 0)
            {
               hours = 12;
            }
            amPM = "AM";
         }
         switch(day)
         {
            case 0:
               stDay = "Sun";
               break;
            case 1:
               stDay = "Mon";
               break;
            case 2:
               stDay = "Tue";
               break;
            case 3:
               stDay = "Wed";
               break;
            case 4:
               stDay = "Thur";
               break;
            case 5:
               stDay = "Fri";
               break;
            case 6:
               stDay = "Sat";
         }
         return stDay + " at " + hours + ":" + mStr + "" + minutes + " " + amPM;
      }
      
      public static function getLocalServerDateTimeOffset(serverDateTime:Date) : Number
      {
         serverDateTime = serverDateTime;
         var _loc2_:Date = new Date();
         var _loc3_:Number = serverDateTime.getTime() - _loc2_.getTime();
         var _loc4_:int = _loc3_ / MINUTE;
         return _loc4_;
      }
      
      public static function offsetTime(offset:Number, date:Date) : Date
      {
         var newDate:Date = new Date((date.getTime() / MINUTE + offset) * MINUTE);
         return newDate;
      }
   }
}
