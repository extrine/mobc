package iilwygames.pool.model.gameplay
{
   import flash.geom.Vector3D;
   import iilwygames.pool.model.physics.World;
   
   public class Obstacle extends GameObject
   {
       
      
      public function Obstacle()
      {
         super();
         radius = 0.05715 * 0.5;
         radiusSquared = radius * radius;
         setMass(0.16);
         var i:Number = 2 / 5 * mass * radius * radius;
         setInertia(i);
         aabbCollision = false;
      }
      
      override public function update(et:Number) : Boolean
      {
         var mu:Number = NaN;
         var contactVec:Vector3D = null;
         var vp:Vector3D = null;
         var gravity:Number = World.GRAVITY;
         return active;
      }
      
      override public function integrateForces(et:Number) : void
      {
      }
   }
}
