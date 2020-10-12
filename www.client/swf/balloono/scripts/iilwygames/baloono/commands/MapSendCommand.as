package iilwygames.baloono.commands
{
   import iilwygames.baloono.gameplay.map.MapModel;
   
   public class MapSendCommand extends AbstractCommand
   {
       
      
      public var suddenDeathInitTime:uint;
      
      public var mapNum:int;
      
      public var boxExist:Array;
      
      public var dropBlockCount:int;
      
      public var suddenDeathMode:int;
      
      public var playersDead:Array;
      
      public function MapSendCommand(param1:uint = 0, param2:MapModel = null)
      {
         super(param1);
         if(param2)
         {
            this.boxExist = param2.getExistArray();
         }
         this.playersDead = new Array();
         this.dropBlockCount = 0;
         this.suddenDeathMode = 0;
         this.suddenDeathInitTime = 0;
      }
      
      override public function toString() : String
      {
         return "[MapSendCommand]";
      }
   }
}
