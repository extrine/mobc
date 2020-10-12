package iilwy.display.chat.screens
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import iilwy.application.AppComponents;
   import iilwy.display.core.FocusManager;
   import iilwy.events.ChatEvent;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.BevelButton;
   import iilwy.ui.controls.CheckBox;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.controls.TextInput;
   import iilwy.ui.events.ButtonEvent;
   
   public class CreateChatRoomScreen extends UiContainer
   {
       
      
      protected var instructions:TextBlock;
      
      protected var roomNameInput:TextInput;
      
      protected var createButton:BevelButton;
      
      protected var privateCheckBox:CheckBox;
      
      public function CreateChatRoomScreen()
      {
         super();
         width = 100;
         height = 100;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      override public function createChildren() : void
      {
         this.instructions = new TextBlock();
         this.instructions.text = "If you create an offensive room, you will be banned.";
         addContentChild(this.instructions);
         this.roomNameInput = new TextInput();
         this.roomNameInput.field.restrict = "A-Z a-z 0-9 $\\-_.,+!*\'\"?()[]|";
         this.roomNameInput.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp,false,0,true);
         addContentChild(this.roomNameInput);
         FocusManager.getInstance().setStageFocus(this.roomNameInput);
         this.createButton = new BevelButton("CREATE",0,0,75,30);
         this.createButton.addEventListener(ButtonEvent.CLICK,this.onCreateClick);
         addContentChild(this.createButton);
         this.privateCheckBox = new CheckBox();
         this.privateCheckBox.label = "Private";
         this.privateCheckBox.tabEnabled = true;
         addContentChild(this.privateCheckBox);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var hPadding:int = 0;
         var vPadding:int = 0;
         hPadding = 10;
         vPadding = 5;
         var yPos:Number = 0;
         this.instructions.width = unscaledWidth;
         yPos = yPos + (this.instructions.height + vPadding);
         this.roomNameInput.width = unscaledWidth - this.createButton.width - hPadding;
         this.roomNameInput.height = 30;
         this.roomNameInput.y = yPos;
         this.createButton.x = this.roomNameInput.width + hPadding;
         this.createButton.y = yPos;
         yPos = yPos + (this.roomNameInput.height + vPadding);
         this.privateCheckBox.y = yPos;
      }
      
      protected function createRoom() : void
      {
         var chatEvent:ChatEvent = null;
         if(this.roomNameInput.text != "")
         {
            chatEvent = new ChatEvent(ChatEvent.JOIN_CHAT_ROOM);
            chatEvent.chatRoomDisplayName = AppComponents.textOffendCheck.screenOffensive(this.roomNameInput.text);
            chatEvent.chatRoomIsPrivate = this.privateCheckBox.selected;
            chatEvent.createRoom = true;
            dispatchEvent(chatEvent);
         }
      }
      
      protected function onAddedToStage(event:Event) : void
      {
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this.roomNameInput.text = "";
         this.privateCheckBox.selected = false;
      }
      
      protected function onCreateClick(event:ButtonEvent) : void
      {
         this.createRoom();
      }
      
      protected function onInputKeyUp(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.createRoom();
         }
      }
   }
}
