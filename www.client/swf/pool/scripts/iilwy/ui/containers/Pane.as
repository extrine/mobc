package iilwy.ui.containers
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.PromoSettings;
   import iilwy.display.arcade.ArcadeChatModule;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.ArcadeEvent;
   import iilwy.model.dataobjects.promo.enum.SkinDefinition;
   import iilwy.ui.controls.Label;
   import iilwy.ui.themes.Style;
   import iilwy.ui.utils.CapType;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.Scale9Image;
   import iilwy.utils.StageReference;
   import iilwy.utils.TextUtil;
   import iilwy.utils.UiRender;
   
   public class Pane extends ModuleContainer
   {
      
      protected static var bgCache:Dictionary = new Dictionary();
       
      
      protected var _chromeValid:Boolean = false;
      
      protected var _chrome:Sprite;
      
      protected var _backgroundHolder:Sprite;
      
      protected var _background:Sprite;
      
      private var _title:String;
      
      private var _titleLabel:Label;
      
      protected var _capType:String;
      
      protected var _backgroundScale9:Scale9Image;
      
      protected var _filterMargin:Margin;
      
      protected var _skin:SkinDefinition;
      
      protected var _skinImage:Loader;
      
      protected var _skinImageLoaded:Boolean;
      
      protected var _contentOffset:Point;
      
      public function Pane(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200, styleId:String = "pane")
      {
         super();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this._filterMargin = Margin.create(10);
         setPadding(10,10,10,10);
         setStyleById(styleId);
         this._chrome = new Sprite();
         addChildAt(this._chrome,0);
         this._capType = AppProperties.appVersion == AppProperties.VERSION_FACEBOOK_ARCADE?CapType.NONE:CapType.ROUND;
         this._contentOffset = new Point(0,0);
         this._titleLabel = new Label("",4,10);
         this._titleLabel.selectable = false;
         this._backgroundScale9 = new Scale9Image();
         this._chrome.addChild(this._backgroundScale9);
         maskContents = true;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var isSkinned:Boolean = false;
         var cacheKey:String = null;
         var prototype:Scale9Image = null;
         var bgArt:Sprite = null;
         var corners1:Array = null;
         var corners2:Array = null;
         var border:Margin = null;
         var cornerMargin:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         isSkinned = this._skin && this._skinImageLoaded;
         if(!this._chromeValid)
         {
            this._chromeValid = true;
            cacheKey = !!isSkinned?this._skin.toString():this._capType + "|" + style.backgroundGradient.join("|") + "|" + style.backgroundColor;
            prototype = bgCache[cacheKey];
            if(!prototype)
            {
               bgArt = new Sprite();
               this._backgroundScale9.mouseEnabled = false;
               this._backgroundScale9.buttonMode = false;
               this._backgroundScale9.useHandCursor = false;
               this._backgroundScale9.removeEventListener(MouseEvent.CLICK,this.onSkinClick);
               if(isSkinned)
               {
                  bgArt.addChild(this._skinImage);
                  prototype = new Scale9Image(bgArt,this._skin.scale9.left,this._skin.scale9.top,bgArt.width - this._skin.scale9.right,bgArt.height - this._skin.scale9.bottom);
                  if(this._skin.scale9.clickURL)
                  {
                     this._backgroundScale9.mouseEnabled = true;
                     this._backgroundScale9.buttonMode = true;
                     this._backgroundScale9.useHandCursor = true;
                     this._backgroundScale9.addEventListener(MouseEvent.CLICK,this.onSkinClick);
                  }
               }
               else
               {
                  corners1 = CapType.getCornersForType(this._capType,20);
                  corners2 = CapType.getCornersForType(this._capType,17);
                  border = new Margin(3,3,3,3);
                  if(this.capType == CapType.ROUND_RIGHT)
                  {
                     border = new Margin(0,3,3,3);
                  }
                  if(this.capType == CapType.ROUND_LEFT)
                  {
                     border = new Margin(3,3,0,3);
                  }
                  bgArt.graphics.beginFill(0,0);
                  bgArt.graphics.drawRect(0,0,100 + this._filterMargin.horizontal,100 + this._filterMargin.vertical);
                  UiRender.renderGradient(bgArt,style.backgroundGradient,0.5 * Math.PI,this._filterMargin.left,this._filterMargin.top,100,100,corners1);
                  UiRender.renderGradient(bgArt,[style.backgroundColor],0.5 * Math.PI,this._filterMargin.left + border.left,this._filterMargin.top + border.top,100 - border.horizontal,100 - border.vertical,corners2);
                  bgArt.filters = [new DropShadowFilter(4,90,0,0.43,6,6,1,1,false,false,false)];
                  cornerMargin = 10;
                  prototype = new Scale9Image(bgArt,cornerMargin + this._filterMargin.left,cornerMargin + this._filterMargin.top,bgArt.width - this._filterMargin.right - cornerMargin,bgArt.height - this._filterMargin.bottom - cornerMargin);
                  this._contentOffset = new Point(0,0);
               }
               bgCache[cacheKey] = prototype;
            }
            this._backgroundScale9.copy(prototype);
            if(this._title != null)
            {
               this._titleLabel.x = padding.left;
               this._titleLabel.setStyleById(style.titleStyleId);
               this._titleLabel.text = this._title;
               try
               {
                  this._chrome.addChild(this._titleLabel);
               }
               catch(e:Error)
               {
               }
            }
            else
            {
               try
               {
                  this._chrome.removeChild(this._titleLabel);
               }
               catch(e:Error)
               {
               }
            }
         }
         if(isSkinned)
         {
            this._contentOffset = new Point(this._skin.scale9.left,this._skin.scale9.top);
            this._backgroundScale9.x = 0;
            this._backgroundScale9.y = 0;
            this._backgroundScale9.width = unscaledWidth;
            this._backgroundScale9.height = unscaledHeight;
            if(isSkinned && this._skin.scale9)
            {
               setModuleSize(unscaledWidth - this._skin.scale9.left - this._skin.scale9.right,unscaledHeight - this._skin.scale9.top - this._skin.scale9.bottom);
            }
         }
         else
         {
            this._contentOffset = new Point(0,0);
            this._backgroundScale9.x = -this._filterMargin.left;
            this._backgroundScale9.y = -this._filterMargin.top;
            this._backgroundScale9.width = unscaledWidth + this._filterMargin.horizontal;
            this._backgroundScale9.height = unscaledHeight + this._filterMargin.vertical;
            setModuleSize(unscaledWidth,unscaledHeight);
         }
         if(this._title != null)
         {
            this._titleLabel.y = padding.top + this._contentOffset.y;
         }
         if(maskContents)
         {
            contentMask.width = unscaledWidth;
         }
         if(maskContents)
         {
            contentMask.height = unscaledHeight;
         }
         content.x = padding.left + chromePadding.left + this._contentOffset.x;
         content.y = padding.top + chromePadding.top + this._contentOffset.y;
      }
      
      override public function setModule(imodule:IModule) : IModule
      {
         super.setModule(imodule);
         if(PromoSettings.getInstance().promoChatSkin && module is ArcadeChatModule)
         {
            StageReference.stage.addEventListener(ArcadeEvent.SET_PLAYER_STATUS,this.onSetPlayerStatus);
            this.updateShowHideSkin();
         }
         else
         {
            StageReference.stage.removeEventListener(ArcadeEvent.SET_PLAYER_STATUS,this.onSetPlayerStatus);
         }
         return _module;
      }
      
      protected function updateShowHideSkin() : void
      {
         var promoSkin:SkinDefinition = null;
         var pattern:RegExp = null;
         var trackingPixelURL:String = null;
         var trackPixel:ApplicationEvent = null;
         var useSkin:Boolean = false;
         if(PromoSettings.getInstance().promoChatSkin && module is ArcadeChatModule)
         {
            promoSkin = PromoSettings.getInstance().promoChatSkin;
            if(promoSkin && promoSkin.scale9 && promoSkin.scale9.imageURL)
            {
               useSkin = true;
               if(promoSkin.statusWhiteList && promoSkin.statusWhiteList.indexOf(AppComponents.model.privateUser.playerStatus.type) == -1)
               {
                  useSkin = false;
               }
               if(promoSkin.gameWhiteList && promoSkin.gameWhiteList.indexOf(AppComponents.gamenetManager.currentMatch.gameId) == -1)
               {
                  useSkin = false;
               }
            }
         }
         if(useSkin == (this._skin && this._skinImageLoaded))
         {
            return;
         }
         if(useSkin)
         {
            this._skin = promoSkin;
            this._skinImageLoaded = false;
            this._skinImage = new Loader();
            this._skinImage.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSkinImageLoaded);
            this._skinImage.load(new URLRequest(AppProperties.fileServerStaticOrLocal + this._skin.scale9.imageURL));
            if(this._skin.trackingPixel)
            {
               pattern = /#CACHE_BUST#/;
               trackingPixelURL = TextUtil.replaceMultiple(this._skin.trackingPixel,[pattern],[new Date().toString()]);
               trackPixel = new ApplicationEvent(ApplicationEvent.TRACK_PIXEL,true);
               trackPixel.url = unescape(trackingPixelURL);
               StageReference.stage.dispatchEvent(trackPixel);
            }
         }
         else
         {
            this._skin = null;
            this._chromeValid = false;
         }
         invalidateDisplayList();
      }
      
      protected function onSkinImageLoaded(event:Event) : void
      {
         this._chromeValid = false;
         this._skinImageLoaded = true;
         invalidateDisplayList();
      }
      
      protected function onSkinClick(event:MouseEvent) : void
      {
         if(this._skin && this._skin.scale9 && this._skin.scale9.clickURL)
         {
            navigateToURL(new URLRequest(unescape(this._skin.scale9.clickURL)),"_blank");
         }
      }
      
      protected function onSetPlayerStatus(event:ArcadeEvent) : void
      {
         this.updateShowHideSkin();
      }
      
      public function get capType() : String
      {
         return this._capType;
      }
      
      public function set capType(c:String) : void
      {
         this._capType = c;
         this._chromeValid = false;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(s:String) : void
      {
         this._title = s;
         this._chromeValid = false;
         if(s == null || s == "")
         {
            chromePadding.top = 0;
         }
         else
         {
            chromePadding.top = 20;
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function set style(s:Style) : void
      {
         this._chromeValid = false;
         super.style = s;
      }
   }
}
