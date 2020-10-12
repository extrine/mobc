package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.debug.Console;
   import iilwy.events.PopupManagerEvent;
   import iilwy.ui.containers.IModule;
   import iilwy.ui.containers.InfoWindow;
   import iilwy.ui.containers.ModuleContainer;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.containers.Window;
   import iilwy.ui.controls.ConfirmationWindow;
   import iilwy.ui.controls.ErrorWindow;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.MathUtil;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class PopupManager extends EventDispatcher
   {
      
      public static const DEFAULT_WINDOW_CONSTRAINT_PADDING:Margin = new Margin(30,65,30,50);
       
      
      private var _mainLayer:Sprite;
      
      private var _floatingWindowLayer:Sprite;
      
      private var _dialogLayer:Sprite;
      
      private var _comboboxLayer:Sprite;
      
      private var _infoWindowLayer:Sprite;
      
      private var _infoWindowForFloatingLayer:Sprite;
      
      private var _blocker:Sprite;
      
      private var _dimmer:Sprite;
      
      private var _minimizedWindows:Array;
      
      public var floatingWindowConstraints:Rectangle;
      
      protected var _windowConstraintPadding:Margin;
      
      public var _confirmationWindow:ConfirmationWindow;
      
      public var _errorWindow:ErrorWindow;
      
      private var _popupQueue:PopupQueue;
      
      public var automatePopupQueue:Boolean;
      
      public var _temporaryWindowFactory:ItemFactory;
      
      public var _temporaryWindows:Array;
      
      public var _singletonPopupRegistry:Object;
      
      public var minimizedWindowLocation:Point;
      
      public var dialogCount:uint = 0;
      
      public var floatingCount:uint = 0;
      
      public var floatingRect:Rectangle;
      
      public function PopupManager()
      {
         this._minimizedWindows = [];
         this._windowConstraintPadding = DEFAULT_WINDOW_CONSTRAINT_PADDING;
         this._singletonPopupRegistry = {};
         this.minimizedWindowLocation = new Point(10,90);
         this.floatingRect = new Rectangle();
         super();
         this._popupQueue = new PopupQueue();
         this._temporaryWindowFactory = new ItemFactory(Window);
         this._temporaryWindows = new Array();
         this._floatingWindowLayer = AppComponents.display.getLayer("popupmanager-floating");
         this._mainLayer = AppComponents.display.getLayer("popupmanager");
         this._dialogLayer = AppComponents.display.getLayer("popupmanager-dialog");
         this._comboboxLayer = AppComponents.display.getLayer("popupmanager-combobox");
         this._infoWindowLayer = AppComponents.display.getLayer("popupmanager-info");
         this._infoWindowForFloatingLayer = AppComponents.display.getLayer("popupmanager-info-forfloating");
         this._dialogLayer.mouseEnabled = false;
         this._floatingWindowLayer.addEventListener(UiEvent.FOCUS,this.onWindowFocus);
         this._floatingWindowLayer.addEventListener(ContainerEvent.MINIMIZE,this.onWindowMinimize);
         this._floatingWindowLayer.addEventListener(ContainerEvent.MAXIMIZE,this.onWindowMaximize);
         this._floatingWindowLayer.addEventListener(ContainerEvent.DESTROY,this.onWindowDestroy);
         this._floatingWindowLayer.addEventListener(ContainerEvent.CLOSE,this.onWindowClose);
         this._infoWindowLayer.addEventListener(ContainerEvent.CLOSE,this.onInfoWindowClose);
         this._infoWindowForFloatingLayer.addEventListener(ContainerEvent.CLOSE,this.onInfoWindowClose);
         this._dialogLayer.addEventListener(ContainerEvent.CLOSE,this.onDialogClose);
         this._dialogLayer.addEventListener(ContainerEvent.RESIZE,this.onDialogResize);
         this._dialogLayer.addEventListener(ContainerEvent.DESTROY,this.onDialogDestroy);
         this._confirmationWindow = new ConfirmationWindow();
         this._errorWindow = new ErrorWindow();
         this._blocker = new Sprite();
         UiRender.renderRect(this._blocker,33488896,0,0,100,100);
         this._blocker.mouseEnabled = true;
         this._dimmer = new Sprite();
         UiRender.renderRect(this._dimmer,3422552064,0,0,100,100);
         this._dimmer.mouseEnabled = false;
         this._dimmer.mouseChildren = false;
         this.floatingWindowConstraints = new Rectangle(0,0,100,100);
         this.updateConstraints();
         WindowManager.getInstance().addEventListener(Event.RESIZE,this.onApplicationResize);
         this.onApplicationResize();
      }
      
      public function get windowConstraintPadding() : Margin
      {
         return this._windowConstraintPadding;
      }
      
      public function set windowConstraintPadding(m:Margin) : void
      {
         this._windowConstraintPadding = m;
         this.updateConstraints();
      }
      
      private function updateConstraints() : void
      {
         this.floatingWindowConstraints.x = this._windowConstraintPadding.left;
         this.floatingWindowConstraints.y = this._windowConstraintPadding.top;
         this.floatingWindowConstraints.width = WindowManager.width - this._windowConstraintPadding.left - this._windowConstraintPadding.right;
         this.floatingWindowConstraints.height = WindowManager.height - this._windowConstraintPadding.top - this._windowConstraintPadding.bottom;
      }
      
      public function addComboBoxMenu(sprite:Sprite) : Sprite
      {
         this._comboboxLayer.addChild(sprite);
         return sprite;
      }
      
      public function removeComboBoxMenu(sprite:Sprite) : Sprite
      {
         this._comboboxLayer.removeChild(sprite);
         return sprite;
      }
      
      public function constrainComboBoxMenu(sprite:Sprite) : void
      {
         sprite.x = Math.min(sprite.x,this.floatingWindowConstraints.right - sprite.width);
         sprite.y = Math.min(sprite.y,this.floatingWindowConstraints.bottom - sprite.height);
      }
      
      public function addFloatingWindow(sprite:Sprite) : Sprite
      {
         this._floatingWindowLayer.addChild(sprite);
         this.constrainWindow(sprite);
         this.countFloatingWindows();
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.FLOATING_ADDED));
         return sprite;
      }
      
      public function removeFloatingWindow(sprite:Sprite) : Sprite
      {
         if(this._floatingWindowLayer.contains(sprite))
         {
            this._floatingWindowLayer.removeChild(sprite);
         }
         this.countFloatingWindows();
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.FLOATING_REMOVED));
         return sprite;
      }
      
      public function addDialogWindow(window:Sprite) : Sprite
      {
         this._dialogLayer.addChild(window);
         this.centerWindow(window);
         this.constrainWindow(window);
         this.updateBlocker();
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.DIALOG_ADDED));
         return window;
      }
      
      public function removeDialogWindow(sprite:Sprite) : Sprite
      {
         if(this._dialogLayer.contains(sprite))
         {
            this._dialogLayer.removeChild(sprite);
         }
         this.updateBlocker();
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.DIALOG_REMOVED));
         return sprite;
      }
      
      private function countFloatingWindows() : void
      {
         var win:DisplayObject = null;
         var l:Number = this._floatingWindowLayer.numChildren;
         this.floatingCount = 0;
         this.floatingRect = new Rectangle();
         for(var i:Number = 0; i < l; i++)
         {
            win = this._floatingWindowLayer.getChildAt(i);
            try
            {
               if(win is UiElement && this._minimizedWindows.indexOf(win) < 0)
               {
                  this.floatingRect = this.floatingRect.union(new Rectangle(win.x,win.y,win.width,win.height));
                  this.floatingCount++;
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function updateBlocker() : void
      {
         var obj:DisplayObject = null;
         var win:* = undefined;
         if(this._blocker.stage != null)
         {
            this._dialogLayer.removeChild(this._blocker);
         }
         if(this._dimmer.stage != null)
         {
            this._dialogLayer.removeChild(this._dimmer);
         }
         var l:Number = this._dialogLayer.numChildren;
         var blockIndex:Number = -1;
         var dimIndex:Number = -1;
         this.dialogCount = 0;
         for(var i:Number = 0; i < l; i++)
         {
            obj = this._dialogLayer.getChildAt(i);
            try
            {
               win = obj;
               if(win.blockBelow)
               {
                  blockIndex = i;
               }
               if(win.dimBelow)
               {
                  dimIndex = i;
                  blockIndex = i;
               }
               if(win is UiElement)
               {
                  this.dialogCount++;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(dimIndex >= 0)
         {
            this._dialogLayer.addChildAt(this._dimmer,dimIndex);
            if(dimIndex <= blockIndex && blockIndex >= 0)
            {
               blockIndex++;
            }
         }
         if(blockIndex >= 0)
         {
            this._dialogLayer.addChildAt(this._blocker,blockIndex);
         }
      }
      
      public function setWindowPosition(window:Sprite, x:Number, y:Number, relativeTo:DisplayObject) : void
      {
         var pos:Point = new Point(x,y);
         pos = relativeTo.localToGlobal(pos);
         pos = this._mainLayer.globalToLocal(pos);
         window.x = pos.x;
         window.y = pos.y;
      }
      
      public function addInfoWindow(sprite:Sprite, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : Sprite
      {
         var uilayer:Sprite = AppComponents.display.getLayer("ui");
         var floatingTarget:Boolean = false;
         if(target == null)
         {
            floatingTarget = true;
         }
         else if(this._dialogLayer.contains(target) || this._floatingWindowLayer.contains(target) || uilayer.contains(target))
         {
            floatingTarget = true;
         }
         if(floatingTarget)
         {
            this._infoWindowForFloatingLayer.addChild(sprite);
            try
            {
               InfoWindow(sprite).requestFocus();
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            this._infoWindowLayer.addChild(sprite);
            try
            {
               InfoWindow(sprite).requestFocus();
            }
            catch(e:Error)
            {
            }
         }
         if(target != null)
         {
            InfoWindow(sprite).setPosition(target,method,x,y);
         }
         return sprite;
      }
      
      public function removeInfoWindow(sprite:Sprite) : Sprite
      {
         try
         {
            this._infoWindowLayer.removeChild(sprite);
         }
         catch(e:Error)
         {
         }
         try
         {
            this._infoWindowForFloatingLayer.removeChild(sprite);
         }
         catch(e:Error)
         {
         }
         return sprite;
      }
      
      public function showConfirmation(callback:Function = null, header:String = null, message:String = null, checkboxLabel:String = null, yesLabel:String = "OK", noLabel:String = "Cancel", buttonOrder:String = null) : ConfirmationWindow
      {
         this._confirmationWindow.header = header;
         this._confirmationWindow.message = message;
         this._confirmationWindow.yesLabel = yesLabel;
         this._confirmationWindow.noLabel = noLabel;
         this._confirmationWindow.checkboxLabel = checkboxLabel;
         this._confirmationWindow.blockBelow = true;
         this._confirmationWindow.dimBelow = true;
         this._confirmationWindow.callback = callback;
         this._confirmationWindow.buttonOrder = buttonOrder;
         this.addDialogWindow(this._confirmationWindow);
         return this._confirmationWindow;
      }
      
      public function hideConfirmation() : void
      {
         this.removeDialogWindow(this._confirmationWindow);
      }
      
      public function showError(header:String = null, message:String = null, buttonLabel:String = "OK") : ErrorWindow
      {
         this._errorWindow.header = header;
         this._errorWindow.message = message;
         this._errorWindow.buttonLabel = buttonLabel;
         this._errorWindow.blockBelow = true;
         this._errorWindow.dimBelow = true;
         this.addDialogWindow(this._errorWindow);
         return this._errorWindow;
      }
      
      public function centerWindow(window:Sprite) : void
      {
         var p:Margin = this._windowConstraintPadding;
         var w:Number = WindowManager.width - p.left - p.right;
         var h:Number = WindowManager.height - p.top - p.bottom;
         var x:Number = p.left + Math.floor(w / 2 - window.width / 2);
         var y:Number = Math.max(2,p.top + Math.floor(h / 2 - window.height / 2));
         window.x = x;
         window.y = y;
      }
      
      public function minimizeAllFloatingWindows() : void
      {
      }
      
      public function minimizeFloatingWindow() : void
      {
      }
      
      public function maximizeFloatingWindow() : void
      {
      }
      
      private function onInfoWindowClose(event:ContainerEvent) : void
      {
         this.removeInfoWindow(event.container);
      }
      
      private function onWindowFocus(event:UiEvent) : void
      {
         this._floatingWindowLayer.addChildAt(event.element,this._floatingWindowLayer.numChildren);
      }
      
      private function onWindowDestroy(event:ContainerEvent) : void
      {
         this.removeFloatingWindow(Window(event.target));
      }
      
      private function onWindowClose(event:ContainerEvent) : void
      {
         this.removeFloatingWindow(event.container);
         var index:Number = this._minimizedWindows.indexOf(event.container);
         if(index >= 0)
         {
            this._minimizedWindows.splice(index,1);
            this.updateMinimizedWindows(event.container);
         }
         this.recyleIfTemporaryWindow(event.container as Window);
         AppComponents.localStore.flushQueuedObjects();
      }
      
      private function onWindowAutoRemove(event:ContainerEvent) : void
      {
      }
      
      private function onWindowMinimize(event:ContainerEvent) : void
      {
         var index:Number = this._minimizedWindows.indexOf(event.container);
         if(index >= 0)
         {
            this._minimizedWindows.splice(index,1);
         }
         this._minimizedWindows.push(event.container);
         this.updateMinimizedWindows(event.container);
         this.countFloatingWindows();
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.FLOATING_REMOVED));
      }
      
      private function onWindowMaximize(event:ContainerEvent) : void
      {
         var index:Number = this._minimizedWindows.indexOf(event.container);
         if(index >= 0)
         {
            this._minimizedWindows.splice(index,1);
            this.addFloatingWindow(event.container as Sprite);
            this.updateMinimizedWindows();
         }
      }
      
      private function updateMinimizedWindows(ignore:UiContainer = null) : void
      {
         var win:Window = null;
         var x:Number = this.minimizedWindowLocation.x;
         for(var i:Number = 0; i < this._minimizedWindows.length; i++)
         {
            win = this._minimizedWindows[i] as Window;
            win.minimizedDimensions.x = x;
            win.minimizedDimensions.y = WindowManager.height - this.minimizedWindowLocation.y;
            win.minimizedDimensions.width = 200;
            if(win != ignore)
            {
               win.x = win.minimizedDimensions.x;
               win.y = win.minimizedDimensions.y;
            }
            x = x + (200 + 5);
         }
      }
      
      private function onDialogResize(event:ContainerEvent) : void
      {
         if(event.container is Window)
         {
            if(Window(event.container).autoCenter)
            {
               this.centerWindow(event.target as Sprite);
            }
         }
      }
      
      private function onDialogClose(event:ContainerEvent) : void
      {
         var popup:IModule = null;
         this.removeDialogWindow(event.container);
         this.updateBlocker();
         if(this._dialogLayer.numChildren == 0)
         {
            AppComponents.stateManager.assertValidState();
         }
         this.recyleIfTemporaryWindow(event.container as Window);
         AppComponents.localStore.flushQueuedObjects();
         if(this.automatePopupQueue)
         {
            if(this.currentPopupQueueItem)
            {
               popup = AppComponents.popupManager.getSingletonPopupModule(this.currentPopupQueueItem.id);
            }
            if(!popup || !DisplayObject(popup).stage)
            {
               this.openNextPopup();
            }
         }
      }
      
      private function onDialogDestroy(event:ContainerEvent) : void
      {
         this.removeDialogWindow(Window(event.target));
         this.updateBlocker();
      }
      
      private function onDialogAutoRemove(event:ContainerEvent) : void
      {
      }
      
      private function onApplicationResize(event:Event = null) : void
      {
         this._blocker.width = WindowManager.width;
         this._blocker.height = WindowManager.height;
         this._dimmer.width = WindowManager.width;
         this._dimmer.height = WindowManager.height;
         this.constrainWindows();
         this.updateMinimizedWindows();
         this.updateConstraints();
      }
      
      private function constrainWindows() : void
      {
         var dObj:DisplayObject = null;
         var l:Number = this._floatingWindowLayer.numChildren;
         for(var i:Number = 0; i < l; i++)
         {
            dObj = this._floatingWindowLayer.getChildAt(i);
            if(dObj is Window)
            {
               this.constrainWindow(dObj as Window);
            }
         }
         l = this._dialogLayer.numChildren;
         for(i = 0; i < l; i++)
         {
            dObj = this._dialogLayer.getChildAt(i);
            if(dObj is Window)
            {
               this.constrainWindow(dObj as Window);
               this.centerWindow(dObj as Sprite);
            }
         }
      }
      
      private function constrainWindow(sprite:Sprite) : void
      {
         var w:Window = null;
         if(sprite is Window)
         {
            w = sprite as Window;
            w.x = Math.min(w.x,this.floatingWindowConstraints.right);
            w.y = Math.min(w.y,this.floatingWindowConstraints.bottom);
            if(w.resizable)
            {
               w.height = MathUtil.clamp(w.minHeight,this.floatingWindowConstraints.height,w.height);
               w.width = MathUtil.clamp(w.minWidth,this.floatingWindowConstraints.width,w.width);
            }
            return;
         }
      }
      
      public function createTemporaryWindow() : Window
      {
         var win:Window = this._temporaryWindowFactory.createItem();
         win.initialize();
         this._temporaryWindows.push(win);
         return win;
      }
      
      public function recyleIfTemporaryWindow(window:Window) : void
      {
         var index:Number = this._temporaryWindows.indexOf(window);
         if(index >= 0)
         {
            this._temporaryWindows.splice(index,1);
            ModuleContainer(window).setModule(null);
            this._temporaryWindowFactory.recycleItem(window);
         }
      }
      
      public function closeSingletonPopup(id:String, force:Boolean = false) : void
      {
         var closeEvent:ContainerEvent = null;
         var popup:IModule = AppComponents.popupManager.getSingletonPopupModule(id);
         if(popup && DisplayObject(popup).stage)
         {
            closeEvent = new ContainerEvent(ContainerEvent.CLOSE,true);
            closeEvent.force = force;
            EventDispatcher(popup).dispatchEvent(closeEvent);
         }
      }
      
      public function getSingletonPopupConfig(id:String) : XML
      {
         var lookup:XML = null;
         var match:XMLList = null;
         var config:XML = null;
         lookup = AppComponents.stringManager.popups;
         match = lookup.popups.popup.(attribute("id") == id);
         if(match != null && match[0] != null)
         {
            config = match[0];
         }
         return config;
      }
      
      public function getSingletonPopupModule(id:String) : IModule
      {
         var lookup:XML = null;
         var match:XMLList = null;
         var config:XML = null;
         var module:IModule = null;
         var className:String = null;
         var classReference:Class = null;
         lookup = AppComponents.stringManager.popups;
         match = lookup.popups.popup.(attribute("id") == id);
         config = this.getSingletonPopupConfig(id);
         if(config)
         {
            if(this._singletonPopupRegistry[id] == null)
            {
               className = config.module.@className;
               try
               {
                  classReference = getDefinitionByName(className) as Class;
               }
               catch(error:Error)
               {
               }
               if(classReference)
               {
                  module = new classReference();
                  this._singletonPopupRegistry[id] = module;
               }
            }
            else
            {
               module = this._singletonPopupRegistry[id];
            }
         }
         return module;
      }
      
      public function getSingletonPopupModuleIfExists(id:String) : IModule
      {
         var module:IModule = null;
         if(this._singletonPopupRegistry[id])
         {
            module = this.getSingletonPopupModule(id);
         }
         return module;
      }
      
      public function getSingletonPopup(id:String) : Window
      {
         var lookup:XML = null;
         var match:XMLList = null;
         var config:XML = null;
         var module:IModule = null;
         var window:Window = null;
         var styleId:String = null;
         var parent:DisplayObject = null;
         lookup = AppComponents.stringManager.popups;
         match = lookup.popups.popup.(attribute("id") == id);
         config = this.getSingletonPopupConfig(id);
         if(config)
         {
            module = this.getSingletonPopupModule(id);
            try
            {
               parent = DisplayObject(module).parent.parent;
               if(parent is Window)
               {
                  return parent as Window;
               }
            }
            catch(e:Error)
            {
            }
            window = this.createTemporaryWindow();
            if(config.@baseType == "dialog")
            {
               window.minimizable = false;
               window.resizable = false;
               window.chromelessTop = false;
               window.chromelessBottom = true;
            }
            if(config.@baseType == "modalDialog")
            {
               window.minimizable = false;
               window.resizable = false;
               window.chromelessTop = false;
               window.chromelessBottom = true;
               window.dimBelow = true;
               window.blockBelow = true;
               window.autoCenter = true;
            }
            if(config.@baseType == "floating")
            {
               window.minimizable = true;
               window.resizable = true;
               window.chromelessTop = false;
               window.chromelessBottom = false;
            }
            window.dimBelow = config.@dimBelow == "true"?Boolean(true):config.@dimBelow == "false"?Boolean(false):Boolean(window.dimBelow);
            window.chromelessTop = config.@chromelessTop == "true"?Boolean(true):config.@chromelessTop == "false"?Boolean(false):Boolean(window.chromelessTop);
            window.chromelessBottom = config.@chromelessBottom == "true"?Boolean(true):config.@chromelessBottom == "false"?Boolean(false):Boolean(window.chromelessBottom);
            window.closable = config.@closable == "true"?Boolean(true):config.@closable == "false"?Boolean(false):Boolean(window.closable);
            window.minimizable = config.@minimizable == "true"?Boolean(true):config.@minimizable == "false"?Boolean(false):Boolean(window.minimizable);
            window.resizable = config.@resizable == "true"?Boolean(true):config.@resizable == "false"?Boolean(false):Boolean(window.resizable);
            window.draggable = config.@draggable == "true"?Boolean(true):config.@draggable == "false"?Boolean(false):Boolean(window.draggable);
            if(config.@title.toXMLString() != "")
            {
               window.title = config.@title.toXMLString();
            }
            if(config.@defaultWidth.toXMLString() != "")
            {
               window.innerWidth = config.@defaultWidth.toXMLString();
            }
            if(config.@defaultHeight.toXMLString() != "")
            {
               window.innerHeight = config.@defaultHeight.toXMLString();
            }
            if(config.@minWidth.toXMLString() != "")
            {
               window.minWidth = config.@minWidth.toXMLString();
            }
            if(config.@minHeight.toXMLString() != "")
            {
               window.minHeight = config.@minHeight.toXMLString();
            }
            if(config.@padding.toXMLString() != "")
            {
               window.setPadding(config.@padding);
            }
            else
            {
               window.setPadding(10);
            }
            styleId = config.@styleId.toXMLString();
            if(config.@styleId.toXMLString() != "")
            {
               window.setStyleById(config.@styleId);
            }
            else
            {
               window.setStyleById("window");
            }
            window.setModule(module);
            return window;
         }
         return null;
      }
      
      public function openNextPopup() : PopupQueueItem
      {
         var window:Window = null;
         var next:PopupQueueItem = !!this._popupQueue.hasNext()?this._popupQueue.next():null;
         var floatingDivExists:Boolean = this.getSingletonPopupModuleIfExists(Popups.SECURE) != null;
         if(next && !floatingDivExists)
         {
            if(next.event)
            {
               StageReference.stage.dispatchEvent(next.event);
            }
            else
            {
               window = this.getSingletonPopup(next.id);
               if(window && !window.stage)
               {
                  this.addDialogWindow(window);
               }
            }
         }
         return next;
      }
      
      public function get popupQueue() : PopupQueue
      {
         return this._popupQueue;
      }
      
      public function get currentPopupQueueItem() : PopupQueueItem
      {
         return this._popupQueue.source && this._popupQueue.source.length > 0 && this._popupQueue.index > 0?this._popupQueue.source[this._popupQueue.index - 1]:null;
      }
      
      public function popupError(ref:*, error:Error, force:Boolean = false) : void
      {
         var stack:String = null;
         var str:String = null;
         if(AppProperties.debugMode != AppProperties.MODE_NOT_DEBUGGING || force)
         {
            stack = error.getStackTrace();
            str = ref + "\n\n" + error.message + "\n\n" + stack;
            this.popupDebugMessage("Error",str);
         }
      }
      
      public function popupDebugMessage(title:String, message:String, minimized:Boolean = false) : void
      {
         var consoleWindow:Window = null;
         var console:Console = new Console();
         consoleWindow = new Window(title,20,100,200,200);
         consoleWindow.setModule(console);
         this.addFloatingWindow(consoleWindow);
         console.forceAppendText(message);
         console.scrollToTop();
         if(minimized)
         {
            consoleWindow.minimize();
         }
      }
   }
}
