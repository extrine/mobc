package iilwygames.pool.model.gameplay
{
   public class TurnConfirmation
   {
       
      
      public var turnNumber:int;
      
      public var teamTurn:int;
      
      public var winnerIndex:int;
      
      public function TurnConfirmation()
      {
         super();
         this.turnNumber = -1;
         this.teamTurn = -1;
         this.winnerIndex = -1;
      }
   }
}
