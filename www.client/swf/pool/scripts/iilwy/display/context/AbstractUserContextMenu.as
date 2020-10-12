package iilwy.display.context
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.application.AppProperties;
   import iilwy.application.EmbedSettings;
   import iilwy.delegates.user.ProfileDelegate;
   import iilwy.display.image.ImagePane;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.AsyncEvent;
   import iilwy.factories.context.AbstractUserContextActionFactory;
   import iilwy.model.dataobjects.MediaItemData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.context.ContextAction;
   import iilwy.namespaces.omgpop_internal;
   import iilwy.net.MediaProxy;
   import iilwy.net.MerbRequest;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.AutoScrollLabelMultiple;
   import iilwy.ui.controls.ContextSimpleMenu;
   import iilwy.ui.controls.Divider;
   import iilwy.ui.controls.MultiSelectData;
   import iilwy.ui.controls.ProcessingIndicator;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.partials.badges.ProfileBadgeSet;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.Responder;
   import iilwy.utils.UiRender;
   import iilwy.utils.logging.Logger;
   
   use namespace omgpop_internal;
   
   public class AbstractUserContextMenu extends UiModule
   {
       
      
      protected var actionFactory:AbstractUserContextActionFactory;
      
      protected var caption:Sprite;
      
      protected var contextOptions:Array;
      
      protected var contextSimpleMenu:ContextSimpleMenu;
      
      protected var flipPhotosIndex:int = 0;
      
      protected var flipPhotosTimer:Timer;
      
      protected var fullProfile:ProfileData;
      
      protected var fullProfileRequest:MerbRequest;
      
      protected var fullProfileTimer:Timer;
      
      protected var imageScroller:ImagePane;
      
      protected var loadingIndicator:ProcessingIndicator;
      
      protected var logger:Logger;
      
      protected var multiScroller:AutoScrollLabelMultiple;
      
      protected var profileBadgeSet:ProfileBadgeSet;
      
      protected var removedTimer:Timer;
      
      protected var _profileData:ProfileData;
      
      public function AbstractUserContextMenu()
      {
         super();
         width = 180;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.logger = Logger.getLogger(this);
         this.logger.level = Logger.LOG;
         this.imageScroller = new ImagePane();
         this.imageScroller.width = 180;
         this.imageScroller.height = 100;
         this.imageScroller.scrollPad = 15;
         this.imageScroller.backgroundColor = 1725026769;
         this.imageScroller.addEventListener(MouseEvent.CLICK,this.onImageScrollerClick);
         addContentChild(this.imageScroller);
         this.loadingIndicator = new ProcessingIndicator(0,0,180,5);
         this.loadingIndicator.cornerRadius = 0;
         this.loadingIndicator.stroke = 0;
         GraphicUtil.setColor(this.loadingIndicator,2583691263);
         addContentChild(this.loadingIndicator);
         this.caption = new Sprite();
         addContentChild(this.caption);
         this.caption.y = 60;
         UiRender.renderRect(this.caption,1711276032,0,0,180,40);
         this.multiScroller = new AutoScrollLabelMultiple(2,3,3,174);
         this.multiScroller.getLabelAt(0).setStyleById("strongWhite");
         this.multiScroller.getLabelAt(1).setStyleById("smallWhite");
         this.caption.addChild(this.multiScroller);
         this.profileBadgeSet = new ProfileBadgeSet();
         this.multiScroller.setAccessoryViewAt(this.profileBadgeSet,0);
         this.fullProfileTimer = new Timer(1500,1);
         this.fullProfileTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFullProfileTimer);
         this.flipPhotosTimer = new Timer(4000,1);
         this.flipPhotosTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFlipPhotosTimer);
         this.removedTimer = new Timer(500,1);
         this.removedTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRemovedTimer);
         this.contextSimpleMenu = new ContextSimpleMenu();
         addContentChild(this.contextSimpleMenu);
         this.contextSimpleMenu.addEventListener(MultiSelectEvent.SELECT,this.onSelect);
         this.contextSimpleMenu.y = 105;
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(visible && !value)
         {
            this.onRemovedFromStage(null);
         }
         super.visible = value;
      }
      
      omgpop_internal function set profileData(value:ProfileData) : void
      {
         this._profileData = value;
         this.logger.log("Setting profile to",this._profileData.profile_name);
         this.fullProfile = null;
         this.cancelFullProfileRequest();
         this.flipPhotosTimer.stop();
         this.fullProfileTimer.reset();
         this.fullProfileTimer.start();
         this.loadingIndicator.visible = true;
         this.loadingIndicator.animate = true;
         this.multiScroller.getLabelAt(0).text = this._profileData.displayName;
         this.multiScroller.getLabelAt(1).text = this._profileData.getAboutString();
         this.multiScroller.getLabelAt(1).reset();
         this.profileBadgeSet.level = this._profileData.premiumLevel;
         this.profileBadgeSet.profileData = this._profileData;
         this.imageScroller.url = MediaProxy.url(this._profileData.photo_url,MediaProxy.SIZE_SMALL);
         this.contextOptions = [];
         if(this._profileData.id == null)
         {
            this.contextSimpleMenu.setData(this.contextOptions);
            invalidateSize();
            return;
         }
         this.addAvailableOptions();
         this.addDividersToOptions();
         this.contextSimpleMenu.setData(this.contextOptions);
         invalidateSize();
      }
      
      override public function destroy() : void
      {
         this._profileData = null;
         super.destroy();
      }
      
      override public function measure() : void
      {
         measuredHeight = this.contextSimpleMenu.height == 0?Number(100):Number(this.contextSimpleMenu.height + 105);
      }
      
      protected function cancelFullProfileRequest() : void
      {
         this.fullProfileTimer.stop();
         try
         {
            this.fullProfileRequest.removeEventListener(AsyncEvent.SUCCESS,this.onFullProfileComplete);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function addAvailableOptions() : void
      {
         var displaySocial:Boolean = false;
         var enableArcadeChat:Boolean = false;
         this.actionFactory = this.createContextActionFactory();
         if(AppProperties.appVersionIsWebsiteOrAIR)
         {
            this.actionFactory.addAvailableOptions(ContextAction.JOIN.id,ContextAction.VIEW_PROFILE.id,ContextAction.POPUP_PROFILE.id,ContextAction.MUTE.id,ContextAction.UNMUTE.id,ContextAction.CHAT.id,ContextAction.MESSAGE.id,ContextAction.ADD_FRIEND.id,ContextAction.REMOVE_FRIEND.id,ContextAction.LIKE.id,ContextAction.DISLIKE.id,ContextAction.REPORT.id);
         }
         else
         {
            displaySocial = EmbedSettings.getInstance().displaySocial;
            enableArcadeChat = EmbedSettings.getInstance().enableArcadeChat;
            if(displaySocial)
            {
               this.actionFactory.addAvailableOption(ContextAction.JOIN.id);
            }
            this.actionFactory.addAvailableOption(ContextAction.VIEW_PROFILE.id);
            if(enableArcadeChat)
            {
               this.actionFactory.addAvailableOption(ContextAction.MUTE.id);
            }
            if(enableArcadeChat)
            {
               this.actionFactory.addAvailableOption(ContextAction.UNMUTE.id);
            }
            if(displaySocial)
            {
               this.actionFactory.addAvailableOption(ContextAction.ADD_FRIEND.id);
            }
            if(displaySocial)
            {
               this.actionFactory.addAvailableOption(ContextAction.REMOVE_FRIEND.id);
            }
            this.actionFactory.addAvailableOption(ContextAction.REPORT.id);
         }
         this.contextOptions = this.actionFactory.getContextOptions();
      }
      
      protected function addDividersToOptions() : int
      {
         var numItems:int = 0;
         var lastNumItems:int = numItems;
         numItems = numItems + (!!this.isActionInContextOptions(ContextAction.JOIN)?1:0);
         if(numItems > lastNumItems)
         {
            this.contextOptions.splice(numItems,0,Divider.LIST_IDENTIFIER);
            numItems = numItems + 1;
         }
         lastNumItems = numItems;
         numItems = numItems + (!!this.isActionInContextOptions(ContextAction.VIEW_PROFILE)?1:0);
         numItems = numItems + (!!this.isActionInContextOptions(ContextAction.POPUP_PROFILE)?1:0);
         if(numItems > lastNumItems && this.isLoggedIn && !this._profileData.isMe)
         {
            this.contextOptions.splice(numItems,0,Divider.LIST_IDENTIFIER);
            numItems = numItems + 1;
         }
         return numItems;
      }
      
      protected function flipPhotos() : void
      {
         var mi:MediaItemData = null;
         if(this.fullProfile != null && this.fullProfile.photos.length > 1)
         {
            this.logger.log("Flipping");
            mi = this.fullProfile.photos[this.flipPhotosIndex];
            this.imageScroller.url = MediaProxy.url(mi.url,MediaProxy.SIZE_SMALL);
            if(++this.flipPhotosIndex >= this.fullProfile.photos.length)
            {
               this.flipPhotosIndex = 0;
            }
         }
         if(stage != null)
         {
            this.flipPhotosTimer.reset();
            this.flipPhotosTimer.start();
         }
      }
      
      protected function isActionInContextOptions(action:ContextAction) : Boolean
      {
         var avail:Boolean = false;
         var option:* = undefined;
         for each(option in this.contextOptions)
         {
            if(option is MultiSelectData)
            {
               if(option.value == action.id)
               {
                  avail = true;
                  break;
               }
            }
         }
         return avail;
      }
      
      protected function get isLoggedIn() : Boolean
      {
         return AppComponents.model.privateUser.isLoggedIn;
      }
      
      protected function createContextActionFactory() : AbstractUserContextActionFactory
      {
         throw new Error("Concrete class must implement the createContextActionFactory method.");
      }
      
      protected function createContextActionEvent(action:String) : ApplicationEvent
      {
         var responder:Responder = new Responder();
         responder.setAsyncListeners(this.onProfileActionComplete);
         var appEvent:ApplicationEvent = new ApplicationEvent(ApplicationEvent.DO_CONTEXT_ACTION);
         appEvent.contextAction = action;
         appEvent.profileData = this._profileData;
         appEvent.responder = responder;
         return appEvent;
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this.removedTimer.reset();
         this.removedTimer.start();
      }
      
      protected function onImageScrollerClick(event:MouseEvent) : void
      {
         this.flipPhotos();
      }
      
      protected function onFullProfileTimer(event:TimerEvent) : void
      {
         this.cancelFullProfileRequest();
         if(!this._profileData)
         {
            return;
         }
         this.logger.log("Loading full profile for " + this._profileData.profile_name);
         var del:ProfileDelegate = new ProfileDelegate(this.onFullProfileComplete);
         this.fullProfileRequest = del.getProfile(this._profileData.id);
      }
      
      protected function onFlipPhotosTimer(event:TimerEvent) : void
      {
         this.flipPhotos();
      }
      
      protected function onRemovedTimer(event:TimerEvent) : void
      {
         if(stage == null || !visible)
         {
            this.logger.log("removed from stage");
            this.cancelFullProfileRequest();
            this.flipPhotosTimer.stop();
            this.loadingIndicator.visible = false;
            this.loadingIndicator.animate = false;
         }
      }
      
      protected function onSelect(event:MultiSelectEvent) : void
      {
         dispatchEvent(this.createContextActionEvent(event.value));
      }
      
      protected function onFullProfileComplete(event:AsyncEvent) : void
      {
         this.loadingIndicator.visible = false;
         this.loadingIndicator.animate = false;
         this.fullProfile = ProfileData.createFromMerbResult(event.data.user);
         if(this.multiScroller.getLabelAt(1).text == null || this.multiScroller.getLabelAt(1).text == "")
         {
            this.multiScroller.getLabelAt(1).text = this.fullProfile.getAboutString();
            this.multiScroller.getLabelAt(1).reset();
         }
         this.flipPhotosTimer.reset();
         this.flipPhotosTimer.start();
         this.flipPhotosIndex = 1;
         this.flipPhotos();
      }
      
      protected function onProfileActionComplete(event:AsyncEvent) : void
      {
      }
   }
}
