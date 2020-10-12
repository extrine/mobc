package iilwy.ui.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.themes.Style;
   import iilwy.utils.BitmapCache;
   
   public class Skin extends UiElement
   {
      
      public static var staticCache:BitmapCache = new BitmapCache();
       
      
      private var _cache:BitmapCache;
      
      private var _bitmap:Bitmap;
      
      public var renderMethod:Function;
      
      public var target:UiElement;
      
      private var _styleOptions:Array;
      
      public var defaultStyle:Style;
      
      public var useStaticCache:Boolean = true;
      
      public function Skin()
      {
         this._styleOptions = [];
         super();
         this._cache = new BitmapCache(6);
         this._bitmap = new Bitmap();
         addChild(this._bitmap);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      override public function destroy() : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.renderMethod = null;
         this.target = null;
         this._styleOptions = null;
         this.defaultStyle = null;
         if(this._bitmap.bitmapData && !this.useStaticCache)
         {
            this._bitmap.bitmapData.dispose();
         }
         this._bitmap.bitmapData = null;
         this._cache.destroy();
         super.destroy();
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         if(!this.useStaticCache)
         {
            if(this._bitmap.bitmapData)
            {
               this._bitmap.bitmapData.dispose();
            }
            this._bitmap.bitmapData = null;
            this._cache.clear();
            invalidateDisplayList();
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var style:Style = null;
         var data:BitmapData = null;
         var cacheId:String = null;
         var po:Object = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         for(var i:Number = 0; i < this._styleOptions.length; i++)
         {
            if(this._styleOptions[i] != null)
            {
               style = this._styleOptions[i];
               break;
            }
         }
         if(style != null)
         {
            cacheId = "";
            po = parent as Object;
            try
            {
               po = parent as Object;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.toString();
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.label;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.iconColor.toString();
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.cornerRadius.toString();
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.width.toString();
               cacheId = cacheId + po.height.toString();
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.icon.toString();
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + (po.padding.left + po.padding.right + po.padding.top + po.padding.bottom);
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.iconAlign;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.capType;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + po.info;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + style.fullyQualifiedName;
            }
            catch(e:Error)
            {
            }
            try
            {
               cacheId = cacheId + themeID;
            }
            catch(e:Error)
            {
            }
            if(this.useStaticCache)
            {
               data = Skin.staticCache.getItem(cacheId);
            }
            else
            {
               data = this._cache.getItem(cacheId);
            }
            if(data == null)
            {
               data = this.renderMethod(style);
               if(this.useStaticCache)
               {
                  Skin.staticCache.addItem(cacheId,data);
               }
               else
               {
                  this._cache.addItem(cacheId,data);
               }
            }
         }
         if(data != null)
         {
            this._bitmap.bitmapData = data;
         }
      }
      
      public function setStyle(style:Style, ... alternates) : void
      {
         if(this.renderMethod == null)
         {
            return;
         }
         var options:Array = new Array();
         options.push(style);
         for(var i:Number = 0; i < alternates.length; i++)
         {
            options.push(alternates[i]);
         }
         if(this.defaultStyle != null)
         {
            options.push(this.defaultStyle);
         }
         this._styleOptions = options;
         invalidateDisplayList();
      }
      
      public function onTargetInvalidate(event:UiEvent) : void
      {
         invalidateDisplayList();
      }
   }
}
