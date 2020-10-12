package iilwygames.baloono.commands
{
   import iilwygames.baloono.BaloonoGame;
   
   public class BackToLobbyCommand extends AbstractCommand
   {
      
      protected static const DELAY:uint = 3500;
       
      
      public function BackToLobbyCommand(param1:uint = 0)
      {
         super(param1 == 0?uint(BaloonoGame.time + DELAY):uint(param1));
      }
      
      override public function toString() : String
      {
         return "[BackToLobbyCommand]";
      }
   }
}
