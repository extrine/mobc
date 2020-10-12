package iilwygames.baloono.embedded
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class SpriteSheets_Powerups extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function SpriteSheets_Powerups()
      {
         this.dataClass = SpriteSheets_Powerups_dataClass;
         super();
         initialWidth = 6000 / 20;
         initialHeight = 2000 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}
