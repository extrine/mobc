package iilwy.display.shop
{
   import iilwy.display.thumbnails.ProductThumbnail;
   
   public class MiniProductGridItem extends ProductThumbnail
   {
       
      
      public function MiniProductGridItem()
      {
         super();
         isPNG = true;
         setStyleById("clearImage");
      }
   }
}
