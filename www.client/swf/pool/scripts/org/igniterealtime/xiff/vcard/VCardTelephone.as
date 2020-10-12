package org.igniterealtime.xiff.vcard
{
   public class VCardTelephone
   {
       
      
      private var _cell:String;
      
      private var _fax:String;
      
      private var _msg:String;
      
      private var _pager:String;
      
      private var _video:String;
      
      private var _voice:String;
      
      public function VCardTelephone(voice:String = null, fax:String = null, pager:String = null, msg:String = null, cell:String = null, video:String = null)
      {
         super();
         this.voice = voice;
         this.fax = fax;
         this.pager = pager;
         this.msg = msg;
         this.cell = cell;
         this.video = video;
      }
      
      public function get cell() : String
      {
         return this._cell;
      }
      
      public function set cell(value:String) : void
      {
         this._cell = value;
      }
      
      public function get fax() : String
      {
         return this._fax;
      }
      
      public function set fax(value:String) : void
      {
         this._fax = value;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function set msg(value:String) : void
      {
         this._msg = value;
      }
      
      public function get pager() : String
      {
         return this._pager;
      }
      
      public function set pager(value:String) : void
      {
         this._pager = value;
      }
      
      public function get video() : String
      {
         return this._video;
      }
      
      public function set video(value:String) : void
      {
         this._video = value;
      }
      
      public function get voice() : String
      {
         return this._voice;
      }
      
      public function set voice(value:String) : void
      {
         this._voice = value;
      }
   }
}
