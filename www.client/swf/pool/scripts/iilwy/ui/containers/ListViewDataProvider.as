package iilwy.ui.containers
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ListViewDataProvider extends EventDispatcher
   {
       
      
      protected var _data:Array;
      
      protected var _selectedUid:Number = -1;
      
      protected var _selectedUids:Array;
      
      public var allowMultipleSelection:Boolean = false;
      
      public function ListViewDataProvider()
      {
         this._selectedUids = [];
         super();
         this._data = new Array();
      }
      
      public function dispatchChangedEvent() : void
      {
         var evt:Event = new Event(Event.CHANGE,false);
         dispatchEvent(evt);
      }
      
      public function selectItem(uid:Number) : void
      {
         if(!this.allowMultipleSelection)
         {
            return;
         }
         var index:int = this._selectedUids.indexOf(uid);
         if(index < 0)
         {
            this._selectedUids.push(uid);
            this.dispatchChangedEvent();
         }
      }
      
      public function deselectItem(uid:Number) : void
      {
         if(!this.allowMultipleSelection)
         {
            return;
         }
         var index:int = this._selectedUids.indexOf(uid);
         if(index >= 0)
         {
            this._selectedUids.splice(index,1);
            this.dispatchChangedEvent();
         }
      }
      
      public function clearSelections() : void
      {
         this._selectedUid = -1;
         this._selectedUids = [];
         this.dispatchChangedEvent();
      }
      
      public function get selectedUids() : Array
      {
         return this._selectedUids;
      }
      
      public function get selectedUid() : Number
      {
         return this._selectedUid;
      }
      
      public function set selectedUid(uid:Number) : void
      {
         this._selectedUid = uid;
         this.dispatchChangedEvent();
      }
      
      public function get selectedIndex() : Number
      {
         return this.indexOf(this.selectedUid);
      }
      
      public function set selectedIndex(index:Number) : void
      {
         var d:ListViewDataWrapper = ListViewDataWrapper(this._data[index]);
         if(d)
         {
            this.selectedUid = d.uid;
         }
      }
      
      public function isSelected(uid:Number) : Boolean
      {
         var index:int = 0;
         if(!this.allowMultipleSelection)
         {
            return this._selectedUid == uid;
         }
         index = this._selectedUids.indexOf(uid);
         return index >= 0;
      }
      
      public function get items() : Array
      {
         return this._data;
      }
      
      public function addItem(data:*) : void
      {
         var wrapper:ListViewDataWrapper = new ListViewDataWrapper(data);
         this._data.push(wrapper);
         this.dispatchChangedEvent();
      }
      
      public function addItemAt(data:*, index:Number) : void
      {
         var wrapper:ListViewDataWrapper = new ListViewDataWrapper(data);
         index = Math.max(0,index);
         if(index < this._data.length)
         {
            this._data.splice(index,0,wrapper);
         }
         else
         {
            this._data.push(wrapper);
         }
         this.dispatchChangedEvent();
      }
      
      public function removeItem(data:*) : void
      {
         var len:int = this._data.length;
         for(var i:int = 0; i < len; i++)
         {
            if(ListViewDataWrapper(this._data[i]).data == data)
            {
               this.removeItemAt(i);
               break;
            }
         }
      }
      
      public function removeItemAt(index:int) : void
      {
         this._data.splice(index,1);
         this.dispatchChangedEvent();
      }
      
      public function getItemAt(index:Number) : ListViewDataWrapper
      {
         return this._data[index];
      }
      
      public function removeAll() : void
      {
         this._data = new Array();
         this.dispatchChangedEvent();
      }
      
      public function indexOf(uid:Number) : Number
      {
         var index:Number = -1;
         for(var i:Number = 0; i < this._data.length; i++)
         {
            if(ListViewDataWrapper(this._data[i]).uid == uid)
            {
               index = i;
               break;
            }
         }
         return index;
      }
      
      public function get length() : Number
      {
         return this._data.length;
      }
   }
}
