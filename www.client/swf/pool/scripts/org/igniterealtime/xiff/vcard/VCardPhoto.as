package org.igniterealtime.xiff.vcard
{
   import com.hurlant.util.Base64;
   import flash.utils.ByteArray;
   
   public class VCardPhoto
   {
       
      
      private var _binaryValue:String;
      
      private var _bytes:ByteArray;
      
      private var _externalValue:String;
      
      private var _type:String;
      
      public function VCardPhoto(type:String = null, binaryValue:String = null, externalValue:String = null)
      {
         super();
         this.type = type;
         this.binaryValue = binaryValue;
         this.externalValue = externalValue;
      }
      
      public function get binaryValue() : String
      {
         return this._binaryValue;
      }
      
      public function set binaryValue(value:String) : void
      {
         this._binaryValue = value;
         if(value)
         {
            try
            {
               this._bytes = Base64.decodeToByteArrayB(value);
            }
            catch(error:Error)
            {
               throw new Error("VCardPhoto Error decoding binaryValue " + error.getStackTrace());
            }
         }
         else
         {
            this._bytes = null;
         }
      }
      
      public function get bytes() : ByteArray
      {
         return this._bytes;
      }
      
      public function set bytes(value:ByteArray) : void
      {
         this._bytes = value;
         if(value)
         {
            try
            {
               this._binaryValue = Base64.encodeByteArray(value);
            }
            catch(error:Error)
            {
               throw new Error("VCardPhoto Error encoding bytes " + error.getStackTrace());
            }
         }
         else
         {
            this._binaryValue = null;
         }
      }
      
      public function get externalValue() : String
      {
         return this._externalValue;
      }
      
      public function set externalValue(value:String) : void
      {
         this._externalValue = value;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         this._type = value;
      }
   }
}
