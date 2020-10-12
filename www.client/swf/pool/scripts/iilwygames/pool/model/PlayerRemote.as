package iilwygames.pool.model
{
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.input.InputData;
   import iilwygames.pool.model.gameplay.CueStick;
   import iilwygames.pool.network.MessageTypes;
   import iilwygames.pool.network.NetworkMessage;

   public class PlayerRemote extends Player
   {


      protected var desiredBoardMouseX:Number;

      protected var desiredBoardMouseY:Number;

      protected var initialUpdateRecieved:Boolean;

      private var inputDataQueue:Vector.<InputData>;

      private var lastMsgIndex:Number;

      public function PlayerRemote()
      {
         super();
         mousePosition.x = 0;
         mousePosition.y = 0;
         this.desiredBoardMouseX = 0;
         this.desiredBoardMouseY = 0;
         this.inputDataQueue = new Vector.<InputData>();
         this.lastMsgIndex = 0;
      }

      override public function destroy() : void
      {
         this.inputDataQueue.length = 0;
         this.inputDataQueue = null;
         super.destroy();
      }

      override public function update(et:Number) : void
      {
         var id:InputData = null;
         var cs:CueStick = null;
         mousePosition.x = mousePosition.x + (this.desiredBoardMouseX - mousePosition.x) * et * 5;
         mousePosition.y = mousePosition.y + (this.desiredBoardMouseY - mousePosition.y) * et * 5;
         if(isMyTurn)
         {
            if(this.inputDataQueue.length)
            {
               id = this.inputDataQueue[0];
               cs = Globals.model.ruleset.cueStick;
               if(cs.processInputData(id))
               {
                  this.inputDataQueue.shift();
                  Globals.model.ruleset.insertInputData(id);
               }
            }
         }
      }

      override public function processNetworkMessage(msg:NetworkMessage) : Boolean
      {
         var mouseDownData:InputData = null;
         var mouseUpData:InputData = null;
         if(msg.mi <= this.lastMsgIndex)
         {
            return true;
         }
         this.lastMsgIndex = msg.mi;
         if(msg.msgID == MessageTypes.MSG_MOUSE_UPDATE)
         {
            this.desiredBoardMouseX = msg.data.x;
            this.desiredBoardMouseY = msg.data.y;
            if(this.initialUpdateRecieved == false)
            {
               this.initialUpdateRecieved = true;
               mousePosition.x = this.desiredBoardMouseX;
               mousePosition.y = this.desiredBoardMouseY;
            }
         }
         else if(msg.msgID == MessageTypes.MSG_MOUSE_DOWN)
         {
            if(Globals.model.ruleset.turnNumber <= msg.data.ti)
            {
               mouseDownData = new InputData(InputData.ID_MOUSE_DOWN);
               mouseDownData.mouseX = msg.data.x / 10000;
               mouseDownData.mouseY = msg.data.y / 10000;
               mouseDownData.cueX = 0;
               mouseDownData.cueY = 0;
               mouseDownData.turnIndex = msg.data.ti;
               this.inputDataQueue.push(mouseDownData);
            }
         }
         else if(msg.msgID == MessageTypes.MSG_MOUSE_UP)
         {
            if(Globals.model.ruleset.turnNumber <= msg.data.ti)
            {
               mouseUpData = new InputData(InputData.ID_MOUSE_UP);
               mouseUpData.mouseX = msg.data.x / 10000;
               mouseUpData.mouseY = msg.data.y / 10000;
               mouseUpData.cueX = msg.data.cx / 10000;
               mouseUpData.cueY = msg.data.cy / 10000;
               mouseUpData.turnIndex = msg.data.ti;
               this.inputDataQueue.push(mouseUpData);
            }
         }
         else if(msg.msgID == MessageTypes.MSG_FORFEIT_TURN)
         {
            this.inputDataQueue.length = 0;
            trace("length of input queue is:  " + this.inputDataQueue.length.toString());
            Globals.model.ruleset.cueStick.forfeitTurn();
         }
         return true;
      }

      public function addToInputQueue(id:InputData) : void
      {
         var inputs:InputData = null;
         for each(inputs in Globals.model.ruleset.inputHistory)
         {
            if(id.inputIndex == inputs.inputIndex)
            {
               return;
            }
         }
         this.inputDataQueue.push(id);
         this.inputDataQueue.sort(this.sortInput);
      }

      private function sortInput(a:InputData, b:InputData) : Number
      {
         return a.inputIndex - b.inputIndex;
      }
   }
}
