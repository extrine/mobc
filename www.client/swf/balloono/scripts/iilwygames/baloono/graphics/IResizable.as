package iilwygames.baloono.graphics
{
   import flash.geom.Rectangle;
   
   public interface IResizable
   {
       
      
      function get size() : Rectangle;
      
      function resize(param1:Number, param2:Number) : void;
   }
}
