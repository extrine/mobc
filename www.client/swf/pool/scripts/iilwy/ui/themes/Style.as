package iilwy.ui.themes
{
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   
   public dynamic class Style
   {
      
      public static var staticCount:int = 0;
       
      
      public var _parent:Style;
      
      public var _descriptor:Object;
      
      public var name:String;
      
      public var fullyQualifiedName:String;
      
      public var styleSheet:StyleSheet;
      
      public var fontFace:String;
      
      public var fontSize:Number;
      
      public var fontColor:Number;
      
      public var fontAlign:String;
      
      public var fontLeading:Number;
      
      public var fontThickness:Number;
      
      public var subFontFace:String;
      
      public var subFontSize:Number;
      
      public var subFontColor:Number;
      
      public var subFontAlign:String;
      
      public var subFontLeading:Number;
      
      public var subFontThickness:Number;
      
      public var embedFonts:Boolean = true;
      
      public var type:String;
      
      public var capType:String;
      
      public var backgroundColor:Number;
      
      public var midgroundColor:Number;
      
      public var foregroundColor:Number;
      
      public var dashColor:Number;
      
      public var borderColor:Number;
      
      public var border1Color:Number;
      
      public var border2Color:Number;
      
      public var border3Color:Number;
      
      public var border4Color:Number;
      
      public var borderSize:Number;
      
      public var outsideBorderColor:Number;
      
      public var outsideBorderSize:Number;
      
      public var accentColor:Number;
      
      public var gradientColor:Number;
      
      public var iconColor:Number;
      
      public var iconAlign:String;
      
      public var hilightColor:Number;
      
      public var paddingTop:Number;
      
      public var paddingRight:Number;
      
      public var paddingBottom:Number;
      
      public var paddingLeft:Number;
      
      public var marginTop:Number;
      
      public var marginRight:Number;
      
      public var marginBottom:Number;
      
      public var marginLeft:Number;
      
      public var minWidth:Number;
      
      public var minHeight:Number;
      
      public var backgroundGradient:Array;
      
      public var backgroundGradientAngle:Number;
      
      public var foregroundGradient:Array;
      
      public var backgroundImageURL:String;
      
      public var backgroundStripesColor:Number;
      
      public var cornerRadius:Number;
      
      public var cornerDiameter:Number;
      
      public var itemPadding:Number;
      
      public var listBackgroundColorParent:Number;
      
      public var listBackgroundColorEven:Number;
      
      public var listBackgroundColorOdd:Number;
      
      public var listBackgroundColor2Parent:Number;
      
      public var listBackgroundColor2Even:Number;
      
      public var listBackgroundColor2Odd:Number;
      
      public var windowStyleId:String;
      
      public var buttonStyleId:String;
      
      public var itemStyleId:String;
      
      public var contentStyleId:String;
      
      public var titleStyleId:String;
      
      public var scrollbarStyleId:String;
      
      public var labelStyleId:String;
      
      public var altLabelStyleId:String;
      
      public var inputStyleId:String;
      
      public var paneStyle:Style;
      
      public var itemStyle:Style;
      
      public var buttonStyle:Style;
      
      public var unfocused;
      
      public var focused;
      
      public var focusedOver;
      
      public var error;
      
      public var up;
      
      public var down;
      
      public var over;
      
      public var selected;
      
      public var selectedOver;
      
      public var disabled;
      
      public var disabledOver;
      
      public var disabledSelected;
      
      public var disabledSelectedOver;
      
      public var filters:Array;
      
      public function Style(name:String, descriptor:Object, parent:Style, theme:Theme)
      {
         var prop:* = null;
         var s:Style = null;
         super();
         if(!name)
         {
            return;
         }
         if(!descriptor)
         {
            return;
         }
         if(!theme)
         {
            return;
         }
         this._parent = parent;
         this._descriptor = descriptor;
         this.name = name;
         this.fullyQualifiedName = this._parent == null?theme.name + "-" + this.name:this._parent.fullyQualifiedName + "-" + this.name;
         if(parent != null)
         {
            for(prop in parent._descriptor)
            {
               if(prop != "states" && prop != "styles")
               {
                  this.copyProperty(prop,parent);
               }
            }
         }
         for(prop in descriptor)
         {
            if(prop != "states" && prop != "styles")
            {
               this.copyProperty(prop,descriptor);
            }
         }
         if(descriptor.styles)
         {
            for(prop in descriptor.styles)
            {
               s = new Style(prop,descriptor.styles[prop],this,theme);
               this[prop] = s;
            }
         }
         if(descriptor.states)
         {
            for(prop in descriptor.states)
            {
               s = new Style(prop,descriptor.states[prop],this,theme);
               this[prop] = s;
            }
         }
         if(descriptor.css)
         {
            this.styleSheet = new StyleSheet();
            this.styleSheet.parseCSS(descriptor.css);
         }
      }
      
      public function get textFormat() : TextFormat
      {
         var face:String = this.fontFace == null?"aveneirLight":this.fontFace;
         var size:Number = !!isNaN(this.fontSize)?Number(12):Number(this.fontSize);
         var color:Number = !!isNaN(this.fontColor)?Number(0):Number(this.fontColor);
         var fmt:TextFormat = new TextFormat(face,size,color);
         fmt.align = this.fontAlign;
         fmt.leading = this.fontLeading;
         return fmt;
      }
      
      public function get subTextFormat() : TextFormat
      {
         var face:String = this.subFontFace == null?"aveneirLight":this.subFontFace;
         var size:Number = !!isNaN(this.subFontSize)?Number(10):Number(this.subFontSize);
         var color:Number = !!isNaN(this.subFontColor)?Number(0):Number(this.subFontColor);
         var fmt:TextFormat = new TextFormat(face,size,color);
         fmt.align = this.subFontAlign;
         fmt.leading = this.subFontLeading;
         return fmt;
      }
      
      public function copyProperty(prop:String, source:Object) : void
      {
         if(source && prop)
         {
            this[prop] = source[prop];
         }
      }
   }
}
