package iilwy.model.dataobjects.user
{
   import iilwy.model.dataobjects.DrawingData;
   import iilwy.model.dataobjects.ProfileData;
   
   public class AnswerData
   {
       
      
      public var id:int;
      
      public var questionID:int;
      
      public var profileData:ProfileData;
      
      public var body:String;
      
      public var drawing:DrawingData;
      
      public var timeStamp:Date;
      
      public function AnswerData()
      {
         super();
      }
   }
}
