package iilwy.display.chat
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatRoomManager;
   import iilwy.display.chat.enum.ChatRoomWindowView;
   import iilwy.display.chat.enum.RoomListScreen;
   import iilwy.display.chat.views.ChatView;
   import iilwy.display.chat.views.InformationView;
   import iilwy.display.chat.views.RoomListView;
   import iilwy.display.popups.AbstractProcessingPopup;
   import iilwy.events.ChatEvent;
   import iilwy.events.UserDataEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.ui.containers.ViewStack;
   import iilwy.ui.containers.Window;
   import iilwy.ui.controls.IconButton;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.utils.StageReference;
   
   public class ChatRoomWindow extends AbstractProcessingPopup
   {
       
      
      private var header:ChatRoomHeader;
      
      private var viewStack:ViewStack;
      
      private var minimizeButton:IconButton;
      
      private var chatView:ChatView;
      
      private var roomListView:RoomListView;
      
      private var informationView:InformationView;
      
      private var chatRoomManager:ChatRoomManager;
      
      private var pendingView:String;
      
      private var pendingRoom:String;
      
      private var pendingScreen:String;
      
      public function ChatRoomWindow()
      {
         super();
         percentWidth = 100;
         percentHeight = 100;
         this.chatRoomManager = AppComponents.chatRoomManager;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(ContainerEvent.ADDED_TO_CONTAINER,this.onAddedToContainer);
      }
      
      public function setView(view:String, roomJIDNode:String = null, screen:String = null) : void
      {
         this.pendingView = view;
         this.pendingRoom = view == ChatRoomWindowView.CHAT?Boolean(roomJIDNode)?roomJIDNode:Boolean(this.chatRoomManager.lastOpenRoom)?this.chatRoomManager.lastOpenRoom.jidNode:roomJIDNode:roomJIDNode;
         this.pendingScreen = screen;
         invalidateProperties();
         invalidateDisplayList();
         invalidateSize();
      }
      
      override public function commitProperties() : void
      {
         var view:String = this.pendingView;
         var room:String = this.pendingRoom;
         var screen:String = Boolean(this.pendingScreen)?this.pendingScreen:RoomListScreen.ROOM_LIST;
         if(view != this.viewStack.selectedID)
         {
            AppComponents.analytics.trackAction("chatroom/click/tab_" + view);
         }
         this.viewStack.selectedID = view;
         this.header.setView(view);
         if(view == ChatRoomWindowView.CHAT)
         {
            this.chatView.setRoom(room);
         }
         else if(view == ChatRoomWindowView.ROOM_LIST)
         {
            this.roomListView.setScreen(screen);
         }
         this.pendingView = null;
         this.pendingRoom = null;
         this.pendingScreen = null;
      }
      
      override public function createChildren() : void
      {
         super.createChildren();
         this.header = new ChatRoomHeader();
         this.header.addEventListener(ChatEvent.SET_CHAT_ROOM_WINDOW_VIEW,this.onSetWindowView);
         addContentChild(this.header);
         this.chatView = new ChatView();
         this.chatView.addEventListener(ChatEvent.UPDATE_CHAT_ROOM,this.onUpdateChatRoom);
         this.roomListView = new RoomListView();
         this.roomListView.addEventListener(ChatEvent.SET_CHAT_ROOM_WINDOW_VIEW,this.onSetWindowView);
         this.informationView = new InformationView();
         this.viewStack = new ViewStack();
         this.viewStack.backgroundColor = 16777215;
         this.viewStack.addContainerBackground();
         this.viewStack.addItem(ChatRoomWindowView.CHAT,this.chatView);
         this.viewStack.addItem(ChatRoomWindowView.ROOM_LIST,this.roomListView);
         this.viewStack.addItem(ChatRoomWindowView.INFORMATION,this.informationView);
         addContentChild(this.viewStack);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!container)
         {
            return;
         }
         this.header.x = -container.padding.left;
         this.header.y = -container.padding.top;
         this.header.width = unscaledWidth + container.padding.horizontal;
         this.header.height = 70;
         this.viewStack.x = -container.padding.left;
         this.viewStack.y = this.header.height - container.padding.top;
         this.viewStack.width = this.header.width;
         this.viewStack.height = unscaledHeight - this.header.height + container.padding.vertical;
         this.chatView.width = this.viewStack.width;
         this.chatView.height = this.viewStack.height;
         this.roomListView.width = this.viewStack.width;
         this.roomListView.height = this.viewStack.height;
         this.informationView.width = this.viewStack.width;
         this.informationView.height = this.viewStack.height;
      }
      
      override public function get defaultFocus() : InteractiveObject
      {
         var focus:InteractiveObject = null;
         if(this.viewStack)
         {
            if(this.viewStack.selectedID == ChatRoomWindowView.CHAT)
            {
               focus = this.chatView.messageInput;
            }
         }
         return focus;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         AppComponents.model.addEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
         StageReference.stage.addEventListener(ChatEvent.DISCONNECTED_FROM_CHAT_SERVER,this.onDisconnected);
         dispatchEvent(new ContainerEvent(ContainerEvent.UNMASK_CONTENTS,true));
         dispatchEvent(new ContainerEvent(ContainerEvent.START_PROCESSING,true));
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         AppComponents.model.removeEventListener(UserDataEvent.PRIVATE_LOGIN_STATE_CHANGED,this.onLoginChanged);
         StageReference.stage.removeEventListener(ChatEvent.DISCONNECTED_FROM_CHAT_SERVER,this.onDisconnected);
      }
      
      private function onLoginChanged(event:UserDataEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
      }
      
      private function onDisconnected(event:ChatEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
      }
      
      private function onAddedToContainer(event:ContainerEvent) : void
      {
         this.minimizeButton = Window(container).addTopRightControl(GraphicManager.iconMinimize);
         this.minimizeButton.addEventListener(ButtonEvent.CLICK,this.onMinimize);
         invalidateDisplayList();
      }
      
      private function onMinimize(event:ButtonEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
         StageReference.stage.dispatchEvent(new ChatEvent(ChatEvent.MINIMIZE_CHAT_ROOM_WINDOW,true,true));
         AppComponents.analytics.trackAction("chatroom/window/close");
      }
      
      private function onUpdateChatRoom(event:ChatEvent) : void
      {
         this.header.chatRoom = event.chatRoom;
      }
      
      private function onSetWindowView(event:ChatEvent) : void
      {
         this.setView(event.chatRoomWindowView,event.chatRoomJIDNode,event.roomListScreen);
      }
   }
}
