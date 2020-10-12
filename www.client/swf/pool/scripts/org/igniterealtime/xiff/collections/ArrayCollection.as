package org.igniterealtime.xiff.collections
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import org.igniterealtime.xiff.collections.events.CollectionEvent;
   import org.igniterealtime.xiff.collections.events.CollectionEventKind;
   
   public class ArrayCollection extends Proxy implements IEventDispatcher
   {
       
      
      protected const OUT_OF_BOUNDS_MESSAGE:String = "The supplied index is out of bounds.";
      
      protected var eventDispatcher:EventDispatcher;
      
      protected var _source:Array;
      
      public function ArrayCollection(source:Array = null)
      {
         this._source = [];
         super();
         this.eventDispatcher = new EventDispatcher(this);
         if(source)
         {
            this.source = source;
         }
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function set source(value:Array) : void
      {
         this._source = Boolean(value)?value:[];
         this.internalDispatchEvent(CollectionEventKind.RESET);
      }
      
      public function get length() : int
      {
         return Boolean(this._source)?int(this._source.length):int(0);
      }
      
      public function getItemAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new RangeError(this.OUT_OF_BOUNDS_MESSAGE);
         }
         return this._source[index];
      }
      
      public function setItemAt(item:*, index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new RangeError(this.OUT_OF_BOUNDS_MESSAGE);
         }
         var replaced:* = this._source.splice(index,1,item)[0];
         this.internalDispatchEvent(CollectionEventKind.REPLACE,item,index);
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
            throw new RangeError(this.OUT_OF_BOUNDS_MESSAGE);
         }
         this._source.splice(index,0,item);
         this.internalDispatchEvent(CollectionEventKind.ADD,item,index);
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
            throw new RangeError(this.OUT_OF_BOUNDS_MESSAGE);
         }
         var removed:* = this._source.splice(index,1)[0];
         this.internalDispatchEvent(CollectionEventKind.REMOVE,removed,index);
         return removed;
      }
      
      public function removeAll() : void
      {
         if(this.length > 0)
         {
            this.clearSource();
            this.internalDispatchEvent(CollectionEventKind.RESET);
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
         this.internalDispatchEvent(CollectionEventKind.UPDATE,item);
      }
      
      public function toArray() : Array
      {
         return this._source.concat();
      }
      
      public function toString() : String
      {
         if(this._source)
         {
            return this._source.toString();
         }
         return "";
      }
      
      protected function internalDispatchEvent(kind:String, item:* = null, location:int = -1) : void
      {
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = kind;
         event.items.push(item);
         event.location = location;
         this.dispatchEvent(event);
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var n:Number = NaN;
         var message:String = null;
         if(name is QName)
         {
            var name:* = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(error:Error)
         {
         }
         if(index == -1)
         {
            message = "Unknown Property: " + name + ".";
            throw new Error(message);
         }
         return this.getItemAt(index);
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var n:Number = NaN;
         var message:String = null;
         if(name is QName)
         {
            var name:* = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(error:Error)
         {
         }
         if(index == -1)
         {
            message = "Unknown Property: " + name + ".";
            throw new Error(message);
         }
         this.setItemAt(value,index);
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         var n:Number = NaN;
         if(name is QName)
         {
            var name:* = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(error:Error)
         {
         }
         if(index == -1)
         {
            return false;
         }
         return index >= 0 && index < this.length;
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         return index < this.length?int(index + 1):int(0);
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return (index - 1).toString();
      }
      
      override flash_proxy function nextValue(index:int) : *
      {
         return this.getItemAt(index - 1);
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         return null;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this.eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.eventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(type);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.eventDispatcher.willTrigger(type);
      }
   }
}
