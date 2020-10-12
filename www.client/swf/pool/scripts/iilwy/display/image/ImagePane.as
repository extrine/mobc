package iilwy.display.image
{
   import caurina.transitions.Tweener;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import iilwy.application.AppComponents;
   import iilwy.events.DataEvent;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.MathUtil;
   import iilwy.utils.Scale;
   
   public class ImagePane extends Sprite
   {
      
      public static const STRETCH:String = "Stretch";
      
      public static const FIT:String = "Fit";
      
      public static const STRETCH_FACE:String = "Stretch_face";
      
      public static const NOSCALE_CENTER:String = "Noscale_center";
      
      public static const NOSCALE_CENTER_TOP:String = "Noscale_center_top";
       
      
      protected var _image:Image;
      
      public var hasStripes:Boolean = false;
      
      private var _imageMask:Sprite;
      
      protected var _background:Sprite;
      
      private var _overlay:Sprite;
      
      private var _overlayMask:Sprite;
      
      protected var _width:Number = 250;
      
      protected var _height:Number = 250;
      
      private var _imageNativeWidth:Number = 0;
      
      private var _imageNativeHeight:Number = 0;
      
      private var _padding:Number = 10;
      
      private var _expose:Number = 0;
      
      private var _mouseOver:Boolean = false;
      
      private var _dockX:Number = 0;
      
      private var _dockY:Number = 0;
      
      private var _panEnabled:Boolean = true;
      
      private var _exposeEnabled:Boolean = false;
      
      public var soundEnabled:Boolean = true;
      
      private var _numListeners:int = 0;
      
      private var _scrollPad:Number = 50;
      
      protected var _imageMode:String = "Stretch";
      
      private var _scrollRect:Rectangle;
      
      private var _rollOutBounds:Rectangle;
      
      public var outerPadding:Number = 0;
      
      private var _autoPan:Boolean = false;
      
      private var autoPanLocation:Point;
      
      protected var _mouseEnabled:Boolean = true;
      
      public var disp:Bitmap;
      
      public var cachebit:BitmapData;
      
      public var recyclerect:Rectangle;
      
      public var np:Point;
      
      public function ImagePane()
      {
         this._image = new Image();
         this._scrollRect = new Rectangle(0,0,100,200);
         this._rollOutBounds = new Rectangle(0,0,10,10);
         this.autoPanLocation = new Point();
         super();
         var initSize:Number = 250;
         this._imageMask = new Sprite();
         this._imageMask.graphics.beginFill(0,0.1);
         this._imageMask.graphics.drawRect(0,0,initSize,initSize);
         this._overlayMask = new Sprite();
         this._overlayMask.graphics.beginFill(0,0.1);
         this._overlayMask.graphics.drawRect(0,0,initSize,initSize);
         this._background = new Sprite();
         this._background.graphics.beginFill(16777215);
         this._background.graphics.drawRect(0,0,initSize,initSize);
         this._overlay = new Sprite();
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.addChild(this._overlayMask);
         this.addChild(this._background);
         this._overlay.mask = this._overlayMask;
         this._overlay.cacheAsBitmap = true;
         addChild(this._overlay);
         this.disp = new Bitmap();
         addChild(this.disp);
         if(!this.recyclerect)
         {
            this.recyclerect = new Rectangle();
         }
         this.np = new Point();
         this.resizePane();
      }
      
      public function autoPan(x:Number, y:Number) : void
      {
         this._autoPan = true;
         this.autoPanLocation = new Point(x,y);
         if(this._imageMode == STRETCH || this._imageMode == NOSCALE_CENTER || this._imageMode == NOSCALE_CENTER_TOP || this._imageMode == STRETCH_FACE)
         {
            this.startLoop();
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(!this._panEnabled)
         {
            return;
         }
         if(this._exposeEnabled)
         {
            this.expose = 500;
            Tweener.addTween(this,{
               "expose":0,
               "time":1,
               "rounded":true,
               "transition":"easeIn"
            });
         }
         this._mouseOver = true;
         this._autoPan = false;
         if(this._imageMode == STRETCH || this._imageMode == NOSCALE_CENTER || this._imageMode == NOSCALE_CENTER_TOP || this._imageMode == STRETCH_FACE)
         {
            this.startLoop();
         }
         if(this.soundEnabled)
         {
            AppComponents.soundManager.playSound("clink");
         }
      }
      
      public function set expose(tValue:Number) : void
      {
         this._expose = tValue;
         this.transform.colorTransform = new ColorTransform(1,1,1,1,this._expose,this._expose,this._expose,0);
      }
      
      public function get expose() : Number
      {
         return this._expose;
      }
      
      public function get innerImage() : Image
      {
         return this._image;
      }
      
      public function recenter() : void
      {
         this.startLoop();
         this.onRollOut();
      }
      
      protected function onRollOut(evt:MouseEvent = null) : void
      {
         var ideal:Object = null;
         this._mouseOver = false;
         if(this._imageMode == NOSCALE_CENTER)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_ORIGINAL,0,0,Scale.POS_CENTER);
         }
         else if(this._imageMode == NOSCALE_CENTER_TOP)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_ORIGINAL,0,0,Scale.POS_UPPER_LEFT);
         }
         else if(this._imageMode == STRETCH_FACE)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_PAD,0,this._padding,Scale.POS_FACETOP);
         }
         else
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_PAD,0,this._padding,Scale.POS_FACE);
         }
         this._dockX = ideal.x;
         this._dockY = ideal.y;
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var percentY:Number = NaN;
         var percentX:Number = NaN;
         if(this._mouseOver)
         {
            percentY = Math.min(Math.max(this.mouseY,this._scrollPad),this.height - this._scrollPad) / (this.height - this._scrollPad * 2) - this._scrollPad / (this.height - this._scrollPad * 2);
            percentX = Math.min(Math.max(this.mouseX,this._scrollPad),this.width - this._scrollPad) / (this.width - this._scrollPad * 2) - this._scrollPad / (this.width - this._scrollPad * 2);
            MathUtil.clamp(percentX,0,1);
            MathUtil.clamp(percentY,0,1);
            this._dockX = (this.width - this._image.width) * percentX;
            this._dockY = (this.height - this._image.height) * percentY;
            this._rollOutBounds.x = -this.outerPadding;
            this._rollOutBounds.y = -this.outerPadding;
            this._rollOutBounds.width = this.width + 2 * this.outerPadding;
            this._rollOutBounds.height = this.height + 2 * this.outerPadding;
            if(!this._rollOutBounds.contains(mouseX,mouseY))
            {
               this.onRollOut();
            }
         }
         else if(this._autoPan)
         {
            this._dockX = (this.width - this._image.width) * this.autoPanLocation.x;
            this._dockY = (this.height - this._image.height) * this.autoPanLocation.y;
         }
         else if(Math.abs(this._dockX - this._image.x) < 1 && Math.abs(this._dockY - this._image.y) < 1)
         {
            this.stopLoop();
         }
         this._image.x = this._image.x + (this._dockX - this._image.x) * 0.1;
         this._image.y = this._image.y + (this._dockY - this._image.y) * 0.1;
         dispatchEvent(new Event("imagePaneMove"));
         this.updatebit();
      }
      
      public function updatebit() : void
      {
         if(this.cachebit)
         {
            this.recyclerect.x = -this._image.x;
            this.recyclerect.y = -this._image.y;
            this.recyclerect.width = this.disp.bitmapData.width;
            this.recyclerect.height = this.disp.bitmapData.height;
            this.disp.bitmapData.copyPixels(this.cachebit,this.recyclerect,this.np);
         }
      }
      
      public function get panX() : Number
      {
         return this._dockX / (this.width - this._image.width);
      }
      
      public function set panX(n:Number) : void
      {
         this._dockX = (this.width - this._image.width) * n;
         this._image.x = this._dockX;
         this.updatebit();
      }
      
      public function get panY() : Number
      {
         return this._dockY / (this.height - this._image.height);
      }
      
      public function set panY(n:Number) : void
      {
         this._dockY = (this.height - this._image.height) * n;
         this._image.y = this._dockY;
         this.updatebit();
      }
      
      public function set backgroundColor(n:Number) : void
      {
         GraphicUtil.setColor(this._background,n);
      }
      
      public function get url() : String
      {
         return this._image.url;
      }
      
      public function set url(tUrl:String) : void
      {
         this._image.removeEventListener("imageLoaded",this.onImageLoaded);
         this._image.addEventListener("imageLoaded",this.onImageLoaded,false,0,true);
         this._image.url = tUrl;
         var _this:Sprite = this;
         this._image.cacheAsBitmap = false;
      }
      
      private function onImageLoaded(event:Event) : void
      {
         this._imageNativeWidth = event.currentTarget.width;
         this._imageNativeHeight = event.currentTarget.height;
         this.resizePane();
         if(!this._exposeEnabled)
         {
         }
         this.onPhotoLoaded();
      }
      
      public function onPhotoLoaded() : void
      {
         var evt:DataEvent = new DataEvent("imagePaneLoaded",true,true,{
            "nativeWidth":this._imageNativeWidth,
            "nativeHeight":this._imageNativeHeight
         });
         dispatchEvent(evt);
      }
      
      public function set priority(tPriority:Number) : void
      {
         this._image.priority = tPriority;
      }
      
      override public function set width(tWidth:Number) : void
      {
         this._width = tWidth;
         this.resizePane();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(tHeight:Number) : void
      {
         this._height = tHeight;
         this.resizePane();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function get nativeWidth() : Number
      {
         return this._imageNativeWidth;
      }
      
      public function get nativeHeight() : Number
      {
         return this._imageNativeHeight;
      }
      
      public function get panEnabled() : Boolean
      {
         return this._panEnabled;
      }
      
      public function set panEnabled(value:Boolean) : void
      {
         var bounds:Rectangle = null;
         this._panEnabled = value;
         if(value)
         {
            bounds = new Rectangle(0,0,this.width,this.height);
            if(bounds.contains(mouseX,mouseY))
            {
               this.onRollOver(null);
            }
         }
         else
         {
            this.stopLoop();
         }
      }
      
      public function set exposeEnabled(tValue:Boolean) : void
      {
         this._exposeEnabled = tValue;
      }
      
      public function dropIn() : void
      {
      }
      
      private function startLoop() : void
      {
         this.stopLoop();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._numListeners++;
      }
      
      private function stopLoop() : void
      {
         for(var t:int = 0; t < this._numListeners; t++)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this._numListeners = 0;
      }
      
      public function set imageMode(t:String) : void
      {
         this._imageMode = t;
         if(t == FIT)
         {
            this.stopLoop();
            dispatchEvent(new Event("imagePaneMove"));
            dispatchEvent(new Event("imagePaneResize"));
         }
         this.resizePane();
      }
      
      public function get imageMode() : String
      {
         return this._imageMode;
      }
      
      protected function resizePane() : void
      {
         var ideal:Object = null;
         this._background.width = this._width;
         this._background.height = this._height;
         var rect:Rectangle = new Rectangle(0,0,this._width,this._height);
         this._imageMask.width = this._width;
         this._imageMask.height = this._height;
         this._overlayMask.width = this._width;
         this._overlayMask.height = this._height;
         if(this._imageMode == STRETCH)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_PAD,0,this._padding,Scale.POS_FACE);
         }
         else if(this._imageMode == NOSCALE_CENTER)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_ORIGINAL,0,0,Scale.POS_CENTER);
         }
         else if(this._imageMode == NOSCALE_CENTER_TOP)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_ORIGINAL,0,0,Scale.POS_UPPER_LEFT);
         }
         else if(this._imageMode == STRETCH_FACE)
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_PAD,0,this._padding,Scale.POS_FACETOP);
         }
         else
         {
            ideal = Scale.scaleContent(this._width,this._height,this._imageNativeWidth,this._imageNativeHeight,Scale.SCALE_FIT,0,this._padding,Scale.POS_CENTER);
         }
         this._image.height = ideal.height;
         this._image.width = ideal.width;
         this._image.x = ideal.x;
         this._image.y = ideal.y;
         this.recyclerect.x = -this._image.x;
         this.recyclerect.y = -this._image.y;
         this._dockX = this._image.x;
         this._dockY = this._image.y;
         if(this.disp && this.disp.bitmapData)
         {
            this.disp.bitmapData.dispose();
         }
         if(this.disp && this._width > 0 && this._height > 0)
         {
            this.disp.bitmapData = new BitmapData(this._width,this._height,true,4294967295);
         }
         if(this._image.width > 0 && this._image.height > 0)
         {
            this.cachebit = new BitmapData(this._image.width,this._image.height,true,4294967295);
            this.cachebit.draw(this._image,new Matrix(this._image.scaleX,0,0,this._image.scaleY));
            this.onEnterFrame(null);
         }
         this.updatebit();
      }
      
      public function get overlay() : Sprite
      {
         return this._overlay;
      }
      
      public function set overlay(f:Sprite) : void
      {
         this._overlay = f;
      }
      
      public function set scrollPad(t:Number) : void
      {
         this._scrollPad = t;
      }
      
      public function destroy() : void
      {
         try
         {
            this.stopLoop();
            removeChild(this._imageMask);
            removeChild(this._overlayMask);
            removeChild(this._background);
            removeChild(this._image);
            removeChild(this._overlay);
            this._image.destroy();
            if(this.disp && this.disp.parent)
            {
               this.disp.parent.removeChild(this.disp);
            }
            if(this.disp)
            {
               if(this.disp.bitmapData)
               {
                  this.disp.bitmapData.dispose();
               }
               this.disp = null;
            }
            if(this.cachebit)
            {
               this.cachebit.dispose();
            }
            this.recyclerect = null;
            this.np = null;
         }
         catch(err:Error)
         {
         }
      }
   }
}
