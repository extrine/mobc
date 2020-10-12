package iilwygames.baloono.commands
{
   public class PlayerCommand extends AbstractCommand
   {
       
      
      public var playerJid:String;
      
      public var playerId:int;
      
      public function PlayerCommand(param1:uint = 0, param2:int = -1, param3:String = "empty")
      {
         super(param1);
         this.playerId = param2;
         this.playerJid = param3;
      }
   }
}
