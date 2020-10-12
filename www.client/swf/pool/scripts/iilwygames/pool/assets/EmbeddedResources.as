package iilwygames.pool.assets
{
   public class EmbeddedResources
   {
       
      
      [Embed(source="art/finalart_pm5.swf")]
      public var art:Class;
      
      [Embed(source="art/scratch.swf")]
      public var animations:Class;
      
      public function EmbeddedResources()
      {
         this.art = EmbeddedResources_art;
         this.animations = EmbeddedResources_animations;
         super();
      }
   }
}
