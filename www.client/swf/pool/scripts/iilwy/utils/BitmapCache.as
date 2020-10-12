package iilwy.utils
{
   import flash.display.BitmapData;
   
   public class BitmapCache
   {
       
      
      private var _lookup:Object;
      
      private var _list:Array;
      
      private var _maxItems:Number;
      
      public function BitmapCache(maxItems:Number = Infinity)
      {
         super();
         this._lookup = new Object();
         this._list = new Array();
         this._maxItems = maxItems;
      }
      
      public function destroy() : void
      {
         this.clear();
         this._lookup = null;
         this._list = null;
      }
      
      public function clear() : void
      {
         var prop:* = null;
         var bd:BitmapData = null;
         for(prop in this._lookup)
         {
            bd = this._lookup[prop];
            bd.dispose();
            delete this._lookup[prop];
         }
         this._lookup = new Array();
         this._list = new Array();
      }
      
      public function addItem(id:String, item:BitmapData) : void
      {
         var removeId:String = null;
         var remove:BitmapData = null;
         if(this._lookup[id] == null)
         {
            this._lookup[id] = item;
            this._list.push(id);
            if(this._list.length > this._maxItems)
            {
               removeId = this._list.shift();
               remove = this._lookup[removeId];
               delete this._lookup[removeId];
               remove.dispose();
            }
         }
      }
      
      public function getItem(id:String) : BitmapData
      {
         if(!this._lookup)
         {
            return null;
         }
         return this._lookup[id];
      }
      
      public function contains(id:String) : Boolean
      {
         if(this.getItem(id) == null)
         {
            return false;
         }
         return true;
      }
   }
}
