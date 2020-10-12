package iilwygames.pool.model.gameplay
{
   public class GhostBall extends GameObject
   {
       
      
      public function GhostBall()
      {
         super();
         radius = 0.05715 * 0.5;
         radiusSquared = radius * radius;
         setMass(0.5);
         var i:Number = 2 / 5 * mass * radius * radius;
         setInertia(i);
         aabbCollision = false;
      }
   }
}
