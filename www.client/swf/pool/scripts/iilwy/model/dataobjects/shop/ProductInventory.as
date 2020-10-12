package iilwy.model.dataobjects.shop
{
   import com.adobe.utils.DictionaryUtil;
   import iilwy.collections.DictionaryCollection;
   
   public class ProductInventory
   {
       
      
      private var _collection:DictionaryCollection;
      
      public function ProductInventory()
      {
         super();
         this._collection = new DictionaryCollection();
      }
      
      public function clear() : void
      {
         this._collection.clearSource();
      }
      
      public function getProductCollection(shopID:int) : InventoryProductCollection
      {
         if(!this._collection.containsItemAtKey(shopID))
         {
            this._collection.addItem(shopID,new InventoryProductCollection());
         }
         return this._collection.getItemAtKey(shopID);
      }
      
      public function getShopIDs() : Array
      {
         return DictionaryUtil.getKeys(this._collection.source);
      }
      
      public function get collection() : DictionaryCollection
      {
         return this._collection;
      }
      
      public function set collection(value:DictionaryCollection) : void
      {
         this._collection = value;
      }
      
      public function clone(activeOnly:Boolean = false) : ProductInventory
      {
         var inventory:ProductInventory = new ProductInventory();
         inventory.copy(this,activeOnly);
         return inventory;
      }
      
      public function copy(other:ProductInventory, activeOnly:Boolean = false) : void
      {
         var id:int = 0;
         var inv:InventoryProductCollection = null;
         var copiedInv:InventoryProductCollection = null;
         this.clear();
         var shopIDs:Array = other.getShopIDs();
         for each(id in shopIDs)
         {
            inv = other.getProductCollection(id);
            copiedInv = inv.clone(activeOnly);
            this._collection.addItem(id,copiedInv);
         }
      }
      
      public function getProductByID(productID:int) : InventoryProduct
      {
         var inventoryCollection:InventoryProductCollection = null;
         var product:InventoryProduct = null;
         for each(inventoryCollection in this._collection.source)
         {
            product = inventoryCollection.getProductByID(productID);
            if(product)
            {
               return product;
            }
         }
         return null;
      }
      
      public function getProductByProductID(productID:int) : InventoryProduct
      {
         var inventoryCollection:InventoryProductCollection = null;
         var product:InventoryProduct = null;
         for each(inventoryCollection in this._collection.source)
         {
            product = inventoryCollection.getProductByProductID(productID);
            if(product)
            {
               return product;
            }
         }
         return null;
      }
      
      public function getProductByBaseItemID(baseItemID:int) : InventoryProduct
      {
         var inventoryCollection:InventoryProductCollection = null;
         var product:InventoryProduct = null;
         for each(inventoryCollection in this._collection.source)
         {
            product = inventoryCollection.getProductByBaseItemID(baseItemID);
            if(product)
            {
               return product;
            }
         }
         return null;
      }
      
      public function getInventoryProductCount() : int
      {
         var result:int = 0;
         var inventoryCollection:InventoryProductCollection = null;
         var inventoryProduct:InventoryProduct = null;
         for each(inventoryCollection in this._collection.source)
         {
            for each(inventoryProduct in inventoryCollection.source)
            {
               result++;
            }
         }
         return result;
      }
   }
}
