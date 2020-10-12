package iilwy.display.chat.screens
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   import iilwy.display.core.FocusManager;
   import iilwy.events.ChatEvent;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoCompleteInput;
   import iilwy.ui.controls.BevelButton;
   import iilwy.ui.events.ButtonEvent;
   
   public class JoinChatRoomScreen extends UiContainer
   {
       
      
      protected var roomNameInput:AutoCompleteInput;
      
      protected var joinButton:BevelButton;
      
      protected var roomMap:Dictionary;
      
      protected var roomNameList:Array;
      
      protected var _roomList:Array;
      
      public function JoinChatRoomScreen()
      {
         super();
         width = 100;
         height = 100;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function set roomList(value:Array) : void
      {
         var room:ChatRoom = null;
         this._roomList = value;
         this.roomMap = new Dictionary();
         this.roomNameList = [];
         for each(room in value)
         {
            this.roomMap[room.displayName] = room;
            this.roomNameList.push(room.displayName);
         }
         invalidateProperties();
      }
      
      override public function createChildren() : void
      {
         this.roomNameInput = new AutoCompleteInput();
         this.roomNameInput.field.restrict = "A-Z a-z 0-9 $\\-_.,+!*\'\"?()[]|";
         this.roomNameInput.minCharsToSearch = 1;
         this.roomNameInput.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp,false,0,true);
         addContentChild(this.roomNameInput);
         FocusManager.getInstance().setStageFocus(this.roomNameInput);
         this.joinButton = new BevelButton("JOIN",0,0,75,30);
         this.joinButton.addEventListener(ButtonEvent.CLICK,this.onJoinClick);
         addContentChild(this.joinButton);
      }
      
      override public function commitProperties() : void
      {
         this.roomNameInput.itemArray = this.roomNameList;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.roomNameInput.width = unscaledWidth - this.joinButton.width - 10;
         this.roomNameInput.height = 30;
         this.joinButton.x = this.roomNameInput.width + 10;
      }
      
      protected function joinRoom() : void
      {
         var chatRoom:ChatRoom = null;
         var chatEvent:ChatEvent = null;
         if(this.roomNameInput.text != "")
         {
            chatRoom = ChatRoom(this.roomMap[this.roomNameInput.text]);
            chatEvent = new ChatEvent(ChatEvent.JOIN_CHAT_ROOM);
            chatEvent.chatRoomDisplayName = Boolean(chatRoom)?chatRoom.displayName:this.roomNameInput.text;
            chatEvent.chatRoomJIDNode = Boolean(chatRoom)?chatRoom.jidNode:null;
            dispatchEvent(chatEvent);
         }
      }
      
      protected function onAddedToStage(event:Event) : void
      {
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this.roomNameInput.text = "";
      }
      
      protected function onJoinClick(event:ButtonEvent) : void
      {
         this.joinRoom();
      }
      
      protected function onInputKeyUp(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.joinRoom();
         }
      }
   }
}
