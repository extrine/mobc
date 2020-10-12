package iilwy.ui.partials.scrollgroups
{
   import iilwy.ui.containers.ScrollableList;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Scrollbar;
   import iilwy.ui.events.ScrollEvent;
   
   public class ScrollableListScrollGroup extends UiContainer
   {
       
      
      public var scrollable:ScrollableList;
      
      public var scrollbar:Scrollbar;
      
      public function ScrollableListScrollGroup(x:Number = 0, y:Number = 0, width:Number = 300, height:Number = 200, styleId:String = "textBlockScrollGroup")
      {
         super();
         setStyleById(styleId);
         this.scrollable = new ScrollableList();
         this.scrollbar = new Scrollbar();
         this.scrollbar.margin.left = 5;
         this.scrollbar.addEventListener(ScrollEvent.VISIBLE_CHANGE,this.onScrollVisibleChange);
         addContentChild(this.scrollable);
         addContentChild(this.scrollbar);
         this.scrollbar.setScrollableTarget(this.scrollable);
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
      }
      
      override public function destroy() : void
      {
         removeContentChild(this.scrollbar);
         removeContentChild(this.scrollable);
         this.scrollbar.destroy();
         this.scrollable.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(isNaN(unscaledWidth) || isNaN(unscaledHeight))
         {
            return;
         }
         this.scrollbar.x = Math.floor(unscaledWidth - this.scrollbar.width);
         this.scrollable.width = !!this.scrollbar.visible?Number(this.scrollbar.x - this.scrollbar.margin.horizontal):Number(unscaledWidth);
         this.scrollbar.height = unscaledHeight - this.scrollbar.margin.top - this.scrollbar.margin.bottom;
         this.scrollable.height = unscaledHeight;
         this.scrollbar.y = this.scrollbar.margin.top;
      }
      
      override public function calculateInnerWidth(width:Number) : Number
      {
         var w:Number = width - padding.left - padding.right - chromePadding.left - chromePadding.right;
         if(this.scrollbar.visible)
         {
            w = w - (this.scrollbar.width + this.scrollbar.margin.horizontal);
         }
         return w;
      }
      
      private function onScrollVisibleChange(event:ScrollEvent) : void
      {
         invalidateDisplayList();
         validate();
      }
   }
}
