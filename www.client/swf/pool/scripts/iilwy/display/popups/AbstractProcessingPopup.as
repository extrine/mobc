package iilwy.display.popups
{
   import flash.events.Event;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.partials.ProcessingBlocker;
   import iilwy.utils.GraphicUtil;
   
   public class AbstractProcessingPopup extends UiModule
   {
       
      
      protected var processingBlocker:ProcessingBlocker;
      
      protected var processingMessage:TextBlock;
      
      public function AbstractProcessingPopup()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(ContainerEvent.START_PROCESSING,this.startProcessing);
         addEventListener(ContainerEvent.STOP_PROCESSING,this.stopProcessing);
      }
      
      override public function createChildren() : void
      {
         this.processingBlocker = new ProcessingBlocker();
         this.processingBlocker.backgroundColor = 3997977676;
         GraphicUtil.setColor(this.processingBlocker.processingIndicator,872415231);
         this.processingMessage = new TextBlock("",0,0,250,undefined,"overlayMessage");
         this.processingBlocker.messageView = this.processingMessage;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!container)
         {
            return;
         }
         if(this.processingBlocker)
         {
            this.processingBlocker.x = -container.padding.left;
            this.processingBlocker.y = -container.padding.top;
            this.processingBlocker.width = unscaledWidth + container.padding.horizontal;
            this.processingBlocker.height = unscaledHeight + container.padding.vertical;
         }
      }
      
      public function startProcessing(event:ContainerEvent = null) : void
      {
         event.stopImmediatePropagation();
         this.processingMessage.text = event.title;
         this.processingBlocker.invalidateDisplayList();
         addContentChild(this.processingBlocker);
         this.processingBlocker.visible = true;
         invalidateDisplayList();
      }
      
      public function stopProcessing(event:ContainerEvent = null) : void
      {
         if(contains(this.processingBlocker))
         {
            this.processingBlocker.visible = false;
            removeContentChild(this.processingBlocker);
         }
      }
      
      private function onAddedToStage(event:Event) : void
      {
         this.stopProcessing();
      }
   }
}
