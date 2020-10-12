package iilwygames.baloono.commands
{
   public class PlayerMovePlanCommand extends PlayerCommand
   {
       
      
      public var moves:Array;
      
      public function PlayerMovePlanCommand(param1:Array = null)
      {
         var _loc2_:PlayerMoveCommand = null;
         super();
         if(param1 && param1.length > 0)
         {
            _loc2_ = PlayerMoveCommand(param1[0]);
            this.moves = param1;
            this.occurTime = _loc2_.occurTime;
            this.playerId = _loc2_.playerId;
            this.playerJid = _loc2_.playerJid;
         }
      }
      
      public function get empty() : Boolean
      {
         return this.moves == null || this.moves.length < 1;
      }
      
      override public function toString() : String
      {
         return "[PlayerMovePlanCommand]";
      }
      
      public function equals(param1:PlayerMovePlanCommand) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:Boolean = true;
         if(param1.moves.length != this.moves.length)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.moves.length)
         {
            if(PlayerMoveCommand(this.moves[_loc3_]).direction.code != PlayerMoveCommand(param1.moves[_loc3_]).direction.code)
            {
               _loc2_ = false;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
