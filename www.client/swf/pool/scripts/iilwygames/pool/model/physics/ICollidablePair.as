package iilwygames.pool.model.physics
{
   public interface ICollidablePair
   {
       
      
      function get toc() : Number;
      
      function willCollideIn(dt:Number) : Boolean;
      
      function resolve() : void;
   }
}
