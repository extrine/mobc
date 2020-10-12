package iilwy.display.user.listitems
{
   import iilwy.model.dataobjects.user.FeedData;
   import iilwy.ui.containers.IListItem;
   
   public interface IFeedListItem extends IListItem
   {
       
      
      function set data(value:FeedData) : void;
      
      function set useDivider(value:Boolean) : void;
      
      function set editable(value:Boolean) : void;
   }
}
