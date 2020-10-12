package iilwy.ui.partials.badges
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import iilwy.ui.controls.UiElement;
   
   public class AbstractBadge extends UiElement
   {
       
      
      public var bitmap:Bitmap;
      
      public function AbstractBadge()
      {
         super();
         this.bitmap = new Bitmap();
         addChild(this.bitmap);
         setMargin(4,0,0,5);
         addEventListener(MouseEvent.CLICK,this.onClick);
         buttonMode = true;
         useHandCursor = true;
      }
      
      override public function measure() : void
      {
         measuredHeight = this.bitmap.height;
         measuredWidth = this.bitmap.width;
         measuredWidth = Math.max(measuredWidth,20);
         measuredHeight = Math.max(measuredWidth,5);
      }
      
      protected function loadBitmap(classAsset:Class) : BitmapData
      {
         var loader:Bitmap = null;
         if(classAsset)
         {
            loader = new classAsset();
            return loader.bitmapData;
         }
         this.bitmap.bitmapData = null;
         return null;
      }
      
      protected function onClick(event:MouseEvent) : void
      {
      }
   }
}
