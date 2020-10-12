package iilwy.display.arcade
{
   import iilwy.display.thumbnails.PlayerThumbnail;
   import iilwy.gamenet.model.PlayerData;
   
   public class ArcadePlayerThumbnail extends PlayerThumbnail
   {
       
      
      public function ArcadePlayerThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail")
      {
         super(x,y,size,styleID);
      }
      
      public function get player() : PlayerData
      {
         return playerData;
      }
      
      public function set player(value:PlayerData) : void
      {
         playerData = value;
      }
   }
}
