package iilwy.application
{
   import com.asual.swfaddress.SWFAddress;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import iilwy.data.PageCommand;
   import iilwy.display.layout.IPageView;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.AsyncEvent;
   import iilwy.events.ModuleManagerEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.managers.ModuleManager;
   import iilwy.model.dataobjects.module.ModuleType;
   import iilwy.model.local.LocalProperties;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class StateManager
   {
       
      
      private var _defaultResult:Object;
      
      private var _currentResult:Object;
      
      private var _siteStructure:XML;
      
      private var _debug:Boolean = true;
      
      private var _refractoryTimer:Timer;
      
      private var _lastURLSentToJS:String;
      
      private var _currentLayout:IPageView;
      
      private var _nextLayout:IPageView;
      
      private var _nextLayoutType:Class;
      
      private var _inTransition:Boolean = false;
      
      private var _externalInterfaceTimer:Timer;
      
      private var _initialURL:String = "/";
      
      private var _forcedInitialURL:String;
      
      private var _loginResponder:Responder;
      
      private var _pendingURL:String;
      
      private var _logger:Logger;
      
      private var _lastURL:String;
      
      private var _currentSection:String;
      
      private var _currentPageCommand:PageCommand;
      
      private var _enableHistoryManagement:Boolean = true;
      
      protected var _firstLogin:Boolean = true;
      
      protected var _swfAddressInited:Boolean = false;
      
      protected var _moduleManager:ModuleManager;
      
      public function StateManager(structure:XML, enableHistoryManagement:Boolean = true, forceInitial:String = null)
      {
         super();
         this.siteStructure = structure;
         var result:Object = new Object();
         result.searched = [];
         result.toSearch = [];
         result.node = this.siteStructure.pages.page.(attribute("rule") == "index")[0];
         if(!result.node)
         {
            result.node = this.siteStructure.pages.page[0];
         }
         result.url = "/";
         this._defaultResult = result;
         this._logger = Logger.getLogger("StateManager");
         this._logger.level = Logger.ALL;
         this._refractoryTimer = new Timer(1200,2);
         this._enableHistoryManagement = enableHistoryManagement;
         if(this._enableHistoryManagement)
         {
            this.addExternalInterface();
            this._forcedInitialURL = forceInitial;
         }
         else if(forceInitial)
         {
            this.appCreated(true,forceInitial);
         }
         else
         {
            this.appCreated(true,"/");
         }
         SWFAddress.onInit = this.onSwfAddressInit;
         this._moduleManager = ModuleManager.getInstance();
         this._moduleManager.addEventListener(ModuleManagerEvent.MODULE_LOADED,this.onModuleLoaded);
      }
      
      protected function onSwfAddressInit() : void
      {
         this._logger.log("Swf address init");
         this._swfAddressInited = true;
         try
         {
            this._logger.log(SWFAddress.getPath());
            this._logger.log(SWFAddress.getHistory());
         }
         catch(e:Error)
         {
         }
      }
      
      public function get currentSection() : String
      {
         return this._currentSection;
      }
      
      public function get currentPageCommand() : PageCommand
      {
         return this._currentPageCommand;
      }
      
      private function onFirstUserLogin(evt:Event) : void
      {
         this._logger.log("First login change detected");
         this._firstLogin = false;
         AppComponents.model.removeEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onFirstUserLogin);
         this.appCreated(true,this._initialURL);
      }
      
      private function appCreated(success:Boolean, initialURL:String) : void
      {
         this._logger.log("App created",success);
         if(success)
         {
            this._logger.log("app created success on interface");
            if(AppProperties.debugMode == AppProperties.MODE_LOCAL_DEBUGGING && AppProperties.appVersion != AppProperties.VERSION_ARCADE_TESTER)
            {
            }
            this._initialURL = initialURL;
            if(!AppComponents.model.firstSessionLoaded)
            {
               this._logger.log("First session not loaded");
               AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onFirstUserLogin);
            }
            else
            {
               this._logger.log("First session loaded");
               AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
               this.processURL(this._initialURL);
            }
         }
         else
         {
            this._logger.log("app created fail on interface");
            this._initialURL = "/";
            this.processURL(this._initialURL);
         }
      }
      
      private function onLoginChanged(evt:Event) : void
      {
         var loginConditional:String = null;
         var loginRequired:String = null;
         var premiumLevelRequired:int = 0;
         var siteLevelRequired:int = 0;
         if(this._currentResult && !this._pendingURL)
         {
            loginConditional = this._currentResult.node.@loginConditional;
            loginRequired = this._currentResult.node.@loginRequired;
            premiumLevelRequired = int(this._currentResult.node.@premiumLevelRequired);
            siteLevelRequired = int(this._currentResult.node.@siteLevelRequired);
            if(loginConditional == "true")
            {
               this._logger.log("Resetting page view for login conditional");
               this.processResult(this._currentResult);
            }
            else if(loginRequired == "true")
            {
               if(!AppComponents.model.privateUser.isLoggedIn)
               {
                  this._logger.log("Resetting page view for login required");
                  this.processResult(this._defaultResult);
               }
               else if(AppComponents.model.privateUser.profile.premiumLevel < premiumLevelRequired || AppComponents.model.privateUser.profile.experience.level < siteLevelRequired)
               {
                  this.processResult(this._defaultResult);
               }
            }
         }
      }
      
      protected function onLoginSuccess(event:AsyncEvent) : void
      {
         this.processURL(this._pendingURL);
         this._pendingURL = null;
      }
      
      public function returnToInitialURL() : void
      {
         if(this._initialURL)
         {
            this.processURL(this._initialURL);
         }
      }
      
      public function processURL(url:String) : void
      {
         var filteredURL:String = null;
         var match:Object = null;
         this._logger.log("Parsing",url);
         this._lastURL = url;
         if(url == "")
         {
            this.processResult(this._defaultResult);
         }
         else
         {
            filteredURL = this.prepURL(url);
            filteredURL = this.preFilterURL(filteredURL);
            this._logger.log("Prefiltered to:",filteredURL);
            match = this.matchURL(filteredURL);
            if(match == null)
            {
               filteredURL = this.postFilterURL(filteredURL);
               this._logger.log("Postfiltered to:",filteredURL);
               if(filteredURL != null)
               {
                  match = this.matchURL(filteredURL);
               }
               if(match == null)
               {
                  this._logger.log("No match found");
                  match = this._defaultResult;
               }
               else
               {
                  this._logger.log("Match found on postfiltered url");
               }
            }
            else
            {
               this._logger.log("Match found on prefiltered url");
            }
            this.processResult(match);
         }
      }
      
      protected function prepURL(url:String) : String
      {
         var result:String = url;
         if(result == null)
         {
            return "/";
         }
         result = result.replace(/(\?.+)/,"");
         result = result.replace(/\?$/,"");
         result = result.replace(/\/$/,"");
         result = result.replace(/^#/,"");
         result = result.replace(/^\/#/,"");
         result = unescape(result);
         result = result.replace(/\+/," ");
         if(result.charAt(0) != "/")
         {
            result = "/" + result;
         }
         return result;
      }
      
      protected function preFilterURL(url:String) : String
      {
         var result:String = url;
         if(url.match(/^\/game\/detail/) != null)
         {
            result = url.replace(/\/detail/,"");
         }
         else if(url.match(/^\/profile\/detail/) != null)
         {
            result = url.replace(/\/detail/,"");
         }
         return result;
      }
      
      protected function postFilterURL(url:String) : String
      {
         var result:String = null;
         var id:String = null;
         if(url.match(/^\/\d+/) != null)
         {
            id = url.match(/^\/\d+/)[0];
            this._logger.log("Postfilter found a possible game ",id);
            result = "/game" + id;
         }
         else if(url.match(/^\/[\w ]+/) != null)
         {
            id = url.match(/^\/[\w ]+/)[0];
            this._logger.log("Postfilter found a possible profile ",id);
            result = "/profile" + id;
         }
         return result;
      }
      
      protected function matchURL(url:String) : Object
      {
         var arr:Array = url.replace(/^\//,"").split("/");
         var result:Object = new Object();
         result.searched = new Array();
         result.toSearch = arr;
         result.node = null;
         result.url = url;
         result = this.searchStructureRecursive(this.siteStructure.pages[0],result);
         if(result.node == null)
         {
            return null;
         }
         return result;
      }
      
      protected function searchStructureRecursive(xml:XML, result:Object) : Object
      {
         var currentId:String = null;
         var node:XML = null;
         var subpages:XMLList = null;
         currentId = result.toSearch.shift();
         node = xml.page.(attribute("rule") == currentId)[0];
         if(!this.validNode(node))
         {
            result.toSearch.unshift(currentId);
            return result;
         }
         result.searched.push(currentId);
         subpages = node.page;
         result.node = node;
         if(result.toSearch.length < 1 || subpages.length() < 1)
         {
            return result;
         }
         return this.searchStructureRecursive(node,result);
      }
      
      protected function validNode(node:*) : Boolean
      {
         var dev:String = null;
         var flag:Boolean = true;
         if(node == null)
         {
            flag = false;
         }
         else
         {
            dev = node.@dev;
            if(dev == "true" && AppProperties.debugMode == AppProperties.MODE_NOT_DEBUGGING)
            {
               flag = false;
            }
         }
         return flag;
      }
      
      protected function processRewriteResult(result:Object) : String
      {
         var searched:Array = result.searched;
         var toSearch:Array = result.toSearch;
         var rewrite:String = result.node.@rewrite.toXMLString();
         searched.pop();
         var url:String = "";
         if(rewrite.charAt(0) != "/")
         {
            if(searched.length > 0)
            {
               url = "/" + searched.join("/");
            }
            url = url + "/";
         }
         url = url + rewrite;
         if(toSearch.length > 0)
         {
            url = url + ("/" + toSearch.join("/"));
         }
         this._logger.log("Rewriting to",url);
         return url;
      }
      
      protected function processResult(result:Object) : void
      {
         var isModule:Boolean = false;
         var pageName:String = null;
         var hasSignedUp:Boolean = false;
         var loginEvent:ApplicationEvent = null;
         var signupEvent:ApplicationEvent = null;
         if(result.node.@action == "rewrite")
         {
            this.processURL(this.processRewriteResult(result));
            return;
         }
         try
         {
            this._logger.info("Processing result:",result.searched,"|",result.toSearch,"|",result.node.toXMLString());
         }
         catch(e:Error)
         {
         }
         this._loginResponder = new Responder();
         var loginRequired:String = result.node.@loginRequired;
         var loginConditional:String = result.node.@loginConditional;
         var premiumLevelRequired:int = int(result.node.@premiumLevelRequired);
         var siteLevelRequired:int = int(result.node.@siteLevelRequired);
         isModule = "@isModule" in result.node?Boolean(result.node.@isModule == "true"):Boolean(false);
         var pageCommand:PageCommand = new PageCommand();
         pageCommand.subPath = result.toSearch;
         pageCommand.path = result.searched;
         pageCommand.url = result.url;
         pageCommand.loginConditional = loginConditional == "true";
         this._currentSection = result.node.@rule;
         try
         {
            if(loginConditional == "true")
            {
               if(AppComponents.model.privateUser.isLoggedIn)
               {
                  if(AppComponents.model.privateUser.profile.experience.level < siteLevelRequired)
                  {
                     pageName = "iilwy.display.user.PrivateUserPageView";
                  }
                  else
                  {
                     pageName = result.node.@loginTemplate;
                  }
               }
               else
               {
                  pageName = result.node.@logoutTemplate;
               }
            }
            else
            {
               pageName = result.node.@template;
            }
            pageCommand.pageClassType = getDefinitionByName(pageName) as Class;
         }
         catch(e:Error)
         {
            _logger.warn("No page class type",result.node.toXMLString());
            if(isModule)
            {
               _moduleManager.loadModuleByClassName(pageName,ModuleType.TYPE_PAGEVIEW);
               return;
            }
         }
         try
         {
            if(result.node.@event.toXMLString().length > 0)
            {
               if(result.node.@eventClass.toXMLString().length > 0)
               {
                  try
                  {
                     pageCommand.eventClass = getDefinitionByName(result.node.@eventClass.toXMLString()) as Class;
                  }
                  catch(e:Error)
                  {
                  }
               }
               if(!pageCommand.eventClass)
               {
                  pageCommand.eventClass = ApplicationEvent;
               }
               pageCommand.eventType = result.node.@event;
               pageCommand.eventParam = result.node.@param;
            }
         }
         catch(e:Error)
         {
         }
         if(loginRequired == "true" && !AppComponents.model.privateUser.isLoggedIn)
         {
            if(!AppComponents.pageViewManager.hasPageView)
            {
               this.processResult(this._defaultResult);
            }
            hasSignedUp = AppComponents.localStore.getExpiringObject(LocalProperties.HAS_SIGNED_UP);
            if(hasSignedUp)
            {
               this._loginResponder.addEventListener(AsyncEvent.SUCCESS,this.onLoginSuccess);
               this._pendingURL = result.url;
               loginEvent = new ApplicationEvent(ApplicationEvent.USER_PROMPT_LOGIN);
               loginEvent.responder = this._loginResponder;
               StageReference.stage.dispatchEvent(loginEvent);
            }
            else
            {
               signupEvent = new ApplicationEvent(ApplicationEvent.USER_PROMPT_SIGNUP);
               signupEvent.context = "securepage";
               StageReference.stage.dispatchEvent(signupEvent);
            }
         }
         else if(loginRequired == "true" && AppComponents.model.privateUser.isLoggedIn && (AppComponents.model.privateUser.profile.premiumLevel < premiumLevelRequired || AppComponents.model.privateUser.profile.experience.level < siteLevelRequired))
         {
            this.processResult(this._defaultResult);
         }
         else
         {
            if(pageCommand.pageClassType != null)
            {
               this._currentResult = result;
            }
            this.processPageCommand(pageCommand);
         }
      }
      
      public function processPageCommand(pageCommand:PageCommand) : void
      {
         var evt:* = undefined;
         var layoutEvt:ApplicationEvent = null;
         this._currentPageCommand = pageCommand;
         if(pageCommand.eventType != null)
         {
            evt = new pageCommand.eventClass(pageCommand.eventClass[pageCommand.eventType]);
            if(evt.hasOwnProperty("data"))
            {
               evt["data"] = pageCommand.eventParam;
            }
            if(evt.hasOwnProperty("pageCommand"))
            {
               evt["pageCommand"] = pageCommand;
            }
            StageReference.stage.dispatchEvent(evt);
            if(AppComponents.pageViewManager.hasPageView)
            {
            }
         }
         else if(pageCommand.pageClassType != null)
         {
            AppComponents.pageViewManager.processPageCommand(pageCommand);
            layoutEvt = new ApplicationEvent(ApplicationEvent.LAYOUT_CHANGED);
            layoutEvt.pageCommand = pageCommand;
            StageReference.stage.dispatchEvent(layoutEvt);
         }
      }
      
      private function addExternalInterface() : void
      {
         this._externalInterfaceTimer = new Timer(500,8);
         this._externalInterfaceTimer.addEventListener(TimerEvent.TIMER,this.onExternalInterfaceTimer);
         this._externalInterfaceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onExternalInterfaceTimerComplete);
         this._externalInterfaceTimer.start();
      }
      
      protected function onExternalInterfaceTimerComplete(evt:TimerEvent) : void
      {
         this.appCreated(true,"/");
      }
      
      protected function onExternalInterfaceTimer(evt:TimerEvent) : void
      {
         var histStr:String = null;
         var locStr:String = null;
         if(ExternalInterface.available && this._swfAddressInited)
         {
            try
            {
               ExternalInterface.addCallback("flashOnBeforeUnload",this.onBeforeUnload);
            }
            catch(e:Error)
            {
               _logger.error(e);
            }
            try
            {
               SWFAddress.onChange = this.gotHistoryFromJS;
            }
            catch(e:Error)
            {
               _logger.error(e);
            }
            try
            {
               this._refractoryTimer.start();
               histStr = SWFAddress.getPath();
               this._logger.log("Found initial history",histStr);
            }
            catch(e:Error)
            {
               _logger.error(e);
            }
            try
            {
               locStr = ExternalInterface.call("window.location.href.toString");
               if(!AppProperties.appVersionIsWebsiteOrAIR)
               {
                  AppComponents.analytics.trackPageView("externalView/" + locStr);
               }
            }
            catch(e:Error)
            {
               _logger.error(e);
            }
            this._externalInterfaceTimer.stop();
            if(this._forcedInitialURL)
            {
               this.appCreated(true,this._forcedInitialURL);
            }
            else if(histStr)
            {
               this.appCreated(true,histStr);
            }
            else
            {
               this.appCreated(true,"/");
            }
         }
      }
      
      private function arePathsEqual(path1:String, path2:String) : Boolean
      {
         if(path1)
         {
            path1 = path1.replace(/[^a-zA-Z0-9]/gi,"");
         }
         if(path2)
         {
            path2 = path2.replace(/[^a-zA-Z0-9]/gi,"");
         }
         this._logger.log("Testing equivalence",path1,path2);
         if(path1 == path2)
         {
            return true;
         }
         return false;
      }
      
      private function gotHistoryFromJS() : void
      {
         var path:String = SWFAddress.getPath();
         this._logger.log("Got history from JS",path,"last url",this._lastURLSentToJS,this._refractoryTimer.running);
         if(this._refractoryTimer.running || this.arePathsEqual(path,this._lastURLSentToJS))
         {
            this._lastURLSentToJS = null;
            this._logger.log("Block timer running");
         }
         else
         {
            this._logger.log("Block timer not running");
            this.processURL(path);
         }
      }
      
      public function sendHistoryToJS(path:String) : void
      {
         if(!this._enableHistoryManagement)
         {
            return;
         }
         this._lastURLSentToJS = path;
         this._logger.log("Setting history",path);
         try
         {
            SWFAddress.setValue(path);
         }
         catch(e:Error)
         {
         }
         try
         {
            ExternalInterface.call("refocusFlash");
         }
         catch(e:Error)
         {
         }
         try
         {
            ExternalInterface.call("function() { if( OMG.outer_ads_enabled ) OMG.swfPageChanged(\'" + path + "\'); }");
         }
         catch(e:Error)
         {
         }
      }
      
      private function onBeforeUnload(... args) : String
      {
         this._logger.log("externalInterface / onBeforeUnload");
         var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.BEFORE_UNLOAD);
         StageReference.stage.dispatchEvent(evt);
         return "";
      }
      
      public function assertValidState() : void
      {
         if(!AppComponents.pageViewManager.hasPageView)
         {
            this.processResult(this._defaultResult);
         }
      }
      
      public function set siteStructure(v:XML) : void
      {
         this._siteStructure = v;
      }
      
      public function get siteStructure() : XML
      {
         return this._siteStructure;
      }
      
      private function onModuleLoaded(event:ModuleManagerEvent) : void
      {
         this.processURL(this._lastURL);
      }
   }
}
