package iilwy.ui.utils
{
   public class CapType
   {
      
      public static var TAB:String = "capType_tab";
      
      public static var TAB_LEFT:String = "capType_tabLeft";
      
      public static var TAB_RIGHT:String = "capType_tabRight";
      
      public static var TAB_BOTTOM:String = "capType_tabBottom";
      
      public static var TAB_BOTTOM_LEFT:String = "capType_tabBottomLeft";
      
      public static var TAB_BOTTOM_RIGHT:String = "capType_tabBottomRight";
      
      public static var ROUND:String = "capType_round";
      
      public static var ROUND_RIGHT:String = "capType_roundRight";
      
      public static var ROUND_LEFT:String = "capType_roundLeft";
      
      public static var ROUND_BOTTOM:String = "capType_roundBottom";
      
      public static var ROUND_TOP:String = "capType_roundTop";
      
      public static var ROUND_MINUS_TOP:String = "capType_roundMinusTop";
      
      public static var NONE:String = "capType_none";
       
      
      public function CapType()
      {
         super();
      }
      
      public static function getCornersForType(type:String, radius:Number) : Array
      {
         var cornersLookup:Object = new Object();
         cornersLookup[CapType.NONE] = [0,0,0,0];
         cornersLookup[CapType.ROUND] = [radius,radius,radius,radius];
         cornersLookup[CapType.ROUND_LEFT] = [radius,0,radius,0];
         cornersLookup[CapType.ROUND_RIGHT] = [0,radius,0,radius];
         cornersLookup[CapType.ROUND_BOTTOM] = [0,0,radius,radius];
         cornersLookup[CapType.ROUND_TOP] = [radius,radius,0,0];
         cornersLookup[CapType.TAB] = [radius,radius,0,0];
         cornersLookup[CapType.TAB_LEFT] = [radius,0,0,0];
         cornersLookup[CapType.TAB_RIGHT] = [0,radius,0,0];
         cornersLookup[CapType.TAB_BOTTOM] = [0,0,radius,radius];
         cornersLookup[CapType.TAB_BOTTOM_LEFT] = [0,0,radius,0];
         cornersLookup[CapType.TAB_BOTTOM_RIGHT] = [0,0,0,radius];
         cornersLookup[CapType.ROUND_MINUS_TOP] = [0,radius,radius,radius,radius];
         return cornersLookup[type];
      }
   }
}
