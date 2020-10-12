package iilwygames.baloono.commands
{
   public class PickupRemoveCommand extends TileChangeCommand
   {
       
      
      public function PickupRemoveCommand(param1:uint = 0, param2:int = 0, param3:int = 0)
      {
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return "[PickupRemoveCommand]";
      }
   }
}
