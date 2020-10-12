package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.utils.Margin;
   
   public class Grid extends List
   {
       
      
      private var _size:Number;
      
      public function Grid(x:Number = 0, y:Number = 0, size:Number = 2, direction:String = "vertical")
      {
         super(x,y,direction);
         this.size = size;
      }
      
      public function set size(value:Number) : void
      {
         this._size = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function startedColumnAt(x:Number, y:Number, height:Number) : void
      {
      }
      
      protected function startedRowAt(x:Number, y:Number, width:Number) : void
      {
      }
      
      override protected function repositionChildren() : void
      {
         var len:Number = NaN;
         var margin:Margin = null;
         var item:DisplayObject = null;
         len = content.numChildren;
         if(len == 0)
         {
            return;
         }
         var x:Number = 0;
         var y:Number = 0;
         measuredHeight = 0;
         measuredWidth = 0;
         var itemWidth:Number = 0;
         var itemHeight:Number = 0;
         var maxx:Number = 0;
         var maxy:Number = 0;
         var desiredPadding:Number = 0;
         for(var i:int = 0; i < len; i++)
         {
            item = content.getChildAt(i);
            margin = new Margin();
            if(item is UiElement)
            {
               margin = UiElement(item).margin;
            }
            if(decideToIncludeChildInLayout(item))
            {
               if((i + 1) % this._size - 1 == 0 && i >= this._size || this._size == 1)
               {
                  x = direction == ListDirection.VERTICAL?Number(0):Number(x + itemWidth + desiredPadding);
                  y = direction == ListDirection.VERTICAL?Number(y + itemHeight + desiredPadding):Number(0);
               }
               desiredPadding = itemPadding;
               item.x = direction == ListDirection.VERTICAL?Number(x + margin.left):Number(Math.floor(x));
               item.y = direction == ListDirection.VERTICAL?Number(Math.floor(y)):Number(y + margin.top);
               maxx = Math.max(x,maxx);
               maxy = Math.max(y,maxy);
               itemWidth = item.width + margin.left + margin.right;
               itemHeight = item.height + margin.top + margin.bottom;
               if(direction == ListDirection.VERTICAL)
               {
                  x = x + (itemWidth + itemPadding);
               }
               else
               {
                  y = y + (itemHeight + itemPadding);
               }
            }
         }
         measuredWidth = maxx + itemWidth;
         measuredHeight = maxy + itemHeight;
      }
   }
}
