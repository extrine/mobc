package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import iilwy.ui.events.ScrollEvent;
   import iilwy.utils.MathUtil;
   
   public class ScrollableTextInput extends TextInput implements IScrollable
   {
       
      
      private var _scrollAmount:Number = 0;
      
      public function ScrollableTextInput(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 300, styleId:String = "textInput")
      {
         super(x,y,width,height,styleId);
         multiline = true;
         _field.addEventListener(Event.CHANGE,this.onFieldChange);
         _field.addEventListener(Event.SCROLL,this.onFieldScroll);
         this.listenForMouseWheel();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         _field.removeEventListener(Event.CHANGE,this.onFieldChange);
         _field.removeEventListener(Event.SCROLL,this.onFieldScroll);
      }
      
      private function onFieldChange(event:Event) : void
      {
         this.dispatchContentChangedEvent();
      }
      
      private function onFieldScroll(event:Event) : void
      {
         this.dispatchScrollEvent();
      }
      
      override public function set htmlText(s:String) : void
      {
         super.htmlText = s;
         this.dispatchContentChangedEvent();
      }
      
      override public function set text(s:String) : void
      {
         super.text = s;
         this.dispatchContentChangedEvent();
      }
      
      public function dispatchContentChangedEvent() : void
      {
         this._scrollAmount = (_field.scrollV - 1) / (_field.maxScrollV - 1);
         if(isNaN(this._scrollAmount))
         {
            this._scrollAmount = 0;
         }
         this._scrollAmount = MathUtil.clamp(0,1,this._scrollAmount);
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
      
      public function getWindowToContentRatio() : Number
      {
         var w:Number = _field.bottomScrollV - _field.scrollV;
         var c:Number = _field.numLines;
         var ratio:Number = w / c;
         if(_field.maxScrollV <= 1)
         {
            ratio = 1;
         }
         return Math.max(0,ratio);
      }
      
      public function set scrollAmount(amount:Number) : void
      {
         this.setScrollAmount(amount);
      }
      
      private function setScrollAmount(amount:Number) : void
      {
         this._scrollAmount = MathUtil.clamp(0,1,amount);
         _field.scrollV = _field.maxScrollV * this._scrollAmount;
         this.dispatchScrollEvent();
      }
      
      public function get scrollAmount() : Number
      {
         return this._scrollAmount;
      }
      
      public function listenForMouseWheel() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var dir:Number = event.delta < 0?Number(1):Number(-1);
         this.incrementScrollAmount(dir);
      }
      
      public function incrementScrollAmount(direction:Number, multiple:Number = 1) : void
      {
         var range:Number = _field.numLines - (_field.bottomScrollV - _field.scrollV);
         var value:Number = 1 / range;
         this.setScrollAmount(this._scrollAmount + direction * value);
      }
   }
}
