package iilwy.debug
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class FPSMeter extends Sprite
   {
       
      
      protected var tf:TextField;
      
      public var time:Number;
      
      public var frameTime:Number;
      
      public var prevFrameTime:Number;
      
      public var secondTime:Number;
      
      public var prevSecondTime:Number;
      
      public var frames:Number = 0;
      
      public var fps:String = "...";
      
      public function FPSMeter()
      {
         this.tf = new TextField();
         this.prevFrameTime = getTimer();
         this.prevSecondTime = getTimer();
         super();
         graphics.beginFill(16777215,0.6);
         graphics.drawRect(0,0,40,20);
         this.tf = new TextField();
         addChild(this.tf);
         y = 50;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      protected function onAdded(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onRemoved(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onEnterFrame(event:Event) : void
      {
         this.time = getTimer();
         this.frameTime = this.time - this.prevFrameTime;
         this.secondTime = this.time - this.prevSecondTime;
         if(this.secondTime >= 1000)
         {
            this.fps = int(this.frames / (this.secondTime / 1000)).toString();
            this.frames = 0;
            this.prevSecondTime = this.time;
         }
         else
         {
            this.frames++;
         }
         this.prevFrameTime = this.time;
         this.tf.text = this.fps;
      }
      
      protected function onClick(event:MouseEvent) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
