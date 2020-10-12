package iilwy.model.dataobjects.user
{
   import iilwy.managers.GraphicManager;
   
   public class PremiumLevels
   {
      
      public static const GOD:int = 101;
      
      public static const CHARLES:int = 100;
      
      public static const CREW:int = 99;
      
      public static const REAL:int = 20;
      
      public static const GOLD_STAR:int = 15;
      
      public static const STAR:int = 10;
      
      public static const ELITE:int = 5;
      
      public static const LITE:int = 2;
      
      public static const NONE:int = 0;
       
      
      public function PremiumLevels()
      {
         super();
      }
      
      public static function levelToString(level:int) : String
      {
         return level >= GOD?"GOD":level >= CHARLES?"CHARLES":level >= CREW?"CREW":level >= REAL?"REAL":level >= GOLD_STAR?"GOLD STAR":level >= STAR?"STAR":level >= ELITE?"ELITE":level >= LITE?"LITE":"STANDARD";
      }
      
      public static function badgeAssetForLevel(level:int) : Class
      {
         return level >= PremiumLevels.CHARLES?GraphicManager.premiumCharlesBadge:level >= PremiumLevels.CREW?GraphicManager.premiumCrewBadge:level >= PremiumLevels.REAL?GraphicManager.premiumRealBadge:level >= PremiumLevels.GOLD_STAR?GraphicManager.premiumGoldStarBadge:level >= PremiumLevels.STAR?GraphicManager.premiumStarBadge:level >= PremiumLevels.ELITE?GraphicManager.premiumEliteBadge:level >= PremiumLevels.LITE?GraphicManager.premiumLiteBadge:null;
      }
      
      public static function iconAssetForLevel(level:int) : Class
      {
         return level >= PremiumLevels.CHARLES?GraphicManager.premiumCharlesBadge:level >= PremiumLevels.CREW?GraphicManager.premiumCrewBadge:level >= PremiumLevels.REAL?GraphicManager.premiumRealBadge:level >= PremiumLevels.GOLD_STAR?GraphicManager.premiumGoldStarBadge:level >= PremiumLevels.STAR?GraphicManager.premiumStarIcon:level >= PremiumLevels.ELITE?GraphicManager.premiumEliteBadge:level >= PremiumLevels.LITE?GraphicManager.premiumLiteBadge:null;
      }
      
      public static function textIconAssetForLevel(level:int) : Class
      {
         return level >= PremiumLevels.CHARLES?GraphicManager.premiumCharlesBadge:level >= PremiumLevels.CREW?GraphicManager.premiumCrewBadge:level >= PremiumLevels.REAL?GraphicManager.premiumRealBadge:level >= PremiumLevels.GOLD_STAR?GraphicManager.premiumGoldStarBadge:level >= PremiumLevels.STAR?GraphicManager.premiumStarTextIcon:level >= PremiumLevels.ELITE?GraphicManager.premiumEliteBadge:level >= PremiumLevels.LITE?GraphicManager.premiumLiteBadge:null;
      }
   }
}
