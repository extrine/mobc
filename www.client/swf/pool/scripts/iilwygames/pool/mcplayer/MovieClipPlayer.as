package iilwygames.pool.mcplayer
{
   import caurina.transitions.Equations;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import gs.TweenLite;
   import iilwy.ui.controls.BevelButton;
   import iilwygames.pool.core.Globals;
   
   public class MovieClipPlayer extends Sprite
   {
       
      
      private var _currentClip:MovieClip;
      
      private var _currentFrame:int;
      
      private var _playStartTime:uint;
      
      private var _elapsedTime:Number;
      
      private var _playingClip:Boolean;
      
      private var _desiredFPS:Number;
      
      private var _repeat:Boolean;
      
      private var _clipTimer:Number;
      
      private var _clipType:int;
      
      private const FRAME_RATE:Number = 30;
      
      private var _replayButton:BevelButton;
      
      private var _readyButton:BevelButton;
      
      public var _width:Number;
      
      public var _height:Number;
      
      private const CLIP_TYPE_USER_INTERACTIVE:int = 0;
      
      private const CLIP_TYPE_NON_INTERACTIVE:int = 1;
      
      public var mouseTakeover:Boolean;
      
      public function MovieClipPlayer()
      {
         super();
         this._playingClip = false;
         this.mouseTakeover = false;
         this._replayButton = new BevelButton("REPLAY",0,0,100,40,"bevelButtonColor");
         this._replayButton.cornerRadius = 15;
         this._replayButton.color = 16751910;
         this._readyButton = new BevelButton("REPLAY",0,0,100,40,"bevelButtonColor");
         this._readyButton.cornerRadius = 15;
         this._readyButton.color = 16751910;
         addChild(this._replayButton);
         addChild(this._readyButton);
         this._replayButton.visible = false;
         this._readyButton.visible = false;
         this._replayButton.addEventListener(MouseEvent.CLICK,this.onReplay);
         this._readyButton.addEventListener(MouseEvent.CLICK,this.onReady);
         this._clipTimer = 0;
      }
      
      public function destroy() : void
      {
         TweenLite.killTweensOf(this);
         if(contains(this._currentClip))
         {
            removeChild(this._currentClip);
         }
         removeChild(this._replayButton);
         removeChild(this._readyButton);
         this._currentClip = null;
      }
      
      public function stop() : void
      {
         TweenLite.killTweensOf(this);
         this.closeMovieClip();
      }
      
      public function playClip(source:MovieClip, mouseFocus:Boolean, fps:Number = -1) : void
      {
         if(this._currentClip && contains(this._currentClip))
         {
            removeChild(this._currentClip);
         }
         addChild(source);
         this._currentClip = source;
         this.setFrameRecursive(source,1);
         this._currentFrame = 1;
         this._playStartTime = getTimer();
         this._elapsedTime = 0;
         visible = true;
         this._playingClip = true;
         var fps_slider:DisplayObject = source.getChildByName("FRAMERATE_SLIDER");
         if(!fps_slider && fps < 0)
         {
            this._desiredFPS = this.FRAME_RATE;
         }
         else if(fps > 0)
         {
            this._desiredFPS = fps;
         }
         else if(fps_slider)
         {
            this._desiredFPS = fps_slider.x;
         }
         this._replayButton.visible = false;
         this._readyButton.visible = false;
         this._clipTimer = 0;
         if(mouseFocus)
         {
            this.mouseTakeover = true;
            Globals.model.ruleset.cueStick.active = false;
            this._clipType = this.CLIP_TYPE_USER_INTERACTIVE;
         }
         else
         {
            this._clipType = this.CLIP_TYPE_NON_INTERACTIVE;
         }
      }
      
      public function playClipTimed(source:MovieClip, repeat:Boolean, duration:Number, fps:int = -1) : void
      {
         if(this._currentClip && contains(this._currentClip))
         {
            removeChild(this._currentClip);
         }
         addChild(source);
         this._currentClip = source;
         this.setFrameRecursive(source,1);
         this._currentFrame = 1;
         this._playStartTime = getTimer();
         this._elapsedTime = 0;
         visible = true;
         this._playingClip = true;
         this._clipTimer = duration;
         this._repeat = repeat;
         var fps_slider:DisplayObject = source.getChildByName("FRAMERATE_SLIDER");
         if(!fps_slider && fps < 0)
         {
            this._desiredFPS = this.FRAME_RATE;
         }
         else if(fps > 0)
         {
            this._desiredFPS = fps;
         }
         else if(fps_slider)
         {
            this._desiredFPS = fps_slider.x;
         }
         this._replayButton.visible = false;
         this._readyButton.visible = false;
         this.mouseTakeover = false;
         this._clipType = this.CLIP_TYPE_NON_INTERACTIVE;
      }
      
      private function replayClip() : void
      {
         this._elapsedTime = 0;
         this._playingClip = true;
         this._replayButton.visible = false;
         this._readyButton.visible = false;
      }
      
      private function closeMovieClip() : void
      {
         visible = false;
         this._playingClip = false;
         this._replayButton.visible = false;
         this._readyButton.visible = false;
         this.mouseTakeover = false;
         alpha = 1;
      }
      
      public function update(et:Number) : void
      {
         var desiredFrame:int = 0;
         if(this._playingClip)
         {
            this._elapsedTime = this._elapsedTime + et;
            desiredFrame = Math.floor(this._elapsedTime * this.FRAME_RATE) + 1;
            if(desiredFrame > this._currentClip.totalFrames)
            {
               if(this._clipType == this.CLIP_TYPE_USER_INTERACTIVE)
               {
                  desiredFrame = this._currentClip.totalFrames;
                  this._playingClip = false;
                  this._replayButton.visible = true;
                  this._readyButton.visible = true;
               }
               else if(this._repeat)
               {
                  desiredFrame = desiredFrame % this._currentClip.totalFrames;
               }
               else if(this._clipType == this.CLIP_TYPE_NON_INTERACTIVE)
               {
                  this.closeMovieClip();
               }
            }
            this.setFrameRecursive(this._currentClip,desiredFrame);
         }
         if(this._clipTimer > 0)
         {
            this._clipTimer = this._clipTimer - et;
            if(this._clipTimer <= 0)
            {
               this._clipTimer = 0;
               TweenLite.to(this,0.5,{
                  "alpha":0,
                  "ease":Equations.easeOutExpo,
                  "onComplete":this.onTweenComplete
               });
            }
         }
      }
      
      private function onTweenComplete() : void
      {
         this.closeMovieClip();
      }
      
      private function setFrameRecursive(clip:MovieClip, frame:int) : void
      {
         var child:DisplayObject = null;
         var numFrames:int = clip.framesLoaded;
         var goalFrame:int = frame;
         if(frame > numFrames)
         {
            goalFrame = goalFrame % numFrames;
         }
         clip.gotoAndStop(goalFrame);
         var numChildren:int = clip.numChildren;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = clip.getChildAt(i);
            if(child is MovieClip)
            {
               this.setFrameRecursive(child as MovieClip,frame);
            }
         }
      }
      
      private function onReady(me:MouseEvent) : void
      {
         this.closeMovieClip();
      }
      
      private function onReplay(me:MouseEvent) : void
      {
         this.replayClip();
      }
      
      public function resize(w:Number, h:Number) : void
      {
         var buffer:int = 0;
         this._width = w;
         this._height = h;
         buffer = w * 0.1;
         this._replayButton.x = 0.5 * this._width - this._replayButton.width - buffer;
         this._replayButton.y = 0.5 * this._height - this._replayButton.height;
         this._readyButton.x = 0.5 * this._width + buffer;
         this._readyButton.y = 0.5 * this._height - this._readyButton.height;
      }
   }
}
