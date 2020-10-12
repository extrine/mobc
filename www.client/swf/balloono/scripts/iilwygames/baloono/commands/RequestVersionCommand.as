package iilwygames.baloono.commands
{
   public class RequestVersionCommand extends AbstractCommand
   {
       
      
      public function RequestVersionCommand(param1:uint = 0)
      {
         super(param1);
      }
      
      override public function toString() : String
      {
         return "[RequestVersionCommand]";
      }
   }
}
