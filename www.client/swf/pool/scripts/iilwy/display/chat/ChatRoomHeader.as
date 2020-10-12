package iilwy.display.chat
{
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatRoomManager;
   import iilwy.display.chat.enum.ChatRoomWindowView;
   import iilwy.events.ChatEvent;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoScrollLabel;
   import iilwy.ui.controls.AutoScrollLabelMultiple;
   import iilwy.ui.controls.SimpleButton;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.partials.ShareLinkDisplay;
   import iilwy.ui.utils.CapType;
   import iilwy.utils.StageReference;
   
   public class ChatRoomHeader extends UiContainer
   {
       
      
      private var voiceChatButton:VoiceChatButton;
      
      private var shareLink:ShareLinkDisplay;
      
      private var chatHeaderLabels:AutoScrollLabelMultiple;
      
      private var headerLabel:AutoScrollLabel;
      
      private var chatButton:SimpleButton;
      
      private var roomListButton:SimpleButton;
      
      private var informationButton:SimpleButton;
      
      private var chatRoomManager:ChatRoomManager;
      
      private var pendingView:String;
      
      private var _chatRoom:ChatRoom;
      
      private var _chatRoomIsJoinable:Boolean;
      
      public function ChatRoomHeader()
      {
         super();
         this.chatRoomManager = AppComponents.chatRoomManager;
         setPadding(5,7);
         StageReference.stage.addEventListener(ChatEvent.ROOM_PASS_UPDATE,this.onRoomPassUpdate);
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function set chatRoom(value:ChatRoom) : void
      {
         if(this._chatRoom == value)
         {
            return;
         }
         this._chatRoom = value;
         this.chatHeaderLabels.getLabelAt(0).text = this.chatRoomName;
         this.chatHeaderLabels.getLabelAt(1).text = this.chatRoomSubject;
         this.chatRoomIsJoinable = true;
         this.voiceChatButton.chatRoom = this._chatRoom;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get chatRoomName() : String
      {
         return Boolean(this._chatRoom)?this._chatRoom.displayName:null;
      }
      
      public function get chatRoomSubject() : String
      {
         return Boolean(this._chatRoom)?this._chatRoom.room.subject:null;
      }
      
      public function get chatRoomIsJoinable() : Boolean
      {
         return this._chatRoomIsJoinable;
      }
      
      public function set chatRoomIsJoinable(value:Boolean) : void
      {
         this._chatRoomIsJoinable = value;
         invalidateProperties();
      }
      
      public function setView(view:String) : void
      {
         if(view != this.pendingView)
         {
            this.pendingView = view;
            invalidateProperties();
         }
         invalidateDisplayList();
      }
      
      override public function commitProperties() : void
      {
         var view:String = this.pendingView;
         this.voiceChatButton.visible = view == ChatRoomWindowView.CHAT?Boolean(true):Boolean(false);
         this.shareLink.visible = view == ChatRoomWindowView.CHAT && this.chatRoomIsJoinable?Boolean(true):Boolean(false);
         this.shareLink.url = "chatrooms/" + escape(this.chatRoomName);
         this.chatHeaderLabels.visible = view == ChatRoomWindowView.CHAT?Boolean(true):Boolean(false);
         this.headerLabel.visible = view == ChatRoomWindowView.ROOM_LIST || view == ChatRoomWindowView.INFORMATION?Boolean(true):Boolean(false);
         this.headerLabel.text = view == ChatRoomWindowView.INFORMATION?"Information":"Room List";
         this.chatButton.enabled = this.chatRoomManager.rooms.length > 0;
         this.chatButton.selected = view == ChatRoomWindowView.CHAT?Boolean(true):Boolean(false);
         this.roomListButton.selected = view == ChatRoomWindowView.ROOM_LIST?Boolean(true):Boolean(false);
         this.informationButton.selected = view == ChatRoomWindowView.INFORMATION?Boolean(true):Boolean(false);
      }
      
      override public function createChildren() : void
      {
         this.voiceChatButton = new VoiceChatButton();
         this.voiceChatButton.addEventListener(ChatEvent.ENABLE_VOICE_CHAT,this.onVoiceChatClick);
         this.voiceChatButton.addEventListener(ChatEvent.DISABLE_VOICE_CHAT,this.onVoiceChatClick);
         addContentChild(this.voiceChatButton);
         this.shareLink = new ShareLinkDisplay("Invitation link");
         this.shareLink.confirmNotification = "Link copied! Send it to your friends to invite them to this chatroom.";
         this.shareLink.width = 190;
         addContentChild(this.shareLink);
         this.chatHeaderLabels = new AutoScrollLabelMultiple(2);
         this.chatHeaderLabels.itemPadding = -3;
         this.chatHeaderLabels.getLabelAt(0).setStyleById("h3");
         this.chatHeaderLabels.getLabelAt(0).label.fontColor = 16777215;
         this.chatHeaderLabels.getLabelAt(1).setStyleById("small");
         this.chatHeaderLabels.getLabelAt(1).label.fontColor = 16777215;
         addContentChild(this.chatHeaderLabels);
         this.headerLabel = new AutoScrollLabel();
         this.headerLabel.setStyleById("h3");
         this.headerLabel.label.fontColor = 16777215;
         addContentChild(this.headerLabel);
         this.chatButton = new SimpleButton("Chat",0,0,115,30,"simpleButton");
         this.chatButton.capType = CapType.TAB;
         this.chatButton.addEventListener(ButtonEvent.CLICK,this.onButtonClick);
         addContentChild(this.chatButton);
         this.roomListButton = new SimpleButton("Room List",0,0,115,30,"simpleButton");
         this.roomListButton.capType = CapType.TAB;
         this.roomListButton.addEventListener(ButtonEvent.CLICK,this.onButtonClick);
         addContentChild(this.roomListButton);
         this.informationButton = new SimpleButton("Read This",0,0,115,30,"simpleButton");
         this.informationButton.capType = CapType.TAB;
         this.informationButton.addEventListener(ButtonEvent.CLICK,this.onButtonClick);
         addContentChild(this.informationButton);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.voiceChatButton.x = unscaledWidth - padding.right - this.voiceChatButton.width;
         if(this.shareLink.visible)
         {
            this.voiceChatButton.x = this.voiceChatButton.x - (this.shareLink.width + 5);
         }
         this.voiceChatButton.y = padding.top + 1;
         this.shareLink.x = unscaledWidth - padding.right - this.shareLink.width;
         this.shareLink.y = padding.top;
         var buttonPadding:Number = 2;
         var roomListButtonWidth:Number = !!this.chatRoomManager.roomPass?Number(0):Number(this.roomListButton.width + buttonPadding);
         var tabSetWidth:Number = this.chatButton.width + buttonPadding + roomListButtonWidth + this.informationButton.width;
         this.chatHeaderLabels.x = padding.left;
         this.chatHeaderLabels.y = unscaledHeight / 2 - this.chatHeaderLabels.height / 2;
         this.chatHeaderLabels.width = unscaledWidth - tabSetWidth;
         this.headerLabel.x = padding.left;
         this.headerLabel.y = unscaledHeight / 2 - this.headerLabel.height / 2;
         this.headerLabel.width = unscaledWidth - tabSetWidth;
         this.chatButton.x = unscaledWidth - tabSetWidth;
         this.chatButton.y = unscaledHeight - this.chatButton.height;
         this.roomListButton.x = this.chatButton.x + this.chatButton.width + buttonPadding;
         this.roomListButton.y = unscaledHeight - this.roomListButton.height;
         this.roomListButton.visible = !this.chatRoomManager.roomPass;
         this.informationButton.x = !!this.chatRoomManager.roomPass?Number(this.roomListButton.x):Number(this.roomListButton.x + this.roomListButton.width + buttonPadding);
         this.informationButton.y = unscaledHeight - this.roomListButton.height;
      }
      
      private function onButtonClick(event:ButtonEvent) : void
      {
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.SET_CHAT_ROOM_WINDOW_VIEW);
         chatEvent.chatRoomWindowView = event.button == this.roomListButton?ChatRoomWindowView.ROOM_LIST:event.button == this.chatButton?ChatRoomWindowView.CHAT:ChatRoomWindowView.INFORMATION;
         dispatchEvent(chatEvent);
      }
      
      private function onVoiceChatClick(event:ChatEvent) : void
      {
         AppComponents.analytics.trackAction("action/chatroom/click/voicechat_" + (event.type == ChatEvent.ENABLE_VOICE_CHAT?"enable":"disable"));
      }
      
      private function onRoomPassUpdate(event:ChatEvent) : void
      {
         invalidateDisplayList();
      }
   }
}
