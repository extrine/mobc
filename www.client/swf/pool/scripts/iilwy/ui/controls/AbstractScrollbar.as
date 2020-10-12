package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class AbstractScrollbar extends UiElement
   {
       
      
      protected var _bg:Sprite;
      
      protected var _thumb:Sprite;
      
      protected var _dragOffset:Number = 0;
      
      protected var _value:Number = 0;
      
      protected var _dragging:Boolean = false;
      
      protected var _bgTimer:Timer;
      
      public var gutter:Number = 3;
      
      protected var _widthChanged:Boolean = true;
      
      protected var _heightChanged:Boolean = true;
      
      protected var _vertical:Boolean = true;
      
      public function AbstractScrollbar(x:Number, y:Number, size:Number, vertical:Boolean = true, styleId:String = "scrollBar")
      {
         super();
         this._vertical = vertical;
         this.x = x;
         this.y = y;
         this.thickness = 19;
         this.size = size;
         this.setStyleById(styleId);
         this._bg = new Sprite();
         addChild(this._bg);
         this._thumb = new Sprite();
         addChild(this._thumb);
         this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown);
         this._thumb.addEventListener(MouseEvent.MOUSE_OVER,this.onThumbMouseOver);
         this._thumb.addEventListener(MouseEvent.MOUSE_OUT,this.onThumbMouseOut);
         this._bg.addEventListener(MouseEvent.MOUSE_DOWN,this.onBgMouseDown);
         this._bg.useHandCursor = true;
         this._bg.buttonMode = true;
         tabEnabled = false;
         tabChildren = false;
         mouseEnabled = true;
         mouseChildren = true;
         this._thumb.buttonMode = true;
         this._thumb.useHandCursor = true;
         this._bgTimer = new Timer(200);
      }
      
      override public function destroy() : void
      {
         this._bgTimer.stop();
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragLoop);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBgMouseUp);
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var r:Rectangle = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var rad:Number = NaN;
         var yInset:Number = NaN;
         var xInset:Number = NaN;
         if(this._widthChanged && this._vertical || this._heightChanged && !this._vertical)
         {
            this._widthChanged = false;
            this._heightChanged = false;
            if(this._vertical)
            {
               w = unscaledWidth;
               h = 100;
               rad = w;
               yInset = -Math.floor(w / 2);
               xInset = -1;
            }
            else
            {
               w = 100;
               h = unscaledHeight;
               rad = h;
               xInset = -Math.floor(h / 2);
               yInset = -1;
            }
            this._bg.graphics.clear();
            UiRender.renderRoundRect(this._bg,style.backgroundColor,0,0,w,h,rad);
            r = new Rectangle(0,0,w,h);
            r.inflate(xInset,yInset);
            try
            {
               this._bg.scale9Grid = r;
            }
            catch(e:Error)
            {
            }
            if(this._vertical)
            {
               w = unscaledWidth - this.gutter - this.gutter;
               h = 100;
               rad = w;
               yInset = -Math.floor(w / 2);
               xInset = -1;
            }
            else
            {
               w = 100;
               h = unscaledHeight - this.gutter - this.gutter;
               rad = h;
               xInset = -Math.floor(h / 2);
               yInset = -1;
            }
            this._thumb.graphics.clear();
            UiRender.renderRoundRect(this._thumb,style.foregroundColor,0,0,w,h,rad);
            r = new Rectangle(0,0,w,h);
            r.inflate(xInset,yInset);
            try
            {
               this._thumb.scale9Grid = r;
            }
            catch(e:Error)
            {
            }
            this._thumb.x = this.gutter;
            this._thumb.y = this.gutter;
         }
         if(this._vertical)
         {
            this._bg.height = unscaledHeight;
         }
         else
         {
            this._bg.width = unscaledWidth;
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set size(n:Number) : void
      {
         if(this._vertical)
         {
            this.height = n;
         }
         else
         {
            this.width = n;
         }
      }
      
      public function set thickness(n:Number) : void
      {
         if(this._vertical)
         {
            this.width = n;
         }
         else
         {
            this.height = n;
         }
      }
      
      override public function set width(n:Number) : void
      {
         super.width = n;
         this._widthChanged = true;
      }
      
      override public function set height(n:Number) : void
      {
         super.height = n;
         this._heightChanged = true;
      }
      
      protected function onBgMouseDown(event:MouseEvent) : void
      {
         var clicked:Number = this.checkIncrementBasedOnClick();
         if(clicked == 1)
         {
            this.increment(1);
         }
         else if(clicked == -1)
         {
            this.increment(-1);
         }
         if(clicked == 0)
         {
            this.onThumbMouseDown(event);
         }
         else
         {
            StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBgMouseUp);
            this._bgTimer.addEventListener(TimerEvent.TIMER,this.onBgRepeat);
            this._bgTimer.reset();
            this._bgTimer.delay = 200;
            this._bgTimer.start();
         }
      }
      
      protected function onBgMouseUp(event:MouseEvent) : void
      {
         this._bgTimer.stop();
         this._bgTimer.removeEventListener(TimerEvent.TIMER,this.onBgRepeat);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBgMouseUp);
      }
      
      protected function onBgRepeat(event:TimerEvent) : void
      {
         if(this._bgTimer.currentCount > 2)
         {
            this._bgTimer.delay = 50;
         }
         var clicked:Number = this.checkIncrementBasedOnClick();
         if(clicked == 1)
         {
            this.increment(1);
         }
         else if(clicked == -1)
         {
            this.increment(-1);
         }
      }
      
      protected function checkIncrementBasedOnClick() : Number
      {
         var clicked:Number = 0;
         if(this._vertical && mouseY > this._thumb.y + this._thumb.height)
         {
            clicked = 1;
         }
         else if(this._vertical && mouseY < this._thumb.y)
         {
            clicked = -1;
         }
         else if(!this._vertical && mouseX > this._thumb.x + this._thumb.width)
         {
            clicked = 1;
         }
         else if(!this._vertical && mouseX < this._thumb.x)
         {
            clicked = -1;
         }
         return clicked;
      }
      
      private function onThumbMouseOut(event:MouseEvent) : void
      {
      }
      
      private function onThumbMouseOver(event:MouseEvent) : void
      {
      }
      
      protected function onThumbMouseDown(event:MouseEvent) : void
      {
         if(this._vertical)
         {
            this._dragOffset = this._thumb.mouseY * (this._thumb.height / 100);
         }
         else
         {
            this._dragOffset = this._thumb.mouseX * (this._thumb.width / 100);
         }
         StageReference.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragLoop,false,0,true);
         this.listenForGlobalMouseUp();
         this._dragging = true;
         dispatchEvent(new ScrollEvent(ScrollEvent.START));
         this.onDragStart();
      }
      
      protected function listenForGlobalMouseUp() : void
      {
         StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageReference.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownOut);
         StageReference.stage.addEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
      }
      
      protected function onMouseUp(event:MouseEvent) : void
      {
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragLoop);
         this._dragging = false;
         dispatchEvent(new ScrollEvent(ScrollEvent.STOP));
         this.onDragStop();
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownOut);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageReference.stage.removeEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
      }
      
      protected function onMouseDownOut(event:MouseEvent) : void
      {
         if(!new Rectangle(0,0,width,height).contains(mouseX,mouseY))
         {
            this.onMouseUp(null);
         }
      }
      
      protected function onMouseLeave(event:Event) : void
      {
         this.onMouseUp(null);
      }
      
      protected function onDragLoop(event:Event) : void
      {
         var y:Number = NaN;
         var x:Number = NaN;
         if(this._vertical)
         {
            y = mouseY - this._dragOffset;
            y = Math.max(y,this.gutter);
            y = Math.min(y,height - this.gutter - this._thumb.height);
            this._thumb.y = y;
         }
         else
         {
            x = mouseX - this._dragOffset;
            x = Math.max(x,this.gutter);
            x = Math.min(x,width - this.gutter - this._thumb.width);
            this._thumb.x = x;
         }
         this.onDragUpdate();
      }
      
      protected function getRange() : Number
      {
         var range:Number = height - this.gutter - this.gutter - this._thumb.height;
         if(!this._vertical)
         {
            range = width - this.gutter - this.gutter - this._thumb.width;
         }
         return range;
      }
      
      protected function getThumbOffset() : Number
      {
         var offset:Number = this._thumb.y - this.gutter;
         if(!this._vertical)
         {
            offset = this._thumb.x - this.gutter;
         }
         return offset;
      }
      
      protected function onDragStart() : void
      {
      }
      
      protected function onDragStop() : void
      {
      }
      
      protected function onDragUpdate() : void
      {
      }
      
      protected function increment(direction:Number) : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.INCREMENT,direction));
      }
      
      protected function onChanged() : void
      {
      }
      
      override public function setStyleById(styleID:String) : void
      {
         super.setStyleById(styleID);
         this._widthChanged = true;
         this._heightChanged = true;
      }
   }
}
