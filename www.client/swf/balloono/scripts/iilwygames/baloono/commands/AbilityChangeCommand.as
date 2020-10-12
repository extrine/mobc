package iilwygames.baloono.commands
{
   import iilwygames.baloono.gameplay.player.BombAbility;
   import iilwygames.baloono.gameplay.player.KickAbility;
   import iilwygames.baloono.gameplay.player.MovementAbility;
   
   public class AbilityChangeCommand extends PlayerCommand
   {
       
      
      public var kickAbility:KickAbility;
      
      public var bombAbility:BombAbility;
      
      public var movementAbility:MovementAbility;
      
      public function AbilityChangeCommand(param1:uint = 0, param2:int = 0, param3:String = "empty", param4:BombAbility = null, param5:MovementAbility = null, param6:KickAbility = null)
      {
         super(param1,param2,param3);
         this.bombAbility = param4;
         this.movementAbility = param5;
         this.kickAbility = param6;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.movementAbility = null;
         this.bombAbility = null;
         this.kickAbility = null;
      }
      
      override public function toString() : String
      {
         return "[AbilityChangeCommand]";
      }
   }
}
