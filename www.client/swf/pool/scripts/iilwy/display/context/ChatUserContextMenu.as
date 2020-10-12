package iilwy.display.context
{
   import iilwy.events.ApplicationEvent;
   import iilwy.factories.context.AbstractUserContextActionFactory;
   import iilwy.factories.context.ChatUserContextActionFactory;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.MediaProxy;
   
   use namespace omgpop_internal;
   
   public class ChatUserContextMenu extends AbstractUserContextMenu
   {
       
      
      protected var _chatUser:ChatUser;
      
      public function ChatUserContextMenu()
      {
         super();
      }
      
      public function set chatUser(value:ChatUser) : void
      {
         var profile:ProfileData = null;
         _profileData = null;
         this._chatUser = value;
         if(this._chatUser.profileID == null)
         {
            multiScroller.getLabelAt(0).text = this._chatUser.displayName;
            multiScroller.getLabelAt(1).text = this._chatUser.getAboutString();
            multiScroller.getLabelAt(1).reset();
            profileBadgeSet.level = PremiumLevels.NONE;
            profileBadgeSet.profileData = null;
            imageScroller.url = MediaProxy.url(this._chatUser.photoURL,MediaProxy.SIZE_SMALL);
            invalidateSize();
            return;
         }
         profile = this._chatUser.asProfileData();
         profileData = profile;
      }
      
      override public function destroy() : void
      {
         this._chatUser = null;
         super.destroy();
      }
      
      override protected function addAvailableOptions() : void
      {
         super.addAvailableOptions();
         contextOptions = actionFactory.getContextOptions();
      }
      
      override protected function createContextActionFactory() : AbstractUserContextActionFactory
      {
         return new ChatUserContextActionFactory(this._chatUser);
      }
      
      override protected function createContextActionEvent(action:String) : ApplicationEvent
      {
         var appEvent:ApplicationEvent = super.createContextActionEvent(action);
         appEvent.chatUser = this._chatUser;
         return appEvent;
      }
   }
}
