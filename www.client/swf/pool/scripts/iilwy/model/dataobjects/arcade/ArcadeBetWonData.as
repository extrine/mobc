package iilwy.model.dataobjects.arcade
{
   public class ArcadeBetWonData
   {
       
      
      public var winnerProfileName:String;
      
      public var rakedPotTotal:int;
      
      public var wonAmount:int;
      
      public var lostAmount:int;
      
      public function ArcadeBetWonData()
      {
         super();
      }
      
      public static function createFromMerbResult(data:*) : ArcadeBetWonData
      {
         var betWonData:ArcadeBetWonData = new ArcadeBetWonData();
         if(data)
         {
            betWonData.winnerProfileName = data.winner_profile_name;
            betWonData.rakedPotTotal = data.raked_pot_total;
            betWonData.wonAmount = data.won_amount;
            betWonData.lostAmount = data.lost_amount;
         }
         return betWonData;
      }
      
      public function clear() : void
      {
         this.winnerProfileName = null;
         this.rakedPotTotal = 0;
         this.wonAmount = 0;
         this.lostAmount = 0;
      }
   }
}
