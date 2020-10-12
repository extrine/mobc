package com.partlyhuman.util
{
   import com.partlyhuman.debug.Console;
   import iilwygames.baloono.BaloonoGame;
   
   public class Assert
   {
       
      
      public function Assert()
      {
         super();
      }
      
      public static function fail(param1:String = null) : void
      {
         assert(false,param1);
      }
      
      public static function assert(param1:Boolean, param2:String = null) : void
      {
         if(BaloonoGame.instance.DEBUG_ERRORS)
         {
            if(!param1)
            {
               throw new AssertionError(param2);
            }
         }
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            if(!param1)
            {
               Console.fatal("ASSERTION FAILED",!!param2?": " + param2:"");
               Console.dumpStackTrace();
            }
         }
      }
   }
}
