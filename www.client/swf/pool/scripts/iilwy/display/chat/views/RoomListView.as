package iilwy.display.chat.views
{
   import flash.display.Sprite;
   import flash.events.Event;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatRoomManager;
   import iilwy.collections.ArrayCollection;
   import iilwy.display.chat.enum.ChatRoomAction;
   import iilwy.display.chat.enum.ChatRoomWindowView;
   import iilwy.display.chat.enum.RoomListScreen;
   import iilwy.display.chat.screens.CreateChatRoomScreen;
   import iilwy.display.chat.screens.JoinChatRoomScreen;
   import iilwy.display.chat.screens.ListChatRoomsScreen;
   import iilwy.events.AsyncEvent;
   import iilwy.events.ChatEvent;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.containers.ViewStack;
   import iilwy.ui.controls.SimpleMenu;
   import iilwy.ui.controls.SimpleMenuDataProvider;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import iilwy.utils.UiRender;
   
   public class RoomListView extends UiContainer
   {
       
      
      private var menuBG:Sprite;
      
      private var divider:Sprite;
      
      private var menu:SimpleMenu;
      
      private var menuData:SimpleMenuDataProvider;
      
      private var viewStack:ViewStack;
      
      private var allChatRoomsScreen:ListChatRoomsScreen;
      
      private var joinChatRoomScreen:JoinChatRoomScreen;
      
      private var createChatRoomScreen:CreateChatRoomScreen;
      
      private var joinedChatRoomsScreen:ListChatRoomsScreen;
      
      private var chatRoomManager:ChatRoomManager;
      
      private var joinRoomEvent:ChatEvent;
      
      private var joinRoomResponder:Responder;
      
      private var pendingScreen:String;
      
      private var roomIndex:ArrayCollection;
      
      public function RoomListView()
      {
         super();
         setPadding(10);
         this.chatRoomManager = AppComponents.chatRoomManager;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function setScreen(screen:String) : void
      {
         this.pendingScreen = screen;
         invalidateProperties();
         invalidateDisplayList();
         invalidateSize();
      }
      
      override public function commitProperties() : void
      {
         var screen:String = this.pendingScreen;
         this.menuData.value = screen;
         this.viewStack.selectedID = screen;
         if(screen == RoomListScreen.ROOM_LIST)
         {
            this.allChatRoomsScreen.getIndex();
         }
         else if(screen == RoomListScreen.JOINED_ROOMS)
         {
            this.joinedChatRoomsScreen.dataProvider = this.chatRoomManager.rooms;
         }
         else if(screen == RoomListScreen.JOIN)
         {
            this.joinChatRoomScreen.roomList = this.roomIndex.toArray();
         }
      }
      
      override public function createChildren() : void
      {
         this.menuBG = new Sprite();
         this.menuBG.graphics.beginFill(15658734);
         this.menuBG.graphics.drawRect(0,0,100,100);
         this.menuBG.graphics.endFill();
         addContentChild(this.menuBG);
         this.divider = new Sprite();
         UiRender.renderGradient(this.divider,[15066597,12895428],0,0,0,3,100);
         addContentChild(this.divider);
         var menuItems:Array = new Array();
         menuItems.push({
            "label":"Room List",
            "value":RoomListScreen.ROOM_LIST
         });
         menuItems.push({
            "label":"Join",
            "value":RoomListScreen.JOIN
         });
         menuItems.push({
            "label":"Create",
            "value":RoomListScreen.CREATE
         });
         this.menuData = new SimpleMenuDataProvider();
         this.menuData.addItems(menuItems);
         this.menu = new SimpleMenu();
         this.menu.data = this.menuData;
         this.menu.listenForMouseWheel();
         this.menu.addEventListener(MultiSelectEvent.SELECT,this.onMenuSelect);
         addContentChild(this.menu);
         this.allChatRoomsScreen = new ListChatRoomsScreen();
         this.allChatRoomsScreen.addEventListener(Event.COMPLETE,this.onRoomIndexComplete);
         this.allChatRoomsScreen.addEventListener(ChatEvent.JOIN_CHAT_ROOM,this.onJoinChatRoom);
         this.joinChatRoomScreen = new JoinChatRoomScreen();
         this.joinChatRoomScreen.addEventListener(ChatEvent.JOIN_CHAT_ROOM,this.onJoinChatRoom);
         this.createChatRoomScreen = new CreateChatRoomScreen();
         this.createChatRoomScreen.addEventListener(ChatEvent.JOIN_CHAT_ROOM,this.onJoinChatRoom);
         this.joinedChatRoomsScreen = new ListChatRoomsScreen(ChatRoomAction.LEAVE);
         this.joinedChatRoomsScreen.addEventListener(ChatEvent.LEAVE_CHAT_ROOM,this.onLeaveChatRoom);
         this.viewStack = new ViewStack();
         this.viewStack.addItem(RoomListScreen.ROOM_LIST,this.allChatRoomsScreen);
         this.viewStack.addItem(RoomListScreen.JOIN,this.joinChatRoomScreen);
         this.viewStack.addItem(RoomListScreen.CREATE,this.createChatRoomScreen);
         this.viewStack.addItem(RoomListScreen.JOINED_ROOMS,this.joinedChatRoomsScreen);
         addContentChild(this.viewStack);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var gap:Number = NaN;
         var menuWidth:Number = NaN;
         var dividerGap:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         xPos = 0;
         yPos = 0;
         gap = 5;
         menuWidth = 130;
         dividerGap = 2;
         this.menuBG.x = xPos;
         this.menuBG.y = yPos;
         this.menuBG.width = menuWidth + padding.left + dividerGap;
         this.menuBG.height = unscaledHeight;
         xPos = xPos + padding.left;
         this.menu.x = xPos;
         this.menu.y = yPos + padding.top;
         this.menu.width = menuWidth;
         this.menu.height = unscaledHeight - padding.vertical;
         xPos = xPos + (menuWidth + dividerGap);
         this.divider.height = unscaledHeight;
         this.divider.x = xPos;
         this.divider.y = yPos;
         xPos = xPos + (this.divider.width + gap);
         yPos = yPos + padding.top;
         this.viewStack.width = unscaledWidth - xPos - padding.right;
         this.viewStack.height = unscaledHeight - padding.vertical;
         this.viewStack.x = xPos;
         this.viewStack.y = yPos;
         this.allChatRoomsScreen.width = this.viewStack.width;
         this.allChatRoomsScreen.height = this.viewStack.height;
         this.joinChatRoomScreen.width = this.viewStack.width;
         this.joinChatRoomScreen.height = this.viewStack.height;
         this.createChatRoomScreen.width = this.viewStack.width;
         this.createChatRoomScreen.height = this.viewStack.height;
         this.joinedChatRoomsScreen.width = this.viewStack.width;
         this.joinedChatRoomsScreen.height = this.viewStack.height;
      }
      
      private function onAddedToStage(event:Event) : void
      {
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
      }
      
      private function onRoomIndexComplete(event:Event) : void
      {
         this.roomIndex = this.allChatRoomsScreen.dataProvider as ArrayCollection;
      }
      
      private function onJoinChatRoom(event:ChatEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.START_PROCESSING,true));
         this.joinRoomResponder = new Responder();
         this.joinRoomResponder.setAsyncListeners(this.onJoinRoomSuccess,this.onJoinRoomFail);
         event.responder = this.joinRoomResponder;
         this.joinRoomEvent = event;
         StageReference.stage.dispatchEvent(event);
      }
      
      private function onJoinRoomSuccess(event:AsyncEvent) : void
      {
         var chatRoom:ChatRoom = event.data as ChatRoom;
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.SET_CHAT_ROOM_WINDOW_VIEW,true,true);
         chatEvent.chatRoomWindowView = ChatRoomWindowView.CHAT;
         chatEvent.chatRoomJIDNode = chatRoom.jidNode;
         dispatchEvent(chatEvent);
      }
      
      private function onJoinRoomFail(event:AsyncEvent) : void
      {
         StageReference.stage.dispatchEvent(new ChatEvent(ChatEvent.CHAT_ROOM_ERROR,true,true,{
            "error":event.data,
            "failedEvent":this.joinRoomEvent
         }));
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
      }
      
      private function onLeaveChatRoom(event:ChatEvent) : void
      {
         StageReference.stage.dispatchEvent(event);
      }
      
      private function onMenuSelect(event:MultiSelectEvent) : void
      {
         this.setScreen(event.value);
      }
   }
}
