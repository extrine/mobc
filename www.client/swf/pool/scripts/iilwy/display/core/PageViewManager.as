package iilwy.display.core
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import iilwy.application.AppComponents;
   import iilwy.data.PageCommand;
   import iilwy.display.layout.IPageView;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ConfirmationWindowEvent;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.MathUtil;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class PageViewManager
   {
       
      
      private var _currentPageView:IPageView;
      
      private var _nextPageView:IPageView;
      
      private var _confirmPageCommand:PageCommand;
      
      private var _pendingPageCommand:PageCommand;
      
      private var _pageViewLookup:Object;
      
      private var _pageViewConstraints:Rectangle;
      
      private var _inTransition:Boolean = false;
      
      private var _deferredUpdateTimer:Timer;
      
      private var _logger:Logger;
      
      public var padding:Margin;
      
      public var allowBeforeUnload:Boolean = true;
      
      public var trackPageViews:Boolean = true;
      
      protected var _showNextPageViewTimer:Timer;
      
      public function PageViewManager()
      {
         this._pageViewLookup = {};
         super();
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.ERROR;
         this.padding = new Margin(30,70,30,60);
         WindowManager.addEventListener(Event.RESIZE,this.onResize);
         this._deferredUpdateTimer = new Timer(400,1);
         this._deferredUpdateTimer.addEventListener(TimerEvent.TIMER,this.onDeferredUpdateTimer);
         this._showNextPageViewTimer = new Timer(10,1);
         this._showNextPageViewTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShowNextTimerComplete);
      }
      
      public function get hasPageView() : Boolean
      {
         return this._currentPageView != null;
      }
      
      public function processPageCommand(pageCommand:PageCommand) : void
      {
         var msg:String = null;
         if(this._currentPageView != null && this.allowBeforeUnload)
         {
            msg = this._currentPageView.onBeforeUnload();
            if(msg && msg.length > 0 && (!this._pendingPageCommand || this._pendingPageCommand.pageClassType != pageCommand.pageClassType))
            {
               this._confirmPageCommand = pageCommand;
               AppComponents.popupManager.showConfirmation(this.onConfirm,"Do you really want to leave this page?",msg,null,"Yes","No");
               return;
            }
         }
         AppComponents.localStore.flushQueuedObjects();
         this.doProcessPageCommand(pageCommand);
      }
      
      public function onConfirm(event:ConfirmationWindowEvent) : void
      {
         if(event.type == ConfirmationWindowEvent.YES)
         {
            this.doProcessPageCommand(this._confirmPageCommand);
            this._confirmPageCommand = null;
         }
      }
      
      public function doProcessPageCommand(pageCommand:PageCommand) : void
      {
         var trackingURL:String = null;
         var ClassReference:Class = null;
         this._logger.log("current: ",this._currentPageView);
         if(this._inTransition)
         {
            return;
         }
         this._inTransition = true;
         this._deferredUpdateTimer.stop();
         AppComponents.contextMenuManager.hide();
         AppComponents.tooltipManager.hideTooltip();
         if(this.trackPageViews)
         {
            trackingURL = pageCommand.url;
            if(pageCommand.loginConditional)
            {
               trackingURL = trackingURL + (trackingURL.charAt(trackingURL.length - 1) != "/"?"/":"");
               trackingURL = trackingURL + (!!AppComponents.model.privateUser.isLoggedIn?"logged_in":"logged_out");
            }
            AppComponents.stateManager.sendHistoryToJS(pageCommand.url);
            AppComponents.analytics.trackPageView(trackingURL);
         }
         var typeOfLayout:String = getQualifiedClassName(pageCommand.pageClassType);
         var _instanceIdentifierString:String = typeOfLayout;
         this._nextPageView = this._pageViewLookup[_instanceIdentifierString];
         if(this._currentPageView == this._nextPageView && this._nextPageView != null)
         {
            this._currentPageView._processPageCommand(pageCommand);
            this.allowBeforeUnload = true;
            this._nextPageView = null;
            this._inTransition = false;
         }
         else
         {
            if(this._nextPageView == null)
            {
               ClassReference = getDefinitionByName(typeOfLayout) as Class;
               this._nextPageView = new ClassReference();
               this._nextPageView.init();
               this._pageViewLookup[_instanceIdentifierString] = this._nextPageView;
            }
            if(this._currentPageView != null)
            {
               this._currentPageView._hide();
               AppComponents.display.getLayer("panes").removeChild(this._currentPageView.asUiContainer());
            }
            this._currentPageView = this._nextPageView;
            this._pendingPageCommand = pageCommand;
            this._showNextPageViewTimer.reset();
            this._showNextPageViewTimer.start();
         }
      }
      
      protected function onShowNextTimerComplete(event:TimerEvent) : void
      {
         StageReference.stage.frameRate = 61;
         this.constrainPageView();
         AppComponents.display.getLayer("panes").addChild(this._currentPageView.asUiContainer());
         this._currentPageView._show();
         this._currentPageView._processPageCommand(this._pendingPageCommand);
         this._pendingPageCommand = null;
         this._confirmPageCommand = null;
         this.allowBeforeUnload = true;
         this._nextPageView = null;
         this._inTransition = false;
      }
      
      public function onResize(event:Event) : void
      {
         if(this._inTransition)
         {
            return;
         }
         this._deferredUpdateTimer.reset();
         this._deferredUpdateTimer.start();
      }
      
      protected function onDeferredUpdateTimer(event:TimerEvent) : void
      {
         this.constrainPageView();
      }
      
      protected function constrainPageView() : void
      {
         var view:UiContainer = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         if(this._currentPageView is PageView)
         {
            view = this._currentPageView.asUiContainer();
            w = Math.round(WindowManager.width - this.padding.left - this.padding.right - view.padding.horizontal);
            h = Math.round(WindowManager.height - this.padding.top - this.padding.bottom - view.padding.vertical);
            view.width = MathUtil.clamp(view.minWidth,view.maxWidth,w);
            view.height = MathUtil.clamp(view.minHeight,view.maxHeight,h);
            view.invalidateSize();
            view.invalidateDisplayList();
            x = Math.round(WindowManager.width / 2 - this._currentPageView.asUiContainer().width / 2);
            y = this.padding.top + Math.round((WindowManager.height - this.padding.top - this.padding.bottom) / 2 - this._currentPageView.asUiContainer().height / 2);
            this._currentPageView.asUiContainer().x = x;
            this._currentPageView.asUiContainer().y = Math.max(this.padding.top,y);
         }
      }
      
      public function clearPage() : void
      {
         this.trackPageViews = false;
         var pageCommand:PageCommand = new PageCommand();
         pageCommand.url = "blank";
         pageCommand.pageClassType = BlankPageView;
         this.doProcessPageCommand(pageCommand);
         this.trackPageViews = true;
      }
   }
}
