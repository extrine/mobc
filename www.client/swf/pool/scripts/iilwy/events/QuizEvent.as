package iilwy.events
{
   import flash.events.Event;
   import iilwy.model.dataobjects.quiz.QuizQuestion;
   
   public class QuizEvent extends PaginationDataResponderEvent
   {
      
      public static const GET_QUESTION:String = "iilwy.events.QuizEvent.GET_QUESTION";
      
      public static const RECORD_ANSWER:String = "iilwy.events.QuizEvent.RECORD_ANSWER";
      
      public static const GET_QUESTION_INDEX:String = "iilwy.events.QuizEvent.GET_QUESTION_INDEX";
       
      
      public var question:QuizQuestion;
      
      public var questionID:int = -1;
      
      public var questionType:String;
      
      public var indexType:String;
      
      public function QuizEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         super(type,bubbles,cancelable,data);
      }
      
      override public function clone() : Event
      {
         var quizEvent:QuizEvent = new QuizEvent(type,bubbles,cancelable,data);
         quizEvent.responder = responder;
         quizEvent.direction = direction;
         quizEvent.page = page;
         quizEvent.offset = offset;
         quizEvent.limit = limit;
         quizEvent.forceRefresh = forceRefresh;
         quizEvent.question = this.question;
         quizEvent.questionID = this.questionID;
         quizEvent.questionType = this.questionType;
         quizEvent.indexType = this.indexType;
         return quizEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("QuizEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
