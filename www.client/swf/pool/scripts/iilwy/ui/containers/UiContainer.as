package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   use namespace omgpop_internal;
   
   public class UiContainer extends UiElement implements IUiContainer
   {
       
      
      protected var containerBackground:Sprite;
      
      protected var contentMask:Sprite;
      
      protected var contentRecentlyCleared:Boolean = true;
      
      protected var listeningForRender:Boolean = false;
      
      protected var methodQueue:Array;
      
      private var _backgroundColor:Number;
      
      private var _backgroundGradient:Array;
      
      private var _backgroundGradientAngle:Number;
      
      private var _cachePolicy:Boolean = false;
      
      private var _chromePadding:Margin;
      
      private var _content:Sprite;
      
      private var _maskContents:Boolean = false;
      
      public function UiContainer()
      {
         this.methodQueue = [];
         super();
         this._content = new Sprite();
         super.addChild(this._content);
         this.contentMask = new Sprite();
         this.contentMask.mouseEnabled = false;
         this._chromePadding = new Margin();
         mouseChildren = true;
         mouseEnabled = true;
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
      
      public function get cachePolicy() : Boolean
      {
         return this._cachePolicy;
      }
      
      public function set cachePolicy(value:Boolean) : void
      {
         this._cachePolicy = value;
         this._content.cacheAsBitmap = value;
      }
      
      public function get chromePadding() : Margin
      {
         return this._chromePadding;
      }
      
      public function set chromePadding(value:Margin) : void
      {
         this._chromePadding = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function get innerHeight() : Number
      {
         return this.calculateInnerHeight(this.height);
      }
      
      public function set innerHeight(value:Number) : void
      {
         height = value + padding.bottom + padding.top + this.chromePadding.top + this.chromePadding.bottom;
         invalidateDisplayList();
      }
      
      public function get innerWidth() : Number
      {
         return this.calculateInnerWidth(this.width);
      }
      
      public function set innerWidth(value:Number) : void
      {
         width = value + padding.left + padding.right + this.chromePadding.left + this.chromePadding.right;
         invalidateDisplayList();
      }
      
      public function get maskContents() : Boolean
      {
         return this._maskContents;
      }
      
      public function set maskContents(value:Boolean) : void
      {
         if(value)
         {
            if(!this._maskContents)
            {
               addChild(this.contentMask);
               UiRender.renderRect(this.contentMask,872349696,0,0,100,100);
               this._content.mask = this.contentMask;
            }
         }
         else if(this._maskContents)
         {
            this.contentMask.graphics.clear();
            removeChild(this.contentMask);
            this._content.mask = null;
         }
         this._maskContents = value;
      }
      
      public function get numContentChildren() : int
      {
         return this._content.numChildren;
      }
      
      override public function destroy() : void
      {
         this.clearContentChildren(true);
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._maskContents)
         {
            this.contentMask.width = unscaledWidth;
            this.contentMask.height = unscaledHeight;
         }
         if(this.containerBackground != null)
         {
            this.drawBackground();
            this.containerBackground.width = unscaledWidth;
            this.containerBackground.height = unscaledHeight;
         }
         if(this.cachePolicy)
         {
            this._content.cacheAsBitmap = true;
         }
      }
      
      override public function setThemeById(themeID:String) : void
      {
         var l:int = 0;
         var i:int = 0;
         var c:DisplayObject = null;
         if(themeID != this.themeID)
         {
            super.setThemeById(themeID);
            if(this._content && this._content.numChildren > 0)
            {
               l = this._content.numChildren;
               for(i = 0; i < l; i++)
               {
                  c = this._content.getChildAt(i);
                  if(c is UiElement)
                  {
                     UiElement(c).setThemeById(themeID);
                  }
               }
            }
         }
      }
      
      public function addContainerBackground() : void
      {
         if(this.containerBackground != null)
         {
            return;
         }
         this.containerBackground = new Sprite();
         this.containerBackground.mouseEnabled = false;
         addChildAt(this.containerBackground,0);
         UiRender.renderRect(this.containerBackground,33488896,0,0,1,1);
         invalidateDisplayList();
      }
      
      public function addContentChild(child:DisplayObject) : DisplayObject
      {
         var obj:DisplayObject = this.addContentChildAt(child,this.numContentChildren);
         return obj;
      }
      
      public function addContentChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         if(child is UiElement)
         {
            UiElement(child).setThemeById(themeID);
         }
         this._content.addChildAt(child,index);
         this.contentChildrenChanged();
         return child;
      }
      
      public function calculateInnerHeight(height:Number) : Number
      {
         return height - padding.bottom - padding.top - this.chromePadding.top - this.chromePadding.bottom;
      }
      
      public function calculateInnerWidth(width:Number) : Number
      {
         return width - padding.left - padding.right - this.chromePadding.left - this.chromePadding.right;
      }
      
      public function getContentChildren() : Array
      {
         var children:Array = [];
         var l:int = this.numContentChildren;
         for(var i:int = 0; i < l; i++)
         {
            children.push(this.getContentChildAt(i));
         }
         return children;
      }
      
      public function clearContentChildren(destroyChildren:Boolean = true) : Array
      {
         var item:DisplayObject = null;
         var element:Object = null;
         var cleared:Array = [];
         var len:Number = this._content.numChildren;
         if(this._content.numChildren > 0)
         {
            do
            {
               item = this._content.getChildAt(0);
               if(destroyChildren)
               {
                  try
                  {
                     element = Object(item);
                     element.destroy();
                  }
                  catch(e:Error)
                  {
                  }
               }
               else
               {
                  cleared.push(item);
               }
               this.removeContentChild(item);
            }
            while(this._content.numChildren > 0);
            
         }
         this.contentRecentlyCleared = true;
         return cleared;
      }
      
      public function getContentChildAt(index:Number) : DisplayObject
      {
         var child:DisplayObject = this._content.getChildAt(index);
         return child;
      }
      
      public function getContentChildByName(name:String) : DisplayObject
      {
         var child:DisplayObject = this._content.getChildByName(name);
         return child;
      }
      
      public function getContentChildIndex(child:DisplayObject) : int
      {
         var index:int = this._content.getChildIndex(child);
         return index;
      }
      
      public function removeContentChild(child:DisplayObject) : DisplayObject
      {
         try
         {
            this._content.removeChild(child);
         }
         catch(e:Error)
         {
         }
         this.contentChildrenChanged();
         return child;
      }
      
      public function removeContentChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = this._content.removeChildAt(index);
         this.contentChildrenChanged();
         return child;
      }
      
      public function setChromePadding(... args) : void
      {
         this._chromePadding.setValues.apply(this._chromePadding,args);
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function setContentChildIndex(child:DisplayObject, index:int) : void
      {
         this._content.setChildIndex(child,index);
         this.contentChildrenChanged();
      }
      
      protected function contentChildrenChanged() : void
      {
         if(!validating)
         {
            invalidateDisplayList();
         }
      }
      
      protected function decideToIncludeChildInLayout(child:DisplayObject) : Boolean
      {
         var element:UiElement = null;
         var value:Boolean = true;
         if(child is UiElement)
         {
            element = child as UiElement;
            if(!element.includeInLayout)
            {
               value = false;
            }
         }
         return value;
      }
      
      protected function drawBackground() : void
      {
         var fill:Array = null;
         this.containerBackground.graphics.clear();
         var grad:Array = getValidValue(this._backgroundGradient,style.backgroundGradient);
         var col:Number = getValidValue(this._backgroundColor,style.backgroundColor,33554431);
         if(grad)
         {
            fill = grad;
         }
         else
         {
            fill = [col,col];
         }
         var bgColor:Number = getValidValue(this._backgroundColor,style.backgroundColor,33554431);
         UiRender.renderGradient(this.containerBackground,fill,Math.PI / 2,0,0,1,1);
      }
      
      public function callLater(method:Function, args:Array = null) : void
      {
         this.methodQueue.push(new MethodQueueElement(method,args));
         if(!this.listeningForRender)
         {
            StageReference.stage.addEventListener(Event.ENTER_FRAME,this.callLaterDispatcher);
            this.listeningForRender = true;
         }
         StageReference.stage.invalidate();
      }
      
      omgpop_internal function cancelAllCallLaters() : void
      {
         if(this.listeningForRender)
         {
            StageReference.stage.removeEventListener(Event.ENTER_FRAME,this.callLaterDispatcher);
            this.listeningForRender = false;
         }
         this.methodQueue.splice(0);
      }
      
      private function callLaterDispatcher(event:Event) : void
      {
         var mqe:MethodQueueElement = null;
         if(this.listeningForRender)
         {
            StageReference.stage.removeEventListener(Event.ENTER_FRAME,this.callLaterDispatcher);
            this.listeningForRender = false;
         }
         var queue:Array = this.methodQueue;
         this.methodQueue = [];
         var n:int = queue.length;
         for(var i:int = 0; i < n; i++)
         {
            mqe = MethodQueueElement(queue[i]);
            mqe.method.apply(null,mqe.args);
         }
      }
   }
}

class MethodQueueElement
{
    
   
   public var method:Function;
   
   public var args:Array;
   
   function MethodQueueElement(method:Function, args:Array = null)
   {
      super();
      this.method = method;
      this.args = args;
   }
}
