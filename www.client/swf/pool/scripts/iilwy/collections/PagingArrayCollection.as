package iilwy.collections
{
   public class PagingArrayCollection extends ArrayCollection
   {
       
      
      public var currentPage:int;
      
      public var maxItems:int;
      
      private var _offset:int;
      
      public var limit:int;
      
      public function PagingArrayCollection()
      {
         super();
      }
      
      public function get offset() : int
      {
         if(this._offset > 0)
         {
            return this._offset;
         }
         return this.currentPage * this.limit;
      }
      
      public function set offset(value:int) : void
      {
         this._offset = value;
         this.currentPage = this.findPageOfIndex(value);
      }
      
      public function findPageOfIndex(index:int) : int
      {
         var page:Number = Math.floor(index / this.limit);
         return page;
      }
   }
}
