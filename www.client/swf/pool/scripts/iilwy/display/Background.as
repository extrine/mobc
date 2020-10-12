package iilwy.display
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.display.core.WindowManager;
   import iilwy.events.ModelEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.net.MediaProxy;
   import iilwy.utils.Scale;
   
   public final class Background extends Sprite
   {
       
      
      private var _bitmap:Bitmap;
      
      private var _timer:Timer;
      
      private var _requestURL:String;
      
      private var _pendingURL:String;
      
      private var _requesting:Boolean = false;
      
      public var defaultBackground:String = "http://staticcdn.iminlikewithyou.com/background-default.jpg";
      
      public var enabled:Boolean = true;
      
      public var _firstLoad:Boolean = true;
      
      protected var _clearedBackground:BitmapData;
      
      public function Background()
      {
         super();
         this._bitmap = new GraphicManager.backgroundBase();
         this._clearedBackground = this._bitmap.bitmapData;
         this._bitmap.smoothing = true;
         this._bitmap.x = 0;
         this._bitmap.y = 0;
         addChild(this._bitmap);
         this._timer = new Timer(999999,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSetBackgroundDelayed);
         this.init();
      }
      
      public function init() : void
      {
         WindowManager.getInstance().addEventListener(Event.RESIZE,this.resizeHandler);
         this.rescaleImage();
         this.resetDefaultBackground(null);
         AppComponents.model.addEventListener(ModelEvent.CHANGE_BACKGROUND,this.doChangeBackgroundImage);
         AppComponents.model.addEventListener(ModelEvent.CURRENT_PROFILE_LOAD_SUCCESS,this.doChangeToProfileBackground);
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.loginChanged);
         AppComponents.model.addEventListener(ModelEvent.RESET_DEFAULT_BACKGROUND,this.resetDefaultBackground);
      }
      
      private function loginChanged(evt:Event) : void
      {
         if(!AppComponents.model.privateUser.isLoggedIn)
         {
            this.setBackground(this.defaultBackground);
         }
      }
      
      private function setBackground(bg:*, delay:Number = 1500) : void
      {
         var background:Object = null;
         if(!this.enabled)
         {
            return;
         }
         if(bg is Bitmap)
         {
            this._pendingURL = null;
            this.onSetBackgroundDelayed(null);
            background = {};
            background.photo = {};
            background.photo.bitmapData = Bitmap(bg).bitmapData;
            this.doChangeBackground(background);
         }
         else if(bg is String)
         {
            if(this._firstLoad)
            {
               this._timer.delay = 8000;
            }
            else
            {
               this._timer.delay = 1500;
            }
            this._pendingURL = bg;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function onSetBackgroundDelayed(event:TimerEvent) : void
      {
         if(!this.enabled)
         {
            return;
         }
         this._firstLoad = false;
         if(this._requesting)
         {
            MediaProxy.killRequest(this._requestURL);
         }
         if(this._pendingURL)
         {
            MediaProxy.request(this._pendingURL,this.doChangeBackground,1);
            this._requesting = true;
         }
      }
      
      private function doChangeToProfileBackground(evt:ModelEvent) : void
      {
         var p:ProfileData = AppComponents.model.currentProfile;
         if(p.background != null)
         {
            this.setBackground(p.background);
         }
      }
      
      private function doChangeBackgroundImage(evt:ModelEvent) : void
      {
         this.setBackground(evt.data);
      }
      
      private function doChangeBackground(b:Object) : void
      {
         this._requesting = false;
         if(b.photo && b.photo.bitmapData)
         {
            if(this._bitmap.bitmapData != null && this._bitmap.bitmapData != this._clearedBackground)
            {
               this._bitmap.bitmapData.dispose();
            }
            this._bitmap.bitmapData = b.photo.bitmapData;
            this._bitmap.smoothing = true;
            this.rescaleImage();
         }
      }
      
      public function clearIfNotEqual(str:String) : void
      {
         if(this._pendingURL != str)
         {
            this.clear();
         }
      }
      
      public function clear() : void
      {
         if(this._bitmap.bitmapData != null && this._bitmap.bitmapData != this._clearedBackground)
         {
            this._bitmap.bitmapData.dispose();
         }
         this._bitmap.bitmapData = this._clearedBackground;
         this._bitmap.smoothing = true;
         this.rescaleImage();
      }
      
      private function resetDefaultBackground(evt:* = null) : void
      {
         if(!this.enabled)
         {
            return;
         }
         this.setBackground(this.defaultBackground,3000);
      }
      
      private function gotData(tData:Object) : void
      {
         if(tData.notLoggedIn == null)
         {
            var onDone:Function = function(b:Object):void
            {
               if(b.photo.bitmapData != null)
               {
                  _bitmap.bitmapData = b.photo.bitmapData;
                  _bitmap.smoothing = true;
                  rescaleImage();
               }
            };
            this.setBackground(tData.url);
         }
      }
      
      private function resizeHandler(evt:Event) : void
      {
         if(this._bitmap.bitmapData != null)
         {
            this.rescaleImage();
         }
      }
      
      private function rescaleImage(... args) : void
      {
         var tScale:Object = null;
         tScale = Scale.scaleContent(WindowManager.width,WindowManager.height,this._bitmap.bitmapData.width,this._bitmap.bitmapData.height,Scale.SCALE_CROP,0,0,Scale.POS_FACE);
         this._bitmap.width = tScale.width;
         this._bitmap.height = tScale.height;
         this._bitmap.x = tScale.x;
         this._bitmap.y = tScale.y;
      }
   }
}
