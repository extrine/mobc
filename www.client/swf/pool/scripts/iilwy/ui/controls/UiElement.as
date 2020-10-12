package iilwy.ui.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import iilwy.display.core.ThemeManager;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.ui.events.ThemeEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.themes.Style;
   import iilwy.ui.themes.Theme;
   import iilwy.ui.themes.Themes;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.logging.Logger;
   
   use namespace omgpop_internal;
   
   [Event(name="resize",type="iilwy.ui.events.UiEvent")]
   [Event(name="redraw",type="iilwy.ui.events.UiEvent")]
   [Event(name="invalidateSize",type="iilwy.ui.events.UiEvent")]
   [Event(name="invalidateDisplaylist",type="iilwy.ui.events.UiEvent")]
   public class UiElement extends Sprite implements IUiElement
   {
      
      public static const DEFAULT_MAX_WIDTH:Number = 10000;
      
      public static const DEFAULT_MAX_HEIGHT:Number = 10000;
      
      protected static var themeManager:ThemeManager;
       
      
      public var obeyMaxMins:Boolean = true;
      
      protected var propertiesValid:Boolean = false;
      
      protected var sizeValid:Boolean = false;
      
      protected var sizeChanged:Boolean = false;
      
      protected var displayListValid:Boolean = false;
      
      protected var validated:Boolean = false;
      
      protected var destroyed:Boolean = false;
      
      protected var styleID:String;
      
      protected var themeID:String;
      
      private var logger:Logger;
      
      private var oldWidth:Number = 0;
      
      private var oldHeight:Number = 0;
      
      private var firstAppearance:Boolean = false;
      
      private var hasBeenInvalidatedOnceWhileOffstage:Boolean = true;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _measuredMinWidth:Number = 0;
      
      private var _measuredMinHeight:Number = 0;
      
      private var _measuredWidth:Number;
      
      private var _measuredHeight:Number;
      
      private var _explicitMinWidth:Number;
      
      private var _explicitMinHeight:Number;
      
      private var _explicitMaxWidth:Number;
      
      private var _explicitMaxHeight:Number;
      
      private var _explicitWidth:Number;
      
      private var _explicitHeight:Number;
      
      private var _percentWidth:Number;
      
      private var _percentHeight:Number;
      
      private var _includeInLayout:Boolean = true;
      
      private var _validating:Boolean = false;
      
      private var _childrenCreated:Boolean = false;
      
      private var _style:Style;
      
      private var _theme:Theme;
      
      private var _margin:Margin;
      
      private var _padding:Margin;
      
      public function UiElement()
      {
         var AppComponents:* = undefined;
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this._onRemovedFromStage,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this._onAddedToStage,false,0,true);
         addEventListener(Event.ADDED,this._onAdded,false,0,true);
         this._margin = new Margin();
         this._padding = new Margin();
         try
         {
            AppComponents = getDefinitionByName("iilwy.application.AppComponents") as Class;
         }
         catch(error:Error)
         {
         }
         themeManager = AppComponents && AppComponents.themeManager?AppComponents.themeManager:Boolean(themeManager)?themeManager:new ThemeManager();
         this.setThemeById(Themes.APPLICATION_THEME);
         themeManager.addEventListener(ThemeEvent.THEME_CHANGED,this.onThemeManagerChanged,false,0,true);
         this.invalidateDisplayList();
         tabEnabled = false;
         mouseChildren = false;
         mouseEnabled = true;
         this.logger = Logger.getLogger(this);
      }
      
      public static function getValidValue(... args) : *
      {
         var val:* = undefined;
         var test:String = null;
         var match:* = undefined;
         for(var i:Number = 0; i < args.length; i++)
         {
            val = args[i];
            if(val != undefined)
            {
               test = val.toString();
               if(test != "NaN")
               {
                  match = val;
                  break;
               }
            }
         }
         return match;
      }
      
      override public function get width() : Number
      {
         if(!this.destroyed)
         {
            this._measure();
         }
         return this._width;
      }
      
      override public function set width(value:Number) : void
      {
         if(this._width != value)
         {
            if(isNaN(this.percentWidth))
            {
               this._explicitWidth = value;
            }
            this._width = value;
            this.invalidateSize();
            this.invalidateDisplayList();
         }
      }
      
      override public function get height() : Number
      {
         if(!this.destroyed)
         {
            this._measure();
         }
         return this._height;
      }
      
      override public function set height(value:Number) : void
      {
         if(this._height != value)
         {
            if(isNaN(this.percentHeight))
            {
               this._explicitHeight = value;
            }
            this._height = value;
            this.invalidateSize();
            this.invalidateDisplayList();
         }
      }
      
      public function get measuredMinWidth() : Number
      {
         return this._measuredMinWidth;
      }
      
      public function set measuredMinWidth(value:Number) : void
      {
         this._measuredMinWidth = value;
      }
      
      public function get measuredMinHeight() : Number
      {
         return this._measuredMinHeight;
      }
      
      public function set measuredMinHeight(value:Number) : void
      {
         this._measuredMinHeight = value;
      }
      
      public function get measuredWidth() : Number
      {
         return this._measuredWidth;
      }
      
      public function set measuredWidth(value:Number) : void
      {
         this._measuredWidth = value;
      }
      
      public function get measuredHeight() : Number
      {
         return this._measuredHeight;
      }
      
      public function set measuredHeight(value:Number) : void
      {
         this._measuredHeight = value;
      }
      
      public function get minWidth() : Number
      {
         if(!isNaN(this.explicitMinWidth))
         {
            return this.explicitMinWidth;
         }
         return this.measuredMinWidth;
      }
      
      public function set minWidth(value:Number) : void
      {
         if(this.explicitMinWidth == value)
         {
            return;
         }
         this.explicitMinWidth = value;
      }
      
      public function get minHeight() : Number
      {
         if(!isNaN(this.explicitMinHeight))
         {
            return this.explicitMinHeight;
         }
         return this.measuredMinHeight;
      }
      
      public function set minHeight(value:Number) : void
      {
         if(this.explicitMinHeight == value)
         {
            return;
         }
         this.explicitMinHeight = value;
      }
      
      public function get maxWidth() : Number
      {
         return !isNaN(this.explicitMaxWidth)?Number(this.explicitMaxWidth):Number(DEFAULT_MAX_WIDTH);
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this.explicitMaxWidth == value)
         {
            return;
         }
         this.explicitMaxWidth = value;
      }
      
      public function get maxHeight() : Number
      {
         return !isNaN(this.explicitMaxHeight)?Number(this.explicitMaxHeight):Number(DEFAULT_MAX_HEIGHT);
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(this.explicitMaxHeight == value)
         {
            return;
         }
         this.explicitMaxHeight = value;
      }
      
      public function get explicitMinWidth() : Number
      {
         return this._explicitMinWidth;
      }
      
      public function set explicitMinWidth(value:Number) : void
      {
         if(this._explicitMinWidth == value)
         {
            return;
         }
         this._explicitMinWidth = value;
         this.invalidateSize();
      }
      
      public function get explicitMinHeight() : Number
      {
         return this._explicitMinHeight;
      }
      
      public function set explicitMinHeight(value:Number) : void
      {
         if(this._explicitMinHeight == value)
         {
            return;
         }
         this._explicitMinHeight = value;
         this.invalidateSize();
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function set explicitMaxWidth(value:Number) : void
      {
         if(this._explicitMaxWidth == value)
         {
            return;
         }
         this._explicitMaxWidth = value;
         this.invalidateSize();
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function set explicitMaxHeight(value:Number) : void
      {
         if(this._explicitMaxHeight == value)
         {
            return;
         }
         this._explicitMaxHeight = value;
         this.invalidateSize();
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(value:Number) : void
      {
         if(this._explicitWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._percentWidth = NaN;
         }
         this._explicitWidth = value;
         this.invalidateSize();
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         if(this._explicitHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._percentHeight = NaN;
         }
         this._explicitHeight = value;
         this.invalidateSize();
      }
      
      public function get percentWidth() : Number
      {
         return this._percentWidth;
      }
      
      public function set percentWidth(value:Number) : void
      {
         if(this._percentWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._explicitWidth = NaN;
         }
         this._percentWidth = value;
      }
      
      public function get percentHeight() : Number
      {
         return this._percentHeight;
      }
      
      public function set percentHeight(value:Number) : void
      {
         if(this._percentHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._explicitHeight = NaN;
         }
         this._percentHeight = value;
      }
      
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(value:Boolean) : void
      {
         this._includeInLayout = value;
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function get validating() : Boolean
      {
         return this._validating;
      }
      
      public function get childrenCreated() : Boolean
      {
         return this._childrenCreated;
      }
      
      public function get style() : Style
      {
         return this._style;
      }
      
      public function set style(value:Style) : void
      {
         this._style = value;
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function get theme() : Theme
      {
         return this._theme;
      }
      
      public function set theme(value:Theme) : void
      {
         this._theme = value;
         this.setStyleById(this.styleID);
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function get margin() : Margin
      {
         return this._margin;
      }
      
      public function set margin(value:Margin) : void
      {
         this._margin = value;
         this.invalidateSize();
      }
      
      public function get padding() : Margin
      {
         return this._padding;
      }
      
      public function set padding(value:Margin) : void
      {
         this._padding = value;
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function destroy() : void
      {
         this.destroyed = true;
         removeEventListener(Event.RENDER,this._onRender);
         removeEventListener(Event.ADDED_TO_STAGE,this._onAddedToStage);
         removeEventListener(Event.ADDED,this._onAdded);
         removeEventListener(Event.ENTER_FRAME,this._onRender,false);
         this.propertiesValid = false;
         this.sizeValid = false;
         this.sizeChanged = false;
         this.displayListValid = false;
         this._measuredMinWidth = 0;
         this._measuredMinHeight = 0;
         this._measuredWidth = NaN;
         this._measuredHeight = NaN;
         this._explicitMinWidth = NaN;
         this._explicitMinHeight = NaN;
         this._explicitMaxWidth = NaN;
         this._explicitMaxHeight = NaN;
         this._explicitWidth = NaN;
         this._explicitHeight = NaN;
         this._percentWidth = NaN;
         this._percentHeight = NaN;
         this._width = NaN;
         this._height = NaN;
         this.oldWidth = NaN;
         this.oldHeight = NaN;
         themeManager.removeEventListener(ThemeEvent.THEME_CHANGED,this.onThemeManagerChanged);
         this.styleID = null;
         this.themeID = null;
         this._style = null;
         this._theme = null;
      }
      
      public function invalidateProperties() : void
      {
         this.propertiesValid = false;
         this.invalidateStage();
      }
      
      public function invalidateSize() : void
      {
         this.sizeValid = false;
         this.invalidateStage();
         dispatchEvent(new UiEvent(UiEvent.INVALIDATE_SIZE,this,true,true));
      }
      
      public function invalidateDisplayList() : void
      {
         this.displayListValid = false;
         this.invalidateStage();
         dispatchEvent(new UiEvent(UiEvent.INVALIDATE_DISPLAYLIST,this,true,true));
      }
      
      public function validate() : void
      {
         this.validated = true;
         if(this.destroyed)
         {
            return;
         }
         this._validating = true;
         if(!this._childrenCreated)
         {
            this._childrenCreated = true;
            this.createChildren();
         }
         if(!this.propertiesValid)
         {
            this.propertiesValid = true;
            this.commitProperties();
         }
         if(!this.sizeValid)
         {
            this._measure();
            this._validating = true;
         }
         if(!this.displayListValid)
         {
            this.displayListValid = true;
            this.updateDisplayList(this._width,this._height);
            dispatchEvent(new UiEvent(UiEvent.REDRAW,this,false,false));
         }
         if(this.sizeChanged)
         {
            dispatchEvent(new UiEvent(UiEvent.RESIZE,this,false,false));
            this.sizeChanged = false;
         }
         this._validating = false;
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         return !isNaN(this.explicitWidth)?Number(this.explicitWidth):Number(this.measuredWidth);
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         return !isNaN(this.explicitHeight)?Number(this.explicitHeight):Number(this.measuredHeight);
      }
      
      public function setActualSize(width:Number, height:Number) : void
      {
         var changed:Boolean = false;
         if(this._width != width)
         {
            this._width = width;
            changed = true;
         }
         if(this._height != height)
         {
            this._height = height;
            changed = true;
         }
         if(changed)
         {
            this.invalidateDisplayList();
         }
      }
      
      public function getStyleId() : String
      {
         return this.styleID;
      }
      
      public function setStyleById(styleID:String) : void
      {
         this.styleID = styleID;
         this.style = this._theme.getStyle(styleID);
      }
      
      public function setThemeById(themeID:String) : void
      {
         if(themeID != this.themeID)
         {
            this.themeID = themeID;
            this.theme = themeManager.getTheme(this.themeID);
         }
      }
      
      public function setMargin(... args) : void
      {
         this.margin.setValues.apply(this.margin,args);
         this.invalidateSize();
      }
      
      public function setPadding(... args) : void
      {
         this.padding.setValues.apply(this.padding,args);
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      public function createChildren() : void
      {
      }
      
      public function commitProperties() : void
      {
      }
      
      public function measure() : void
      {
      }
      
      public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
      
      private function invalidateStage() : void
      {
         if(stage != null)
         {
            this.validated = false;
            stage.invalidate();
            removeEventListener(Event.ENTER_FRAME,this._onRender,false);
            addEventListener(Event.ENTER_FRAME,this._onRender,false,0,true);
         }
         else if(!this.hasBeenInvalidatedOnceWhileOffstage)
         {
            this.validated = false;
            this.hasBeenInvalidatedOnceWhileOffstage = true;
            removeEventListener(Event.ENTER_FRAME,this._onRender,false);
            addEventListener(Event.ENTER_FRAME,this._onRender,false,0,true);
         }
      }
      
      private function _measure() : void
      {
         if(!this.sizeValid)
         {
            this._validating = true;
            if(!this._childrenCreated)
            {
               this._childrenCreated = true;
               this.createChildren();
            }
            if(!this.propertiesValid)
            {
               this.propertiesValid = true;
               this.commitProperties();
            }
            this.sizeValid = true;
            this.measure();
            if(!isNaN(this.explicitWidth))
            {
               this._width = this.explicitWidth;
            }
            else if(!isNaN(this.measuredWidth))
            {
               this._width = this.measuredWidth;
               if(this.obeyMaxMins)
               {
                  this._width = Math.max(this._width,this.minWidth);
                  this._width = Math.min(this._width,this.maxWidth);
               }
            }
            if(!isNaN(this.explicitHeight))
            {
               this._height = this.explicitHeight;
            }
            else if(!isNaN(this.measuredHeight))
            {
               this._height = this.measuredHeight;
               if(this.obeyMaxMins)
               {
                  this._height = Math.max(this._height,this.minHeight);
                  this._height = Math.min(this._height,this.maxHeight);
               }
            }
            if(this._height != this.oldHeight)
            {
               this.sizeChanged = true;
            }
            if(this._width != this.oldWidth)
            {
               this.sizeChanged = true;
            }
            this.oldWidth = this._width;
            this.oldHeight = this._height;
            this._validating = false;
         }
      }
      
      protected function _onAdded(event:Event) : void
      {
      }
      
      protected function _onAddedToStage(event:Event) : void
      {
         addEventListener(Event.RENDER,this._onRender,false,0,true);
         this.hasBeenInvalidatedOnceWhileOffstage = false;
         this.validate();
         if(!this.firstAppearance)
         {
            this.firstAppearance = true;
            this.onFirstAppearance();
         }
      }
      
      protected function _onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.RENDER,this._onRender);
      }
      
      protected function _onRender(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this._onRender,false);
         if(!this.validated)
         {
            this.validate();
         }
      }
      
      protected function onFirstAppearance() : void
      {
      }
      
      private function onThemeManagerChanged(event:ThemeEvent) : void
      {
         if(event.id == this.themeID)
         {
            this.theme = themeManager.getTheme(this.themeID);
         }
      }
   }
}
