package iilwygames.baloono.commands
{
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.RoundResults;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.player.Player;
   import iilwygames.baloono.gameplay.player.PlayerManager;
   
   public class GameOverCommand extends AbstractCommand
   {
       
      
      public var orderedPlayerIds:Array;
      
      public function GameOverCommand(param1:uint = 0, param2:Array = null)
      {
         super(param1);
         this.orderedPlayerIds = param2;
      }
      
      override public function toString() : String
      {
         return "[GameOverCommand]";
      }
      
      public function getRoundResults() : RoundResults
      {
         var _loc5_:Player = null;
         var _loc6_:GamenetPlayerData = null;
         var _loc1_:PlayerManager = BaloonoGame.instance.playerManager;
         var _loc2_:RoundResults = new RoundResults();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this.orderedPlayerIds.length)
         {
            _loc5_ = _loc1_.getPlayerByIndex(this.orderedPlayerIds[_loc4_]);
            if(_loc5_)
            {
               _loc6_ = _loc5_.iilwyPlayerData;
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_.addResult(_loc4_ + 1,_loc3_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
   }
}
