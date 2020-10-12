package iilwy.display.chat.listitems
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatRoomManager;
   import iilwy.chat.VoiceChatManager;
   import iilwy.display.chat.enum.ChatRoomWindowView;
   import iilwy.events.ChatEvent;
   import iilwy.managers.GraphicManager;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoScrollLabelButton;
   import iilwy.ui.controls.SimpleButton;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.utils.CapType;
   import iilwy.ui.utils.ControlAlign;
   
   public class ChatRoomButtonListItem extends UiContainer
   {
       
      
      private var _openButton:AutoScrollLabelButton;
      
      private var _closeButton:SimpleButton;
      
      private var chatRoomManager:ChatRoomManager;
      
      private var voiceChatManager:VoiceChatManager;
      
      private var roomData:ChatRoom;
      
      private var voiceChatIcon:Bitmap;
      
      private var isActiveVCRoom:Boolean;
      
      public function ChatRoomButtonListItem()
      {
         super();
         setPadding(0);
         this.chatRoomManager = AppComponents.chatRoomManager;
         this.voiceChatManager = AppComponents.voiceChatManager;
         this.voiceChatManager.addEventListener(ChatEvent.VOICE_CHAT_ENABLED,this.onVoiceChatEnableChanged,false,0,true);
         this.voiceChatManager.addEventListener(ChatEvent.VOICE_CHAT_DISABLED,this.onVoiceChatEnableChanged,false,0,true);
      }
      
      public function get openButton() : SimpleButton
      {
         return this._openButton;
      }
      
      public function get closeButton() : SimpleButton
      {
         return this._closeButton;
      }
      
      override public function createChildren() : void
      {
         this._openButton = new AutoScrollLabelButton(null,0,0,120,22,"simpleButtonBottomTab");
         this._openButton.toggle = true;
         this._openButton.capType = CapType.TAB_BOTTOM;
         this._openButton.tooltipAlign = ControlAlign.TOP;
         this._openButton.icon = BlankIcon;
         this._openButton.iconColor = 0;
         this._openButton.iconAlign = TextFormatAlign.RIGHT;
         this._openButton.addEventListener(MouseEvent.CLICK,this.onOpenClick);
         this._openButton.addEventListener(ButtonEvent.ROLL_OVER,this.onOpenOver);
         this._openButton.addEventListener(ButtonEvent.ROLL_OUT,this.onOpenOut);
         addContentChild(this._openButton);
         this._closeButton = new SimpleButton(null,0,0,12,12);
         this._closeButton.visible = false;
         this._closeButton.capType = CapType.ROUND;
         this._closeButton.icon = GraphicManager.iconX1;
         this._closeButton.iconAlign = TextFormatAlign.CENTER;
         this._closeButton.addEventListener(ButtonEvent.CLICK,this.onCloseClick);
         this._closeButton.addEventListener(ButtonEvent.ROLL_OUT,this.onCloseOut);
         addContentChild(this._closeButton);
      }
      
      override public function commitProperties() : void
      {
         if(this.roomData)
         {
            this._openButton.label = this.roomData.displayName;
            this._openButton.tooltip = this.roomData.displayName;
            this._closeButton.enabled = true;
            this.isActiveVCRoom = this.voiceChatManager && this.voiceChatManager.channel && this.roomData.room.roomJID.equals(this.voiceChatManager.channel,true);
         }
         else
         {
            this.isActiveVCRoom = false;
         }
      }
      
      override public function measure() : void
      {
         measuredWidth = this._openButton.width;
         measuredHeight = this._openButton.height;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.isActiveVCRoom)
         {
            this._openButton.iconAlign = TextFormatAlign.LEFT;
            this._openButton.icon = VCIcon;
            this._openButton.iconColor = 0;
         }
         else
         {
            this._openButton.iconAlign = TextFormatAlign.RIGHT;
            this._openButton.icon = null;
         }
         this._openButton.invalidateDisplayList();
         this._closeButton.x = this._openButton.x + this._openButton.width - this._closeButton.width - this._openButton.style.paddingRight;
         this._closeButton.y = this._openButton.y + this._openButton.height / 2 - this._closeButton.height / 2;
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
      
      public function set selected(value:Boolean) : void
      {
      }
      
      public function asUiElement() : UiElement
      {
         return this as UiElement;
      }
      
      private function onOpenClick(event:MouseEvent) : void
      {
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.OPEN_CHAT_ROOM,true);
         chatEvent.chatRoomWindowView = ChatRoomWindowView.CHAT;
         chatEvent.chatRoomJIDNode = this.roomData.jidNode;
         dispatchEvent(chatEvent);
      }
      
      private function onOpenOver(event:ButtonEvent) : void
      {
         var roomPass:Object = null;
         var roomJIDNode:String = this.roomData.jidNode;
         if(this.chatRoomManager.roomPass)
         {
            for each(roomPass in ChatRoomManager.ROOM_PASSES)
            {
               if(roomPass.jidNode == roomJIDNode)
               {
                  return;
               }
            }
         }
         this._closeButton.visible = true;
      }
      
      private function onOpenOut(event:ButtonEvent) : void
      {
         var globalPoint:Point = new Point(mouseX,mouseY);
         globalPoint = localToGlobal(globalPoint);
         if(this.closeButton.hitTestPoint(globalPoint.x,globalPoint.y,true))
         {
            return;
         }
         this._closeButton.visible = false;
      }
      
      private function onCloseOut(event:ButtonEvent) : void
      {
         var globalPoint:Point = new Point(mouseX,mouseY);
         globalPoint = localToGlobal(globalPoint);
         if(this.openButton.hitTestPoint(globalPoint.x,globalPoint.y,true))
         {
            return;
         }
         this._closeButton.visible = false;
      }
      
      private function onCloseClick(event:ButtonEvent) : void
      {
         this._closeButton.enabled = false;
         var chatEvent:ChatEvent = new ChatEvent(ChatEvent.LEAVE_CHAT_ROOM,true);
         chatEvent.chatRoom = this.roomData;
         dispatchEvent(chatEvent);
      }
      
      private function onVoiceChatEnableChanged(event:ChatEvent) : void
      {
         invalidateProperties();
         invalidateDisplayList();
      }
   }
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import iilwy.managers.GraphicManager;

class VCIcon extends Sprite
{
   
   private static var VOICECHAT_ICON:BitmapData;
    
   
   function VCIcon()
   {
      super();
      if(!VOICECHAT_ICON)
      {
         VOICECHAT_ICON = new GraphicManager.voicechat_mini_icon().bitmapData;
      }
      addChild(new Bitmap(VOICECHAT_ICON,PixelSnapping.ALWAYS));
   }
}

import flash.display.Sprite;

class BlankIcon extends Sprite
{
    
   
   private var size:int = 12;
   
   function BlankIcon()
   {
      super();
      this.draw();
   }
   
   private function draw() : void
   {
      graphics.beginFill(0,1);
      graphics.drawRect(0,0,this.size,this.size);
      graphics.endFill();
      visible = false;
   }
}
