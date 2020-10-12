package org.igniterealtime.xiff.vcard
{
   public class VCardOrganization
   {
       
      
      private var _name:String;
      
      private var _unit:String;
      
      public function VCardOrganization(name:String = null, unit:String = null)
      {
         super();
         this.name = name;
         this.unit = unit;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get unit() : String
      {
         return this._unit;
      }
      
      public function set unit(value:String) : void
      {
         this._unit = value;
      }
   }
}
