package iilwy.utils
{
   import be.boulevart.as3.security.RC4;
   
   public class UrlCodeEncryption
   {
       
      
      public function UrlCodeEncryption()
      {
         super();
      }
      
      public static function encrypt(str:String) : String
      {
         return encodeURI(RC4.encrypt(str,"you aint got no defences"));
      }
      
      public static function decrypt(str:String) : String
      {
         return RC4.decrypt(decodeURI(str),"you aint got no defences");
      }
   }
}
