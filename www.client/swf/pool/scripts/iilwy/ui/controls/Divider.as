package iilwy.ui.controls
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import iilwy.ui.themes.Style;
   import iilwy.utils.BitmapCache;
   import iilwy.utils.UiRender;
   
   public class Divider extends UiElement
   {
      
      public static const LIST_IDENTIFIER:String = "dividerListIdentifier";
      
      public static const LIST_IDENTIFIER_VERTICAL:String = "dividerListIdentifierVertical";
      
      private static var staticCache:BitmapCache = new BitmapCache();
       
      
      private var _fill:BitmapData;
      
      private var _fillValid:Boolean = false;
      
      public var _dashColor:Number;
      
      private var _dash:int = 2;
      
      private var _gap:int = 1;
      
      public function Divider(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 1, styleId:String = "divider")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this._fill = new BitmapData(1,1,true);
         setStyleById(styleId);
      }
      
      override public function destroy() : void
      {
         this._fill = null;
         super.destroy();
      }
      
      public function set dashColor(n:Number) : void
      {
         this._dashColor = n;
         this._fillValid = false;
         invalidateDisplayList();
      }
      
      override public function set style(s:Style) : void
      {
         super.style = s;
         this._fillValid = false;
      }
      
      public function get dash() : int
      {
         return this._dash;
      }
      
      public function set dash(n:int) : void
      {
         this._dash = n;
      }
      
      public function get gap() : int
      {
         return this._gap;
      }
      
      public function set gap(n:int) : void
      {
         this._gap = n;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var col:Number = NaN;
         var key:String = null;
         var fill:BitmapData = null;
         var canvas:Sprite = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!this._fillValid)
         {
            col = getValidValue(this._dashColor,style.dashColor,570425344);
            key = style.fullyQualifiedName + col.toString() + this.dash.toString() + this.gap.toString();
            if(staticCache.contains(key))
            {
               fill = staticCache.getItem(key);
            }
            else
            {
               fill = new BitmapData(this.dash + this.gap,this.dash + this.gap,true,16711680);
               canvas = new Sprite();
               UiRender.renderRect(canvas,33488896,0,0,this.dash + this.gap,this.dash);
               UiRender.renderRect(canvas,col,0,0,this.dash,this.dash);
               fill.draw(canvas);
               staticCache.addItem(key,fill);
            }
            this._fill = fill;
            this._fillValid = true;
         }
         graphics.clear();
         graphics.beginBitmapFill(this._fill);
         graphics.moveTo(0,0);
         graphics.lineTo(unscaledWidth,0);
         graphics.lineTo(unscaledWidth,unscaledHeight);
         graphics.lineTo(0,unscaledHeight);
         graphics.lineTo(0,0);
         graphics.endFill();
      }
   }
}
