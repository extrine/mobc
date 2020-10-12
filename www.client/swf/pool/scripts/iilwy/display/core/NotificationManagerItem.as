package iilwy.display.core
{
   import caurina.transitions.Tweener;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import iilwy.display.drawing.DrawingThumbnail;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.QuizEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.quiz.QuizQuestion;
   import iilwy.model.dataobjects.quiz.enum.QuizQuestionType;
   import iilwy.net.EventNotificationType;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.ButtonSet;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.Image;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ConfirmationWindowEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.utils.UiRender;
   
   public class NotificationManagerItem extends UiContainer
   {
      
      protected static var staticFilter:DropShadowFilter;
      
      protected static var iconFilter:DropShadowFilter;
      
      public static var EVENT_REMOVE:String = "notificationManagerItemEvent.remove";
      
      public static var EVENT_AUTO_CLOSE:String = "notificationManagerItemEvent.autoClose";
      
      protected static var _actionLookup;
       
      
      private var _background:Sprite;
      
      private var _data:NotificationManagerData;
      
      protected var _contentList:List;
      
      protected var _headerBlock:TextBlock;
      
      protected var _messageBlock:TextBlock;
      
      protected var _closeButton:IconButton;
      
      protected var _image:Image;
      
      protected var _drawingThumbnail:DrawingThumbnail;
      
      protected var _autoCloseTimer:Timer;
      
      protected var _buttonSet:ButtonSet;
      
      public function NotificationManagerItem()
      {
         super();
         this._autoCloseTimer = new Timer(999999,1);
         this._autoCloseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAutoClose);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function createChildren() : void
      {
         setPadding(5,3,5,7);
         setChromePadding(2,21,2,2);
         this._background = new Sprite();
         UiRender.renderRoundRect(this._background,2583691263,0,0,100,100,20);
         UiRender.renderGradient(this._background,[2583691263,2868903935],Math.PI / 2,2,2,96,96,18);
         this._background.scale9Grid = new Rectangle(10,10,80,80);
         addContentChild(this._background);
         if(staticFilter == null)
         {
            staticFilter = new DropShadowFilter(2,90,0,0.4,10,10,1,1,false,false,false);
            iconFilter = new DropShadowFilter(2,90,0,0.3,4,4,1,1);
         }
         this._background.filters = [staticFilter];
         this._closeButton = new IconButton(GraphicManager.iconX1,0,0,16,16,"iconButtonReverse");
         addContentChild(this._closeButton);
         this._closeButton.addEventListener(ButtonEvent.CLICK,this.onCloseClicked);
         this._contentList = new List();
         addContentChild(this._contentList);
         this._headerBlock = new TextBlock("",0,0,200,undefined,"notificationHeader");
         addContentChild(this._headerBlock);
         this._headerBlock.margin.bottom = -4;
         this._contentList.addContentChild(this._headerBlock);
         this._messageBlock = new TextBlock("",0,0,200,undefined,"notificationMessage");
         this._messageBlock.margin.top = -2;
         this._contentList.addContentChild(this._messageBlock);
         this._image = new Image(0,0,30,30);
         this._image.resizeMode = Image.RESIZE_STRETCH;
         addContentChild(this._image);
         this._drawingThumbnail = new DrawingThumbnail(0,0,120,75);
         this._drawingThumbnail.margin.bottom = 5;
         this._contentList.addContentChild(this._drawingThumbnail);
         this._drawingThumbnail.addOpenInLightboxHandler();
         this._buttonSet = new ButtonSet(0,0,24,ListDirection.HORIZONTAL,"notificationButtonSet");
         this._contentList.addContentChild(this._buttonSet);
      }
      
      override public function commitProperties() : void
      {
         this._drawingThumbnail.visible = false;
         this._drawingThumbnail.includeInLayout = false;
         this._headerBlock.visible = false;
         this._headerBlock.includeInLayout = false;
         this._messageBlock.visible = false;
         this._messageBlock.includeInLayout = false;
         this._buttonSet.visible = false;
         this._buttonSet.includeInLayout = false;
         this._buttonSet.removeAll();
         if(this._data == null)
         {
            this._headerBlock.htmlText = null;
            this._messageBlock.htmlText = null;
            this._image.url = null;
         }
         else
         {
            if(this._data.header && this._data.header.length > 0)
            {
               this._headerBlock.htmlText = this._data.header;
               this._headerBlock.visible = true;
               this._headerBlock.includeInLayout = true;
            }
            else
            {
               this._headerBlock.htmlText = null;
            }
            if(this._data.message && this._data.message.length > 0)
            {
               this._messageBlock.htmlText = this._data.message;
               this._messageBlock.visible = true;
               this._messageBlock.includeInLayout = true;
            }
            else
            {
               this._messageBlock.htmlText = null;
            }
            if(this._data.hasIconImage)
            {
               this._image.borderColor = 33554431;
               this._image.borderSize = 0;
               this._image.filters = [iconFilter];
            }
            else
            {
               this._image.borderColor = 1711276032;
               this._image.borderSize = 1;
               this._image.filters = [];
            }
            this._image.url = this._data.image;
            if(this._data.drawing)
            {
               this._drawingThumbnail.data = this._data.drawing;
               this._drawingThumbnail.visible = true;
               this._drawingThumbnail.includeInLayout = true;
            }
            else
            {
               this._drawingThumbnail.data = null;
            }
            if(this._data.type == EventNotificationType.QUIZ_QUESTION)
            {
               this._buttonSet.addItem("YES","yes");
               this._buttonSet.addItem("NO","no");
               this._buttonSet.visible = true;
               this._buttonSet.includeInLayout = true;
               this._buttonSet.addEventListener(MultiSelectEvent.SELECT,this.onButtonSetSelect,false,0,true);
            }
            else if(this._data.type == EventNotificationType.ERROR_CONFIRMATION)
            {
               this._buttonSet.addItem(this.data.yesLabel,"yes");
               this._buttonSet.addItem(this.data.noLabel,"no");
               this._buttonSet.visible = true;
               this._buttonSet.includeInLayout = true;
               this._buttonSet.addEventListener(MultiSelectEvent.SELECT,this.onButtonSetSelect,false,0,true);
            }
            this._contentList.invalidateSize();
            this._autoCloseTimer.delay = this._data.autoCloseDelay;
            this._autoCloseTimer.reset();
            this._autoCloseTimer.start();
         }
         this._image.x = padding.left + chromePadding.left;
         this._contentList.x = this._image.x + this._image.width + 5;
      }
      
      override public function measure() : void
      {
         measuredWidth = 260;
         this._headerBlock.width = measuredWidth - this._contentList.x - padding.right - chromePadding.right;
         this._messageBlock.width = measuredWidth - this._contentList.x - padding.right - chromePadding.right;
         if(this._buttonSet.includeInLayout)
         {
            this._buttonSet.setMargin(Math.max(this._image.height - this._headerBlock.height - this._messageBlock.height,0),0,0,measuredWidth - this._contentList.x - this._buttonSet.width - 2 - 4);
         }
         if(this._drawingThumbnail.includeInLayout)
         {
            this._drawingThumbnail.margin.top = Math.max(this._image.height - this._messageBlock.height,0);
         }
         measuredHeight = Math.max(this._image.height,this._contentList.height) + padding.top + padding.bottom + chromePadding.top + chromePadding.bottom;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._background.width = unscaledWidth;
         this._background.height = unscaledHeight;
         this._image.y = padding.top + chromePadding.top;
         if(this._contentList.height < this._image.height)
         {
            this._contentList.y = this._image.y + Math.floor(this._image.height / 2 - this._contentList.height / 2);
         }
         else
         {
            this._contentList.y = padding.top + chromePadding.top;
         }
         this._headerBlock.width = unscaledWidth - this._contentList.x - padding.right - chromePadding.right;
         this._messageBlock.width = unscaledWidth - this._contentList.x - padding.right - chromePadding.right;
         this._closeButton.x = unscaledWidth - this._closeButton.width - 5;
         this._closeButton.y = 5;
      }
      
      public function get data() : NotificationManagerData
      {
         return this._data;
      }
      
      public function set data(d:NotificationManagerData) : void
      {
         Tweener.removeTweens(this);
         alpha = 1;
         this._data = d;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         this._autoCloseTimer.stop();
      }
      
      public function tweenTo(yPos:Number) : void
      {
         Tweener.addTween(this,{
            "y":yPos,
            "time":0.3,
            "transition":"easeOutCubic",
            "delay":0,
            "rounded":true
         });
      }
      
      protected function onAutoClose(event:TimerEvent) : void
      {
         dispatchEvent(new Event(EVENT_AUTO_CLOSE,true));
      }
      
      protected function onCloseClicked(event:ButtonEvent) : void
      {
         this.close(true,true);
      }
      
      public function close(transition:Boolean = true, userInitiated:Boolean = false, automatic:Boolean = false) : void
      {
         this._autoCloseTimer.stop();
         Tweener.addTween(this,{
            "alpha":0,
            "time":0.3,
            "transition":"easeinoutCubic",
            "delay":0,
            "onComplete":this.onClose,
            "onCompleteParams":[userInitiated,automatic]
         });
      }
      
      public function onClose(userInitiated:Boolean, automatic:Boolean) : void
      {
         var confirmationEvent:ConfirmationWindowEvent = null;
         if(this.data.callback is Function)
         {
            confirmationEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.CLOSED);
            confirmationEvent.userInitiatedClose = userInitiated;
            confirmationEvent.automaticClose = automatic;
            this.data.callback(confirmationEvent);
         }
         dispatchEvent(new Event(EVENT_REMOVE,true));
      }
      
      public function resetAutoCloseTimer() : void
      {
         this._autoCloseTimer.reset();
         this._autoCloseTimer.start();
      }
      
      public function onClick(event:MouseEvent) : void
      {
         if(event.target != this._drawingThumbnail && event.target != this._closeButton && !this._buttonSet.contains(event.target as DisplayObject))
         {
            this.doAction();
         }
      }
      
      public function onButtonSetSelect(event:MultiSelectEvent) : void
      {
         var aEvt:ApplicationEvent = null;
         var question:QuizQuestion = null;
         var answerEvent:QuizEvent = null;
         var questionEvent:QuizEvent = null;
         var confirmationEvent:ConfirmationWindowEvent = null;
         if(this._data.type == EventNotificationType.QUIZ_QUESTION)
         {
            this._buttonSet.setEnabledByID("yes",false);
            this._buttonSet.setEnabledByID("no",false);
            question = new QuizQuestion();
            question.id = QuizQuestion(this._data.data).id;
            question.userAnswers = [event.value];
            answerEvent = new QuizEvent(QuizEvent.RECORD_ANSWER,true,true);
            answerEvent.question = question;
            dispatchEvent(answerEvent);
            this.close();
            questionEvent = new QuizEvent(QuizEvent.GET_QUESTION,true,true);
            questionEvent.questionType = QuizQuestionType.YES_NO;
            dispatchEvent(questionEvent);
         }
         else if(this._data.type == EventNotificationType.ERROR_CONFIRMATION)
         {
            if(event.value == "yes")
            {
               confirmationEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.YES);
            }
            else
            {
               confirmationEvent = new ConfirmationWindowEvent(ConfirmationWindowEvent.NO);
            }
            this.close();
            this.data.callback(confirmationEvent);
         }
      }
      
      protected function doAction() : void
      {
         if(_actionLookup == null)
         {
            _actionLookup = {};
            _actionLookup[EventNotificationType.CONTACT_LOGGED_IN] = this.openMiniProfile;
            _actionLookup[EventNotificationType.FRIEND_LOGS_IN] = this.openMiniProfile;
         }
         var action:Function = _actionLookup[this._data.type];
         if(action == null)
         {
            if(this._data.link != null)
            {
               action = this.followLink;
            }
         }
         if(action != null)
         {
            action();
         }
      }
      
      public function openMiniProfile() : void
      {
         var appEvent:ApplicationEvent = new ApplicationEvent(ApplicationEvent.PROFILE_SHOW_MINI);
         var pData:ProfileData = ProfileData.createFromMerbResult(this.data.data.user);
         appEvent.profileData = pData;
         dispatchEvent(appEvent);
      }
      
      public function followLink() : void
      {
         var sendEvent:ApplicationEvent = null;
         if(this._data.link.indexOf("http") == 0)
         {
            sendEvent = new ApplicationEvent(ApplicationEvent.NAVIGATE_TO_URL);
            sendEvent.data = this._data.link;
         }
         else
         {
            sendEvent = new ApplicationEvent(ApplicationEvent.SHOW_PAGE);
            sendEvent.id = this._data.link;
         }
         dispatchEvent(sendEvent);
         this.close();
      }
   }
}
