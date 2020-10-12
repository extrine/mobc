package iilwy.utils
{
   public class TimeSpan
   {
      
      public static const MILLISECOND:Number = 1;
      
      public static const SECOND:Number = MILLISECOND * 1000;
      
      public static const MINUTE:Number = SECOND * 60;
      
      public static const HOUR:Number = MINUTE * 60;
      
      public static const DAY:Number = HOUR * 24;
      
      public static const WEEK:Number = DAY * 7;
       
      
      private var _totalMilliseconds:Number;
      
      public function TimeSpan(milliseconds:Number)
      {
         super();
         this._totalMilliseconds = Math.floor(milliseconds);
      }
      
      public static function fromDates(start:Date, end:Date) : TimeSpan
      {
         return new TimeSpan(end.time - start.time);
      }
      
      public static function fromMilliseconds(milliseconds:Number) : TimeSpan
      {
         return new TimeSpan(milliseconds);
      }
      
      public static function fromSeconds(seconds:Number) : TimeSpan
      {
         return new TimeSpan(seconds * SECOND);
      }
      
      public static function fromMinutes(minutes:Number) : TimeSpan
      {
         return new TimeSpan(minutes * MINUTE);
      }
      
      public static function fromHours(hours:Number) : TimeSpan
      {
         return new TimeSpan(hours * HOUR);
      }
      
      public static function fromDays(days:Number) : TimeSpan
      {
         return new TimeSpan(days * DAY);
      }
      
      public function get days() : int
      {
         return int(this._totalMilliseconds / DAY);
      }
      
      public function get hours() : int
      {
         return int(this._totalMilliseconds / HOUR) % 24;
      }
      
      public function get minutes() : int
      {
         return int(this._totalMilliseconds / MINUTE) % 60;
      }
      
      public function get seconds() : int
      {
         return int(this._totalMilliseconds / SECOND) % 60;
      }
      
      public function get milliseconds() : int
      {
         return int(this._totalMilliseconds) % 1000;
      }
      
      public function get totalDays() : Number
      {
         return this._totalMilliseconds / DAY;
      }
      
      public function get totalHours() : Number
      {
         return this._totalMilliseconds / HOUR;
      }
      
      public function get totalMinutes() : Number
      {
         return this._totalMilliseconds / MINUTE;
      }
      
      public function get totalSeconds() : Number
      {
         return this._totalMilliseconds / SECOND;
      }
      
      public function get totalMilliseconds() : Number
      {
         return this._totalMilliseconds;
      }
      
      public function add(date:Date) : Date
      {
         var newDate:Date = new Date(date.time);
         newDate.milliseconds = newDate.milliseconds + this.totalMilliseconds;
         return newDate;
      }
   }
}
