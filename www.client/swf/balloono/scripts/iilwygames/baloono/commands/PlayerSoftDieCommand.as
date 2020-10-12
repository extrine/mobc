package iilwygames.baloono.commands
{
   public class PlayerSoftDieCommand extends PlayerCommand
   {
       
      
      public function PlayerSoftDieCommand(param1:uint = 0, param2:int = -1, param3:String = "empty")
      {
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return "[PlayerSoftDieCommand]";
      }
   }
}
