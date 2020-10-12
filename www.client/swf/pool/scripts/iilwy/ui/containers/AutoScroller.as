package iilwy.ui.containers
{
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.utils.MathUtil;
   import iilwy.utils.UiRender;
   
   public class AutoScroller extends UiContainer
   {
       
      
      private var _mouseOver:Boolean = false;
      
      private var _dockX:Number = 0;
      
      private var _dockY:Number = 0;
      
      private var _currentX:Number = 0;
      
      private var _currentY:Number = 0;
      
      private var percentY:Number = 0;
      
      private var _percentX:Number = 0;
      
      private var _direction:String;
      
      private var _scrollPad:Number = 30;
      
      private var _timeoutTimer:Timer;
      
      private var _resizeTimer:Timer;
      
      private var _idleScrolling:Boolean = false;
      
      private var _idleScroll:Boolean = false;
      
      public var idleScrollDelay:Number = 1000;
      
      public var idleScrollSpeed:Number = 20;
      
      private var _tCount:Number = 0;
      
      private var _scrollWheelEnabled:Boolean = false;
      
      private var _scrollWheelUsed:Boolean = false;
      
      private var _scrollWheelUsedBounds:Rectangle;
      
      private var _scrollIndicator:Sprite;
      
      public var showIndicators:Boolean = false;
      
      private var _rollOutBounds:Rectangle;
      
      private var _restRatio:Number = 0;
      
      public var autoReturn:Boolean = true;
      
      public var cacheContentWhileAnimating:Boolean = true;
      
      public function AutoScroller(direction:String = "horizontal", x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200, styleID:String = "autoScroller")
      {
         this._scrollWheelUsedBounds = new Rectangle();
         this._rollOutBounds = new Rectangle();
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setStyleById(styleID);
         setPadding(0,0,0,0);
         this.direction = direction;
         this._timeoutTimer = new Timer(this.idleScrollDelay,1);
         this._timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeoutComplete);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._scrollIndicator = new Sprite();
         addChild(this._scrollIndicator);
         addContainerBackground();
         maskContents = true;
         if(direction == AutoScrollerDirection.VERTICAL)
         {
            this.keyboardEnabled = true;
         }
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      private function set restPosition(n:Number) : void
      {
         this._restRatio = -n / width;
         this._restRatio = 0;
      }
      
      public function set restRatio(n:Number) : void
      {
         this._restRatio = -n;
         this._restRatio = 0;
      }
      
      private function get restPosition() : Number
      {
         return 0;
      }
      
      override public function destroy() : void
      {
         this._timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeoutComplete);
         this._timeoutTimer.stop();
         content.cacheAsBitmap = false;
         this.keyboardEnabled = false;
         if(!this._scrollWheelEnabled)
         {
         }
         Tweener.removeTweens(content);
         Tweener.removeTweens(this._scrollIndicator);
         removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this._scrollIndicator.graphics.clear();
         UiRender.renderRoundRect(this._scrollIndicator,style.foregroundColor,0,0,100,100,4);
         this._scrollIndicator.scale9Grid = new Rectangle(2,2,96,96);
         if(this._direction == AutoScrollerDirection.VERTICAL)
         {
            this._scrollIndicator.width = 4;
            this._scrollIndicator.x = unscaledWidth + 1;
         }
         else
         {
            this._scrollIndicator.height = 4;
            this._scrollIndicator.y = unscaledHeight + 1;
         }
         this.reset();
      }
      
      public function reset() : void
      {
         content.x = 0;
         content.y = 0;
         this._dockX = 0;
         this._dockY = 0;
         if(this._scrollIndicator)
         {
            this._scrollIndicator.alpha = 0;
         }
         Tweener.removeTweens(content);
         Tweener.removeTweens(this._scrollIndicator);
         content.cacheAsBitmap = false;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mouseOver = false;
         this._idleScrolling = false;
         this.startIdleTimer();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(s:String) : void
      {
         this._direction = s == AutoScrollerDirection.HORIZONTAL?AutoScrollerDirection.HORIZONTAL:AutoScrollerDirection.VERTICAL;
         invalidateDisplayList();
      }
      
      public function get idleScroll() : Boolean
      {
         return this._idleScroll;
      }
      
      public function set idleScroll(b:Boolean) : void
      {
         this._idleScroll = b;
         this.startIdleTimer();
      }
      
      public function set scrollPad(tValue:Number) : void
      {
         this._scrollPad = tValue;
      }
      
      private function get percentX() : Number
      {
         return this._percentX;
      }
      
      private function set percentX(n:Number) : void
      {
         this._percentX = n;
      }
      
      public function enableScrollWheel() : void
      {
         if(!this._scrollWheelEnabled)
         {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
         }
         this._scrollWheelEnabled = true;
      }
      
      public function set keyboardEnabled(b:Boolean) : void
      {
         try
         {
            if(b)
            {
               AppComponents.globalKeyListener.addItem(this);
            }
            else
            {
               AppComponents.globalKeyListener.removeItem(this);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      protected function increment(dir:Number) : void
      {
         if(this._direction == AutoScrollerDirection.VERTICAL)
         {
            this.percentY = this.percentY + dir * 0.1;
            MathUtil.clamp(0,1,this.percentY);
         }
         else
         {
            this.percentX = this.percentX + dir * 0.1;
            MathUtil.clamp(0,1,this.percentX);
         }
      }
      
      protected function startIdleScroll() : void
      {
         if(this._idleScroll && stage)
         {
            if(this.cacheContentWhileAnimating)
            {
               content.cacheAsBitmap = true;
            }
            if(this._direction == AutoScrollerDirection.VERTICAL && content.height > height + 5)
            {
               Tweener.addTween(content,{
                  "y":height - content.height,
                  "time":Math.abs(height - content.height) / this.idleScrollSpeed,
                  "transition":"linear",
                  "onComplete":this.backToDock
               });
               this._idleScrolling = true;
            }
            else if(this._direction == AutoScrollerDirection.HORIZONTAL && content.width > width + 5)
            {
               Tweener.addTween(content,{
                  "x":width - content.width,
                  "time":Math.abs(width - content.width) / this.idleScrollSpeed,
                  "transition":"linear",
                  "onComplete":this.backToDock
               });
               this._idleScrolling = true;
            }
         }
      }
      
      protected function backToDock() : void
      {
         if(this._direction == AutoScrollerDirection.VERTICAL)
         {
            Tweener.addTween(content,{
               "y":0,
               "time":1,
               "transition":"easeinout",
               "delay":2
            });
         }
         else
         {
            Tweener.addTween(content,{
               "x":0,
               "time":1,
               "transition":"easeinout",
               "delay":2
            });
         }
      }
      
      private function startIdleTimer() : void
      {
         if(this._idleScroll)
         {
            this._timeoutTimer.delay = this.idleScrollDelay;
            this._timeoutTimer.reset();
            this._timeoutTimer.start();
         }
      }
      
      public function onRollOver(evt:MouseEvent) : void
      {
         this._mouseOver = true;
         this._scrollWheelUsed = false;
         if(this._direction == AutoScrollerDirection.VERTICAL && content.height > height + 1)
         {
            if(this.cacheContentWhileAnimating)
            {
               content.cacheAsBitmap = true;
            }
            Tweener.removeTweens(content);
            this._currentY = content.y;
            this._timeoutTimer.stop();
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this._rollOutBounds = new Rectangle(-20,-50,width + 40,height + 100);
            if(this.showIndicators)
            {
               Tweener.addTween(this._scrollIndicator,{
                  "alpha":1,
                  "time":0.2,
                  "transition":"easeInOut"
               });
            }
         }
         else if(this._direction == AutoScrollerDirection.HORIZONTAL && content.width > width + 1)
         {
            if(this.cacheContentWhileAnimating)
            {
               content.cacheAsBitmap = true;
            }
            Tweener.removeTweens(content);
            this._currentX = content.x;
            this._timeoutTimer.stop();
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this._rollOutBounds = new Rectangle(-50,-20,width + 100,height + 40);
            if(this.showIndicators)
            {
               Tweener.addTween(this._scrollIndicator,{
                  "alpha":1,
                  "time":0.2,
                  "transition":"easeInOut"
               });
            }
         }
      }
      
      public function onRollOut(evt:MouseEvent = null) : void
      {
         this._mouseOver = false;
         Tweener.addTween(this._scrollIndicator,{
            "alpha":0,
            "time":0.2,
            "transition":"easeInOut"
         });
         if(this.autoReturn)
         {
            if(this._direction == AutoScrollerDirection.VERTICAL)
            {
               this._dockY = this.restPosition;
            }
            else
            {
               this._dockX = this.restPosition;
            }
         }
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         if(!this._scrollWheelUsed)
         {
            this._scrollWheelUsed = true;
            this._scrollWheelUsedBounds = new Rectangle(mouseX,mouseY,1,1);
            this._scrollWheelUsedBounds.inflate(20,20);
         }
         if(this._direction == AutoScrollerDirection.VERTICAL)
         {
            if(event.keyCode == Keyboard.DOWN)
            {
               this.increment(1);
            }
            else if(event.keyCode == Keyboard.UP)
            {
               this.increment(-1);
            }
         }
         else if(this._direction == AutoScrollerDirection.HORIZONTAL)
         {
            if(event.keyCode == Keyboard.RIGHT)
            {
               this.increment(1);
            }
            else if(event.keyCode == Keyboard.LEFT)
            {
               this.increment(-1);
            }
         }
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var dir:Number = event.delta < 0?Number(1):Number(-1);
         if(!this._scrollWheelUsed)
         {
            this._scrollWheelUsed = true;
            this._scrollWheelUsedBounds = new Rectangle(mouseX,mouseY,1,1);
            this._scrollWheelUsedBounds.inflate(20,20);
         }
         this.increment(dir);
      }
      
      private function onTimeoutComplete(evt:TimerEvent) : void
      {
         this.startIdleScroll();
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var rPercentY:Number = NaN;
         var rPercentX:Number = NaN;
         var spad:Number = this._scrollPad;
         if(this._mouseOver)
         {
            if(this._direction == AutoScrollerDirection.VERTICAL)
            {
               spad = MathUtil.clamp(0,height * 0.2,spad);
               if(!this._scrollWheelUsed)
               {
                  this.percentY = Math.min(Math.max(mouseY,spad),height - spad) / (height - spad * 2) - spad / (height - spad * 2);
               }
               if(this.percentY > 1)
               {
                  this.percentY = 1;
               }
               if(this.percentY < 0)
               {
                  this.percentY = 0;
               }
               this._dockY = (height - content.height) * this.percentY;
            }
            else
            {
               spad = MathUtil.clamp(0,width * 0.2,spad);
               if(!this._scrollWheelUsed)
               {
                  this.percentX = Math.min(Math.max(mouseX,spad),width - spad) / (width - spad * 2) - spad / (width - spad * 2);
               }
               if(this.percentX > 1)
               {
                  this.percentX = 1;
               }
               if(this.percentX < 0)
               {
                  this.percentX = 0;
               }
               this._dockX = (width - content.width) * this.percentX;
            }
            if(!this._rollOutBounds.contains(mouseX,mouseY))
            {
               this.onRollOut();
            }
            if(!this._scrollWheelUsedBounds.contains(mouseX,mouseY))
            {
               this._scrollWheelUsed = false;
            }
         }
         else if(Math.abs(this._dockX - content.x) < 1 && Math.abs(this._dockY - content.y) < 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this.cacheContentWhileAnimating)
            {
               content.cacheAsBitmap = true;
            }
            if(this.autoReturn)
            {
               this.startIdleTimer();
            }
         }
         if(this._direction == AutoScrollerDirection.VERTICAL)
         {
            this._currentY = this._currentY + (this._dockY - this._currentY) * 0.1;
         }
         else
         {
            this._currentX = this._currentX + (this._dockX - this._currentX) * 0.1;
         }
         content.x = int(this._currentX);
         content.y = int(this._currentY);
         if(this.showIndicators)
         {
            if(this._direction == AutoScrollerDirection.VERTICAL)
            {
               this._scrollIndicator.height = height * (height / content.height);
               rPercentY = -content.y / (content.height - height);
               this._scrollIndicator.y = (height - this._scrollIndicator.height) * rPercentY;
            }
            else
            {
               this._scrollIndicator.width = width * (width / content.width);
               rPercentX = -content.x / (content.width - width);
               this._scrollIndicator.x = (width - this._scrollIndicator.width) * rPercentX;
            }
         }
      }
   }
}
