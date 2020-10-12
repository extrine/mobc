package iilwy.model.dataobjects
{
   import flash.events.EventDispatcher;
   
   public class CommentListData extends EventDispatcher
   {
       
      
      public var list:Array;
      
      public var maxItems:Number = 100;
      
      public var itemsPerPage:Number = 20;
      
      public var currentPage:Number = 0;
      
      public var commentedOnType:String;
      
      public var commentedOnId:String;
      
      public function CommentListData()
      {
         this.list = [];
         super();
      }
      
      public static function createTest(type:String = null) : CommentListData
      {
         var comment:CommentData = null;
         var commentList:CommentListData = new CommentListData();
         for(var i:Number = 0; i < 10; i++)
         {
            comment = CommentData.createTest(type);
            commentList.list.push(comment);
         }
         return commentList;
      }
      
      public function clear() : void
      {
         this.list = [];
      }
      
      public function getMostExpensiveComment() : CommentData
      {
         var arr:Array = this.sortByAmount();
         return arr[0];
      }
      
      public function sortByAmount() : Array
      {
         var arr:Array = this.list.concat();
         arr.sortOn("amount",Array.DESCENDING | Array.NUMERIC);
         return arr;
      }
      
      public function sortByTimeIndex() : Array
      {
         var arr:Array = this.list.concat();
         arr.sortOn("timeIndex",Array.NUMERIC);
         return arr;
      }
      
      public function get hasComments() : Boolean
      {
         return this.list != null && this.list.length >= 1;
      }
      
      public function initFromJson(json:Array) : void
      {
         var comment:CommentData = null;
         for(var i:Number = 0; i < json.length; i++)
         {
            comment = new CommentData();
            comment.initFromJson(json[i]);
            this.list.push(comment);
         }
      }
      
      public function addComment(comment:CommentData) : Boolean
      {
         var existing:CommentData = null;
         var match:Boolean = false;
         for each(existing in this.list)
         {
            if(comment.equals(existing))
            {
               match = true;
            }
         }
         if(!match)
         {
            this.list.unshift(comment);
         }
         return !match;
      }
      
      public function getRankOfPointAmount(amount:Number) : Number
      {
         var item:CommentData = null;
         var rank:Number = 0;
         var sortedComments:Array = this.sortByAmount();
         for(var i:Number = 0; i < sortedComments.length; i++)
         {
            item = sortedComments[i];
            if(amount >= item.amount)
            {
               break;
            }
            rank = i + 1;
         }
         return rank;
      }
      
      public function getCommentById(id:String) : CommentData
      {
         var comment:CommentData = null;
         for each(comment in this.list)
         {
            if(comment.id == id)
            {
               return comment;
            }
         }
         return null;
      }
   }
}
