package iilwy.debug
{
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.ScrollableTextInput;
   import iilwy.ui.controls.Scrollbar;
   
   public class Console extends UiModule
   {
       
      
      private var _block:ScrollableTextInput;
      
      private var _scrollbar:Scrollbar;
      
      private var _field:TextField;
      
      public function Console()
      {
         super();
         this._field = new TextField();
         this._field.type = TextFieldType.INPUT;
         addChild(this._field);
         this._field.height = 400;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
         this._field.multiline = true;
         this._field.wordWrap = true;
         var fmt:TextFormat = new TextFormat("Courier",11);
         fmt.leading = 3;
         this._field.defaultTextFormat = fmt;
         percentWidth = 100;
         percentHeight = 100;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         this._field.width = w;
         this._field.height = h;
      }
      
      public function appendText(... args) : void
      {
         var prop:* = null;
         if(stage == null)
         {
            return;
         }
         this._field.appendText("\n");
         for(prop in args)
         {
            this._field.appendText(args[prop] + " ");
         }
         this._field.scrollV = this._field.maxScrollV;
      }
      
      public function forceAppendText(... args) : void
      {
         var prop:* = null;
         this._field.appendText("\n");
         for(prop in args)
         {
            this._field.appendText(args[prop] + " ");
         }
         this._field.scrollV = this._field.maxScrollV;
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         var value:Number = event.delta < 0?Number(-3):Number(3);
         try
         {
            this._field.scrollV = this._field.scrollV - value;
         }
         catch(e:Error)
         {
         }
      }
      
      public function scrollToTop() : void
      {
         this._field.scrollV = 0;
      }
   }
}
