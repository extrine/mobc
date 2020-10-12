package iilwy.ui.controls
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import iilwy.application.AppProperties;
   import iilwy.ui.containers.UiContainer;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   import iilwy.utils.logging.Logger;
   
   public class SwfLoader extends UiContainer
   {
      
      public static const RESIZE_FIT:String = "fit";
      
      public static const RESIZE_FILL:String = "fill";
       
      
      private var _url:String;
      
      private var _urlValid:Boolean = false;
      
      protected var _pending:Boolean = false;
      
      protected var _loader:Loader;
      
      protected var _processingIndicator:ProcessingIndicator;
      
      public var resizeMode:String = "fit";
      
      public var showProcessing:Boolean = true;
      
      public var shareSecurity:Boolean;
      
      protected var _logger:Logger;
      
      public function SwfLoader(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 100)
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this._logger = Logger.getLogger(this);
         this._loader = new Loader();
         addContentChild(this._loader);
         this.maskContents = true;
         this._processingIndicator = new ProcessingIndicator();
         GraphicUtil.setColor(this._processingIndicator,2583691263);
      }
      
      override public function destroy() : void
      {
         this._loader.unload();
         this._processingIndicator.destroy();
         super.destroy();
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(s:String) : void
      {
         if(s == null)
         {
            this._logger.log("Unloading swf");
            if(this._pending)
            {
               this._pending = false;
            }
            this._loader.unload();
            this._url = s;
         }
         else if(s != this._url)
         {
            this._logger.log("Setting url to ",s);
            if(this._pending)
            {
               this._pending = false;
               this._loader.unload();
            }
            this._url = s;
            this._urlValid = false;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      override public function commitProperties() : void
      {
         var req:URLRequest = null;
         var context:LoaderContext = null;
         if(!this._urlValid)
         {
            if(this._url != null)
            {
               this._urlValid = true;
               this._pending = true;
               if(this.showProcessing)
               {
                  addContentChild(this._processingIndicator);
                  this._processingIndicator.animate = true;
               }
               req = new URLRequest(this._url);
               this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
               this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
               if(this.shareSecurity)
               {
                  context = new LoaderContext();
                  if(this._url.indexOf("http://") > -1 && AppProperties.debugMode != AppProperties.MODE_LOCAL_DEBUGGING)
                  {
                     context.securityDomain = SecurityDomain.currentDomain;
                  }
                  context.checkPolicyFile = true;
               }
               try
               {
                  this._loader.load(req,context);
               }
               catch(error:SecurityError)
               {
                  _logger.error("Security error");
               }
               this._loader.visible = false;
               this._logger.log("Loading url ",this._url);
            }
            else
            {
               if(contains(this._processingIndicator))
               {
                  removeContentChild(this._processingIndicator);
               }
               this._processingIndicator.animate = false;
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rect:Sprite = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!this._pending && this._loader.contentLoaderInfo.bytesLoaded > 1 && this._loader.contentLoaderInfo.width > 0)
         {
            rect = new Sprite();
            UiRender.renderRect(rect,0,0,0,this._loader.contentLoaderInfo.width,this._loader.contentLoaderInfo.height);
            if(this.resizeMode == RESIZE_FIT)
            {
               GraphicUtil.fitInto(rect,0,0,unscaledWidth,unscaledHeight);
            }
            else if(this.resizeMode == RESIZE_FILL)
            {
               GraphicUtil.fillInto(rect,0,0,unscaledWidth,unscaledHeight);
            }
            this._loader.x = rect.x;
            this._loader.y = rect.y;
            this._loader.scaleX = rect.width / this._loader.contentLoaderInfo.width;
            this._loader.scaleY = rect.height / this._loader.contentLoaderInfo.height;
            this._loader.visible = true;
         }
         if(contains(this._processingIndicator))
         {
            GraphicUtil.centerInto(this._processingIndicator,0,0,unscaledWidth,unscaledHeight,true);
         }
      }
      
      override public function measure() : void
      {
         super.measure();
         measuredWidth = this._loader.width;
         measuredHeight = this._loader.height;
      }
      
      protected function onLoadComplete(event:Event) : void
      {
         this._pending = false;
         invalidateDisplayList();
         if(contains(this._processingIndicator))
         {
            removeContentChild(this._processingIndicator);
         }
         this._processingIndicator.animate = false;
         var evt:Event = new Event(Event.COMPLETE,true);
         dispatchEvent(evt);
      }
      
      private function ioErrorHandler(e:Event) : void
      {
         trace(e);
      }
      
      private function securityErrorHandler(e:Event) : void
      {
         trace(e);
      }
      
      public function get loadedContent() : MovieClip
      {
         return this._loader.content as MovieClip;
      }
      
      public function stop() : void
      {
         this.loadedContent.stop();
      }
      
      public function gotoAndStop(frame:int) : void
      {
         if(this.loadedContent)
         {
            this.loadedContent.gotoAndStop(frame);
         }
      }
      
      public function gotoAndPlay(frame:int) : void
      {
         if(this.loadedContent)
         {
            this.loadedContent.gotoAndPlay(frame);
         }
      }
      
      public function get totalFrames() : int
      {
         if(this.loadedContent)
         {
            return this.loadedContent.totalFrames;
         }
         return 1;
      }
      
      public function get currentFrame() : int
      {
         if(this.loadedContent)
         {
            return this.loadedContent.currentFrame;
         }
         return 1;
      }
   }
}
