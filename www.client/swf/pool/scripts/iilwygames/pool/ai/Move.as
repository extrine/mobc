package iilwygames.pool.ai
{
   import flash.geom.Vector3D;
   import iilwygames.pool.model.gameplay.Ball;
   
   public class Move
   {
      
      public static const TYPE_NONE:int = -1;
      
      public static const TYPE_DIRECT:int = 0;
      
      public static const TYPE_KICK:int = 1;
      
      public static const TYPE_BANK:int = 2;
      
      public static const TYPE_CLUSTER:int = 3;
      
      public static const TYPE_SAFETY:int = 4;
      
      public static const TYPE_COMBO:int = 5;
      
      public static const TYPE_FAILSAFE:int = 6;
      
      public static const POCKET_SIDE:int = 0;
      
      public static const POCKET_CORNER:int = 1;
       
      
      public var objectBall:Ball;
      
      public var targetPos:Vector3D;
      
      public var railTargetPos:Vector3D;
      
      public var pocket:Vector3D;
      
      public var moveScore:Number;
      
      public var shotType:int;
      
      public var cueVelocity:Vector3D;
      
      public var obVector:Vector3D;
      
      public var comboBallOrder:Vector.<Ball>;
      
      public var comboTargetOrder:Vector.<Vector3D>;
      
      public function Move()
      {
         super();
         this.targetPos = new Vector3D();
         this.cueVelocity = new Vector3D();
         this.obVector = new Vector3D();
         this.railTargetPos = new Vector3D();
         this.shotType = TYPE_NONE;
      }
      
      public function reset() : void
      {
         if(this.comboBallOrder)
         {
            this.comboBallOrder.length = 0;
            this.comboBallOrder = null;
         }
         if(this.comboTargetOrder)
         {
            this.comboTargetOrder.length = 0;
            this.comboTargetOrder = null;
         }
      }
      
      public function destroy() : void
      {
         this.reset();
         this.objectBall = null;
         this.targetPos = null;
         this.cueVelocity = null;
         this.obVector = null;
         this.railTargetPos = null;
         this.pocket = null;
      }
   }
}
