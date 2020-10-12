package com.google.analytics.debug
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   
   public class Label extends UISprite
   {
      
      public static var count:uint = 0;
       
      
      private var _background:Shape;
      
      private var _textField:TextField;
      
      private var _text:String;
      
      private var _tag:String;
      
      private var _color:uint;
      
      protected var selectable:Boolean;
      
      public var stickToEdge:Boolean;
      
      public function Label(text:String = "", tag:String = "uiLabel", color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
      {
         super();
         this.name = "Label" + count++;
         this.selectable = false;
         this._background = new Shape();
         this._textField = new TextField();
         this._text = text;
         this._tag = tag;
         if(alignement == null)
         {
            alignement = Align.none;
         }
         this.alignement = alignement;
         this.stickToEdge = stickToEdge;
         if(color == 0)
         {
            color = Style.backgroundColor;
         }
         this._color = color;
         this._textField.addEventListener(TextEvent.LINK,this.onLink);
      }
      
      override protected function layout() : void
      {
         this._textField.type = TextFieldType.DYNAMIC;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.background = false;
         this._textField.selectable = this.selectable;
         this._textField.multiline = true;
         this._textField.styleSheet = Style.sheet;
         this.text = this._text;
         addChild(this._background);
         addChild(this._textField);
      }
      
      override protected function dispose() : void
      {
         this._textField.removeEventListener(TextEvent.LINK,this.onLink);
         super.dispose();
      }
      
      private function _draw() : void
      {
         var g:Graphics = this._background.graphics;
         g.clear();
         g.beginFill(this._color);
         var W:uint = this._textField.width;
         var H:uint = this._textField.height;
         if(forcedWidth > 0)
         {
            W = forcedWidth;
         }
         Background.drawRounded(this,g,W,H);
         g.endFill();
      }
      
      public function get tag() : String
      {
         return this._tag;
      }
      
      public function set tag(value:String) : void
      {
         this._tag = value;
         this.text = "";
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function set text(value:String) : void
      {
         if(value == "")
         {
            value = this._text;
         }
         this._textField.htmlText = "<span class=\"" + this.tag + "\">" + value + "</span>";
         this._text = value;
         this._draw();
         resize();
      }
      
      public function appendText(value:String, newtag:String = "") : void
      {
         if(value == "")
         {
            return;
         }
         if(newtag == "")
         {
            newtag = this.tag;
         }
         this._textField.htmlText = this._textField.htmlText + ("<span class=\"" + newtag + "\">" + value + "</span>");
         this._text = this._text + value;
         this._draw();
         resize();
      }
      
      public function onLink(event:TextEvent) : void
      {
      }
   }
}
