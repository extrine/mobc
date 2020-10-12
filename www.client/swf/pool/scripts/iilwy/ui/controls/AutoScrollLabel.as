package iilwy.ui.controls
{
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.ui.containers.AutoScroller;
   import iilwy.ui.containers.AutoScrollerDirection;
   
   public class AutoScrollLabel extends AutoScroller
   {
       
      
      private var labelText:String;
      
      private var clippedLabel:Label;
      
      private var delayTimer:Timer;
      
      private var _label:Label;
      
      private var _clipText:Boolean;
      
      public function AutoScrollLabel(text:String = "", x:Number = 0, y:Number = 0, width:Number = 200, styleID:String = "p")
      {
         this.labelText = text;
         this._label = new Label(text);
         super(AutoScrollerDirection.HORIZONTAL,x,y,width,undefined,styleID);
         keyboardEnabled = false;
         mouseEnabled = false;
         this.delayTimer = new Timer(2200,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayComplete);
         addContentChild(this._label);
      }
      
      public function get label() : Label
      {
         return this._label;
      }
      
      public function get text() : String
      {
         return this.labelText;
      }
      
      public function set text(value:String) : void
      {
         if(value != this.labelText)
         {
            this.labelText = value;
            this._label.text = value;
            if(this.clippedLabel)
            {
               this.clippedLabel.text = value;
            }
            this.reset();
            invalidateDisplayList();
            invalidateProperties();
            invalidateSize();
         }
      }
      
      public function get htmlText() : String
      {
         return this.text;
      }
      
      public function set htmlText(value:String) : void
      {
         this.text = value;
      }
      
      public function get clipText() : Boolean
      {
         return this._clipText;
      }
      
      public function set clipText(value:Boolean) : void
      {
         if(!this.clippedLabel)
         {
            this.clippedLabel = new Label(this.text);
            addContentChild(this.clippedLabel);
         }
         this._clipText = value;
         this._label.visible = !value;
         this.clippedLabel.visible = value;
         invalidateProperties();
      }
      
      override public function destroy() : void
      {
         this.labelText = null;
         this._label.destroy();
         if(this.clippedLabel)
         {
            this.clippedLabel.destroy();
         }
         super.destroy();
      }
      
      override public function commitProperties() : void
      {
         super.commitProperties();
         if(this.clippedLabel)
         {
            this.clippedLabel.text = this.getClippedText();
         }
      }
      
      override public function measure() : void
      {
         measuredHeight = this._label.height;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.delayTimer.reset();
         this._label.visible = !this.clipText;
         if(this.clippedLabel)
         {
            this.clippedLabel.visible = this.clipText;
         }
      }
      
      override public function setStyleById(styleID:String) : void
      {
         super.setStyleById(styleID);
         this._label.setStyleById(styleID);
         if(this.clippedLabel)
         {
            this.clippedLabel.setStyleById(styleID);
         }
      }
      
      override protected function startIdleScroll() : void
      {
         if(idleScroll && this.clipText)
         {
            this._label.visible = true;
            if(this.clippedLabel)
            {
               this.clippedLabel.visible = false;
            }
         }
         super.startIdleScroll();
      }
      
      override protected function backToDock() : void
      {
         super.backToDock();
         this.delayTimer.reset();
         this.delayTimer.delay = 2200;
         this.delayTimer.start();
      }
      
      private function getClippedText() : String
      {
         this.clippedLabel.text = "...";
         this.clippedLabel.validate();
         var clipIndex:int = this._label.field.getCharIndexAtPoint(width - this.clippedLabel.width,height / 2);
         return clipIndex != -1?this.labelText.slice(0,clipIndex) + "...":this.labelText;
      }
      
      private function showClippedText() : void
      {
         if(this.clipText)
         {
            this._label.visible = false;
            this.clippedLabel.visible = true;
         }
      }
      
      override public function onRollOver(evt:MouseEvent) : void
      {
         super.onRollOver(evt);
         if(!this.clipText)
         {
            return;
         }
         this._label.visible = true;
         this.clippedLabel.visible = false;
      }
      
      override public function onRollOut(evt:MouseEvent = null) : void
      {
         super.onRollOut(evt);
         if(!this.clipText)
         {
            return;
         }
         this.delayTimer.reset();
         this.delayTimer.delay = 200;
         this.delayTimer.start();
      }
      
      private function onDelayComplete(event:TimerEvent) : void
      {
         this.showClippedText();
      }
      
      public function getAppropriateWidth() : Number
      {
         return Math.ceil(Math.min(this.label.width,width));
      }
   }
}
