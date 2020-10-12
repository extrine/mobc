package iilwygames.baloono.graphics
{
   import flash.display.DisplayObject;
   
   public interface IDrawable
   {
       
      
      function get display() : DisplayObject;
      
      function redraw(param1:uint) : void;
   }
}
