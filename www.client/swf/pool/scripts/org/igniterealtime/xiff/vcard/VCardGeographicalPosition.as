package org.igniterealtime.xiff.vcard
{
   public class VCardGeographicalPosition
   {
       
      
      private var _latitude:Number;
      
      private var _longitude:Number;
      
      public function VCardGeographicalPosition(latitude:Number = NaN, longitude:Number = NaN)
      {
         super();
         this.latitude = latitude;
         this.longitude = longitude;
      }
      
      public function get latitude() : Number
      {
         return this._latitude;
      }
      
      public function set latitude(value:Number) : void
      {
         this._latitude = value;
      }
      
      public function get longitude() : Number
      {
         return this._longitude;
      }
      
      public function set longitude(value:Number) : void
      {
         this._longitude = value;
      }
   }
}
