package iilwy.ui.controls
{
   import iilwy.ui.containers.Window;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ContainerEvent;
   
   public class ErrorWindow extends Window
   {
       
      
      private var _headerBlock:TextBlock;
      
      private var _messageBlock:TextBlock;
      
      private var _okButton:BevelButton;
      
      private var _message:String;
      
      private var _header:String;
      
      public function ErrorWindow(title:String = null, width:Number = 400, height:Number = undefined, styleId:String = "errorWindow")
      {
         super(title,0,0,width,height,styleId);
         minimizable = false;
         resizable = false;
         chromelessBottom = true;
         this._headerBlock = new TextBlock("",0,0,10,undefined,"strong");
         addContentChild(this._headerBlock);
         this._messageBlock = new TextBlock("",0,0);
         addContentChild(this._messageBlock);
         this._okButton = new BevelButton("");
         this._okButton.width = 100;
         addContentChild(this._okButton);
         this._okButton.addEventListener(ButtonEvent.CLICK,this.onButtonClicked);
         setChromePadding(_topBarHeight,0,0,0);
         this.width = width;
      }
      
      override public function destroy() : void
      {
         graphics.clear();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var w:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var y:Number = 0;
         if(this._header != null)
         {
            y = y + Math.round(this._headerBlock.height);
         }
         if(this._message != null)
         {
            this._messageBlock.y = y;
            y = y + Math.round(this._messageBlock.height);
         }
         w = calculateInnerWidth(unscaledWidth);
         var h:Number = calculateInnerHeight(unscaledHeight);
         this._okButton.y = h - this._okButton.height;
         var x:Number = w;
         x = x - this._okButton.width;
         this._okButton.x = x;
      }
      
      override public function set width(n:Number) : void
      {
         super.width = n;
         if(this._messageBlock != null)
         {
            this._messageBlock.width = innerWidth;
         }
         if(this._headerBlock != null)
         {
            this._headerBlock.width = innerWidth;
         }
      }
      
      override public function measure() : void
      {
         super.measure();
         var h:Number = 130;
         if(this._header != null)
         {
            this._headerBlock.text = this._header;
            h = h + this._headerBlock.height;
         }
         else
         {
            this._headerBlock.text = null;
         }
         if(this._message != null)
         {
            this._messageBlock.text = this._message;
            h = h + this._messageBlock.height;
         }
         else
         {
            this._messageBlock.text = null;
         }
         measuredHeight = Math.round(h);
      }
      
      protected function onButtonClicked(event:ButtonEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(s:String) : void
      {
         this._message = s;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get header() : String
      {
         return this._header;
      }
      
      public function set header(s:String) : void
      {
         this._header = s;
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get buttonLabel() : String
      {
         return this._okButton.label;
      }
      
      public function set buttonLabel(s:String) : void
      {
         this._okButton.label = s;
      }
   }
}
