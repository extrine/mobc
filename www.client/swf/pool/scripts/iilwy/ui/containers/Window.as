package iilwy.ui.containers
{
   import caurina.transitions.Tweener;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.display.core.FocusManager;
   import iilwy.graphics.GradientFill;
   import iilwy.managers.GraphicManager;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.Image;
   import iilwy.ui.controls.Label;
   import iilwy.ui.controls.SwfLoader;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlState;
   import iilwy.ui.utils.FocusGroupSpriteProxy;
   import iilwy.ui.utils.IFocusGroup;
   import iilwy.utils.BitmapCache;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.MathUtil;
   import iilwy.utils.Scale9Image;
   import iilwy.utils.Scale9Mask;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class Window extends ModuleContainer
   {
      
      public static const CHROME_TOP_HEIGHT:int = 33;
      
      public static const CHROME_BOTTOM_HEIGHT:int = 24;
      
      public static const CHROME_PADDING:Number = 8;
      
      public static const CHROME_CONTROL_SIZE:Number = 16;
      
      public static const CHROME_CONTROL_CORNER_RADIUS:Number = 6;
      
      public static const CHROME_CONTROL_GAP:Number = 4;
      
      public static const TOP_OVERLAY_OFFSET:Number = 2;
      
      protected static var bgCache:BitmapCache = new BitmapCache();
       
      
      protected var _title:String;
      
      protected var _titleLabel:Label;
      
      private var _blocker:Sprite;
      
      public var blockBelow:Boolean;
      
      public var dimBelow:Boolean;
      
      private var _iconHolder:Sprite;
      
      private var _iconClass:Class;
      
      private var _iconType:Number = 0;
      
      private var _iconValid:Boolean = false;
      
      private var _controlsTopRight:Sprite;
      
      private var _closeButton:IconButton;
      
      private var _minimizeButton:IconButton;
      
      private var _additionalTopRightControls:Array;
      
      private var _controlsTopRightValid:Boolean = false;
      
      private var _storedMinHeight:Number;
      
      private var _outsideBorder:Sprite;
      
      private var _border:Sprite;
      
      private var _chrome:Sprite;
      
      private var _chromeValid:Boolean = false;
      
      private var _minimizedChrome:Sprite;
      
      private var _minimizedChromeValid:Boolean = false;
      
      private var _backgroundHolder:Sprite;
      
      private var _background:Scale9Image;
      
      private var _backgroundImage:Image;
      
      private var _backgroundImageMask:Scale9Mask;
      
      private var _backgroundSwfLoader:SwfLoader;
      
      private var _backgroundSwfMask:Scale9Mask;
      
      private var _backgroundStripes:Sprite;
      
      private var _backgroundTopOverlay:Sprite;
      
      private var _backgroundImageURL:String;
      
      private var _backgroundImageValid:Boolean = false;
      
      private var _backgroundStripesColor:Number;
      
      private var _backgroundStripesGradientFill:GradientFill;
      
      private var _backgroundStripesValid:Boolean = false;
      
      private var _backgroundStripesOffset:Rectangle;
      
      protected var _topBarHeight:Number = 33;
      
      protected var _bottomBarHeight:Number = 24;
      
      protected var _topBarValid:Boolean = false;
      
      private var _alertStep:Boolean = false;
      
      private var _alertTransform:ColorTransform;
      
      protected var _alertTimer:Timer;
      
      private var _alertGradient:Sprite;
      
      private var _alertHolder:Sprite;
      
      private var _topHit:Sprite;
      
      private var _resizeHit:Sprite;
      
      private var _dragOffset:Point;
      
      public var autoRemove:Boolean = false;
      
      public var autoHide:Boolean = false;
      
      public var autoMinimize:Boolean = true;
      
      public var autoDestroy:Boolean = false;
      
      public var autoCenter:Boolean = false;
      
      private var _chromelessTop:Boolean = false;
      
      private var _chromelessBottom:Boolean = false;
      
      private var _draggable:Boolean = true;
      
      private var _resizable:Boolean = true;
      
      private var _minimizable:Boolean = true;
      
      private var _closable:Boolean = true;
      
      protected var _state:String;
      
      public var minimizedDimensions:Rectangle;
      
      public var maximizedDimensions:Rectangle;
      
      protected var _focusGroupProxy:FocusGroupSpriteProxy;
      
      public var isAnimating:Boolean = false;
      
      public var autoFocus:Boolean = true;
      
      private var _minimizedShadow:DropShadowFilter;
      
      private var _maximizedShadow:DropShadowFilter;
      
      public function Window(title:String = null, x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200, styleId:String = "window")
      {
         this._additionalTopRightControls = [];
         this.minimizedDimensions = new Rectangle();
         this.maximizedDimensions = new Rectangle();
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this.title = title;
         minWidth = 100;
         super.minHeight = 60;
         setStyleById(styleId);
         setPadding(10,10,10,10);
         maskContents = true;
         this._alertGradient = new Sprite();
         addChild(this._alertGradient);
         this._topHit = new Sprite();
         addChild(this._topHit);
         UiRender.renderRect(this._topHit,33488896,0,0,100,CHROME_TOP_HEIGHT);
         this._topHit.addEventListener(MouseEvent.MOUSE_DOWN,this.onTopBarMouseDown);
         this._iconHolder = new Sprite();
         this._iconHolder.x = CHROME_PADDING;
         this._iconHolder.y = CHROME_PADDING;
         addChild(this._iconHolder);
         this._titleLabel = new Label("",CHROME_PADDING,CHROME_PADDING);
         this._titleLabel.autoSize = TextFieldAutoSize.NONE;
         this._titleLabel.selectable = false;
         this._titleLabel.mouseEnabled = false;
         this._titleLabel.mouseChildren = false;
         addChild(this._titleLabel);
         this._controlsTopRight = new Sprite();
         addChild(this._controlsTopRight);
         this._controlsTopRight.y = CHROME_PADDING;
         this._closeButton = new IconButton(GraphicManager.iconX2);
         this._closeButton.x = -CHROME_CONTROL_SIZE;
         this._closeButton.cornerRadius = CHROME_CONTROL_CORNER_RADIUS;
         this._controlsTopRight.addChild(this._closeButton);
         this._minimizeButton = new IconButton(GraphicManager.iconMinimize);
         this._minimizeButton.x = -CHROME_CONTROL_SIZE;
         this._minimizeButton.cornerRadius = CHROME_CONTROL_CORNER_RADIUS;
         this._controlsTopRight.addChild(this._minimizeButton);
         this._closeButton.addEventListener(ButtonEvent.CLICK,this.onCloseClick);
         this._minimizeButton.addEventListener(ButtonEvent.CLICK,this.onMinimizeClick);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onElementClick);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         addEventListener(ContainerEvent.START_ALERT,this.onStartAlert);
         addEventListener(ContainerEvent.STOP_ALERT,this.onStopAlert);
         addEventListener(ContainerEvent.SET_TITLE,this.onSetTitle);
         addEventListener(ContainerEvent.UPDATE_BACKGROUND,this.onUpdateBackground);
         addEventListener(ContainerEvent.UNMASK_CONTENTS,this.onUnmaskContents);
         addEventListener(UiEvent.FOCUS,this.onUiFocus);
         addEventListener(ContainerEvent.CLOSE,this.onClose);
         this._alertTimer = new Timer(800);
         this._alertTimer.addEventListener(TimerEvent.TIMER,this.onAlertTimerStep);
         this._alertTransform = new ColorTransform();
         this._outsideBorder = new Sprite();
         this._outsideBorder.mouseEnabled = false;
         this._outsideBorder.buttonMode = false;
         addChildAt(this._outsideBorder,0);
         this._border = new Sprite();
         this._border.mouseEnabled = false;
         this._border.buttonMode = false;
         addChildAt(this._border,0);
         this._resizeHit = new Sprite();
         addChild(this._resizeHit);
         UiRender.renderRect(this._resizeHit,33488896,0,0,CHROME_BOTTOM_HEIGHT,CHROME_BOTTOM_HEIGHT);
         this._resizeHit.addEventListener(MouseEvent.MOUSE_DOWN,this.onResizeMouseDown);
         this._chrome = new Sprite();
         this._minimizedChrome = new Sprite();
         setChromePadding(CHROME_TOP_HEIGHT,0,CHROME_BOTTOM_HEIGHT,0);
         this._backgroundHolder = new Sprite();
         this._chrome.addChild(this._backgroundHolder);
         this._backgroundImage = new Image();
         this._backgroundImage.resizeMode = Image.RESIZE_FILL;
         this._backgroundImage.maskContents = true;
         this._backgroundImage.bitmapCache = bgCache;
         this._backgroundImage.visible = false;
         this._backgroundImage.mouseEnabled = false;
         this._backgroundImage.buttonMode = false;
         this._backgroundHolder.addChild(this._backgroundImage);
         this._backgroundSwfLoader = new SwfLoader();
         this._backgroundSwfLoader.resizeMode = SwfLoader.RESIZE_FILL;
         this._backgroundSwfLoader.maskContents = true;
         this._backgroundSwfLoader.visible = false;
         this._backgroundSwfLoader.mouseEnabled = false;
         this._backgroundSwfLoader.buttonMode = false;
         this._backgroundHolder.addChild(this._backgroundSwfLoader);
         this._backgroundStripes = new Sprite();
         this._backgroundStripes.mouseEnabled = false;
         this._backgroundStripes.buttonMode = false;
         this._backgroundHolder.addChild(this._backgroundStripes);
         this._backgroundTopOverlay = new Sprite();
         this._backgroundTopOverlay.mouseEnabled = false;
         this._backgroundTopOverlay.buttonMode = false;
         this._backgroundHolder.addChild(this._backgroundTopOverlay);
         this._maximizedShadow = new DropShadowFilter(8,90,0,0.6,25,25,1,1);
         this._minimizedShadow = new DropShadowFilter(5,90,0,0.3,15,15,1,1);
         this._chrome.filters = [this._maximizedShadow];
         this._minimizedChrome.filters = [this._minimizedShadow];
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(ContainerEvent.MINIMIZE,this.onContentMinimize);
         mouseEnabled = true;
      }
      
      public function initialize() : void
      {
         setStyleById("window");
         setPadding(10,10,10,10);
         this.title = "";
         maskContents = true;
         this.setState(ControlState.DEFAULT);
         this.icon = null;
         this._iconType = 0;
         x = 0;
         y = 0;
         minWidth = 0;
         super.minHeight = 0;
         this._storedMinHeight = NaN;
         maxWidth = 99999999;
         maxHeight = 99999999;
         visible = true;
         alpha = 1;
         this.closable = true;
         this.draggable = true;
         this.minimizable = true;
         this.resizable = true;
         this.dimBelow = false;
         this.blockBelow = false;
         this.autoCenter = false;
         this.chromelessTop = false;
         this.chromelessBottom = false;
         this.backgroundColor = NaN;
         this.backgroundGradient = null;
         this._backgroundImage.url = null;
         this._backgroundImage.visible = false;
         this._backgroundImage.alpha = 1;
         this._backgroundSwfLoader.url = null;
         this._backgroundSwfLoader.visible = false;
         this._backgroundSwfLoader.alpha = 1;
         this._backgroundStripesOffset = null;
         this.autoMinimize = true;
         this.autoDestroy = false;
         this.isAnimating = false;
         this.autoFocus = true;
         this.onStopAlert(null);
         stopProcessing(null);
         var len:int = this._additionalTopRightControls.length;
         for(var i:int = 0; i < len; i++)
         {
            this._controlsTopRight.removeChild(this._additionalTopRightControls[i]);
         }
         this._additionalTopRightControls = [];
      }
      
      override public function destroy() : void
      {
         removeEventListener(UiEvent.FOCUS,this.onUiFocus);
         this._topHit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTopBarMouseDown);
         this._resizeHit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onResizeMouseDown);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTopBarMouseUp);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTopBarDrag);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onResizeDrag);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onResizeMouseUp);
         removeEventListener(ContainerEvent.START_ALERT,this.onStartAlert);
         removeEventListener(ContainerEvent.STOP_ALERT,this.onStopAlert);
         removeEventListener(ContainerEvent.SET_TITLE,this.onSetTitle);
         removeEventListener(ContainerEvent.UNMASK_CONTENTS,this.onUnmaskContents);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onElementClick);
         removeEventListener(Event.ADDED,this.onAdded);
         removeEventListener(UiEvent.FOCUS,this.onUiFocus);
         removeEventListener(ContainerEvent.CLOSE,this.onClose);
         this._alertTimer.removeEventListener(TimerEvent.TIMER,this.onAlertTimerStep);
         this._alertTimer.stop();
         if(this._focusGroupProxy != null)
         {
            this._focusGroupProxy.destroy();
         }
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onElementClick);
         dispatchEvent(new ContainerEvent(ContainerEvent.DESTROY,true));
         this.declineFocus();
         this._background.destroy();
         this._backgroundImageMask.destroy();
         this._backgroundSwfMask.destroy();
         super.destroy();
      }
      
      override public function measure() : void
      {
         if(this._state == ControlState.MINIMIZED)
         {
            measuredHeight = CHROME_TOP_HEIGHT;
            measuredWidth = 200;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var topRightControlsLength:int = 0;
         var additionalTopRightControlsLength:int = 0;
         var i:int = 0;
         var control:IconButton = null;
         var totalTopRightControlsLength:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._state == ControlState.MINIMIZED)
         {
            this.updateDisplayListMinimized(unscaledWidth,unscaledHeight);
         }
         else
         {
            this.updateDisplayListDefault(unscaledWidth,unscaledHeight);
         }
         if(!this._controlsTopRightValid)
         {
            this._closeButton.x = -CHROME_CONTROL_SIZE;
            this._minimizeButton.x = -CHROME_CONTROL_SIZE;
            if(this.closable)
            {
               this._minimizeButton.x = this._minimizeButton.x - (CHROME_CONTROL_SIZE + CHROME_CONTROL_GAP);
            }
            topRightControlsLength = this.closable && this.minimizable?int(2):this.closable || this.minimizable?int(1):int(0);
            additionalTopRightControlsLength = this._additionalTopRightControls.length;
            for(i = 0; i < additionalTopRightControlsLength; i++)
            {
               control = this._additionalTopRightControls[i] as IconButton;
               control.x = -CHROME_CONTROL_SIZE;
               totalTopRightControlsLength = topRightControlsLength + additionalTopRightControlsLength - 1;
               control.x = control.x - totalTopRightControlsLength * (CHROME_CONTROL_SIZE + CHROME_CONTROL_GAP);
            }
            this._controlsTopRightValid = true;
         }
         this._titleLabel.width = unscaledWidth - CHROME_PADDING * 2 - this._controlsTopRight.width - (this._iconHolder.numChildren > 0?this._iconHolder.width + 2:0);
         this._titleLabel.height = CHROME_TOP_HEIGHT - CHROME_PADDING;
      }
      
      public function updateDisplayListMinimized(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._resizeHit.visible = false;
         this._outsideBorder.visible = false;
         this._border.visible = false;
         if(content.visible)
         {
            content.visible = false;
         }
         if(this._chrome.stage != null)
         {
            removeChild(this._chrome);
         }
         if(this._minimizedChrome.stage == null)
         {
            addChildAt(this._minimizedChrome,0);
         }
         if(!this._minimizedChromeValid)
         {
            this._minimizedChromeValid = true;
            this._minimizedChrome.graphics.clear();
            UiRender.renderGradient(this._minimizedChrome,this.foregroundColors,0.5 * Math.PI,0,0,100,30,20);
            this._minimizedChrome.scale9Grid = new Rectangle(10,10,80,10);
         }
         this._minimizedChrome.width = Math.round(unscaledWidth);
         this._minimizedChrome.height = CHROME_TOP_HEIGHT;
         this._topHit.width = unscaledWidth;
         this._alertGradient.scaleX = unscaledWidth / 100;
         this._alertGradient.scaleY = this._topBarHeight / 100;
         this._controlsTopRight.x = unscaledWidth - CHROME_PADDING;
         this._titleLabel.text = this._title;
         this._titleLabel.setStyleById(style.titleStyleId);
         this.updateIcon();
      }
      
      public function updateDisplayListDefault(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bgImageURL:String = null;
         var color:Number = NaN;
         var size:Number = NaN;
         var dash:Number = NaN;
         var alpha:Number = NaN;
         var colors:Array = null;
         var alphas:Array = null;
         var ratios:Array = null;
         var matrix:Matrix = null;
         this._resizeHit.visible = this.resizable;
         this._outsideBorder.visible = true;
         this._border.visible = true;
         if(!content.visible)
         {
            content.visible = true;
         }
         if(this._minimizedChrome.stage != null)
         {
            removeChild(this._minimizedChrome);
         }
         if(this._chrome.stage == null)
         {
            addChildAt(this._chrome,0);
         }
         var outsideBorderSize:Number = getValidValue(style.outsideBorderSize,0);
         var borderSize:Number = getValidValue(style.borderSize,0);
         var diameterBorderSize:Number = borderSize <= 2?Number(borderSize * 3):Number(borderSize);
         var diameter:Number = Math.max(0,getValidValue(style.cornerDiameter,style.cornerRadius,20));
         var bgCornerDiameter:Number = Math.max(0,diameter - diameterBorderSize);
         var middleCornerDiameter:* = !!this._chromelessTop?!!this._chromelessBottom?bgCornerDiameter:[bgCornerDiameter,bgCornerDiameter,0,0]:!!this._chromelessBottom?[0,0,bgCornerDiameter,bgCornerDiameter]:0;
         var topOverlayDiameter:Number = Math.max(0,bgCornerDiameter - TOP_OVERLAY_OFFSET);
         if(!this._chromeValid)
         {
            this._chromeValid = true;
            this._outsideBorder.graphics.clear();
            this._border.graphics.clear();
            this._backgroundTopOverlay.graphics.clear();
            try
            {
               this._backgroundHolder.removeChild(this._background);
               this._background.destroy();
               this._backgroundHolder.removeChild(this._backgroundImageMask);
               this._backgroundImageMask.destroy();
               this._backgroundHolder.removeChild(this._backgroundSwfMask);
               this._backgroundSwfMask.destroy();
            }
            catch(e:Error)
            {
            }
            this.renderBackground(bgCornerDiameter,middleCornerDiameter,topOverlayDiameter);
         }
         if(!this._topBarValid)
         {
            content.y = this._topBarHeight;
            if(maskContents)
            {
               contentMask.y = this._topBarHeight;
            }
            this._topHit.graphics.clear();
            UiRender.renderRect(this._topHit,33488896,0,0,100,CHROME_TOP_HEIGHT);
            this._topBarValid = true;
         }
         if(!this._backgroundImageValid)
         {
            bgImageURL = getValidValue(this._backgroundImageURL,style.backgroundImageURL);
            if(bgImageURL)
            {
               if(bgImageURL.lastIndexOf(".swf") == bgImageURL.length - 4)
               {
                  this._backgroundSwfLoader.url = AppProperties.fileServerStaticOrLocal + bgImageURL;
                  this._backgroundSwfLoader.visible = true;
               }
               else
               {
                  this._backgroundImage.url = AppProperties.fileServerStaticOrLocal + bgImageURL;
                  this._backgroundImage.visible = true;
               }
            }
            this._backgroundImageValid = true;
         }
         if(!this._backgroundStripesValid)
         {
            color = getValidValue(this._backgroundStripesColor,style.backgroundStripesColor,NaN);
            if(!isNaN(color))
            {
               size = 4;
               dash = 80;
               alpha = GraphicUtil.getAlpha(color);
               colors = [color,color,color,color];
               alphas = [alpha,alpha,0,0];
               ratios = [0,dash,dash,255];
               matrix = new Matrix();
               matrix.createGradientBox(size * 2,size * 2,0.25 * Math.PI,x,y);
               this._backgroundStripesGradientFill = new GradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix,SpreadMethod.REPEAT);
            }
            else
            {
               this._backgroundStripesGradientFill = null;
            }
         }
         this._titleLabel.text = this._title;
         this._titleLabel.setStyleById(style.titleStyleId);
         this.updateIcon();
         this._outsideBorder.width = this._border.width = unscaledWidth + outsideBorderSize * 2;
         this._outsideBorder.height = this._border.height = unscaledHeight + outsideBorderSize * 2;
         this._outsideBorder.x = this._border.x = -outsideBorderSize;
         this._outsideBorder.y = this._border.y = -outsideBorderSize;
         this._background.width = Math.round(unscaledWidth);
         this._background.height = Math.round(unscaledHeight);
         this._backgroundImageMask.width = this._backgroundImage.width = this._backgroundSwfMask.width = this._backgroundSwfLoader.width = this._background.width;
         this._backgroundImageMask.height = this._backgroundImage.height = this._backgroundSwfMask.height = this._backgroundSwfLoader.height = this._background.height - this._topBarHeight - this._bottomBarHeight;
         this._backgroundImageMask.y = this._backgroundImage.y = this._backgroundSwfMask.y = this._backgroundSwfLoader.y = this._topBarHeight;
         this._backgroundStripes.graphics.clear();
         var offsetX:Number = Boolean(this._backgroundStripesOffset)?Number(this._backgroundStripesOffset.x):Number(0);
         var offsetY:Number = Boolean(this._backgroundStripesOffset)?Number(this._backgroundStripesOffset.y):Number(0);
         var offsetWidth:Number = Boolean(this._backgroundStripesOffset)?Number(this._backgroundStripesOffset.width):Number(0);
         var offsetHeight:Number = Boolean(this._backgroundStripesOffset)?Number(this._backgroundStripesOffset.height):Number(0);
         var topLeftCorner:Number = !!this._chromelessTop?offsetX > 0 || offsetY > 0?Number(0):Number(bgCornerDiameter):Number(0);
         var topRightCorner:Number = !!this._chromelessTop?offsetY > 0 || offsetWidth > 0?Number(0):Number(bgCornerDiameter):Number(0);
         var bottomLeftCorner:Number = !!this._chromelessBottom?offsetX > 0 || offsetHeight > 0?Number(0):Number(bgCornerDiameter):Number(0);
         var bottomRightCorner:Number = !!this._chromelessBottom?offsetWidth > 0 || offsetHeight > 0?Number(0):Number(bgCornerDiameter):Number(0);
         var stripesCornerDiameter:* = [topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner];
         offsetWidth = offsetWidth + offsetX;
         offsetHeight = offsetHeight + offsetY;
         if(this._backgroundStripesGradientFill)
         {
            UiRender.renderGradient(this._backgroundStripes,this.backgroundColors,0.5 * Math.PI,borderSize + offsetX,this._topBarHeight + borderSize + offsetY,this._background.width - borderSize * 2 - offsetWidth,this._background.height - this._topBarHeight - this._bottomBarHeight - borderSize * 2 - offsetHeight,stripesCornerDiameter);
            UiRender.renderGradientFill(this._backgroundStripes,this._backgroundStripesGradientFill,borderSize + offsetX,this._topBarHeight + borderSize + offsetY,this._background.width - borderSize * 2 - offsetWidth,this._background.height - this._topBarHeight - this._bottomBarHeight - borderSize * 2 - offsetHeight,stripesCornerDiameter);
         }
         this._backgroundTopOverlay.width = this._background.width - borderSize * 2 - TOP_OVERLAY_OFFSET * 2;
         this._backgroundTopOverlay.height = Math.max(CHROME_TOP_HEIGHT - borderSize * 2 - TOP_OVERLAY_OFFSET * 2,topOverlayDiameter);
         this._backgroundTopOverlay.x = borderSize + TOP_OVERLAY_OFFSET;
         this._backgroundTopOverlay.y = borderSize + TOP_OVERLAY_OFFSET;
         this._resizeHit.x = unscaledWidth - this._resizeHit.width;
         this._resizeHit.y = unscaledHeight - this._resizeHit.height;
         this._topHit.width = unscaledWidth;
         this._alertGradient.scaleX = unscaledWidth / 100;
         this._alertGradient.scaleY = this._topBarHeight / 100;
         this._controlsTopRight.x = unscaledWidth - CHROME_PADDING;
         if(maskContents)
         {
            contentMask.height = unscaledHeight - chromePadding.top - chromePadding.bottom;
         }
         content.x = padding.left;
         content.y = padding.top + this._topBarHeight;
      }
      
      protected function renderBackground(backgroundCornerDiameter:Number, middleCornerDiameter:*, topOverlayDiameter:Number) : void
      {
         var preferredTopOverlayHeight:Number = NaN;
         var topOverlayHeight:Number = NaN;
         var range:Number = NaN;
         var matrix:Matrix = null;
         var gradientFill:GradientFill = null;
         var resize:Bitmap = null;
         var outsideBorderColor:Number = getValidValue(style.outsideBorderColor,16777215);
         var outsideBorderSize:Number = getValidValue(style.outsideBorderSize,0);
         var borderColor:Number = getValidValue(style.borderColor,5616086);
         var borderSize:Number = getValidValue(style.borderSize,0);
         var borderCornerDiameter:Number = backgroundCornerDiameter;
         var outsideBorderCornerDiameter:Number = backgroundCornerDiameter + outsideBorderSize;
         UiRender.renderRect(this._outsideBorder,33554431,0,0,100,100);
         UiRender.renderRect(this._border,33554431,0,0,100,100);
         UiRender.renderRect(this._backgroundTopOverlay,33554431,0,0,100,100);
         if(outsideBorderSize > 0)
         {
            if(style.outsideBorderGradient != null)
            {
               UiRender.createGradientFill(this._outsideBorder.graphics,style.outsideBorderGradient,Math.PI / 2,0,0,100,100);
            }
            else
            {
               this._outsideBorder.graphics.beginFill(outsideBorderColor,GraphicUtil.getAlpha(outsideBorderColor));
            }
            this._outsideBorder.graphics.drawRoundRect(0,0,100,100,outsideBorderCornerDiameter);
            this._outsideBorder.graphics.drawRoundRect(outsideBorderSize,outsideBorderSize,100 - outsideBorderSize * 2,100 - outsideBorderSize * 2,borderCornerDiameter);
         }
         if(borderSize > 0)
         {
            if(style.borderGradient != null)
            {
               UiRender.createGradientFill(this._border.graphics,style.borderGradient,Math.PI / 2,0,0,100,100);
            }
            else
            {
               this._border.graphics.beginFill(borderColor,GraphicUtil.getAlpha(borderColor));
            }
            this._border.graphics.drawRoundRect(outsideBorderSize,outsideBorderSize,100 - outsideBorderSize * 2,100 - outsideBorderSize * 2,borderCornerDiameter);
            this._border.graphics.drawRoundRect(outsideBorderSize + borderSize,outsideBorderSize + borderSize,100 - outsideBorderSize * 2 - borderSize * 2,100 - outsideBorderSize * 2 - borderSize * 2,backgroundCornerDiameter);
         }
         var bgArt:Sprite = new Sprite();
         UiRender.renderGradient(bgArt,this.foregroundColors,0.5 * Math.PI,0,0,100,this._topBarHeight,[backgroundCornerDiameter,backgroundCornerDiameter,0,0]);
         UiRender.renderGradient(bgArt,this.foregroundColors,0.5 * Math.PI,0,100 - this._bottomBarHeight,100,this._bottomBarHeight,[0,0,backgroundCornerDiameter,backgroundCornerDiameter]);
         UiRender.renderGradient(bgArt,this.backgroundColors,0.5 * Math.PI,0,this._topBarHeight,100,100 - this._topBarHeight - this._bottomBarHeight,middleCornerDiameter);
         if(!this._chromelessTop)
         {
            UiRender.renderRect(bgArt,style.accentColor,0,this._topBarHeight - 1,100,1);
         }
         else
         {
            preferredTopOverlayHeight = CHROME_TOP_HEIGHT - borderSize * 2 - TOP_OVERLAY_OFFSET * 2;
            topOverlayHeight = Math.max(preferredTopOverlayHeight,topOverlayDiameter);
            range = preferredTopOverlayHeight / topOverlayHeight;
            range = range * 255;
            matrix = new Matrix();
            matrix.createGradientBox(100,100,0.5 * Math.PI);
            gradientFill = new GradientFill(GradientType.LINEAR,[16777215,16777215],[0.6,0],[0,range],matrix);
            UiRender.renderGradientFill(this._backgroundTopOverlay,gradientFill,0,0,100,100,[topOverlayDiameter,topOverlayDiameter,0,0]);
         }
         if(!this._chromelessBottom)
         {
            UiRender.renderRect(bgArt,style.accentColor,0,100 - this._bottomBarHeight,100,1);
         }
         if(this._resizable)
         {
            resize = new GraphicManager.iconWindowResize();
            resize.x = resize.y = 80;
            GraphicUtil.setColor(resize,style.accentColor);
            this._resizeHit.addChild(resize);
         }
         this._outsideBorder.scale9Grid = new Rectangle(outsideBorderCornerDiameter / 2 + outsideBorderSize,outsideBorderCornerDiameter / 2 + outsideBorderSize,100 - outsideBorderCornerDiameter - outsideBorderSize * 2,100 - outsideBorderCornerDiameter - outsideBorderSize * 2);
         this._border.scale9Grid = new Rectangle(outsideBorderSize + borderCornerDiameter / 2 + borderSize,outsideBorderSize + borderCornerDiameter / 2 + borderSize,100 - borderCornerDiameter - borderSize * 2 - outsideBorderSize * 2,100 - borderCornerDiameter - borderSize * 2 - outsideBorderSize * 2);
         this._backgroundTopOverlay.scale9Grid = new Rectangle(topOverlayDiameter / 2,topOverlayDiameter / 2,100 - topOverlayDiameter,100 - topOverlayDiameter);
         var bgTop:Number = Math.max(backgroundCornerDiameter / 2,this._topBarHeight);
         var bgBottom:Number = Math.max(backgroundCornerDiameter / 2,this._bottomBarHeight);
         this._background = new Scale9Image(bgArt,backgroundCornerDiameter / 2,bgTop,100 - backgroundCornerDiameter / 2,100 - bgBottom);
         this._backgroundHolder.addChildAt(this._background,0);
         var topRadius:Number = !!this._chromelessTop?Number(backgroundCornerDiameter / 2):Number(0);
         var bottomRadius:Number = !!this._chromelessBottom?Number(backgroundCornerDiameter / 2):Number(0);
         this._backgroundImageMask = new Scale9Mask(100,100,topRadius,topRadius,bottomRadius,bottomRadius);
         this._backgroundImage.mask = this._backgroundImageMask;
         this._backgroundImage.borderColor = borderColor;
         this._backgroundHolder.addChild(this._backgroundImageMask);
         this._backgroundSwfMask = new Scale9Mask(100,100,topRadius,topRadius,bottomRadius,bottomRadius);
         this._backgroundSwfLoader.mask = this._backgroundSwfMask;
         this._backgroundHolder.addChild(this._backgroundSwfMask);
      }
      
      public function updateIcon() : void
      {
         var icon:DisplayObject = null;
         if(!this._iconValid)
         {
            if(this._iconType == 2)
            {
               this._titleLabel.x = this._iconHolder.x + this._iconHolder.width + 2;
            }
            else if(this._iconType == 1 && this._iconClass != null)
            {
               if(this._iconHolder.numChildren > 0)
               {
                  this._iconHolder.removeChildAt(0);
               }
               icon = new this._iconClass();
               icon.height = icon.width = CHROME_CONTROL_SIZE;
               GraphicUtil.setColor(icon,style.iconColor);
               this._iconHolder.addChild(icon);
               this._titleLabel.x = 26;
            }
            else
            {
               if(this._iconHolder.numChildren > 0)
               {
                  this._iconHolder.removeChildAt(0);
               }
               this._titleLabel.x = CHROME_PADDING;
            }
            this._iconValid = true;
         }
      }
      
      public function addTopRightControl(icon:Class) : IconButton
      {
         var control:IconButton = new IconButton(icon);
         control.x = -CHROME_CONTROL_SIZE;
         control.cornerRadius = CHROME_CONTROL_CORNER_RADIUS;
         this._controlsTopRight.addChild(control);
         this._additionalTopRightControls.push(control);
         this._controlsTopRightValid = false;
         invalidateDisplayList();
         return control;
      }
      
      override public function set minHeight(value:Number) : void
      {
         this._storedMinHeight = value;
         super.minHeight = value;
      }
      
      override public function set style(value:Style) : void
      {
         this._chromeValid = false;
         this._backgroundImageValid = false;
         this._backgroundStripesValid = false;
         super.style = value;
      }
      
      override public function set backgroundColor(value:Number) : void
      {
         super.backgroundColor = value;
         this._chromeValid = false;
      }
      
      override public function set backgroundGradient(value:Array) : void
      {
         super.backgroundGradient = value;
         this._chromeValid = false;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get backgroundImageURL() : String
      {
         return this._backgroundImageURL;
      }
      
      public function set backgroundImageURL(value:String) : void
      {
         this._backgroundImageURL = value;
         this._backgroundImageValid = false;
         invalidateDisplayList();
      }
      
      public function get backgroundStripesColor() : Number
      {
         return this._backgroundStripesColor;
      }
      
      public function set backgroundStripesColor(value:Number) : void
      {
         this._backgroundStripesColor = value;
         this._backgroundStripesValid = false;
         invalidateDisplayList();
      }
      
      public function get chromelessTop() : Boolean
      {
         return this._chromelessTop;
      }
      
      public function set chromelessTop(value:Boolean) : void
      {
         this._chromelessTop = value;
         this._topBarHeight = !!value?Number(0):Number(CHROME_TOP_HEIGHT);
         chromePadding.setValues(this._topBarHeight,0,this._bottomBarHeight,0);
         this._chromeValid = false;
         this._topBarValid = false;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get chromelessBottom() : Boolean
      {
         return this._chromelessBottom;
      }
      
      public function set chromelessBottom(value:Boolean) : void
      {
         this._chromelessBottom = value;
         this._bottomBarHeight = !!value?Number(0):Number(CHROME_BOTTOM_HEIGHT);
         chromePadding.setValues(this._topBarHeight,0,this._bottomBarHeight,0);
         this._chromeValid = false;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      public function set draggable(value:Boolean) : void
      {
         this._draggable = value;
         this._topHit.visible = value;
      }
      
      public function get resizable() : Boolean
      {
         return this._resizable;
      }
      
      public function set resizable(value:Boolean) : void
      {
         this._resizable = value;
         this._chromeValid = false;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get closable() : Boolean
      {
         return this._closable;
      }
      
      public function set closable(value:Boolean) : void
      {
         this._closable = value;
         this._closeButton.visible = value;
         this._controlsTopRightValid = false;
         invalidateDisplayList();
      }
      
      public function get minimizable() : Boolean
      {
         return this._minimizable;
      }
      
      public function set minimizable(value:Boolean) : void
      {
         this._minimizable = value;
         this._minimizeButton.visible = value;
         this._controlsTopRightValid = false;
         invalidateDisplayList();
      }
      
      public function set icon(iconClass:Class) : void
      {
         this._iconClass = iconClass;
         this._iconType = 1;
         this._iconValid = false;
         invalidateDisplayList();
      }
      
      protected function get foregroundColors() : Array
      {
         var fgGradient:Array = getValidValue(style.foregroundGradient);
         var fgColor:Number = getValidValue(style.foregroundColor,16777215);
         return Boolean(fgGradient)?fgGradient:[fgColor];
      }
      
      protected function get backgroundColors() : Array
      {
         var bgGradient:Array = getValidValue(backgroundGradient,style.backgroundGradient);
         var bgColor:Number = getValidValue(backgroundColor,style.backgroundColor,16777215);
         return Boolean(bgGradient)?bgGradient:[bgColor];
      }
      
      public function setIconSprite(sprite:Sprite) : void
      {
         var ratio:Number = NaN;
         if(this._iconHolder.numChildren > 0)
         {
            this._iconHolder.removeChildAt(0);
         }
         this._iconHolder.addChild(sprite);
         if(sprite.height > sprite.width)
         {
            ratio = sprite.width / sprite.height;
            sprite.height = 20;
            sprite.width = ratio * 20;
         }
         else
         {
            ratio = sprite.height / sprite.width;
            sprite.width = 20;
            sprite.height = ratio * 20;
         }
         this._iconType = 2;
         this._iconValid = false;
         invalidateDisplayList();
      }
      
      public function hide() : void
      {
         visible = false;
      }
      
      public function show() : void
      {
         visible = true;
      }
      
      protected function onUnmaskContents(event:ContainerEvent) : void
      {
         maskContents = false;
      }
      
      protected function onSetTitle(event:ContainerEvent) : void
      {
         this.title = event.title;
      }
      
      protected function onUpdateBackground(event:ContainerEvent) : void
      {
         this._backgroundStripesOffset = event.backgroundStripesOffset.clone();
         this._backgroundImage.alpha = event.backgroundImageAlpha;
         this._backgroundSwfLoader.alpha = event.backgroundImageAlpha;
         invalidateDisplayList();
      }
      
      public function onStartAlert(event:ContainerEvent) : void
      {
         this._alertTimer.start();
         this._alertGradient.graphics.clear();
         if(this._state == ControlState.MINIMIZED)
         {
            UiRender.renderSimpleGradient(this._alertGradient,13421772,Math.PI / 2,0,0,100,100,20);
            this._alertGradient.scale9Grid = new Rectangle(10,10,80,80);
         }
         else
         {
            UiRender.renderSimpleGradient(this._alertGradient,13421772,Math.PI / 2,0,0,100,100,1);
            this._alertGradient.scale9Grid = new Rectangle(10,10,80,80);
         }
      }
      
      public function onStopAlert(event:ContainerEvent) : void
      {
         this._alertTimer.stop();
         this._alertGradient.graphics.clear();
      }
      
      public function onAlertTimerStep(event:TimerEvent) : void
      {
         if(this._alertTimer.currentCount % 2 == 1)
         {
            this._alertGradient.alpha = 0;
         }
         else
         {
            this._alertGradient.alpha = 1;
         }
      }
      
      private function onTopBarMouseDown(event:MouseEvent) : void
      {
         if(this._state == ControlState.MINIMIZED)
         {
            this.maximize();
         }
         else
         {
            this._dragOffset = new Point(mouseX,mouseY);
            StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onTopBarMouseUp,false,0,true);
            StageReference.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onTopBarDrag,false,0,true);
         }
      }
      
      private function onTopBarMouseUp(event:MouseEvent) : void
      {
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTopBarMouseUp);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTopBarDrag);
      }
      
      private function onTopBarDrag(event:MouseEvent) : void
      {
         var x:Number = stage.mouseX;
         var y:Number = stage.mouseY;
         x = MathUtil.clamp(AppComponents.popupManager.floatingWindowConstraints.x,AppComponents.popupManager.floatingWindowConstraints.right,x);
         y = MathUtil.clamp(AppComponents.popupManager.floatingWindowConstraints.y,AppComponents.popupManager.floatingWindowConstraints.bottom,y);
         x = x - this._dragOffset.x;
         y = y - this._dragOffset.y;
         this.x = Math.round(x);
         this.y = Math.round(y);
      }
      
      private function onResizeMouseDown(event:MouseEvent) : void
      {
         if(!this._resizable)
         {
            return;
         }
         this._dragOffset = new Point(width - mouseX,height - mouseY);
         StageReference.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onResizeDrag,false,0,true);
         StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.onResizeMouseUp,false,0,true);
      }
      
      private function onResizeMouseUp(event:MouseEvent) : void
      {
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onResizeDrag);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onResizeMouseUp);
      }
      
      private function onResizeDrag(event:Event) : void
      {
         var w:Number = mouseX + this._dragOffset.x;
         var h:Number = mouseY + this._dragOffset.y;
         width = Math.round(MathUtil.clamp(minWidth,maxWidth,w));
         height = Math.round(MathUtil.clamp(minHeight,maxHeight,h));
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE && this.closable)
         {
            this.onCloseClick(null);
         }
      }
      
      public function onClose(event:ContainerEvent) : void
      {
         var evt:ContainerEvent = null;
         this.declineFocus();
         event.container = this;
         if(this.autoRemove)
         {
            evt = new ContainerEvent(ContainerEvent.AUTO_REMOVE,true);
            evt.container = this;
            dispatchEvent(evt);
         }
         if(this.autoDestroy)
         {
            this.destroy();
         }
         else if(this.autoHide)
         {
            this.hide();
         }
      }
      
      protected function onCloseClick(event:ButtonEvent) : void
      {
         var evt:ContainerEvent = new ContainerEvent(ContainerEvent.CLOSE,true);
         if(_module != null && contains(_module.getConcreteDisplayObject()))
         {
            _module.getConcreteDisplayObject().dispatchEvent(evt);
         }
         else
         {
            dispatchEvent(evt);
         }
      }
      
      protected function onMinimizeClick(event:ButtonEvent) : void
      {
         if(this._state == ControlState.MINIMIZED)
         {
            this.maximize();
         }
         else
         {
            this.minimize();
         }
      }
      
      public function onContentMinimize(event:ContainerEvent) : void
      {
         if(event.target != this)
         {
            event.stopImmediatePropagation();
            this.minimize();
         }
      }
      
      public function minimize() : void
      {
         super.minHeight = 30;
         var evt:ContainerEvent = new ContainerEvent(ContainerEvent.MINIMIZE,true);
         evt.container = this;
         dispatchEvent(evt);
         obeyMaxMins = false;
         this.maximizedDimensions.x = this.x;
         this.maximizedDimensions.y = this.y;
         this.maximizedDimensions.width = this.width;
         this.maximizedDimensions.height = this.height;
         this.onStopAlert(null);
         Tweener.addTween(this,{
            "x":this.minimizedDimensions.x,
            "y":this.minimizedDimensions.y,
            "transition":"easeOutQuad",
            "time":0.2,
            "onComplete":this.onMinimizeComplete,
            "rounded":true
         });
         this.setState(ControlState.MINIMIZED);
         this.declineFocus();
      }
      
      protected function onMinimizeComplete() : void
      {
         this.isAnimating = false;
      }
      
      public function maximize() : void
      {
         super.minHeight = !isNaN(this._storedMinHeight)?Number(this._storedMinHeight):Number(60);
         var evt:ContainerEvent = new ContainerEvent(ContainerEvent.MAXIMIZE,true);
         evt.container = this;
         this.onStopAlert(null);
         dispatchEvent(evt);
         Tweener.addTween(this,{
            "x":this.maximizedDimensions.x,
            "y":this.maximizedDimensions.y,
            "width":this.maximizedDimensions.width,
            "transition":"easeOutQuad",
            "time":0.2,
            "onComplete":this.onMaximizeComplete,
            "rounded":true
         });
         this.requestFocus();
      }
      
      protected function onMaximizeComplete() : void
      {
         this.isAnimating = false;
         this.setState(ControlState.DEFAULT);
         obeyMaxMins = true;
      }
      
      protected function onUiFocus(event:UiEvent) : void
      {
      }
      
      protected function onMinimize(event:ContainerEvent) : void
      {
      }
      
      private function onAdded(event:Event) : void
      {
         if(event.target == this)
         {
            if(this.autoFocus)
            {
               this.requestFocus();
            }
         }
      }
      
      private function onRemoved(event:Event) : void
      {
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onResizeDrag);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onResizeMouseUp);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTopBarMouseUp);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTopBarDrag);
         if(event.target == this)
         {
            this.declineFocus();
         }
      }
      
      private function onElementClick(event:MouseEvent) : void
      {
         if(event.target == this._closeButton)
         {
            return;
         }
         if(event.target == this._minimizeButton)
         {
            return;
         }
         dispatchEvent(new UiEvent(UiEvent.FOCUS,this,true,true));
         this.requestFocus();
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      protected function setState(state:String) : void
      {
         if(state == ControlState.DEFAULT)
         {
            width = this.maximizedDimensions.width;
            height = this.maximizedDimensions.height;
         }
         else if(state == ControlState.MINIMIZED)
         {
            explicitWidth = NaN;
            explicitHeight = NaN;
         }
         this._state = state;
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function requestFocus() : void
      {
         if(_module != null)
         {
            if(IFocusGroup(_module).wantsFocus)
            {
               FocusManager.getInstance().addFocusGroup(_module as IFocusGroup);
            }
         }
         else
         {
            if(this._focusGroupProxy == null)
            {
               this._focusGroupProxy = new FocusGroupSpriteProxy();
               this._focusGroupProxy.addSprite(content);
            }
            FocusManager.getInstance().addFocusGroup(this._focusGroupProxy as IFocusGroup);
         }
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_ALERT,true));
      }
      
      protected function declineFocus() : void
      {
         if(_module != null)
         {
            FocusManager.getInstance().removeFocusGroup(_module as IFocusGroup);
         }
         else if(this._focusGroupProxy != null)
         {
            FocusManager.getInstance().removeFocusGroup(this._focusGroupProxy as IFocusGroup);
         }
      }
      
      override public function setModule(imodule:IModule) : IModule
      {
         this.declineFocus();
         super.setModule(imodule);
         if(stage != null)
         {
            this.requestFocus();
         }
         return imodule;
      }
   }
}
