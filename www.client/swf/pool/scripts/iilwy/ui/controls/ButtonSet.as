package iilwy.ui.controls
{
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import iilwy.collections.ArrayCollection;
   import iilwy.display.core.TooltipManager;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.utils.CapType;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.ItemFactory;
   
   public class ButtonSet extends UiContainer
   {
       
      
      protected var data:ArrayCollection;
      
      protected var itemFactory:ItemFactory;
      
      protected var itemsValid:Boolean = true;
      
      protected var factoryValid:Boolean = false;
      
      protected var capTypeValid:Boolean = true;
      
      protected var list:List;
      
      protected var buttonDict:Dictionary;
      
      protected var valueDict:Dictionary;
      
      protected var enabledLookup:Object;
      
      protected var _size:Number;
      
      protected var _direction:String;
      
      protected var _horizontalAlign:String;
      
      protected var _toggle:Boolean;
      
      protected var _capType:String;
      
      protected var _capTypeAffectsAll:Boolean;
      
      protected var _cornerRadius:Number;
      
      protected var _buttonPadding:Margin;
      
      protected var _itemPadding:Number;
      
      protected var _scaleToFit:Boolean = true;
      
      protected var _scaleType:String = "proportional";
      
      protected var _selectedValue:String;
      
      protected var _selectedIndex:int;
      
      protected var _fontAlign:String;
      
      protected var _fontSize:Number;
      
      protected var _hilight:String;
      
      public var useStaticCache:Boolean = false;
      
      public var renderItemMethod:Function;
      
      public var buttonStyleId:String;
      
      public var buttonColor:Number;
      
      protected var customButtonStyleIds:Dictionary;
      
      public function ButtonSet(x:Number = 0, y:Number = 0, size:Number = 37, direction:String = "horizontal", styleID:String = "bevelButtonSet")
      {
         super();
         this.data = new ArrayCollection();
         this.buttonDict = new Dictionary();
         this.valueDict = new Dictionary();
         this.horizontalAlign = ControlAlign.LEFT;
         this.list = new List();
         this.list.direction = direction;
         this.itemFactory = new ItemFactory(BevelButton);
         this.enabledLookup = {};
         this.x = x;
         this.y = y;
         this.size = size;
         this.direction = direction;
         this.setStyleById(styleID);
         addEventListener(ButtonEvent.ROLL_OVER,this.onRollOver);
         addEventListener(ButtonEvent.ROLL_OUT,this.onRollOut);
         addEventListener(ButtonEvent.CLICK,this.onClick);
         tabChildren = false;
      }
      
      public function get numItems() : Number
      {
         return this.data.length;
      }
      
      public function get size() : Number
      {
         return this._size;
      }
      
      public function set size(value:Number) : void
      {
         this._size = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value == ListDirection.VERTICAL?ListDirection.VERTICAL:ListDirection.HORIZONTAL;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         this._horizontalAlign = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get toggle() : Boolean
      {
         return this._toggle;
      }
      
      public function set toggle(value:Boolean) : void
      {
         this._toggle = value;
      }
      
      public function get capType() : String
      {
         return this._capType;
      }
      
      public function set capType(value:String) : void
      {
         this._capType = value;
         this.capTypeValid = false;
         invalidateDisplayList();
      }
      
      public function get capTypeAffectsAll() : Boolean
      {
         return this._capTypeAffectsAll;
      }
      
      public function set capTypeAffectsAll(value:Boolean) : void
      {
         this._capTypeAffectsAll = value;
         this.capTypeValid = false;
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
      
      public function get buttonPadding() : Margin
      {
         return this._buttonPadding;
      }
      
      public function set buttonPadding(value:Margin) : void
      {
         this._buttonPadding = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(value:Number) : void
      {
         this._itemPadding = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get scaleToFit() : Boolean
      {
         return this._scaleToFit;
      }
      
      public function set scaleToFit(value:Boolean) : void
      {
         this._scaleToFit = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get scaleType() : String
      {
         return this._scaleType;
      }
      
      public function set scaleType(value:String) : void
      {
         this._scaleType = value;
         invalidateDisplayList();
      }
      
      public function get selectedValue() : String
      {
         return this._selectedValue;
      }
      
      public function set selectedValue(value:String) : void
      {
         this.setSelectedByValue(value);
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         var item:* = undefined;
         try
         {
            item = this.data.getItemAt(value);
         }
         catch(e:Error)
         {
         }
         if(item)
         {
            this.setSelectedByValue(MultiSelectData(item).value);
         }
         else
         {
            this.setSelectedByValue(null);
         }
      }
      
      public function get fontAlign() : String
      {
         return this._fontAlign;
      }
      
      public function set fontAlign(value:String) : void
      {
         this._fontAlign = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get fontSize() : Number
      {
         return this._fontSize;
      }
      
      public function set fontSize(value:Number) : void
      {
         this._fontSize = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get hilight() : String
      {
         return this._hilight;
      }
      
      public function set hilight(value:String) : void
      {
         this._hilight = value;
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function addMultiSelectData(value:MultiSelectData, buttonStyleId:String = null) : void
      {
         this.data.addItem(value);
         if(buttonStyleId)
         {
            if(!this.customButtonStyleIds)
            {
               this.customButtonStyleIds = new Dictionary();
            }
            this.customButtonStyleIds[value.value] = buttonStyleId;
         }
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function addItem(label:String, value:String) : void
      {
         var multiSelectData:MultiSelectData = new MultiSelectData(label,value);
         this.addMultiSelectData(multiSelectData);
      }
      
      public function removeMultiSelectData(value:MultiSelectData) : void
      {
         this.data.removeItem(value);
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function removeItem(value:String) : void
      {
         var multiSelectData:MultiSelectData = null;
         var len:int = this.data.length;
         for(var i:int = 0; i < len; i++)
         {
            multiSelectData = this.data.getItemAt(i) as MultiSelectData;
            if(multiSelectData.value == value)
            {
               this.removeMultiSelectData(multiSelectData);
               break;
            }
         }
      }
      
      public function removeAll() : void
      {
         this.data.removeAll();
         this.enabledLookup = {};
         this.itemsValid = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function setEnabledByID(id:String, value:Boolean) : void
      {
         this.enabledLookup[id] = !!value?"1":"0";
         invalidateProperties();
      }
      
      public function getButtonFromValue(value:String) : DisplayButton
      {
         if(!this.valueDict || !this.valueDict[value] || this.valueDict[value] == undefined)
         {
            return null;
         }
         return this.valueDict[value].button;
      }
      
      public function getDataFromValue(value:String) : MultiSelectData
      {
         if(!this.valueDict || !this.valueDict[value] || this.valueDict[value] == undefined)
         {
            return null;
         }
         return this.valueDict[value].data;
      }
      
      public function getDataFromButton(button:AbstractButton) : MultiSelectData
      {
         if(!this.buttonDict || !this.buttonDict[button] || this.buttonDict[button] == undefined)
         {
            return null;
         }
         return this.buttonDict[button] as MultiSelectData;
      }
      
      override public function destroy() : void
      {
         this.list.destroy();
         super.destroy();
      }
      
      override public function createChildren() : void
      {
         addContentChild(this.list);
      }
      
      override public function commitProperties() : void
      {
         var button:DisplayButton = null;
         var item:MultiSelectData = null;
         if(!this.factoryValid)
         {
            this.factoryValid = true;
            this.clearButtons();
            this.itemFactory.destroy();
            if(style.buttonStyleId.indexOf("bevelButton") >= 0)
            {
               this.itemFactory = new ItemFactory(BevelButton);
            }
            else if(style.buttonStyleId.indexOf("shadedButton") >= 0)
            {
               this.itemFactory = new ItemFactory(ShadedButton);
            }
            else
            {
               this.itemFactory = new ItemFactory(SimpleButton);
            }
            this.itemsValid = false;
         }
         if(!this.itemsValid)
         {
            this.itemsValid = true;
            this.list.itemPadding = getValidValue(this.itemPadding,style.itemPadding);
            this.clearButtons();
            this.buildButtons();
         }
         this.list.direction = this.direction;
         this.list.horizontalAlign = this.horizontalAlign;
         for(var i:int = 0; i < this.list.numContentChildren; i++)
         {
            button = this.list.getContentChildAt(i) as DisplayButton;
            item = this.data.getItemAt(i) as MultiSelectData;
            if(this.enabledLookup[item.value] == "0")
            {
               button.enabled = false;
            }
            else
            {
               button.enabled = true;
            }
            if(this._selectedValue == item.value)
            {
               button.selected = true;
            }
            else
            {
               button.selected = false;
            }
         }
      }
      
      override public function measure() : void
      {
         if(this._direction == ListDirection.HORIZONTAL)
         {
            measuredWidth = !isNaN(percentWidth)?Number(width * (percentWidth / 100)):Number(this.list.width);
            measuredHeight = this._size;
         }
         else if(this._direction == ListDirection.VERTICAL)
         {
            measuredHeight = !isNaN(percentHeight)?Number(height * (percentHeight / 100)):Number(this.list.height);
            measuredWidth = this.list.width;
         }
      }
      
      protected function sizeButtons() : void
      {
         var button:AbstractButton = null;
         var i:int = 0;
         var remainder:Number = NaN;
         var evenItemWidth:Number = 0;
         var evenItemCorrection:Number = 0;
         evenItemWidth = getExplicitOrMeasuredWidth() - this.list.itemPadding * (this.list.numContentChildren - 1);
         evenItemWidth = Math.floor(evenItemWidth / this.list.numContentChildren);
         evenItemCorrection = getExplicitOrMeasuredWidth() - evenItemWidth * this.list.numContentChildren - this.list.itemPadding * (this.list.numContentChildren - 1);
         var proportionalItemCorrection:Number = Math.floor((getExplicitOrMeasuredWidth() - this.list.width) / this.list.numContentChildren);
         var len:int = this.list.numContentChildren;
         var totalWidth:Number = 0;
         if(this._direction == ListDirection.HORIZONTAL)
         {
            for(i = 0; i < len; i++)
            {
               button = this.list.getContentChildAt(i) as AbstractButton;
               if(this.scaleToFit)
               {
                  if(this.scaleType == ButtonSetScaleType.EVEN)
                  {
                     button.width = evenItemWidth;
                     if(i < evenItemCorrection)
                     {
                        button.width = button.width + 1;
                     }
                  }
                  else if(proportionalItemCorrection > 0)
                  {
                     button.width = button.width + proportionalItemCorrection;
                  }
                  totalWidth = totalWidth + (button.width + this.list.itemPadding);
               }
               else
               {
                  button.width = undefined;
               }
            }
            totalWidth = totalWidth - this.list.itemPadding;
            if(this.scaleToFit)
            {
               if(button)
               {
                  remainder = getExplicitOrMeasuredWidth() - totalWidth;
                  button.width = button.width + remainder;
               }
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var button:AbstractButton = null;
         var len:int = this.list.numContentChildren;
         for(var i:int = 0; i < len; i++)
         {
            button = this.list.getContentChildAt(i) as AbstractButton;
            if(!isNaN(this.cornerRadius))
            {
               button.cornerRadius = this.cornerRadius;
            }
            if(this._direction == ListDirection.HORIZONTAL)
            {
               this.list.getContentChildAt(i).height = this._size;
               if(!this.capTypeValid)
               {
                  if(this._capTypeAffectsAll)
                  {
                     button.capType = this.capType;
                  }
                  else if(i == 0 && this.list.numContentChildren == 1)
                  {
                     button.capType = this.capType;
                  }
                  else if(i == 0)
                  {
                     if(this.capType == CapType.TAB)
                     {
                        button.capType = CapType.TAB_LEFT;
                     }
                     else if(this.capType == CapType.TAB_BOTTOM)
                     {
                        button.capType = CapType.TAB_BOTTOM_LEFT;
                     }
                     else if(this.capType == CapType.ROUND)
                     {
                        button.capType = CapType.ROUND_LEFT;
                     }
                     else
                     {
                        button.capType = CapType.NONE;
                     }
                  }
                  else if(i == this.list.numContentChildren - 1)
                  {
                     if(this.capType == CapType.TAB)
                     {
                        button.capType = CapType.TAB_RIGHT;
                     }
                     else if(this.capType == CapType.TAB_BOTTOM)
                     {
                        button.capType = CapType.TAB_BOTTOM_RIGHT;
                     }
                     else if(this.capType == CapType.ROUND)
                     {
                        button.capType = CapType.ROUND_RIGHT;
                     }
                     else
                     {
                        button.capType = CapType.NONE;
                     }
                  }
                  else
                  {
                     button.capType = CapType.NONE;
                  }
               }
            }
            else if(this._direction == ListDirection.VERTICAL)
            {
               this.list.getContentChildAt(i).width = unscaledWidth;
               this.list.getContentChildAt(i).height = this._size;
               if(!this.capTypeValid)
               {
                  if(this._capTypeAffectsAll)
                  {
                     button.capType = this.capType;
                  }
                  else if(i == 0 && this.list.numContentChildren == 1)
                  {
                     button.capType = this.capType;
                  }
                  else if(i == 0)
                  {
                     if(this.capType == CapType.TAB)
                     {
                        button.capType = CapType.TAB_LEFT;
                     }
                     else if(this.capType == CapType.ROUND)
                     {
                        button.capType = CapType.ROUND_TOP;
                     }
                     else
                     {
                        button.capType = CapType.NONE;
                     }
                  }
                  else if(i == this.list.numContentChildren - 1)
                  {
                     if(this.capType == CapType.TAB)
                     {
                        button.capType = CapType.TAB_BOTTOM_LEFT;
                     }
                     else if(this.capType == CapType.ROUND)
                     {
                        button.capType = CapType.ROUND_BOTTOM;
                     }
                     else
                     {
                        button.capType = CapType.NONE;
                     }
                  }
                  else
                  {
                     button.capType = CapType.NONE;
                  }
               }
            }
         }
         this.sizeButtons();
      }
      
      override public function setStyleById(styleID:String) : void
      {
         this.factoryValid = false;
         super.setStyleById(styleID);
         if(!style.buttonStyleId)
         {
            style.buttonStyleId = style.itemStyleId;
         }
      }
      
      protected function setSelectedByValue(value:String) : void
      {
         var index:int = 0;
         var len:int = 0;
         var i:int = 0;
         var multiSelectData:MultiSelectData = null;
         if(this.toggle)
         {
            index = -1;
            this._selectedValue = null;
            len = this.data.length;
            for(i = 0; i < len; i++)
            {
               multiSelectData = this.data.getItemAt(i) as MultiSelectData;
               if(multiSelectData.value == value)
               {
                  index = i;
                  break;
               }
            }
            this._selectedIndex = index;
            try
            {
               this._selectedValue = MultiSelectData(this.data.getItemAt(index)).value;
            }
            catch(e:Error)
            {
            }
            invalidateProperties();
         }
      }
      
      protected function buildButtons() : void
      {
         var button:DisplayButton = null;
         var item:MultiSelectData = null;
         var pl:Number = NaN;
         var pr:Number = NaN;
         for(var i:int = 0; i < this.data.length; i++)
         {
            button = this.itemFactory.createItem();
            button.width = undefined;
            item = this.data.getItemAt(i) as MultiSelectData;
            if(this.customButtonStyleIds && this.customButtonStyleIds[item.value])
            {
               button.setStyleById(getValidValue(this.customButtonStyleIds[item.value],this.buttonStyleId,style.buttonStyleId));
            }
            else
            {
               button.setStyleById(getValidValue(this.buttonStyleId,style.buttonStyleId));
            }
            if(!isNaN(this.buttonColor) && button.hasOwnProperty("color"))
            {
               button["color"] = this.buttonColor;
            }
            button.cornerRadius = this._cornerRadius;
            if(button is SkinButton)
            {
               SkinButton(button).skin.useStaticCache = this.useStaticCache;
            }
            pl = getValidValue(style.paddingLeft,0);
            pr = getValidValue(style.paddingRight,0);
            if(this._buttonPadding)
            {
               pl = this._buttonPadding.left;
               pr = this._buttonPadding.right;
            }
            if(i == 0)
            {
               pl = pl + chromePadding.left;
            }
            if(i == this.data.length - 1)
            {
               pr = pr + chromePadding.right;
            }
            if(this.fontAlign)
            {
               button.fontAlign = this.fontAlign;
            }
            if(this.fontSize && !isNaN(this.fontSize) && this.fontSize != 0)
            {
               button.fontSize = this.fontSize;
            }
            button.setPadding(0,pr,0,pl);
            if(style.minWidth)
            {
               button.minWidth = style.minWidth;
            }
            if(item.value == this.hilight)
            {
               try
               {
                  BevelButton(button).hilight = true;
               }
               catch(e:Error)
               {
               }
            }
            else
            {
               try
               {
                  BevelButton(button).hilight = false;
               }
               catch(e:Error)
               {
               }
            }
            if(item.label)
            {
               button.label = item.label;
               button.iconAlign = TextFormatAlign.LEFT;
            }
            else
            {
               button.iconAlign = TextFormatAlign.CENTER;
            }
            if(item.icon)
            {
               button.icon = item.icon;
            }
            if(item.tooltip)
            {
               button.tooltip = item.tooltip;
               button.tooltipDelay = TooltipManager.DELAY_MINIMUM;
            }
            else
            {
               button.tooltip = null;
            }
            if(this._direction == ListDirection.HORIZONTAL)
            {
               button.height = this._size;
               button.tooltipAlign = ControlAlign.TOP;
            }
            else if(this._direction == ListDirection.VERTICAL)
            {
               button.height = this._size;
               button.tooltipAlign = ControlAlign.RIGHT;
            }
            if(this.renderItemMethod != null)
            {
               this.renderItemMethod(button,item);
            }
            this.list.addContentChild(button);
            this.buttonDict[button] = item;
            this.valueDict[item.value] = {
               "button":button,
               "data":item
            };
         }
      }
      
      protected function clearButtons() : void
      {
         this.buttonDict = new Dictionary();
         this.valueDict = new Dictionary();
         var old:Array = this.list.clearContentChildren(false);
         this.itemFactory.recyleItems(old);
      }
      
      protected function onRollOver(event:ButtonEvent) : void
      {
         var multiSelectData:MultiSelectData = this.getDataFromButton(event.button);
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.ROLL_OVER,true);
         evt.value = multiSelectData.value;
         dispatchEvent(evt);
         event.stopImmediatePropagation();
      }
      
      protected function onRollOut(event:ButtonEvent) : void
      {
         var multiSelectData:MultiSelectData = this.getDataFromButton(event.button);
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.ROLL_OUT,true);
         evt.value = multiSelectData.value;
         dispatchEvent(evt);
         event.stopImmediatePropagation();
      }
      
      protected function onClick(event:ButtonEvent) : void
      {
         var multiSelectData:MultiSelectData = this.getDataFromButton(event.button);
         this.selectedValue = multiSelectData.value;
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.SELECT,true);
         evt.value = multiSelectData.value;
         dispatchEvent(evt);
         event.stopImmediatePropagation();
      }
      
      public function get hasItems() : Boolean
      {
         return this.data.length > 0;
      }
   }
}
