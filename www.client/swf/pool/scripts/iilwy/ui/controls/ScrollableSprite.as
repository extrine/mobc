package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import iilwy.application.AppComponents;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.utils.MathUtil;
   
   public class ScrollableSprite extends UiContainer implements IScrollable
   {
       
      
      public var scrollIncrement:Number = 50;
      
      public var pixelSnapScrolling:Boolean = false;
      
      private var _scrollAmount:Number = 0;
      
      private var _vertical:Boolean = true;
      
      public function ScrollableSprite(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200)
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this.listenForMouseWheel();
         addContainerBackground();
         maskContents = true;
         if(AppComponents.globalKeyListener)
         {
            AppComponents.globalKeyListener.addItem(this);
         }
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         content.addEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidate);
      }
      
      public function forceUpdate() : void
      {
         this.contentChildrenChanged();
      }
      
      override protected function contentChildrenChanged() : void
      {
         this.scrollAmount = this.scrollAmount;
         super.contentChildrenChanged();
      }
      
      protected function onContentInvalidate(event:Event) : void
      {
         this.contentChildrenChanged();
      }
      
      override public function destroy() : void
      {
         content.removeEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidate);
         super.destroy();
      }
      
      protected function set contentPosition(n:Number) : void
      {
         if(this._vertical)
         {
            content.y = n;
         }
         else
         {
            content.x = n;
         }
      }
      
      protected function get contentPosition() : Number
      {
         if(this._vertical)
         {
            return content.y;
         }
         return content.x;
      }
      
      protected function get contentSize() : Number
      {
         if(this._vertical)
         {
            return content.height;
         }
         return content.width;
      }
      
      protected function get beginningPadding() : Number
      {
         if(this._vertical)
         {
            return padding.top;
         }
         return padding.left;
      }
      
      protected function get endPadding() : Number
      {
         if(this._vertical)
         {
            return padding.bottom;
         }
         return padding.right;
      }
      
      protected function get viewableSpan() : Number
      {
         if(this._vertical)
         {
            return height - padding.vertical;
         }
         return width - padding.horizontal;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var span:Number = this.viewableSpan;
         if(this._vertical)
         {
            span = unscaledHeight - padding.vertical;
         }
         else
         {
            span = unscaledWidth - padding.horizontal;
         }
         if(maskContents)
         {
            contentMask.x = padding.left;
            contentMask.y = padding.right;
            contentMask.width = unscaledWidth - padding.horizontal;
            contentMask.height = unscaledHeight - padding.vertical;
         }
         if(this._vertical)
         {
            content.x = padding.left;
         }
         else
         {
            content.y = padding.top;
         }
         if(Math.abs(this.contentPosition) > this.contentSize - span)
         {
            this.contentPosition = padding.top - Math.max(0,this.contentSize - span);
         }
         this._scrollAmount = (Math.abs(this.contentPosition) - this.beginningPadding) / (this.contentSize - span);
         this.dispatchContentChangedEvent();
      }
      
      public function testScroll(e:MouseEvent) : void
      {
         this.scrollAmount = Math.random();
      }
      
      public function setScrollAbsolute(n:Number) : void
      {
         var diff:Number = NaN;
         if(this._vertical)
         {
            diff = content.height - innerHeight;
         }
         else
         {
            diff = content.width - innerWidth;
         }
         var amount:Number = MathUtil.clamp(0,1,n / diff);
         this.scrollAmount = amount;
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var dir:Number = event.delta < 0?Number(1):Number(-1);
         this.incrementScrollAmount(dir);
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.DOWN)
         {
            this.incrementScrollAmount(1,1);
         }
         else if(event.keyCode == Keyboard.UP)
         {
            this.incrementScrollAmount(-1,1);
         }
      }
      
      public function dispatchContentChangedEvent() : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_CHANGE));
      }
      
      public function dispatchScrollEvent() : void
      {
         dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
      }
      
      public function getConcreteDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getWindowToRangeRatio() : Number
      {
         return Math.max(0,this.viewableSpan / (this.contentSize - this.viewableSpan));
      }
      
      public function getWindowToContentRatio() : Number
      {
         return Math.max(0,this.viewableSpan / this.contentSize);
      }
      
      public function set scrollAmount(amount:Number) : void
      {
         var n:Number = NaN;
         if(this.contentSize > this.viewableSpan)
         {
            this._scrollAmount = MathUtil.clamp(0,1,amount);
            n = (this.contentSize - this.viewableSpan) * -MathUtil.clamp(0,1,this._scrollAmount);
            if(this.pixelSnapScrolling)
            {
               n = Math.round(n);
            }
            this.contentPosition = n + this.beginningPadding;
            this.dispatchScrollEvent();
         }
      }
      
      public function get scrollAmount() : Number
      {
         return this._scrollAmount;
      }
      
      public function listenForMouseWheel() : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function removeMouseWheel() : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function incrementScrollAmount(direction:Number, multiple:Number = 1) : void
      {
         var percent:Number = NaN;
         if(this._vertical)
         {
            percent = this.scrollIncrement / (content.height - innerHeight);
         }
         else
         {
            percent = this.scrollIncrement / (content.width - innerWidth);
         }
         this.scrollAmount = this.scrollAmount + percent * direction * multiple;
      }
      
      public function calculateScrollAmount(pixelOffset:Number) : Number
      {
         var value:Number = NaN;
         if(this._vertical)
         {
            value = pixelOffset / (content.height - innerHeight);
         }
         else
         {
            value = pixelOffset / (content.width - innerWidth);
         }
         return value;
      }
      
      public function get direction() : String
      {
         return !!this._vertical?ListDirection.VERTICAL:ListDirection.HORIZONTAL;
      }
      
      public function set direction(s:String) : void
      {
         this._vertical = s == ListDirection.VERTICAL;
      }
   }
}
