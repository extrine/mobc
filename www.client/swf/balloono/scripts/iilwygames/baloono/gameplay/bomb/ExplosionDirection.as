package iilwygames.baloono.gameplay.bomb
{
   import iilwygames.baloono.gameplay.Directions;
   
   public class ExplosionDirection
   {
       
      
      public var code:uint;
      
      public function ExplosionDirection(param1:uint = 0)
      {
         super();
         this.code = param1;
      }
      
      public function get isVertical() : Boolean
      {
         return (this.code & Directions.UP) != 0 || (this.code & Directions.DOWN) != 0;
      }
      
      public function get isNull() : Boolean
      {
         return this.code == 0;
      }
      
      public function coverBothDirectionsInAxis() : ExplosionDirection
      {
         if(this.code & Directions.LEFT)
         {
            this.code = this.code | Directions.RIGHT;
         }
         if(this.code & Directions.RIGHT)
         {
            this.code = this.code | Directions.LEFT;
         }
         if(this.code & Directions.UP)
         {
            this.code = this.code | Directions.DOWN;
         }
         if(this.code & Directions.DOWN)
         {
            this.code = this.code | Directions.UP;
         }
         return this;
      }
      
      public function toAssetName() : String
      {
         switch(this.code)
         {
            case 0:
               return null;
            case Directions.LEFT:
               return "left";
            case Directions.RIGHT:
               return "right";
            case Directions.DOWN:
               return "down";
            case Directions.UP:
               return "up";
            case Directions.UP | Directions.DOWN:
               return "vertical";
            case Directions.LEFT | Directions.RIGHT:
               return "horizontal";
            default:
               return "cross";
         }
      }
      
      public function merge(param1:ExplosionDirection) : ExplosionDirection
      {
         this.code = this.code | param1.code;
         return this;
      }
      
      public function clone() : ExplosionDirection
      {
         return new ExplosionDirection(this.code);
      }
      
      public function get isHorizontal() : Boolean
      {
         return (this.code & Directions.LEFT) != 0 || (this.code & Directions.RIGHT) != 0;
      }
   }
}
