package iilwy.display.context
{
   import iilwy.events.ApplicationEvent;
   import iilwy.factories.context.AbstractUserContextActionFactory;
   import iilwy.factories.context.ChatRoomUserContextActionFactory;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.context.ContextAction;
   import iilwy.ui.controls.Divider;
   
   public class ChatRoomUserContextMenu extends ChatUserContextMenu
   {
       
      
      protected var _chatRoomUser:ChatRoomUser;
      
      public function ChatRoomUserContextMenu()
      {
         super();
      }
      
      public function set chatRoomUser(value:ChatRoomUser) : void
      {
         this._chatRoomUser = value;
         chatUser = value.chatUser;
      }
      
      override public function destroy() : void
      {
         this._chatRoomUser = null;
         super.destroy();
      }
      
      override protected function addAvailableOptions() : void
      {
         super.addAvailableOptions();
         actionFactory.addAvailableOption(ContextAction.KICK.id);
         actionFactory.addAvailableOption(ContextAction.BAN.id);
         actionFactory.addAvailableOption(ContextAction.GRANT_ADMIN.id);
         actionFactory.addAvailableOption(ContextAction.GRANT_OWNER.id);
         actionFactory.addAvailableOption(ContextAction.REVOKE_ADMIN.id);
         actionFactory.addAvailableOption(ContextAction.REVOKE_OWNER.id);
         contextOptions = actionFactory.getContextOptions();
      }
      
      override protected function addDividersToOptions() : int
      {
         var numItems:int = super.addDividersToOptions();
         var lastNumItems:int = numItems;
         numItems = numItems + (!!isActionInContextOptions(ContextAction.MUTE)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.UNMUTE)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.CHAT)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.MESSAGE)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.ADD_FRIEND)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.REMOVE_FRIEND)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.SEND_TO_FRIEND)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.LIKE)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.DISLIKE)?1:0);
         numItems = numItems + (!!isActionInContextOptions(ContextAction.REPORT)?1:0);
         var newNumItems:int = 0;
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.KICK)?1:0);
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.BAN)?1:0);
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.GRANT_ADMIN)?1:0);
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.GRANT_OWNER)?1:0);
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.REVOKE_ADMIN)?1:0);
         newNumItems = newNumItems + (!!isActionInContextOptions(ContextAction.REVOKE_OWNER)?1:0);
         if(numItems > lastNumItems && newNumItems > 0)
         {
            contextOptions.splice(numItems,0,Divider.LIST_IDENTIFIER);
            numItems = numItems + 1;
         }
         return numItems;
      }
      
      override protected function createContextActionFactory() : AbstractUserContextActionFactory
      {
         return new ChatRoomUserContextActionFactory(this._chatRoomUser);
      }
      
      override protected function createContextActionEvent(action:String) : ApplicationEvent
      {
         var appEvent:ApplicationEvent = super.createContextActionEvent(action);
         appEvent.chatRoomUser = this._chatRoomUser;
         return appEvent;
      }
   }
}
