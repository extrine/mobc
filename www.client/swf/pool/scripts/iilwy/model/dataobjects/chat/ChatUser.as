package iilwy.model.dataobjects.chat
{
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.chat.ChatManager;
   import iilwy.events.ChatUserEvent;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.model.dataobjects.ExperienceData;
   import iilwy.model.dataobjects.LoginCredentials;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.utils.TextUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.events.VCardEvent;
   import org.igniterealtime.xiff.vcard.VCard;
   
   public class ChatUser extends EventDispatcher
   {
       
      
      public var autoLoadVCard:Boolean;
      
      public var isMuted:Boolean;
      
      protected var _jid:UnescapedJID;
      
      protected var _rosterItem:RosterItemVO;
      
      protected var _vCard:VCard;
      
      protected var _vCardRequested:Boolean;
      
      protected var _userID:int = -1;
      
      protected var _profileID:String;
      
      protected var _displayName:String;
      
      protected var _firstName:String;
      
      protected var _photoURL:String;
      
      protected var _status:String;
      
      protected var _gender:int;
      
      protected var _credentials:LoginCredentials;
      
      protected var _experience:ExperienceData;
      
      protected var _clanName:String;
      
      protected var _premiumLevel:Number;
      
      protected var _nameColor:uint;
      
      protected var _messageColor:uint;
      
      public function ChatUser(jid:UnescapedJID)
      {
         super();
         this.jid = jid;
         this._vCard = new VCard();
         if(this.autoLoadVCard && jid)
         {
            this.loadVCard();
         }
         this.credentials = new LoginCredentials();
         this.experience = new ExperienceData();
      }
      
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set jid(value:UnescapedJID) : void
      {
         this._jid = value;
         if(this._rosterItem)
         {
            this._rosterItem.jid = value;
         }
         if(this.autoLoadVCard)
         {
            this.loadVCard();
         }
      }
      
      public function get rosterItem() : RosterItemVO
      {
         return this._rosterItem;
      }
      
      public function set rosterItem(value:RosterItemVO) : void
      {
         this._rosterItem = value;
         if(!this._rosterItem)
         {
            return;
         }
         if(this.jid)
         {
            this._rosterItem.jid = this.jid;
         }
         this.jid = Boolean(this.jid)?this.jid:this.rosterItem.jid;
         this.displayName = Boolean(this.displayName)?this.displayName:this.rosterItem.displayName;
      }
      
      public function get vCard() : VCard
      {
         return this._vCard;
      }
      
      public function get vCardRequested() : Boolean
      {
         return this._vCardRequested;
      }
      
      public function get userID() : int
      {
         return this._userID > -1?int(this._userID):Boolean(this.jid)?int(parseInt(this.jid.node)):int(null);
      }
      
      public function set userID(value:int) : void
      {
         this._userID = value;
      }
      
      public function get profileID() : String
      {
         return Boolean(this._profileID)?this._profileID:Boolean(this.userID)?this.userID.toString():null;
      }
      
      public function set profileID(value:String) : void
      {
         this._profileID = value;
      }
      
      public function get displayName() : String
      {
         return this._vCard && this._vCard.nickname?this._vCard.nickname:this._displayName;
      }
      
      public function set displayName(value:String) : void
      {
         this._displayName = value;
      }
      
      public function get firstName() : String
      {
         return this._vCard && this._vCard.name && this._vCard.name.given?this._vCard.name.given:this._firstName;
      }
      
      public function set firstName(value:String) : void
      {
         this._firstName = value;
      }
      
      public function get isMe() : Boolean
      {
         return this.asProfileData().isMe;
      }
      
      public function get photoURL() : String
      {
         return this._vCard && this._vCard.photo && this._vCard.photo.externalValue?this._vCard.photo.externalValue:this._photoURL;
      }
      
      public function set photoURL(value:String) : void
      {
         this._photoURL = value;
      }
      
      public function get status() : String
      {
         return Boolean(this._status)?this._status:Boolean(this._rosterItem)?this._rosterItem.status:null;
      }
      
      public function set status(value:String) : void
      {
         this._status = value;
      }
      
      public function get gender() : int
      {
         return this._gender;
      }
      
      public function set gender(value:int) : void
      {
         this._gender = value;
      }
      
      public function get credentials() : LoginCredentials
      {
         return this._credentials;
      }
      
      public function set credentials(value:LoginCredentials) : void
      {
         this._credentials = value;
      }
      
      public function get experience() : ExperienceData
      {
         return this._experience;
      }
      
      public function set experience(value:ExperienceData) : void
      {
         this._experience = value;
      }
      
      public function get clanName() : String
      {
         return this._vCard && this._vCard.extensions && this._vCard.extensions["X-CLAN-NAME"]?this._vCard.extensions["X-CLAN-NAME"]:this._clanName;
      }
      
      public function set clanName(value:String) : void
      {
         this._clanName = value;
      }
      
      public function get premiumLevel() : Number
      {
         return this._vCard && this._vCard.extensions && this._vCard.extensions["X-PREMIUM-LEVEL"] && !isNaN(Number(this._vCard.extensions["X-PREMIUM-LEVEL"]))?Number(Number(this._vCard.extensions["X-PREMIUM-LEVEL"])):Number(this._premiumLevel);
      }
      
      public function set premiumLevel(value:Number) : void
      {
         this._premiumLevel = value;
      }
      
      public function get nameColor() : uint
      {
         return this._nameColor;
      }
      
      public function set nameColor(value:uint) : void
      {
         this._nameColor = value;
      }
      
      public function get messageColor() : uint
      {
         return this._messageColor;
      }
      
      public function set messageColor(value:uint) : void
      {
         this._messageColor = value;
      }
      
      public function isFacebookUser() : Boolean
      {
         return this.jid && AppComponents.fbChatManager && this.jid.domain == AppComponents.fbChatManager.serverURL;
      }
      
      public function equals(other:ChatUser) : Boolean
      {
         return this.jid.equals(other.jid,false);
      }
      
      public function getAboutString() : String
      {
         var aboutString:String = "";
         var components:Array = [];
         if(this.experience && this.experience.level > 0)
         {
            components.push("Level " + this.experience.level);
         }
         if(this.status)
         {
         }
         aboutString = TextUtil.makeSlashSeparatedString(components);
         return aboutString;
      }
      
      public function asProfileData() : ProfileData
      {
         this.loadVCard();
         var profile:ProfileData = new ProfileData();
         profile.id = this.profileID;
         profile.userId = this.userID;
         profile.chatUserJID = this.jid;
         profile.profile_name = this.displayName;
         profile.firstName = this.firstName;
         profile.photo_url = this.photoURL;
         profile.status = this.status;
         profile.onlineStatus = Boolean(this.status)?PlayerStatus.createFromDescription(this.status):null;
         profile.gender = this.gender;
         profile.experience = this.experience;
         profile.clan_name = this.clanName;
         profile.premiumLevel = this.premiumLevel;
         return profile;
      }
      
      public function loadVCard() : void
      {
         var chatManager:ChatManager = null;
         if(!this._vCardRequested)
         {
            chatManager = !!this.isFacebookUser()?AppComponents.fbChatManager:AppComponents.chatManager;
            this._vCard.removeEventListener(VCardEvent.LOADED,this.onVCardLoaded);
            this._vCard = VCard.getVCard(chatManager.connection,this.jid);
            this._vCard.addEventListener(VCardEvent.LOADED,this.onVCardLoaded);
            this._vCardRequested = true;
         }
      }
      
      protected function onVCardLoaded(event:VCardEvent) : void
      {
         var chatUserEvent:ChatUserEvent = new ChatUserEvent(ChatUserEvent.UPDATE,true,true);
         chatUserEvent.chatUser = this;
         dispatchEvent(chatUserEvent);
      }
   }
}
