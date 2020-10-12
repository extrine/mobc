package iilwy.display.drawing
{
   import iilwy.display.drawing.model.DrawingFileData;
   import iilwy.events.ApplicationEvent;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.net.MediaProxy;
   import iilwy.ui.controls.ImageButton;
   import iilwy.ui.events.ButtonEvent;
   
   public class DrawingThumbnail extends ImageButton
   {
       
      
      private var _data:DrawingData;
      
      public function DrawingThumbnail(x:Number = 0, y:Number = 0, width:Number = 80, height:Number = 50, styleId:String = "imageButton")
      {
         super(x,y,width,height);
         tabEnabled = false;
      }
      
      public function get data() : DrawingData
      {
         return this._data;
      }
      
      public function set data(d:DrawingData) : void
      {
         this._data = d;
         if(this._data != null && this._data.url != null)
         {
            url = MediaProxy.drawing_url(this._data.url,MediaProxy.DRAWING_SIZE_SMALL_THUMB);
         }
         else
         {
            url = null;
         }
      }
      
      public function addOpenInLightboxHandler() : void
      {
         addEventListener(ButtonEvent.CLICK,this.openInLightbox);
      }
      
      public function openInLightbox(event:ButtonEvent = null) : void
      {
         var aEvent:ApplicationEvent = new ApplicationEvent(ApplicationEvent.OPEN_DRAWING_LIGHTBOX);
         var drawingFileData:DrawingFileData = new DrawingFileData();
         drawingFileData.drawing_filename = this.data.url;
         aEvent.drawingFileData = drawingFileData;
         dispatchEvent(aEvent);
      }
   }
}
