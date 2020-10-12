package iilwy.model.dataobjects
{
   import flash.events.EventDispatcher;
   
   public class LiveStreamData extends EventDispatcher
   {
       
      
      public var status:Boolean = false;
      
      public var headline:String;
      
      public var description:String;
      
      public var largeStream:String;
      
      public var smallStream:String;
      
      public var streamLocation:String;
      
      public function LiveStreamData()
      {
         super();
      }
   }
}
