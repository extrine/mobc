package iilwy.model.dataobjects.market.product
{
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   
   public class ProductCollection extends ArrayCollection
   {
       
      
      protected var sortParam:String;
      
      public function ProductCollection()
      {
         super();
      }
      
      public function getProductByID(id:int) : Product
      {
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).id && Product(_source[i]).id == id)
            {
               return Product(_source[i]);
            }
         }
         return null;
      }
      
      public function getProductByBaseItemID(baseItemID:int) : Product
      {
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).baseItemID && Product(_source[i]).baseItemID == baseItemID)
            {
               return Product(_source[i]);
            }
         }
         return null;
      }
      
      public function getProductsByCategory(category:String) : Array
      {
         var result:Array = new Array();
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).category == category)
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
            if(Product(_source[i]).id == id)
            {
               removeItemAt(i);
            }
         }
      }
      
      public function search(searchObject:Object, value:String) : void
      {
         var focusValue:String = null;
         var score:Number = NaN;
         for(var i:int = 0; i < length; i++)
         {
            focusValue = Product(_source[i]).metadata.getParamValue(searchObject.name);
            score = searchObject.searchCommand.execute(value,focusValue);
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
      
      public function sortGender() : void
      {
         var yourGender:Array = new Array();
         var otherGender:Array = new Array();
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).gender == -1 || Product(_source[i]).gender == AppComponents.model.privateUser.gender)
            {
               yourGender.push(_source[i]);
            }
            else
            {
               otherGender.push(_source[i]);
            }
         }
         var combinedArray:Array = new Array();
         combinedArray = combinedArray.concat(yourGender);
         combinedArray = combinedArray.concat(otherGender);
         _source = combinedArray;
      }
      
      protected function paramSort(a:Product, b:Product) : int
      {
         var strA:String = String(a.metadata.getParamValue(this.sortParam)).toLowerCase();
         var strB:String = String(b.metadata.getParamValue(this.sortParam)).toLowerCase();
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
      
      protected function paramSortReverse(a:Product, b:Product) : int
      {
         var strA:String = String(b.metadata.getParamValue(this.sortParam)).toLowerCase();
         var strB:String = String(a.metadata.getParamValue(this.sortParam)).toLowerCase();
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
         var product:Product = null;
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).id == id && i != length - 1)
            {
               product = new Product();
               product = _source[i];
               _source[i] = _source[i + 1];
               _source[i + 1] = product;
               break;
            }
         }
      }
      
      public function moveDown(id:int) : void
      {
         var product:Product = null;
         for(var i:int = 0; i < length; i++)
         {
            if(Product(_source[i]).id == id && i > 0)
            {
               product = new Product();
               product = _source[i - 1];
               _source[i - 1] = _source[i];
               _source[i] = product;
               break;
            }
         }
      }
      
      public function clone(activeOnly:Boolean = false) : ProductCollection
      {
         var p:ProductCollection = new ProductCollection();
         p.copy(this,activeOnly);
         return p;
      }
      
      public function copy(other:ProductCollection, activeOnly:Boolean = false) : void
      {
         var product:Product = null;
         this.clearSource();
         var temp:Array = [];
         for each(product in other.source)
         {
            if(product.active || !activeOnly)
            {
               temp.push(product.clone());
            }
         }
         this.source = temp;
      }
   }
}
