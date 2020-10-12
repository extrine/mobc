package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import iilwy.ui.utils.IFocusGroup;
   
   public class UiModule extends UiContainer implements IModule, IFocusGroup
   {
       
      
      private var _container:ModuleContainer;
      
      private var _delayedUpdateTimer:Timer;
      
      private var _defaultFocus:InteractiveObject;
      
      private var _savedFocus:InteractiveObject;
      
      protected var _wantsFocus:Boolean = true;
      
      protected var _deferredUpdateTimer:Timer;
      
      protected var _deferredUpdateTimerDelay:Number = 300;
      
      protected var _deferredDimensions:Rectangle;
      
      protected var _firstUpdate:Boolean = true;
      
      public function UiModule()
      {
         this._deferredDimensions = new Rectangle();
         super();
         this._deferredUpdateTimer = new Timer(this._deferredUpdateTimerDelay,1);
         this._deferredUpdateTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDeferredUpdateTimerComplete);
         mouseChildren = true;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      public function updateDisplayListDeferred(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this._deferredDimensions.width = unscaledWidth;
         this._deferredDimensions.height = unscaledHeight;
         if(this._firstUpdate)
         {
            this._firstUpdate = false;
            this.updateDisplayListDeferred(unscaledWidth,unscaledHeight);
         }
         else
         {
            this._deferredUpdateTimer.reset();
            this._deferredUpdateTimer.delay = this._deferredUpdateTimerDelay;
            this._deferredUpdateTimer.start();
         }
      }
      
      protected function onDeferredUpdateTimerComplete(event:TimerEvent) : void
      {
         this.updateDisplayListDeferred(this._deferredDimensions.width,this._deferredDimensions.height);
      }
      
      public function get container() : ModuleContainer
      {
         return this._container;
      }
      
      public function setContainer(container:ModuleContainer) : void
      {
         this._container = container;
      }
      
      override public function set width(n:Number) : void
      {
         super.width = n;
      }
      
      override public function set height(n:Number) : void
      {
         super.height = n;
      }
      
      public function getConcreteDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function focusIn() : void
      {
         tabChildren = true;
      }
      
      public function focusOut() : void
      {
         tabChildren = false;
      }
      
      public function get defaultFocus() : InteractiveObject
      {
         return this._defaultFocus;
      }
      
      public function set defaultFocus(i:InteractiveObject) : void
      {
         this._defaultFocus = i;
      }
      
      public function get savedFocus() : InteractiveObject
      {
         return this._savedFocus;
      }
      
      public function set savedFocus(i:InteractiveObject) : void
      {
         this._savedFocus = i;
      }
      
      public function get wantsFocus() : Boolean
      {
         return this._wantsFocus;
      }
      
      public function set wantsFocus(val:Boolean) : void
      {
         this._wantsFocus = val;
      }
   }
}
