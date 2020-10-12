package iilwy.display.image
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import iilwy.net.MediaProxy;
   
   public class Image extends Sprite
   {
       
      
      public var _bitmap:Bitmap;
      
      private var _priority:Number = 1;
      
      private var _isRequestPending:Boolean = false;
      
      private var _url:String = "";
      
      public function Image()
      {
         super();
         this._bitmap = new Bitmap(null,"auto",true);
         this._bitmap.x = 0;
         this._bitmap.y = 0;
         addChild(this._bitmap);
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(tUrl:String) : void
      {
         this._url = tUrl;
         if(this._bitmap.bitmapData != null)
         {
            this._bitmap.bitmapData.dispose();
            this._bitmap.bitmapData = null;
         }
         if(tUrl != null)
         {
            MediaProxy.request(this._url,this.onImageLoaded,this._priority);
            this._isRequestPending = true;
         }
      }
      
      public function onImageLoaded(b:Object) : void
      {
         this._isRequestPending = false;
         if(b && b.photo)
         {
            this._bitmap.bitmapData = b.photo.bitmapData;
            width = b.photo.width;
            height = b.photo.height;
         }
         this._bitmap.smoothing = true;
         dispatchEvent(new Event("imageLoaded"));
         b = null;
      }
      
      public function set priority(tPriority:Number) : void
      {
         this._priority = tPriority;
      }
      
      public function destroy() : void
      {
         if(this._isRequestPending == true)
         {
         }
         if(this._bitmap.bitmapData != null)
         {
            removeChild(this._bitmap);
            this._bitmap.bitmapData.dispose();
            this._bitmap = null;
         }
      }
   }
}
