package iilwy.display.thumbnails
{
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.namespaces.omgpop_internal;

   use namespace omgpop_internal;

   public class PlayerThumbnail extends AbstractUserThumbnail
   {


      public var useYouThumbnail:Boolean;

      protected var _playerData:PlayerData;

      public function PlayerThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail")
      {
         super(x,y,size,styleID);
       }

      public function get playerData() : PlayerData
      {
         return this._playerData;
      }

      public function set playerData(value:PlayerData) : void
      {
         this._playerData = value;
         if(this._playerData)
         {
            profileData = this._playerData.asProfileData();
            if(this.useYouThumbnail && this._playerData.isGuest && AppComponents.gamenetManager.currentPlayer.equals(this._playerData))
            {
               url = AppProperties.selfPlayerPhoto;
            }
         }
         else
         {
            profileData = null;
         }
      }

      override protected function onMouseDown(event:MouseEvent) : void
      {
         if(this._playerData && contextMenuEnabled)
         {
            AppComponents.contextMenuManager.showPlayerContextMenu(this._playerData,this,contextMenuAlign);
         }
      }
   }
}
