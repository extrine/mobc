package iilwy.factories.context
{
   import iilwy.gamenet.model.PlayerData;
   
   public class PlayerContextActionFactory extends AbstractUserContextActionFactory
   {
       
      
      protected var playerData:PlayerData;
      
      public function PlayerContextActionFactory(playerData:PlayerData)
      {
         this.playerData = playerData;
         super(playerData.asProfileData());
      }
   }
}
