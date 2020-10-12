package iilwy.display.ad
{
   import flash.utils.Dictionary;
   
   public class AdNetwork
   {
      
      public static var ACUDEO:AdNetwork = new AdNetwork("acudeo");
      
      public static var ADAPTV:AdNetwork = new AdNetwork("adaptv");
      
      public static var ADSENSE_TEXT:AdNetwork = new AdNetwork("adsenseText");
      
      public static var ADSENSE_VIDEO:AdNetwork = new AdNetwork("adsenseVideo");
      
      public static var INTERNAL:AdNetwork = new AdNetwork("internal");
      
      public static var DOUBLE_CLICK:AdNetwork = new AdNetwork("doubleclick");
      
      public static var NONE:AdNetwork = new AdNetwork("none");
      
      public static var VEX:AdNetwork = new AdNetwork("vex");
      
      private static var idDict:Dictionary;
       
      
      public var campaignID:String;
      
      private var _id:String;
      
      public function AdNetwork(id:String)
      {
         super();
         if(!idDict)
         {
            idDict = new Dictionary();
         }
         this._id = id;
         idDict[this._id] = this;
      }
      
      public static function getByID(id:String) : AdNetwork
      {
         return idDict[id];
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}
