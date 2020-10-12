package iilwy.model.dataobjects.shop
{
   import iilwy.collections.ArrayCollection;
   
   public class InventoryProductCollection extends ArrayCollection
   {
       
      
      protected var sortParam:String;
      
      public function InventoryProductCollection()
      {
         super();
      }
      
      public function getProductByID(id:int) : InventoryProduct
      {
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).id && InventoryProduct(_source[i]).id == id)
            {
               return InventoryProduct(_source[i]);
            }
         }
         return null;
      }
      
      public function getProductByProductID(id:int) : InventoryProduct
      {
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).catalogProduct && InventoryProduct(_source[i]).catalogProduct.id && InventoryProduct(_source[i]).catalogProduct.id == id)
            {
               return InventoryProduct(_source[i]);
            }
         }
         return null;
      }
      
      public function getProductByBaseItemID(baseID:int) : InventoryProduct
      {
         var inv:InventoryProduct = null;
         for(var i:int = 0; i < length; i++)
         {
            inv = InventoryProduct(_source[i]);
            if(inv.catalogProductBase && inv.catalogProductBase.id == baseID)
            {
               return inv;
            }
         }
         return null;
      }
      
      public function getProductsByCategory(categoryID:int) : Array
      {
         var result:Array = new Array();
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).catalogProductBase && InventoryProduct(_source[i]).catalogProductBase.categoryID == categoryID)
            {
               result.push(_source[i]);
            }
         }
         return result;
      }
      
      public function getProductsByCategoryKey(categoryKey:String) : Array
      {
         var result:Array = new Array();
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).catalogProductBase && InventoryProduct(_source[i]).catalogProductBase.categoryKey == categoryKey)
            {
               result.push(_source[i]);
            }
         }
         return result;
      }
      
      public function removeProductByID(id:int) : void
      {
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).id == id)
            {
               removeItemAt(i);
            }
         }
      }
      
      public function sortBy(param:String) : void
      {
         this.sortParam = param;
         _source = _source.sort(this.paramSort);
      }
      
      public function sortByReverse(param:String) : void
      {
         this.sortParam = param;
         _source = _source.sort(this.paramSortReverse);
      }
      
      public function sortNumeric(param:String) : void
      {
         _source = _source.sortOn(param,Array.NUMERIC);
      }
      
      public function sortNumericDescending(param:String) : void
      {
         _source = _source.sortOn(param,Array.NUMERIC | Array.DESCENDING);
      }
      
      protected function paramSort(a:InventoryProduct, b:InventoryProduct) : int
      {
         var strA:String = String(a.catalogProductBase.meta.getParamValue(this.sortParam)).toLowerCase();
         var strB:String = String(b.catalogProductBase.meta.getParamValue(this.sortParam)).toLowerCase();
         var sorter:Array = [strA,strB];
         sorter.sort();
         if(strA == strB)
         {
            return 0;
         }
         if(sorter[0] == strA)
         {
            return -1;
         }
         return 1;
      }
      
      protected function paramSortReverse(a:InventoryProduct, b:InventoryProduct) : int
      {
         var strA:String = String(b.catalogProductBase.meta.getParamValue(this.sortParam)).toLowerCase();
         var strB:String = String(a.catalogProductBase.meta.getParamValue(this.sortParam)).toLowerCase();
         var sorter:Array = [strA,strB];
         sorter.sort();
         if(strA == strB)
         {
            return 0;
         }
         if(sorter[0] == strA)
         {
            return -1;
         }
         return 1;
      }
      
      public function moveUp(id:int) : void
      {
         var product:InventoryProduct = null;
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).id == id && i != length - 1)
            {
               product = new InventoryProduct();
               product = _source[i];
               _source[i] = _source[i + 1];
               _source[i + 1] = product;
               break;
            }
         }
      }
      
      public function moveDown(id:int) : void
      {
         var product:InventoryProduct = null;
         for(var i:int = 0; i < length; i++)
         {
            if(InventoryProduct(_source[i]).id == id && i > 0)
            {
               product = new InventoryProduct();
               product = _source[i - 1];
               _source[i - 1] = _source[i];
               _source[i] = product;
               break;
            }
         }
      }
      
      public function clone(activeOnly:Boolean = false) : InventoryProductCollection
      {
         var clonedCollection:InventoryProductCollection = new InventoryProductCollection();
         clonedCollection.copy(this,activeOnly);
         return clonedCollection;
      }
      
      public function copy(other:InventoryProductCollection, activeOnly:Boolean = false) : void
      {
         var product:InventoryProduct = null;
         this.clearSource();
         var copiedSource:Array = [];
         for each(product in other.source)
         {
            if(product.active || !activeOnly)
            {
               copiedSource.push(product.clone());
            }
         }
         this.source = copiedSource;
      }
   }
}
