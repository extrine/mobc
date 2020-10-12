package iilwy.gamenet.model
{
   import iilwy.application.AppComponents;
   
   public class CurrentPlayerData extends PlayerData
   {
       
      
      public var currentServerID:int;
      
      public var currentServerURL:String;
      
      public var currentUsername:String;
      
      public var currentPassword:String;
      
      private var _valid:Boolean = false;
      
      public var hasChosenGuestName:Boolean = false;
      
      public function CurrentPlayerData()
      {
         super();
      }
      
      public function invalidate() : void
      {
         var p:PlayerData = new PlayerData();
         pingTime = undefined;
         this.copy(p);
         this._valid = false;
      }
      
      public function validatePlayerData() : void
      {
         this._valid = true;
      }
      
      public function get valid() : Boolean
      {
         return this._valid;
      }
      
      public function updateInventory() : void
      {
         if(AppComponents.model.privateUser.isLoggedIn)
         {
            activeProducts = AppComponents.model.privateUser.productInventory.clone(true);
         }
      }
      
      public function reset() : void
      {
         medalHistory = "";
         this.updateInventory();
      }
   }
}
