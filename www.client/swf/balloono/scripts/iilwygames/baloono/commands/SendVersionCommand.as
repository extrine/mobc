package iilwygames.baloono.commands
{
   public class SendVersionCommand extends AbstractCommand
   {
       
      
      public var version:String;
      
      public function SendVersionCommand(param1:uint = 0)
      {
         super(param1);
      }
      
      override public function toString() : String
      {
         return "[SendVersionCommand]";
      }
   }
}
