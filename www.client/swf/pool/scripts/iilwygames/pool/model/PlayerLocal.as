package iilwygames.pool.model
{
   import flash.events.MouseEvent;
   import iilwy.gamenet.developer.GamenetController;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.gameplay.CueStick;
   import iilwygames.pool.network.MessageTypes;
   import iilwygames.pool.network.NetworkMessage;
   
   public class PlayerLocal extends Player
   {
       
      
      public var moveStartSyncTime:Number;
      
      public var timeToMove:Number = 30000;
      
      public var consecutiveForfeits:int;
      
      private var _mouseUpdateTimer:Number;
      
      private const MOUSE_UPDATE_INTERVAL:Number = 0.25;
      
      public var useTimer:Boolean = true;
      
      private var currSoundCount:int;
      
      public function PlayerLocal()
      {
         super();
         Globals.view.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Globals.view.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._mouseUpdateTimer = 0;
         this.moveStartSyncTime = Number.MAX_VALUE;
         this.consecutiveForfeits = 0;
         this.currSoundCount = -1;
         this.timeToMove = 30000;
         this.useTimer = true;
      }
      
      override public function destroy() : void
      {
         Globals.view.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Globals.view.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         super.destroy();
      }
      
      public function initNumberStore(gnc:GamenetController) : void
      {
         if(gnc.genericNumberStore)
         {
            winStreak = gnc.genericNumberStore["win_streak"];
            winsCount = gnc.genericNumberStore["total_wins"];
            ballsPocketed = gnc.genericNumberStore["total_pocketed"];
            winsAsSolids = gnc.genericNumberStore["solid_wins"];
            winsAsStripes = gnc.genericNumberStore["stripe_wins"];
         }
      }
      
      override public function initPowerups() : void
      {
      }
      
      override public function update(et:Number) : void
      {
         var currentTime:Number = NaN;
         var forfeitTurn:NetworkMessage = null;
         var diff:Number = NaN;
         var mouseupdate:NetworkMessage = null;
         if(Globals.view.hasMouseFocus && !Globals.movieClipPlayer.mouseTakeover)
         {
            mousePosition.x = Globals.model.world.screenToWorldLength(Globals.view.table.mouseX);
            mousePosition.y = Globals.model.world.screenToWorldLength(Globals.view.table.mouseY);
         }
         if(isMyTurn)
         {
            currentTime = Globals.netController.syncedTime;
            if(currentTime - this.moveStartSyncTime > this.timeToMove + timeExtenstion)
            {
               Globals.soundManager.playSound("error");
               forfeitTurn = new NetworkMessage(MessageTypes.MSG_FORFEIT_TURN);
               Globals.netMediator.sendNetworkMessage(forfeitTurn);
               Globals.model.ruleset.cueStick.forfeitTurn();
            }
            else
            {
               diff = 0.001 * (Globals.netController.syncedTime - this.moveStartSyncTime);
               diff = Math.floor(diff);
               if(diff >= 20 && diff % 5 == 0 && this.currSoundCount != diff)
               {
                  this.currSoundCount = diff;
                  Globals.soundManager.playSound("tick");
               }
            }
            if(Globals.view.hasMouseFocus)
            {
               this._mouseUpdateTimer = this._mouseUpdateTimer + et;
               if(this._mouseUpdateTimer > this.MOUSE_UPDATE_INTERVAL)
               {
                  this._mouseUpdateTimer = 0;
                  if(Globals.view.hasMouseFocus && Globals.model.ruleset.teamTurn == teamID)
                  {
                     mouseupdate = new NetworkMessage(MessageTypes.MSG_MOUSE_UPDATE);
                     mouseupdate.data = {
                        "x":mousePosition.x,
                        "y":mousePosition.y
                     };
                     Globals.netMediator.sendNetworkMessage(mouseupdate);
                  }
               }
            }
         }
      }
      
      private function onMouseDown(me:MouseEvent) : void
      {
         var idata:InputData = null;
         var invalidMouseDown:Boolean = Globals.view.isMouseOverBottom() || Globals.movieClipPlayer.mouseTakeover;
         if(invalidMouseDown)
         {
            return;
         }
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         var singlePlayer:Boolean = Globals.model.ruleset.singlePlayer;
         if(isMyTurn && Globals.view.hasMouseFocus)
         {
            idata = new InputData(InputData.ID_MOUSE_DOWN);
            idata.turnIndex = Globals.model.ruleset.turnNumber;
            idata.isShiftDown = me.shiftKey;
            idata.mouseX = Globals.model.world.screenToWorldLength(Globals.view.table.mouseX);
            idata.mouseY = Globals.model.world.screenToWorldLength(Globals.view.table.mouseY);
            Globals.model.ruleset.processUserInput(idata);
         }
      }
      
      private function onMouseUp(me:MouseEvent) : void
      {
         var idata:InputData = null;
         var singlePlayer:Boolean = Globals.model.ruleset.singlePlayer;
         var cueStick:CueStick = Globals.model.ruleset.cueStick;
         if(isMyTurn && Globals.view.hasMouseFocus)
         {
            idata = new InputData(InputData.ID_MOUSE_UP);
            idata.turnIndex = Globals.model.ruleset.turnNumber;
            idata.mouseX = Globals.model.world.screenToWorldLength(Globals.view.table.mouseX);
            idata.mouseY = Globals.model.world.screenToWorldLength(Globals.view.table.mouseY);
            idata.cueX = cueStick.cueDotControl.x;
            idata.cueY = cueStick.cueDotControl.y;
            Globals.model.ruleset.processUserInput(idata);
         }
      }
      
      override public function startPlayerTurn(isSinglePlayer:Boolean) : void
      {
         isMyTurn = true;
         if(this.useTimer && !isSinglePlayer)
         {
            this.moveStartSyncTime = Globals.netController.syncedTime;
            Globals.view.startClock((this.timeToMove + timeExtenstion) * 0.001);
            this.currSoundCount = -1;
         }
         super.startPlayerTurn(isSinglePlayer);
      }
      
      override public function endPlayerTurn(withHit:Boolean) : void
      {
         isMyTurn = false;
         this.moveStartSyncTime = Number.MAX_VALUE;
         if(withHit)
         {
            this.consecutiveForfeits = 0;
         }
         else
         {
            this.consecutiveForfeits++;
         }
         if(this.consecutiveForfeits == 2)
         {
            Globals.model.quitgameNextUpdate = true;
         }
         Globals.view.stopClock();
         super.endPlayerTurn(withHit);
      }
   }
}
