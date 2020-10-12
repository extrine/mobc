package iilwygames.baloono.commands
{
   public class TileChangeCommand extends AbstractCommand
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public function TileChangeCommand(param1:uint, param2:int, param3:int)
      {
         super(param1);
         this.x = param2;
         this.y = param3;
      }
   }
}
