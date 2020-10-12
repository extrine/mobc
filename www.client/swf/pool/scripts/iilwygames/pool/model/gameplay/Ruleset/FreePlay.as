package iilwygames.pool.model.gameplay.Ruleset
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ball;
   import flash.external.ExternalInterface;

   public class FreePlay extends Eightball
   {


      public function FreePlay(rngSeed:uint = 0, teamCount:int = 1)
      {
         super(rngSeed,teamCount);
         gameType = GAMETYPE_FREEPLAY;
      }

      override protected function evaluateTeamUp() : void
      {
         var focusBall:Ball = null;
         var i:int = 0;
         legalBreak = true;
         var numberOfBallsSank:int = ballsSankThisTurn.length;
         ballInHand = false;
         if(numberOfBallsSank > 0)
         {
            for(i = 0; i < numberOfBallsSank; i++)
            {
               focusBall = ballsSankThisTurn[i] as Ball;
               if(focusBall.ballType == Ball.BALL_CUE)
               {
                  ballInHand = true;
                  return;
               }
            }
         }
      }

      override protected function evaluateGame() : int
      {
         var b:Ball = null;
         var len:int = balls.length;
         var ballsActive:Boolean = false;
         for(var i:int = 0; i < len; i++)
         {
            b = balls[i];
            if(b.active)
            {
               ballsActive = true;
               break;
            }
         }
         if(ballsActive)
         {
            return TEAM_NONE;
         }
         return teamTurn;
      }

      override public function endGamePlay(timerOverride:Number = 4.0) : void
      {
         /*super.endGamePlay(timerOverride);
         var gameplaytime:Number = gameEndTime - gameStartTime;
         var mins:int = int(gameplaytime / (1000 * 60));
         var seconds:int = int(gameplaytime / 1000 - mins * 60);
         var stringSeconds:String = seconds < 10?"0" + String(seconds):String(seconds);
   */
         ExternalInterface.call("u.log","completed!")
         ExternalInterface.call("emit",{
               "id":"pool",
               "f":"chat2",
               "d":{'completed':name, 'game':'pool', 'v':mins.toString() + ":" + stringSeconds}
            });
         //Globals.netController.selfNotification("You completed the rack in " + mins.toString() + ":" + stringSeconds);
      }
   }
}
