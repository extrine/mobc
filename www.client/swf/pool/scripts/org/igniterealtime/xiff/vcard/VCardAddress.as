package org.igniterealtime.xiff.vcard
{
   public class VCardAddress
   {
       
      
      private var _country:String;
      
      private var _extendedAddress:String;
      
      private var _locality:String;
      
      private var _poBox:String;
      
      private var _postalCode:String;
      
      private var _region:String;
      
      private var _street:String;
      
      public function VCardAddress(street:String = null, locality:String = null, region:String = null, postalCode:String = null, country:String = null, extendedAddress:String = null, poBox:String = null)
      {
         super();
         this.street = street;
         this.locality = locality;
         this.region = region;
         this.postalCode = postalCode;
         this.country = country;
         this.extendedAddress = extendedAddress;
         this.poBox = poBox;
      }
      
      public function get country() : String
      {
         return this._country;
      }
      
      public function set country(value:String) : void
      {
         this._country = value;
      }
      
      public function get extendedAddress() : String
      {
         return this._extendedAddress;
      }
      
      public function set extendedAddress(value:String) : void
      {
         this._extendedAddress = value;
      }
      
      public function get locality() : String
      {
         return this._locality;
      }
      
      public function set locality(value:String) : void
      {
         this._locality = value;
      }
      
      public function get poBox() : String
      {
         return this._poBox;
      }
      
      public function set poBox(value:String) : void
      {
         this._poBox = value;
      }
      
      public function get postalCode() : String
      {
         return this._postalCode;
      }
      
      public function set postalCode(value:String) : void
      {
         this._postalCode = value;
      }
      
      public function get region() : String
      {
         return this._region;
      }
      
      public function set region(value:String) : void
      {
         this._region = value;
      }
      
      public function get street() : String
      {
         return this._street;
      }
      
      public function set street(value:String) : void
      {
         this._street = value;
      }
   }
}
