package iilwygames.baloono.graphics
{
   import flash.events.Event;
   
   public class AssetEvent extends Event
   {
      
      public static const SEQUENCE_COMPLETE:String = "sequenceComplete";
       
      
      public var asset:GraphicAsset;
      
      public function AssetEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
