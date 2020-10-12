package iilwy.model.dataobjects.user
{
   public class FeedData
   {
       
      
      public var id:Number;
      
      public var subject:String;
      
      public var body:String;
      
      public var primaryImageURL:String;
      
      public var primaryImageData;
      
      public var icon:String;
      
      public var type:String;
      
      public var extraImages:Array;
      
      public var timeStamp:Date;
      
      public function FeedData()
      {
         this.extraImages = [];
         super();
      }
   }
}
