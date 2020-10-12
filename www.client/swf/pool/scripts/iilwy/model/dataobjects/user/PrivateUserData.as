package iilwy.model.dataobjects.user
{
   import com.adobe.utils.DateUtil;
   import flash.events.EventDispatcher;
   import iilwy.application.AppComponents;
   import iilwy.application.EmbedSettings;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.PagingArrayCollection;
   import iilwy.model.dataobjects.UserMediaData;
   import iilwy.model.dataobjects.avatar.BasicAvatar;
   import iilwy.model.dataobjects.market.product.ProductCollection;
   import iilwy.model.dataobjects.shop.CompoundPrice;
   import iilwy.model.local.LocalProperties;
   
   public class PrivateUserData extends PublicUserData
   {
       
      
      private const EMAIL_ACCESS_CODE_SUFFIX:String = "@omgpop.com";
      
      public var isLoggedIn:Boolean = false;
      
      public var productCollection:ProductCollection;
      
      public var tempAvatar:BasicAvatar;
      
      public var friends:FriendsData;
      
      public var inboxMessages:PagingArrayCollection;
      
      public var sentMessages:PagingArrayCollection;
      
      public var threadMessages:PagingArrayCollection;
      
      public var unreadMessageCount:int;
      
      public var recruitsData:RecruitsData;
      
      public var loginStreak:LoginStreak;
      
      public var mutedProfiles:ArrayCollection;
      
      public var mutedGuests:ArrayCollection;
      
      public var quizQuestions:PagingArrayCollection;
      
      public var reportCount:int = 0;
      
      public var signedUpAt:Date;
      
      public var gender:int = -1;
      
      public var country:String;
      
      public var city:String;
      
      public var state:String;
      
      public var zipcode:String;
      
      public var birthDay:Number;
      
      public var birthMonth:Number;
      
      public var birthYear:Number;
      
      public var chatUserPassword:String;
      
      public var media:UserMediaData;
      
      private var _currentBalance:CompoundPrice;
      
      private var _emailAccessCode:String;
      
      public var matchMakingSilo:String;
      
      public var logins:Array;
      
      public var emailAddressVerified:Boolean;
      
      public var hasAgreedToSiteRules:int = -1;
      
      public var hasAddedAimBot:Boolean = false;
      
      public var activePet:EventDispatcher;
      
      private var _profileNameUpdateStatus:String;
      
      public function PrivateUserData()
      {
         this.logins = [];
         super();
         this.friends = new FriendsData();
         this._currentBalance = new CompoundPrice();
         this.currentBalance.soft = -1;
         this.currentBalance.hard = -1;
         this.inboxMessages = new PagingArrayCollection();
         this.sentMessages = new PagingArrayCollection();
         this.threadMessages = new PagingArrayCollection();
         this.recruitsData = new RecruitsData();
         this.loginStreak = new LoginStreak();
         this.mutedProfiles = new ArrayCollection();
         this.mutedGuests = new ArrayCollection();
         this.quizQuestions = new PagingArrayCollection();
         this.media = new UserMediaData();
      }
      
      override public function clear() : void
      {
         super.clear();
         this.friends.clear();
         this.media = new UserMediaData();
         this.unreadMessageCount = 0;
         this.inboxMessages.clearSource();
         this.sentMessages.clearSource();
         this.threadMessages.clearSource();
         this.recruitsData.clear();
         this.loginStreak.clear();
         this.mutedProfiles.clearSource();
         this.mutedGuests.clearSource();
         this.quizQuestions.clearSource();
         this.isLoggedIn = false;
         this.currentBalance.soft = -1;
         this.currentBalance.hard = -1;
         this.matchMakingSilo = null;
         this.country = "";
         this.city = "";
         this.state = "";
         this.zipcode = "";
         this.birthDay = 1;
         this.birthMonth = 1;
         this.birthYear = new Date().fullYear - 16;
         this._emailAccessCode = "";
         this.logins = [];
         this.emailAddressVerified = false;
         this.hasAgreedToSiteRules = -1;
         this.hasAddedAimBot = false;
      }
      
      public function storeMuteList() : void
      {
         var obj:* = {
            "mutedProfiles":this.mutedProfiles.source,
            "mutedGuests":this.mutedGuests.source
         };
         AppComponents.localStore.saveUserSpecificObject(LocalProperties.MUTE_LIST,obj);
      }
      
      public function readMuteList() : void
      {
         var obj:* = AppComponents.localStore.getUserSpecificObject(LocalProperties.MUTE_LIST);
         if(obj && obj.mutedProfiles)
         {
            this.mutedProfiles.source = obj.mutedProfiles;
         }
         if(obj && obj.mutedGuests)
         {
            this.mutedGuests.source = obj.mutedGuests;
         }
      }
      
      public function isGuestMuted(id:String) : Boolean
      {
         var result:int = this.mutedGuests.getItemIndex(id);
         if(result >= 0)
         {
            return true;
         }
         return false;
      }
      
      public function isProfileMuted(id:String) : Boolean
      {
         var result:int = this.mutedProfiles.getItemIndex(id);
         if(result >= 0)
         {
            return true;
         }
         return false;
      }
      
      override public function initFromSessionData(data:*) : void
      {
         var match:Array = null;
         super.initFromSessionData(data);
         this.matchMakingSilo = Boolean(EmbedSettings.getInstance().matchMakingSilo)?EmbedSettings.getInstance().matchMakingSilo:data.silo;
         this.chatUserPassword = data.chat_user_password;
         if(data.signed_up_at)
         {
            this.signedUpAt = DateUtil.parseW3CDTF(data.signed_up_at);
         }
         this.country = Boolean(data.country)?data.country:"US";
         this.city = Boolean(data.city)?data.city:"";
         this.state = Boolean(data.state)?data.state:"";
         this.zipcode = Boolean(data.zipcode)?data.zipcode:"";
         this.gender = data.gender != null?int(data.gender):int(this.gender);
         if(data.date_of_birth)
         {
            match = data.date_of_birth.match(/^(\d{4})-(\d{2})-(\d{2})$/);
            if(match)
            {
               this.birthYear = Number(match[1]);
               this.birthMonth = Number(match[2]);
               this.birthDay = Number(match[3]);
            }
         }
         this.emailAccessCode = data.email_access_code;
         this.emailAddressVerified = data.email_address_verified;
      }
      
      public function get currentBalance() : CompoundPrice
      {
         return this._currentBalance;
      }
      
      public function set currentBalance(value:CompoundPrice) : void
      {
         this._currentBalance = value;
      }
      
      public function get emailAccessCode() : String
      {
         if(!this._emailAccessCode || this._emailAccessCode == "")
         {
            return "";
         }
         return this._emailAccessCode + this.EMAIL_ACCESS_CODE_SUFFIX;
      }
      
      public function set emailAccessCode(value:String) : void
      {
         value = Boolean(value)?value:"";
         var suffixIndex:int = value.indexOf("@");
         value = suffixIndex > -1?value.slice(0,suffixIndex - 1):value;
         this._emailAccessCode = value;
      }
      
      public function removeSuggestion(suggestion:SuggestionData) : void
      {
         recentContactSuggestions.removeItem(suggestion);
         numSuggestionRequests = recentContactSuggestions.length;
      }
      
      public function set profileNameUpdateStatus(value:String) : void
      {
         this._profileNameUpdateStatus = value;
      }
      
      public function get profileNameUpdateStatus() : String
      {
         return this._profileNameUpdateStatus;
      }
   }
}
