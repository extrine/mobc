package iilwy.display.context
{
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.events.ApplicationEvent;
   import iilwy.factories.context.AbstractUserContextActionFactory;
   import iilwy.factories.context.PlayerContextActionFactory;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.context.ContextAction;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.MediaProxy;
   import iilwy.ui.controls.MultiSelectData;
   
   use namespace omgpop_internal;
   
   public class PlayerContextMenu extends AbstractUserContextMenu
   {
       
      
      protected var _playerData:PlayerData;
      
      public function PlayerContextMenu()
      {
         super();
      }
      
      public function set playerData(value:PlayerData) : void
      {
         var guestOptions:Array = null;
         var isMuted:Boolean = false;
         var profile:ProfileData = null;
         _profileData = null;
         this._playerData = value;
         if(this._playerData.profileId == null)
         {
            multiScroller.getLabelAt(0).text = this._playerData.displayName;
            multiScroller.getLabelAt(1).text = this._playerData.getAboutString();
            multiScroller.getLabelAt(1).reset();
            profileBadgeSet.level = PremiumLevels.NONE;
            profileBadgeSet.profileData = null;
            imageScroller.url = MediaProxy.url(this._playerData.profilePhoto,MediaProxy.SIZE_SMALL);
            guestOptions = [];
            isMuted = AppComponents.model.privateUser.isGuestMuted(this._playerData.guestId);
            if(isMuted)
            {
               guestOptions.push(new MultiSelectData(ContextAction.UNMUTE.label,ContextAction.UNMUTE.id));
            }
            else
            {
               guestOptions.push(new MultiSelectData(ContextAction.MUTE.label,ContextAction.MUTE.id));
            }
            contextSimpleMenu.setData(guestOptions);
            invalidateSize();
            return;
         }
         profile = this._playerData.asProfileData();
         profileData = profile;
      }
      
      override public function destroy() : void
      {
         this._playerData = null;
         super.destroy();
      }
      
      override protected function addAvailableOptions() : void
      {
         var displaySocial:Boolean = false;
         super.addAvailableOptions();
         if(!AppProperties.appVersionIsWebsiteOrAIR)
         {
            displaySocial = EmbedSettings.getInstance().displaySocial;
            if(displaySocial)
            {
               actionFactory.addAvailableOptionAt(ContextAction.POPUP_PROFILE.id,2);
            }
         }
         contextOptions = actionFactory.getContextOptions();
      }
      
      override protected function createContextActionFactory() : AbstractUserContextActionFactory
      {
         return new PlayerContextActionFactory(this._playerData);
      }
      
      override protected function createContextActionEvent(action:String) : ApplicationEvent
      {
         var appEvent:ApplicationEvent = super.createContextActionEvent(action);
         appEvent.playerData = this._playerData;
         return appEvent;
      }
   }
}
