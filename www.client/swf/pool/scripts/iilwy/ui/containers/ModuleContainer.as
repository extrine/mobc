package iilwy.ui.containers
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.ui.controls.ProcessingIndicator;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.MathUtil;
   import iilwy.utils.UiRender;
   
   public class ModuleContainer extends UiContainer implements IModuleContainer
   {
       
      
      protected var _module:IModule;
      
      private var _autoDestroyModule:Boolean = false;
      
      protected var _stopInvalidatingTimer:Timer;
      
      private var _invalidatingModule:Boolean = false;
      
      protected var _processingBlocker:Sprite;
      
      protected var _processingAnim:ProcessingIndicator;
      
      private var _processingAnimTimer:Timer;
      
      private var _processingMargin:Margin;
      
      private var _processingBlockerAlpha:Number = 0.8;
      
      public function ModuleContainer()
      {
         this._processingMargin = new Margin();
         super();
         this._stopInvalidatingTimer = new Timer(1,1);
         this._stopInvalidatingTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.stopInvalidating);
         addEventListener(ContainerEvent.START_PROCESSING,this.startProcessing);
         addEventListener(ContainerEvent.STOP_PROCESSING,this.stopProcessing);
         addEventListener(ContainerEvent.SET_PROCESSING_MARGIN,this.onSetProcessingMargin);
         this._processingAnimTimer = new Timer(10000,1);
         this._processingAnimTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onProcessingAnimTimerComplete);
         mouseChildren = true;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bgCol:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._module != null)
         {
            this.setModuleSize(unscaledWidth,unscaledHeight);
         }
         var evt:ContainerEvent = new ContainerEvent(ContainerEvent.RESIZE,true,true);
         evt.container = this;
         dispatchEvent(evt);
         if(this._processingBlocker != null && contains(this._processingBlocker))
         {
            bgCol = getValidValue(backgroundColor,style.backgroundColor);
            GraphicUtil.setColor(this._processingBlocker,bgCol);
            this._processingBlocker.alpha = this.processingBlockerAlpha;
            this._processingBlocker.width = innerWidth - this._processingMargin.horizontal;
            this._processingBlocker.height = innerHeight - this._processingMargin.vertical;
            this._processingBlocker.visible = true;
            this._processingBlocker.x = chromePadding.left + padding.left + this._processingMargin.left;
            this._processingBlocker.y = chromePadding.top + padding.top + this._processingMargin.top;
            this._processingAnim.x = int(this._processingBlocker.x + innerWidth / 2 - this._processingAnim.width / 2);
            this._processingAnim.y = int(this._processingBlocker.y + innerHeight / 2 - this._processingAnim.height / 2);
            this._processingAnim.visible = true;
         }
         content.x = padding.left + chromePadding.left;
         content.y = padding.top + chromePadding.top;
      }
      
      override public function destroy() : void
      {
         if(this._module != null)
         {
            removeContentChild(this._module.getConcreteDisplayObject());
            if(this.autoDestroyModule)
            {
               try
               {
                  this._module.destroy();
               }
               catch(e:Error)
               {
               }
            }
         }
         this._stopInvalidatingTimer.stop();
         this._stopInvalidatingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.stopInvalidating);
         removeEventListener(ContainerEvent.START_PROCESSING,this.startProcessing);
         removeEventListener(ContainerEvent.STOP_PROCESSING,this.stopProcessing);
         this._module = null;
         super.destroy();
      }
      
      public function startProcessing(event:ContainerEvent = null) : void
      {
         if(this._processingBlocker == null)
         {
            this._processingBlocker = new Sprite();
            UiRender.renderRect(this._processingBlocker,16777215,0,0,100,100);
         }
         if(this._processingAnim == null)
         {
            this._processingAnim = new ProcessingIndicator();
            this._processingAnim.alpha = 0.2;
         }
         this._processingAnimTimer.reset();
         this._processingAnimTimer.start();
         this._processingAnim.visible = false;
         this._processingBlocker.visible = false;
         this._processingAnim.animate = true;
         addChild(this._processingBlocker);
         addChild(this._processingAnim);
         invalidateDisplayList();
      }
      
      public function stopProcessing(event:ContainerEvent = null) : void
      {
         if(this._processingBlocker != null)
         {
            if(contains(this._processingBlocker))
            {
               removeChild(this._processingBlocker);
            }
            if(contains(this._processingAnim))
            {
               removeChild(this._processingAnim);
               this._processingAnim.animate = false;
            }
         }
      }
      
      protected function onSetProcessingMargin(event:ContainerEvent) : void
      {
         if(event.margin)
         {
            this.processingMargin = event.margin;
         }
      }
      
      protected function onProcessingAnimTimerComplete(event:TimerEvent) : void
      {
         this.stopProcessing();
      }
      
      public function setModule(imodule:IModule) : IModule
      {
         var module:Module = null;
         var uimodule:UiModule = null;
         if(this._module != null)
         {
            this.removeModule();
         }
         if(imodule == null)
         {
            return null;
         }
         if(imodule is Module)
         {
            module = imodule as Module;
            this._module = module;
            if(!isNaN(module.explicitWidth))
            {
               innerWidth = Math.round(module.explicitWidth);
            }
            if(!isNaN(module.explicitHeight))
            {
               innerHeight = Math.round(module.explicitHeight);
            }
            this.setModuleSize(width,height);
         }
         else if(imodule is UiModule)
         {
            uimodule = imodule as UiModule;
            this._module = uimodule;
            if(uimodule.percentWidth == 100)
            {
               uimodule.width = innerWidth;
            }
            else if(!isNaN(uimodule.width))
            {
               innerWidth = MathUtil.clamp(calculateInnerWidth(minWidth),calculateInnerWidth(maxWidth),uimodule.width);
            }
            if(uimodule.percentHeight == 100)
            {
               uimodule.height = innerHeight;
            }
            else if(!isNaN(uimodule.height))
            {
               innerHeight = MathUtil.clamp(calculateInnerHeight(minHeight),calculateInnerHeight(maxHeight),uimodule.height);
            }
            invalidateSize();
            invalidateDisplayList();
            uimodule.addEventListener(UiEvent.INVALIDATE_SIZE,this.onModuleInvalidateSize);
         }
         imodule.setContainer(this);
         addContentChild(imodule.getConcreteDisplayObject());
         imodule.getConcreteDisplayObject().dispatchEvent(new ContainerEvent(ContainerEvent.ADDED_TO_CONTAINER));
         return module;
      }
      
      public function removeModule() : IModule
      {
         var m:IModule = this._module;
         if(this._module != null)
         {
            this._module.getConcreteDisplayObject().removeEventListener(UiEvent.INVALIDATE_SIZE,this.onModuleInvalidateSize);
            this._module.setContainer(null);
            removeContentChild(this._module.getConcreteDisplayObject());
            this._module = null;
         }
         return m;
      }
      
      public function get processingMargin() : Margin
      {
         return this._processingMargin;
      }
      
      public function set processingMargin(value:Margin) : void
      {
         this._processingMargin = value;
      }
      
      protected function setModuleSize(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var module:Module = null;
         var uimodule:UiModule = null;
         if(this._module is Module)
         {
            module = this._module as Module;
            module.setSize(calculateInnerWidth(unscaledWidth),calculateInnerHeight(unscaledHeight));
         }
         else if(this._module is UiModule)
         {
            uimodule = this._module as UiModule;
            this._invalidatingModule = true;
            if(uimodule.percentWidth == 100)
            {
               uimodule.width = calculateInnerWidth(unscaledWidth);
            }
            if(uimodule.percentHeight == 100)
            {
               uimodule.height = calculateInnerHeight(unscaledHeight);
            }
            this._stopInvalidatingTimer.reset();
            this._stopInvalidatingTimer.start();
         }
      }
      
      protected function stopInvalidating(event:TimerEvent = null) : void
      {
         this._invalidatingModule = false;
      }
      
      protected function onModuleInvalidateSize(event:UiEvent) : void
      {
         var uimodule:UiModule = null;
         if(!this._invalidatingModule && event.target == this._module)
         {
            uimodule = this._module as UiModule;
            if(uimodule.percentWidth != 100 && !isNaN(uimodule.width))
            {
               innerWidth = MathUtil.clamp(calculateInnerWidth(minWidth),calculateInnerWidth(maxWidth),uimodule.width);
            }
            if(uimodule.percentHeight != 100 && !isNaN(uimodule.height))
            {
               innerHeight = MathUtil.clamp(calculateInnerHeight(minHeight),calculateInnerHeight(maxHeight),uimodule.height);
            }
         }
      }
      
      public function get module() : IModule
      {
         return this._module;
      }
      
      public function get autoDestroyModule() : Boolean
      {
         return this._autoDestroyModule;
      }
      
      public function set autoDestroyModule(value:Boolean) : void
      {
         this._autoDestroyModule = value;
      }
      
      public function get processingBlockerAlpha() : Number
      {
         return this._processingBlockerAlpha;
      }
      
      public function set processingBlockerAlpha(value:Number) : void
      {
         this._processingBlockerAlpha = value;
      }
   }
}
