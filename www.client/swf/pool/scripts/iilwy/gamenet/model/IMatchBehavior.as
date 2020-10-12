package iilwy.gamenet.model
{
   import iilwy.gamenet.developer.RoundResults;
   
   public interface IMatchBehavior
   {
       
      
      function attach(match:MatchData) : void;
      
      function detach() : void;
      
      function recordRound(results:RoundResults) : void;
      
      function join(matchName:String, config:MatchListingData) : void;
      
      function registerInGameEvents() : void;
   }
}
