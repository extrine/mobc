package iilwy.factories.context
{
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.context.ContextAction;
   import iilwy.ui.controls.MultiSelectData;
   import iilwy.utils.ArrayUtil;
   import org.igniterealtime.xiff.conference.Room;
   
   public class ChatRoomUserContextActionFactory extends ChatUserContextActionFactory
   {
       
      
      protected var chatRoomUser:ChatRoomUser;
      
      public function ChatRoomUserContextActionFactory(chatRoomUser:ChatRoomUser)
      {
         this.chatRoomUser = chatRoomUser;
         super(chatRoomUser.chatUser);
      }
      
      override public function getContextOptions() : Array
      {
         var options:Array = super.getContextOptions();
         if(isOptionAvailable(ContextAction.BAN.id) && !profileData.isMe)
         {
            if((this.isOwner || this.isAdmin) && (!this.chatRoomUser.isOwner && !this.chatRoomUser.isAdmin))
            {
               options.push(new MultiSelectData(ContextAction.BAN.label,ContextAction.BAN.id));
            }
         }
         if(isOptionAvailable(ContextAction.GRANT_ADMIN.id) && !profileData.isMe)
         {
            if(this.isOwner && !this.chatRoomUser.isOwner && !this.chatRoomUser.isAdmin)
            {
               options.push(new MultiSelectData(ContextAction.GRANT_ADMIN.label,ContextAction.GRANT_ADMIN.id));
            }
         }
         if(isOptionAvailable(ContextAction.GRANT_OWNER.id) && !profileData.isMe)
         {
            if(this.isOwner && !this.chatRoomUser.isOwner)
            {
               options.push(new MultiSelectData(ContextAction.GRANT_OWNER.label,ContextAction.GRANT_OWNER.id));
            }
         }
         if(isOptionAvailable(ContextAction.KICK.id) && !profileData.isMe)
         {
            if((this.isOwner || this.isAdmin) && (!this.chatRoomUser.isOwner && !this.chatRoomUser.isAdmin && !this.chatRoomUser.isModerator))
            {
               options.push(new MultiSelectData(ContextAction.KICK.label,ContextAction.KICK.id));
            }
         }
         if(isOptionAvailable(ContextAction.REVOKE_ADMIN.id) && !profileData.isMe)
         {
            if(this.isOwner && this.chatRoomUser.isAdmin)
            {
               options.push(new MultiSelectData(ContextAction.REVOKE_ADMIN.label,ContextAction.REVOKE_ADMIN.id));
            }
         }
         if(isOptionAvailable(ContextAction.REVOKE_OWNER.id) && !profileData.isMe)
         {
            if(this.isOwner && this.chatRoomUser.isOwner)
            {
               options.push(new MultiSelectData(ContextAction.REVOKE_OWNER.label,ContextAction.REVOKE_OWNER.id));
            }
         }
         options = ArrayUtil.sortArrayByArray(options,availableOptions,["value"]);
         return options;
      }
      
      protected function get isOwner() : Boolean
      {
         return this.chatRoomUser.chatRoom && this.chatRoomUser.chatRoom.room.affiliation == Room.AFFILIATION_OWNER;
      }
      
      protected function get isAdmin() : Boolean
      {
         return this.chatRoomUser.chatRoom && this.chatRoomUser.chatRoom.room.affiliation == Room.AFFILIATION_ADMIN;
      }
      
      protected function get isModerator() : Boolean
      {
         return this.chatRoomUser.chatRoom && this.chatRoomUser.chatRoom.room.role == Room.ROLE_MODERATOR;
      }
   }
}
