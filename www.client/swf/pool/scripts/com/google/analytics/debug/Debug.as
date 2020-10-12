package com.google.analytics.debug
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class Debug extends Label
   {
      
      public static var count:uint;
       
      
      private var _lines:Array;
      
      private var _linediff:int = 0;
      
      private var _preferredForcedWidth:uint = 540;
      
      public var maxLines:uint = 16;
      
      public function Debug(color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
      {
         if(alignement == null)
         {
            alignement = Align.bottom;
         }
         super("","uiLabel",color,alignement,stickToEdge);
         this.name = "Debug" + count++;
         this._lines = [];
         selectable = true;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
      }
      
      override public function get forcedWidth() : uint
      {
         if(this.parent)
         {
            if(UISprite(this.parent).forcedWidth > this._preferredForcedWidth)
            {
               return this._preferredForcedWidth;
            }
            return UISprite(this.parent).forcedWidth;
         }
         return super.forcedWidth;
      }
      
      override protected function dispose() : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         super.dispose();
      }
      
      private function onKey(event:KeyboardEvent = null) : void
      {
         var lines:Array = null;
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
               lines = this._getLinesToDisplay(1);
               break;
            case Keyboard.UP:
               lines = this._getLinesToDisplay(-1);
               break;
            default:
               lines = null;
         }
         if(lines == null)
         {
            return;
         }
         text = lines.join("\n");
      }
      
      private function _getLinesToDisplay(direction:int = 0) : Array
      {
         var lines:Array = null;
         var start:uint = 0;
         var end:uint = 0;
         if(this._lines.length - 1 > this.maxLines)
         {
            if(this._linediff <= 0)
            {
               this._linediff = this._linediff + direction;
            }
            else if(this._linediff > 0 && direction < 0)
            {
               this._linediff = this._linediff + direction;
            }
            start = this._lines.length - this.maxLines + this._linediff;
            end = start + this.maxLines;
            lines = this._lines.slice(start,end);
         }
         else
         {
            lines = this._lines;
         }
         return lines;
      }
      
      public function close() : void
      {
         this.dispose();
      }
      
      public function write(message:String, bold:Boolean = false) : void
      {
         var inputLines:Array = null;
         if(message.indexOf("") > -1)
         {
            inputLines = message.split("\n");
         }
         else
         {
            inputLines = [message];
         }
         var pre:String = "";
         var post:String = "";
         if(bold)
         {
            pre = "<b>";
            post = "</b>";
         }
         for(var i:int = 0; i < inputLines.length; i++)
         {
            this._lines.push(pre + inputLines[i] + post);
         }
         var lines:Array = this._getLinesToDisplay();
         text = lines.join("\n");
      }
      
      public function writeBold(message:String) : void
      {
         this.write(message,true);
      }
   }
}
