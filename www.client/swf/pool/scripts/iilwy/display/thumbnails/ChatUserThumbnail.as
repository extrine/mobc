package iilwy.display.thumbnails
{
   import flash.events.MouseEvent;
   import iilwy.application.AppComponents;
   import iilwy.events.ChatUserEvent;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.namespaces.omgpop_internal;
   
   use namespace omgpop_internal;
   
   public class ChatUserThumbnail extends AbstractUserThumbnail
   {
       
      
      protected var _chatUser:ChatUser;
      
      public function ChatUserThumbnail(x:Number = 0, y:Number = 0, size:Number = 40, styleID:String = "thumbnail")
      {
         super(x,y,size,styleID);
      }
      
      public function get chatUser() : ChatUser
      {
         return this._chatUser;
      }
      
      public function set chatUser(value:ChatUser) : void
      {
         if(this._chatUser)
         {
            this._chatUser.removeEventListener(ChatUserEvent.UPDATE,this.onUpdate);
         }
         this._chatUser = value;
         if(this._chatUser)
         {
            useVerbosePhotoUrl = this._chatUser.isFacebookUser();
            profileData = this._chatUser.asProfileData();
            if(!this._chatUser.photoURL)
            {
               if(this._chatUser.vCard && this._chatUser.vCard.photo && this._chatUser.vCard.photo.bytes)
               {
                  bytes = this._chatUser.vCard.photo.bytes;
               }
            }
            this._chatUser.addEventListener(ChatUserEvent.UPDATE,this.onUpdate);
         }
         else
         {
            profileData = null;
         }
      }
      
      override protected function onMouseDown(event:MouseEvent) : void
      {
         if(this._chatUser && this._chatUser.vCard.loaded && contextMenuEnabled)
         {
            AppComponents.contextMenuManager.showChatUserContextMenu(this._chatUser,this,contextMenuAlign);
         }
      }
      
      protected function onUpdate(event:ChatUserEvent) : void
      {
         if(!event.chatUser.jid.equals(this._chatUser.jid,true))
         {
            return;
         }
         if(!url && this._chatUser.photoURL)
         {
            profileData = this._chatUser.asProfileData();
         }
         else if(!this._chatUser.photoURL)
         {
            if(this._chatUser.vCard && this._chatUser.vCard.photo && this._chatUser.vCard.photo.bytes)
            {
               bytes = this._chatUser.vCard.photo.bytes;
            }
         }
      }
   }
}
