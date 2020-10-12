package org.igniterealtime.xiff.util
{
   public class SHA1
   {
      
      private static const HEX_STR:String = "0123456789abcdef";
       
      
      public function SHA1()
      {
         super();
      }
      
      public static function calcSHA1(str:String) : String
      {
         var olda:Number = NaN;
         var oldb:Number = NaN;
         var oldc:Number = NaN;
         var oldd:Number = NaN;
         var olde:Number = NaN;
         var j:Number = NaN;
         var t:Number = NaN;
         var x:Array = SHA1.str2blks(str);
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
                  w[j] = SHA1.rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16],1);
               }
               t = SHA1.safe_add(SHA1.safe_add(SHA1.rol(a,5),SHA1.ft(j,b,c,d)),SHA1.safe_add(SHA1.safe_add(e,w[j]),SHA1.kt(j)));
               e = d;
               d = c;
               c = SHA1.rol(b,30);
               b = a;
               a = t;
            }
            a = SHA1.safe_add(a,olda);
            b = SHA1.safe_add(b,oldb);
            c = SHA1.safe_add(c,oldc);
            d = SHA1.safe_add(d,oldd);
            e = SHA1.safe_add(e,olde);
         }
         return SHA1.hex(a) + SHA1.hex(b) + SHA1.hex(c) + SHA1.hex(d) + SHA1.hex(e);
      }
      
      private static function hex(num:Number) : String
      {
         var str:String = "";
         for(var j:Number = 7; j >= 0; j--)
         {
            str = str + HEX_STR.charAt(num >> j * 4 & 15);
         }
         return str;
      }
      
      private static function str2blks(str:String) : Array
      {
         var nblk:Number = (str.length + 8 >> 6) + 1;
         var blks:Array = new Array(nblk * 16);
         for(var i:Number = 0; i < nblk * 16; i++)
         {
            blks[i] = 0;
         }
         for(var j:Number = 0; j < str.length; j++)
         {
            blks[j >> 2] = blks[j >> 2] | str.charCodeAt(j) << 24 - j % 4 * 8;
         }
         blks[j >> 2] = blks[j >> 2] | 128 << 24 - j % 4 * 8;
         blks[nblk * 16 - 1] = str.length * 8;
         return blks;
      }
      
      private static function safe_add(x:Number, y:Number) : Number
      {
         var lsw:Number = (x & 65535) + (y & 65535);
         var msw:Number = (x >> 16) + (y >> 16) + (lsw >> 16);
         return msw << 16 | lsw & 65535;
      }
      
      private static function rol(num:Number, cnt:Number) : Number
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      private static function ft(t:Number, b:Number, c:Number, d:Number) : Number
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
      
      private static function kt(t:Number) : Number
      {
         return t < 20?Number(1518500249):t < 40?Number(1859775393):t < 60?Number(-1894007588):Number(-899497514);
      }
   }
}
