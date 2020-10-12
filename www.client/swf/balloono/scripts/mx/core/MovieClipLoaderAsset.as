package mx.core
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class MovieClipLoaderAsset extends MovieClipAsset implements IFlexAsset, IFlexDisplayObject
   {
      
      static const VERSION:String = "3.3.0.4852";
       
      
      protected var initialHeight:Number = 0;
      
      private var loader:Loader = null;
      
      private var initialized:Boolean = false;
      
      protected var initialWidth:Number = 0;
      
      private var requestedHeight:Number;
      
      private var requestedWidth:Number;
      
      public function MovieClipLoaderAsset()
      {
         super();
         var _loc1_:LoaderContext = new LoaderContext();
         _loc1_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         if("allowLoadBytesCodeExecution" in _loc1_)
         {
            _loc1_["allowLoadBytesCodeExecution"] = true;
         }
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         loader.loadBytes(movieClipData,_loc1_);
         addChild(loader);
      }
      
      override public function get width() : Number
      {
         if(!initialized)
         {
            return initialWidth;
         }
         return super.width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(!initialized)
         {
            requestedWidth = param1;
         }
         else
         {
            loader.width = param1;
         }
      }
      
      override public function get measuredHeight() : Number
      {
         return initialHeight;
      }
      
      private function completeHandler(param1:Event) : void
      {
         initialized = true;
         initialWidth = loader.width;
         initialHeight = loader.height;
         if(!isNaN(requestedWidth))
         {
            loader.width = requestedWidth;
         }
         if(!isNaN(requestedHeight))
         {
            loader.height = requestedHeight;
         }
         dispatchEvent(param1);
      }
      
      override public function set height(param1:Number) : void
      {
         if(!initialized)
         {
            requestedHeight = param1;
         }
         else
         {
            loader.height = param1;
         }
      }
      
      override public function get measuredWidth() : Number
      {
         return initialWidth;
      }
      
      override public function get height() : Number
      {
         if(!initialized)
         {
            return initialHeight;
         }
         return super.height;
      }
      
      public function get movieClipData() : ByteArray
      {
         return null;
      }
   }
}
