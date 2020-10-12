package iilwygames.pool.assets
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class EmbeddedResources_animations extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      [Embed(_resolvedSource="/Users/will/Documents/Projects/omgpop/repository/projects/games/Pool/src/iilwygames/pool/assets/art/scratch.swf",mimeType="application/octet-stream")]
      public var dataClass:Class;
      
      public function EmbeddedResources_animations()
      {
         this.dataClass = EmbeddedResources_animations_dataClass;
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
