package iilwy.ui.controls
{
   import com.adobe.utils.StringUtil;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.utils.ControlState;
   
   public class AutoCompleteInput extends TextInput
   {
      
      public static const AUTO_COMPLETE_NORMAL:String = "AutoCompleteNormal";
      
      public static const AUTO_COMPLETE_EMAIL:String = "AutoCompleteEmail";
       
      
      private var _completeArray:Array;
      
      private var _dropDownList:DropDownList;
      
      private var _stale:Boolean = true;
      
      private var _matchedArray:Array;
      
      private var _itemArray:Array;
      
      public var minCharsToSearch:int = 4;
      
      public var type:String = "AutoCompleteNormal";
      
      public function AutoCompleteInput(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 30, styleId:String = "textInput", dropDownSyleId:String = "comboBox")
      {
         super(x,y,width,height,styleId);
         this._completeArray = new Array();
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         addEventListener(MouseEvent.CLICK,this.onTextClicked);
         addEventListener(Event.CHANGE,this.onTextChange);
         this._dropDownList = new DropDownList(0,0,180,30,dropDownSyleId);
         this._dropDownList.addEventListener(MultiSelectEvent.SELECT,this.onListSelected);
         addChild(this._dropDownList);
         this._matchedArray = new Array();
         this._itemArray = new Array();
         tabEnabled = false;
      }
      
      private function onTextClicked(evt:MouseEvent) : void
      {
         if(!this._stale)
         {
            if(this._dropDownList.length > 0)
            {
               if(this.text.length >= this.minCharsToSearch)
               {
                  this.showDropDown();
               }
            }
         }
      }
      
      public function get selected() : int
      {
         return this._dropDownList.selected;
      }
      
      public function get selectedValue() : String
      {
         return this._dropDownList.value;
      }
      
      private function onTextChange(evt:Event) : void
      {
         this._stale = true;
         if(this.text.length >= this.minCharsToSearch)
         {
            this.matchItems();
         }
         else
         {
            this._dropDownList.setState(ControlState.COLLAPSED);
         }
      }
      
      private function findPreviousCommaOrSpace(ind:int, str:String) : int
      {
         for(var f:int = ind; f >= 0; f--)
         {
            if(str.charAt(f) == ",")
            {
               return f + 1;
            }
         }
         return 0;
      }
      
      private function findNextCommaOrEnd(ind:int, str:String) : int
      {
         var indE:int = 0;
         var indC:int = str.indexOf(",",ind);
         if(indC > 0)
         {
            indE = indC;
         }
         else
         {
            indE = str.length;
         }
         return indE;
      }
      
      private function getCurrentName(str:String, ind:int) : String
      {
         var x:int = this.findPreviousCommaOrSpace(ind,str);
         var y:int = this.findNextCommaOrEnd(ind,str);
         var nameStr:String = str.substr(x,y);
         if(nameStr.charAt(0) == " ")
         {
            nameStr = nameStr.substr(1,nameStr.length);
         }
         return nameStr;
      }
      
      private function matchItems() : void
      {
         var f:String = null;
         var g:String = null;
         var h:int = 0;
         if(this.text.length < this.minCharsToSearch || this.stage == null)
         {
            return;
         }
         var t:String = "";
         if(this.type == AutoCompleteInput.AUTO_COMPLETE_EMAIL)
         {
            t = this.getCurrentName(this.text,this.field.selectionBeginIndex);
            if(t.length == 0)
            {
               return;
            }
         }
         else if(this.type == AutoCompleteInput.AUTO_COMPLETE_NORMAL)
         {
            t = this.text;
         }
         this._matchedArray.splice(0,this._matchedArray.length);
         for each(f in this._itemArray)
         {
            g = StringUtil.ltrim(f).toLowerCase();
            h = g.indexOf(t.toLocaleLowerCase());
            if(h == 0)
            {
               this._matchedArray.push(f);
            }
         }
         if(this._matchedArray.length > 0)
         {
            this._dropDownList.setOptions(this._matchedArray);
            this._dropDownList.selected = 0;
            this._dropDownList.setState(ControlState.EXPANDED);
            this._stale = false;
         }
         else
         {
            this._stale = true;
            this._dropDownList.setState(ControlState.COLLAPSED);
         }
      }
      
      private function onListSelected(evt:MultiSelectEvent) : void
      {
         var whole:String = null;
         var x:int = 0;
         var y:int = 0;
         var str1:String = null;
         var str2:String = null;
         if(this.type == AutoCompleteInput.AUTO_COMPLETE_EMAIL)
         {
            whole = this.text;
            x = this.findPreviousCommaOrSpace(this.field.selectionBeginIndex,whole);
            y = this.findNextCommaOrEnd(this.field.selectionBeginIndex,whole);
            str1 = this.text.substr(0,x);
            str2 = this.text.substr(y,whole.length);
            this.text = str1 + this._dropDownList.value + "," + str2;
         }
         else
         {
            this.text = this._dropDownList.value;
         }
      }
      
      private function keyDownHandler(evt:KeyboardEvent) : void
      {
         var event:MultiSelectEvent = null;
         var whole:String = null;
         var x:int = 0;
         var y:int = 0;
         var str1:String = null;
         var str2:String = null;
         if(evt.keyCode == 13)
         {
            if(!this._stale)
            {
               if(this._dropDownList.length > 0)
               {
                  if(this.type == AutoCompleteInput.AUTO_COMPLETE_EMAIL)
                  {
                     whole = this.text;
                     x = this.findPreviousCommaOrSpace(this.field.selectionBeginIndex,whole);
                     y = this.findNextCommaOrEnd(this.field.selectionBeginIndex,whole);
                     str1 = this.text.substr(0,x);
                     str2 = this.text.substr(y,whole.length);
                     this.text = str1 + this._dropDownList.value + "," + str2;
                  }
                  else
                  {
                     this.text = this._dropDownList.value;
                  }
                  this.field.setSelection(this.text.length,this.text.length);
                  event = new MultiSelectEvent(MultiSelectEvent.SELECT);
                  event.value = this._dropDownList.value;
                  this.dispatchEvent(event);
               }
            }
            else
            {
               event = new MultiSelectEvent(MultiSelectEvent.SELECT);
               event.value = this.text;
               this.dispatchEvent(event);
            }
            this._dropDownList.setState(ControlState.COLLAPSED);
            this._stale = true;
         }
         if(this._dropDownList.length > 0)
         {
            if(evt.keyCode == 40)
            {
               if(this._dropDownList.selected == this._dropDownList.length - 1)
               {
                  this._dropDownList.selected = 0;
               }
               else
               {
                  this._dropDownList.selected++;
               }
            }
            else if(evt.keyCode == 38)
            {
               if(this._dropDownList.selected == 0)
               {
                  this._dropDownList.selected = this._dropDownList.length - 1;
               }
               else
               {
                  this._dropDownList.selected--;
               }
            }
         }
      }
      
      public function set itemArray(e:Array) : void
      {
         this._itemArray = e;
         this._dropDownList.setOptions(this._itemArray);
         this.matchItems();
      }
      
      public function get itemArray() : Array
      {
         return this._itemArray;
      }
      
      public function itemsUpdated() : void
      {
         this._stale = false;
         this.matchItems();
      }
      
      public function showDropDown() : void
      {
         this._dropDownList.setState(ControlState.EXPANDED);
      }
      
      public function setSelected(e:int) : void
      {
         this._dropDownList.selected = e;
      }
      
      public function hideDropDown() : void
      {
         this._dropDownList.setState(ControlState.COLLAPSED);
      }
   }
}
