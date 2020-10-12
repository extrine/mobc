package iilwy.model.dataobjects
{
   import flash.events.EventDispatcher;
   
   public class ViralMediaListData extends EventDispatcher
   {
       
      
      public var featuredComments:CommentListData;
      
      public var list:Array;
      
      public var currentPage:Number = 0;
      
      public var maxItems:Number = 100;
      
      public var limit:Number = 20;
      
      public var selectedIndex:Number = -1;
      
      public var selectedInList:Boolean = false;
      
      private var _selectedItem:ViralMediaData;
      
      public function ViralMediaListData()
      {
         this.list = [];
         super();
         this.featuredComments = new CommentListData();
      }
      
      public function clear() : void
      {
         this.list = new Array();
         this._selectedItem = null;
         this.selectedIndex = -1;
         this.featuredComments.clear();
      }
      
      public function addCommentToViralMediaItem(comment:CommentData) : Boolean
      {
         var added:Boolean = false;
         if(this.selectedItem != null && this.selectedItem.id == comment.commentedOnId)
         {
            if(this.selectedItem.commentList.addComment(comment))
            {
               added = true;
            }
         }
         var item:ViralMediaData = this.getNewsItemById(comment.commentedOnId);
         if(item != null)
         {
            if(item.commentList.addComment(comment))
            {
               added = true;
            }
         }
         return added;
      }
      
      public function getNewsItemById(id:String) : ViralMediaData
      {
         var result:ViralMediaData = null;
         var item:ViralMediaData = null;
         for each(item in this.list)
         {
            if(item.id == id)
            {
               result = item;
               break;
            }
         }
         return result;
      }
      
      public function set selectedItem(data:ViralMediaData) : void
      {
         this._selectedItem = data;
         var testIndex:Number = this.getIndexOf(data.id);
         if(!isNaN(testIndex))
         {
            this.selectedIndex = testIndex;
         }
         else
         {
            this.selectedIndex = -1;
         }
      }
      
      public function get selectedItem() : ViralMediaData
      {
         return this._selectedItem;
      }
      
      public function getItemAt(index:Number) : ViralMediaData
      {
         return this.list[index];
      }
      
      private function getIndexOf(id:String) : Number
      {
         var item:ViralMediaData = null;
         var index:Number = 0;
         for(var i:Number = 0; i < this.list.length; i++)
         {
            item = this.list[i];
            if(item.id == id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
   }
}
