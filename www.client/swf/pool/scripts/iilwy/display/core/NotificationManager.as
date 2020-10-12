package iilwy.display.core
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.events.NotificationManagerEvent;
   import iilwy.events.QuizEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.model.ExternalSounds;
   import iilwy.model.dataobjects.quiz.QuizQuestion;
   import iilwy.model.dataobjects.quiz.enum.QuizQuestionType;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.EventNotificationType;
   import iilwy.ui.events.ConfirmationWindowEvent;
   import iilwy.ui.events.UiEvent;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.ui.utils.Margin;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.StageReference;
   import iilwy.utils.TextUtil;
   import iilwy.utils.UiRender;
   import iilwy.utils.logging.Logger;
   
   use namespace omgpop_internal;
   
   public class NotificationManager extends EventDispatcher
   {
       
      
      public var notificationsEnabled:Boolean = true;
      
      public var _itemFactory:ItemFactory;
      
      public var _items:Array;
      
      protected var _container:Sprite;
      
      protected var _holder:Sprite;
      
      protected var _holderMask:Sprite;
      
      protected var _hitArea:Sprite;
      
      protected var _hitAreaInner:Sprite;
      
      private var _position:String;
      
      public var defaultPosition:String;
      
      public var alternatePosition:String;
      
      public var itemPadding:Number = 5;
      
      public var maxItems:Number = 15;
      
      public var defaultMaxItems:Number = 15;
      
      public var _autoCloseItems:Array;
      
      protected var isFirstQuizQuestion:Boolean = true;
      
      protected var delayedQuizQuestion:NotificationManagerData;
      
      protected var quizQuestionDelayTimer:Timer;
      
      protected var numQuizQuestionsClosed:int;
      
      protected var quizQuestionCloseTimer:Timer;
      
      protected var _validateItemsTimer:Timer;
      
      protected var _logger:Logger;
      
      private var _eventTypeBlackList:Array;
      
      private var _eventTypeWhiteList:Array;
      
      private var _edge:Margin;
      
      private var _soundTimer:Timer;
      
      private var _pendingSound:String;
      
      public var floatingRect:Rectangle;
      
      public function NotificationManager()
      {
         this._position = ControlAlign.BOTTOM_RIGHT;
         this.defaultPosition = ControlAlign.BOTTOM_RIGHT;
         this.alternatePosition = ControlAlign.BOTTOM_LEFT;
         this._autoCloseItems = [];
         this._eventTypeBlackList = [];
         this._eventTypeWhiteList = [EventNotificationType.ACHIEVEMENT,EventNotificationType.BAN,EventNotificationType.COIN_DOWN,EventNotificationType.COIN_UP,EventNotificationType.EARNED_XP,EventNotificationType.GOLD_MEDAL,EventNotificationType.SILVER_MEDAL,EventNotificationType.BRONZE_MEDAL,EventNotificationType.LEVEL_UP,EventNotificationType.PRODUCT_PURCHASE,EventNotificationType.SUCCESSFUL_PHOTO_UPLOAD];
         this._edge = new Margin(10,36 + 10,10,45 + 10);
         this.floatingRect = new Rectangle();
         super();
         this._container = new Sprite();
         AppComponents.display.getLayer("notificationManager").addChild(this._container);
         this._hitArea = new Sprite();
         this._container.addChild(this._hitArea);
         this._hitArea.scaleX = 0;
         this._hitArea.scaleY = 0;
         this._hitAreaInner = new Sprite();
         this._hitArea.addChild(this._hitAreaInner);
         UiRender.renderRect(this._hitAreaInner,33488896,0,0,100,100);
         this._holder = new Sprite();
         this._container.addChild(this._holder);
         this._holderMask = new Sprite();
         UiRender.renderRect(this._holderMask,570490624,0,0,100,100);
         this._container.addChild(this._holderMask);
         this._holder.mask = this._holderMask;
         this._holder.addEventListener(NotificationManagerItem.EVENT_REMOVE,this.onItemRemove);
         this._holder.addEventListener(NotificationManagerItem.EVENT_AUTO_CLOSE,this.onItemAutoClose);
         this._holder.addEventListener(UiEvent.INVALIDATE_SIZE,this.onItemResize);
         this._itemFactory = new ItemFactory(NotificationManagerItem);
         this._items = new Array();
         this._validateItemsTimer = new Timer(50,1);
         this._validateItemsTimer.addEventListener(TimerEvent.TIMER,this.onValidateItems);
         this._container.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._logger = Logger.getLogger(this);
         this._logger.level = Logger.NONE;
         this._soundTimer = new Timer(10,1);
         this._soundTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSoundTimer);
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginStageChange);
         this.quizQuestionDelayTimer = new Timer(0,1);
         this.quizQuestionDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onQuizQuestionDelay);
         this.quizQuestionCloseTimer = new Timer(2 * 60 * 1000,1);
         this.quizQuestionCloseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onQuizQuestionCloseTimer);
         WindowManager.getInstance().addEventListener(Event.RESIZE,this.onApplicationResize);
         this.onApplicationResize(null);
      }
      
      public function destroy() : void
      {
      }
      
      public function get eventTypeWhiteList() : Array
      {
         return this._eventTypeWhiteList;
      }
      
      public function set edge(m:Margin) : void
      {
         this._edge = m;
         this.onApplicationResize(null);
      }
      
      protected function onApplicationResize(event:Event) : void
      {
         var rect:Rectangle = null;
         rect = new Rectangle(this._edge.left,this._edge.top,Math.round(WindowManager.width) - this._edge.horizontal,Math.round(WindowManager.height) - this._edge.vertical);
         this._holderMask.width = 270;
         this._holderMask.height = rect.height + 10;
         this._holderMask.y = rect.y - this.itemPadding;
         if(this._position == ControlAlign.TOP_RIGHT)
         {
            this._holder.x = rect.right;
            this._holder.y = rect.y;
            this._holderMask.x = rect.right - 260;
            this._hitAreaInner.x = -100;
            this._hitAreaInner.y = 0;
         }
         else if(this._position == ControlAlign.BOTTOM_RIGHT)
         {
            this._holder.x = rect.right;
            this._holder.y = rect.bottom;
            this._holderMask.x = rect.right - 260;
            this._hitAreaInner.x = -100;
            this._hitAreaInner.y = -100;
         }
         else if(this._position == ControlAlign.TOP_LEFT)
         {
            this._holder.x = rect.x;
            this._holder.y = rect.y;
            this._hitAreaInner.x = 0;
            this._hitAreaInner.y = 0;
            this._holderMask.x = rect.left - this.itemPadding;
         }
         else if(this._position == ControlAlign.BOTTOM_LEFT)
         {
            this._holder.x = rect.x;
            this._holder.y = rect.bottom;
            this._hitAreaInner.x = 0;
            this._hitAreaInner.y = -100;
            this._holderMask.x = rect.left - this.itemPadding;
         }
         this._hitArea.x = this._holder.x;
         this._hitArea.y = this._holder.y;
         this.invalidateItems();
      }
      
      public function addEventTypeToBlackList(str:String) : void
      {
         this._eventTypeBlackList.push(str);
      }
      
      public function addEventTypeToWhiteList(str:String) : void
      {
         this._eventTypeWhiteList.push(str);
      }
      
      public function showError(msg:String) : void
      {
         var data:NotificationManagerData = NotificationManagerData.createError(msg);
         data.message = msg;
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.playSound("error");
         this.flashMessage(msg);
         this.addItem(data);
      }
      
      public function showErrorConfirmation(callback:Function, header:String = null, message:String = null, yesLabel:String = "OK", noLabel:String = "Cancel") : void
      {
         var data:NotificationManagerData = NotificationManagerData.createError(message);
         data.type = EventNotificationType.ERROR_CONFIRMATION;
         data.autoCloseDelay = 20000;
         data.callback = callback;
         data.header = header;
         data.yesLabel = yesLabel;
         data.noLabel = noLabel;
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.playSound("error");
         this.flashMessage(message);
         this.addItem(data);
      }
      
      public function showConfirmation(msg:String) : void
      {
         var data:NotificationManagerData = NotificationManagerData.createConfirmation(msg);
         data.message = msg;
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.playSound("toneup");
         this.flashMessage(msg);
         this.addItem(data);
      }
      
      public function showNotification(msg:String) : void
      {
         var data:NotificationManagerData = NotificationManagerData.createConfirmation(msg);
         data.message = msg;
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.flashMessage(msg);
         this.addItem(data);
      }
      
      public function showRemoteNotification(data:NotificationManagerData) : void
      {
         var sound:String = null;
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.flashMessage(data.message);
         this.addItem(data);
         if(AppComponents.model.privateUser.isLoggedIn)
         {
            try
            {
               this.playSound(ExternalSounds.getSoundForEvent(data.type));
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            sound = data.data.e_type == EventNotificationType.ERROR?"error":"message";
            this.playSound(sound);
         }
      }
      
      public function showQuizQuestion(question:QuizQuestion, delay:Boolean = true) : void
      {
         var delayTime:Number = NaN;
         var data:NotificationManagerData = NotificationManagerData.createQuizQuestion(question);
         data.callback = this.onQuizQuestionCallback;
         this.delayedQuizQuestion = null;
         this.quizQuestionDelayTimer.stop();
         this.quizQuestionDelayTimer.reset();
         if(delay)
         {
            this.delayedQuizQuestion = data;
            delayTime = !!this.isFirstQuizQuestion?Number(30 * 1000):Number(5 * 1000);
            this.quizQuestionDelayTimer.delay = delayTime;
            this.quizQuestionDelayTimer.start();
         }
         else
         {
            this.showQuizQuestion(data);
         }
      }
      
      omgpop_internal function showQuizQuestion(data:NotificationManagerData) : void
      {
         if(!this.shouldShowItem(data))
         {
            return;
         }
         this.playSound("bubbles");
         this.addItem(data);
         this.isFirstQuizQuestion = false;
      }
      
      protected function onQuizQuestionCallback(event:ConfirmationWindowEvent) : void
      {
         if(event.type == ConfirmationWindowEvent.CLOSED && this.numQuizQuestionsClosed < 1 && (event.userInitiatedClose || event.automaticClose))
         {
            this.quizQuestionCloseTimer.start();
            this.numQuizQuestionsClosed++;
         }
         else
         {
            this.quizQuestionCloseTimer.stop();
            this.numQuizQuestionsClosed = 0;
         }
      }
      
      protected function onQuizQuestionCloseTimer(event:TimerEvent) : void
      {
         var quizEvent:QuizEvent = new QuizEvent(QuizEvent.GET_QUESTION,true,true);
         quizEvent.questionType = QuizQuestionType.YES_NO;
         StageReference.stage.dispatchEvent(quizEvent);
      }
      
      protected function onQuizQuestionDelay(event:TimerEvent) : void
      {
         this.showQuizQuestion(this.delayedQuizQuestion);
      }
      
      protected function onLoginStageChange(event:UserDataEvent) : void
      {
         this.isFirstQuizQuestion = true;
         this.delayedQuizQuestion = null;
         this.quizQuestionDelayTimer.stop();
         this.quizQuestionDelayTimer.reset();
         this.numQuizQuestionsClosed = 0;
         this.quizQuestionCloseTimer.stop();
         this.quizQuestionCloseTimer.reset();
      }
      
      public function showItem(data:NotificationManagerData) : void
      {
         this.flashMessage(data.message);
         this.addItem(data);
      }
      
      protected function shouldShowItem(data:NotificationManagerData) : Boolean
      {
         var whiteListIndex:int = 0;
         var blackListIndex:int = 0;
         var show:Boolean = true;
         if(!data.suppressable)
         {
            return show;
         }
         if(!this.notificationsEnabled)
         {
            whiteListIndex = this._eventTypeWhiteList.indexOf(data.type);
            if(whiteListIndex < 0)
            {
               show = false;
            }
         }
         else
         {
            blackListIndex = this._eventTypeBlackList.indexOf(data.type);
            if(blackListIndex >= 0)
            {
               show = false;
            }
         }
         if(!show)
         {
            this._logger.log("Blocking event type: ",data.type);
         }
         return show;
      }
      
      protected function flashMessage(str:String) : void
      {
         var msg:String = null;
         if(AppComponents.gamenetManager.currentMatch.isActive() && !AppComponents.gamenetManager.currentMatch.open)
         {
            return;
         }
         try
         {
            msg = TextUtil.prettyText(str);
            msg = TextUtil.clipText(msg,60);
            ExternalInterface.call("flashMessage",msg);
         }
         catch(e:Error)
         {
            _logger.error(e.message);
         }
      }
      
      public function get position() : String
      {
         return this._position;
      }
      
      public function set position(s:String) : void
      {
         this._position = s;
         this.onApplicationResize(null);
      }
      
      public function resetDefaults() : void
      {
         this.notificationsEnabled = true;
         this.position = this.defaultPosition;
         this.maxItems = this.defaultMaxItems;
      }
      
      protected function onSoundTimer(event:TimerEvent) : void
      {
         AppComponents.soundManager.playSound(this._pendingSound);
      }
      
      protected function playSound(id:String) : void
      {
         if(!id)
         {
            return;
         }
         this._pendingSound = id;
         this._soundTimer.reset();
         this._soundTimer.start();
      }
      
      protected function onItemAutoClose(event:Event) : void
      {
         var item:NotificationManagerItem = event.target as NotificationManagerItem;
         var mPoint:Point = new Point(this._holder.mouseX,this._holder.mouseY);
         var inside:Boolean = this._hitArea.hitTestPoint(this._container.mouseX,this._container.mouseY);
         var index:Number = this._items.indexOf(item);
         this._logger.log("Autoclose attempt for item ",index,"mouse is at ",this._container.mouseX,this._container.mouseY);
         if(!inside)
         {
            this._logger.log("Mouse outside");
            item.close(true,false,true);
         }
         else if(this.getVerticalDir() > 0)
         {
            this._logger.log("Direction down",item.y,"|",this._holder.mouseY);
            if(item.y > this._holder.mouseY)
            {
               item.close(true,false,true);
            }
            else
            {
               this._autoCloseItems.push(item);
            }
         }
         else
         {
            this._logger.log("Direction up",item.y,"|",this._holder.mouseY);
            if(item.y + item.height < this._holder.mouseY)
            {
               item.close(true,false,true);
            }
            else
            {
               this._autoCloseItems.push(item);
            }
         }
         dispatchEvent(new NotificationManagerEvent(NotificationManagerEvent.NOTIFICATION_REMOVED,true));
      }
      
      protected function onItemRemove(event:Event) : void
      {
         var index:int = 0;
         var item:NotificationManagerItem = null;
         index = this._items.indexOf(event.target);
         if(index >= 0)
         {
            item = this._items[index];
            this._items.splice(index,1);
            this._holder.removeChild(event.target as NotificationManagerItem);
            item.data = null;
            this._itemFactory.recycleItem(item);
         }
         this.floatingRect = new Rectangle(this._holder.x,this._holder.y,this._holder.width,this._holder.height);
         dispatchEvent(new NotificationManagerEvent(NotificationManagerEvent.NOTIFICATION_REMOVED,true));
         this.invalidateItems();
      }
      
      protected function addItem(data:NotificationManagerData) : NotificationManagerItem
      {
         var item:NotificationManagerItem = this._itemFactory.createItem();
         item.data = data;
         this.removeEquivalentItems(data);
         this._items.unshift(item);
         this._holder.addChild(item);
         if(this._position == ControlAlign.TOP_RIGHT)
         {
            item.y = -item.height - this.itemPadding;
            item.x = -item.width;
         }
         else if(this._position == ControlAlign.BOTTOM_RIGHT)
         {
            item.y = this.itemPadding;
            item.x = -item.width;
         }
         else if(this._position == ControlAlign.TOP_LEFT)
         {
            item.y = -item.height - this.itemPadding;
            item.x = 0;
         }
         else if(this._position == ControlAlign.BOTTOM_LEFT)
         {
            item.y = this.itemPadding;
            item.x = 0;
         }
         if(this._items.length > this.maxItems)
         {
            NotificationManagerItem(this._items[this.maxItems]).close();
         }
         item.visible = false;
         this.invalidateItems();
         this.floatingRect = new Rectangle(this._holder.x,this._holder.y,this._holder.width,this._holder.height);
         dispatchEvent(new NotificationManagerEvent(NotificationManagerEvent.NOTIFCATION_ADDED,true));
         return item;
      }
      
      protected function removeItem(item:NotificationManagerItem) : void
      {
      }
      
      protected function removeEquivalentItems(data:NotificationManagerData) : void
      {
         var item:NotificationManagerItem = null;
         for each(item in this._items)
         {
            if(data.equivalent(item.data))
            {
               item.close();
            }
         }
      }
      
      protected function invalidateItems() : void
      {
         this._validateItemsTimer.start();
      }
      
      protected function onValidateItems(event:Event) : void
      {
         this.positionItems();
      }
      
      protected function onItemResize(event:UiEvent) : void
      {
         if(event.target is NotificationManagerItem)
         {
            this.invalidateItems();
         }
      }
      
      protected function positionItems() : void
      {
         var y:Number = NaN;
         var item:NotificationManagerItem = null;
         var vDir:int = 0;
         var hDir:int = 0;
         var pad:Number = this.itemPadding;
         if(this._position == ControlAlign.TOP_RIGHT)
         {
            vDir = 1;
            hDir = -1;
         }
         else if(this._position == ControlAlign.BOTTOM_RIGHT)
         {
            vDir = -1;
            hDir = -1;
         }
         else if(this._position == ControlAlign.TOP_LEFT)
         {
            vDir = 1;
            hDir = 1;
         }
         else if(this._position == ControlAlign.BOTTOM_LEFT)
         {
            vDir = -1;
            hDir = 1;
         }
         y = 0;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i];
            item.visible = true;
            if(vDir == -1)
            {
               y = y - item.height;
               if(i != 0)
               {
                  y = y - pad;
               }
            }
            item.tweenTo(y);
            if(hDir == -1)
            {
               item.x = -item.width;
            }
            else
            {
               item.x = 0;
            }
            if(vDir == 1)
            {
               y = y + item.height;
               y = y + pad;
            }
         }
         this._hitArea.scaleX = this._holder.width / 100;
         this._hitArea.scaleY = Math.abs(y) / 100;
      }
      
      protected function onRollOut(event:Event) : void
      {
         var item:NotificationManagerItem = null;
         this._logger.log("Autoclosing",this._autoCloseItems.length,"items");
         for each(item in this._autoCloseItems)
         {
            item.resetAutoCloseTimer();
         }
         this._autoCloseItems.splice(0,this._autoCloseItems.length);
      }
      
      protected function getVerticalDir() : Number
      {
         var vDir:int = 0;
         var hDir:int = 0;
         if(this._position == ControlAlign.TOP_RIGHT)
         {
            vDir = 1;
            hDir = -1;
         }
         else if(this._position == ControlAlign.BOTTOM_RIGHT)
         {
            vDir = -1;
            hDir = -1;
         }
         else if(this._position == ControlAlign.TOP_LEFT)
         {
            vDir = 1;
            hDir = 1;
         }
         else if(this._position == ControlAlign.BOTTOM_LEFT)
         {
            vDir = -1;
            hDir = 1;
         }
         return vDir;
      }
   }
}
