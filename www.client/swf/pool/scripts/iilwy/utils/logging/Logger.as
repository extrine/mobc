package iilwy.utils.logging
{
   public class Logger
   {
      
      public static const ALL:int = 2;
      
      public static const LOG:int = 2;
      
      public static const DEBUG:int = 3;
      
      public static const INFO:int = 4;
      
      public static const WARN:int = 5;
      
      public static const ERROR:int = 6;
      
      public static const FATAL:int = 7;
      
      public static const NONE:int = 99;
      
      public static var console;
      
      private static var instance:Logger;
      
      private static var instances:Object = {};
      
      private static var _defaultLevel:int = 1;
      
      private static var _forceLevel:int = 0;
       
      
      private var id:String;
      
      private var _level:int;
      
      public function Logger(id:String)
      {
         super();
         this.id = id;
         this._level = Logger._defaultLevel;
      }
      
      public static function set defaultLevel(value:int) : void
      {
         _defaultLevel = value;
      }
      
      public static function set forceLevel(value:int) : void
      {
         _forceLevel = value;
      }
      
      public static function getInstance() : Logger
      {
         if(!instance)
         {
            instance = new Logger("Logger");
         }
         return instance;
      }
      
      public static function getLogger(id:*) : Logger
      {
         var fid:String = id.toString();
         if(fid.indexOf("[object") >= 0)
         {
            fid = fid.match(/\[object ([\w]+)\]/)[1];
         }
         else
         {
            fid = id;
         }
         var logger:Logger = instances[fid];
         if(logger == null)
         {
            logger = new Logger(fid);
            instances[fid] = logger;
         }
         return logger;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(value:int) : void
      {
         this._level = value;
      }
      
      public function getLevel() : int
      {
         return this.level;
      }
      
      public function setLevel(value:int) : void
      {
         this.level = value;
      }
      
      public function destroy() : void
      {
         delete instances[this.id];
      }
      
      public function log(... args) : void
      {
         this.output(LOG,"LOG",args);
      }
      
      public function debug(... args) : void
      {
         this.output(DEBUG,"DEBUG",args);
      }
      
      public function info(... args) : void
      {
         this.output(INFO,"INFO",args);
      }
      
      public function warn(... args) : void
      {
         this.output(WARN,"WARN",args);
      }
      
      public function error(... args) : void
      {
         this.output(ERROR,"ERROR",args);
      }
      
      public function fatal(... args) : void
      {
         this.output(FATAL,"FATAL",args);
      }
      
      public function none(... args) : void
      {
         this.output(NONE,"NONE",args);
      }
      
      private function output(outputLevel:int, prepend:String, args:Array) : void
      {
         var str:String = null;
         var s:String = null;
         if(outputLevel < Logger._forceLevel)
         {
            return;
         }
         if(outputLevel < this._level)
         {
            return;
         }
         var toAdd:String = this.id + " [" + prepend + "]" + ":";
         do
         {
            toAdd = toAdd + " ";
         }
         while(toAdd.length < 20);
         
         args.unshift(toAdd);
         trace.apply(this,args);
         if(Logger.console != null)
         {
            str = "";
            for each(s in args)
            {
               str = str + (s + " ");
            }
            Logger.console.appendText(str);
         }
      }
   }
}
