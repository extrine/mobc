package be.boulevart.as3.security
{
   public class RC4
   {
      
      protected static var sbox:Array = new Array(255);
      
      protected static var mykey:Array = new Array(255);
       
      
      public function RC4()
      {
         super();
      }
      
      public static function encrypt(src:String, key:String) : String
      {
         var mtxt:Array = strToChars(src);
         var mkey:Array = strToChars(key);
         var result:Array = calculate(mtxt,mkey);
         return charsToHex(result);
      }
      
      public static function decrypt(src:String, key:String) : String
      {
         var mtxt:Array = hexToChars(src);
         var mkey:Array = strToChars(key);
         var result:Array = calculate(mtxt,mkey);
         return charsToStr(result);
      }
      
      protected static function initialize(pwd:Array) : void
      {
         var tempSwap:Number = NaN;
         var a:Number = NaN;
         var b:Number = 0;
         var intLength:Number = pwd.length;
         for(a = 0; a <= 255; a++)
         {
            mykey[a] = pwd[a % intLength];
            sbox[a] = a;
         }
         for(a = 0; a <= 255; a++)
         {
            b = (b + sbox[a] + mykey[a]) % 256;
            tempSwap = sbox[a];
            sbox[a] = sbox[b];
            sbox[b] = tempSwap;
         }
      }
      
      protected static function calculate(plaintxt:Array, psw:Array) : Array
      {
         var k:Number = NaN;
         var temp:Number = NaN;
         var cipherby:Number = NaN;
         var idx:Number = NaN;
         initialize(psw);
         var i:Number = 0;
         var j:Number = 0;
         var cipher:Array = new Array();
         for(var a:Number = 0; a < plaintxt.length; a++)
         {
            i = (i + 1) % 256;
            j = (j + sbox[i]) % 256;
            temp = sbox[i];
            sbox[i] = sbox[j];
            sbox[j] = temp;
            idx = (sbox[i] + sbox[j]) % 256;
            k = sbox[idx];
            cipherby = plaintxt[a] ^ k;
            cipher.push(cipherby);
         }
         return cipher;
      }
      
      protected static function charsToHex(chars:Array) : String
      {
         var result:String = new String("");
         var hexes:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
         for(var i:Number = 0; i < chars.length; i++)
         {
            result = result + (hexes[chars[i] >> 4] + hexes[chars[i] & 15]);
         }
         return result;
      }
      
      protected static function hexToChars(hex:String) : Array
      {
         var codes:Array = new Array();
         for(var i:Number = hex.substr(0,2) == "0x"?Number(2):Number(0); i < hex.length; i = i + 2)
         {
            codes.push(parseInt(hex.substr(i,2),16));
         }
         return codes;
      }
      
      protected static function charsToStr(chars:Array) : String
      {
         var result:String = new String("");
         for(var i:Number = 0; i < chars.length; i++)
         {
            result = result + String.fromCharCode(chars[i]);
         }
         return result;
      }
      
      protected static function strToChars(str:String) : Array
      {
         var codes:Array = new Array();
         for(var i:Number = 0; i < str.length; i++)
         {
            codes.push(str.charCodeAt(i));
         }
         return codes;
      }
   }
}
