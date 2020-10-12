package iilwy.ui.controls
{
   import flash.events.EventDispatcher;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.utils.ArrayUtil;
   
   use namespace omgpop_internal;
   
   public class AbstractOptionButtonGroup extends EventDispatcher
   {
       
      
      protected var buttons:Array;
      
      protected var _enabled:Boolean = true;
      
      protected var _selections:Array;
      
      protected var _selectionLimit:int;
      
      protected var _unselectableEnabled:Boolean;
      
      private var unselectableCurrentlyDisabled:Boolean;
      
      public var wrapOnSelectionLimit:Boolean = false;
      
      public function AbstractOptionButtonGroup()
      {
         this._selections = [];
         super();
         this.buttons = new Array();
      }
      
      public function clear() : void
      {
         while(this.buttons.length > 0)
         {
            this.removeButton(this.buttons[0]);
         }
         this._selections = [];
         this.unselectableCurrentlyDisabled = false;
         this._selectionLimit = 0;
         this._enabled = true;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         var button:AbstractOptionButton = null;
         this._enabled = value;
         for each(button in this.buttons)
         {
            button.enabled = value;
         }
         if(value)
         {
            this.unselectableCurrentlyDisabled = false;
         }
         this.setUnselectableEnabledValue();
      }
      
      omgpop_internal function get selections() : Array
      {
         return this._selections;
      }
      
      omgpop_internal function set selections(value:Array) : void
      {
         var button:AbstractOptionButton = null;
         this.deselectAll();
         for each(button in value)
         {
            this.selectButton(button);
         }
      }
      
      omgpop_internal function get unselectedButtons() : Array
      {
         return ArrayUtil.createUniqueCopyFromArray1NotInArray2(this.buttons,this.selections);
      }
      
      omgpop_internal function get unselectableButtons() : Array
      {
         return this.numSelectedButtons >= this.selectionLimit?this.unselectedButtons:[];
      }
      
      omgpop_internal function get selectionLimit() : int
      {
         return this._selectionLimit;
      }
      
      omgpop_internal function set selectionLimit(value:int) : void
      {
         var selectionsOver:Array = null;
         var button:AbstractOptionButton = null;
         this._selectionLimit = value;
         if(value > 0 && value < this.numSelectedButtons)
         {
            selectionsOver = this.selections.slice(value + 1);
            this.selections = this.selections.slice(0,value);
            for each(button in selectionsOver)
            {
               this.deselectButton(button);
            }
         }
      }
      
      omgpop_internal function get unselectableEnabled() : Boolean
      {
         return this._unselectableEnabled;
      }
      
      omgpop_internal function set unselectableEnabled(value:Boolean) : void
      {
         this._unselectableEnabled = value;
         if(this.unselectableButtons.length > 0)
         {
            this.setUnselectableEnabledValue();
         }
      }
      
      omgpop_internal function get numButtons() : int
      {
         return this.buttons.length;
      }
      
      omgpop_internal function get numSelectedButtons() : int
      {
         return this.selections.length;
      }
      
      omgpop_internal function addButton(button:AbstractOptionButton) : void
      {
         button.addEventListener(ButtonEvent.CHANGED,this.onButtonChanged,false,0,true);
         button.enabled = !this.enabled || !this.unselectableEnabled && this.numSelectedButtons >= this.selectionLimit && !this.wrapOnSelectionLimit?Boolean(false):Boolean(true);
         this.buttons.push(button);
      }
      
      omgpop_internal function removeButton(button:AbstractOptionButton) : void
      {
         button.removeEventListener(ButtonEvent.CHANGED,this.onButtonChanged);
         ArrayUtil.removeValueFromArray(this.selections,button);
         ArrayUtil.removeValueFromArray(this.buttons,button);
      }
      
      omgpop_internal function getButtonAt(index:int) : AbstractOptionButton
      {
         return this.buttons[index];
      }
      
      omgpop_internal function selectAll() : void
      {
         var button:AbstractOptionButton = null;
         for each(button in this.buttons)
         {
            this.selectButton(button);
         }
      }
      
      omgpop_internal function deselectAll() : void
      {
         var button:AbstractOptionButton = null;
         for each(button in this.buttons)
         {
            this.deselectButton(button);
         }
      }
      
      protected function selectButton(value:AbstractOptionButton) : void
      {
         var shifted:AbstractOptionButton = null;
         if(!value)
         {
            return;
         }
         if(this.selectionLimit == 0 || this.numSelectedButtons < this.selectionLimit || this.wrapOnSelectionLimit)
         {
            if(this.numSelectedButtons == this.selectionLimit && this.wrapOnSelectionLimit)
            {
               shifted = this.selections.shift();
               shifted.selected = false;
               this.dispatchChangedEvent(shifted);
            }
            value.selected = true;
            this.selections.push(value);
         }
         this.setUnselectableEnabledValue();
      }
      
      protected function deselectButton(value:AbstractOptionButton) : void
      {
         if(!value)
         {
            return;
         }
         value.selected = false;
         ArrayUtil.removeValueFromArray(this.selections,value);
         this.setUnselectableEnabledValue();
      }
      
      protected function selectButtonByValue(value:String) : void
      {
         var button:AbstractOptionButton = this.buttons[this.indexOfButtonValue(value)];
         if(button)
         {
            this.selectButton(button);
         }
      }
      
      protected function indexOfButtonValue(value:String) : int
      {
         var button:AbstractOptionButton = null;
         var result:int = -1;
         for(var i:int = 0; i < this.numButtons; i++)
         {
            button = this.buttons[i];
            if(button.value === value)
            {
               result = i;
            }
         }
         return result;
      }
      
      protected function setUnselectableEnabledValue() : void
      {
         var unselectedButton:AbstractOptionButton = null;
         if(!this.enabled)
         {
            return;
         }
         var unselecteds:Array = this.unselectedButtons;
         if(this.unselectableCurrentlyDisabled && this.numSelectedButtons < this.selectionLimit || this.wrapOnSelectionLimit)
         {
            for each(unselectedButton in unselecteds)
            {
               unselectedButton.enabled = true;
            }
            this.unselectableCurrentlyDisabled = false;
         }
         else if(!this.unselectableEnabled && !this.unselectableCurrentlyDisabled && this.numSelectedButtons >= this.selectionLimit)
         {
            for each(unselectedButton in unselecteds)
            {
               unselectedButton.enabled = false;
            }
            this.unselectableCurrentlyDisabled = true;
         }
      }
      
      protected function onButtonChanged(event:ButtonEvent) : void
      {
         var button:AbstractOptionButton = event.button as AbstractOptionButton;
         if(button.selected)
         {
            this.selectButton(button);
         }
         else
         {
            this.deselectButton(button);
         }
         this.dispatchChangedEvent(button);
      }
      
      protected function dispatchChangedEvent(button:AbstractOptionButton) : void
      {
         var evt:MultiSelectEvent = new MultiSelectEvent(MultiSelectEvent.CHANGED);
         evt.value = button;
         dispatchEvent(evt);
      }
   }
}
