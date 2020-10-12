package com.google.analytics.core
{
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.v4.Configuration;
   
   public class DocumentInfo
   {
       
      
      private var _config:Configuration;
      
      private var _info:Environment;
      
      private var _adSense:AdSenseGlobals;
      
      private var _pageURL:String;
      
      private var _utmr:String;
      
      public function DocumentInfo(config:Configuration, info:Environment, formatedReferrer:String, pageURL:String = null, adSense:AdSenseGlobals = null)
      {
         super();
         this._config = config;
         this._info = info;
         this._utmr = formatedReferrer;
         this._pageURL = pageURL;
         this._adSense = adSense;
      }
      
      private function _generateHitId() : Number
      {
         var hid:Number = NaN;
         if(this._adSense.hid && this._adSense.hid != "")
         {
            hid = Number(this._adSense.hid);
         }
         else
         {
            hid = Math.round(Math.random() * 2147483647);
            this._adSense.hid = String(hid);
         }
         return hid;
      }
      
      private function _renderPageURL(pageURL:String = "") : String
      {
         var pathname:String = this._info.locationPath;
         var search:String = this._info.locationSearch;
         if(!pageURL || pageURL == "")
         {
            pageURL = pathname + unescape(search);
            if(pageURL == "")
            {
               pageURL = "/";
            }
         }
         return pageURL;
      }
      
      public function get utmdt() : String
      {
         return this._info.documentTitle;
      }
      
      public function get utmhid() : String
      {
         return String(this._generateHitId());
      }
      
      public function get utmr() : String
      {
         if(!this._utmr)
         {
            return "-";
         }
         return this._utmr;
      }
      
      public function get utmp() : String
      {
         return this._renderPageURL(this._pageURL);
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         if(this._config.detectTitle && this.utmdt != "")
         {
            variables.utmdt = this.utmdt;
         }
         variables.utmhid = this.utmhid;
         variables.utmr = this.utmr;
         variables.utmp = this.utmp;
         return variables;
      }
      
      public function toURLString() : String
      {
         var v:Variables = this.toVariables();
         return v.toString();
      }
   }
}
