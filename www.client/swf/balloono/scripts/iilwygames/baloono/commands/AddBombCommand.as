package iilwygames.baloono.commands
{
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.gameplay.player.BombAbility;
   
   public class AddBombCommand extends AbstractCommand
   {
       
      
      public var bombAbility:BombAbility;
      
      public var detonateTime:uint;
      
      public var ownerPlayerId:uint;
      
      public var ownerPlayerJid:String;
      
      public var x:int;
      
      public var y:int;
      
      public var id:uint;
      
      public function AddBombCommand(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:String = "empty", param5:BombAbility = null, param6:int = 0, param7:int = 0)
      {
         super(BaloonoGame.time);
         this.id = param1;
         this.detonateTime = param2;
         this.ownerPlayerId = param3;
         this.ownerPlayerJid = param4;
         this.bombAbility = param5;
         this.x = param6;
         this.y = param7;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function toString() : String
      {
         return "[AddBombCommand]";
      }
   }
}
