package iilwy.display.core
{
   import flash.display.Sprite;
   import flash.events.Event;
   import iilwy.application.AppComponents;
   
   public class AlertManager
   {
       
      
      private var _layer:Sprite;
      
      public var _alert1:AlertManagerItem;
      
      public var _alert2:AlertManagerItem;
      
      private var _alerts:Array;
      
      public function AlertManager(layer:Sprite)
      {
         var e:Event = null;
         super();
         this._layer = layer;
         this._alert1 = new AlertManagerItem();
         this._layer.addChild(this._alert1);
         this._alert2 = new AlertManagerItem();
         this._layer.addChild(this._alert2);
         this._alert1.y = -500;
         this._alert2.y = -500;
         this._alerts = [this._alert1,this._alert2];
         WindowManager.getInstance().addEventListener(Event.RESIZE,this.onApplicationResize);
         this.onApplicationResize();
      }
      
      public function destroy() : void
      {
      }
      
      public function showError(msg:String, timeout:Boolean = true) : void
      {
         var tMsg:String = null;
         AppComponents.soundManager.playSound("error");
         if(msg != null && msg != "")
         {
            tMsg = msg;
         }
         this.show(tMsg,14621440,timeout);
      }
      
      public function showConfirmation(msg:String, timeout:Boolean = true) : void
      {
         AppComponents.soundManager.playSound("toneup");
         this.show(msg,0,timeout);
      }
      
      public function showWarning(msg:String, timeout:Boolean = true) : void
      {
         AppComponents.soundManager.playSound("lowding");
         this.show(msg,0,timeout);
      }
      
      public function showNotification(msg:String, timeout:Boolean = true) : void
      {
         this.show(msg,0,timeout);
      }
      
      protected function show(msg:String, color:Number, timeout:Boolean = true) : void
      {
         this._alerts.unshift(this._alerts.pop());
         this._alerts[1].hide();
         var alert:AlertManagerItem = this._alerts[0] as AlertManagerItem;
         alert.message = msg;
         alert.color = color;
         alert.show(timeout);
      }
      
      protected function onApplicationResize(event:Event = null) : void
      {
         this._alert1.width = Math.min(540,WindowManager.width - 20);
         this._alert2.width = Math.min(540,WindowManager.width - 20);
         this._alert1.x = Math.floor(WindowManager.width / 2 - this._alert1.width / 2);
         this._alert2.x = Math.floor(WindowManager.width / 2 - this._alert2.width / 2);
      }
      
      public function hide(event:Event = null) : void
      {
         this._alerts[0].hide();
         this._alerts[1].hide();
      }
   }
}

import caurina.transitions.Tweener;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.utils.getTimer;
import iilwy.managers.GraphicManager;
import iilwy.ui.containers.UiContainer;
import iilwy.ui.controls.IconButton;
import iilwy.ui.controls.TextBlock;
import iilwy.ui.controls.UiElement;
import iilwy.utils.GraphicUtil;
import iilwy.utils.Scale9Image;
import iilwy.utils.StageReference;
import iilwy.utils.UiRender;

class AlertManagerItem extends UiContainer
{
    
   
   private var _bg:Scale9Image;
   
   private var _bgOuter:Sprite;
   
   public var _messageBlock:TextBlock;
   
   public var _messageDisplay:UiElement;
   
   private var _hideTimer:Timer;
   
   private var _showTime:Number = 0;
   
   private var _closeButton:IconButton;
   
   private var _message:String;
   
