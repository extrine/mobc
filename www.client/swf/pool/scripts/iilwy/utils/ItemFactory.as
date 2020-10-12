package iilwy.utils
{
   import iilwy.utils.logging.Logger;
   
   public class ItemFactory
   {
       
      
      public var maxRecycledItems:Number = 400;
      
      private var _itemType:Class;
      
      private var _recycledItems:Array;
      
      private var _logger:Logger;
      
      private var createdCount:int = 0;
      
      public function ItemFactory(itemType:Class)
      {
         super();
         this._itemType = itemType;
         this._recycledItems = new Array();
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.WARN;
      }
      
      public function destroy() : void
      {
         this.clearRecycledItems(true);
         this._itemType = null;
         this._recycledItems = null;
      }
      
      public function createItem() : *
      {
         var item:* = undefined;
         if(this._recycledItems.length > 0)
         {
            item = this._recycledItems.shift();
            this._logger.log("reusing item" + this._itemType);
         }
         else
         {
            item = new this._itemType();
            this.createdCount++;
            this._logger.log("creating item" + this._itemType + " ( " + this.createdCount + " ) ");
         }
         return item;
      }
      
      public function recyleItems(items:Array) : void
      {
         var item:* = undefined;
         for each(item in items)
         {
            this.recycleItem(item);
         }
      }
      
      public function recycleItem(item:*) : void
      {
         var index:Number = NaN;
         var e:Error = null;
         if(item is this._itemType)
         {
            if(this._recycledItems.length < this.maxRecycledItems)
            {
               index = this._recycledItems.indexOf(item);
               this._logger.log("recycling item" + this._itemType + " ( " + this._recycledItems.length + " ) ");
               if(index == -1)
               {
                  this._recycledItems.push(item);
               }
            }
            else
            {
               try
               {
                  item.destroy();
               }
               catch(e:Error)
               {
               }
            }
            return;
         }
         e = new Error("Item factory can only reclaim errors of it\'s own type");
         throw e;
      }
      
      public function clearRecycledItems(destroy:Boolean = true) : void
      {
         var item:* = undefined;
         var l:Number = this._recycledItems.length;
         for(var i:Number = l - 1; i >= 0; i--)
         {
            item = this._recycledItems.pop();
            if(destroy)
            {
               try
               {
                  item.destroy();
               }
               catch(e:Error)
               {
               }
            }
         }
      }
   }
}
