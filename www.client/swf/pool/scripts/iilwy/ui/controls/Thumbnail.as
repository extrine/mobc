package iilwy.ui.controls
{
   public class Thumbnail extends Image
   {
       
      
      public function Thumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleId:String = "thumbnail")
      {
         super(x,y,size,size,styleId);
         resizeMode = RESIZE_STRETCH;
         borderSize = 1;
      }
      
      override public function get size() : Number
      {
         return Math.max(width,height);
      }
      
      override public function set size(n:Number) : void
      {
         width = height = n;
      }
   }
}
