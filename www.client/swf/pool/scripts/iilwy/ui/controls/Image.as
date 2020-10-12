package iilwy.ui.controls
{
   import caurina.transitions.Tweener;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.CapType;
   import iilwy.utils.BitmapCache;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   import iilwy.utils.logging.Logger;
   
   public class Image extends UiElement
   {
      
      public static const RESIZE_NONE:String = "none";
      
      public static const RESIZE_FIT:String = "fit";
      
      public static const RESIZE_STRETCH:String = "stretch";
      
      public static const RESIZE_AUTO:String = "auto";
      
      public static const RESIZE_FILL:String = "fill";
      
      private static const CLEAR_BITMAP_DATA:BitmapData = new BitmapData(1,1,true,16777215);
      
      private static var stageRect:Rectangle;
       
      
      public var autoLoad:Boolean = true;
      
      public var bitmapCache:BitmapCache;
      
      public var fadeTransition:Boolean;
      
      public var deferredLoad:Boolean;
      
      protected var background:Sprite;
      
      protected var contentMask:Sprite;
      
      protected var deferredTimer:Timer;
      
      protected var deferredURL:String;
      
      protected var deferredBytes:ByteArray;
      
      protected var logger:Logger;
      
      protected var loader:Loader;
      
      protected var urlOrBytesValid:Boolean;
      
      protected var pending:Boolean;
      
      protected var globalRect:Rectangle;
      
      protected var globalPos:Point;
      
      protected var _bitmap:Bitmap;
      
      protected var _url:String;
      
      protected var _bytes:ByteArray;
      
      protected var _borderColor:Number;
      
      protected var _borderSize:Number;
      
      protected var _cornerRadius:Number;
      
      protected var _backgroundColor:Number;
      
      protected var _backgroundGradient:Array;
      
      protected var _backgroundGradientAngle:Number;
      
      protected var _resizeMode:String = "auto";
      
      protected var _maskContents:Boolean;
      
      public function Image(x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = undefined, styleId:String = "image")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setStyleById(styleId);
         this.background = new Sprite();
         addChild(this.background);
         UiRender.renderRect(this.background,0,0,0,1,1);
         this._bitmap = new Bitmap();
         this._bitmap.bitmapData = new BitmapData(10,10);
         this._bitmap.smoothing = true;
         addChild(this._bitmap);
         mouseEnabled = true;
         mouseChildren = false;
         this.deferredTimer = new Timer(1000);
         this.deferredTimer.addEventListener(TimerEvent.TIMER,this.onDeferredTimer);
         this.logger = Logger.getLogger(this);
         this.logger.level = Logger.ERROR;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onLoaderError);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
         this.loader.contentLoaderInfo.addEventListener(Event.OPEN,this.onLoaderOpen);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      override public function destroy() : void
      {
         this.deferredTimer.stop();
         super.destroy();
      }
      
      override public function commitProperties() : void
      {
         var load:Boolean = false;
         var id:String = null;
         if(!this.urlOrBytesValid)
         {
            load = true;
            if(this.useBitmapCache)
            {
               id = this.generateBitmapCacheId();
               if((this._url || this._bytes) && this.bitmapCache.contains(id))
               {
                  load = false;
                  this._bitmap.bitmapData = this.bitmapCache.getItem(id);
                  this._bitmap.smoothing = true;
                  invalidateDisplayList();
               }
            }
            else
            {
               try
               {
                  if(this._bitmap.bitmapData)
                  {
                     this._bitmap.bitmapData.dispose();
                  }
               }
               catch(e:Error)
               {
               }
            }
            if(load)
            {
               if(this.autoLoad && (this._url || this._bytes))
               {
                  this.loadImage();
               }
            }
            this.urlOrBytesValid = true;
         }
         else
         {
            invalidateDisplayList();
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.background.width = unscaledWidth;
         this.background.height = unscaledHeight;
         GraphicUtil.setColor(this.background,getValidValue(this._borderColor,style.borderColor));
         this.resizeBitmap(unscaledWidth,unscaledHeight);
         if(style.filters)
         {
            filters = style.filters;
         }
      }
      
      public function clearImmediately() : void
      {
         this._url = null;
      }
      
      public function resizeBitmap(width:Number, height:Number) : void
      {
         var rect:Rectangle = null;
         if(this._bitmap.width == 0 || this._bitmap.height == 0)
         {
            return;
         }
         var bSize:Number = getValidValue(this._borderSize,style.borderSize,0);
         rect = new Rectangle(0,0,width,height);
         rect.inflate(-bSize,-bSize);
         if(this.resizeMode == RESIZE_FIT)
         {
            GraphicUtil.fitInto(this._bitmap,rect.x,rect.y,rect.width,rect.height);
         }
         else if(this.resizeMode == RESIZE_STRETCH)
         {
            this._bitmap.x = rect.x;
            this._bitmap.y = rect.y;
            this._bitmap.width = rect.width;
            this._bitmap.height = rect.height;
         }
         else if(this.resizeMode == RESIZE_AUTO)
         {
            this._bitmap.x = rect.x;
            this._bitmap.y = rect.y;
            this._bitmap.width = rect.width;
            this._bitmap.height = rect.height;
         }
         else if(this.resizeMode == RESIZE_FILL)
         {
            GraphicUtil.fillInto(this._bitmap,rect.x,rect.y,rect.width,rect.height);
         }
         else if(this.resizeMode == RESIZE_NONE)
         {
            this._bitmap.x = rect.x;
            this._bitmap.y = rect.y;
            this._bitmap.scaleX = 1;
            this._bitmap.scaleY = 1;
         }
         if(this._maskContents)
         {
            this.contentMask.x = rect.x;
            this.contentMask.y = rect.y;
            this.contentMask.width = rect.width;
            this.contentMask.height = rect.height;
         }
      }
      
      public function load() : void
      {
         if(!this.urlOrBytesValid && this._url != null)
         {
            try
            {
               this._bitmap.bitmapData.dispose();
            }
            catch(e:Error)
            {
            }
            this.urlOrBytesValid = true;
            this.loadImage();
         }
      }
      
      protected function loadImage() : void
      {
         var req:URLRequest = null;
         this.cancelLoad();
         var context:LoaderContext = new LoaderContext();
         if(this._url)
         {
            context.checkPolicyFile = true;
            req = new URLRequest(this._url);
            this.loader.load(req,context);
         }
         else
         {
            context.checkPolicyFile = false;
            this.loader.loadBytes(this._bytes,context);
         }
         dispatchEvent(new UiEvent(UiEvent.LOAD_BEGIN,this,true));
      }
      
      protected function cancelLoad() : void
      {
         this.loader.unload();
      }
      
      protected function drawBackground() : void
      {
         var xOffset:int = 0;
         var yOffset:int = 0;
         var fill:Array = null;
         var angle:Number = NaN;
         var rect:Rectangle = null;
         var cRad:Number = getValidValue(this._cornerRadius,style.cornerRadius,0);
         var containerBackground:Sprite = this.background;
         containerBackground.graphics.clear();
         containerBackground.scaleX = 1;
         containerBackground.scaleY = 1;
         var brdrCol:Number = getValidValue(this.borderColor,style.backgroundColor);
         var brdrSize:Number = getValidValue(this.borderSize,style.borderSize,0);
         if(brdrSize > 0 || !isNaN(brdrCol))
         {
            UiRender.renderRoundRect(containerBackground,brdrCol,0,0,100,100,cRad);
         }
         xOffset = xOffset + this.borderSize / 2;
         yOffset = yOffset + this.borderSize / 2;
         cRad = cRad - this.borderSize / 2;
         var grad:Array = getValidValue(this.backgroundGradient,style.backgroundGradient);
         var col:Number = getValidValue(this.backgroundColor,style.backgroundColor);
         if(grad)
         {
            fill = grad;
         }
         else if(!isNaN(col))
         {
            fill = [col,col];
         }
         if(fill)
         {
            angle = getValidValue(this.backgroundGradientAngle,style.backgroundGradientAngle,90);
            UiRender.renderGradient(containerBackground,fill,angle * Math.PI / 180,xOffset,yOffset,100,100,CapType.getCornersForType(CapType.ROUND,cRad));
         }
         if(cRad > 0)
         {
            rect = new Rectangle(cRad / 2,cRad / 2,100 - cRad,100 - cRad);
            containerBackground.scale9Grid = rect;
         }
      }
      
      protected function generateBitmapCacheId() : String
      {
         return Boolean(this._url)?this._url:Boolean(this._bytes)?this._bytes.toString():null;
      }
      
      protected function displayLoadedBitmap(bd:BitmapData) : void
      {
         if(!bd)
         {
            return;
         }
         this.pending = false;
         this._bitmap.scaleX = 1;
         this._bitmap.scaleY = 1;
         this._bitmap.bitmapData = bd;
         if(this.bitmapCache && this._url)
         {
            this.bitmapCache.addItem(this._url,bd);
         }
         this._bitmap.smoothing = true;
         if(this.resizeMode == RESIZE_AUTO)
         {
            width = this._bitmap.bitmapData.width;
            height = this._bitmap.bitmapData.height;
         }
         invalidateDisplayList();
         dispatchEvent(new UiEvent(UiEvent.LOAD_COMPLETE,this,true));
         if(this.fadeTransition)
         {
            Tweener.removeTweens(this._bitmap);
            this._bitmap.alpha = 0;
            Tweener.addTween(this._bitmap,{
               "alpha":1,
               "time":0.4,
               "transition":"easeInOutCubic"
            });
         }
      }
      
      protected function setURLOrBytes(url:String = null, bytes:ByteArray = null) : void
      {
         if(url == null && bytes == null || url != this._url || bytes != this._bytes)
         {
            if(this.pending)
            {
               this.pending = false;
               this.cancelLoad();
            }
            if(this._bitmap.bitmapData)
            {
               if(!this.useBitmapCache)
               {
                  this._bitmap.bitmapData.dispose();
               }
               this._bitmap.bitmapData = null;
            }
            if(this.deferredLoad && (url || bytes))
            {
               this.logger.log("deferring ",Boolean(url)?url:bytes);
               this.urlOrBytesValid = true;
               if(url)
               {
                  this.deferredURL = url;
                  this.deferredBytes = null;
               }
               else
               {
                  this.deferredURL = null;
                  this.deferredBytes = bytes;
               }
               this._url = null;
               this._bytes = null;
               this.deferredTimer.delay = 400;
               this.deferredTimer.reset();
               this.deferredTimer.start();
            }
            else
            {
               this.logger.log("loading ",Boolean(url)?url:bytes);
               if(url)
               {
                  this._url = url;
                  this._bytes = null;
               }
               else
               {
                  this._url = null;
                  this._bytes = bytes;
               }
               this.urlOrBytesValid = false;
               this.deferredTimer.stop();
            }
            invalidateProperties();
         }
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(value:String) : void
      {
         this.setURLOrBytes(value);
      }
      
      public function get bytes() : ByteArray
      {
         return this._bytes;
      }
      
      public function set bytes(value:ByteArray) : void
      {
         this.setURLOrBytes(null,value);
      }
      
      public function get maskContents() : Boolean
      {
         return this._maskContents;
      }
      
      public function set maskContents(value:Boolean) : void
      {
         if(value)
         {
            if(!this.contentMask)
            {
               this.contentMask = new Sprite();
               this.contentMask.mouseEnabled = false;
            }
            if(!this._maskContents)
            {
               addChild(this.contentMask);
               UiRender.renderRect(this.contentMask,872349696,0,0,100,100);
               this._bitmap.mask = this.contentMask;
            }
         }
         else if(this._maskContents)
         {
            this.contentMask.graphics.clear();
            removeChild(this.contentMask);
            this._bitmap.mask = null;
         }
         this._maskContents = value;
      }
      
      public function set bitmapData(value:BitmapData) : void
      {
         this._bitmap.bitmapData = value;
         this._bitmap.smoothing = true;
         invalidateDisplayList();
      }
      
      public function get bitmap() : Bitmap
      {
         return this._bitmap;
      }
      
      public function get resizeMode() : String
      {
         return this._resizeMode;
      }
      
      public function set resizeMode(value:String) : void
      {
         this._resizeMode = value;
      }
      
      public function get size() : Number
      {
         return Math.max(width,height);
      }
      
      public function set size(n:Number) : void
      {
         width = height = n;
      }
      
      public function get borderColor() : Number
      {
         return this._borderColor;
      }
      
      public function set borderColor(n:Number) : void
      {
         this._borderColor = n;
         invalidateDisplayList();
      }
      
      public function get borderSize() : Number
      {
         return this._borderSize;
      }
      
      public function set borderSize(n:Number) : void
      {
         this._borderSize = n;
         invalidateDisplayList();
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(n:Number) : void
      {
         this._cornerRadius = n;
         invalidateDisplayList();
      }
      
      public function get backgroundColor() : Number
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(value:Number) : void
      {
         this._backgroundColor = value;
         invalidateDisplayList();
      }
      
      public function get backgroundGradient() : Array
      {
         return this._backgroundGradient;
      }
      
      public function set backgroundGradient(value:Array) : void
      {
         this._backgroundGradient = value;
         invalidateDisplayList();
      }
      
      public function get backgroundGradientAngle() : Number
      {
         return this._backgroundGradientAngle;
      }
      
      public function set backgroundGradientAngle(value:Number) : void
      {
         this._backgroundGradientAngle = value;
         invalidateDisplayList();
      }
      
      protected function get onStage() : Boolean
      {
         if(!stage)
         {
            return false;
         }
         var s:Stage = stage;
         if(!this.globalPos)
         {
            this.globalPos = new Point();
         }
         this.globalPos.x = 0;
         this.globalPos.y = 0;
         this.globalPos = localToGlobal(this.globalPos);
         if(this.globalPos.x > s.stageWidth)
         {
            return false;
         }
         if(this.globalPos.y > s.stageHeight)
         {
            return false;
         }
         if(!this.globalRect)
         {
            this.globalRect = new Rectangle();
         }
         if(!stageRect)
         {
            stageRect = new Rectangle();
         }
         this.globalRect.x = this.globalPos.x;
         this.globalRect.y = this.globalPos.y;
         this.globalRect.width = getExplicitOrMeasuredWidth();
         this.globalRect.height = getExplicitOrMeasuredHeight();
         stageRect.width = s.stageWidth;
         stageRect.height = s.stageHeight;
         if(this.globalRect.intersects(stageRect))
         {
            return true;
         }
         return false;
      }
      
      protected function get useBitmapCache() : Boolean
      {
         return this.bitmapCache != null;
      }
      
      protected function onLoaderComplete(event:Event) : void
      {
         var b:Bitmap = null;
         var bd:BitmapData = null;
         try
         {
            if(this.loader.content is Bitmap)
            {
               b = Bitmap(this.loader.content);
            }
         }
         catch(error:Error)
         {
            logger.error(error.message);
         }
         if(b)
         {
            bd = b.bitmapData;
         }
         this.cancelLoad();
         this.displayLoadedBitmap(bd);
      }
      
      protected function onLoaderOpen(event:Event) : void
      {
      }
      
      protected function onLoaderError(event:Event) : void
      {
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         if(this.deferredURL || this.deferredBytes)
         {
            this.deferredTimer.start();
         }
      }
      
      protected function onDeferredTimer(event:TimerEvent) : void
      {
         if(!stage)
         {
            this.deferredTimer.stop();
         }
         else if(this.onStage)
         {
            this._url = this.deferredURL;
            this._bytes = this.deferredBytes;
            this.urlOrBytesValid = false;
            this.deferredTimer.stop();
            this.deferredURL = null;
            this.deferredBytes = null;
            invalidateProperties();
         }
         else
         {
            this.deferredTimer.delay = 1000;
         }
      }
   }
}
