package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.Margin;
   
   public class List extends UiContainer
   {
      
      public static var TYPE_HORIZONTAL:String = "horizontal";
      
      public static var TYPE_VERTICAL:String = "vertical";
       
      
      protected var _direction:String;
      
      protected var _itemPadding:Number = 5;
      
      public var verticalAlign:String;
      
      public var horizontalAlign:String;
      
      public function List(x:Number = 0, y:Number = 0, direction:String = "vertical")
      {
         super();
         this.x = x;
         this.y = y;
         this.direction = direction;
         this.verticalAlign = ControlAlign.TOP;
         this.horizontalAlign = ControlAlign.LEFT;
         maskContents = false;
         content.addEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidate);
      }
      
      override public function destroy() : void
      {
         content.removeEventListener(UiEvent.INVALIDATE_SIZE,this.onContentInvalidate);
         super.destroy();
      }
      
      override public function measure() : void
      {
         this.repositionChildren();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value == ListDirection.HORIZONTAL?ListDirection.HORIZONTAL:ListDirection.VERTICAL;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get type() : String
      {
         return this.direction;
      }
      
      public function set type(value:String) : void
      {
         this.direction = value;
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(p:Number) : void
      {
         this._itemPadding = p;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var item:DisplayObject = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var len:Number = content.numChildren;
         if(this._direction == ListDirection.HORIZONTAL && this.verticalAlign != ControlAlign.TOP)
         {
            for(i = 0; i < len; i++)
            {
               item = content.getChildAt(i);
               if(decideToIncludeChildInLayout(item))
               {
                  if(this.verticalAlign == ControlAlign.MIDDLE)
                  {
                     item.y = Math.floor(unscaledHeight / 2 - item.height / 2);
                  }
               }
            }
         }
      }
      
      protected function repositionChildren() : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var len:Number = NaN;
         var i:int = 0;
         var item:DisplayObject = null;
         var lastItem:DisplayObject = null;
         var margin:Margin = null;
         x = 0;
         y = 0;
         len = content.numChildren;
         measuredHeight = 0;
         measuredWidth = 0;
         if(this._direction == ListDirection.HORIZONTAL)
         {
            for(i = 0; i < len; i++)
            {
               item = content.getChildAt(i);
               if(decideToIncludeChildInLayout(item))
               {
                  margin = new Margin();
                  if(item is UiElement)
                  {
                     margin = UiElement(item).margin;
                  }
                  item.y = margin.top;
                  measuredHeight = Math.max(item.height + margin.top + margin.bottom,measuredHeight);
                  x = x + margin.left;
                  item.x = Math.floor(x);
                  x = x + margin.right;
                  x = x + (item.width + this.itemPadding);
               }
            }
            measuredWidth = Math.max(0,Math.floor(x - this.itemPadding));
         }
         else
         {
            for(i = 0; i < len; i++)
            {
               item = content.getChildAt(i);
               if(decideToIncludeChildInLayout(item))
               {
                  margin = new Margin();
                  if(item is UiElement)
                  {
                     margin = UiElement(item).margin;
                  }
                  item.x = margin.left;
                  measuredWidth = Math.max(item.width + margin.left + margin.right,measuredWidth);
                  y = y + margin.top;
                  item.y = Math.floor(y);
                  y = y + (item.height + this.itemPadding + margin.bottom);
               }
            }
            measuredHeight = Math.max(0,Math.floor(y - this.itemPadding));
         }
      }
      
      public function onContentInvalidate(event:UiEvent) : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function contentChildrenChanged() : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
   }
}
