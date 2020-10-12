package com.google.analytics.campaign
{
   import com.google.analytics.utils.Variables;
   
   public class CampaignTracker
   {
       
      
      public var id:String;
      
      public var source:String;
      
      public var clickId:String;
      
      public var name:String;
      
      public var medium:String;
      
      public var term:String;
      
      public var content:String;
      
      public function CampaignTracker(id:String = "", source:String = "", clickId:String = "", name:String = "", medium:String = "", term:String = "", content:String = "")
      {
         super();
         this.id = id;
         this.source = source;
         this.clickId = clickId;
         this.name = name;
         this.medium = medium;
         this.term = term;
         this.content = content;
      }
      
      private function _addIfNotEmpty(arr:Array, field:String, value:String) : void
      {
         if(value != "")
         {
            value = value.split("+").join("%20");
            value = value.split(" ").join("%20");
            arr.push(field + value);
         }
      }
      
      public function isValid() : Boolean
      {
         if(this.id != "" || this.source != "" || this.clickId != "")
         {
            return true;
         }
         return false;
      }
      
      public function fromTrackerString(tracker:String) : void
      {
         var data:String = tracker.split(CampaignManager.trackingDelimiter).join("&");
         var vars:Variables = new Variables(data);
         if(vars.hasOwnProperty("utmcid"))
         {
            this.id = vars["utmcid"];
         }
         if(vars.hasOwnProperty("utmcsr"))
         {
            this.source = vars["utmcsr"];
         }
         if(vars.hasOwnProperty("utmccn"))
         {
            this.name = vars["utmccn"];
         }
         if(vars.hasOwnProperty("utmcmd"))
         {
            this.medium = vars["utmcmd"];
         }
         if(vars.hasOwnProperty("utmctr"))
         {
            this.term = vars["utmctr"];
         }
         if(vars.hasOwnProperty("utmcct"))
         {
            this.content = vars["utmcct"];
         }
         if(vars.hasOwnProperty("utmgclid"))
         {
            this.clickId = vars["utmgclid"];
         }
      }
      
      public function toTrackerString() : String
      {
         var data:Array = [];
         this._addIfNotEmpty(data,"utmcid=",this.id);
         this._addIfNotEmpty(data,"utmcsr=",this.source);
         this._addIfNotEmpty(data,"utmgclid=",this.clickId);
         this._addIfNotEmpty(data,"utmccn=",this.name);
         this._addIfNotEmpty(data,"utmcmd=",this.medium);
         this._addIfNotEmpty(data,"utmctr=",this.term);
         this._addIfNotEmpty(data,"utmcct=",this.content);
         return data.join(CampaignManager.trackingDelimiter);
      }
   }
}