   function AlertManagerItem()
   {
      super();
      this._bgOuter = new Sprite();
      addContentChild(this._bgOuter);
      this._bg = this.renderBackground();
      this._bgOuter.addChild(this._bg);
      this._bgOuter.filters = [new DropShadowFilter(4,90,0,0.5,15,15,1,1,false,false,false)];
      this._closeButton = new IconButton(GraphicManager.iconX1,0,0,16,16,"iconButtonWhiteReverse");
      this._closeButton.blendMode = BlendMode.LIGHTEN;
      addContentChild(this._closeButton);
      this._messageBlock = new TextBlock("",30,19,480);
      this._messageBlock.setStyleById("overlayMessage");
      this._messageBlock.selectable = false;
      this._messageBlock.mouseEnabled = false;
      addContentChild(this._messageBlock);
      this._messageBlock.filters = [new DropShadowFilter(1,90,0,0.8,6,5,1,1,false,false,false)];
      this._messageDisplay = this._messageBlock;
      this._hideTimer = new Timer(5000,1);
      this._hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideTimerComplete);
      mouseEnabled = true;
      buttonMode = true;
      useHandCursor = true;
      tabEnabled = false;
      tabChildren = false;
      width = 540;
   }
   
   protected function renderBackground() : Scale9Image
   {
      var bgArt:Sprite = new Sprite();
      UiRender.renderGradient(bgArt,[1426063360,1426063360],Math.PI / 2,0,0,100,100,20);
      UiRender.renderGradient(bgArt,[16777216,2281701376,4278190080],Math.PI / 2,3,3,94,94,16);
      return new Scale9Image(bgArt,10,10,90,90);
   }
   
   public function set color(n:Number) : void
   {
      GraphicUtil.setColor(this._bg,n);
   }
   
   override public function commitProperties() : void
   {
   }
   
   override public function measure() : void
   {
      measuredHeight = Math.floor(this._messageDisplay.height + 40);
   }
   
   override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      this._bg.width = unscaledWidth;
      this._bg.height = unscaledHeight;
      this._closeButton.x = unscaledWidth - 22;
      this._closeButton.y = 6;
   }
   
   public function set message(str:String) : void
   {
      this._message = str;
      this._messageBlock.text = this._message;
      this._messageDisplay = this._messageBlock;
      this._messageDisplay.width = width - 60;
      invalidateSize();
      invalidateDisplayList();
   }
   
   public function hide() : void
   {
      Tweener.removeTweens(this);
      Tweener.addTween(this,{
         "alpha":0,
         "time":0.3,
         "transition":"easeinoutCubic",
         "delay":0,
         "onComplete":this.onHide
      });
      StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.startHideTimer);
      StageReference.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHideSelected);
      StageReference.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onCheckHideKey);
      StageReference.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.startHideTimer);
   }
   
   protected function onHide() : void
   {
      y = -1000;
      alpha = 1;
   }
   
   public function show(timeout:Boolean = true) : void
   {
      this._showTime = getTimer();
      this.stopHideTimer();
      Tweener.removeTweens(this);
      alpha = 1;
      y = -height;
      Tweener.addTween(this,{
         "y":18,
         "time":0.3,
         "transition":"easeoutCubic",
         "delay":0,
         "rounded":true
      });
      if(timeout)
      {
         StageReference.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.startHideTimer,false,0,true);
         StageReference.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.startHideTimer,false,0,true);
      }
      StageReference.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onHideSelected,false,0,true);
      StageReference.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onCheckHideKey,false,0,true);
   }
   
   protected function startHideTimer(event:Event = null) : void
   {
      StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.startHideTimer);
      StageReference.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.startHideTimer);
      this._hideTimer.reset();
      this._hideTimer.start();
   }
   
   protected function stopHideTimer() : void
   {
      this._hideTimer.stop();
   }
   
   protected function onHideTimerComplete(event:TimerEvent) : void
   {
      var rect:Rectangle = new Rectangle(0,0,width,height);
      if(rect.contains(mouseX,mouseY))
      {
         this.startHideTimer();
      }
      else
      {
         this.hide();
      }
   }
   
   protected function onHideSelected(event:Event) : void
   {
      if(getTimer() - this._showTime > 1000 || mouseY < height)
      {
         this.hide();
      }
   }
   
   protected function onCheckHideKey(event:KeyboardEvent) : void
   {
      if(event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
      {
         this.onHideSelected(null);
      }
   }
}
