package iilwy.ui.partials
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.text.TextFieldType;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.display.core.FocusManager;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.ui.controls.LabelInputSet;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.EmbedUtil;
   
   public class ShareLinkDisplay extends LabelInputSet
   {
       
      
      public var confirmTooltip:String = "Copied!";
      
      public var confirmNotification:String = null;
      
      private var _tooltipTimer:Timer;
      
      public var trackString:String = "";
      
      public function ShareLinkDisplay(label:String)
      {
         super(label,ControlAlign.LEFT,"smallWhite","simpleTextInput_white");
         this.backgroundColor = 855638016;
         this.setPadding(3,3,3,8);
         this.height = 20;
         this.input.width = 100;
         this.input.fontSize = 10;
         this.label.selectable = false;
         this.label.buttonMode = false;
         this.label.margin.right = 5;
         this.cornerRadius = 20;
         this.buttonMode = true;
         this.input.field.type = TextFieldType.DYNAMIC;
         input.useFocusGlow = false;
         this._tooltipTimer = new Timer(1000,1);
         this._tooltipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTooltipTimer);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function set url(s:String) : void
      {
         s = s.replace(/^\//,"");
         trace("**********Debug mode: " + AppProperties.debugMode);
         input.text = DataUtil.getInviteLinkBaseURL() + s;
      }
      
      public function set embedCode(s:String) : void
      {
         input.text = EmbedUtil.embedCode(s,437,637);
      }
      
      override public function set height(n:Number) : void
      {
         super.height = n;
         cornerRadius = n;
      }
      
      public function set inputWidth(n:Number) : void
      {
         input.width = n;
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function onClick(event:Event) : void
      {
         input.field.setSelection(input.field.length,0);
         input.field.scrollH = 0;
         FocusManager.getInstance().setStageFocus(input);
         input.showError(this.confirmTooltip);
         this._tooltipTimer.reset();
         this._tooltipTimer.start();
         input.useFocusGlow = false;
         AppComponents.analytics.trackAction("shareLink/click/" + this.trackString);
      }
      
      protected function onMouseDown(event:Event) : void
      {
         System.setClipboard(input.text);
         if(this.confirmNotification)
         {
            AppComponents.notificationManager.showConfirmation(this.confirmNotification);
         }
      }
      
      protected function onTooltipTimer(event:TimerEvent) : void
      {
         input.hideError();
      }
   }
}
