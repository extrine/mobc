package iilwy.display.chat.views
{
   import com.adobe.utils.StringUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.NetStatusEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatManager;
   import iilwy.chat.ChatRoomManager;
   import iilwy.chat.VoiceChatManager;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.DictionaryCollection;
   import iilwy.display.chat.listitems.ChatRoomButtonListItem;
   import iilwy.display.chat.listitems.ChatRoomUserListItem;
   import iilwy.display.core.FocusManager;
   import iilwy.events.ChatEvent;
   import iilwy.events.CollectionEvent;
   import iilwy.gamenet.utils.DataUtil;
   import iilwy.model.dataobjects.chat.ChatMessage;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.chat.extensions.jingle.JingleAction;
   import iilwy.model.dataobjects.chat.extensions.jingle.JingleExtension;
   import iilwy.model.dataobjects.user.CrewUser;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.net.NetStatusInfo;
   import iilwy.ui.containers.Canvas;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.DisplayButton;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.controls.TextInput;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.partials.scrollgroups.ListViewScrollGroup;
   import iilwy.ui.partials.scrollgroups.TextBlockScrollGroup;
   import iilwy.ui.utils.ControlAlign;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.TextUtil;
   import iilwy.utils.UiRender;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   public class ChatView extends UiContainer
   {
       
      
      protected const MIN_CONCURRENT_MESSAGE_INTERVAL:int = 1000;
      
      protected const MIN_SIMILAR_MESSAGE_INTERVAL:int = 20000;
      
      protected const MIN_UPDATE_INTERVAL:int = 120000;
      
      protected const MAX_CONCURRENT_MESSAGES:int = 3;
      
      protected const MAX_SIMILAR_MESSAGES:int = 4;
      
      protected const OFFENDER_TIMEOUT:int = 30000;
      
      protected const MAX_OFFENSES:int = 3;
      
      protected const NUM_SENT_MESSAGES_TO_TRACK:int = 20;
      
      protected const MAX_CHARACTERS:int = 200;
      
      protected var roomUsersBG:Sprite;
      
      protected var divider:Sprite;
      
      protected var roomUsersGroup:ListViewScrollGroup;
      
      protected var messageScrollGroup:TextBlockScrollGroup;
      
      protected var _messageInput:TextInput;
      
      protected var roomListHolder:Canvas;
      
      protected var roomList:List;
      
      protected var addRoomButton:IconButton;
      
      protected var mouseSprite:Sprite;
      
      protected var chatManager:ChatManager;
      
      protected var chatRoomManager:ChatRoomManager;
      
      protected var voiceChatManager:VoiceChatManager;
      
      protected var chatRoom:ChatRoom;
      
      protected var userFactory:ItemFactory;
      
      protected var usersValid:Boolean = true;
      
      protected var messagesValid:Boolean = true;
      
      protected var roomFactory:ItemFactory;
      
      protected var roomsValid:Boolean = true;
      
      protected var roomButtons:Dictionary;
      
      protected var lastMessage:String = "";
      
      protected var lastMessageTime:int;
      
      protected var lastUpdateTime:int;
      
      protected var offenderStartTime:int;
      
      protected var offenses:int;
      
      protected var reenableChatTimer:Timer;
      
      protected var muteState:Boolean;
      
      protected var numConcurrentMessages:int;
      
      protected var numSimilarMessages:int;
      
      protected var numSentMessages:int;
      
      protected var selectedRoomButton:String;
      
      protected var selectedRoomValid:Boolean = true;
      
      protected var profileColors:Array;
      
      protected var profileColorsToChooseFrom:Array;
      
      protected var profileColorsDict:Dictionary;
      
      protected var ctrlPressed:Boolean;
      
      protected var _userDataProvider:DictionaryCollection;
      
      protected var _messageDataProvider:ArrayCollection;
      
      protected var _roomDataProvider:DictionaryCollection;
      
      protected var privilegedUsers:Array;
      
      public function ChatView()
      {
         this.privilegedUsers = ["3670962"];
         super();
         setPadding(10);
         this.chatManager = AppComponents.chatManager;
         this.chatRoomManager = AppComponents.chatRoomManager;
         this.voiceChatManager = AppComponents.voiceChatManager;
         this.userFactory = new ItemFactory(ChatRoomUserListItem);
         this.roomFactory = new ItemFactory(ChatRoomButtonListItem);
         this.profileColors = [1542867,13834082,11097054,13419389,16745525,6482400,16711680,8438325];
         this.profileColorsToChooseFrom = this.profileColors.slice();
         this.profileColorsDict = new Dictionary();
         this.reenableChatTimer = new Timer(this.OFFENDER_TIMEOUT,1);
         this.reenableChatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onReenableChat);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function get messageInput() : TextInput
      {
         return this._messageInput;
      }
      
      public function set userDataProvider(value:DictionaryCollection) : void
      {
         if(this._userDataProvider != null)
         {
            this._userDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onUserCollectionChange);
            this._userDataProvider = null;
         }
         if(value)
         {
            this._userDataProvider = value;
            this._userDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onUserCollectionChange,false,0,true);
         }
         this.usersValid = false;
         invalidateProperties();
      }
      
      public function set messageDataProvider(value:ArrayCollection) : void
      {
         if(this._messageDataProvider != null)
         {
            this._messageDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessageCollectionChange);
            this._messageDataProvider = null;
         }
         if(value)
         {
            this._messageDataProvider = value;
            this._messageDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessageCollectionChange,false,0,true);
         }
         this.messagesValid = false;
         invalidateProperties();
      }
      
      public function set roomDataProvider(value:DictionaryCollection) : void
      {
         if(this._roomDataProvider != null)
         {
            this._roomDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange);
            this._roomDataProvider = null;
         }
         if(value)
         {
            this._roomDataProvider = value;
            this._roomDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange,false,0,true);
         }
         this.roomsValid = false;
         invalidateProperties();
      }
      
      public function setRoom(chatRoomJIDNode:String) : void
      {
         var newChatRoom:ChatRoom = null;
         try
         {
            newChatRoom = this.chatRoomManager.rooms.getItemAtKey(chatRoomJIDNode);
         }
         catch(error:Error)
         {
         }
         if(!newChatRoom)
         {
            return;
         }
         if(this.chatRoom)
         {
            this.chatRoom.removeEventListener(RoomEvent.SUBJECT_CHANGE,this.onSubjectChange);
         }
         this.chatRoom = newChatRoom;
         this.chatRoom.addEventListener(RoomEvent.SUBJECT_CHANGE,this.onSubjectChange,false,0,true);
         this.userDataProvider = this.chatRoom.users;
         this.messageDataProvider = this.chatRoom.messages;
         this.roomDataProvider = this.chatRoomManager.rooms;
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.UPDATE_CHAT_ROOM);
         chatEvent.chatRoom = this.chatRoom;
         dispatchEvent(chatEvent);
         this.chatRoomManager.updateChatUserStatus(this.chatRoom);
         if(this.roomButtons && DisplayButton(this.roomButtons[this.chatRoom.jidNode]))
         {
            DisplayButton(this.roomButtons[this.chatRoom.jidNode]).setStyleById("simpleButtonBottomTab");
         }
         this.selectedRoomValid = false;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function createChildren() : void
      {
         this.roomUsersBG = new Sprite();
         this.roomUsersBG.graphics.beginFill(15658734);
         this.roomUsersBG.graphics.drawRect(0,0,100,100);
         this.roomUsersBG.graphics.endFill();
         addContentChild(this.roomUsersBG);
         this.divider = new Sprite();
         UiRender.renderGradient(this.divider,[15066597,12895428],0,0,0,3,100);
         addContentChild(this.divider);
         this.roomUsersGroup = new ListViewScrollGroup(ChatRoomUserListItem);
         this.roomUsersGroup.listView.scrollIncrement = 30;
         this.roomUsersGroup.listView.itemPadding = 3;
         this.roomUsersGroup.listView.itemHeight = 30;
         this.roomUsersGroup.listView.listenForMouseWheel();
         this.roomUsersGroup.scrollbar.width = 12;
         addContentChild(this.roomUsersGroup);
         this.messageScrollGroup = new TextBlockScrollGroup();
         this.messageScrollGroup.textBlock.setStyleById("cssBlock");
         this.messageScrollGroup.textBlock.cachePolicy = false;
         this.messageScrollGroup.textBlock.defaultLinkHandling = false;
         this.messageScrollGroup.textBlock.fixScrollPosition = true;
         this.messageScrollGroup.textBlock.enableScrollWheel();
         this.messageScrollGroup.textBlock.addEventListener(TextEvent.LINK,this.onTextClicked);
         addContentChild(this.messageScrollGroup);
         this._messageInput = new TextInput();
         this._messageInput.maxChars = this.MAX_CHARACTERS;
         this._messageInput.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown,false,0,true);
         this._messageInput.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp,false,0,true);
         this._messageInput.addEventListener(TextEvent.TEXT_INPUT,this.onInputText,false,0,true);
         addContentChild(this._messageInput);
         FocusManager.getInstance().setStageFocus(this._messageInput);
         this.roomListHolder = new Canvas();
         addContentChild(this.roomListHolder);
         this.roomList = new List();
         this.roomList.direction = ListDirection.HORIZONTAL;
         this.roomList.itemPadding = 0;
         this.roomListHolder.addContentChild(this.roomList);
         this.mouseSprite = new Sprite();
         addChild(this.mouseSprite);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         xPos = 0;
         yPos = 0;
         var gap:Number = 5;
         var roomUserWidth:Number = 130;
         var dividerGap:Number = 2;
         var messageInputHeight:Number = 30;
         this.roomUsersBG.x = xPos;
         this.roomUsersBG.y = yPos;
         this.roomUsersBG.width = roomUserWidth + padding.left + dividerGap;
         this.roomUsersBG.height = unscaledHeight;
         xPos = xPos + padding.left;
         this.roomUsersGroup.x = xPos;
         this.roomUsersGroup.y = yPos + padding.top;
         this.roomUsersGroup.width = roomUserWidth;
         this.roomUsersGroup.height = unscaledHeight - padding.vertical;
         xPos = xPos + (roomUserWidth + dividerGap);
         this.divider.height = unscaledHeight;
         this.divider.x = xPos;
         this.divider.y = yPos;
         xPos = xPos + (this.divider.width + gap);
         yPos = yPos + padding.top;
         this.messageScrollGroup.width = unscaledWidth - xPos - padding.right;
         this.messageScrollGroup.height = unscaledHeight - messageInputHeight - gap - padding.vertical;
         this.messageScrollGroup.x = xPos;
         this.messageScrollGroup.y = yPos;
         yPos = yPos + (this.messageScrollGroup.height + gap);
         this._messageInput.width = this.messageScrollGroup.width;
         this._messageInput.height = messageInputHeight;
         this._messageInput.x = xPos;
         this._messageInput.y = yPos;
         yPos = unscaledHeight;
         this.roomListHolder.width = unscaledWidth;
         this.roomListHolder.x = 2;
         this.roomListHolder.y = yPos;
         this.mouseSprite.x = xPos + 5;
      }
      
      override public function commitProperties() : void
      {
         if(!this.usersValid)
         {
            this.usersValid = true;
            this.clearUsers();
            if(this._userDataProvider)
            {
               this.buildUsers();
            }
         }
         if(!this.messagesValid)
         {
            this.messagesValid = true;
            this.clearMessages();
            if(this._messageDataProvider)
            {
               this.addMessages();
            }
         }
         if(!this.roomsValid)
         {
            this.roomsValid = true;
            this.clearRooms();
            if(this._roomDataProvider)
            {
               this.buildRooms();
            }
         }
         if(!this.selectedRoomValid)
         {
            this.selectedRoomValid = true;
            this.setSelectedRoomButton();
         }
      }
      
      protected function sendMessage() : void
      {
         var send:Boolean = false;
         var currentTime:int = 0;
         var updateInterval:int = 0;
         var messageInterval:int = 0;
         var waitTime:int = 0;
         if(this.muteState)
         {
            return;
         }
         var message:String = StringUtil.trim(this._messageInput.text);
         if(message.length > 0)
         {
            send = true;
            currentTime = getTimer();
            updateInterval = currentTime - this.lastUpdateTime;
            if(updateInterval > this.MIN_UPDATE_INTERVAL)
            {
               this.chatRoomManager.updateChatUserStatus(this.chatRoom);
               this.lastUpdateTime = currentTime;
            }
            messageInterval = currentTime - this.lastMessageTime;
            if(messageInterval < this.MIN_CONCURRENT_MESSAGE_INTERVAL)
            {
               this.numConcurrentMessages++;
               if(this.numConcurrentMessages >= this.MAX_CONCURRENT_MESSAGES)
               {
                  this.offenses++;
                  if(this.offenses > this.MAX_OFFENSES)
                  {
                     waitTime = this.OFFENDER_TIMEOUT * 0.001;
                     AppComponents.alertManager.showError("Chat disabled for " + waitTime + " seconds");
                     this.muteState = true;
                     this.reenableChatTimer.reset();
                     this.reenableChatTimer.start();
                  }
                  else
                  {
                     waitTime = this.MIN_CONCURRENT_MESSAGE_INTERVAL * 0.001;
                     AppComponents.alertManager.showWarning("Wait " + waitTime + " " + TextUtil.makePlural("second",waitTime) + " between messages");
                  }
                  send = false;
               }
            }
            if(messageInterval < this.MIN_SIMILAR_MESSAGE_INTERVAL && message.substr(0,4) == this.lastMessage.substr(0,4))
            {
               this.numSimilarMessages++;
               if(this.numSimilarMessages >= this.MAX_SIMILAR_MESSAGES)
               {
                  this.offenses++;
                  if(this.offenses > this.MAX_OFFENSES)
                  {
                     waitTime = this.OFFENDER_TIMEOUT * 0.001;
                     AppComponents.alertManager.showError("Chat disabled for " + waitTime + " seconds");
                     this.muteState = true;
                     this.reenableChatTimer.reset();
                     this.reenableChatTimer.start();
                  }
                  else
                  {
                     waitTime = this.MIN_SIMILAR_MESSAGE_INTERVAL * 0.001;
                     AppComponents.alertManager.showWarning("Wait " + waitTime + " " + TextUtil.makePlural("second",waitTime) + " between similar messages");
                  }
                  send = false;
               }
            }
            if(send)
            {
               this.numSentMessages++;
               this.lastMessage = message;
               message = AppComponents.textOffendCheck.screenOffensive(message.slice(0,this.MAX_CHARACTERS - 1));
               this.trackSentMessage(message);
               this.chatRoom.sendMessage(message);
               this.lastMessageTime = currentTime;
            }
         }
      }
      
      protected function trackSentMessage(body:String) : void
      {
         var path:String = null;
         var subPath:Array = null;
         var firstSubPath:String = null;
         var secondSubPath:String = null;
         var inviteLink:String = null;
         var params:* = undefined;
         var gameID:String = null;
         var chatroomName:String = null;
         if(this.numSentMessages == 1 || this.numSentMessages % this.NUM_SENT_MESSAGES_TO_TRACK == 0)
         {
            AppComponents.analytics.trackAction("chatroom/message/send/" + this.numSentMessages);
         }
         var internalURLInfo:Object = TextUtil.internalURLPattern.exec(body);
         if(internalURLInfo && (internalURLInfo as Array).length > 0)
         {
            path = (internalURLInfo as Array)[4];
            subPath = path.split("/");
            subPath.shift();
            firstSubPath = subPath.shift();
            if(firstSubPath == "#")
            {
               firstSubPath = subPath.shift();
            }
            secondSubPath = subPath.shift();
            if(firstSubPath == "arcade" && secondSubPath == "invite_to_match")
            {
               inviteLink = subPath.shift();
               params = DataUtil.parseInviteLink(inviteLink);
               gameID = DataUtil.getGameIdFromMatchName(params.matchName);
               AppComponents.analytics.trackAction("chatroom/message/invite/game/" + gameID);
            }
            else if(firstSubPath == "chatrooms")
            {
               chatroomName = secondSubPath;
               AppComponents.analytics.trackAction("chatroom/message/invite/room/" + chatroomName);
            }
         }
      }
      
      protected function updateMessagePosition() : void
      {
         var atBottom:Boolean = false;
         if(this.messageScrollGroup.textBlock.scrollAmount >= 0.99 || this.messageScrollGroup.textBlock.scrollAmount == 0)
         {
            atBottom = true;
         }
         if(atBottom)
         {
            this.messageScrollGroup.textBlock.scrollAmount = 1;
         }
      }
      
      protected function addUser(index:int) : void
      {
         if(!childrenCreated)
         {
            return;
         }
         var chatRoomUser:ChatRoomUser = new ChatRoomUser(this._userDataProvider.getItemAt(index),this.chatRoom);
         this.roomUsersGroup.listView.data.addItem(chatRoomUser);
      }
      
      protected function removeUser(index:int) : void
      {
         if(!childrenCreated)
         {
            return;
         }
         this.roomUsersGroup.listView.data.removeItemAt(index);
      }
      
      protected function buildUsers() : void
      {
         var item:ChatRoomUserListItem = null;
         if(!childrenCreated)
         {
            return;
         }
         for(var i:int = 0; i < this._userDataProvider.length; i++)
         {
            this.addUser(i);
         }
      }
      
      protected function clearUsers() : void
      {
         if(!childrenCreated)
         {
            return;
         }
         this.roomUsersGroup.listView.data.removeAll();
         this.roomUsersGroup.listView.scrollAmount = 0;
      }
      
      protected function addMessages() : void
      {
         var message:ChatMessage = null;
         var isSystem:Boolean = false;
         var isCrew:Boolean = false;
         var isBot:Boolean = false;
         var isPrivileged:Boolean = false;
         var isMuted:Boolean = false;
         var userText:String = null;
         var messageHexColor:String = null;
         var messageText:String = null;
         var profileName:String = null;
         var profileNamePattern:RegExp = null;
         var text:String = null;
         if(!childrenCreated)
         {
            return;
         }
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
         var messageLength:int = this._messageDataProvider.length;
         var msgDataProviderArray:Array = this._messageDataProvider.source;
         var sourceArrayLength:int = msgDataProviderArray.length;
         for(var i:int = 0; i < messageLength; i++)
         {
            if(i >= sourceArrayLength)
            {
               throw new Error();
            }
            message = msgDataProviderArray[i] as ChatMessage;
            if(message.text)
            {
               if(message.user)
               {
                  if(this.profileColorsDict[message.user.userID] == undefined)
                  {
                     this.profileColorsDict[message.user.userID] = message.user.nameColor = this.getNextProfileColor();
                  }
                  else
                  {
                     message.user.nameColor = this.profileColorsDict[message.user.userID];
                  }
               }
               isSystem = !message.user;
               isCrew = message.user && CrewUser.getByUserID(int(message.user.jid.node));
               isBot = message.user && message.user.jid.node == "0";
               isPrivileged = message.user && this.privilegedUsers.indexOf(message.user.jid.node) > -1;
               isMuted = Boolean(message.user)?Boolean(AppComponents.model.privateUser.isProfileMuted(message.user.profileID)):Boolean(false);
               userText = Boolean(message.user)?"<a class=\'noUnderlineLink\' href=\'event:profileContextMenu/" + message.user.profileID + "\'>" + "<font color=\'#" + message.getHexColor(message.user.nameColor) + "\'>" + message.user.asProfileData().displayName + ":</font></a> ":"";
               messageHexColor = Boolean(message.user)?message.getHexColor(message.user.messageColor):message.getHexColor(message.color);
               if(!(isMuted && !isCrew && !isBot))
               {
                  if(isSystem || isBot || isCrew)
                  {
                     messageText = TextUtil.prettyText(message.text,true);
                  }
                  else if(isPrivileged)
                  {
                     messageText = TextUtil.prettyText("<font size=\"20\" color=\"#000000\"><strong>" + message.text + "</strong></font>",true);
                  }
                  else
                  {
                     messageText = TextUtil.prettyText(message.text,false,message.user.userID);
                  }
                  profileName = AppComponents.model.privateUser.profile.profile_name;
                  profileNamePattern = new RegExp("(^|\\(|\\<|\\>|@|\\s)(" + profileName + ")(\\s|:|,|\\.|-|\\)|\\>|\\<|\\;|\\\'|$)","g");
                  if(message.user && message.user.displayName != profileName)
                  {
                     messageText = messageText.replace(profileNamePattern,this.boldProfile);
                  }
                  text = userText + "<font color=\'#" + messageHexColor + "\'>" + messageText + "</font>";
                  text = "<p>" + text + "</p>";
                  this.messageScrollGroup.textBlock.htmlText = this.messageScrollGroup.textBlock.htmlText + text;
               }
            }
         }
         this.updateMessagePosition();
      }
      
      protected function boldProfile() : String
      {
         var args:Array = arguments;
         var preProfile:String = arguments[1];
         var profile:String = "<strong>" + arguments[2] + "</strong>";
         var postProfile:String = arguments[3];
         return preProfile + profile + postProfile;
      }
      
      protected function clearMessages() : void
      {
         if(!childrenCreated)
         {
            return;
         }
         this.messageScrollGroup.textBlock.htmlText = "";
      }
      
      protected function buildRooms() : void
      {
         var item:ChatRoomButtonListItem = null;
         var room:ChatRoom = null;
         if(!childrenCreated)
         {
            return;
         }
         this.roomButtons = new Dictionary();
         for(var i:int = 0; i < this._roomDataProvider.length; i++)
         {
            room = this._roomDataProvider.getItemAt(i) as ChatRoom;
            item = this.roomFactory.createItem();
            item.data = room;
            item.selected = false;
            this.roomList.addContentChild(item);
            this.roomButtons[room.jidNode] = item.openButton;
         }
      }
      
      protected function clearRooms() : void
      {
         var item:ChatRoomButtonListItem = null;
         if(!childrenCreated)
         {
            return;
         }
         var items:Array = this.roomList.clearContentChildren(false);
         for each(item in items)
         {
            item.data = null;
         }
         this.roomFactory.recyleItems(items);
      }
      
      protected function setSelectedRoomButton() : void
      {
         var button:DisplayButton = null;
         var roomButton:DisplayButton = null;
         if(!this.roomButtons)
         {
            return;
         }
         var roomJIDNode:String = this.chatRoom.jidNode;
         button = DisplayButton(this.roomButtons[this.selectedRoomButton]);
         if(!roomJIDNode)
         {
            try
            {
               button.selected = false;
               this.selectedRoomButton = null;
            }
            catch(error:Error)
            {
            }
            return;
         }
         if(button)
         {
            button.selected = false;
         }
         for each(roomButton in this.roomButtons)
         {
            if(roomButton.selected)
            {
               roomButton.selected = false;
            }
         }
         button = DisplayButton(this.roomButtons[roomJIDNode]);
         if(button)
         {
            button.selected = true;
         }
         this.selectedRoomButton = roomJIDNode;
      }
      
      protected function getNextProfileColor() : uint
      {
         if(this.profileColorsToChooseFrom.length <= 0)
         {
            this.profileColorsToChooseFrom = this.profileColors.slice();
         }
         return this.profileColorsToChooseFrom.shift();
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         this.usersValid = false;
         this.messagesValid = false;
         this.roomsValid = false;
         invalidateProperties();
         this.chatRoomManager.addEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage);
         this.voiceChatManager.addEventListener(NetStatusEvent.NET_STATUS,this.onVoiceNetStatus);
         this.voiceChatManager.addEventListener(ChatEvent.VOICE_CHAT_ENABLED,this.onVoiceChatEnabled);
         this.voiceChatManager.addEventListener(ChatEvent.VOICE_CHAT_DISABLED,this.onVoiceChatDisabled);
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this.chatRoomManager.removeEventListener(RoomEvent.GROUP_MESSAGE,this.onGroupMessage);
         this.voiceChatManager.removeEventListener(NetStatusEvent.NET_STATUS,this.onVoiceNetStatus);
         this.voiceChatManager.removeEventListener(ChatEvent.VOICE_CHAT_ENABLED,this.onVoiceChatEnabled);
         this.voiceChatManager.removeEventListener(ChatEvent.VOICE_CHAT_DISABLED,this.onVoiceChatDisabled);
         this.clearUsers();
         if(this._userDataProvider)
         {
            this._userDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onUserCollectionChange);
         }
         this.clearMessages();
         if(this._messageDataProvider)
         {
            this._messageDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessageCollectionChange);
         }
         this.clearRooms();
         if(this._roomDataProvider)
         {
            this._roomDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRoomCollectionChange);
         }
      }
      
      protected function onUserCollectionChange(event:CollectionEvent) : void
      {
         if(event.kind == CollectionEvent.KIND_ADD)
         {
            this.addUser(event.location);
         }
         else if(event.kind == CollectionEvent.KIND_REMOVE)
         {
            this.removeUser(event.location);
         }
      }
      
      protected function onMessageCollectionChange(event:CollectionEvent) : void
      {
         var currentNumLines:int = 0;
         var removedNumLines:int = 0;
         if(!childrenCreated)
         {
            return;
         }
         var preChangeNumLines:int = this.messageScrollGroup.textBlock._field.numLines;
         this.messagesValid = false;
         invalidateProperties();
         validate();
         this.messageScrollGroup.textBlock.validate();
         if(event.kind == CollectionEvent.KIND_REMOVE)
         {
            if(this.messageScrollGroup.textBlock.scrollAmount == 1)
            {
               return;
            }
            currentNumLines = this.messageScrollGroup.textBlock._field.numLines;
            removedNumLines = preChangeNumLines - currentNumLines;
            this.messageScrollGroup.textBlock.incrementScrollAmount(-1,removedNumLines);
         }
      }
      
      protected function onRoomCollectionChange(event:CollectionEvent) : void
      {
         var roomJIDNode:String = null;
         var room:ChatRoom = null;
         this.roomsValid = false;
         invalidateProperties();
         invalidateDisplayList();
         if(event.kind == CollectionEvent.KIND_ADD)
         {
            roomJIDNode = event.items[0].key;
            this.setRoom(roomJIDNode);
         }
         else if(event.kind == CollectionEvent.KIND_REMOVE)
         {
            roomJIDNode = event.items[0].key;
            if(roomJIDNode == this.chatRoom.jidNode)
            {
               if(this._roomDataProvider.length > 0)
               {
                  room = this._roomDataProvider.getItemAt(this._roomDataProvider.length - 1) as ChatRoom;
                  this.setRoom(room.jidNode);
               }
            }
            else
            {
               this.setRoom(this.chatRoom.jidNode);
            }
         }
      }
      
      protected function onTextClicked(event:flash.events.TextEvent) : void
      {
         var profileID:String = null;
         var chatUser:ChatUser = null;
         var len:int = 0;
         var i:int = 0;
         var user:ChatUser = null;
         var chatRoomUser:ChatRoomUser = null;
         var linkClickedEvent:iilwy.events.TextEvent = null;
         var path:String = null;
         var subPath:Array = null;
         var firstSubPath:String = null;
         var secondSubPath:String = null;
         var inviteLink:String = null;
         var params:* = undefined;
         var gameID:String = null;
         var chatroomName:String = null;
         var match:* = event.text.match(/^profileContextMenu/);
         if(match)
         {
            profileID = event.text.match(/^profileContextMenu\/(\w+)/)[1];
            len = this._userDataProvider.length;
            for(i = 0; i < len; i++)
            {
               user = this._userDataProvider.getItemAt(i) as ChatUser;
               if(user.profileID == profileID)
               {
                  chatUser = user;
                  break;
               }
            }
            if(chatUser)
            {
               this.mouseSprite.y = mouseY;
               chatRoomUser = new ChatRoomUser(chatUser,this.chatRoom);
               AppComponents.contextMenuManager.showChatRoomUserContextMenu(chatRoomUser,this.mouseSprite,ControlAlign.LEFT_BOTTOM);
            }
            event.stopImmediatePropagation();
         }
         else
         {
            linkClickedEvent = new iilwy.events.TextEvent(TextEvent.TEXT_LINK_CLICKED,true,true);
            linkClickedEvent.text = event.text;
            dispatchEvent(linkClickedEvent);
            path = event.text;
            subPath = path.split("/");
            firstSubPath = subPath.shift();
            if(firstSubPath == "#")
            {
               firstSubPath = subPath.shift();
            }
            secondSubPath = subPath.shift();
            if(firstSubPath == "arcade" && secondSubPath == "invite_to_match")
            {
               inviteLink = subPath.shift();
               params = DataUtil.parseInviteLink(inviteLink);
               gameID = DataUtil.getGameIdFromMatchName(params.matchName);
               AppComponents.analytics.trackAction("chatroom/message/join/game/" + gameID);
            }
            else if(firstSubPath == "chatrooms")
            {
               chatroomName = secondSubPath;
               AppComponents.analytics.trackAction("chatroom/message/join/room/" + chatroomName);
            }
         }
      }
      
      protected function onInputKeyDown(event:KeyboardEvent) : void
      {
         this.onInputKeyChange(event);
      }
      
      protected function onInputKeyUp(event:KeyboardEvent) : void
      {
         this.onInputKeyChange(event);
         if(event.keyCode == 13 && this._messageInput.text != "")
         {
            this.sendMessage();
            this._messageInput.text = "";
            this.messageScrollGroup.textBlock.scrollAmount = 1;
         }
      }
      
      protected function onInputKeyChange(event:KeyboardEvent) : void
      {
         var validCtrlKeys:Array = [67,86,88,89,90];
         this.ctrlPressed = event.ctrlKey && validCtrlKeys.indexOf(event.keyCode) == -1;
      }
      
      protected function onInputText(event:flash.events.TextEvent) : void
      {
         if(this.ctrlPressed)
         {
            event.preventDefault();
            event.stopImmediatePropagation();
         }
      }
      
      protected function onSubjectChange(event:RoomEvent) : void
      {
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.UPDATE_CHAT_ROOM);
         chatEvent.chatRoom = this.chatRoom;
         dispatchEvent(chatEvent);
      }
      
      protected function onAddRoomClick(event:ButtonEvent) : void
      {
      }
      
      protected function onGroupMessage(event:RoomEvent) : void
      {
         var room:ChatRoom = null;
         var tempChatRoom:ChatRoom = null;
         var jingles:Array = null;
         var jingle:JingleExtension = null;
         var chatEvent:ChatEvent = null;
         var button:DisplayButton = null;
         var message:Message = event.data as Message;
         var roomsArray:Array = this.chatRoomManager.rooms.toArray();
         var len:int = roomsArray.length;
         for(var i:int = 0; i < len; i++)
         {
            tempChatRoom = roomsArray[i].value as ChatRoom;
            if(tempChatRoom.room.isThisRoom(message.from.unescaped))
            {
               room = tempChatRoom;
               break;
            }
         }
         if(room.jidNode == this.chatRoom.jidNode)
         {
            jingles = message._exts[JingleExtension.NS];
            if(jingles)
            {
               jingle = jingles[0];
               chatEvent = new ChatEvent(ChatEvent.CHAT_ROOM_JINGLE,true,true);
               chatEvent.chatRoom = this.chatRoom;
               chatEvent.jingle = jingle;
               dispatchEvent(chatEvent);
            }
         }
         else
         {
            button = this.roomButtons[room.jidNode];
            if(button)
            {
               button.setStyleById("simpleButtonBottomTabHilight");
            }
         }
      }
      
      protected function onReenableChat(event:TimerEvent) : void
      {
         this.reenableChatTimer.stop();
         this.offenses = 0;
         this.numConcurrentMessages = 0;
         if(this.muteState)
         {
            AppComponents.alertManager.showWarning("Chat reactivated");
            this.muteState = false;
         }
      }
      
      protected function onVoiceChatEnabled(event:ChatEvent) : void
      {
         if(!event.voiceChatChannel)
         {
            return;
         }
         var room:ChatRoom = this.chatRoomManager.rooms.getItemAtKey(event.voiceChatChannel.node);
         if(!room)
         {
            return;
         }
         var message:Message = room.room.getMessage();
         var jingle:JingleExtension = new JingleExtension();
         jingle.action = JingleAction.SESSION_INITIATE;
         jingle.initiator = this.chatManager.currentUser.displayName;
         message.addExtension(jingle);
         this.chatManager.connection.send(message);
      }
      
      protected function onVoiceChatDisabled(event:ChatEvent) : void
      {
         if(!event.voiceChatChannel)
         {
            return;
         }
         var room:ChatRoom = this.chatRoomManager.rooms.getItemAtKey(event.voiceChatChannel.node);
         if(!room)
         {
            return;
         }
         var message:Message = room.room.getMessage();
         var jingle:JingleExtension = new JingleExtension();
         jingle.action = JingleAction.SESSION_TERMINATE;
         jingle.initiator = this.chatManager.currentUser.displayName;
         message.addExtension(jingle);
         this.chatManager.connection.send(message);
      }
      
      protected function onVoiceNetStatus(event:NetStatusEvent) : void
      {
         var info:NetStatusInfo = null;
         var chatMessage:ChatMessage = null;
         if(AppComponents.model.privateUser.profile.premiumLevel >= PremiumLevels.CREW)
         {
            info = NetStatusInfo.getByCode(event.info.code);
            chatMessage = new ChatMessage(info.code + ": " + info.level + ": " + event.info.description);
            this._messageDataProvider.addItem(chatMessage);
         }
      }
   }
}
