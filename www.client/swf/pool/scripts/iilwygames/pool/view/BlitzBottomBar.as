package iilwygames.pool.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import iilwy.ui.controls.Label;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.model.gameplay.Ruleset.EightballBlitz;
   
   public class BlitzBottomBar extends Sprite
   {
       
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var cueControl:CueControlView;
      
      public var serialBallView:SerialBallView;
      
      private var background:Bitmap;
      
      private var score:Label;
      
      private var multiplyerLabel:Label;
      
      private var englishLabel:Label;
      
      private var timeLeft:Label;
      
      private var playerScore:Number;
      
      private var multiplyer:Number;
      
      public function BlitzBottomBar()
      {
         super();
         this.cueControl = new CueControlView();
         this.background = new Bitmap();
         this.englishLabel = new Label("ENGLISH");
         this.serialBallView = new SerialBallView();
         this.englishLabel.setStyleById("white");
         this.englishLabel.fontSize = 10;
         this.englishLabel.alpha = 0.5;
         this.score = new Label("0");
         this.score.setStyleById("white");
         this.multiplyerLabel = new Label("x1");
         this.multiplyerLabel.setStyleById("white");
         this.timeLeft = new Label("1:00");
         this.timeLeft.setStyleById("white");
         addChild(this.background);
         addChild(this.cueControl);
         addChild(this.englishLabel);
         addChild(this.serialBallView);
         addChild(this.score);
         addChild(this.multiplyerLabel);
         addChild(this.timeLeft);
         this.multiplyer = -1;
         this.playerScore = -1;
      }
      
      public function destroy() : void
      {
         removeChild(this.background);
         removeChild(this.cueControl);
         removeChild(this.englishLabel);
         removeChild(this.serialBallView);
         removeChild(this.score);
         removeChild(this.multiplyerLabel);
         removeChild(this.timeLeft);
         this.englishLabel.destroy();
         this.cueControl.destroy();
         this.serialBallView.destroy();
         this.score.destroy();
         this.multiplyerLabel.destroy();
         this.timeLeft.destroy();
         this.englishLabel = null;
         this.background = null;
         this.cueControl = null;
         this.serialBallView = null;
         this.score = null;
         this.multiplyerLabel = null;
         this.timeLeft = null;
      }
      
      public function update(et:Number) : void
      {
         var tl:Number = NaN;
         var mins:Number = NaN;
         var seconds:int = 0;
         var secondText:String = null;
         this.cueControl.update();
         var ebb:EightballBlitz = Globals.model.ruleset as EightballBlitz;
         if(ebb)
         {
            if(ebb.score != this.playerScore)
            {
               this.playerScore = ebb.score;
               this.score.text = this.playerScore.toString();
            }
            if(ebb.scoreMultiplier != this.multiplyer)
            {
               this.multiplyer = ebb.scoreMultiplier;
               this.multiplyerLabel.text = "x" + this.multiplyer;
            }
            tl = ebb.gameTimer;
            mins = int(tl / 60);
            seconds = int(tl - mins * 60);
            if(seconds < 10)
            {
               secondText = "0" + seconds;
            }
            else
            {
               secondText = seconds.toString();
            }
            this.timeLeft.text = mins + ":" + secondText;
         }
      }
      
      public function resize() : void
      {
         var padding:int = 0;
         this.resizeAssets();
         this.cueControl.resize(40,40);
         this.cueControl.x = 30;
         this.cueControl.y = 41;
         this.englishLabel.x = 6;
         this.englishLabel.y = 2;
         this._width = 524;
         this._height = 70;
         this.serialBallView.resize();
         padding = 10;
         this.timeLeft.x = 80;
         this.timeLeft.y = this._height - this.timeLeft.height - padding;
         this.score.x = 180;
         this.score.y = this._height - this.score.height - padding;
         this.serialBallView.x = this._width - this.serialBallView.width;
         -padding;
         this.serialBallView.y = this._height - this.serialBallView.height - padding;
         this.multiplyerLabel.x = this.serialBallView.x - padding - this.multiplyerLabel.width;
         this.multiplyerLabel.y = this._height - this.score.height - padding;
      }
      
      public function resizeAssets() : void
      {
         this.background.bitmapData = Globals.resourceManager.getTexture("bottomBar");
         if(this.background.bitmapData)
         {
            this._width = this.background.width;
            this._height = this.background.height;
         }
         this.cueControl.resizeAssets();
      }
      
      public function onViewChange() : void
      {
         this.serialBallView.onViewChange();
      }
   }
}
