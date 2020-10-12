package iilwy.display.chat.listitems
{
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatRoomManager;
   import iilwy.display.chat.enum.ChatRoomAction;
   import iilwy.events.ChatEvent;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoScrollLabelMultiple;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.LiteButton;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ButtonEvent;
   
   public class ChatRoomListItem extends UiContainer
   {
       
      
      private var divider:Divider;
      
      private var labels:AutoScrollLabelMultiple;
      
      private var actionButton:LiteButton;
      
      private var chatRoomManager:ChatRoomManager;
      
      private var roomData:ChatRoom;
      
      private var _useDivider:Boolean;
      
      private var _action:String;
      
      public function ChatRoomListItem()
      {
         super();
         this.chatRoomManager = AppComponents.chatRoomManager;
         height = 50;
         setPadding(10,0);
      }
      
      override public function createChildren() : void
      {
         addContainerBackground();
         this.divider = new Divider(0,0,100,1);
         addContentChild(this.divider);
         this.labels = new AutoScrollLabelMultiple(2);
         this.labels.idleScroll = true;
         this.labels.itemPadding = -3;
         this.labels.getLabelAt(1).setStyleById("small");
         addContentChild(this.labels);
         this.actionButton = new LiteButton();
         this.actionButton.height = 20;
         this.actionButton.width = 70;
         this.actionButton.setStyleById("simpleButtonHilight");
         this.actionButton.addEventListener(ButtonEvent.CLICK,this.onActionClick);
         addContentChild(this.actionButton);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      override public function commitProperties() : void
      {
         if(this.roomData)
         {
            this.labels.idleScroll = false;
            this.labels.getLabelAt(0).text = this.roomData.displayName;
            this.labels.getLabelAt(1).text = this.chatRoomManager.getRoomOverview(this.roomData);
            this.actionButton.label = this.action == ChatRoomAction.LEAVE?"LEAVE":"JOIN";
            this.actionButton.visible = true;
         }
      }
      
      override public function measure() : void
      {
         measuredHeight = 30;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var innerWidth:Number = calculateInnerWidth(unscaledWidth);
         if(this._useDivider)
         {
            this.divider.visible = true;
            this.divider.width = unscaledWidth;
         }
         else
         {
            this.divider.visible = false;
         }
         this.labels.x = padding.left;
         this.labels.y = padding.top;
         this.labels.width = innerWidth - this.actionButton.width - padding.right;
         this.actionButton.x = Math.floor(unscaledWidth - this.actionButton.width - padding.right);
         this.actionButton.y = Math.floor(unscaledHeight - this.actionButton.height - padding.bottom);
      }
      
      public function get data() : ChatRoom
      {
         return this.roomData;
      }
      
      public function set data(value:ChatRoom) : void
      {
         this.roomData = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function set useDivider(value:Boolean) : void
      {
         if(this._useDivider != value)
         {
            this._useDivider = value;
            invalidateDisplayList();
         }
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function set action(value:String) : void
      {
         this._action = value;
         invalidateProperties();
      }
      
      public function set selected(value:Boolean) : void
      {
      }
      
      public function asUiElement() : UiElement
      {
         return this as UiElement;
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
      }
      
      protected function onMouseOut(event:MouseEvent) : void
      {
      }
      
      protected function onActionClick(event:ButtonEvent) : void
      {
         var chatEvent:ChatEvent = null;
         if(this.action == ChatRoomAction.LEAVE)
         {
            chatEvent = new ChatEvent(ChatEvent.LEAVE_CHAT_ROOM);
            chatEvent.chatRoom = this.roomData;
         }
         else
         {
            chatEvent = new ChatEvent(ChatEvent.JOIN_CHAT_ROOM);
            chatEvent.chatRoomJIDNode = this.roomData.jidNode;
         }
         dispatchEvent(chatEvent);
      }
   }
}
