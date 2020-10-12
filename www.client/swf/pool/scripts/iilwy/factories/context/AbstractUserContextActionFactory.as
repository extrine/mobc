package iilwy.factories.context
{
   import com.adobe.utils.ArrayUtil;
   import iilwy.application.AppComponents;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.context.ContextAction;
   import iilwy.model.dataobjects.user.PremiumLevels;
   import iilwy.ui.controls.MultiSelectData;
   
   public class AbstractUserContextActionFactory
   {
       
      
      protected var profileData:ProfileData;
      
      protected var availableOptions:Array;
      
      public function AbstractUserContextActionFactory(profileData:ProfileData)
      {
         super();
         this.profileData = profileData;
         this.availableOptions = new Array();
      }
      
      public function addAvailableOptions(... options) : void
      {
         var option:String = null;
         for each(option in options)
         {
            this.addAvailableOption(option);
         }
      }
      
      public function addAvailableOption(option:String) : void
      {
         this.addAvailableOptionAt(option,this.availableOptions.length);
      }
      
      public function addAvailableOptionAt(option:String, index:int) : void
      {
         if(!ArrayUtil.arrayContainsValue(this.availableOptions,option))
         {
            this.availableOptions.splice(index,0,option);
         }
      }
      
      public function removeAvailableOption(option:String) : void
      {
         ArrayUtil.removeValueFromArray(this.availableOptions,option);
      }
      
      public function removeAvailableOptionAt(index:int) : void
      {
         this.availableOptions.splice(index,1);
      }
      
      public function removeAllAvailableOptions() : void
      {
         this.availableOptions = [];
      }
      
      public function getAvailableOptions() : Array
      {
         return this.availableOptions;
      }
      
      public function getContextOptions() : Array
      {
         var options:Array = [];
         if(this.isOptionAvailable(ContextAction.ADD_FRIEND.id) && !this.profileData.isMe)
         {
            if(!this.profileData.isFriend)
            {
               options.push(new MultiSelectData(ContextAction.ADD_FRIEND.label,ContextAction.ADD_FRIEND.id));
            }
         }
         if(this.isOptionAvailable(ContextAction.CHAT.id) && this.profileData.isFriend && this.profileData.isOnlineFriend || AppComponents.model.privateUser.profile.premiumLevel >= PremiumLevels.CREW && this.profileData.id != AppComponents.model.privateUser.profile.id)
         {
            options.push(new MultiSelectData(ContextAction.CHAT.label,ContextAction.CHAT.id));
         }
         if(this.isOptionAvailable(ContextAction.DISLIKE.id) && this.isLoggedIn && !this.profileData.isMe)
         {
            options.push(new MultiSelectData(ContextAction.DISLIKE.label,ContextAction.DISLIKE.id));
         }
         if(this.isOptionAvailable(ContextAction.INVITE.id) && !this.profileData.isMe && this.profileData.onlineStatus && this.profileData.onlineStatus.isInvitable)
         {
            if(AppComponents.model.privateUser.profile.onlineStatus && AppComponents.model.privateUser.profile.onlineStatus.isJoinable && AppComponents.model.privateUser.profile.onlineStatus.type != PlayerStatus.TYPE_LOBBY)
            {
               options.push(new MultiSelectData(ContextAction.INVITE.label,ContextAction.INVITE.id));
            }
         }
         if(this.isOptionAvailable(ContextAction.JOIN.id) && !this.profileData.isMe && this.profileData.onlineStatus && this.profileData.onlineStatus.isJoinable)
         {
            options.push(new MultiSelectData(ContextAction.JOIN.label,ContextAction.JOIN.id));
         }
         if(this.isOptionAvailable(ContextAction.LIKE.id) && this.isLoggedIn && !this.profileData.isMe)
         {
            options.push(new MultiSelectData(ContextAction.LIKE.label,ContextAction.LIKE.id));
         }
         if(this.isOptionAvailable(ContextAction.MANAGE_PROFILE.id) && this.profileData.isMe)
         {
            options.push(new MultiSelectData(ContextAction.MANAGE_PROFILE.label,ContextAction.MANAGE_PROFILE.id));
         }
         if(this.isOptionAvailable(ContextAction.MESSAGE.id) && this.profileData.isFriend)
         {
            options.push(new MultiSelectData(ContextAction.MESSAGE.label,ContextAction.MESSAGE.id));
         }
         if(this.isOptionAvailable(ContextAction.MUTE.id) && !this.profileData.isMe)
         {
            if(!this.isMuted)
            {
               options.push(new MultiSelectData(ContextAction.MUTE.label,ContextAction.MUTE.id));
            }
         }
         if(this.isOptionAvailable(ContextAction.POPUP_PROFILE.id) && this.isLoggedIn)
         {
            options.push(new MultiSelectData(ContextAction.POPUP_PROFILE.label,ContextAction.POPUP_PROFILE.id));
         }
         if(this.isOptionAvailable(ContextAction.REMOVE_FRIEND.id) && !this.profileData.isMe)
         {
            if(this.profileData.isFriend)
            {
               options.push(new MultiSelectData(ContextAction.REMOVE_FRIEND.label,ContextAction.REMOVE_FRIEND.id));
            }
         }
         if(this.isOptionAvailable(ContextAction.REPORT.id) && !this.profileData.isMe)
         {
            options.push(new MultiSelectData(ContextAction.REPORT.label,ContextAction.REPORT.id));
         }
         if(this.isOptionAvailable(ContextAction.SEND_TO_FRIEND.id) && !this.profileData.isMe)
         {
            options.push(new MultiSelectData(ContextAction.SEND_TO_FRIEND.label,ContextAction.SEND_TO_FRIEND.id));
         }
         if(this.isOptionAvailable(ContextAction.UNMUTE.id) && !this.profileData.isMe)
         {
            if(this.isMuted)
            {
               options.push(new MultiSelectData(ContextAction.UNMUTE.label,ContextAction.UNMUTE.id));
            }
         }
         if(this.isOptionAvailable(ContextAction.VIEW_PROFILE.id))
         {
            options.push(new MultiSelectData(ContextAction.VIEW_PROFILE.label,ContextAction.VIEW_PROFILE.id));
         }
         options = ArrayUtil.sortArrayByArray(options,this.availableOptions,["value"]);
         return options;
      }
      
      public function isOptionAvailable(option:String) : Boolean
      {
         var avail:Boolean = false;
         var index:int = this.availableOptions.indexOf(option);
         if(index >= 0)
         {
            avail = true;
         }
         return avail;
      }
      
      protected function get isLoggedIn() : Boolean
      {
         return AppComponents.model.privateUser.isLoggedIn;
      }
      
      protected function get isMuted() : Boolean
      {
         return AppComponents.model.privateUser.isProfileMuted(this.profileData.id);
      }
   }
}
