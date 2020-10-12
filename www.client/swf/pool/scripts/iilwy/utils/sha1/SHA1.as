package iilwy.utils.sha1
{
   public class SHA1
   {
      
      public static const HEX_FORMAT_LOWERCASE:uint = 0;
      
      public static const HEX_FORMAT_UPPERCASE:uint = 1;
      
      public static const BASE64_PAD_CHARACTER_DEFAULT_COMPLIANCE:String = "";
      
      public static const BASE64_PAD_CHARACTER_RFC_COMPLIANCE:String = "=";
      
      public static const BITS_PER_CHAR_ASCII:uint = 8;
      
      public static const BITS_PER_CHAR_UNICODE:uint = 8;
      
      public static var hexcase:uint = 0;
      
      public static var b64pad:String = "";
      
      public static var chrsz:uint = 8;
       
      
      public function SHA1()
      {
         super();
      }
      
      public static function encrypt(string:String) : String
      {
         return hex_sha1(string);
      }
      
      public static function hex_sha1(string:String) : String
      {
         return binb2hex(core_sha1(str2binb(string),string.length * chrsz));
      }
      
      public static function b64_sha1(string:String) : String
      {
         return binb2b64(core_sha1(str2binb(string),string.length * chrsz));
      }
      
      public static function str_sha1(string:String) : String
      {
         return binb2str(core_sha1(str2binb(string),string.length * chrsz));
      }
      
      public static function hex_hmac_sha1(key:String, data:String) : String
      {
         return binb2hex(core_hmac_sha1(key,data));
      }
      
      public static function b64_hmac_sha1(key:String, data:String) : String
      {
         return binb2b64(core_hmac_sha1(key,data));
      }
      
      public static function str_hmac_sha1(key:String, data:String) : String
      {
         return binb2str(core_hmac_sha1(key,data));
      }
      
      public static function sha1_vm_test() : Boolean
      {
         return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
      }
      
      public static function core_sha1(x:Array, len:Number) : Array
      {
         var olda:Number = NaN;
         var oldb:Number = NaN;
         var oldc:Number = NaN;
         var oldd:Number = NaN;
         var olde:Number = NaN;
         var j:Number = NaN;
         var t:Number = NaN;
         x[len >> 5] = x[len >> 5] | 128 << 24 - len % 32;
         x[(len + 64 >> 9 << 4) + 15] = len;
         var w:Array = new Array(80);
         var a:Number = 1732584193;
         var b:Number = -271733879;
         var c:Number = -1732584194;
         var d:Number = 271733878;
         var e:Number = -1009589776;
         for(var i:Number = 0; i < x.length; i = i + 16)
         {
            olda = a;
            oldb = b;
            oldc = c;
            oldd = d;
            olde = e;
            for(j = 0; j < 80; j++)
            {
               if(j < 16)
               {
                  w[j] = x[i + j];
               }
               else
               {
                  w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16],1);
               }
               t = safe_add(safe_add(rol(a,5),sha1_ft(j,b,c,d)),safe_add(safe_add(e,w[j]),sha1_kt(j)));
               e = d;
               d = c;
               c = rol(b,30);
               b = a;
               a = t;
            }
            a = safe_add(a,olda);
            b = safe_add(b,oldb);
            c = safe_add(c,oldc);
            d = safe_add(d,oldd);
            e = safe_add(e,olde);
         }
         return [a,b,c,d,e];
      }
      
      public static function sha1_ft(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t < 20)
         {
            return b & c | ~b & d;
         }
         if(t < 40)
         {
            return b ^ c ^ d;
         }
         if(t < 60)
         {
            return b & c | b & d | c & d;
         }
         return b ^ c ^ d;
      }
      
      public static function sha1_kt(t:Number) : Number
      {
         return t < 20?Number(1518500249):t < 40?Number(1859775393):t < 60?Number(-1894007588):Number(-899497514);
      }
      
      public static function core_hmac_sha1(key:String, data:String) : Array
      {
         var bkey:Array = str2binb(key);
         if(bkey.length > 16)
         {
            bkey = core_sha1(bkey,key.length * chrsz);
         }
         var ipad:Array = new Array(16);
         var opad:Array = new Array(16);
         for(var i:Number = 0; i < 16; i++)
         {
            ipad[i] = bkey[i] ^ 909522486;
            opad[i] = bkey[i] ^ 1549556828;
         }
         var hash:Array = core_sha1(ipad.concat(str2binb(data)),512 + data.length * chrsz);
         return core_sha1(opad.concat(hash),512 + 160);
      }
      
      public static function safe_add(x:Number, y:Number) : Number
      {
         var lsw:Number = (x & 65535) + (y & 65535);
         var msw:Number = (x >> 16) + (y >> 16) + (lsw >> 16);
         return msw << 16 | lsw & 65535;
      }
      
      public static function rol(num:Number, cnt:Number) : Number
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      public static function str2binb(str:String) : Array
      {
         var bin:Array = new Array();
         var mask:Number = (1 << chrsz) - 1;
         for(var i:Number = 0; i < str.length * chrsz; bin[i >> 5] = bin[i >> 5] | (str.charCodeAt(i / chrsz) & mask) << 32 - chrsz - i % 32,i = i + chrsz)
         {
         }
         return bin;
      }
      
      public static function binb2str(bin:Array) : String
      {
         var str:String = "";
         var mask:Number = (1 << chrsz) - 1;
         for(var i:Number = 0; i < bin.length * 32; str = str + String.fromCharCode(bin[i >> 5] >>> 32 - chrsz - i % 32 & mask),i = i + chrsz)
         {
         }
         return str;
      }
      
      public static function binb2hex(binarray:Array) : String
      {
         var hex_tab:String = Boolean(hexcase)?"0123456789ABCDEF":"0123456789abcdef";
         var str:String = "";
         for(var i:Number = 0; i < binarray.length * 4; i++)
         {
            str = str + (hex_tab.charAt(binarray[i >> 2] >> (3 - i % 4) * 8 + 4 & 15) + hex_tab.charAt(binarray[i >> 2] >> (3 - i % 4) * 8 & 15));
         }
         return str;
      }
      
      public static function binb2b64(binarray:Array) : String
      {
         var triplet:Number = NaN;
         var j:Number = NaN;
         var tab:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
         var str:String = "";
         for(var i:Number = 0; i < binarray.length * 4; i = i + 3)
         {
            triplet = (binarray[i >> 2] >> 8 * (3 - i % 4) & 255) << 16 | (binarray[i + 1 >> 2] >> 8 * (3 - (i + 1) % 4) & 255) << 8 | binarray[i + 2 >> 2] >> 8 * (3 - (i + 2) % 4) & 255;
            for(j = 0; j < 4; j++)
            {
               if(i * 8 + j * 6 > binarray.length * 32)
               {
                  str = str + b64pad;
               }
               else
               {
                  str = str + tab.charAt(triplet >> 6 * (3 - j) & 63);
               }
            }
         }
         return str;
      }
   }
}
