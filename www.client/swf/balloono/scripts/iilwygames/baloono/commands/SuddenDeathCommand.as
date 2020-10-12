package iilwygames.baloono.commands
{
   public class SuddenDeathCommand extends AbstractCommand
   {
       
      
      public var suddenDeathInitTime:uint;
      
      public function SuddenDeathCommand(param1:uint = 0)
      {
         super(param1);
         this.suddenDeathInitTime = 0;
      }
   }
}
