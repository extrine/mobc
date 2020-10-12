package com.partlyhuman.debug
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   import iilwy.utils.logging.Logger;
   import iilwygames.baloono.BaloonoGame;
   
   public final class Console
   {
      
      public static var SEPARATOR:String = " ";
      
      public static var USE_FIREBUG:Boolean = false;
      
      public static var USE_LOGGER:Boolean = true;
       
      
      public function Console()
      {
         super();
      }
      
      public static function log(... rest) : void
      {
         sendToConsole("log",rest);
      }
      
      public static function fatal(... rest) : void
      {
         sendToConsole("fatal",rest);
      }
      
      public static function warn(... rest) : void
      {
         sendToConsole("warn",rest);
      }
      
      public static function info(... rest) : void
      {
         sendToConsole("info",rest);
      }
      
      public static function error(... rest) : void
      {
         sendToConsole("error",rest);
      }
      
      public static function dumpStackTrace() : void
      {
         try
         {
            log(Stack.getRawStackTrace());
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public static function dumpThisMethod() : void
      {
         try
         {
            log(Stack.getSimplifiedStackTraceEntry(Stack.getStackEntries(3)[0]));
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      private static function sendToConsole(param1:String, param2:Array) : void
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            if(USE_FIREBUG && ExternalInterface.available && Capabilities.playerType != "StandAlone" && Capabilities.playerType != "External")
            {
               ExternalInterface.call("console." + param1,param2.join(SEPARATOR));
            }
            else if(USE_LOGGER)
            {
               Logger.getLogger("Balloono").log("[" + param1.toUpperCase() + "] " + param2.join(SEPARATOR));
               trace("[" + param1.toUpperCase() + "] " + param2.join(SEPARATOR));
            }
            else
            {
               trace("[" + param1.toUpperCase() + "] " + param2.join(SEPARATOR));
            }
         }
      }
   }
}
