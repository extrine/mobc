package iilwygames.pool.model.physics
{
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class Wall
   {
       
      
      public var pointA:Vector3D;
      
      public var pointB:Vector3D;
      
      public var normal:Vector3D;
      
      public var vectorAB:Vector3D;
      
      public var fullVector:Vector3D;
      
      public var aabb:Rectangle;
      
      public var isBackWall:Boolean;
      
      public var isRail:Boolean;
      
      public function Wall(ax:Number, ay:Number, bx:Number, by:Number, backwall:Boolean = false, rail:Boolean = false)
      {
         super();
         this.pointA = new Vector3D(ax,ay,0);
         this.pointB = new Vector3D(bx,by,0);
         this.normal = new Vector3D(ay - by,bx - ax);
         this.normal.normalize();
         this.vectorAB = this.pointB.subtract(this.pointA);
         this.fullVector = this.vectorAB.clone();
         this.vectorAB.normalize();
         this.aabb = new Rectangle();
         this.aabb.left = Math.min(ax,bx);
         this.aabb.right = Math.max(ax,bx);
         this.aabb.top = Math.min(ay,by);
         this.aabb.bottom = Math.max(ay,by);
         this.isBackWall = backwall;
         this.isRail = rail;
      }
      
      public function destroy() : void
      {
         this.pointA = null;
         this.pointB = null;
         this.normal = null;
         this.vectorAB = null;
         this.fullVector = null;
      }
   }
}
