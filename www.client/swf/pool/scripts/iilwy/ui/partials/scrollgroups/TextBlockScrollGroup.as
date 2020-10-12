package iilwy.ui.partials.scrollgroups
{
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Scrollbar;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.themes.Style;
   
   public class TextBlockScrollGroup extends UiContainer
   {
       
      
      public var textBlock:TextBlock;
      
      public var scrollbar:Scrollbar;
      
      public function TextBlockScrollGroup(x:Number = 0, y:Number = 0, width:Number = 300, height:Number = 200, styleId:String = "textBlockScrollGroup")
      {
         super();
         setStyleById(styleId);
         this.textBlock = new TextBlock();
         this.scrollbar = new Scrollbar();
         addContentChild(this.scrollbar);
         addContentChild(this.textBlock);
         this.scrollbar.setScrollableTarget(this.textBlock);
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
      }
      
      override public function destroy() : void
      {
         removeContentChild(this.scrollbar);
         removeContentChild(this.textBlock);
         this.scrollbar.destroy();
         this.textBlock.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function set width(n:Number) : void
      {
         super.width = n;
         this.textBlock.x = padding.left;
         this.scrollbar.x = Math.floor(n - this.scrollbar.width - padding.right);
         this.textBlock.width = this.scrollbar.x - 5 - this.textBlock.x;
      }
      
      override public function set height(n:Number) : void
      {
         super.height = n;
         this.scrollbar.y = padding.top;
         this.textBlock.y = padding.top;
         this.scrollbar.height = n - padding.vertical;
         this.textBlock.height = n - padding.vertical;
      }
      
      override public function set style(s:Style) : void
      {
      }
   }
}
