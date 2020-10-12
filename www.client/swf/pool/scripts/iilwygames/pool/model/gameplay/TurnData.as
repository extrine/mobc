package iilwygames.pool.model.gameplay
{
   public class TurnData
   {
      
      public static const RESULT_SUCCESS:uint = 0;
      
      public static const RESULT_NO_POCKET:uint = 1;
      
      public static const RESULT_FOUL:uint = 2;
      
      public static const RESULT_WINNER:uint = 3;
       
      
      public var playerID:String;
      
      public var ballType:int;
      
      public var ballsPocketed:Array;
      
      public var turnResult:uint;
      
      public var turnIndex:int;
      
      public var isBreak:Boolean;
      
      public function TurnData()
      {
         super();
         this.ballsPocketed = [];
      }
      
      public function destroy() : void
      {
         this.ballsPocketed = null;
      }
   }
}
