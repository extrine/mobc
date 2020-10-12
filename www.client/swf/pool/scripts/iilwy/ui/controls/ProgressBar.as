package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import iilwy.ui.themes.Style;
   import iilwy.utils.MathUtil;
   import iilwy.utils.UiRender;
   
   public class ProgressBar extends UiElement
   {
       
      
      protected var border:Sprite;
      
      protected var bgBar:Sprite;
      
      protected var fgBar:Sprite;
      
      protected var processingIndicator:ProcessingIndicator;
      
      protected var readout:Label;
      
      protected var barsValid:Boolean = false;
      
      protected var _percent:Number = 100;
      
      protected var _borderSize:Number;
      
      protected var _borderColor:Number;
      
      protected var _backgroundColor:Number;
      
      protected var _foregroundColor:Number;
      
      protected var _cornerDiameter:Number;
      
      protected var _insideCornerDiameter:Number;
      
      protected var _preventDistortion:Boolean = true;
      
      protected var _processOverBorder:Boolean = true;
      
      protected var _showReadout:Boolean = false;
      
      protected var _foregroundGradient:Array;
      
      public function ProgressBar(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 19, styleID:String = "progressBar")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this.border = new Sprite();
         addChild(this.border);
         this.bgBar = new Sprite();
         addChild(this.bgBar);
         this.processingIndicator = new ProcessingIndicator();
         this.processingIndicator.height = height;
         this.processingIndicator.cornerRadius = height;
         this.processingIndicator.stroke = 0;
         this.processingIndicator.alpha = 0.1;
         addChild(this.processingIndicator);
         this.processing = false;
         this.fgBar = new Sprite();
         addChild(this.fgBar);
         this.readout = new Label();
         setStyleById(styleID);
      }
      
      override public function destroy() : void
      {
         this.border.scale9Grid = null;
         removeChild(this.border);
         this.border = null;
         this.bgBar.scale9Grid = null;
         removeChild(this.bgBar);
         this.bgBar = null;
         this.processingIndicator.destroy();
         this.fgBar.scale9Grid = null;
         removeChild(this.fgBar);
         this.fgBar = null;
         if(contains(this.readout))
         {
            removeChild(this.readout);
         }
         this._percent = undefined;
         super.destroy();
      }
      
      override public function commitProperties() : void
      {
         super.commitProperties();
         if(this.readout)
         {
            if(this._showReadout && !contains(this.readout))
            {
               addChild(this.readout);
            }
            else if(!this._showReadout && contains(this.readout))
            {
               removeChild(this.readout);
            }
            this.readout.setStyleById(styleID);
            this.readout.text = Math.round(this.percent) + "%";
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var brdrSize:Number = NaN;
         var barWidth:Number = NaN;
         var barHeight:Number = NaN;
         var brdrColor:Number = NaN;
         var bgColor:Number = NaN;
         var fgColor:Number = NaN;
         var fgGradient:Array = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         brdrSize = this.getValidBorderSize();
         barWidth = this.getBarWidth(unscaledWidth);
         barHeight = this.getBarHeight(unscaledHeight);
         var edge:Number = this.getEdge(unscaledHeight);
         var diameter:Number = this.getValidDiameter(unscaledHeight);
         var insideDiameter:Number = this.getValidInsideDiameter(unscaledHeight);
         if(!this.barsValid)
         {
            this.barsValid = true;
            brdrColor = getValidValue(this.borderColor,style.borderColor);
            this.border.graphics.clear();
            UiRender.renderRoundRect(this.border,brdrColor,0,0,100,100,diameter);
            this.border.scale9Grid = new Rectangle(edge,edge,100 - edge - edge,100 - edge - edge);
            this.border.width = unscaledWidth;
            this.border.height = unscaledHeight;
            edge = Math.floor(barHeight / 2);
            bgColor = getValidValue(this.backgroundColor,style.backgroundColor);
            this.bgBar.graphics.clear();
            UiRender.renderRoundRect(this.bgBar,bgColor,0,0,100,100,insideDiameter);
            try
            {
               this.bgBar.scale9Grid = new Rectangle(edge,edge,100 - edge - edge,100 - edge - edge);
            }
            catch(e:Error)
            {
            }
            this.bgBar.x = brdrSize;
            this.bgBar.y = brdrSize;
            this.bgBar.width = barWidth;
            this.bgBar.height = barHeight;
            this.processingIndicator.x = !!this.processOverBorder?Number(0):Number(brdrSize);
            this.processingIndicator.y = !!this.processOverBorder?Number(0):Number(brdrSize);
            this.processingIndicator.width = !!this.processOverBorder?Number(unscaledWidth):Number(barWidth);
            this.processingIndicator.height = this.processingIndicator.cornerRadius = !!this.processOverBorder?Number(unscaledHeight):Number(barHeight);
            fgColor = getValidValue(this.foregroundColor,style.foregroundColor,0);
            fgGradient = getValidValue(this.foregroundGradient,style.foregroundGradient);
            this.fgBar.graphics.clear();
            if(fgGradient)
            {
               UiRender.renderGradient(this.fgBar,fgGradient,0,0,0,100,100,insideDiameter);
            }
            else
            {
               UiRender.renderRoundRect(this.fgBar,fgColor,0,0,100,100,insideDiameter);
            }
            try
            {
               this.fgBar.scale9Grid = new Rectangle(edge,edge,100 - edge - edge,100 - edge - edge);
            }
            catch(e:Error)
            {
            }
            this.fgBar.x = brdrSize;
            this.fgBar.y = brdrSize;
            this.fgBar.height = barHeight;
         }
         var w:Number = Math.floor(this._percent / 100 * barWidth);
         this.fgBar.width = !this.preventDistortion || w > insideDiameter || w == 0?Number(w):Number(insideDiameter);
         if(this._showReadout)
         {
            this.readout.x = Math.max(5,this.fgBar.width - this.readout.width - 3);
            this.readout.y = unscaledHeight / 2 - this.readout.height / 2;
         }
      }
      
      override public function set width(value:Number) : void
      {
         this.barsValid = false;
         super.width = value;
      }
      
      override public function set height(value:Number) : void
      {
         this.barsValid = false;
         super.height = value;
      }
      
      override public function set style(value:Style) : void
      {
         this.barsValid = false;
         super.style = value;
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function set percent(value:Number) : void
      {
         this._percent = MathUtil.clamp(0,100,value);
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get borderSize() : Number
      {
         return this._borderSize;
      }
      
      public function set borderSize(value:Number) : void
      {
         this._borderSize = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get stroke() : Number
      {
         return this.borderSize;
      }
      
      public function set stroke(value:Number) : void
      {
         this.borderSize = value;
      }
      
      public function get borderColor() : Number
      {
         return this._borderColor;
      }
      
      public function set borderColor(value:Number) : void
      {
         this._borderColor = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get backgroundColor() : Number
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(value:Number) : void
      {
         this._backgroundColor = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get foregroundColor() : Number
      {
         return this._foregroundColor;
      }
      
      public function set foregroundColor(value:Number) : void
      {
         this._foregroundColor = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get foregroundGradient() : Array
      {
         return this._foregroundGradient;
      }
      
      public function set foregroundGradient(value:Array) : void
      {
         this._foregroundGradient = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get cornerDiameter() : Number
      {
         return this._cornerDiameter;
      }
      
      public function set cornerDiameter(value:Number) : void
      {
         this._cornerDiameter = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function get cornerRadius() : Number
      {
         return this.cornerDiameter / 2;
      }
      
      public function set cornerRadius(value:Number) : void
      {
         this.cornerDiameter = value * 2;
      }
      
      public function get insideCornerDiameter() : Number
      {
         return this._insideCornerDiameter;
      }
      
      public function set insideCornerDiameter(value:Number) : void
      {
         this._insideCornerDiameter = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      public function set processing(value:Boolean) : void
      {
         this.processingIndicator.animate = value;
         this.processingIndicator.visible = value;
      }
      
      public function get preventDistortion() : Boolean
      {
         return this._preventDistortion;
      }
      
      public function set preventDistortion(value:Boolean) : void
      {
         this._preventDistortion = value;
         invalidateDisplayList();
      }
      
      public function get processOverBorder() : Boolean
      {
         return this._processOverBorder;
      }
      
      public function set processOverBorder(value:Boolean) : void
      {
         this._processOverBorder = value;
         this.barsValid = false;
         invalidateDisplayList();
      }
      
      protected function getValidBorderSize() : Number
      {
         return getValidValue(this.borderSize,style.borderSize,0);
      }
      
      protected function getBarWidth(width:Number) : Number
      {
         return width - this.getValidBorderSize() * 2;
      }
      
      protected function getBarHeight(height:Number) : Number
      {
         return height - this.getValidBorderSize() * 2;
      }
      
      protected function getEdge(height:Number) : Number
      {
         return Math.ceil(height / 2);
      }
      
      protected function getValidDiameter(height:Number) : Number
      {
         return getValidValue(this.cornerDiameter,style.cornerDiameter,Math.floor(height / 2) * 2);
      }
      
      protected function getValidInsideDiameter(height:Number) : Number
      {
         return getValidValue(this.insideCornerDiameter,Math.floor(this.getBarHeight(height) / 2) * 2);
      }
      
      public function set showReadout(value:Boolean) : void
      {
         this._showReadout = value;
         invalidateProperties();
         invalidateDisplayList();
      }
   }
}
