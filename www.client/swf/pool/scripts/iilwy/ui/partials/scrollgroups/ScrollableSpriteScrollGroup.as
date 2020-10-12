package iilwy.ui.partials.scrollgroups
{
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.ScrollableSprite;
   import iilwy.ui.controls.Scrollbar;
   
   public class ScrollableSpriteScrollGroup extends UiContainer
   {
       
      
      public var scrollable:ScrollableSprite;
      
      public var scrollbar:Scrollbar;
      
      public function ScrollableSpriteScrollGroup(x:Number = 0, y:Number = 0, width:Number = 300, height:Number = 200, styleId:String = "textBlockScrollGroup")
      {
         super();
         setStyleById(styleId);
         this.scrollable = new ScrollableSprite();
         this.scrollbar = new Scrollbar();
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
         this.scrollbar.x = Math.floor(unscaledWidth - this.scrollbar.width - padding.right);
         this.scrollbar.y = padding.top;
         this.scrollable.width = this.scrollbar.x - 5;
         this.scrollbar.height = unscaledHeight - padding.vertical;
         this.scrollable.height = unscaledHeight - padding.vertical;
      }
   }
}
