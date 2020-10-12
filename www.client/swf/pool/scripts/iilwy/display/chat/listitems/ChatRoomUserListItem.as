package iilwy.display.chat.listitems
{
   import flash.events.MouseEvent;
   import iilwy.chat.VoiceChatManager;
   import iilwy.display.chat.voicemeter.VoiceMeter;
   import iilwy.display.thumbnails.ChatRoomUserThumbnail;
   import iilwy.events.ChatUserEvent;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.ui.containers.IListViewItem;
   import iilwy.ui.containers.ListViewDataWrapper;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.controls.AutoScrollLabelMultiple;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.TextBlock;
   import iilwy.ui.controls.UiElement;
   import iilwy.ui.partials.badges.ChatUserBadgeSet;
   
   public class ChatRoomUserListItem extends UiContainer implements IListViewItem
   {
       
      
      private var divider:Divider;
      
      private var thumbnail:ChatRoomUserThumbnail;
      
      private var infoBlock:TextBlock;
      
      private var labels:AutoScrollLabelMultiple;
      
      private var chatUserBadgeSet:ChatUserBadgeSet;
      
      private var roomUserData:ChatRoomUser;
      
      private var _useDivider:Boolean;
      
      private var voiceMeter:VoiceMeter;
      
      private var labelX:Number;
      
      private var labelWidth:Number;
      
      public function ChatRoomUserListItem()
      {
         super();
         setPadding(4,0);
      }
      
      override public function createChildren() : void
      {
         addContainerBackground();
         this.divider = new Divider(0,0,100,1);
         addContentChild(this.divider);
         this.thumbnail = new ChatRoomUserThumbnail(0,0,26);
         this.thumbnail.borderSize = 0;
         addContentChild(this.thumbnail);
         this.infoBlock = new TextBlock();
         this.infoBlock.setStyleById("cssBlock");
         addContentChild(this.infoBlock);
         this.labels = new AutoScrollLabelMultiple(2);
         this.labels.idleScroll = true;
         this.labels.itemPadding = -3;
         this.labels.getLabelAt(0).setStyleById("small");
         this.labels.getLabelAt(1).setStyleById("small");
         this.labels.getLabelAt(1).label.fontColor = 8421504;
         addContentChild(this.labels);
         this.labelX = this.labels.getLabelAt(1).x;
         this.labelWidth = this.labels.getLabelAt(1).width;
         this.chatUserBadgeSet = new ChatUserBadgeSet();
         addContentChild(this.chatUserBadgeSet);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      override public function commitProperties() : void
      {
         var userInfo:String = null;
         if(this.roomUserData)
         {
            this.thumbnail.chatRoomUser = this.roomUserData;
            this.labels.idleScroll = false;
            this.labels.getLabelAt(0).text = this.roomUserData.chatUser.asProfileData().displayName;
            userInfo = this.roomUserData.chatUser.getAboutString();
            this.labels.getLabelAt(1).text = userInfo;
            this.chatUserBadgeSet.level = this.roomUserData.chatUser.premiumLevel;
            this.chatUserBadgeSet.chatUser = this.roomUserData.chatUser;
            if(this.roomUserData.chatUser.premiumLevel >= VoiceChatManager.REQUIRED_PREMIUM_LEVEL)
            {
               this.labels.getLabelAt(1).text = "";
               if(!this.voiceMeter)
               {
                  this.voiceMeter = new VoiceMeter();
                  addChild(this.voiceMeter);
               }
               else if(!contains(this.voiceMeter))
               {
                  addChild(this.voiceMeter);
               }
            }
            else if(this.voiceMeter && contains(this.voiceMeter))
            {
               removeChild(this.voiceMeter);
            }
            if(this.voiceMeter)
            {
               this.voiceMeter.user = this.roomUserData.chatUser;
               this.voiceMeter.channel = this.roomUserData.chatRoom.room.roomJID;
            }
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
         this.thumbnail.x = padding.left;
         this.thumbnail.y = padding.top;
         this.labels.x = this.thumbnail.x + this.thumbnail.width + 3;
         this.labels.y = padding.top;
         this.labels.getLabelAt(1).x = this.labelX;
         this.labels.getLabelAt(1).width = this.labelWidth;
         if(this.voiceMeter && contains(this.voiceMeter))
         {
            this.voiceMeter.x = innerWidth - this.voiceMeter.width;
            this.voiceMeter.y = measuredHeight / 2 - this.voiceMeter.height / 2;
            this.labels.width = this.voiceMeter.x - this.labels.x - 3;
         }
         else
         {
            this.labels.width = innerWidth - this.thumbnail.width - 3;
         }
         this.chatUserBadgeSet.y = this.thumbnail.y + this.thumbnail.height - 10;
         this.chatUserBadgeSet.x = this.labels.x + 2;
      }
      
      public function get data() : ChatRoomUser
      {
         return this.roomUserData;
      }
      
      public function set data(value:ChatRoomUser) : void
      {
         if(this.roomUserData && this.roomUserData.chatUser)
         {
            this.roomUserData.chatUser.removeEventListener(ChatUserEvent.UPDATE,this.onUpdate);
         }
         this.roomUserData = value;
         if(this.roomUserData && this.roomUserData.chatUser)
         {
            this.roomUserData.chatUser.loadVCard();
            this.roomUserData.chatUser.addEventListener(ChatUserEvent.UPDATE,this.onUpdate);
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function setListViewData(wrapper:ListViewDataWrapper) : void
      {
         if(wrapper && wrapper.data is ChatRoomUser)
         {
            this.roomUserData = wrapper.data;
            this.roomUserData.chatUser.addEventListener(ChatUserEvent.UPDATE,this.onUpdate);
            this.roomUserData.chatUser.loadVCard();
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
         }
         else
         {
            if(this.roomUserData && this.roomUserData.chatUser)
            {
               this.roomUserData.chatUser.removeEventListener(ChatUserEvent.UPDATE,this.onUpdate);
            }
            this.roomUserData = null;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function set useDivider(value:Boolean) : void
      {
         if(this._useDivider != value)
         {
            this._useDivider = value;
            invalidateDisplayList();
         }
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
         this.thumbnail.contextButtonOutAlpha = 0.6;
         this.thumbnail.contextButtonVisible = true;
      }
      
      protected function onMouseOut(event:MouseEvent) : void
      {
         this.thumbnail.contextButtonVisible = false;
      }
      
      protected function onUpdate(event:ChatUserEvent) : void
      {
         invalidateProperties();
         invalidateDisplayList();
      }
   }
}
