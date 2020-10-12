package iilwy.gamenet.developer
{
   public class RoundResults
   {
       
      
      private var _list:Array;
      
      public var ghostData;
      
      public var level:String;
      
      public function RoundResults()
      {
         this._list = [];
         super();
      }
      
      public function addResult(position:int, player:GamenetPlayerData, score1:int = undefined, score2:int = undefined, score3:int = undefined, score4:int = undefined, score5:int = undefined) : void
      {
         this._list.push({
            "position":position,
            "player":player,
            "score1":score1,
            "score2":score2,
            "score3":score3,
            "score4":score4,
            "score5":score5
         });
      }
      
      public function get list() : Array
      {
         return this._list;
      }
   }
}
