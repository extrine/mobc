package iilwy.utils
{
   import flash.display.Stage;
   
   public final class StageReference
   {
      
      private static var instance:StageReference = new StageReference();
       
      
      private var _stageReference:Stage;
      
      public function StageReference()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         instance._stageReference = stage;
      }
      
      public static function getInstance() : StageReference
      {
         return instance;
      }
      
      public static function get stage() : Stage
      {
         return instance._stageReference;
      }
   }
}
