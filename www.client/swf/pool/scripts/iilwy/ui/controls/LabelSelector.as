package iilwy.ui.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import iilwy.managers.GraphicManager;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.utils.CapType;
   import iilwy.ui.utils.ControlAlign;
   
   public class LabelSelector extends UiContainer
   {
       
      
      private var _label:Label;
      
      private var _data:SimpleMenuDataProvider;
      
      private var _align:String;
      
      private var _leftArrow:SimpleButton;
      
      private var _rightArrow:SimpleButton;
      
      protected var _editable:Boolean = true;
      
      public function LabelSelector(x:Number = 0, y:Number = 0, width:Number = undefined, styleId:String = "labelSelectorWhite")
      {
         this._align = ControlAlign.CENTER;
         super();
         this._data = new SimpleMenuDataProvider();
         this.width = width;
         this._label = new Label("",0,0,styleId);
         this._label.selectable = false;
         this._leftArrow = new SimpleButton();
         this._leftArrow.setStyleById(styleId);
         this._leftArrow.icon = GraphicManager.iconArrow2Left;
         this._leftArrow.capType = CapType.ROUND_LEFT;
         this._leftArrow.iconAlign = TextFormatAlign.RIGHT;
         this._rightArrow = new SimpleButton();
         this._rightArrow.setStyleById(styleId);
         this._rightArrow.icon = GraphicManager.iconArrow2Right;
         this._rightArrow.capType = CapType.ROUND_RIGHT;
         this._rightArrow.iconAlign = TextFormatAlign.LEFT;
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override public function createChildren() : void
      {
         addContentChild(this._label);
         addContentChild(this._leftArrow);
         addContentChild(this._rightArrow);
      }
      
      public function set selectedIndex(n:Number) : void
      {
         this._data.selectedIndex = n;
      }
      
      public function set selected(val:String) : void
      {
         var sel:* = undefined;
         for(var i:int = 0; i < this._data.items.length; i++)
         {
            sel = this._data.getItemAt(i);
            if(sel && sel.data.value == val)
            {
               this.selectedIndex = i;
            }
         }
      }
      
      public function get selected() : String
      {
         var result:String = null;
         var sel:* = this._data.getItemAt(this._data.selectedIndex);
         if(sel)
         {
            result = sel.data.value;
         }
         return result;
      }
      
      public function set editable(b:Boolean) : void
      {
         this._editable = b;
         invalidateDisplayList();
         invalidateProperties();
      }
      
      override public function commitProperties() : void
      {
         var sel:* = undefined;
         if(this._data)
         {
            sel = this._data.getItemAt(this._data.selectedIndex);
            if(sel)
            {
               this._label.text = sel.data.label;
            }
            if(this._data.length <= 1 || !this._editable)
            {
               this._rightArrow.visible = false;
               this._leftArrow.visible = false;
            }
            else
            {
               this._rightArrow.visible = true;
               this._leftArrow.visible = true;
            }
         }
      }
      
      override public function measure() : void
      {
         measuredWidth = this._label.width + 16 + 16 + 2 + 2;
         measuredHeight = Math.round(this._label.height);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var remainingWidth:Number = NaN;
         var bWidth:Number = NaN;
         var x:Number = NaN;
         remainingWidth = Math.round(unscaledWidth - this._label.width - 2 - 2);
         bWidth = Math.floor(remainingWidth / 2);
         this._leftArrow.height = unscaledHeight - 4;
         this._rightArrow.height = unscaledHeight - 4;
         this._leftArrow.y = 2;
         this._rightArrow.y = 2;
         x = 0;
         this._leftArrow.width = bWidth;
         this._leftArrow.x = 0;
         x = x + (this._leftArrow.width + 2);
         this._label.x = x;
         x = x + (this._label.width + 2);
         this._rightArrow.x = x;
         this._rightArrow.width = remainingWidth - bWidth;
      }
      
      public function removeAll() : void
      {
         this._data.removeAll();
      }
      
      public function addItem(label:String, value:String) : void
      {
         this._data.addItem(new MultiSelectData(label,value));
         if(this._data.length == 1)
         {
            this._data.selectedIndex = 0;
         }
         invalidateProperties();
         invalidateDisplayList();
         invalidateSize();
      }
      
      protected function onClick(event:Event) : void
      {
         if(!this._editable)
         {
            return;
         }
         var dir:int = -1;
         if(mouseX > width / 2)
         {
            dir = 1;
         }
         this.increment(dir);
      }
      
      public function increment(dir:int) : void
      {
         var index:int = this._data.selectedIndex + dir;
         if(index < 0)
         {
            this._data.selectedIndex = this._data.length - 1;
         }
         else if(index >= this._data.length)
         {
            this._data.selectedIndex = 0;
         }
         else
         {
            this._data.selectedIndex = index;
         }
         invalidateProperties();
         invalidateDisplayList();
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.SELECT);
         var di:* = this._data.getItemAt(this._data.selectedIndex).data;
         evt.label = di.label;
         evt.value = di.value;
         dispatchEvent(evt);
      }
   }
}
