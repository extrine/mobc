package iilwy.display.thumbnails
{
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   
   public class ChatRoomUserThumbnail extends ChatUserThumbnail
   {
       
      
      protected var _chatRoomUser:ChatRoomUser;
      
      public function ChatRoomUserThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail")
      {
         super(x,y,size,styleID);
      }
      
      public function get chatRoomUser() : ChatRoomUser
      {
         return this._chatRoomUser;
      }
      
      public function set chatRoomUser(value:ChatRoomUser) : void
      {
         this._chatRoomUser = value;
         chatUser = this._chatRoomUser.chatUser;
      }
      
      override protected function onMouseDown(event:MouseEvent) : void
      {
         if(this._chatRoomUser && this._chatRoomUser.chatUser && this._chatRoomUser.chatUser.vCard.loaded && contextMenuEnabled)
         {
            AppComponents.contextMenuManager.showChatRoomUserContextMenu(this._chatRoomUser,this,contextMenuAlign);
         }
      }
   }
}
