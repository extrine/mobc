package iilwy.display.thumbnails
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.user.UserStatus;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.MediaProxy;
   import iilwy.ui.controls.Thumbnail;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.ControlState;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;

   public class AbstractUserThumbnail extends Thumbnail
   {

      protected static var contextButtonArt:BitmapData;


      public var contextButtonOverAlpha:Number = 0.9;

      public var contextButtonOutAlpha:Number = 0;

      public var contextMenuAlign:String;

      public var showOnlineStatus:Boolean;

      public var useVerbosePhotoUrl:Boolean;

      public var contextMenuEnabled:Boolean = true;

      protected var onlineStatusSprite:Sprite;

      protected var onlineStatusValid:Boolean;

      protected var contextButton:Bitmap;

      protected var state:String;

      protected var _contextButtonVisible:Boolean;

      protected var _contextButtonAlign:String;

      protected var _userStatus:String = "offline";

      protected var _profileData:ProfileData;

      public function AbstractUserThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail")
      {
         this.state = ControlState.UP;
         super(x,y,size,styleID);
         this.onlineStatusSprite = new Sprite();
         addChild(this.onlineStatusSprite);
         this._contextButtonAlign = ControlAlign.CENTER_MIDDLE;
         this.contextMenuAlign = ControlAlign.LEFT_BOTTOM;
         this.contextButton = new Bitmap();
         this.contextButton.bitmapData = createContextButtonArt();
         addChild(this.contextButton);
         useHandCursor = true;
         buttonMode = true;
         mouseEnabled = true;
         tabEnabled = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }

      private static function createContextButtonArt() : BitmapData
      {
         var canvas:Sprite = null;
         if(contextButtonArt == null)
         {
            canvas = new Sprite();
            UiRender.renderRoundRect(canvas,2566914048,0,0,20,16,7);
            UiRender.renderTriangle(canvas,16777215,4,6,12,6);
            contextButtonArt = new BitmapData(20,16,true,16777215);
            contextButtonArt.draw(canvas);
         }
         return contextButtonArt;
      }

      public function get contextButtonVisible() : Boolean
      {
         return this._contextButtonVisible;
      }

      public function set contextButtonVisible(value:Boolean) : void
      {
         this._contextButtonVisible = value;
         invalidateDisplayList();
      }

      public function get contextButtonAlign() : String
      {
         return this._contextButtonAlign;
      }

      public function set contextButtonAlign(value:String) : void
      {
         this._contextButtonAlign = value;
         invalidateDisplayList();
      }

      public function get userStatus() : String
      {
         return this._userStatus;
      }

      public function set userStatus(value:String) : void
      {
         if(this._userStatus != value)
         {
            this._userStatus = value;
            this.onlineStatusValid = false;
            invalidateDisplayList();
         }
      }

      omgpop_internal function set profileData(value:ProfileData) : void
      {
         this._profileData = value;
         if(this._profileData == null || this._profileData.photo_url == null)
         {
            url = null;
         }
         else if(this.useVerbosePhotoUrl)
         {
            url = this._profileData.photo_url;
         }
         else if(width >= 80)
         {
            url = MediaProxy.url(this._profileData.photo_url,MediaProxy.SIZE_LARGE_THUMB);
         }
         else if(width >= 40)
         {
            url = MediaProxy.url(this._profileData.photo_url,MediaProxy.SIZE_MEDIUM_THUMB);
         }
         else if(width >= 20)
         {
            url = MediaProxy.url(this._profileData.photo_url,MediaProxy.SIZE_SMALL_THUMB);
         }
         else
         {
            url = MediaProxy.url(this._profileData.photo_url,MediaProxy.SIZE_TINY_THUMB);
         }
      }

      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var tW:int = 0;
         var tH:int = 0;
         var _tX:int = 0;
         var _tY:int = 0;
         var color:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this._contextButtonAlign == ControlAlign.CENTER_MIDDLE)
         {
            GraphicUtil.centerInto(this.contextButton,0,0,unscaledWidth,unscaledHeight,true);
         }
         else if(this._contextButtonAlign == ControlAlign.TOP_LEFT)
         {
            this.contextButton.x = borderSize + 4;
            this.contextButton.y = borderSize + 4;
         }
         if(!this.onlineStatusValid && this.showOnlineStatus)
         {
            this.onlineStatusSprite.graphics.clear();
            if(this._userStatus != UserStatus.OFFLINE)
            {
               tW = width / 2.5;
               tH = height / 2.5;
               _tX = 0;
               _tY = height - tH;
               _tY = height - tH;
               color = this._userStatus == UserStatus.ONLINE?int(3381504):int(16764006);
               this.onlineStatusSprite.graphics.beginFill(color);
               this.onlineStatusSprite.graphics.lineStyle(0,0,0);
               this.onlineStatusSprite.graphics.moveTo(_tX,_tY);
               this.onlineStatusSprite.graphics.lineTo(_tX,_tY + tH);
               this.onlineStatusSprite.graphics.lineTo(_tX + tW,_tY + tH);
               this.onlineStatusSprite.graphics.lineTo(_tX,_tY);
            }
         }
         if(this._contextButtonVisible)
         {
            if(this.state == ControlState.OVER)
            {
               this.contextButton.visible = true;
               this.contextButton.alpha = this.contextButtonOverAlpha;
            }
            else if(this.state == ControlState.UP)
            {
               this.contextButton.visible = true;
               this.contextButton.alpha = this.contextButtonOutAlpha;
            }
         }
         else
         {
            this.contextButton.visible = false;
         }
      }

      protected function onMouseOver(event:MouseEvent) : void
      {
         this.state = ControlState.OVER;
         invalidateDisplayList();
      }

      protected function onMouseOut(event:MouseEvent) : void
      {
         this.state = ControlState.UP;
         invalidateDisplayList();
      }

      protected function onMouseDown(event:MouseEvent) : void
      {
      }
   }
}
