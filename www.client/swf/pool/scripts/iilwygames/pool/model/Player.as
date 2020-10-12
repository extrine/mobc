package iilwygames.pool.model
{
   import flash.geom.Vector3D;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.network.NetworkMessage;

   public class Player
   {


      public var mousePosition:Vector3D;

      public var playerData:GamenetPlayerData;

      public var teamID:int;

      public var consecutiveFouls:int;

      public var isBreaker:Boolean;

      public var turnTaken:Boolean;

      public var turnFinished:Boolean;

      public var tableRelenquished:Boolean;

      public var fullPowerPlay:Boolean;

      public var maxPowerUsed:Boolean;

      public var winStreak:int;

      public var winsCount:int;

      public var ballsPocketed:int;

      public var winsAsSolids:int;

      public var winsAsStripes:int;

      public var isMyTurn:Boolean;

      public var timeExtenstion:int;

      public function Player()
      {
         super();
         this.mousePosition = new Vector3D();
         this.teamID = Ruleset.TEAM_NONE;
         this.isMyTurn = false;
         this.turnTaken = false;
         this.tableRelenquished = false;
         this.isBreaker = false;
         this.turnFinished = false;
         this.fullPowerPlay = true;
         this.maxPowerUsed = false;
         this.winStreak = 0;
         this.winsCount = 0;
         this.ballsPocketed = 0;
         this.winsAsSolids = 0;
         this.winsAsStripes = 0;
         this.consecutiveFouls = 0;
         this.timeExtenstion = 0;
      }

      public function destroy() : void
      {
         this.mousePosition = null;
         this.playerData = null;
      }

      public function initPowerups() : void
      {
      }

      public function update(et:Number) : void
      {
      }

      public function processNetworkMessage(msg:NetworkMessage) : Boolean
      {
         return true;
      }

      public function startPlayerTurn(isSinglePlayer:Boolean) : void
      {
         this.isMyTurn = true;
         this.turnTaken = true;
         if(Globals.model.ruleset.legalBreak == false)
         {
            this.isBreaker = true;
         }
      }

      public function endPlayerTurn(withHit:Boolean) : void
      {
         this.isMyTurn = false;
         this.turnFinished = true;
      }
   }
}
