package iilwygames.pool.network
{
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwygames.pool.core.Globals;
   import flash.external.ExternalInterface;

   public class GamenetMediator
   {


      private var _controller:GamenetController;

      private var _msgQueue:Vector.<NetworkMessage>;

      private var msgIndex:Number;
       public var LAST_MOUSE_ID:String;
      public function GamenetMediator()
      {
         super();
         this._msgQueue = new Vector.<NetworkMessage>();
         ExternalInterface.addCallback("pnmJS",this.onGameAction);
         ExternalInterface.addCallback("uL",this.onPlayerLeave);

      }

      public function destroy() : void
      {
         this.deactivate();
         this._msgQueue = null;
      }

      public function activate(controller:GamenetController) : void
      {
         this.deactivate();
         this._controller = controller;
         this._controller.addEventListener(GamenetEvent.GAME_ACTION,this.onGameAction,false,0,true);
         this._controller.addEventListener(GamenetEvent.PLAYER_LEFT,this.onPlayerLeave,false,0,true);
         this._controller.addEventListener(GamenetEvent.HOST_CHANGED,this.onHostChanged,false,0,true);
         this._msgQueue.length = 0;
         this.msgIndex = 0;
      }

      public function deactivate() : void
      {
         if(this._controller)
         {
            this._controller.removeEventListener(GamenetEvent.GAME_ACTION,this.onGameAction);
            this._controller.removeEventListener(GamenetEvent.PLAYER_LEFT,this.onPlayerLeave);
            this._controller.removeEventListener(GamenetEvent.HOST_CHANGED,this.onHostChanged);
         }
         this._controller = null;
         this._msgQueue.length = 0;
         this.msgIndex = 0;
      }

      protected function onPlayerLeave(event:*) : void
      {
         Globals.model.handlePlayerLeave(event.u);
      }

      protected function onHostChanged(event:GamenetEvent) : void
      {
         trace("hi");
         Globals.model.handleHostChange();
      }

      protected function onGameAction(event:*) : void
      {
         var msg:NetworkMessage = new NetworkMessage(event.id);
         msg.data = event.d;
         msg.mi = event.mi;
         msg.fromPlayerJID = event.sender;
         this._msgQueue.push(msg);

      }

      public function update(et:Number) : void
      {
         var msg:NetworkMessage = null;
         var i:int = 0;
         while(i < this._msgQueue.length)
         {
            msg = this._msgQueue[i];
            if(Globals.model.processNetworkMessage(msg))
            {
               this._msgQueue.splice(i,1);
            }
            else
            {
               msg.timeout = msg.timeout - et;
               if(msg.timeout <= 0)
               {
                  this._msgQueue.splice(i,1);
               }
               else
               {
                  i++;
               }
            }
         }
      }

      public function sendNetworkMessage(msg:NetworkMessage, toPlayerJid:String = null, encrypted:Boolean = true) : void
      {

         if(msg.msgID === 1)
         {
            msg.data.x = String(msg.data.x).substr(0,4)
            msg.data.y = String(msg.data.y).substr(0,4)
            var LAST_MOUSE_ID  = String(Math.abs(msg.data.x)).substr(0,3)+'x'+String(Math.abs(msg.data.y)).substr(0,3);
         }


         if(!(msg.msgID === 1 && this.LAST_MOUSE_ID === LAST_MOUSE_ID)){


            if(msg.msgID === 1)
            {
               this.LAST_MOUSE_ID = LAST_MOUSE_ID
            }


            this.msgIndex = this.msgIndex + 1;
            msg.mi = this.msgIndex;
            var data:* = {
               "id":msg.msgID,
               "d":msg.data,
               "mi":this.msgIndex
            };

             ExternalInterface.call("emit",{
               "id":"pool",
               "f":"snm",
               "d":data,
               "to":toPlayerJid
            });
         }

         /*
         if(encrypted)
         {
            this._controller.sendGameActionEncrypted(data,toPlayerJid);
         }
         else
         {
            this._controller.sendGameAction(data,toPlayerJid);
         }
         */
      }
   }
}
