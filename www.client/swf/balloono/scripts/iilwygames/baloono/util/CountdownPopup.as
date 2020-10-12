package iilwygames.baloono.util
{
   import flash.events.Event;
   import flash.utils.getTimer;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.controls.Label;
   import iilwy.utils.GraphicUtil;
   import iilwygames.baloono.BaloonoGame;
   import iilwygames.baloono.embedded.SoundAssets;
   
   public class CountdownPopup extends Canvas
   {
      
      public static const EVENT_TICK:String = "event.tick";
       
      
      protected var endTime:int;
      
      protected var secLeft:int;
      
      protected var _field:Label;
      
      protected const STR_GO:String = "GO!";
      
      protected const STR_WAITING:String = "...";
      
      public function CountdownPopup()
      {
         super();
         backgroundGradient = [2852126720,3992977408];
         cornerRadius = 20;
         width = 100;
         height = 100;
         this._field = new Label(this.STR_WAITING,0,0,"strongWhite");
         this._field.fontSize = 50;
         addContentChild(this._field);
         GraphicUtil.centerInto(this._field,0,0,width,height,true);
      }
      
      public function start(param1:Number) : void
      {
         this.endTime = int(param1);
         this.secLeft = int.MAX_VALUE;
         addEventListener(Event.ENTER_FRAME,this.onTimer);
      }
      
      protected function onTimer(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = Math.ceil((this.endTime - _loc2_) / 1000);
         if(_loc3_ != this.secLeft)
         {
            this.secLeft = _loc3_;
            if(_loc3_ <= 0)
            {
               removeEventListener(Event.ENTER_FRAME,this.onTimer);
               this._field.text = this.STR_GO;
               BaloonoGame.instance.soundAssets.playSound(SoundAssets.COUNTDOWN_GO);
            }
            else
            {
               BaloonoGame.instance.soundAssets.playSound(SoundAssets.COUNTDOWN_READY);
               this._field.text = this.secLeft.toString();
            }
         }
         GraphicUtil.centerInto(this._field,0,0,width,height,true);
      }
      
      override public function destroy() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onTimer);
         super.destroy();
      }
   }
}
