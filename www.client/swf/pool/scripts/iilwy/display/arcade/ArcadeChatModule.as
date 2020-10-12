package iilwy.display.arcade
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.application.EmbedSettings;
   import iilwy.events.CollectionEvent;
   import iilwy.gamenet.model.ChatData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.gamenet.model.RoomData;
   import iilwy.ui.containers.ListView;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.LiteButton;
   import iilwy.ui.controls.TextInput;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.partials.scrollgroups.TextBlockScrollGroup;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.TextUtil;
   
   public class ArcadeChatModule extends UiModule
   {
      
      protected static var commonEntryText:String;
       
      
      private var _lobby:RoomData;
      
      protected var _scrollGroup:TextBlockScrollGroup;
      
      protected var _textInput:TextInput;
      
      protected var _listView:ListView;
      
      protected var _testButton:LiteButton;
      
      protected var _chatColors:Array;
      
      protected var _chatUserColorLookup:Object;
      
      protected var _mouseSprite:Sprite;
      
      protected var _notificationColors:Array;
      
      protected var lastMessageTime:int;
      
      protected const minimumInterval:int = 1000;
      
      protected var offenses:int;
      
      protected const offenseLimit:int = 3;
      
      protected const offenderTimeOut:int = 30000;
      
      protected var offenserWaitStart:int;
      
      protected var muteState:Boolean;
      
      protected var reenableChatTimer:Timer;
      
      protected var playerChatColor:String = "#333333";
      
      protected var guestChatColor:String = "#cccccc";
      
      protected var lastMessageTimes:Array;
      
      public var useCommonEntryText:Boolean = true;
      
      public function ArcadeChatModule()
      {
         this._chatUserColorLookup = {};
         this.lastMessageTimes = [-99999,-99999,-99999];
         super();
         percentWidth = 100;
         percentHeight = 100;
         this._chatColors = ["#178AD3","#D31762","#a953de","#ccc37d","#ff8435","#62e9e0","#ff0000","#80c235"];
         this._notificationColors = ["#888888","#333333"];
         this._mouseSprite = new Sprite();
         this._mouseSprite.x = 5;
         addChild(this._mouseSprite);
         this._textInput = new TextInput();
         this.offenses = 0;
         this.muteState = false;
      }
      
      override public function createChildren() : void
      {
         this._scrollGroup = new TextBlockScrollGroup();
         addContentChild(this._scrollGroup);
         this._scrollGroup.textBlock.htmlText = "";
         this._scrollGroup.textBlock.setStyleById("cssBlock");
         this._scrollGroup.textBlock.cachePolicy = false;
         this._scrollGroup.textBlock.defaultLinkHandling = false;
         this._scrollGroup.textBlock.addEventListener(TextEvent.LINK,this.onTextClicked);
         this._scrollGroup.textBlock.enableScrollWheel();
         if(EmbedSettings.getInstance().enableArcadeChat)
         {
            addContentChild(this._textInput);
            this._textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.onTextInputKeyDown);
         }
         if(this.useCommonEntryText)
         {
            this._textInput.text = commonEntryText;
         }
         this.reenableChatTimer = new Timer(this.offenderTimeOut);
         this.reenableChatTimer.addEventListener(TimerEvent.TIMER,this.reenableChat);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.reenableChatTimer && this.reenableChatTimer.running)
         {
            this.reenableChatTimer.stop();
         }
         if(this.reenableChatTimer)
         {
            this.reenableChatTimer.removeEventListener(TimerEvent.TIMER,this.reenableChat);
         }
      }
      
      protected function findPlayer(profileId:String) : PlayerData
      {
         var player:PlayerData = this._lobby.players.findPlayerByProfileId(profileId);
         return player;
      }
      
      protected function onTextClicked(event:flash.events.TextEvent) : void
      {
         var profileId:String = null;
         var player:PlayerData = null;
         var textEvent:iilwy.events.TextEvent = null;
         var match:* = event.text.match(/^profileContextMenu/);
         if(match)
         {
            profileId = event.text.match(/^profileContextMenu\/(\w+)/)[1];
            player = this.findPlayer(profileId);
            if(player == null)
            {
            }
            if(player != null)
            {
               this._mouseSprite.y = mouseY;
               AppComponents.contextMenuManager.showPlayerContextMenu(player,this._mouseSprite,ControlAlign.LEFT_BOTTOM);
            }
            event.stopImmediatePropagation();
         }
         else
         {
            textEvent = new iilwy.events.TextEvent(TextEvent.TEXT_LINK_CLICKED,true,true);
            textEvent.text = event.text;
            dispatchEvent(textEvent);
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this._scrollGroup.width = unscaledWidth;
         if(contains(this._textInput))
         {
            this._scrollGroup.height = unscaledHeight - this._textInput.height - 5;
            this._scrollGroup.visible = this._scrollGroup.height > 20;
            this._textInput.width = unscaledWidth;
            this._textInput.y = unscaledHeight - this._textInput.height;
         }
         else
         {
            this._scrollGroup.height = unscaledHeight;
         }
      }
      
      override public function commitProperties() : void
      {
      }
      
      public function set lobby(l:RoomData) : void
      {
         if(this._lobby != null)
         {
            this._scrollGroup.textBlock.htmlText = "";
            this._lobby.chatMessages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessagesChanged);
         }
         if(l != null)
         {
            this._lobby = l;
            this._lobby.chatMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessagesChanged,false,0,true);
         }
      }
      
      protected function sendMessage(msg:String) : void
      {
         var waitseconds:int = 0;
         var wait:int = 0;
         var isoffensive:Boolean = false;
         var diff:int = 0;
         var waitTime:int = 0;
         if(this.muteState)
         {
            wait = getTimer() - this.offenserWaitStart;
            if(wait > this.offenderTimeOut)
            {
               AppComponents.alertManager.showWarning("Chat reactivated");
               this.muteState = false;
            }
         }
         if(!this.muteState)
         {
            isoffensive = AppComponents.textOffendCheck.isOffensive(msg);
            trace("OFFENSE CHECK: " + isoffensive);
            if(isoffensive)
            {
               waitseconds = this.offenderTimeOut / 1000;
               AppComponents.alertManager.showWarning("Watch your language, chat disabled for " + waitseconds + " seconds");
               this.muteState = true;
               this.offenserWaitStart = getTimer();
               this.reenableChatTimer.reset();
               this.reenableChatTimer.start();
               return;
            }
            diff = getTimer() - this.lastMessageTimes[0];
            if(diff < this.minimumInterval)
            {
               waitTime = this.minimumInterval / 1000;
               AppComponents.alertManager.showWarning("Wait " + waitTime + " second between messages");
               this.offenses++;
               if(this.offenses > this.offenseLimit)
               {
                  this.reenableChatTimer = new Timer(waitseconds);
                  waitseconds = this.offenderTimeOut / 1000;
                  AppComponents.alertManager.showError("Chat disabled for " + waitseconds + " seconds");
                  this.offenses = 0;
                  this.muteState = true;
                  this.offenserWaitStart = getTimer();
                  this.reenableChatTimer.reset();
                  this.reenableChatTimer.start();
               }
            }
            else
            {
               this.actuallySend(msg);
               this.offenses = 0;
            }
         }
         this.lastMessageTimes.shift();
         this.lastMessageTimes.push(getTimer());
      }
      
      protected function reenableChat(e:TimerEvent) : void
      {
         this.reenableChatTimer.stop();
         if(this.muteState)
         {
            AppComponents.alertManager.showWarning("Chat reactivated");
            this.muteState = false;
         }
      }
      
      protected function actuallySend(msg:String) : void
      {
         this._lobby.sendChat(msg.substr(0,150));
      }
      
      protected function onTextInputKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            if(this._textInput.text.length > 0)
            {
               this.sendMessage(this._textInput.text);
               this._textInput.text = "";
               commonEntryText = "";
            }
         }
         commonEntryText = this._textInput.text;
      }
      
      protected function onMessagesChanged(event:CollectionEvent) : void
      {
         var chat:ChatData = null;
         var formatted:String = null;
         var msg:String = null;
         var atBottom:Boolean = false;
         var col:String = null;
         var chatcol:String = null;
         if(event.kind == CollectionEvent.KIND_ADD)
         {
            chat = event.items[0] as ChatData;
            if(chat.player != null && chat.player.profileName != null)
            {
               if(EmbedSettings.getInstance().enableArcadeChat)
               {
                  msg = TextUtil.prettyText(chat.message,false,chat.player.userId);
                  col = this.getChatColorForProfile(chat.player.profileName);
                  chatcol = chat.player.profileId != null?this.playerChatColor:this.guestChatColor;
                  formatted = "<a class = \'noUnderlineLink\' href = \'event:profileContextMenu/" + chat.player.profileId + "\'>" + "<font color=\'" + col + "\'>" + chat.player.profileName + ":</font></a> ";
                  if(!chat.muted)
                  {
                     formatted = formatted + ("<font color=\'" + chatcol + "\'>" + msg + "</font>" + "</p>");
                  }
                  formatted = "<p>" + formatted + "</p>";
               }
            }
            else if(chat.type == ChatData.TYPE_PROMO)
            {
               formatted = "<p><br/><font color=\'#9273be\' face=\'aveneirBold\'/>Site message:</font></p>";
               formatted = formatted + ("<p><font color=\'#000000\'>" + chat.message + "</font></p><br/>");
            }
            else
            {
               msg = TextUtil.prettyText(chat.message,true);
               col = this._notificationColors.shift();
               this._notificationColors.push(col);
               formatted = "<p><font color=\'" + col + "\'>" + msg + "</font></p>";
            }
            atBottom = false;
            if(this._scrollGroup.textBlock.scrollAmount >= 0.99 || this._scrollGroup.textBlock.scrollAmount == 0)
            {
               atBottom = true;
            }
            if(formatted)
            {
               this._scrollGroup.textBlock.htmlText = this._scrollGroup.textBlock.htmlText + formatted;
            }
            if(atBottom)
            {
               this._scrollGroup.textBlock.scrollAmount = 1;
            }
         }
         else if(event.kind == CollectionEvent.KIND_RESET)
         {
            this._scrollGroup.textBlock.htmlText = "";
         }
      }
      
      protected function onTestButtonClick(event:ButtonEvent) : void
      {
         this._lobby.testAddChat("sup biiitch");
      }
      
      protected function getChatColorForProfile(id:String) : String
      {
         var col:String = "#999999";
         if(id != null && this._chatUserColorLookup[id] == null)
         {
            col = this._chatColors.shift();
            this._chatColors.push(col);
            this._chatUserColorLookup[id] = col;
         }
         return this._chatUserColorLookup[id];
      }
      
      public function get textInput() : TextInput
      {
         return this._textInput;
      }
      
      protected function onAdded(event:Event) : void
      {
         if(childrenCreated)
         {
            if(this.useCommonEntryText)
            {
               this._textInput.text = commonEntryText;
               this._textInput.dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      protected function onRemoved(event:Event) : void
      {
      }
      
      override public function set visible(b:Boolean) : void
      {
         super.visible = b;
         if(this.useCommonEntryText && childrenCreated)
         {
            if(b)
            {
               this._textInput.text = commonEntryText;
               this._textInput.dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
   }
}
