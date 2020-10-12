package iilwy.collections
{
   import flash.events.EventDispatcher;
   import iilwy.events.CollectionEvent;
   
   public class ArrayCollection extends EventDispatcher implements ICollection
   {
       
      
      protected const OUT_OF_BOUNDS_ERROR:String = "Index out of bounds.";
      
      protected var _source:Array;
      
      public function ArrayCollection(source:Array = null)
      {
         super();
         this.source = Boolean(source)?source:new Array();
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function set source(value:Array) : void
      {
         this._source = Boolean(value)?value:[];
         this.internalDispatchEvent(CollectionEvent.KIND_SOURCE_SET);
      }
      
      public function get length() : int
      {
         return Boolean(this._source)?int(this._source.length):int(0);
      }
      
      public function getItemAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         return this._source[index];
      }
      
      public function setItemAt(item:*, index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         var replaced:* = this._source.splice(index,1,item)[0];
         this.internalDispatchEvent(CollectionEvent.KIND_REPLACE,item,index);
         return replaced;
      }
      
      public function addItem(item:*) : void
      {
         this.addItemAt(item,this.length);
      }
      
      public function addItemAt(item:*, index:int) : void
      {
         if(index < 0 || index > this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         this._source.splice(index,0,item);
         this.internalDispatchEvent(CollectionEvent.KIND_ADD,item,index);
      }
      
      public function getItemIndex(item:*) : int
      {
         var n:int = this._source.length;
         for(var i:int = 0; i < n; i++)
         {
            if(this._source[i] === item)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function removeItem(item:*) : Boolean
      {
         var index:int = this.getItemIndex(item);
         var result:Boolean = index >= 0;
         if(result)
         {
            this.removeItemAt(index);
         }
         return result;
      }
      
      public function removeItemAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         var removed:* = this._source.splice(index,1)[0];
         this.internalDispatchEvent(CollectionEvent.KIND_REMOVE,removed,index);
         return removed;
      }
      
      public function removeAll() : void
      {
         if(this.length > 0)
         {
            this.clearSource();
            this.internalDispatchEvent(CollectionEvent.KIND_RESET);
         }
      }
      
      public function clearSource() : void
      {
         this._source.splice(0,this.length);
      }
      
      public function contains(item:*) : Boolean
      {
         return this.getItemIndex(item) != -1;
      }
      
      public function itemUpdated(item:*) : void
      {
         this.internalDispatchEvent(CollectionEvent.KIND_MODIFY,item);
      }
      
      public function toArray() : Array
      {
         return this._source.concat();
      }
      
      override public function toString() : String
      {
         if(this._source)
         {
            return this._source.toString();
         }
         return super.toString();
      }
      
      protected function internalDispatchEvent(kind:String, item:* = null, location:int = -1) : void
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = kind;
         if(item)
         {
            event.items.push(item);
         }
         event.location = location;
         dispatchEvent(event);
      }
   }
}
