package iilwygames.pool.model.gameplay
{
   import flash.geom.Vector3D;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ruleset.Ruleset;
   import iilwygames.pool.network.MessageTypes;
   import iilwygames.pool.network.NetworkMessage;
   import iilwygames.pool.view.TableView;
   
   public class GameSnapshot
   {
       
      
      public var ballPositions:Vector.<Vector3D>;
      
      public var turnIndex:int;
      
      public var teamUp:int;
      
      public var ballInHand:Boolean;
      
      private var maxBalls:int;
      
      public function GameSnapshot()
      {
         super();
         this.ballPositions = new Vector.<Vector3D>();
         this.turnIndex = 0;
         this.teamUp = Ruleset.TEAM_NONE;
         this.maxBalls = TableView.MAX_BALLS;
         for(var i:int = 0; i < this.maxBalls; i++)
         {
            this.ballPositions[i] = new Vector3D();
         }
         this.ballInHand = false;
      }
      
      public function destroy() : void
      {
         this.ballPositions = null;
      }
      
      public function storeSnapshot(ruleset:Ruleset) : void
      {
         var storePos:Vector3D = null;
         var focusBall:Ball = null;
         var numBalls:int = ruleset.balls.length;
         var i:int = 0;
         for(i = 0; i < numBalls; i++)
         {
            storePos = this.ballPositions[i];
            focusBall = ruleset.balls[i];
            storePos.x = focusBall.position.x;
            storePos.y = focusBall.position.y;
            if(focusBall.active)
            {
               storePos.z = 1;
            }
            else
            {
               storePos.z = 0;
            }
         }
         this.ballPositions[i].x = ruleset.cueBall.position.x;
         this.ballPositions[i].y = ruleset.cueBall.position.y;
         this.ballPositions[i].z = 1;
         this.turnIndex = ruleset.turnNumber;
         this.teamUp = ruleset.teamTurn;
         this.ballInHand = ruleset.ballInHand;
      }
      
      public function packageSnapShot() : NetworkMessage
      {
         var i:int = 0;
         var pos:Vector3D = null;
         var msg:NetworkMessage = new NetworkMessage(MessageTypes.MSG_HOST_RESPONSE_GAMESTATE);
         var data:* = new Object();
         var positions:Array = [];
         var numBalls:int = Globals.model.ruleset.balls.length + 1;
         if(Globals.model.ruleset.legalBreak)
         {
            for(i = 0; i < numBalls; i++)
            {
               pos = this.ballPositions[i];
               positions.push(pos.x,pos.y,pos.z);
            }
         }
         data.pos = positions;
         data.ti = this.turnIndex;
         data.tu = this.teamUp;
         data.ih = !!this.ballInHand?1:0;
         msg.data = data;
         return msg;
      }
   }
}
