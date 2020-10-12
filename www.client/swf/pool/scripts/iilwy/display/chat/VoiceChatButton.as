package iilwy.display.chat
{
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import iilwy.application.AppComponents;
   import iilwy.chat.VoiceChatManager;
   import iilwy.events.ChatEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.BevelButton;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.StageReference;
   
   public class VoiceChatButton extends UiContainer
   {
       
      
      private var button:BevelButton;
      
      private var phoneIcon:Sprite;
      
      private var checkBox:Sprite;
      
      private var check:Sprite;
      
      private var voiceChatManager:VoiceChatManager;
      
      private var voiceChatRoom:ChatRoom;
      
      private var _chatRoom:ChatRoom;
      
      public function VoiceChatButton()
      {
         super();
         this.voiceChatManager = AppComponents.voiceChatManager;
         StageReference.stage.addEventListener(ChatEvent.CONNECTED_TO_VOICE_CHAT_SERVER,this.onVoiceChatEnabled);
         StageReference.stage.addEventListener(ChatEvent.DISCONNECTED_FROM_CHAT_SERVER,this.onVoiceChatDisabled);
      }
      
      public function get selected() : Boolean
      {
         return this.button.selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this.button.selected = value;
         this.check.visible = value;
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
         this.selected = this.voiceChatRoom == this.chatRoom;
         invalidateProperties();
      }
      
      override public function commitProperties() : void
      {
         this.check.visible = this.button.selected;
      }
      
      override public function createChildren() : void
      {
         this.button = new BevelButton("VOICE CHAT",0,0,100,30,"bevelButtonColor");
         this.button.color = 4278234880;
         this.button.toggle = true;
         this.button.setPadding(5,7);
         this.button.hilight = true;
         this.button.tabEnabled = false;
         this.button.fontColor = 0;
         this.button.fontSize = 8;
         this.button.fontThickness = 0;
         this.button.addEventListener(ButtonEvent.CHANGED,this.onVoiceChatChanged);
         addContentChild(this.button);
         this.phoneIcon = new GraphicManager.iconPhone2();
         this.phoneIcon.mouseEnabled = false;
         GraphicUtil.setColor(this.phoneIcon,4294967295);
         this.phoneIcon.scaleX = this.phoneIcon.scaleY = 0.23;
         addContentChild(this.phoneIcon);
         this.checkBox = new Sprite();
         this.checkBox.mouseEnabled = false;
         this.checkBox.graphics.beginFill(16777215,0.15);
         this.checkBox.graphics.drawRect(0,0,12,12);
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(10,10,Math.PI / 2);
         this.checkBox.graphics.beginGradientFill(GradientType.LINEAR,[7691,2641969],[1,1],[0,255],matrix);
         this.checkBox.graphics.drawRect(1,1,10,10);
         this.checkBox.graphics.endFill();
         addContentChild(this.checkBox);
         this.check = new GraphicManager.iconCheck();
         this.check.mouseEnabled = false;
         GraphicUtil.setColor(this.check,4294967295);
         this.check.scaleX = this.check.scaleY = 0.15;
         addContentChild(this.check);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.phoneIcon.x = this.button.padding.left;
         this.phoneIcon.y = this.button.height / 2 - this.phoneIcon.height / 2 - 1;
         this.checkBox.x = unscaledWidth - this.button.padding.right - this.checkBox.width - 2;
         this.checkBox.y = this.button.height / 2 - this.checkBox.height / 2 + 1;
         this.check.x = this.checkBox.x + this.checkBox.width / 2 - this.check.width / 2;
         this.check.y = this.checkBox.y + this.checkBox.height / 2 - this.check.height / 2;
      }
      
      override public function measure() : void
      {
         measuredWidth = this.button.width;
         measuredHeight = this.button.height;
      }
      
      private function onVoiceChatEnabled(event:Event) : void
      {
         this.selected = true;
      }
      
      private function onVoiceChatDisabled(event:Event) : void
      {
         this.selected = false;
      }
      
      private function onVoiceChatChanged(event:ButtonEvent) : void
      {
         var chatEvent:ChatEvent = null;
         if(this.button.selected)
         {
            this.voiceChatRoom = this.chatRoom;
            chatEvent = new ChatEvent(ChatEvent.ENABLE_VOICE_CHAT,true,true);
            chatEvent.voiceChatChannel = this.voiceChatRoom.room.roomJID;
            dispatchEvent(chatEvent);
            if(AppComponents.model.privateUser.profile.premiumLevel < VoiceChatManager.REQUIRED_PREMIUM_LEVEL)
            {
               this.button.selected = false;
               this.voiceChatRoom = null;
            }
         }
         else
         {
            chatEvent = new ChatEvent(ChatEvent.DISABLE_VOICE_CHAT,true,true);
            chatEvent.voiceChatChannel = this.voiceChatRoom.room.roomJID;
            dispatchEvent(chatEvent);
            this.voiceChatRoom = null;
         }
         invalidateProperties();
      }
   }
}
