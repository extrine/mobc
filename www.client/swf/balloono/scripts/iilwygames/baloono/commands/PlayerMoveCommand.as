package iilwygames.baloono.commands
{
   import iilwygames.baloono.gameplay.player.PlayerDirection;
   
   public class PlayerMoveCommand extends PlayerCommand
   {
       
      
      public var occurX:Number;
      
      public var occurY:Number;
      
      public var direction:PlayerDirection;
      
      public function PlayerMoveCommand(param1:uint = 0, param2:int = 0, param3:String = "empty", param4:PlayerDirection = null, param5:Number = 0, param6:Number = 0)
      {
         super(param1,param2,param3);
         this.direction = param4;
         this.occurX = param5;
         this.occurY = param6;
      }
      
      override public function toString() : String
      {
         return "[PlayerMoveCommand]";
      }
   }
}
