package iilwy.model.dataobjects.chat
{
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class ChatRoomUser
   {
       
      
      public var chatUser:ChatUser;
      
      public var chatRoom:ChatRoom;
      
      public function ChatRoomUser(chatUser:ChatUser, chatRoom:ChatRoom)
      {
         super();
         this.chatUser = chatUser;
         this.chatRoom = chatRoom;
      }
      
      public function get isMe() : Boolean
      {
         return this.chatUser && this.chatUser.isMe;
      }
      
      public function get isOwner() : Boolean
      {
         return this.privilegeMatches(Room.AFFILIATION_OWNER);
      }
      
      public function get isAdmin() : Boolean
      {
         return this.privilegeMatches(Room.AFFILIATION_ADMIN);
      }
      
      public function get isModerator() : Boolean
      {
         return this.privilegeMatches(null,Room.ROLE_MODERATOR);
      }
      
      private function privilegeMatches(affiliation:String = null, role:String = null) : Boolean
      {
         var value:Boolean = false;
         var occupant:RoomOccupant = null;
         if(!affiliation && !role)
         {
            return false;
         }
         if(!this.chatUser || !this.chatRoom)
         {
            return false;
         }
         if(this.isMe)
         {
            if(affiliation)
            {
               value = this.chatRoom.room.affiliation == affiliation;
            }
            else if(role)
            {
               value = this.chatRoom.room.role == role;
            }
         }
         else
         {
            occupant = this.chatRoom.room.getOccupantNamed(this.chatUser.displayName);
            if(!occupant)
            {
               return false;
            }
            if(affiliation)
            {
               value = occupant.affiliation == affiliation;
            }
            else if(role)
            {
               value = occupant.role == role;
            }
         }
         return value;
      }
   }
}
