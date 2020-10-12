package iilwy.display.ad
{
   public class AdPatternFactory
   {
       
      
      public function AdPatternFactory()
      {
         super();
      }
      
      public static function createFromApiResult(pattern:*) : Array
      {
         var network:Object = null;
         var adNetwork:AdNetwork = null;
         var result:Array = [];
         for each(network in pattern)
         {
            if(network.network_id)
            {
               adNetwork = AdNetwork.getByID(network.network_id);
               if(adNetwork)
               {
                  adNetwork.campaignID = network.campaign_id;
                  result.push(adNetwork);
               }
            }
         }
         return result;
      }
   }
}
