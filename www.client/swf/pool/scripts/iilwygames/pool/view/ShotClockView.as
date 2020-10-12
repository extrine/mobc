package iilwygames.pool.view
{
   import flash.display.Sprite;
   import iilwy.ui.controls.ProgressBar;
   
   public class ShotClockView extends Sprite
   {
       
      
      private var _isActive:Boolean;
      
      private var _timeLeft:Number;
      
      private var _totalTime:Number;
      
      private var _timer:ProgressBar;
      
      public function ShotClockView()
      {
         super();
         visible = false;
         this._isActive = false;
         this._timer = new ProgressBar();
         this._timer.height = 30;
         this._timer.x = 0;
         this._timer.y = 0;
         this._timer.borderSize = 4;
         this._timer.borderColor = 4291611852;
         this._timer.foregroundColor = 4287137928;
         this._timer.backgroundColor = 4291611852;
         this._timer.cornerDiameter = 8;
         this._timer.insideCornerDiameter = 8;
         this._timer.preventDistortion = false;
         addChild(this._timer);
      }
      
      public function destroy() : void
      {
         removeChild(this._timer);
         this._timer.destroy();
         this._timer = null;
      }
      
      public function setWidth(w:Number) : void
      {
         this._timer.width = w;
      }
      
      public function stop() : void
      {
         this._isActive = false;
         visible = false;
      }
      
      public function startTimer(time:Number) : void
      {
         this._isActive = true;
         visible = true;
         this._timeLeft = time;
         this._totalTime = time;
      }
      
      public function stopTimer() : void
      {
         this._isActive = false;
         visible = false;
      }
      
      public function update(et:Number) : void
      {
         if(this._isActive)
         {
            this._timeLeft = this._timeLeft - et;
            this._timer.percent = 100 * (this._timeLeft / this._totalTime);
         }
      }
   }
}
