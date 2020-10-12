package com.google.analytics.campaign
{
   import com.google.analytics.utils.Variables;
   
   public class CampaignInfo
   {
       
      
      private var _empty:Boolean;
      
      private var _new:Boolean;
      
      public function CampaignInfo(empty:Boolean = true, newCampaign:Boolean = false)
      {
         super();
         this._empty = empty;
         this._new = newCampaign;
      }
      
      public function get utmcn() : String
      {
         return "1";
      }
      
      public function get utmcr() : String
      {
         return "1";
      }
      
      public function isEmpty() : Boolean
      {
         return this._empty;
      }
      
      public function isNew() : Boolean
      {
         return this._new;
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         if(!this.isEmpty() && this.isNew())
         {
            variables.utmcn = this.utmcn;
         }
         if(!this.isEmpty() && !this.isNew())
         {
            variables.utmcr = this.utmcr;
         }
         return variables;
      }
      
      public function toURLString() : String
      {
         var v:Variables = this.toVariables();
         return v.toString();
      }
   }
}
