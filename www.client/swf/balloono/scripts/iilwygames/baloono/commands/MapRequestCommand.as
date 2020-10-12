package iilwygames.baloono.commands
{
   import iilwygames.baloono.gameplay.map.MapModel;
   
   public class MapRequestCommand extends AbstractCommand
   {
       
      
      public var mapModel:MapModel;
      
      public function MapRequestCommand(param1:uint = 0, param2:MapModel = null)
      {
         super(param1);
         this.mapModel = param2;
      }
      
      override public function toString() : String
      {
         return "[MapRequestCommand]";
      }
   }
}
