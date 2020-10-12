package iilwygames.baloono.gameplay
{
   public class Directions
   {
      
      public static const COMBINED:uint = LEFT | RIGHT | UP | DOWN;
      
      public static const LEFT:uint = 1;
      
      public static const DOWN:uint = 8;
      
      public static const UP:uint = 4;
      
      public static const ALL_ARRAY:Array = [LEFT,RIGHT,UP,DOWN];
      
      public static const RIGHT:uint = 2;
       
      
      public function Directions()
      {
         super();
      }
      
      public static function toDx(param1:uint) : int
      {
         return param1 == LEFT?-1:param1 == RIGHT?1:0;
      }
      
      public static function toDy(param1:uint) : int
      {
         return param1 == UP?-1:param1 == DOWN?1:0;
      }
   }
}
