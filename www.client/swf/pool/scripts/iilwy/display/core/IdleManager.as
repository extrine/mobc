package iilwy.display.core
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.delegates.arcade.PlayerDelegate;
   import iilwy.events.ArcadeEvent;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.utils.StageReference;
   import iilwy.utils.TextUtil;
   import iilwy.utils.logging.Logger;
   
   public class IdleManager
   {
       
      
      protected var idleTimer:Timer;
      
      protected var idleTimestamp:Number = 0;
      
      protected var lastInteractionTimestamp:Number = 0;
      
      protected var sendStatusTimer:Timer;
      
      protected var resendTimer:Timer;
      
      protected var logger:Logger;
      
      protected var _isIdle:Boolean;
      
      public function IdleManager()
      {
         super();
         this.logger = Logger.getLogger(this);
         StageReference.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         StageReference.stage.addEventListener(MouseEvent.CLICK,this.onClick);
         this.idleTimer = new Timer(5 * 60 * 1000,0);
         this.idleTimer.addEventListener(TimerEvent.TIMER,this.onIdleTimer);
         this.sendStatusTimer = new Timer(3000,1);
         this.sendStatusTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSendStatus);
         this.resendTimer = new Timer(4 * 60000);
         this.resendTimer.addEventListener(TimerEvent.TIMER,this.onResendTimer);
      }
      
      public function get isIdle() : Boolean
      {
         return this._isIdle;
      }
      
      public function get idleTime() : Number
      {
         return !!this._isIdle?Number(getTimer() - this.idleTimestamp + 5 * 60 * 1000):Number(0);
      }
      
      public function get lastInteractionTime() : Number
      {
         return getTimer() - this.lastInteractionTimestamp;
      }
      
      public function sendStatusDelayed() : void
      {
         this.sendStatusTimer.reset();
         this.sendStatusTimer.start();
         this.resendTimer.reset();
         this.resendTimer.start();
      }
      
      public function cancelSendStatusDelayed() : void
      {
         this.sendStatusTimer.stop();
         this.resendTimer.reset();
         this.resendTimer.start();
      }
      
      protected function checkIdleStatus() : void
      {
         var statusEvt:ArcadeEvent = null;
         var d:NotificationManagerData = null;
         var addOMGPOP:Boolean = false;
         if(this.idleTimer.running)
         {
            this.idleTimer.reset();
            this.idleTimer.start();
         }
         else
         {
            this.idleTimer.start();
            if(this._isIdle)
            {
               statusEvt = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
               statusEvt.playerStatus = new PlayerStatus();
               statusEvt.playerStatus.online();
               StageReference.stage.dispatchEvent(statusEvt);
               d = new NotificationManagerData();
               addOMGPOP = !!AppProperties.appVersionIsWebsiteOrAIR?Boolean(true):Boolean(false);
               d.message = "Hey, welcome back" + (!!addOMGPOP?" to OMGPOP":"") + " - you rock!";
               d.image = TextUtil.getEmoticonFromText("B)");
               AppComponents.notificationManager.showItem(d);
               this._isIdle = false;
            }
         }
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         this.checkIdleStatus();
         this.lastInteractionTimestamp = getTimer();
      }
      
      protected function onClick(event:MouseEvent) : void
      {
         this.checkIdleStatus();
         this.lastInteractionTimestamp = getTimer();
      }
      
      protected function onIdleTimer(event:TimerEvent) : void
      {
         this.idleTimestamp = getTimer();
         var statusEvt:ArcadeEvent = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
         statusEvt.playerStatus = new PlayerStatus();
         statusEvt.playerStatus.idle();
         StageReference.stage.dispatchEvent(statusEvt);
         this._isIdle = true;
         this.idleTimer.reset();
      }
      
      protected function onSendStatus(event:TimerEvent) : void
      {
         this.logger.log("Sending status ",AppComponents.model.privateUser.playerStatus.type);
         var del:PlayerDelegate = new PlayerDelegate();
         del.setPlayerStatus(AppComponents.model.privateUser.playerStatus,AppComponents.model.privateUser.profile.id,AppComponents.model.privateUser.id.toString());
      }
      
      protected function onResendTimer(event:TimerEvent) : void
      {
         var statusEvt:ArcadeEvent = null;
         if(!this._isIdle)
         {
            statusEvt = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
            statusEvt.playerStatus = AppComponents.model.privateUser.playerStatus;
            StageReference.stage.dispatchEvent(statusEvt);
         }
      }
   }
}
