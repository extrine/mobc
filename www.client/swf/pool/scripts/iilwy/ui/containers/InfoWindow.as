package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.display.core.FocusManager;
   import iilwy.display.core.WindowManager;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.IFocusGroup;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class InfoWindow extends ModuleContainer implements IInfoWindow
   {
       
      
      protected var _chromeValid:Boolean = false;
      
      protected var _chrome:Sprite;
      
      protected var _background:Sprite;
      
      protected var _outsideBorder:Sprite;
      
      private var _arrow:Sprite;
      
      private var _arrowHolder:Sprite;
      
      protected var _arrowPadding:Number = 10;
      
      private var _xOffset:Number = 0;
      
      private var _yOffset:Number = 0;
      
      private var _yTargOffset:Number = 0;
      
      private var _xTargOffset:Number = 0;
      
      private var _arrowAngle:Number = 0;
      
      private var _yArrowOffset:Number = 0;
      
      private var _xArrowOffset:Number = 0;
      
      private var _alignMethod:String;
      
      private var _position:Point;
      
      private var _addedTime:int;
      
      private var _useArrow:Boolean = true;
      
      private var _constrainTo:Rectangle;
      
      protected var _shadowCaster:Sprite;
      
      protected var _cornerRadius:Number;
      
      public function InfoWindow(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200, styleId:String = "miniWindow")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setPadding(4,4,4,4);
         setChromePadding(2,2,2,2);
         setStyleById(styleId);
         this._arrowHolder = new Sprite();
         addChildAt(this._arrowHolder,0);
         this._arrowHolder.mouseEnabled = false;
         this._arrowHolder.buttonMode = false;
         this._chrome = new Sprite();
         this._chrome.mouseEnabled = false;
         this._chrome.buttonMode = false;
         addChildAt(this._chrome,0);
         this._background = new Sprite();
         this._background.mouseEnabled = false;
         this._background.buttonMode = false;
         this._chrome.addChild(this._background);
         this._outsideBorder = new Sprite();
         this._outsideBorder.mouseEnabled = false;
         this._outsideBorder.buttonMode = false;
         addChild(this._outsideBorder);
         this._shadowCaster = new Sprite();
         this._shadowCaster.mouseEnabled = false;
         this._shadowCaster.buttonMode = false;
         addChildAt(this._shadowCaster,0);
         var filter:DropShadowFilter = new DropShadowFilter(2,90,0,0.2,10,10,1,1,false,true);
         this._shadowCaster.filters = [filter];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(ContainerEvent.CLOSE,this.onClose);
         maskContents = true;
      }
      
      override public function destroy() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         try
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown);
         }
         catch(e:Error)
         {
         }
         try
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         }
         catch(e:Error)
         {
         }
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var outsideBorderSize:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!this._chromeValid)
         {
            this._background.graphics.clear();
            this._outsideBorder.graphics.clear();
            this.renderBackground();
            if(this._arrowHolder.numChildren > 0)
            {
               this._arrowHolder.removeChildAt(0);
            }
            this._arrow = this.renderArrow();
            this._arrow.y = -Math.round(this._arrow.height / 2);
            this._arrowHolder.addChild(this._arrow);
            this._chromeValid = true;
         }
         outsideBorderSize = getValidValue(style.outsideBorderSize,0);
         this._background.width = unscaledWidth + outsideBorderSize * 2;
         this._background.height = unscaledHeight + outsideBorderSize * 2;
         this._background.x = -outsideBorderSize;
         this._background.y = -outsideBorderSize;
         this._shadowCaster.width = unscaledWidth + outsideBorderSize * 2;
         this._shadowCaster.height = unscaledHeight + outsideBorderSize * 2;
         this._shadowCaster.x = -outsideBorderSize;
         this._shadowCaster.y = -outsideBorderSize;
         this._outsideBorder.width = unscaledWidth + outsideBorderSize * 2;
         this._outsideBorder.height = unscaledHeight + outsideBorderSize * 2;
         this._outsideBorder.x = -outsideBorderSize;
         this._outsideBorder.y = -outsideBorderSize;
         contentMask.width = unscaledWidth;
         contentMask.height = unscaledHeight;
         content.x = chromePadding.left + padding.left;
         content.y = chromePadding.top + padding.top;
      }
      
      protected function renderBackground() : void
      {
         var outsideBorderColor:Number = getValidValue(style.outsideBorderColor,16777215);
         var outsideBorderSize:Number = getValidValue(style.outsideBorderSize,0);
         var borderColor:Number = getValidValue(style.borderColor,0);
         var borderSize:Number = getValidValue(style.borderSize,2);
         var bgColor:Number = getValidValue(backgroundColor,style.backgroundColor,16777215);
         var radius:Number = Math.max(0,getValidValue(this.cornerRadius,style.cornerRadius));
         var radiusBorderSize:Number = borderSize <= 2?Number(borderSize * 3):Number(borderSize);
         var bgRadius:Number = Math.max(0,radius - radiusBorderSize);
         var borderRadius:Number = radius;
         var outsideBorderRadius:Number = radius + outsideBorderSize;
         UiRender.renderRect(this._background,33554431,0,0,100,100);
         UiRender.renderRect(this._outsideBorder,33554431,0,0,100,100);
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
            this._outsideBorder.graphics.drawRoundRect(0,0,100,100,outsideBorderRadius,outsideBorderRadius);
            this._outsideBorder.graphics.drawRoundRect(outsideBorderSize,outsideBorderSize,100 - outsideBorderSize * 2,100 - outsideBorderSize * 2,borderRadius,borderRadius);
         }
         if(borderSize > 0)
         {
            if(style.borderGradient != null)
            {
               UiRender.createGradientFill(this._background.graphics,style.borderGradient,Math.PI / 2,0,0,100,100);
            }
            else
            {
               this._background.graphics.beginFill(borderColor,GraphicUtil.getAlpha(borderColor));
            }
            this._background.graphics.drawRoundRect(outsideBorderSize,outsideBorderSize,100 - outsideBorderSize * 2,100 - outsideBorderSize * 2,borderRadius,borderRadius);
            this._background.graphics.drawRoundRect(outsideBorderSize + borderSize,outsideBorderSize + borderSize,100 - outsideBorderSize * 2 - borderSize * 2,100 - outsideBorderSize * 2 - borderSize * 2,bgRadius,bgRadius);
         }
         if(style.backgroundGradient != null)
         {
            UiRender.renderGradient(this._background,style.backgroundGradient,Math.PI / 2,outsideBorderSize + borderSize,outsideBorderSize + borderSize,100 - outsideBorderSize * 2 - borderSize * 2,100 - outsideBorderSize * 2 - borderSize * 2,bgRadius);
         }
         else
         {
            UiRender.renderRoundRect(this._background,bgColor,outsideBorderSize + borderSize,outsideBorderSize + borderSize,100 - outsideBorderSize * 2 - borderSize * 2,100 - outsideBorderSize * 2 - borderSize * 2,bgRadius);
         }
         this._shadowCaster.graphics.clear();
         UiRender.renderRoundRect(this._shadowCaster,16711680,0,0,100,100,outsideBorderRadius);
         this._background.scale9Grid = new Rectangle(outsideBorderRadius,outsideBorderRadius,100 - outsideBorderRadius * 2,100 - outsideBorderRadius * 2);
         this._outsideBorder.scale9Grid = new Rectangle(outsideBorderRadius,outsideBorderRadius,100 - outsideBorderRadius * 2,100 - outsideBorderRadius * 2);
         this._shadowCaster.scale9Grid = new Rectangle(20,20,60,60);
      }
      
      protected function renderArrow() : Sprite
      {
         var canvas:Sprite = new Sprite();
         var inner:Sprite = new Sprite();
         canvas.addChild(inner);
         UiRender.renderTriangle(inner,style.borderColor,0,3,14,5);
         UiRender.renderTriangle(inner,style.backgroundColor,2,2,10,3);
         inner.rotation = 90;
         inner.x = 9;
         return GraphicUtil.makeBitmapSprite(canvas,9,14);
      }
      
      public function setPosition(target:DisplayObject, method:String, x:Number = undefined, y:Number = undefined) : void
      {
         var tops:Array = null;
         var bottoms:Array = null;
         var pos:Point = null;
         this._alignMethod = method;
         if(method == null)
         {
            this._alignMethod = ControlAlign.RIGHT;
         }
         this.calculatePosition(target);
         var top:Number = 10;
         var bottom:Number = WindowManager.height - AppComponents.popupManager.windowConstraintPadding.bottom;
         var left:Number = 10;
         var right:Number = WindowManager.width - AppComponents.popupManager.windowConstraintPadding.right;
         if(this.constrainTo != null)
         {
            top = this.constrainTo.top;
            bottom = this.constrainTo.bottom;
            left = this.constrainTo.left;
            right = this.constrainTo.right;
         }
         var flip:Boolean = false;
         var lefts:Array = [ControlAlign.LEFT,ControlAlign.LEFT_TOP,ControlAlign.LEFT_BOTTOM];
         var rights:Array = [ControlAlign.RIGHT,ControlAlign.RIGHT_TOP,ControlAlign.RIGHT_BOTTOM];
         tops = [ControlAlign.TOP,ControlAlign.TOP_LEFT,ControlAlign.TOP_RIGHT];
         bottoms = [ControlAlign.BOTTOM,ControlAlign.BOTTOM_LEFT,ControlAlign.BOTTOM_RIGHT];
         if(rights.indexOf(this._alignMethod) >= 0 && this._position.x + width > right)
         {
            flip = true;
         }
         else if(lefts.indexOf(this._alignMethod) >= 0 && this._position.x < left)
         {
            flip = true;
         }
         else if(tops.indexOf(this._alignMethod) >= 0 && this._position.y < top)
         {
            flip = true;
         }
         else if(bottoms.indexOf(this._alignMethod) >= 0 && this._position.y + height > bottom)
         {
            flip = true;
         }
         if(flip)
         {
            this._alignMethod = this.flipAlignMethod(this._alignMethod);
            this.calculatePosition(target);
         }
         if(bottoms.indexOf(this._alignMethod) >= 0 || tops.indexOf(this._alignMethod) >= 0)
         {
            this._position.x = Math.max(left,this._position.x);
            this._position.x = Math.min(right - width,this._position.x);
         }
         if(lefts.indexOf(this._alignMethod) >= 0 || rights.indexOf(this._alignMethod) >= 0)
         {
            this._position.y = Math.max(top,this._position.y);
            this._position.y = Math.min(bottom - height,this._position.y);
         }
         if(parent != null)
         {
            pos = parent.globalToLocal(this._position);
         }
         else
         {
            pos = this._position;
         }
         this.x = Math.round(pos.x);
         this.y = Math.round(pos.y);
         pos = new Point(target.width / 2 + this._xArrowOffset,target.height / 2 + this._yArrowOffset);
         pos = target.localToGlobal(pos);
         pos = this.globalToLocal(pos);
         if(bottoms.indexOf(this._alignMethod) >= 0 || tops.indexOf(this._alignMethod) >= 0)
         {
            pos.x = Math.max(this._arrowPadding,pos.x);
            pos.x = Math.min(width - this._arrowPadding,pos.x);
         }
         if(lefts.indexOf(this._alignMethod) >= 0 || rights.indexOf(this._alignMethod) >= 0)
         {
            pos.y = Math.max(this._arrowPadding,pos.y);
            pos.y = Math.min(height - this._arrowPadding,pos.y);
         }
         this._arrowHolder.x = Math.round(pos.x);
         this._arrowHolder.y = Math.round(pos.y);
         this._arrowHolder.rotation = this._arrowAngle;
      }
      
      protected function flipAlignMethod(method:String) : String
      {
         var f:Object = new Object();
         f[ControlAlign.LEFT] = ControlAlign.RIGHT;
         f[ControlAlign.LEFT_TOP] = ControlAlign.RIGHT_TOP;
         f[ControlAlign.LEFT_BOTTOM] = ControlAlign.RIGHT_BOTTOM;
         f[ControlAlign.RIGHT] = ControlAlign.LEFT;
         f[ControlAlign.RIGHT_TOP] = ControlAlign.LEFT_TOP;
         f[ControlAlign.RIGHT_BOTTOM] = ControlAlign.LEFT_BOTTOM;
         f[ControlAlign.TOP] = ControlAlign.BOTTOM;
         f[ControlAlign.BOTTOM] = ControlAlign.TOP;
         f[ControlAlign.BOTTOM_RIGHT] = ControlAlign.TOP_RIGHT;
         f[ControlAlign.BOTTOM_LEFT] = ControlAlign.TOP_LEFT;
         f[ControlAlign.TOP] = ControlAlign.BOTTOM;
         f[ControlAlign.TOP_RIGHT] = ControlAlign.BOTTOM_RIGHT;
         f[ControlAlign.TOP_LEFT] = ControlAlign.BOTTOM_LEFT;
         return f[method];
      }
      
      protected function calculatePosition(target:DisplayObject) : void
      {
         this._xOffset = 0;
         this._yOffset = 0;
         this._yTargOffset = 0;
         this._xTargOffset = 0;
         this._arrowAngle = 0;
         this._yArrowOffset = 0;
         this._xArrowOffset = 0;
         if(this._alignMethod == ControlAlign.RIGHT || this._alignMethod == ControlAlign.RIGHT_TOP || this._alignMethod == ControlAlign.RIGHT_BOTTOM)
         {
            if(this._alignMethod == ControlAlign.RIGHT)
            {
               this._yOffset = -Math.round(height / 2);
            }
            else if(this._alignMethod == ControlAlign.RIGHT_TOP)
            {
               this._yOffset = -Math.round(height) + 20;
            }
            else if(this._alignMethod == ControlAlign.RIGHT_BOTTOM)
            {
               this._yOffset = -20;
            }
            this._xOffset = 10;
            this._xTargOffset = target.width;
            this._yTargOffset = target.height / 2;
            this._arrowAngle = 0;
            this._xArrowOffset = target.width / 2 + 5;
         }
         else if(this._alignMethod == ControlAlign.LEFT || this._alignMethod == ControlAlign.LEFT_TOP || this._alignMethod == ControlAlign.LEFT_BOTTOM)
         {
            if(this._alignMethod == ControlAlign.LEFT)
            {
               this._yOffset = -Math.round(height / 2);
            }
            else if(this._alignMethod == ControlAlign.LEFT_TOP)
            {
               this._yOffset = -Math.round(height) + 20;
            }
            else if(this._alignMethod == ControlAlign.LEFT_BOTTOM)
            {
               this._yOffset = -20;
            }
            this._xOffset = -Math.round(width) - 10;
            this._yTargOffset = target.height / 2;
            this._arrowAngle = 180;
            this._xArrowOffset = -(target.width / 2) - 5;
         }
         else if(this._alignMethod == ControlAlign.TOP || this._alignMethod == ControlAlign.TOP_LEFT || this._alignMethod == ControlAlign.TOP_RIGHT)
         {
            if(this._alignMethod == ControlAlign.TOP)
            {
               this._xOffset = -Math.round(width / 2);
            }
            else if(this._alignMethod == ControlAlign.TOP_LEFT)
            {
               this._xOffset = -width + 20;
            }
            else if(this._alignMethod == ControlAlign.TOP_RIGHT)
            {
               this._xOffset = -20;
            }
            this._yOffset = -Math.round(height) - 10;
            this._xTargOffset = target.width / 2;
            this._arrowAngle = 270;
            this._yArrowOffset = -target.height / 2 - 5;
         }
         else if(this._alignMethod == ControlAlign.BOTTOM || this._alignMethod == ControlAlign.BOTTOM_LEFT || this._alignMethod == ControlAlign.BOTTOM_RIGHT)
         {
            if(this._alignMethod == ControlAlign.BOTTOM)
            {
               this._xOffset = -Math.round(width / 2);
            }
            else if(this._alignMethod == ControlAlign.BOTTOM_LEFT)
            {
               this._xOffset = -width + 20;
            }
            else if(this._alignMethod == ControlAlign.BOTTOM_RIGHT)
            {
               this._xOffset = -20;
            }
            this._yOffset = 10;
            this._xTargOffset = target.width / 2;
            this._yTargOffset = target.height;
            this._arrowAngle = 90;
            this._yArrowOffset = target.height / 2 + 5;
         }
         this._position = new Point(this._xOffset + this._xTargOffset,this._yOffset + this._yTargOffset);
         this._position = target.localToGlobal(this._position);
      }
      
      override public function set style(s:Style) : void
      {
         super.style = s;
         this._chromeValid = false;
         invalidateDisplayList();
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(n:Number) : void
      {
         this._cornerRadius = n;
         this._chromeValid = false;
         invalidateDisplayList();
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp,false,3,true);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,false,3,true);
         this._addedTime = getTimer();
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         this.declineFocus();
      }
      
      private function onStageDown(event:MouseEvent) : void
      {
         if(getTimer() < this._addedTime + 500)
         {
            return;
         }
         if(mouseX < 0 || mouseY < 0 || mouseX > width || mouseY > height)
         {
            dispatchEvent(new ContainerEvent(ContainerEvent.CLICK_OUT));
         }
      }
      
      private function onStageUp(event:MouseEvent) : void
      {
         if(getTimer() < this._addedTime + 500)
         {
            return;
         }
         if(mouseX < 0 || mouseY < 0 || mouseX > width || mouseY > height)
         {
            dispatchEvent(new ContainerEvent(ContainerEvent.MOUSE_UP_OUT));
         }
      }
      
      public function get useArrow() : Boolean
      {
         return this._useArrow;
      }
      
      public function set useArrow(b:Boolean) : void
      {
         this._useArrow = b;
         this._arrowHolder.visible = b;
      }
      
      protected function onClose(event:ContainerEvent) : void
      {
         event.container = this;
      }
      
      public function requestFocus() : void
      {
         if(_module != null && IFocusGroup(_module).wantsFocus)
         {
            FocusManager.getInstance().addFocusGroup(_module as IFocusGroup);
         }
      }
      
      public function declineFocus() : void
      {
         if(_module != null)
         {
            FocusManager.getInstance().removeFocusGroup(_module as IFocusGroup);
         }
      }
      
      public function get constrainTo() : Rectangle
      {
         return this._constrainTo;
      }
      
      public function set constrainTo(value:Rectangle) : void
      {
         this._constrainTo = value;
      }
   }
}
