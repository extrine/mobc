package iilwy.ui.partials.scrollgroups
{
   import iilwy.ui.containers.ListView;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.Scrollbar;
   
   public class ListViewScrollGroup extends UiContainer
   {
       
      
      public var listView:ListView;
      
      public var scrollbar:Scrollbar;
      
      public function ListViewScrollGroup(itemClass:Class, x:Number = 0, y:Number = 0, width:Number = 300, height:Number = 200, styleId:String = "listViewScrollGroup")
      {
         super();
         setStyleById(styleId);
         this.listView = new ListView(itemClass);
         this.scrollbar = new Scrollbar();
         addContentChild(this.listView);
         addContentChild(this.scrollbar);
         this.scrollbar.setScrollableTarget(this.listView);
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
      }
      
      override public function destroy() : void
      {
         removeContentChild(this.scrollbar);
         removeContentChild(this.listView);
         this.scrollbar.destroy();
         this.listView.destroy();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.scrollbar.x = Math.floor(unscaledWidth - this.scrollbar.width);
         this.listView.width = this.scrollbar.x - 5;
         this.scrollbar.height = unscaledHeight - this.scrollbar.margin.top - this.scrollbar.margin.bottom;
         this.listView.height = unscaledHeight;
         this.scrollbar.y = this.scrollbar.margin.top;
      }
   }
}
