package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   import iilwy.utils.BitmapCache;
   import iilwy.utils.UiRender;
   
   public class ProcessingIndicator extends UiElement
   {
      
      protected static var stripesCache:BitmapCache = new BitmapCache();
       
      
      protected var stripesMask:Sprite;
      
      protected var stripes:Sprite;
      
      protected var loopTimer:Timer;
      
      protected var stripesBitmapData:BitmapData;
      
      protected var stripesOffset:int;
      
      protected var stripesValid:Boolean = false;
      
      protected var _stripeSize:Number = 10;
      
      protected var _cornerRadius:Number;
      
      protected var _stroke:Number = 3;
      
      public function ProcessingIndicator(x:Number = 0, y:Number = 0, width:Number = 80, height:Number = 20, styleID:String = "processingIndicator")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         setStyleById(styleID);
         this.stripesMask = new Sprite();
         addChild(this.stripesMask);
         this.stripes = new Sprite();
         this.stripes.mask = this.stripesMask;
         addChild(this.stripes);
         buttonMode = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.loopTimer = new Timer(1000 / 30);
         this.loopTimer.addEventListener(TimerEvent.TIMER,this.onLoop);
         this.stripesBitmapData = new BitmapData(10,10);
      }
      
      override public function destroy() : void
      {
         removeChild(this.stripesMask);
         this.stripesMask = null;
         removeChild(this.stripes);
         this.stripes = null;
         this.stripesBitmapData = null;
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var canvas:Sprite = null;
         var sSize:int = 0;
         var cacheKey:String = null;
         var diameter:Number = NaN;
         var offset:Number = NaN;
         var str:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!this.stripesValid)
         {
            this.stripesValid = true;
            canvas = new Sprite();
            sSize = 4 * Math.floor(Math.sqrt(this._stripeSize * this._stripeSize / 2)) + 1;
            cacheKey = sSize.toString();
            this.stripesBitmapData = stripesCache.getItem(cacheKey);
            if(!this.stripesBitmapData)
            {
               this.stripesBitmapData = new BitmapData(sSize,sSize,true,16777215);
               UiRender.renderStripes(canvas,0,this._stripeSize,0,0,sSize,sSize);
               this.stripesBitmapData.draw(canvas);
               stripesCache.addItem(cacheKey,this.stripesBitmapData);
            }
         }
         if(sizeChanged)
         {
            diameter = getValidValue(this._cornerRadius,unscaledHeight);
            offset = 0;
            str = getValidValue(this._stroke,0);
            graphics.clear();
            if(str > 0)
            {
               offset = this.stroke + 2;
               graphics.lineStyle(str,0,10);
               graphics.drawRoundRect(str / 2,str / 2,unscaledWidth - str,unscaledHeight - str,diameter,diameter);
               diameter = diameter - str;
            }
            this.stripesMask.graphics.clear();
            this.stripes.graphics.clear();
            try
            {
               UiRender.renderRoundRect(this.stripesMask,16711680,offset,offset,unscaledWidth - offset - offset,unscaledHeight - offset - offset,diameter);
            }
            catch(e:Error)
            {
            }
            this.stripesOffset = -50;
            this.onLoop(null);
         }
      }
      
      public function get stripeSize() : Number
      {
         return this._stripeSize;
      }
      
      public function set stripeSize(value:Number) : void
      {
         this._stripeSize = value;
         this.stripesValid = false;
         invalidateDisplayList();
      }
      
      public function get cornerRadius() : Number
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(value:Number) : void
      {
         this._cornerRadius = value;
         invalidateDisplayList();
      }
      
      public function get stroke() : Number
      {
         return this._stroke;
      }
      
      public function set stroke(value:Number) : void
      {
         this._stroke = value;
         invalidateDisplayList();
      }
      
      public function set animate(value:Boolean) : void
      {
         if(value)
         {
            this.loopTimer.start();
         }
         else
         {
            this.loopTimer.stop();
         }
      }
      
      protected function onLoop(event:TimerEvent) : void
      {
         if(!stage)
         {
            return;
         }
         this.stripesOffset = this.stripesOffset + 2;
         if(this.stripesOffset > 0)
         {
            this.stripesOffset = -4 * Math.floor(Math.sqrt(this._stripeSize * this._stripeSize / 2));
         }
         var matrix:Matrix = new Matrix();
         matrix.translate(this.stripesOffset,0);
         this.stripes.graphics.clear();
         this.stripes.graphics.beginBitmapFill(this.stripesBitmapData,matrix,true,false);
         try
         {
            this.stripes.graphics.drawRect(0,0,width,height);
         }
         catch(e:Error)
         {
         }
      }
   }
}
