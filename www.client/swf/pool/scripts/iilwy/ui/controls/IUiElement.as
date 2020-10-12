package iilwy.ui.controls
{
   import iilwy.ui.core.ISprite;
   import iilwy.ui.themes.Style;
   import iilwy.ui.themes.Theme;
   import iilwy.ui.utils.Margin;
   
   public interface IUiElement extends ISprite
   {
       
      
      function get measuredMinWidth() : Number;
      
      function set measuredMinWidth(value:Number) : void;
      
      function get measuredMinHeight() : Number;
      
      function set measuredMinHeight(value:Number) : void;
      
      function get measuredWidth() : Number;
      
      function set measuredWidth(value:Number) : void;
      
      function get measuredHeight() : Number;
      
      function set measuredHeight(value:Number) : void;
      
      function get minWidth() : Number;
      
      function set minWidth(value:Number) : void;
      
      function get minHeight() : Number;
      
      function set minHeight(value:Number) : void;
      
      function get maxWidth() : Number;
      
      function set maxWidth(value:Number) : void;
      
      function get maxHeight() : Number;
      
      function set maxHeight(value:Number) : void;
      
      function get explicitMinWidth() : Number;
      
      function set explicitMinWidth(value:Number) : void;
      
      function get explicitMinHeight() : Number;
      
      function set explicitMinHeight(value:Number) : void;
      
      function get explicitMaxWidth() : Number;
      
      function set explicitMaxWidth(value:Number) : void;
      
      function get explicitMaxHeight() : Number;
      
      function set explicitMaxHeight(value:Number) : void;
      
      function get explicitWidth() : Number;
      
      function set explicitWidth(value:Number) : void;
      
      function get explicitHeight() : Number;
      
      function set explicitHeight(value:Number) : void;
      
      function get percentWidth() : Number;
      
      function set percentWidth(value:Number) : void;
      
      function get percentHeight() : Number;
      
      function set percentHeight(value:Number) : void;
      
      function get includeInLayout() : Boolean;
      
      function set includeInLayout(value:Boolean) : void;
      
      function get validating() : Boolean;
      
      function get childrenCreated() : Boolean;
      
      function get style() : Style;
      
      function set style(value:Style) : void;
      
      function get theme() : Theme;
      
      function set theme(value:Theme) : void;
      
      function get margin() : Margin;
      
      function set margin(value:Margin) : void;
      
      function get padding() : Margin;
      
      function set padding(value:Margin) : void;
      
      function destroy() : void;
      
      function invalidateProperties() : void;
      
      function invalidateSize() : void;
      
      function invalidateDisplayList() : void;
      
      function validate() : void;
      
      function getExplicitOrMeasuredWidth() : Number;
      
      function getExplicitOrMeasuredHeight() : Number;
      
      function setActualSize(width:Number, height:Number) : void;
      
      function setStyleById(styleID:String) : void;
      
      function setThemeById(themeID:String) : void;
      
      function setMargin(... rest) : void;
      
      function setPadding(... rest) : void;
   }
}
