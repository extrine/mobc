package iilwy.model.dataobjects.user
{
   import iilwy.collections.PagingArrayCollection;
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.ProfileData;
   
   public class QuestionData
   {
       
      
      public var id:int;
      
      public var type:String;
      
      public var profileData:ProfileData;
      
      public var body:String;
      
      public var drawing:DrawingData;
      
      public var numAnswers:int;
      
      public var answers:PagingArrayCollection;
      
      public var timeStamp:Date;
      
      public function QuestionData()
      {
         super();
         this.answers = new PagingArrayCollection();
      }
   }
}
