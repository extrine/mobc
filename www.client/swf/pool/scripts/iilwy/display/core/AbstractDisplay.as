package iilwy.display.core
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.system.Capabilities;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.debug.Console;
   import iilwy.debug.FPSMeter;
   import iilwy.debug.TestActions;
   import iilwy.display.Background;
   import iilwy.display.arcade.ArcadePlayerThumbnail;
   import iilwy.display.market.PriceIndicator;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.ui.containers.Window;
   import iilwy.ui.controls.TextInput;
   import iilwy.utils.FullScreenUtil;
   import iilwy.utils.logging.Logger;
   
   public class AbstractDisplay extends Sprite
   {
       
      
      protected var debugTools:Boolean = false;
      
      protected var consoleWindow:Window;
      
      protected var console:Console;
      
      protected var fps:FPSMeter;
      
      protected var testerWindow:Window;
      
      protected var tester:TestActions;
      
      protected var _debugToolsBuilt:Boolean = false;
      
      public var background:Background;
      
      private var _layers:Object;
      
      public function AbstractDisplay()
      {
         this._layers = {};
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         if(event.target == this)
         {
            this.handleBrowserHacks();
            this.setupLayers();
            this.registerPopups();
            this.registerPageViews();
            this.registerExtraClasses();
            FullScreenUtil.stageReference = stage;
            this.createChildren();
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         }
      }
      
      private function handleBrowserHacks() : void
      {
         var version:Array = Capabilities.version.split(" ");
         var os:String = version[0];
         version = version[1].split(",");
         var majorv:String = version[0];
         var minorv:String = version[1];
         var build:String = version[2];
         var ibuild:String = version[3];
         if(os == "MAC")
         {
            TextInput.disableEmbedding();
         }
      }
      
      protected function registerPopups() : void
      {
      }
      
      protected function registerPageViews() : void
      {
      }
      
      protected function registerExtraClasses() : void
      {
         ArcadePlayerThumbnail(null);
         PriceIndicator(null);
      }
      
      public function getLayer(id:String) : Sprite
      {
         return this._layers[id];
      }
      
      protected function addLayer(id:String) : Sprite
      {
         var layer:Sprite = null;
         if(this._layers[id] == null)
         {
            this._layers[id] = new Sprite();
         }
         layer = this._layers[id];
         addChild(layer);
         return layer;
      }
      
      protected function setupLayers() : void
      {
         this.addLayer("background");
         this.addLayer("panes");
         this.addLayer("ui");
         this.addLayer("event");
         this.addLayer("chat");
         this.addLayer("feedback");
         this.addLayer("ticker");
         this.addLayer("fullScreen");
         this.addLayer("live");
         this.addLayer("nav");
         this.addLayer("searchbox");
         this.addLayer("popupmanager");
         this.addLayer("popupmanager-info");
         this.addLayer("popupmanager-floating");
         this.addLayer("popupmanager-dialog");
         this.addLayer("eventnotifications");
         this.addLayer("popupmanager-info-forfloating");
         this.addLayer("contextmenu");
         this.addLayer("popupmanager-combobox");
         this.addLayer("notificationManager");
         this.addLayer("alertManager");
         this.addLayer("tooltips");
         this.addLayer("focus-manager");
         this.addLayer("dragdrop-manager");
         this.getLayer("dragdrop-manager").mouseChildren = false;
         this.getLayer("dragdrop-manager").mouseEnabled = false;
         this.getLayer("dragdrop-manager").buttonMode = false;
         this.addLayer("top");
         this.addLayer("particle");
      }
      
      public function buildDebugTools() : void
      {
         if(this._debugToolsBuilt)
         {
            return;
         }
         if(this.debugTools || AppComponents.model.privateUser.profile.premiumLevel >= PremiumLevels.CREW || AppProperties.debugMode == AppProperties.MODE_LOCAL_DEBUGGING || AppProperties.debugMode == AppProperties.MODE_REMOTE_DEBUGGING)
         {
            this._debugToolsBuilt = true;
            this.console = new Console();
            this.consoleWindow = new Window("console",20,50,600,500);
            this.consoleWindow.setModule(this.console);
            AppComponents.popupManager.centerWindow(this.consoleWindow);
            Logger.console = this.console;
            this.tester = new TestActions();
            this.testerWindow = new Window("testActions",100,50,400,300);
            this.testerWindow.setModule(this.tester);
            this.fps = new FPSMeter();
            this.getLayer("top").addChild(this.fps);
         }
      }
      
      public function showDebugTools() : void
      {
         AppComponents.popupManager.addFloatingWindow(this.consoleWindow);
         this.consoleWindow.minimize();
         if(AppComponents.model.privateUser.profile.premiumLevel >= PremiumLevels.CREW)
         {
            AppComponents.popupManager.addFloatingWindow(this.testerWindow);
            this.testerWindow.minimize();
            this.getLayer("top").addChild(this.fps);
         }
      }
      
      protected function createChildren() : void
      {
         stage.frameRate = 61;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.stageFocusRect = false;
         this.focusRect = null;
      }
   }
}
