package iilwy.ui.controls
{
   import iilwy.ui.containers.Window;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ConfirmationWindowEvent;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.utils.FocusGroupSpriteProxy;
   
   public class ConfirmationWindow extends Window
   {
      
      public static const LABEL_OK:String = "OK";
      
      public static const LABEL_CANCEL:String = "CANCEL";
      
      public static const LABEL_REMEMBER:String = "Don\'t ask me again.";
       
      
      private var _headerBlock:TextBlock;
      
      private var _messageBlock:TextBlock;
      
      private var _yesButton:BevelButton;
      
      private var _noButton:BevelButton;
      
      private var _checkbox:CheckBox;
      
      private var _message:String;
      
      private var _header:String;
      
      public var buttonOrder:String;
      
      public var callback:Function;
      
      public var suppressAutoClose:Boolean;
      
      public function ConfirmationWindow(title:String = null, width:Number = 400, height:Number = undefined, styleId:String = "window")
      {
         super(title,0,0,width,height,"window");
         minimizable = false;
         resizable = false;
         chromelessBottom = true;
         this._headerBlock = new TextBlock("",0,0,10,undefined,"strong");
         addContentChild(this._headerBlock);
         this._messageBlock = new TextBlock("",0,0,10,undefined,"cssBlock");
         addContentChild(this._messageBlock);
         this._yesButton = new BevelButton("");
         this._yesButton.minWidth = 100;
         this._yesButton.setPadding(0,20,0,20);
         addContentChild(this._yesButton);
         this._noButton = new BevelButton("");
         this._noButton.setPadding(0,20,0,20);
         this._noButton.minWidth = 100;
         addContentChild(this._noButton);
         this._checkbox = new CheckBox();
         addContentChild(this._checkbox);
         this._yesButton.addEventListener(ButtonEvent.CLICK,this.onYesButtonClicked);
         this._noButton.addEventListener(ButtonEvent.CLICK,this.onNoButtonClicked);
         setChromePadding(_topBarHeight,0,0,0);
         _focusGroupProxy = new FocusGroupSpriteProxy();
         _focusGroupProxy.addSprite(content);
         this._yesButton.hilight = true;
         _focusGroupProxy.defaultFocus = this._yesButton;
         this.width = width;
         this.suppressAutoClose = false;
      }
      
      override public function destroy() : void
      {
         graphics.clear();
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var w:Number = NaN;
         var x:Number = NaN;
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
         if(this.checkboxLabel != null)
         {
            y = y + 15;
            this._checkbox.y = y;
            this._checkbox.visible = true;
         }
         else
         {
            this._checkbox.visible = false;
         }
         w = calculateInnerWidth(unscaledWidth);
         var h:Number = calculateInnerHeight(unscaledHeight);
         this._yesButton.y = h - this._yesButton.height;
         this._noButton.y = h - this._noButton.height;
         x = w;
         if(this.buttonOrder == "REVERSE" || this.buttonOrder == "RANDOM" && Math.random() >= 0.5)
         {
            x = x - this._noButton.width;
            this._noButton.x = x;
            x = x - (this._yesButton.width + 10);
            this._yesButton.x = x;
         }
         else
         {
            x = x - this._yesButton.width;
            this._yesButton.x = x;
            x = x - (this._noButton.width + 10);
            this._noButton.x = x;
         }
         this._noButton.visible = this.noLabel != null;
         this._yesButton.visible = this.yesLabel != null;
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
            this._messageBlock.text = "<p>" + this._message + "</p>";
            h = h + this._messageBlock.height;
         }
         else
         {
            this._messageBlock.text = null;
         }
         if(this.checkboxLabel != null)
         {
            h = h + (16 + 15);
         }
         measuredHeight = Math.round(h);
      }
      
      override protected function onCloseClick(event:ButtonEvent) : void
      {
         var evt:ConfirmationWindowEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.CLOSED);
         evt.checkboxSelected = this._checkbox.selected;
         dispatchEvent(evt);
         if(this.callback != null)
         {
            this.callback(evt);
            this.callback = null;
         }
         this.reset();
         super.onCloseClick(event);
      }
      
      protected function onYesButtonClicked(event:ButtonEvent) : void
      {
         var evt:ConfirmationWindowEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.YES);
         evt.checkboxSelected = this._checkbox.selected;
         dispatchEvent(evt);
         if(this.callback != null)
         {
            this.callback(evt);
            this.callback = null;
         }
         if(this.suppressAutoClose)
         {
            this.suppressAutoClose = false;
         }
         else
         {
            dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
         }
         this.reset();
      }
      
      protected function onNoButtonClicked(event:ButtonEvent) : void
      {
         var evt:ConfirmationWindowEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.NO);
         evt.checkboxSelected = this._checkbox.selected;
         dispatchEvent(evt);
         if(this.callback != null)
         {
            this.callback(evt);
            this.callback = null;
         }
         if(this.suppressAutoClose)
         {
            this.suppressAutoClose = false;
         }
         else
         {
            dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
         }
         this.reset();
      }
      
      public function reset() : void
      {
         this._checkbox.selected = false;
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
      
      public function get noLabel() : String
      {
         return this._noButton.label;
      }
      
      public function set noLabel(s:String) : void
      {
         this._noButton.label = s;
         invalidateDisplayList();
      }
      
      public function get yesLabel() : String
      {
         return this._yesButton.label;
      }
      
      public function set yesLabel(s:String) : void
      {
         this._yesButton.label = s;
         invalidateDisplayList();
      }
      
      public function get checkboxLabel() : String
      {
         return this._checkbox.label;
      }
      
      public function set checkboxLabel(s:String) : void
      {
         this._checkbox.label = s;
      }
   }
}
