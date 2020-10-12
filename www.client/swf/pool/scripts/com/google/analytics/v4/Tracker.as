package com.google.analytics.v4
{
   import com.google.analytics.campaign.CampaignInfo;
   import com.google.analytics.campaign.CampaignManager;
   import com.google.analytics.core.BrowserInfo;
   import com.google.analytics.core.Buffer;
   import com.google.analytics.core.DocumentInfo;
   import com.google.analytics.core.DomainNameMode;
   import com.google.analytics.core.Ecommerce;
   import com.google.analytics.core.EventInfo;
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.core.GIFRequest;
   import com.google.analytics.core.ServerOperationMode;
   import com.google.analytics.core.Utils;
   import com.google.analytics.data.X10;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.ecommerce.Transaction;
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Protocols;
   import com.google.analytics.utils.URL;
   import com.google.analytics.utils.Variables;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Tracker implements GoogleAnalyticsAPI
   {
       
      
      private var _account:String;
      
      private var _domainHash:Number;
      
      private var _formatedReferrer:String;
      
      private var _timeStamp:Number;
      
      private var _hasInitData:Boolean = false;
      
      private var _isNewVisitor:Boolean = false;
      
      private var _noSessionInformation:Boolean = false;
      
      private var _config:Configuration;
      
      private var _debug:DebugConfiguration;
      
      private var _info:Environment;
      
      private var _buffer:Buffer;
      
      private var _gifRequest:GIFRequest;
      
      private var _adSense:AdSenseGlobals;
      
      private var _browserInfo:BrowserInfo;
      
      private var _campaignInfo:CampaignInfo;
      
      private const EVENT_TRACKER_PROJECT_ID:int = 5;
      
      private const EVENT_TRACKER_OBJECT_NAME_KEY_NUM:int = 1;
      
      private const EVENT_TRACKER_TYPE_KEY_NUM:int = 2;
      
      private const EVENT_TRACKER_LABEL_KEY_NUM:int = 3;
      
      private const EVENT_TRACKER_VALUE_VALUE_NUM:int = 1;
      
      private var _campaign:CampaignManager;
      
      private var _eventTracker:X10;
      
      private var _x10Module:X10;
      
      private var _ecom:Ecommerce;
      
      public function Tracker(account:String, config:Configuration, debug:DebugConfiguration, info:Environment, buffer:Buffer, gifRequest:GIFRequest, adSense:AdSenseGlobals, ecom:Ecommerce)
      {
         var msg:String = null;
         super();
         this._account = account;
         this._config = config;
         this._debug = debug;
         this._info = info;
         this._buffer = buffer;
         this._gifRequest = gifRequest;
         this._adSense = adSense;
         this._ecom = ecom;
         if(!Utils.validateAccount(account))
         {
            msg = "Account \"" + account + "\" is not valid.";
            this._debug.warning(msg);
            throw new Error(msg);
         }
      }
      
      private function _initData() : void
      {
         var data0:String = null;
         var data:String = null;
         if(!this._hasInitData)
         {
            this._updateDomainName();
            this._domainHash = this._getDomainHash();
            this._timeStamp = Math.round(new Date().getTime() / 1000);
            if(this._debug.verbose)
            {
               data0 = "";
               data0 = data0 + "_initData 0";
               data0 = data0 + ("\ndomain name: " + this._config.domainName);
               data0 = data0 + ("\ndomain hash: " + this._domainHash);
               data0 = data0 + ("\ntimestamp:   " + this._timeStamp + " (" + new Date(this._timeStamp * 1000) + ")");
               this._debug.info(data0,VisualDebugMode.geek);
            }
         }
         if(this._doTracking())
         {
            this._handleCookie();
         }
         if(!this._hasInitData)
         {
            if(this._doTracking())
            {
               this._formatedReferrer = this._formatReferrer();
               this._browserInfo = new BrowserInfo(this._config,this._info);
               this._debug.info("browserInfo: " + this._browserInfo.toURLString(),VisualDebugMode.advanced);
               if(this._config.campaignTracking)
               {
                  this._campaign = new CampaignManager(this._config,this._debug,this._buffer,this._domainHash,this._formatedReferrer,this._timeStamp);
                  this._campaignInfo = this._campaign.getCampaignInformation(this._info.locationSearch,this._noSessionInformation);
                  this._debug.info("campaignInfo: " + this._campaignInfo.toURLString(),VisualDebugMode.advanced);
                  this._debug.info("Search: " + this._info.locationSearch);
                  this._debug.info("CampaignTrackig: " + this._buffer.utmz.campaignTracking);
               }
            }
            this._x10Module = new X10();
            this._eventTracker = new X10();
            this._hasInitData = true;
         }
         if(this._config.hasSiteOverlay)
         {
            this._debug.warning("Site Overlay is not supported");
         }
         if(this._debug.verbose)
         {
            data = "";
            data = data + "_initData (misc)";
            data = data + ("\nflash version: " + this._info.flashVersion.toString(4));
            data = data + ("\nprotocol: " + this._info.protocol);
            data = data + ("\ndefault domain name (auto): \"" + this._info.domainName + "\"");
            data = data + ("\nlanguage: " + this._info.language);
            data = data + ("\ndomain hash: " + this._getDomainHash());
            data = data + ("\nuser-agent: " + this._info.userAgent);
            this._debug.info(data,VisualDebugMode.geek);
         }
      }
      
      private function _handleCookie() : void
      {
         var data0:String = null;
         var data1:String = null;
         var vid:Array = null;
         var data2:String = null;
         if(!this._config.allowLinker)
         {
         }
         this._buffer.createSO();
         if(this._buffer.hasUTMA() && !this._buffer.utma.isEmpty())
         {
            if(!this._buffer.hasUTMB() || !this._buffer.hasUTMC())
            {
               this._buffer.updateUTMA(this._timeStamp);
               this._noSessionInformation = true;
            }
            if(this._debug.verbose)
            {
               this._debug.info("from cookie " + this._buffer.utma.toString(),VisualDebugMode.geek);
            }
         }
         else
         {
            this._debug.info("create a new utma",VisualDebugMode.advanced);
            this._buffer.utma.domainHash = this._domainHash;
            this._buffer.utma.sessionId = this._getUniqueSessionId();
            this._buffer.utma.firstTime = this._timeStamp;
            this._buffer.utma.lastTime = this._timeStamp;
            this._buffer.utma.currentTime = this._timeStamp;
            this._buffer.utma.sessionCount = 1;
            if(this._debug.verbose)
            {
               this._debug.info(this._buffer.utma.toString(),VisualDebugMode.geek);
            }
            this._noSessionInformation = true;
            this._isNewVisitor = true;
         }
         if(this._adSense.gaGlobal && this._adSense.dh == String(this._domainHash))
         {
            if(this._adSense.sid)
            {
               this._buffer.utma.currentTime = Number(this._adSense.sid);
               if(this._debug.verbose)
               {
                  data0 = "";
                  data0 = data0 + "AdSense sid found\n";
                  data0 = data0 + ("Override currentTime(" + this._buffer.utma.currentTime + ") from AdSense sid(" + Number(this._adSense.sid) + ")");
                  this._debug.info(data0,VisualDebugMode.geek);
               }
            }
            if(this._isNewVisitor)
            {
               if(this._adSense.sid)
               {
                  this._buffer.utma.lastTime = Number(this._adSense.sid);
                  if(this._debug.verbose)
                  {
                     data1 = "";
                     data1 = data1 + "AdSense sid found (new visitor)\n";
                     data1 = data1 + ("Override lastTime(" + this._buffer.utma.lastTime + ") from AdSense sid(" + Number(this._adSense.sid) + ")");
                     this._debug.info(data1,VisualDebugMode.geek);
                  }
               }
               if(this._adSense.vid)
               {
                  vid = this._adSense.vid.split(".");
                  this._buffer.utma.sessionId = Number(vid[0]);
                  this._buffer.utma.firstTime = Number(vid[1]);
                  if(this._debug.verbose)
                  {
                     data2 = "";
                     data2 = data2 + "AdSense vid found (new visitor)\n";
                     data2 = data2 + ("Override sessionId(" + this._buffer.utma.sessionId + ") from AdSense vid(" + Number(vid[0]) + ")\n");
                     data2 = data2 + ("Override firstTime(" + this._buffer.utma.firstTime + ") from AdSense vid(" + Number(vid[1]) + ")");
                     this._debug.info(data2,VisualDebugMode.geek);
                  }
               }
               if(this._debug.verbose)
               {
                  this._debug.info("AdSense modified : " + this._buffer.utma.toString(),VisualDebugMode.geek);
               }
            }
         }
         this._buffer.utmb.domainHash = this._domainHash;
         if(isNaN(this._buffer.utmb.trackCount))
         {
            this._buffer.utmb.trackCount = 0;
         }
         if(isNaN(this._buffer.utmb.token))
         {
            this._buffer.utmb.token = this._config.tokenCliff;
         }
         if(isNaN(this._buffer.utmb.lastTime))
         {
            this._buffer.utmb.lastTime = this._buffer.utma.currentTime;
         }
         this._buffer.utmc.domainHash = this._domainHash;
         if(this._debug.verbose)
         {
            this._debug.info(this._buffer.utmb.toString(),VisualDebugMode.advanced);
            this._debug.info(this._buffer.utmc.toString(),VisualDebugMode.advanced);
         }
      }
      
      private function _isNotGoogleSearch() : Boolean
      {
         var domainName:String = this._config.domainName;
         var g0:Boolean = domainName.indexOf("www.google.") < 0;
         var g1:Boolean = domainName.indexOf(".google.") < 0;
         var g2:Boolean = domainName.indexOf("google.") < 0;
         var g4:Boolean = domainName.indexOf("google.org") > -1;
         return g0 || g1 || g2 || this._config.cookiePath != "/" || g4;
      }
      
      private function _doTracking() : Boolean
      {
         if(this._info.protocol != Protocols.file && this._info.protocol != Protocols.none && this._isNotGoogleSearch())
         {
            return true;
         }
         if(this._config.allowLocalTracking)
         {
            return true;
         }
         return false;
      }
      
      private function _updateDomainName() : void
      {
         var domainName:String = null;
         if(this._config.domain.mode == DomainNameMode.auto)
         {
            domainName = this._info.domainName;
            if(domainName.substring(0,4) == "www.")
            {
               domainName = domainName.substring(4);
            }
            this._config.domain.name = domainName;
         }
         this._config.domainName = this._config.domain.name.toLowerCase();
         this._debug.info("domain name: " + this._config.domainName,VisualDebugMode.advanced);
      }
      
      private function _formatReferrer() : String
      {
         var domainName:String = null;
         var ref:URL = null;
         var dom:URL = null;
         var referrer:String = this._info.referrer;
         if(referrer == "" || referrer == "localhost")
         {
            referrer = "-";
         }
         else
         {
            domainName = this._info.domainName;
            ref = new URL(referrer);
            dom = new URL("http://" + domainName);
            if(ref.hostName == domainName)
            {
               return "-";
            }
            if(dom.domain == ref.domain)
            {
               if(dom.subDomain != ref.subDomain)
               {
                  referrer = "0";
               }
            }
            if(referrer.charAt(0) == "[" && referrer.charAt(referrer.length - 1))
            {
               referrer = "-";
            }
         }
         this._debug.info("formated referrer: " + referrer,VisualDebugMode.advanced);
         return referrer;
      }
      
      private function _generateUserDataHash() : Number
      {
         var hash:String = "";
         hash = hash + this._info.appName;
         hash = hash + this._info.appVersion;
         hash = hash + this._info.language;
         hash = hash + this._info.platform;
         hash = hash + this._info.userAgent.toString();
         hash = hash + (this._info.screenWidth + "x" + this._info.screenHeight + this._info.screenColorDepth);
         hash = hash + this._info.referrer;
         return Utils.generateHash(hash);
      }
      
      private function _getUniqueSessionId() : Number
      {
         var sessionID:Number = (Utils.generate32bitRandom() ^ this._generateUserDataHash()) * 2147483647;
         this._debug.info("Session ID: " + sessionID,VisualDebugMode.geek);
         return sessionID;
      }
      
      private function _getDomainHash() : Number
      {
         if(!this._config.domainName || this._config.domainName == "" || this._config.domain.mode == DomainNameMode.none)
         {
            this._config.domainName = "";
            return 1;
         }
         this._updateDomainName();
         if(this._config.allowDomainHash)
         {
            return Utils.generateHash(this._config.domainName);
         }
         return 1;
      }
      
      private function _visitCode() : Number
      {
         if(this._debug.verbose)
         {
            this._debug.info("visitCode: " + this._buffer.utma.sessionId,VisualDebugMode.geek);
         }
         return this._buffer.utma.sessionId;
      }
      
      private function _takeSample() : Boolean
      {
         if(this._debug.verbose)
         {
            this._debug.info("takeSample: (" + this._visitCode() % 10000 + ") < (" + this._config.sampleRate * 10000 + ")",VisualDebugMode.geek);
         }
         return this._visitCode() % 10000 < this._config.sampleRate * 10000;
      }
      
      public function getAccount() : String
      {
         this._debug.info("getAccount()");
         return this._account;
      }
      
      public function getVersion() : String
      {
         this._debug.info("getVersion()");
         return this._config.version;
      }
      
      public function resetSession() : void
      {
         this._debug.info("resetSession()");
         this._buffer.resetCurrentSession();
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         if(newRate < 0)
         {
            this._debug.warning("sample rate can not be negative, ignoring value.");
         }
         else
         {
            this._config.sampleRate = newRate;
         }
         this._debug.info("setSampleRate( " + this._config.sampleRate + " )");
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         this._config.sessionTimeout = newTimeout;
         this._debug.info("setSessionTimeout( " + this._config.sessionTimeout + " )");
      }
      
      public function setVar(newVal:String) : void
      {
         var variables:Variables = null;
         if(newVal != "" && this._isNotGoogleSearch())
         {
            this._initData();
            this._buffer.utmv.domainHash = this._domainHash;
            this._buffer.utmv.value = encodeURI(newVal);
            if(this._debug.verbose)
            {
               this._debug.info(this._buffer.utmv.toString(),VisualDebugMode.geek);
            }
            this._debug.info("setVar( " + newVal + " )");
            if(this._takeSample())
            {
               variables = new Variables();
               variables.utmt = "var";
               this._gifRequest.send(this._account,variables);
            }
         }
         else
         {
            this._debug.warning("setVar \"" + newVal + "\" is ignored");
         }
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         this._debug.info("trackPageview( " + pageURL + " )");
         if(this._doTracking())
         {
            this._initData();
            this._trackMetrics(pageURL);
            this._noSessionInformation = false;
         }
         else
         {
            this._debug.warning("trackPageview( " + pageURL + " ) failed");
         }
      }
      
      private function _renderMetricsSearchVariables(pageURL:String = "") : Variables
      {
         var campvars:Variables = null;
         var variables:Variables = new Variables();
         variables.URIencode = true;
         var docInfo:DocumentInfo = new DocumentInfo(this._config,this._info,this._formatedReferrer,pageURL,this._adSense);
         this._debug.info("docInfo: " + docInfo.toURLString(),VisualDebugMode.geek);
         if(this._config.campaignTracking)
         {
            campvars = this._campaignInfo.toVariables();
         }
         var browservars:Variables = this._browserInfo.toVariables();
         variables.join(docInfo.toVariables(),browservars,campvars);
         return variables;
      }
      
      private function _trackMetrics(pageURL:String = "") : void
      {
         var searchVariables:Variables = null;
         var x10vars:Variables = null;
         var generalvars:Variables = null;
         var eventInfo:EventInfo = null;
         if(this._takeSample())
         {
            searchVariables = new Variables();
            searchVariables.URIencode = true;
            if(this._x10Module && this._x10Module.hasData())
            {
               eventInfo = new EventInfo(false,this._x10Module);
               x10vars = eventInfo.toVariables();
            }
            generalvars = this._renderMetricsSearchVariables(pageURL);
            searchVariables.join(x10vars,generalvars);
            this._gifRequest.send(this._account,searchVariables);
         }
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         this._config.allowAnchor = enable;
         this._debug.info("setAllowAnchor( " + this._config.allowAnchor + " )");
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         this._config.campaignKey.UCCT = newCampContentKey;
         var msg:String = "setCampContentKey( " + this._config.campaignKey.UCCT + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCCT]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         this._config.campaignKey.UCMD = newCampMedKey;
         var msg:String = "setCampMediumKey( " + this._config.campaignKey.UCMD + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCMD]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         this._config.campaignKey.UCCN = newCampNameKey;
         var msg:String = "setCampNameKey( " + this._config.campaignKey.UCCN + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCCN]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         this._config.campaignKey.UCNO = newCampNOKey;
         var msg:String = "setCampNOKey( " + this._config.campaignKey.UCNO + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCNO]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         this._config.campaignKey.UCSR = newCampSrcKey;
         var msg:String = "setCampSourceKey( " + this._config.campaignKey.UCSR + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCSR]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         this._config.campaignKey.UCTR = newCampTermKey;
         var msg:String = "setCampTermKey( " + this._config.campaignKey.UCTR + " )";
         if(this._debug.mode == VisualDebugMode.geek)
         {
            this._debug.info(msg + " [UCTR]");
         }
         else
         {
            this._debug.info(msg);
         }
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         this._config.campaignTracking = enable;
         this._debug.info("setCampaignTrack( " + this._config.campaignTracking + " )");
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         this._config.conversionTimeout = newDefaultTimeout;
         this._debug.info("setCookieTimeout( " + this._config.conversionTimeout + " )");
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         this._debug.warning("cookiePathCopy( " + newPath + " ) not implemented");
      }
      
      public function getLinkerUrl(targetUrl:String = "", useHash:Boolean = false) : String
      {
         this._initData();
         this._debug.info("getLinkerUrl( " + targetUrl + ", " + useHash.toString() + " )");
         return this._buffer.getLinkerUrl(targetUrl,useHash);
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         this._initData();
         var out:String = this._buffer.getLinkerUrl(targetUrl,useHash);
         var request:URLRequest = new URLRequest(out);
         this._debug.info("link( " + [targetUrl,useHash].join(",") + " )");
         try
         {
            navigateToURL(request,"_top");
         }
         catch(e:Error)
         {
            _debug.warning("An error occured in link() msg: " + e.message);
         }
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         this._debug.warning("linkByPost not implemented in AS3 mode");
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         this._config.allowDomainHash = enable;
         this._debug.info("setAllowHash( " + this._config.allowDomainHash + " )");
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         this._config.allowLinker = enable;
         this._debug.info("setAllowLinker( " + this._config.allowLinker + " )");
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         this._config.cookiePath = newCookiePath;
         this._debug.info("setCookiePath( " + this._config.cookiePath + " )");
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         if(newDomainName == "auto")
         {
            this._config.domain.mode = DomainNameMode.auto;
         }
         else if(newDomainName == "none")
         {
            this._config.domain.mode = DomainNameMode.none;
         }
         else
         {
            this._config.domain.mode = DomainNameMode.custom;
            this._config.domain.name = newDomainName;
         }
         this._updateDomainName();
         this._debug.info("setDomainName( " + this._config.domainName + " )");
      }
      
      public function addItem(id:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         var parentTrans:Transaction = null;
         parentTrans = this._ecom.getTransaction(id);
         if(parentTrans == null)
         {
            parentTrans = this._ecom.addTransaction(id,"","","","","","","");
         }
         parentTrans.addItem(sku,name,category,price.toString(),quantity.toString());
         if(this._debug.active)
         {
            this._debug.info("addItem( " + [id,sku,name,category,price,quantity].join(", ") + " )");
         }
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : void
      {
         this._ecom.addTransaction(orderId,affiliation,total.toString(),tax.toString(),shipping.toString(),city,state,country);
         if(this._debug.active)
         {
            this._debug.info("addTrans( " + [orderId,affiliation,total,tax,shipping,city,state,country].join(", ") + " );");
         }
      }
      
      public function trackTrans() : void
      {
         var i:Number = NaN;
         var j:Number = NaN;
         var curTrans:Transaction = null;
         this._initData();
         var searchStrings:Array = new Array();
         if(this._takeSample())
         {
            for(i = 0; i < this._ecom.getTransLength(); i++)
            {
               curTrans = this._ecom.getTransFromArray(i);
               searchStrings.push(curTrans.toGifParams());
               for(j = 0; j < curTrans.getItemsLength(); j++)
               {
                  searchStrings.push(curTrans.getItemFromArray(j).toGifParams());
               }
            }
            for(i = 0; i < searchStrings.length; i++)
            {
               this._gifRequest.send(this._account,searchStrings[i]);
            }
         }
      }
      
      private function _sendXEvent(opt_xObj:X10 = null) : void
      {
         var searchVariables:Variables = null;
         var eventInfo:EventInfo = null;
         var eventvars:Variables = null;
         var generalvars:Variables = null;
         if(this._takeSample())
         {
            searchVariables = new Variables();
            searchVariables.URIencode = true;
            eventInfo = new EventInfo(true,this._x10Module,opt_xObj);
            eventvars = eventInfo.toVariables();
            generalvars = this._renderMetricsSearchVariables();
            searchVariables.join(eventvars,generalvars);
            this._gifRequest.send(this._account,searchVariables,false,true);
         }
      }
      
      public function createEventTracker(objName:String) : EventTracker
      {
         this._debug.info("createEventTracker( " + objName + " )");
         return new EventTracker(objName,this);
      }
      
      public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
      {
         this._initData();
         var success:Boolean = true;
         var params:int = 2;
         if(category != "" && action != "")
         {
            this._eventTracker.clearKey(this.EVENT_TRACKER_PROJECT_ID);
            this._eventTracker.clearValue(this.EVENT_TRACKER_PROJECT_ID);
            success = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID,this.EVENT_TRACKER_OBJECT_NAME_KEY_NUM,category);
            success = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID,this.EVENT_TRACKER_TYPE_KEY_NUM,action);
            if(label)
            {
               success = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID,this.EVENT_TRACKER_LABEL_KEY_NUM,label);
               params = 3;
            }
            if(!isNaN(value))
            {
               success = this._eventTracker.setValue(this.EVENT_TRACKER_PROJECT_ID,this.EVENT_TRACKER_VALUE_VALUE_NUM,value);
               params = 4;
            }
            if(success)
            {
               this._debug.info("valid event tracking call\ncategory: " + category + "\naction: " + action,VisualDebugMode.geek);
               this._sendXEvent(this._eventTracker);
            }
         }
         else
         {
            this._debug.warning("event tracking call is not valid, failed!\ncategory: " + category + "\naction: " + action,VisualDebugMode.geek);
            success = false;
         }
         switch(params)
         {
            case 4:
               this._debug.info("trackEvent( " + [category,action,label,value].join(", ") + " )");
               break;
            case 3:
               this._debug.info("trackEvent( " + [category,action,label].join(", ") + " )");
               break;
            case 2:
            default:
               this._debug.info("trackEvent( " + [category,action].join(", ") + " )");
         }
         return success;
      }
      
      public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
      {
         this._debug.info("addIgnoredOrganic( " + newIgnoredOrganicKeyword + " )");
         this._config.organic.addIgnoredKeyword(newIgnoredOrganicKeyword);
      }
      
      public function addIgnoredRef(newIgnoredReferrer:String) : void
      {
         this._debug.info("addIgnoredRef( " + newIgnoredReferrer + " )");
         this._config.organic.addIgnoredReferral(newIgnoredReferrer);
      }
      
      public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
      {
         this._debug.info("addOrganic( " + [newOrganicEngine,newOrganicKeyword].join(", ") + " )");
         this._config.organic.addSource(newOrganicEngine,newOrganicKeyword);
      }
      
      public function clearIgnoredOrganic() : void
      {
         this._debug.info("clearIgnoredOrganic()");
         this._config.organic.clearIgnoredKeywords();
      }
      
      public function clearIgnoredRef() : void
      {
         this._debug.info("clearIgnoredRef()");
         this._config.organic.clearIgnoredReferrals();
      }
      
      public function clearOrganic() : void
      {
         this._debug.info("clearOrganic()");
         this._config.organic.clearEngines();
      }
      
      public function getClientInfo() : Boolean
      {
         this._debug.info("getClientInfo()");
         return this._config.detectClientInfo;
      }
      
      public function getDetectFlash() : Boolean
      {
         this._debug.info("getDetectFlash()");
         return this._config.detectFlash;
      }
      
      public function getDetectTitle() : Boolean
      {
         this._debug.info("getDetectTitle()");
         return this._config.detectTitle;
      }
      
      public function setClientInfo(enable:Boolean) : void
      {
         this._config.detectClientInfo = enable;
         this._debug.info("setClientInfo( " + this._config.detectClientInfo + " )");
      }
      
      public function setDetectFlash(enable:Boolean) : void
      {
         this._config.detectFlash = enable;
         this._debug.info("setDetectFlash( " + this._config.detectFlash + " )");
      }
      
      public function setDetectTitle(enable:Boolean) : void
      {
         this._config.detectTitle = enable;
         this._debug.info("setDetectTitle( " + this._config.detectTitle + " )");
      }
      
      public function getLocalGifPath() : String
      {
         this._debug.info("getLocalGifPath()");
         return this._config.localGIFpath;
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         this._debug.info("getServiceMode()");
         return this._config.serverMode;
      }
      
      public function setLocalGifPath(newLocalGifPath:String) : void
      {
         this._config.localGIFpath = newLocalGifPath;
         this._debug.info("setLocalGifPath( " + this._config.localGIFpath + " )");
      }
      
      public function setLocalRemoteServerMode() : void
      {
         this._config.serverMode = ServerOperationMode.both;
         this._debug.info("setLocalRemoteServerMode()");
      }
      
      public function setLocalServerMode() : void
      {
         this._config.serverMode = ServerOperationMode.local;
         this._debug.info("setLocalServerMode()");
      }
      
      public function setRemoteServerMode() : void
      {
         this._config.serverMode = ServerOperationMode.remote;
         this._debug.info("setRemoteServerMode()");
      }
   }
}
