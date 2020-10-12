package org.igniterealtime.xiff.vcard
{
   public class VCardName
   {
       
      
      private var _family:String;
      
      private var _given:String;
      
      private var _middle:String;
      
      private var _prefix:String;
      
      private var _suffix:String;
      
      public function VCardName(given:String = null, middle:String = null, family:String = null, prefix:String = null, suffix:String = null)
      {
         super();
         this.given = given;
         this.middle = middle;
         this.family = family;
         this.prefix = prefix;
         this.suffix = suffix;
      }
      
      public function get family() : String
      {
         return this._family;
      }
      
      public function set family(value:String) : void
      {
         this._family = value;
      }
      
      public function get given() : String
      {
         return this._given;
      }
      
      public function set given(value:String) : void
      {
         this._given = value;
      }
      
      public function get middle() : String
      {
         return this._middle;
      }
      
      public function set middle(value:String) : void
      {
         this._middle = value;
      }
      
      public function get prefix() : String
      {
         return this._prefix;
      }
      
      public function set prefix(value:String) : void
      {
         this._prefix = value;
      }
      
      public function get suffix() : String
      {
         return this._suffix;
      }
      
      public function set suffix(value:String) : void
      {
         this._suffix = value;
      }
   }
}
