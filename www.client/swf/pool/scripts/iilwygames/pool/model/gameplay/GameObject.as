package iilwygames.pool.model.gameplay
{
   import flash.geom.Rectangle;
   import iilwygames.pool.model.physics.Body;
   
   public class GameObject extends Body
   {
       
      
      public var aabbCollision:Boolean;
      
      public var boundingBox:Rectangle;
      
      public var active:Boolean;
      
      public function GameObject()
      {
         super();
         this.boundingBox = new Rectangle();
         this.aabbCollision = false;
         this.active = true;
      }
      
      override public function destroy() : void
      {
         this.boundingBox = null;
         super.destroy();
      }
      
      override public function update(et:Number) : Boolean
      {
         return this.active;
      }
      
      public function updateAABB(et:Number) : void
      {
         var xt:Number = position.x + velocity.x * et;
         var yt:Number = position.y + velocity.y * et;
         var minx:Number = Math.min(position.x,xt);
         var maxx:Number = Math.max(position.x,xt);
         var miny:Number = Math.min(position.y,yt);
         var maxy:Number = Math.max(position.y,yt);
         this.boundingBox.left = minx - radius;
         this.boundingBox.right = maxx + radius;
         this.boundingBox.top = miny - radius;
         this.boundingBox.bottom = maxy + radius;
      }
   }
}
