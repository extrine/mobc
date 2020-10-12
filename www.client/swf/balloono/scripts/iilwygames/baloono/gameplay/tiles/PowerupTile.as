package iilwygames.baloono.gameplay.tiles
{
   import iilwygames.baloono.gameplay.IAbility;
   import iilwygames.baloono.graphics.GraphicSet;
   
   public class PowerupTile extends AbstractTile
   {
      
      protected static const DEFAULT:String = "default";
       
      
      public var ability:IAbility;
      
      public function PowerupTile(param1:IAbility)
      {
         super();
         this.ability = param1;
      }
      
      override public function setArt(param1:GraphicSet) : void
      {
         if(!param1)
         {
            return;
         }
         super.setArt(param1);
         graphicEntity.playAnimation(DEFAULT);
      }
   }
}
