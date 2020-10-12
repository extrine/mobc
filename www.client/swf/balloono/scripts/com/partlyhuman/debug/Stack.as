package com.partlyhuman.debug
{
   public class Stack
   {
       
      
      public function Stack()
      {
         super();
      }
      
      public static function getPartsFromStackTraceEntry(param1:String) : Object
      {
         return param1.match(/(?P<package>[\w\d\.]+)::(?P<classname>[\w\d\.\:]*?)(?P<isStatic>\$?)\/((?P<scope>[\w\d\.\:]+)::)?(?P<method>[\w\d]+\(\))(\[(?P<filename>[\w\d\\\/\.]+):(?P<line>\d+)\])?/);
      }
      
      public static function getSimplifiedStackTraceEntry(param1:String) : String
      {
         var _loc2_:Object = getPartsFromStackTraceEntry(param1);
         return !!_loc2_?_loc2_["package"] + "." + _loc2_["classname"] + "::" + _loc2_["method"]:param1;
      }
      
      public static function getStackEntries(param1:int = 0) : Array
      {
         var _loc2_:String = getRawStackTrace();
         var _loc3_:Array = _loc2_.split(/^\s*at\s+/m);
         _loc3_.splice(0,param1 + 1);
         return _loc3_;
      }
      
      public static function getRawStackTrace() : String
      {
         var stackTrace:String = null;
         try
         {
            throw new Error();
         }
         catch(error:Error)
         {
            stackTrace = error.getStackTrace();
         }
         return stackTrace;
      }
   }
}
