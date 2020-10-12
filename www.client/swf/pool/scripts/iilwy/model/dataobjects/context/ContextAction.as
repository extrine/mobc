package iilwy.model.dataobjects.context
{
   import flash.utils.Dictionary;
   
   public class ContextAction
   {
      
      public static const ADD_FRIEND:ContextAction = new ContextAction("addFriend","Add Friend");
      
      public static const BAN:ContextAction = new ContextAction("ban","Ban");
      
      public static const CHAT:ContextAction = new ContextAction("chat","Chat");
      
      public static const DISLIKE:ContextAction = new ContextAction("dislike","Dislike");
      
      public static const GRANT_ADMIN:ContextAction = new ContextAction("grantModerator","Add Moderator");
      
      public static const GRANT_OWNER:ContextAction = new ContextAction("grantOwner","Add Owner");
      
      public static const INVITE:ContextAction = new ContextAction("invite","Invite");
      
      public static const JOIN:ContextAction = new ContextAction("join","Join");
      
      public static const KICK:ContextAction = new ContextAction("kick","Kick");
      
      public static const LIKE:ContextAction = new ContextAction("like","Like");
      
      public static const MANAGE_PROFILE:ContextAction = new ContextAction("manageProfile","Manage Profile");
      
      public static const MESSAGE:ContextAction = new ContextAction("message","Message");
      
      public static const MUTE:ContextAction = new ContextAction("mute","Mute");
      
      public static const POPUP_PROFILE:ContextAction = new ContextAction("popupProfile","Popup Profile");
      
      public static const REMOVE_FRIEND:ContextAction = new ContextAction("removeFriend","Remove Friend");
      
      public static const REPORT:ContextAction = new ContextAction("report","Report");
      
      public static const REVOKE_ADMIN:ContextAction = new ContextAction("revokeModerator","Remove Moderator");
      
      public static const REVOKE_OWNER:ContextAction = new ContextAction("revokeOwner","Remove Owner");
      
      public static const SEND_TO_FRIEND:ContextAction = new ContextAction("sendToFriend","Send To Friend");
      
      public static const UNMUTE:ContextAction = new ContextAction("unmute","Unblock");
      
      public static const VIEW_PROFILE:ContextAction = new ContextAction("viewProfile","View Profile");
      
      private static var finalized:Boolean = true;
      
      private static var idDict:Dictionary;
      
      private static var labelDict:Dictionary;
       
      
      private var _id:String;
      
      private var _label:String;
      
      public function ContextAction(id:String, label:String)
      {
         super();
         if(!idDict)
         {
            idDict = new Dictionary();
         }
         if(!labelDict)
         {
            labelDict = new Dictionary();
         }
         this.id = id;
         this.label = label;
      }
      
      public static function getByID(id:String) : ContextAction
      {
         return idDict[id];
      }
      
      public static function getByLabel(label:String) : ContextAction
      {
         return labelDict[label];
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
         if(!finalized)
         {
            idDict[value] = this;
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         if(!finalized)
         {
            labelDict[value] = this;
         }
      }
   }
}
