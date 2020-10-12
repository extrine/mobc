package iilwygames.pool.model.gameplay
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.model.PlayerCPU;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   
   public class Team
   {
       
      
      public var players:Vector.<Player>;
      
      public var teamBallType:int;
      
      public var teamID:int;
      
      public var consecutiveTurns:int;
      
      private var playerTurn:int;
      
      private var currentPlayer:Player;
      
      public function Team(id:int)
      {
         super();
         this.players = new Vector.<Player>();
         this.playerTurn = 0;
         this.currentPlayer = null;
         this.teamID = id;
         this.teamBallType = 0;
         this.consecutiveTurns = 0;
      }
      
      public function destroy() : void
      {
         this.players.length = 0;
         this.players = null;
         this.currentPlayer = null;
      }
      
      public function addPlayer(player:Player) : void
      {
         this.players.push(player);
         this.currentPlayer = player;
         player.teamID = this.teamID;
      }
      
      public function getCurrentPlayerUp() : Player
      {
         var nextUp:Player = null;
         if(this.players.length)
         {
            nextUp = this.players[this.playerTurn];
         }
         return nextUp;
      }
      
      public function getNextPlayerUp() : Player
      {
         var nextUp:Player = null;
         if(this.players.length)
         {
            nextUp = this.players[this.playerTurn];
            this.playerTurn++;
            this.playerTurn = this.playerTurn % this.players.length;
         }
         return nextUp;
      }
      
      public function update(et:Number) : void
      {
      }
      
      public function subPlayerWithAI(player:Player) : void
      {
         var cue:CueStick = null;
         var subPlayer:PlayerCPU = new PlayerCPU();
         subPlayer.setRngSeed(Globals.netController.randomSeed);
         subPlayer.playerData = player.playerData;
         var index:int = this.players.indexOf(player);
         if(index > -1)
         {
            this.players[index] = subPlayer;
            this.currentPlayer = subPlayer;
            subPlayer.teamID = this.teamID;
         }
         Globals.model.players.push(subPlayer);
         Globals.model.vsCPU = true;
         var rs:Ruleset = Globals.model.ruleset;
         if(player.isMyTurn && rs.playState == Ruleset.PLAYSTATE_SHOOTING)
         {
            cue = Globals.model.ruleset.cueStick;
            cue.startTurnFor(subPlayer);
         }
      }
   }
}
