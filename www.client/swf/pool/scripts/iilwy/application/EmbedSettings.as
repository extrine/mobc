package iilwy.application
{
   public class EmbedSettings
   {
      
      private static var instance:EmbedSettings;
       
      
      public var allowLogin:Boolean = true;
      
      public var allowSignup:Boolean = true;
      
      public var allowUnlimitedGuestPlay:Boolean = false;
      
      public var defaultGuestCatchPhrase:String = "";
      
      public var defaultGuestName:String = null;
      
      public var displayAccountSettings:Boolean = true;
      
      public var displayAds:Boolean = false;
      
      public var displayExternalLinks:Boolean = true;
      
      public var displayInternalAds:Boolean = false;
      
      public var displayLogin:Boolean = true;
      
      public var displayLogout:Boolean = true;
      
      public var displayMoreGames:Boolean = true;
      
      public var displayOffers:Boolean = true;
      
      public var displayPersonal:Boolean = true;
      
      public var displaySignup:Boolean = true;
      
      public var displaySocial:Boolean = true;
      
      public var displayUserFeatures:Boolean = true;
      
      public var displayYesNo:Boolean = false;
      
      public var enableArcadeChat:Boolean = true;
      
      public var enableBetting:Boolean = true;
      
      public var enableDailyLogin:Boolean = true;
      
      public var enableInvitationLinks:Boolean = true;
      
      public var enableInviteFriends:Boolean = true;
      
      public var enablePromotion:Boolean = true;
      
      public var enableRecruits:Boolean = true;
      
      public var enableFriends:Boolean = true;
      
      public var enableBanning:Boolean = true;
      
      public var enableCurrencyExchange:Boolean = true;
      
      public var enableMessaging:Boolean = true;
      
      public var enablePhotos:Boolean = true;
      
      public var enableProfileQuestions:Boolean = true;
      
      public var enableStarPromotion:Boolean = true;
      
      public var fullFeatures:Boolean = false;
      
      public var gamesBlackList:Array;
      
      public var gamesWhiteList:Array;
      
      public var genericGuest:Boolean = false;
      
      public var matchMakingSilo:String = null;
      
      public var minimizeTopBar:Boolean = false;
      
      public var originName:String = "";
      
      public var usePartnerAuthenticationPopups:Boolean = false;
      
      public var internalizeShop:Boolean = false;
      
      public var dailyLoginNewsFeedURL:String = null;
      
      public var gamesBettingWhiteList:Array;
      
      public var inviteLinkBaseURL:String = null;
      
      public var inviteLinkCustomMessage:String = null;
      
      public var profileLinkBaseURL:String = null;
      
      public function EmbedSettings(enforcer:SingletonEnforcer)
      {
         this.gamesBlackList = [];
         this.gamesWhiteList = [];
         this.gamesBettingWhiteList = [];
         super();
      }
      
      public static function getInstance() : EmbedSettings
      {
         if(!instance)
         {
            instance = new EmbedSettings(new SingletonEnforcer());
         }
         return instance;
      }
      
      protected static function getBooleanFromXML(node:*) : Boolean
      {
         var text:String = node.text();
         var bool:Boolean = text == "true";
         return bool;
      }
      
      public function initFromXML(xml:XML) : EmbedSettings
      {
         var node:* = undefined;
         var settings:EmbedSettings = this;
         settings.originName = AppProperties.origin;
         var top:* = xml..settings[0];
         if(!top)
         {
            return settings;
         }
         node = top.allowLogin[0];
         if(node)
         {
            settings.allowLogin = getBooleanFromXML(node);
         }
         node = top.allowSignup[0];
         if(node)
         {
            settings.allowSignup = getBooleanFromXML(node);
         }
         node = top.allowUnlimitedGuestPlay[0];
         if(node)
         {
            settings.allowUnlimitedGuestPlay = getBooleanFromXML(node);
         }
         node = top.defaultGuestCatchPhrase[0];
         if(node)
         {
            settings.defaultGuestCatchPhrase = node.text();
         }
         node = top.defaultGuestName[0];
         if(node)
         {
            settings.defaultGuestName = node.text();
         }
         node = top.displayAccountSettings[0];
         if(node)
         {
            settings.displayAccountSettings = getBooleanFromXML(node);
         }
         node = top.displayAds[0];
         if(node)
         {
            settings.displayAds = getBooleanFromXML(node);
         }
         node = top.displayExternalLinks[0];
         if(node)
         {
            settings.displayExternalLinks = getBooleanFromXML(node);
         }
         node = top.displayInternalAds[0];
         if(node)
         {
            settings.displayInternalAds = getBooleanFromXML(node);
         }
         node = top.displayLogin[0];
         if(node)
         {
            settings.displayLogin = getBooleanFromXML(node);
         }
         node = top.displayLogout[0];
         if(node)
         {
            settings.displayLogout = getBooleanFromXML(node);
         }
         node = top.displayMoreGames[0];
         if(node)
         {
            settings.displayMoreGames = getBooleanFromXML(node);
         }
         node = top.displayOffers[0];
         if(node)
         {
            settings.displayOffers = getBooleanFromXML(node);
         }
         node = top.displayPersonal[0];
         if(node)
         {
            settings.displayPersonal = getBooleanFromXML(node);
         }
         node = top.displaySignup[0];
         if(node)
         {
            settings.displaySignup = getBooleanFromXML(node);
         }
         node = top.displaySocial[0];
         if(node)
         {
            settings.displaySocial = getBooleanFromXML(node);
         }
         node = top.displayUserFeatures[0];
         if(node)
         {
            settings.displayUserFeatures = getBooleanFromXML(node);
         }
         node = top.displayYesNo[0];
         if(node)
         {
            settings.displayYesNo = getBooleanFromXML(node);
         }
         node = top.enableArcadeChat[0];
         if(node)
         {
            settings.enableArcadeChat = getBooleanFromXML(node);
         }
         node = top.enableBetting[0];
         if(node)
         {
            settings.enableBetting = getBooleanFromXML(node);
         }
         node = top.enableDailyLogin[0];
         if(node)
         {
            settings.enableDailyLogin = getBooleanFromXML(node);
         }
         node = top.enableInvitationLinks[0];
         if(node)
         {
            settings.enableInvitationLinks = getBooleanFromXML(node);
         }
         node = top.enableInviteFriends[0];
         if(node)
         {
            settings.enableInviteFriends = getBooleanFromXML(node);
         }
         node = top.enablePromotion[0];
         if(node)
         {
            settings.enablePromotion = getBooleanFromXML(node);
         }
         node = top.enableRecruits[0];
         if(node)
         {
            settings.enableRecruits = getBooleanFromXML(node);
         }
         node = top.enableFriends[0];
         if(node)
         {
            settings.enableFriends = getBooleanFromXML(node);
         }
         node = top.enableBanning[0];
         if(node)
         {
            settings.enableBanning = getBooleanFromXML(node);
         }
         node = top.enableCurrencyExchange[0];
         if(node)
         {
            settings.enableCurrencyExchange = getBooleanFromXML(node);
         }
         node = top.enableMessaging[0];
         if(node)
         {
            settings.enableMessaging = getBooleanFromXML(node);
         }
         node = top.enablePhotos[0];
         if(node)
         {
            settings.enablePhotos = getBooleanFromXML(node);
         }
         node = top.enableProfileQuestions[0];
         if(node)
         {
            settings.enableProfileQuestions = getBooleanFromXML(node);
         }
         node = top.enableStarPromotion[0];
         if(node)
         {
            settings.enableStarPromotion = getBooleanFromXML(node);
         }
         node = top.fullFeatures[0];
         if(node)
         {
            settings.fullFeatures = getBooleanFromXML(node);
         }
         node = top.gamesBlackList[0];
         if(node)
         {
            settings.gamesBlackList = node.text().split(",");
         }
         node = top.gamesWhiteList[0];
         if(node)
         {
            settings.gamesWhiteList = node.text().split(",");
         }
         node = top.genericGuest[0];
         if(node)
         {
            settings.genericGuest = getBooleanFromXML(node);
         }
         node = top.matchMakingSilo[0];
         if(node)
         {
            settings.matchMakingSilo = node.text();
         }
         node = top.minimizeTopBar[0];
         if(node)
         {
            settings.minimizeTopBar = getBooleanFromXML(node);
         }
         node = top.originName[0];
         if(node)
         {
            settings.originName = node.text();
         }
         node = top.usePartnerAuthenticationPopups[0];
         if(node)
         {
            settings.usePartnerAuthenticationPopups = getBooleanFromXML(node);
         }
         node = top.internalizeShop[0];
         if(node)
         {
            settings.internalizeShop = getBooleanFromXML(node);
         }
         node = top.dailyLoginNewsFeedURL[0];
         if(node)
         {
            settings.dailyLoginNewsFeedURL = node.text();
         }
         node = top.gamesBettingWhiteList[0];
         if(node)
         {
            settings.gamesBettingWhiteList = node.text().split(",");
         }
         node = top.inviteLinkBaseURL[0];
         if(node)
         {
            settings.inviteLinkBaseURL = node.text();
         }
         node = top.inviteLinkCustomMessage[0];
         if(node)
         {
            settings.inviteLinkCustomMessage = node.text();
         }
         node = top.profileLinkBaseURL[0];
         if(node)
         {
            settings.profileLinkBaseURL = node.text();
         }
         return settings;
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}
