package iilwygames.pool.util
{
   import flash.geom.Vector3D;
   
   public class MathUtil
   {
      
      public static const MATH_TWOPI:Number = Math.PI * 2;
      
      public static const MATH_HALFPI:Number = Math.PI * 0.5;
      
      public static const MATH_QUARTERPI:Number = Math.PI * 0.25;
       
      
      public function MathUtil()
      {
         super();
      }
      
      public static function distanceBetweenPointsSquared(p1:Vector3D, p2:Vector3D) : Number
      {
         var vectorbetween:Vector3D = p2.subtract(p1);
         var magnitude:Number = vectorbetween.lengthSquared;
         return magnitude;
      }
      
      public static function radiansToDegrees(radians:Number) : Number
      {
         return radians * 180 / Math.PI;
      }
      
      public static function bitCount(n:uint) : int
      {
         var count:int = 0;
         while(n)
         {
            count++;
            n = n & n - 1;
         }
         return count;
      }
      
      public static function correctFloatingPointError(number:Number, precision:int = 5) : Number
      {
         var correction:Number = Math.pow(10,precision);
         return Math.round(correction * number) / correction;
      }
   }
}
