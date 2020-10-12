package iilwygames.baloono.commands
{
   import iilwygames.baloono.BaloonoGame;
   
   public class KickBombCommand extends AbstractCommand
   {
       
      
      public var dx:int;
      
      public var dy:int;
      
      public var kicked:Boolean;
      
      public var bombID:int;
      
      public function KickBombCommand(param1:int = 0, param2:Boolean = true, param3:int = 0, param4:int = 0)
      {
         super(BaloonoGame.time);
         this.bombID = param1;
         this.kicked = param2;
         this.dx = param3;
         this.dy = param4;
      }
      
      override public function toString() : String
      {
         return "[KickBombCommand]";
      }
   }
}
