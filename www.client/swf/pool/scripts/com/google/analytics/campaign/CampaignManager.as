package com.google.analytics.campaign
{
   import com.google.analytics.core.Buffer;
   import com.google.analytics.core.OrganicReferrer;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.utils.Protocols;
   import com.google.analytics.utils.URL;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.v4.Configuration;
   
   public class CampaignManager
   {
      
      public static const trackingDelimiter:String = "|";
       
      
      private var _config:Configuration;
      
      private var _debug:DebugConfiguration;
      
      private var _buffer:Buffer;
      
      private var _domainHash:Number;
      
      private var _referrer:String;
      
      private var _timeStamp:Number;
      
      public function CampaignManager(config:Configuration, debug:DebugConfiguration, buffer:Buffer, domainHash:Number, referrer:String, timeStamp:Number)
      {
         super();
         this._config = config;
         this._debug = debug;
         this._buffer = buffer;
         this._domainHash = domainHash;
         this._referrer = referrer;
         this._timeStamp = timeStamp;
      }
      
      public static function isInvalidReferrer(referrer:String) : Boolean
      {
         var url:URL = null;
         if(referrer == "" || referrer == "-" || referrer == "0")
         {
            return true;
         }
         if(referrer.indexOf("://") > -1)
         {
            url = new URL(referrer);
            if(url.protocol == Protocols.file || url.protocol == Protocols.none)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isFromGoogleCSE(referrer:String, config:Configuration) : Boolean
      {
         var url:URL = new URL(referrer);
         if(url.hostName.indexOf(config.google) > -1)
         {
            if(url.search.indexOf(config.googleSearchParam + "=") > -1)
            {
               if(url.path == "/" + config.googleCsePath)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getCampaignInformation(search:String, noSessionInformation:Boolean) : CampaignInfo
      {
         var campaignTracker:CampaignTracker = null;
         var oldTracker:CampaignTracker = null;
         var sessionCount:int = 0;
         var campInfo:CampaignInfo = new CampaignInfo();
         var duplicateCampaign:Boolean = false;
         var campNoOverride:Boolean = false;
         var responseCount:int = 0;
         if(this._config.allowLinker && this._buffer.isGenuine())
         {
            if(!this._buffer.hasUTMZ())
            {
               return campInfo;
            }
         }
         campaignTracker = this.getTrackerFromSearchString(search);
         if(this.isValid(campaignTracker))
         {
            campNoOverride = this.hasNoOverride(search);
            if(campNoOverride && !this._buffer.hasUTMZ())
            {
               return campInfo;
            }
         }
         if(!this.isValid(campaignTracker))
         {
            campaignTracker = this.getOrganicCampaign();
            if(!this._buffer.hasUTMZ() && this.isIgnoredKeyword(campaignTracker))
            {
               return campInfo;
            }
         }
         if(!this.isValid(campaignTracker) && noSessionInformation)
         {
            campaignTracker = this.getReferrerCampaign();
            if(!this._buffer.hasUTMZ() && this.isIgnoredReferral(campaignTracker))
            {
               return campInfo;
            }
         }
         if(!this.isValid(campaignTracker))
         {
            if(!this._buffer.hasUTMZ() && noSessionInformation)
            {
               campaignTracker = this.getDirectCampaign();
            }
         }
         if(!this.isValid(campaignTracker))
         {
            return campInfo;
         }
         if(this._buffer.hasUTMZ() && !this._buffer.utmz.isEmpty())
         {
            oldTracker = new CampaignTracker();
            oldTracker.fromTrackerString(this._buffer.utmz.campaignTracking);
            duplicateCampaign = oldTracker.toTrackerString() == campaignTracker.toTrackerString();
            responseCount = this._buffer.utmz.responseCount;
         }
         if(!duplicateCampaign || noSessionInformation)
         {
            sessionCount = this._buffer.utma.sessionCount;
            responseCount++;
            if(sessionCount == 0)
            {
               sessionCount = 1;
            }
            this._buffer.utmz.domainHash = this._domainHash;
            this._buffer.utmz.campaignCreation = this._timeStamp;
            this._buffer.utmz.campaignSessions = sessionCount;
            this._buffer.utmz.responseCount = responseCount;
            this._buffer.utmz.campaignTracking = campaignTracker.toTrackerString();
            this._debug.info(this._buffer.utmz.toString(),VisualDebugMode.geek);
            campInfo = new CampaignInfo(false,true);
         }
         else
         {
            campInfo = new CampaignInfo(false,false);
         }
         return campInfo;
      }
      
      public function getOrganicCampaign() : CampaignTracker
      {
         var camp:CampaignTracker = null;
         var tmp:Array = null;
         var currentOrganicSource:OrganicReferrer = null;
         var keyword:String = null;
         if(isInvalidReferrer(this._referrer) || isFromGoogleCSE(this._referrer,this._config))
         {
            return camp;
         }
         var ref:URL = new URL(this._referrer);
         var name:String = "";
         if(ref.hostName != "")
         {
            if(ref.hostName.indexOf(".") > -1)
            {
               tmp = ref.hostName.split(".");
               switch(tmp.length)
               {
                  case 2:
                     name = tmp[0];
                     break;
                  case 3:
                     name = tmp[1];
               }
            }
         }
         if(this._config.organic.match(name))
         {
            currentOrganicSource = this._config.organic.getReferrerByName(name);
            keyword = this._config.organic.getKeywordValue(currentOrganicSource,ref.search);
            camp = new CampaignTracker();
            camp.source = currentOrganicSource.engine;
            camp.name = "(organic)";
            camp.medium = "organic";
            camp.term = keyword;
         }
         return camp;
      }
      
      public function getReferrerCampaign() : CampaignTracker
      {
         var camp:CampaignTracker = null;
         if(isInvalidReferrer(this._referrer) || isFromGoogleCSE(this._referrer,this._config))
         {
            return camp;
         }
         var ref:URL = new URL(this._referrer);
         var hostname:String = ref.hostName;
         var content:String = ref.path;
         if(hostname.indexOf("www.") == 0)
         {
            hostname = hostname.substr(4);
         }
         camp = new CampaignTracker();
         camp.source = hostname;
         camp.name = "(referral)";
         camp.medium = "referral";
         camp.content = content;
         return camp;
      }
      
      public function getDirectCampaign() : CampaignTracker
      {
         var camp:CampaignTracker = new CampaignTracker();
         camp.source = "(direct)";
         camp.name = "(direct)";
         camp.medium = "(none)";
         return camp;
      }
      
      public function hasNoOverride(search:String) : Boolean
      {
         var key:CampaignKey = this._config.campaignKey;
         if(search == "")
         {
            return false;
         }
         var variables:Variables = new Variables(search);
         var value:String = "";
         if(variables.hasOwnProperty(key.UCNO))
         {
            value = variables[key.UCNO];
            switch(value)
            {
               case "1":
                  return true;
               case "":
               case "0":
               default:
                  return false;
            }
         }
         else
         {
            return false;
         }
      }
      
      public function isIgnoredKeyword(tracker:CampaignTracker) : Boolean
      {
         if(tracker && tracker.medium == "organic")
         {
            return this._config.organic.isIgnoredKeyword(tracker.term);
         }
         return false;
      }
      
      public function isIgnoredReferral(tracker:CampaignTracker) : Boolean
      {
         if(tracker && tracker.medium == "referral")
         {
            return this._config.organic.isIgnoredReferral(tracker.source);
         }
         return false;
      }
      
      public function isValid(tracker:CampaignTracker) : Boolean
      {
         if(tracker && tracker.isValid())
         {
            return true;
         }
         return false;
      }
      
      public function getTrackerFromSearchString(search:String) : CampaignTracker
      {
         var organicCampaign:CampaignTracker = this.getOrganicCampaign();
         var camp:CampaignTracker = new CampaignTracker();
         var key:CampaignKey = this._config.campaignKey;
         if(search == "")
         {
            return camp;
         }
         var variables:Variables = new Variables(search);
         if(variables.hasOwnProperty(key.UCID))
         {
            camp.id = variables[key.UCID];
         }
         if(variables.hasOwnProperty(key.UCSR))
         {
            camp.source = variables[key.UCSR];
         }
         if(variables.hasOwnProperty(key.UGCLID))
         {
            camp.clickId = variables[key.UGCLID];
         }
         if(variables.hasOwnProperty(key.UCCN))
         {
            camp.name = variables[key.UCCN];
         }
         else
         {
            camp.name = "(not set)";
         }
         if(variables.hasOwnProperty(key.UCMD))
         {
            camp.medium = variables[key.UCMD];
         }
         else
         {
            camp.medium = "(not set)";
         }
         if(variables.hasOwnProperty(key.UCTR))
         {
            camp.term = variables[key.UCTR];
         }
         else if(organicCampaign && organicCampaign.term != "")
         {
            camp.term = organicCampaign.term;
         }
         if(variables.hasOwnProperty(key.UCCT))
         {
            camp.content = variables[key.UCCT];
         }
         return camp;
      }
   }
}
