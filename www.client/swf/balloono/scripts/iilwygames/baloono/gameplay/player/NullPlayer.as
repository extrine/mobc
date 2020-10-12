package iilwygames.baloono.gameplay.player
{
   import com.partlyhuman.debug.Console;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.commands.AbstractCommand;
   
   public class NullPlayer extends Player
   {
      
      public static const NULL_PLAYER:NullPlayer = new NullPlayer();
       
      
      public function NullPlayer()
      {
         super(-1,null);
      }
      
      override protected function initialize() : void
      {
      }
      
      override public function respondToCommand(param1:AbstractCommand) : Boolean
      {
         if(BaloonoGame.instance.DEBUG_LOGGING)
         {
            Console.error("Command sent to null player.");
            Console.dumpStackTrace();
         }
         return true;
      }
   }
}
