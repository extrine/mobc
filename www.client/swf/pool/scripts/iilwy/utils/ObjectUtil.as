package iilwy.utils
{
   import flash.utils.ByteArray;
   
   public class ObjectUtil
   {
       
      
      public function ObjectUtil()
      {
         super();
      }
      
      public static function cloneObject(o:Object) : Object
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeObject(o);
         bytes.position = 0;
         return bytes.readObject();
      }
   }
}
