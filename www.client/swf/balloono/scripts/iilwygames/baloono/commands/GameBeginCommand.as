package iilwygames.baloono.commands
{
   public class GameBeginCommand extends AbstractCommand
   {
      
      public static const DELAY:uint = 3999;
       
      
      public function GameBeginCommand(param1:uint = 0)
      {
         super(param1);
      }
      
      override public function toString() : String
      {
         return "[BeginGameCommand]";
      }
   }
}
