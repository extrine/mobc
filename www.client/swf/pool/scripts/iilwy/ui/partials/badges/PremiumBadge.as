package iilwy.ui.partials.badges
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.display.core.Popups;
   import iilwy.events.ApplicationEvent;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.utils.BitmapCache;
   
   public class PremiumBadge extends AbstractBadge
   {
      
      public static const BADGE:String = "badge";
      
      public static const ICON:String = "icon";
      
      public static const TEXT_ICON:String = "textIcon";
      
      private static var staticCache:BitmapCache;
       
      
      protected var _assetType:String;
      
      protected var _level:Number = 0;
      
      public function PremiumBadge(assetType:String = "badge")
      {
         super();
         if(!staticCache)
         {
            staticCache = new BitmapCache(10);
         }
         if(!AppProperties.appVersionIsWebsiteOrAIR && !EmbedSettings.getInstance().enableStarPromotion)
         {
            removeEventListener(MouseEvent.CLICK,this.onClick);
            buttonMode = false;
            useHandCursor = false;
         }
         this.assetType = assetType;
      }
      
      public function get assetType() : String
      {
         return this._assetType;
      }
      
      public function set assetType(value:String) : void
      {
         this._assetType = Boolean(value)?value:BADGE;
         invalidateSize();
         invalidateDisplayList();
         invalidateProperties();
      }
      
      public function get level() : Number
      {
         return this._level;
      }
      
      public function set level(value:Number) : void
      {
         var bd:BitmapData = null;
         this._level = value;
         if(isNaN(this._level))
         {
            this._level = 0;
         }
         try
         {
            bd = bd = staticCache.getItem(this._level.toString() + this._assetType);
            bitmap.bitmapData = bd;
         }
         catch(e:Error)
         {
         }
         invalidateSize();
         invalidateDisplayList();
         invalidateProperties();
      }
      
      override public function commitProperties() : void
      {
         var bd:BitmapData = staticCache.getItem(this._level.toString() + this._assetType);
         if(!bd)
         {
            bd = loadBitmap(PremiumLevels[this._assetType + "AssetForLevel"](this._level));
            if(!bd)
            {
               return;
            }
            staticCache.addItem(this._level.toString() + this._assetType,bd);
         }
         bitmap.bitmapData = bd;
      }
      
      override public function measure() : void
      {
         if(this._level == 0)
         {
            measuredHeight = 0;
            measuredWidth = 0;
         }
         else
         {
            super.measure();
         }
      }
      
      override protected function onClick(event:MouseEvent) : void
      {
         var appEvent:ApplicationEvent = new ApplicationEvent(ApplicationEvent.OPEN_POPUP_BY_ID);
         appEvent.id = Popups.PREMIUM_ABOUT;
         dispatchEvent(appEvent);
      }
   }
}
