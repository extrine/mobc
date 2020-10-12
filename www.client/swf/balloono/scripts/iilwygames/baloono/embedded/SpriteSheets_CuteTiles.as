package iilwygames.baloono.embedded
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class SpriteSheets_CuteTiles extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function SpriteSheets_CuteTiles()
      {
         this.dataClass = SpriteSheets_CuteTiles_dataClass;
         super();
         initialWidth = 11000 / 20;
         initialHeight = 8000 / 20;
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
