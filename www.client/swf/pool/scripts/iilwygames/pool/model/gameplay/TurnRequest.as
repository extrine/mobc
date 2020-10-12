package iilwygames.pool.model.gameplay
{
   public class TurnRequest
   {
       
      
      public var turnNumber:int;
      
      public var teamTurn:int;
      
      public var winnerIndex:int;
      
      public var cueX:Number;
      
      public var cueY:Number;
      
      public function TurnRequest()
      {
         super();
         this.turnNumber = -1;
         this.teamTurn = -1;
         this.winnerIndex = -1;
         this.cueX = 0;
         this.cueY = 0;
      }
   }
}
