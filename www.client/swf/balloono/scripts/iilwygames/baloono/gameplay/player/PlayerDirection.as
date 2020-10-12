package iilwygames.baloono.gameplay.player
{
   import com.partlyhuman.debug.Console;
   import flash.net.registerClassAlias;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.Directions;
   
   public final class PlayerDirection
   {
      
      protected static var REGISTERED = registerClassAlias(TYPE_ALIAS,PlayerDirection);
      
      private static const FACE_LEFT_CODE:int = 17;
      
      private static const GO_RIGHT_CODE:int = 2;
      
      private static const FACE_DOWN_CODE:int = 24;
      
      public static const FACE_DOWN:PlayerDirection = new PlayerDirection(FACE_DOWN_CODE);
      
      public static const GO_UP:PlayerDirection = new PlayerDirection(GO_UP_CODE);
      
      private static const GO_DOWN_CODE:int = 8;
      
      private static const GO_LEFT_CODE:int = 1;
      
      public static const GO_DOWN:PlayerDirection = new PlayerDirection(GO_DOWN_CODE);
      
      public static const FACE_RIGHT:PlayerDirection = new PlayerDirection(FACE_RIGHT_CODE);
      
      public static const GO_RIGHT:PlayerDirection = new PlayerDirection(GO_RIGHT_CODE);
      
      public static const FACE_LEFT:PlayerDirection = new PlayerDirection(FACE_LEFT_CODE);
      
      protected static const TYPE_ALIAS:String = "iilwygames.baloono.gameplay.player.PlayerDirection";
      
      private static const FACE_UP_CODE:int = 20;
      
      private static const FACE_RIGHT_CODE:int = 18;
      
      private static const GO_UP_CODE:int = 4;
      
      public static const FACE_UP:PlayerDirection = new PlayerDirection(FACE_UP_CODE);
      
      public static const GO_LEFT:PlayerDirection = new PlayerDirection(GO_LEFT_CODE);
       
      
      public var code:uint;
      
      public function PlayerDirection(param1:uint = 0)
      {
         super();
         this.code = param1;
      }
      
      public static function fromVector(param1:Number, param2:Number) : PlayerDirection
      {
         if(param1 < 0)
         {
            return GO_LEFT;
         }
         if(param1 > 0)
         {
            return GO_RIGHT;
         }
         if(param2 > 0)
         {
            return GO_DOWN;
         }
         if(param2 < 0)
         {
            return GO_UP;
         }
         return FACE_DOWN;
      }
      
      public function toAssetName() : String
      {
         switch(this.code)
         {
            case GO_LEFT_CODE:
               return "goleft";
            case GO_RIGHT_CODE:
               return "goright";
            case GO_UP_CODE:
               return "goup";
            case GO_DOWN_CODE:
               return "godown";
            case FACE_LEFT_CODE:
               return "faceleft";
            case FACE_RIGHT_CODE:
               return "faceright";
            case FACE_UP_CODE:
               return "faceup";
            case FACE_DOWN_CODE:
               return "facedown";
            default:
               return null;
         }
      }
      
      public function toOpposite() : PlayerDirection
      {
         switch(this.code)
         {
            case GO_LEFT_CODE:
               return GO_RIGHT;
            case GO_RIGHT_CODE:
               return GO_LEFT;
            case GO_UP_CODE:
               return GO_DOWN;
            case GO_DOWN_CODE:
               return GO_UP;
            case FACE_LEFT_CODE:
               return FACE_RIGHT;
            case FACE_RIGHT_CODE:
               return FACE_LEFT;
            case FACE_UP_CODE:
               return FACE_DOWN;
            case FACE_DOWN_CODE:
               return FACE_UP;
            default:
               return null;
         }
      }
      
      public function get dx() : int
      {
         return this.code == Directions.LEFT?-1:this.code == Directions.RIGHT?1:0;
      }
      
      public function get dy() : int
      {
         return this.code == Directions.UP?-1:this.code == Directions.DOWN?1:0;
      }
      
      public function toStoppedVersion() : PlayerDirection
      {
         switch(this.code)
         {
            case GO_LEFT_CODE:
               return FACE_LEFT;
            case GO_RIGHT_CODE:
               return FACE_RIGHT;
            case GO_UP_CODE:
               return FACE_UP;
            case GO_DOWN_CODE:
               return FACE_DOWN;
            default:
               if(BaloonoGame.instance.DEBUG_LOGGING)
               {
                  Console.warn("You asked for a stopped version of a stopped direction...");
               }
               return this;
         }
      }
      
      public function get isMoving() : Boolean
      {
         return (this.code & 16) == 0;
      }
      
      public function toString() : String
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            switch(this.code)
            {
               case GO_LEFT_CODE:
                  return "go left";
               case GO_RIGHT_CODE:
                  return "go right";
               case GO_UP_CODE:
                  return "go up";
               case GO_DOWN_CODE:
                  return "go down";
               case FACE_LEFT_CODE:
                  return "face left";
               case FACE_RIGHT_CODE:
                  return "face right";
               case FACE_UP_CODE:
                  return "face up";
               case FACE_DOWN_CODE:
                  return "face down";
            }
         }
         return "";
      }
      
      public function getFacingDirection() : PlayerDirection
      {
         switch(this.code)
         {
            case FACE_LEFT_CODE:
               return GO_LEFT;
            case FACE_RIGHT_CODE:
               return GO_RIGHT;
            case FACE_UP_CODE:
               return GO_UP;
            case FACE_DOWN_CODE:
               return GO_DOWN;
            default:
               return this;
         }
      }
      
      public function equals(param1:PlayerDirection) : Boolean
      {
         return this.code == param1.code;
      }
   }
}
