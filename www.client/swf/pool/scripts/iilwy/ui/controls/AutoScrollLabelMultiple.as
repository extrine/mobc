package iilwy.ui.controls
{
   import flash.events.Event;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.UiEvent;
   
   public class AutoScrollLabelMultiple extends UiContainer
   {
       
      
      public var labels:Array;
      
      private var accessoryViews;
      
      public var itemPadding:Number = 0;
      
      public function AutoScrollLabelMultiple(count:int, x:Number = 0, y:Number = 0, width:Number = 200)
      {
         var l:AutoScrollLabel = null;
         this.labels = [];
         this.accessoryViews = {};
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.itemPadding = -2;
         for(var i:Number = 0; i < count; i++)
         {
            l = new AutoScrollLabel(" ");
            l.label.selectable = false;
            if(i == 0)
            {
               l.setStyleById("strong");
            }
            this.labels.push(l);
            l.addEventListener(UiEvent.INVALIDATE_SIZE,this.onChildInvalidateSize,false,0,true);
            addContentChild(l);
         }
         this.width = width;
      }
      
      protected function onChildInvalidateSize(event:Event) : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function measure() : void
      {
         this.repositionChildren();
         var last:AutoScrollLabel = this.getLabelAt(this.labels.length - 1);
         if(last)
         {
            measuredHeight = last.y + last.height;
         }
      }
      
      protected function repositionChildren() : void
      {
         var label:AutoScrollLabel = null;
         var y:int = 0;
         var i:int = 0;
         for(i = 0; i < this.labels.length; i++)
         {
            label = this.labels[i];
            label.y = y;
            y = y + label.height;
            y = y + this.itemPadding;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var availWidth:Number = NaN;
         var accView:UiElement = null;
         var label:AutoScrollLabel = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var i:int = 0;
         for(i = 0; i < this.labels.length; i++)
         {
            availWidth = unscaledWidth;
            accView = this.accessoryViews[i];
            label = this.labels[i];
            if(accView)
            {
               availWidth = unscaledWidth - accView.width - accView.margin.horizontal;
               accView.x = unscaledWidth - accView.width - accView.margin.right;
               accView.y = label.y + accView.margin.top;
            }
            label.width = availWidth;
            if(accView && label.label.width < availWidth)
            {
               accView.x = label.label.width + accView.margin.left;
            }
         }
      }
      
      public function getAccessoryViewAt(index:int) : UiElement
      {
         return this.accessoryViews[index.toString()];
      }
      
      public function setAccessoryViewAt(view:UiElement, index:int) : void
      {
         this.accessoryViews[index.toString()] = view;
         addChild(view);
         view.addEventListener(UiEvent.INVALIDATE_SIZE,this.onChildInvalidateSize,false,0,true);
      }
      
      public function removeAccessoryViewAt(index:int) : void
      {
         var view:UiElement = this.accessoryViews[index.toString()];
         removeChild(view);
         view.removeEventListener(UiEvent.INVALIDATE_SIZE,this.onChildInvalidateSize);
      }
      
      public function set idleScroll(b:Boolean) : void
      {
         for(var i:int = 0; i < this.labels.length; i++)
         {
            AutoScrollLabel(this.labels[i]).idleScroll = b;
         }
      }
      
      override public function destroy() : void
      {
         this.labels = [];
         this.accessoryViews = null;
      }
      
      public function getLabelAt(number:int) : AutoScrollLabel
      {
         var alabel:AutoScrollLabel = null;
         var label:Label = null;
         try
         {
            alabel = this.labels[number];
            label = alabel.label;
         }
         catch(e:Error)
         {
         }
         return alabel;
      }
      
      public function clearAll() : void
      {
         for(var i:int = 0; i < this.labels.length; i++)
         {
            this.getLabelAt(i).text = "";
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < this.labels.length; i++)
         {
            this.getLabelAt(i).reset();
         }
      }
   }
}
