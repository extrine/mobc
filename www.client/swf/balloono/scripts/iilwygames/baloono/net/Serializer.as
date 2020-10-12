package iilwygames.baloono.net
{
   import com.formatter.Base64;
   import flash.utils.ByteArray;
   
   public class Serializer
   {
       
      
      public function Serializer()
      {
         super();
      }
      
      public static function export(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.position = 0;
         _loc2_.writeObject(param1);
         return Base64.encodeByteArray(_loc2_);
      }
      
      public static function consume(param1:Object) : *
      {
         var _loc2_:Object = Base64.decodeToByteArray(String(param1)).readObject();
         return _loc2_;
      }
   }
}
