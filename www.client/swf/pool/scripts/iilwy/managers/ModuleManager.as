package iilwy.managers
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import iilwy.application.AppProperties;
   import iilwy.events.ModuleManagerEvent;
   import iilwy.model.dataobjects.module.ModuleType;
   import iilwy.ui.controls.ModuleLoader;
   import iilwy.utils.logging.Logger;
   
   public class ModuleManager extends EventDispatcher
   {
      
      private static var __instance:ModuleManager;
       
      
      public var baseURL:String;
      
      private var moduleDict:Dictionary;
      
      private var logger:Logger;
      
      public function ModuleManager(target:IEventDispatcher = null)
      {
         this.baseURL = AppProperties.fileServerFlashOrLocal + "modules/";
         super(target);
         this.moduleDict = new Dictionary();
         this.logger = new Logger("ModuleManager");
      }
      
      public static function getInstance() : ModuleManager
      {
         if(!__instance)
         {
            __instance = new ModuleManager();
         }
         return __instance;
      }
      
      public function loadModule(moduleID:String, moduleType:ModuleType) : void
      {
         var loadEvent:ModuleManagerEvent = null;
         var loader:ModuleLoader = null;
         if(this.getModule(moduleID))
         {
            loadEvent = new ModuleManagerEvent(ModuleManagerEvent.MODULE_LOADED,true);
            loadEvent.module = this.getModule(moduleID);
            dispatchEvent(loadEvent);
            this.logger.log("Loading " + moduleID + " (cached)");
         }
         else
         {
            loader = new ModuleLoader();
            loader.moduleID = moduleID;
            loader.addEventListener(Event.COMPLETE,this.onModuleLoad);
            loader.addEventListener(ErrorEvent.ERROR,this.onModuleLoadError);
            loader.load(this.baseURL + moduleType.directory + "/" + moduleID + ".swf");
            this.logger.log("Loading " + moduleID);
         }
      }
      
      public function loadModuleByClassName(className:String, moduleType:ModuleType) : void
      {
         var moduleID:String = className.substr(className.lastIndexOf(".") + 1);
         this.loadModule(moduleID,moduleType);
      }
      
      private function onModuleLoad(event:Event) : void
      {
         var module:ModuleLoader = ModuleLoader(event.target);
         this.moduleDict[ModuleLoader(event.target).moduleID] = module;
         var loadEvent:ModuleManagerEvent = new ModuleManagerEvent(ModuleManagerEvent.MODULE_LOADED,true);
         loadEvent.module = module;
         dispatchEvent(loadEvent);
      }
      
      private function onModuleLoadError(event:ErrorEvent) : void
      {
         var errorEvent:ModuleManagerEvent = new ModuleManagerEvent(ModuleManagerEvent.MODULE_LOAD_ERROR,true);
         dispatchEvent(errorEvent);
      }
      
      public function getModule(moduleID:String) : ModuleLoader
      {
         return this.moduleDict[moduleID];
      }
   }
}
