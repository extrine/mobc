package com.google.analytics.utils
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.external.HTMLDOM;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   
   public class Environment
   {
       
      
      private var _debug:DebugConfiguration;
      
      private var _dom:HTMLDOM;
      
      private var _protocol:Protocols;
      
      private var _appName:String;
      
      private var _appVersion:Version;
      
      private var _userAgent:UserAgent;
      
      private var _url:String;
      
      public function Environment(url:String = "", app:String = "", version:String = "", debug:DebugConfiguration = null, dom:HTMLDOM = null)
      {
         var v:Version = null;
         super();
         if(app == "")
         {
            if(this.isAIR())
            {
               app = "AIR";
            }
            else
            {
               app = "Flash";
            }
         }
         if(version == "")
         {
            v = this.flashVersion;
         }
         else
         {
            v = Version.fromString(version);
         }
         this._url = url;
         this._appName = app;
         this._appVersion = v;
         this._debug = debug;
         this._dom = dom;
      }
      
      private function _findProtocol() : void
      {
         var URL:String = null;
         var test:String = null;
         var p:Protocols = Protocols.none;
         if(this._url != "")
         {
            URL = this._url.toLowerCase();
            test = URL.substr(0,5);
            switch(test)
            {
               case "file:":
                  p = Protocols.file;
                  break;
               case "http:":
                  p = Protocols.HTTP;
                  break;
               case "https":
                  if(URL.charAt(5) == ":")
                  {
                     p = Protocols.HTTPS;
                  }
                  break;
               default:
                  this._protocol = Protocols.none;
            }
         }
         var _proto:String = this._dom.protocol;
         var proto:String = (p.toString() + ":").toLowerCase();
         if(_proto && _proto != proto && this._debug)
         {
            this._debug.warning("Protocol mismatch: SWF=" + proto + ", DOM=" + _proto);
         }
         this._protocol = p;
      }
      
      public function get appName() : String
      {
         return this._appName;
      }
      
      public function set appName(value:String) : void
      {
         this._appName = value;
         this.userAgent.applicationProduct = value;
      }
      
      public function get appVersion() : Version
      {
         return this._appVersion;
      }
      
      public function set appVersion(value:Version) : void
      {
         this._appVersion = value;
         this.userAgent.applicationVersion = value.toString(4);
      }
      
      function set url(value:String) : void
      {
         this._url = value;
      }
      
      public function get locationSWFPath() : String
      {
         return this._url;
      }
      
      public function get referrer() : String
      {
         var _referrer:String = this._dom.referrer;
         if(_referrer)
         {
            return _referrer;
         }
         if(this.protocol == Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function get documentTitle() : String
      {
         var _title:String = this._dom.title;
         if(_title)
         {
            return _title;
         }
         return "";
      }
      
      public function get domainName() : String
      {
         var URL:String = null;
         var str:String = null;
         var end:int = 0;
         if(this.protocol == Protocols.HTTP || this.protocol == Protocols.HTTPS)
         {
            URL = this._url.toLowerCase();
            if(this.protocol == Protocols.HTTP)
            {
               str = URL.split("http://").join("");
            }
            else if(this.protocol == Protocols.HTTPS)
            {
               str = URL.split("https://").join("");
            }
            end = str.indexOf("/");
            if(end > -1)
            {
               str = str.substring(0,end);
            }
            return str;
         }
         if(this.protocol == Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function isAIR() : Boolean
      {
         return this.playerType == "Desktop" && Security.sandboxType.toString() == "application";
      }
      
      public function isInHTML() : Boolean
      {
         return Capabilities.playerType == "PlugIn";
      }
      
      public function get locationPath() : String
      {
         var _pathname:String = this._dom.pathname;
         if(_pathname)
         {
            return _pathname;
         }
         return "";
      }
      
      public function get locationSearch() : String
      {
         var _search:String = this._dom.search;
         if(_search)
         {
            return _search;
         }
         return "";
      }
      
      public function get flashVersion() : Version
      {
         var v:Version = Version.fromString(Capabilities.version.split(" ")[1],",");
         return v;
      }
      
      public function get language() : String
      {
         var _lang:String = this._dom.language;
         var lang:String = Capabilities.language;
         if(_lang)
         {
            if(_lang.length > lang.length && _lang.substr(0,lang.length) == lang)
            {
               lang = _lang;
            }
         }
         return lang;
      }
      
      public function get languageEncoding() : String
      {
         var _charset:String = null;
         if(System.useCodePage)
         {
            _charset = this._dom.characterSet;
            if(_charset)
            {
               return _charset;
            }
            return "-";
         }
         return "UTF-8";
      }
      
      public function get operatingSystem() : String
      {
         return Capabilities.os;
      }
      
      public function get playerType() : String
      {
         return Capabilities.playerType;
      }
      
      public function get platform() : String
      {
         var p:String = Capabilities.manufacturer;
         return p.split("Adobe ")[1];
      }
      
      public function get protocol() : Protocols
      {
         if(!this._protocol)
         {
            this._findProtocol();
         }
         return this._protocol;
      }
      
      public function get screenHeight() : Number
      {
         return Capabilities.screenResolutionY;
      }
      
      public function get screenWidth() : Number
      {
         return Capabilities.screenResolutionX;
      }
      
      public function get screenColorDepth() : String
      {
         var color:String = null;
         switch(Capabilities.screenColor)
         {
            case "bw":
               color = "1";
               break;
            case "gray":
               color = "2";
               break;
            case "color":
            default:
               color = "24";
         }
         var _colorDepth:String = this._dom.colorDepth;
         if(_colorDepth)
         {
            color = _colorDepth;
         }
         return color;
      }
      
      public function get userAgent() : UserAgent
      {
         if(!this._userAgent)
         {
            this._userAgent = new UserAgent(this,this.appName,this.appVersion.toString(4));
         }
         return this._userAgent;
      }
      
      public function set userAgent(custom:UserAgent) : void
      {
         this._userAgent = custom;
      }
   }
}
