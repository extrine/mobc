package iilwy.model.dataobjects.quiz
{
   public class QuizQuestion
   {
       
      
      public var id:int;
      
      public var type:String;
      
      public var question:String;
      
      public var possibleAnswers:Array;
      
      public var numAnswers:int;
      
      public var userAnswers:Array;
      
      public var skipped:Boolean;
      
      public function QuizQuestion()
      {
         super();
      }
   }
}
