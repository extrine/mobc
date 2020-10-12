package iilwy.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import iilwy.events.CollectionEvent;
   
   public class DictionaryCollection extends EventDispatcher implements ICollection
   {
      
      public static const KEY:String = "key";
      
      public static const VALUE:String = "value";
       
      
      protected const KEY_NOT_FOUND_ERROR:String = "Key not found .";
      
      protected const KEY_EXISTS_ERROR:String = "Key already exists.";
      
      protected const OUT_OF_BOUNDS_ERROR:String = "Index out of bounds.";
      
      protected var _source:Dictionary;
      
      protected var sourceArray:Array;
      
      public function DictionaryCollection(source:Dictionary = null)
      {
         super();
         this.sourceArray = new Array();
         this.source = Boolean(source)?source:new Dictionary();
      }
      
      public function get source() : Dictionary
      {
         return this._source;
      }
      
      public function set source(value:Dictionary) : void
      {
         var key:* = undefined;
         this.sourceArray = [];
         if(value)
         {
            this._source = value;
            for(key in value)
            {
               this.sourceArray.push({
                  "key":key,
                  "value":value[key]
               });
            }
         }
         else
         {
            this._source = new Dictionary();
         }
         this.internalDispatchEvent(CollectionEvent.KIND_SOURCE_SET);
      }
      
      public function get length() : int
      {
         return this.sourceArray.length;
      }
      
      public function getItemAtKey(key:*) : *
      {
         if(this._source[key] == undefined)
         {
            throw new Error(this.KEY_NOT_FOUND_ERROR);
         }
         return this._source[key];
      }
      
      public function getKeyAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         return this.sourceArray[index].key;
      }
      
      public function getItemAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         return this.sourceArray[index].value;
      }
      
      public function setItemAtKey(item:*, key:*) : *
      {
         if(this._source[key] == undefined)
         {
            throw new Error(this.KEY_NOT_FOUND_ERROR);
         }
         var index:int = this.getKeyIndex(key);
         return this.setItemAt(item,index);
      }
      
      public function setItemAt(item:*, index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         var replaced:* = this.sourceArray[index].value;
         var key:* = this.sourceArray[index].key;
         this._source[key] = item;
         this.sourceArray.splice(index,1,{
            "key":key,
            "value":item
         });
         this.internalDispatchEvent(CollectionEvent.KIND_REPLACE,{
            "key":key,
            "value":item
         },index);
         return replaced;
      }
      
      public function addItem(key:*, item:*) : void
      {
         this.addItemAt(key,item,this.length);
      }
      
      public function addItemAt(key:*, item:*, index:int) : void
      {
         if(index < 0 || index > this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         if(this._source[key] != undefined)
         {
            throw new Error(this.KEY_EXISTS_ERROR + ": " + key);
         }
         this._source[key] = item;
         this.sourceArray.splice(index,0,{
            "key":key,
            "value":item
         });
         this.internalDispatchEvent(CollectionEvent.KIND_ADD,{
            "key":key,
            "value":item
         },index);
      }
      
      public function getItemKey(item:*) : *
      {
         var i:* = undefined;
         var key:* = null;
         for(i in this._source)
         {
            if(item === this._source[i])
            {
               key = i;
               break;
            }
         }
         return key;
      }
      
      public function getKeyIndex(key:*) : int
      {
         var n:int = this.sourceArray.length;
         for(var i:int = 0; i < n; i++)
         {
            if(this.sourceArray[i].key === key)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function getItemIndex(item:*) : int
      {
         var n:int = this.sourceArray.length;
         for(var i:int = 0; i < n; i++)
         {
            if(this.sourceArray[i].value === item)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function removeItem(item:*) : Boolean
      {
         var key:* = this.getItemKey(item);
         var result:Boolean = key != null;
         if(result)
         {
            this.removeItemAtKey(key);
         }
         return result;
      }
      
      public function removeItemAtKey(key:*) : *
      {
         if(this._source[key] == undefined)
         {
            throw new Error(this.KEY_NOT_FOUND_ERROR);
         }
         var index:int = this.getKeyIndex(key);
         return this.removeItemAt(index);
      }
      
      public function removeItemAt(index:int) : *
      {
         if(index < 0 || index >= this.length)
         {
            throw new Error(this.OUT_OF_BOUNDS_ERROR);
         }
         var removed:* = this.sourceArray[index].value;
         var key:* = this.sourceArray[index].key;
         this._source[key] = null;
         this.sourceArray.splice(index,1);
         this.internalDispatchEvent(CollectionEvent.KIND_REMOVE,{
            "key":key,
            "value":removed
         },index);
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
         this._source = new Dictionary();
         this.sourceArray.splice(0,this.length);
      }
      
      public function contains(item:*) : Boolean
      {
         return this.getItemKey(item) != null;
      }
      
      public function containsItemAtKey(key:*) : Boolean
      {
         var item:* = null;
         try
         {
            item = this.getItemAtKey(key);
         }
         catch(error:Error)
         {
         }
         return item != null;
      }
      
      public function itemUpdated(item:*) : void
      {
         this.internalDispatchEvent(CollectionEvent.KIND_MODIFY,item);
      }
      
      public function sortOnKey(options:Object = null) : void
      {
         this.sourceArray = this.sourceArray.sortOn("key",options);
      }
      
      public function sortOnValue(options:Object = null) : void
      {
         this.sourceArray = this.sourceArray.sortOn("value",options);
      }
      
      public function toDictionary() : Dictionary
      {
         var key:* = undefined;
         var clone:Dictionary = new Dictionary();
         for(key in this._source)
         {
            clone[key] = this._source[key];
         }
         return clone;
      }
      
      public function toArray(fieldName:String = null) : Array
      {
         var fieldArray:Array = null;
         var keyValue:Object = null;
         var keyValueArray:Array = this.sourceArray.concat();
         if(fieldName == KEY || fieldName == VALUE)
         {
            fieldArray = [];
            for each(keyValue in keyValueArray)
            {
               fieldArray.push(keyValue[fieldName]);
            }
            return fieldArray;
         }
         return keyValueArray;
      }
      
      override public function toString() : String
      {
         var i:int = 0;
         var string:String = "[DictionaryCollection";
         if(this._source && this.length > 0)
         {
            for(i = 0; i < this.sourceArray.length; i++)
            {
               string = string + (" {key:" + this.sourceArray[i].key + ", value:" + this.sourceArray[i].value + "}");
               string = string + (i < this.sourceArray.length - 1?",":"");
            }
            return string + "]";
         }
         return string + "]";
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
