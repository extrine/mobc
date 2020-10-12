package iilwy.ui.controls
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import iilwy.application.AppComponents;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.utils.MathUtil;
   
   public class Scrollbar extends AbstractScrollbar
   {
       
      
      private var _target:IScrollable;
      
      private var _scrollMultiple:Number = 2;
      
      private var _thumbSize:Number = 0.5;
      
      private var _autoHide:Boolean;
      
      public function Scrollbar(x:Number = 0, y:Number = 0, size:Number = 100, vertical:Boolean = true, styleId:String = "scrollBar")
      {
         super(x,y,size,vertical,styleId);
         this.keyboardEnabled = true;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      override public function destroy() : void
      {
         this.clearScrollableTarget();
         this.keyboardEnabled = false;
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var change:Boolean = false;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._target != null)
         {
            if(this._autoHide)
            {
               if(this._target.getWindowToContentRatio() >= 1)
               {
                  if(visible)
                  {
                     visible = false;
                     change = true;
                  }
               }
               else if(!visible)
               {
                  visible = true;
                  change = true;
               }
               if(change)
               {
                  dispatchEvent(new ScrollEvent(ScrollEvent.VISIBLE_CHANGE,0,true,true));
               }
            }
            this._thumbSize = this._target.getWindowToContentRatio();
            if(isNaN(this._thumbSize))
            {
               if(_vertical)
               {
                  _thumb.height = Math.max(20,unscaledHeight - 6);
               }
               else
               {
                  _thumb.width = Math.max(20,unscaledWidth - 6);
               }
            }
            else
            {
               this._thumbSize = Math.min(1,this._thumbSize);
               if(_vertical)
               {
                  _thumb.height = Math.max(20,int((unscaledHeight - 6) * this._thumbSize));
               }
               else
               {
                  _thumb.width = Math.max(20,int((unscaledWidth - 6) * this._thumbSize));
               }
            }
            this.positionThumbToTargetScroll();
         }
         else if(_vertical)
         {
            _thumb.y = 3;
            _thumb.height = Math.max(20,int((unscaledHeight - 6) * this._thumbSize));
         }
         else
         {
            _thumb.x = 3;
            _thumb.width = Math.max(20,int((unscaledWidth - 6) * this._thumbSize));
         }
      }
      
      public function setScrollableTarget(target:IScrollable) : void
      {
         this._target = target;
         this._target.getConcreteDisplayObject().addEventListener(ScrollEvent.SCROLL,this.onTargetScroll);
         this._target.getConcreteDisplayObject().addEventListener(ScrollEvent.CONTENT_CHANGE,this.onTargetContentChanged);
         invalidateDisplayList();
      }
      
      public function clearScrollableTarget() : void
      {
         this._target.getConcreteDisplayObject().removeEventListener(ScrollEvent.SCROLL,this.onTargetScroll);
         this._target.getConcreteDisplayObject().removeEventListener(ScrollEvent.CONTENT_CHANGE,this.onTargetContentChanged);
         this._target = null;
         this._thumbSize = 1;
         invalidateDisplayList();
      }
      
      public function get autoHide() : Boolean
      {
         return this._autoHide;
      }
      
      public function set autoHide(value:Boolean) : void
      {
         this._autoHide = value;
         invalidateDisplayList();
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
      
      public function updateThumb() : void
      {
         invalidateDisplayList();
      }
      
      public function positionThumbToTargetScroll() : void
      {
         if(_vertical)
         {
            _thumb.y = 3 + this._target.scrollAmount * (height - 6 - _thumb.height);
            _thumb.y = MathUtil.clamp(3,Infinity,_thumb.y);
         }
         else
         {
            _thumb.x = 3 + this._target.scrollAmount * (width - 6 - _thumb.width);
            _thumb.x = MathUtil.clamp(3,Infinity,_thumb.x);
         }
      }
      
      protected function onTargetContentChanged(event:ScrollEvent) : void
      {
         this.updateThumb();
      }
      
      protected function onTargetScroll(event:ScrollEvent) : void
      {
         if(!_dragging)
         {
            this.positionThumbToTargetScroll();
         }
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
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
      
      protected function onMouseWheel(event:MouseEvent) : void
      {
         this._target.getConcreteDisplayObject().dispatchEvent(event);
      }
      
      override protected function onDragUpdate() : void
      {
         var range:Number = NaN;
         var offset:Number = NaN;
         if(_vertical)
         {
            range = Math.floor(height - 6 - _thumb.height);
            offset = _thumb.y - 3;
         }
         else
         {
            range = Math.floor(width - 6 - _thumb.width);
            offset = _thumb.x - 3;
         }
         _value = offset / range;
         if(isNaN(_value))
         {
            _value = 0;
         }
         if(this._target != null)
         {
            this._target.scrollAmount = _value;
         }
      }
      
      override protected function increment(direction:Number) : void
      {
         if(this._target != null)
         {
            this._target.incrementScrollAmount(direction);
         }
      }
   }
}
