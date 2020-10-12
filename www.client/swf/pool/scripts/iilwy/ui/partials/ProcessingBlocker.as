package iilwy.ui.partials
{
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.controls.ProcessingIndicator;
   import iilwy.ui.controls.UiElement;
   import iilwy.utils.GraphicUtil;
   
   public class ProcessingBlocker extends Canvas
   {
       
      
      public var processingIndicator:ProcessingIndicator;
      
      protected var _messageView:UiElement;
      
      public function ProcessingBlocker()
      {
         super();
         backgroundColor = 3439329279;
         this.processingIndicator = new ProcessingIndicator();
         this.processingIndicator.alpha = 0.2;
         addContentChild(this.processingIndicator);
         buttonMode = true;
         useHandCursor = false;
      }
      
      public function set messageView(view:UiElement) : void
      {
         if(this._messageView)
         {
            removeContentChild(this._messageView);
         }
         this._messageView = view;
         addContentChild(this._messageView);
         invalidateDisplayList();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         GraphicUtil.centerInto(this.processingIndicator,0,0,unscaledWidth,unscaledHeight,true);
         if(this._messageView)
         {
            GraphicUtil.centerInto(this._messageView,0,0,unscaledWidth,unscaledHeight / 2,true);
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this.processingIndicator.animate = value;
      }
   }
}
