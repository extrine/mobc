package com.google.analytics.utils
{
   public class URL
   {
       
      
      private var _url:String;
      
      public function URL(url:String = "")
      {
         super();
         this._url = url.toLowerCase();
      }
      
      public function get protocol() : Protocols
      {
         var proto:String = this._url.split("://")[0];
         switch(proto)
         {
            case "file":
               return Protocols.file;
            case "http":
               return Protocols.HTTP;
            case "https":
               return Protocols.HTTPS;
            default:
               return Protocols.none;
         }
      }
      
      public function get hostName() : String
      {
         var hostname:String = this._url;
         if(hostname.indexOf("://") > -1)
         {
            hostname = hostname.split("://")[1];
         }
         if(hostname.indexOf("/") > -1)
         {
            hostname = hostname.split("/")[0];
         }
         if(hostname.indexOf("?") > -1)
         {
            hostname = hostname.split("?")[0];
         }
         if(this.protocol == Protocols.file || this.protocol == Protocols.none)
         {
            return "";
         }
         return hostname;
      }
      
      public function get domain() : String
      {
         var parts:Array = null;
         if(this.hostName != "" && this.hostName.indexOf(".") > -1)
         {
            parts = this.hostName.split(".");
            switch(parts.length)
            {
               case 2:
                  return this.hostName;
               case 3:
                  if(parts[1] == "co")
                  {
                     return this.hostName;
                  }
                  parts.shift();
                  return parts.join(".");
               case 4:
                  parts.shift();
                  return parts.join(".");
            }
         }
         return "";
      }
      
      public function get subDomain() : String
      {
         if(this.domain != "" && this.domain != this.hostName)
         {
            return this.hostName.split("." + this.domain).join("");
         }
         return "";
      }
      
      public function get path() : String
      {
         var _path:String = this._url;
         if(_path.indexOf("://") > -1)
         {
            _path = _path.split("://")[1];
         }
         if(_path.indexOf(this.hostName) == 0)
         {
            _path = _path.substr(this.hostName.length);
         }
         if(_path.indexOf("?") > -1)
         {
            _path = _path.split("?")[0];
         }
         if(_path.charAt(0) != "/")
         {
            _path = "/" + _path;
         }
         return _path;
      }
      
      public function get search() : String
      {
         var _search:String = this._url;
         if(_search.indexOf("://") > -1)
         {
            _search = _search.split("://")[1];
         }
         if(_search.indexOf(this.hostName) == 0)
         {
            _search = _search.substr(this.hostName.length);
         }
         if(_search.indexOf("?") > -1)
         {
            _search = _search.split("?")[1];
         }
         else
         {
            _search = "";
         }
         return _search;
      }
   }
}
