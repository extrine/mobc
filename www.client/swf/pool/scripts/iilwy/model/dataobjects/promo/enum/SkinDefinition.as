package iilwy.model.dataobjects.promo.enum
{
   public class SkinDefinition
   {
       
      
      public var campaignId:String;
      
      public var statusWhiteList:Array;
      
      public var gameWhiteList:Array;
      
      public var scale9:Scale9Definition;
      
      public var trackingPixel:String;
      
      public function SkinDefinition(campaignId:String, scale9:Scale9Definition = null, gameWhiteList:Array = null, statusWhiteList:Array = null, trackingPixel:String = null)
      {
         super();
         this.campaignId = campaignId;
         this.gameWhiteList = gameWhiteList;
         this.statusWhiteList = statusWhiteList;
         this.scale9 = scale9;
         this.trackingPixel = trackingPixel;
      }
      
      public function toString() : String
      {
         var str:String = "";
         if(this.scale9)
         {
            str = str + this.scale9.toString();
         }
         if(this.gameWhiteList)
         {
            str = str + this.gameWhiteList.toString();
         }
         if(this.statusWhiteList)
         {
            str = str + this.statusWhiteList.toString();
         }
         if(this.trackingPixel)
         {
            str = str + this.trackingPixel.toString();
         }
         return str;
      }
   }
}
