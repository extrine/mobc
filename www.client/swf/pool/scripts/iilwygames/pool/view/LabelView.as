package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import iilwy.ui.containers.List;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.UiElement;
   
   public class LabelView extends List
   {
       
      
      public var display:Label;
      
      public var icon:UiElement;
      
      private var iconBM:Bitmap;
      
      public function LabelView()
      {
         super(x,y,List.TYPE_HORIZONTAL);
         itemPadding = 0;
         this.icon = new UiElement();
         this.display = new Label("0",0,0,"smallWhite");
         this.display.fontSize = 12;
         this.display.margin.left = -2;
         this.display.alpha = 0.5;
         margin.left = 0;
         this.iconBM = new Bitmap();
         this.icon.addChild(this.iconBM);
      }
      
      override public function createChildren() : void
      {
         super.createChildren();
      }
      
      public function addIcon(bmd:BitmapData) : void
      {
         if(!bmd)
         {
            return;
         }
         this.clearContentChildren(false);
         this.iconBM.bitmapData = bmd;
         this.icon.width = bmd.width;
         this.icon.height = bmd.height;
         this.icon.margin.top = 1;
         addContentChild(this.icon);
         addContentChild(this.display);
      }
   }
}
