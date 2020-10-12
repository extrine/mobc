package com.partlyhuman.util
{
   import flash.utils.ByteArray;
   
   public class EmbedUtilities
   {
       
      
      public function EmbedUtilities()
      {
         super();
      }
      
      public static function classToXML(param1:Class) : XML
      {
         var _loc2_:ByteArray = ByteArray(new param1());
         var _loc3_:String = _loc2_.readUTFBytes(_loc2_.length);
         return XML(_loc3_);
      }
   }
}
