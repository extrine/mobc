package com.google.analytics.core
{
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.utils.Version;
   import com.google.analytics.v4.Configuration;
   
   public class BrowserInfo
   {
       
      
      private var _config:Configuration;
      
      private var _info:Environment;
      
      public function BrowserInfo(config:Configuration, info:Environment)
      {
         super();
         this._config = config;
         this._info = info;
      }
      
      public function get utmcs() : String
      {
         return this._info.languageEncoding;
      }
      
      public function get utmsr() : String
      {
         return this._info.screenWidth + "x" + this._info.screenHeight;
      }
      
      public function get utmsc() : String
      {
         return this._info.screenColorDepth + "-bit";
      }
      
      public function get utmul() : String
      {
         return this._info.language.toLowerCase();
      }
      
      public function get utmje() : String
      {
         return "0";
      }
      
      public function get utmfl() : String
      {
         var v:Version = null;
         if(this._config.detectFlash)
         {
            v = this._info.flashVersion;
            return v.major + "." + v.minor + " r" + v.build;
         }
         return "-";
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         variables.utmcs = this.utmcs;
         variables.utmsr = this.utmsr;
         variables.utmsc = this.utmsc;
         variables.utmul = this.utmul;
         variables.utmje = this.utmje;
         variables.utmfl = this.utmfl;
         return variables;
      }
      
      public function toURLString() : String
      {
         var v:Variables = this.toVariables();
         return v.toString();
      }
   }
}
