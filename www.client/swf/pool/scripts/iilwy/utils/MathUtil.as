package iilwy.utils
{
   public class MathUtil
   {
       
      
      public function MathUtil()
      {
         super();
      }
      
      public static function clamp(min:Number, max:Number, value:Number) : Number
      {
         return Math.max(min,Math.min(max,value));
      }
      
      public static function limit(value:Number, min:Number, max:Number) : Number
      {
         return Math.min(Math.max(min,value),max);
      }
      
      public static function norm(value:Number, min:Number, max:Number) : Number
      {
         return (value - min) / (max - min);
      }
      
      public static function lerp(normValue:Number, min:Number, max:Number) : Number
      {
         return min + (max - min) * normValue;
      }
      
      public static function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number) : Number
      {
         return lerp(norm(value,min1,max1),min2,max2);
      }
      
      public static function roundDownToEvenNumber(n:Number) : Number
      {
         return n - n % 2;
      }
      
      public static function roundToPrecision(n:Number, precision:int = 0) : Number
      {
         var decimalPlaces:Number = Math.pow(10,precision);
         return Math.round(decimalPlaces * n) / decimalPlaces;
      }
      
      public static function randRange(min:Number, max:Number) : Number
      {
         return Math.floor(Math.random() * (max - min + 1)) + min;
      }
      
      public static function wrap(index:int, total:int) : int
      {
         var new_val:int = 0;
         var rem:int = 0;
         if(total > 0)
         {
            if(index > total - 1)
            {
               new_val = index % total;
            }
            else if(index < 0)
            {
               rem = Math.abs(index) % total;
               if(rem == total || total == 1)
               {
                  new_val = total - Math.abs(index);
               }
               else
               {
                  new_val = total - rem;
               }
            }
            else
            {
               new_val = index;
            }
         }
         else
         {
            new_val = 0;
         }
         return new_val;
      }
   }
}
