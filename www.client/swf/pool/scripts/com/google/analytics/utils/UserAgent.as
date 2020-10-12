package com.google.analytics.utils
{
   import com.google.analytics.core.Utils;
   import flash.system.Capabilities;
   import flash.system.System;
   
   public class UserAgent
   {
      
      public static var minimal:Boolean = false;
       
      
      private var _applicationProduct:String;
      
      private var _localInfo:Environment;
      
      private var _version:Version;
      
      public function UserAgent(localInfo:Environment, product:String = "", version:String = "")
      {
         super();
         this._localInfo = localInfo;
         this.applicationProduct = product;
         this._version = Version.fromString(version);
      }
      
      public function get applicationComment() : String
      {
         var comment:Array = [];
         comment.push(this._localInfo.platform);
         comment.push(this._localInfo.playerType);
         if(!UserAgent.minimal)
         {
            comment.push(this._localInfo.operatingSystem);
            comment.push(this._localInfo.language);
         }
         if(Capabilities.isDebugger)
         {
            comment.push("DEBUG");
         }
         if(comment.length > 0)
         {
            return "(" + comment.join("; ") + ")";
         }
         return "";
      }
      
      public function get applicationProduct() : String
      {
         return this._applicationProduct;
      }
      
      public function set applicationProduct(value:String) : void
      {
         this._applicationProduct = value;
      }
      
      public function get applicationProductToken() : String
      {
         var token:String = this.applicationProduct;
         if(this.applicationVersion != "")
         {
            token = token + ("/" + this.applicationVersion);
         }
         return token;
      }
      
      public function get applicationVersion() : String
      {
         return this._version.toString(2);
      }
      
      public function set applicationVersion(value:String) : void
      {
         this._version = Version.fromString(value);
      }
      
      public function get tamarinProductToken() : String
      {
         if(UserAgent.minimal)
         {
            return "";
         }
         if(System.vmVersion)
         {
            return "Tamarin/" + Utils.trim(System.vmVersion,true);
         }
         return "";
      }
      
      public function get vendorProductToken() : String
      {
         var vp:String = "";
         if(this._localInfo.isAIR())
         {
            vp = vp + "AIR";
         }
         else
         {
            vp = vp + "FlashPlayer";
         }
         vp = vp + "/";
         vp = vp + this._version.toString(3);
         return vp;
      }
      
      public function toString() : String
      {
         var UA:String = "";
         UA = UA + this.applicationProductToken;
         if(this.applicationComment != "")
         {
            UA = UA + (" " + this.applicationComment);
         }
         if(this.tamarinProductToken != "")
         {
            UA = UA + (" " + this.tamarinProductToken);
         }
         if(this.vendorProductToken != "")
         {
            UA = UA + (" " + this.vendorProductToken);
         }
         return UA;
      }
   }
}
