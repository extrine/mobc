package iilwy.application
{
   import iilwy.model.dataobjects.promo.enum.ImageDefinition;
   import iilwy.model.dataobjects.promo.enum.Scale9Definition;
   import iilwy.model.dataobjects.promo.enum.SkinDefinition;
   import iilwy.model.dataobjects.promo.enum.popup.ButtonDefinition;
   import iilwy.model.dataobjects.promo.enum.popup.PopupDefinition;
   import iilwy.model.dataobjects.promo.enum.popup.PopupViewDefinition;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.utils.ControlAlign;
   
   public class PromoSettings
   {
      
      public static const PROMO_POPUPS:String = "popup";
      
      public static const PROMO_CHAT:String = "chat";
      
      private static var __instance:PromoSettings;
       
      
      public var rewardsPopups:Array;
      
      public var promoPopups:Array;
      
      public var promoChatSkin:SkinDefinition;
      
      public var allowMultiplePopups:Boolean = true;
      
      public function PromoSettings(enforcer:SingletonEnforcer)
      {
         super();
      }
      
      public static function getInstance() : PromoSettings
      {
         if(!__instance)
         {
            __instance = new PromoSettings(new SingletonEnforcer());
         }
         return __instance;
      }
      
      protected static function getBooleanFromXML(node:*) : Boolean
      {
         var text:String = node.text();
         var bool:Boolean = text == "true";
         return bool;
      }
      
      public function initFromXML(xml:XML) : PromoSettings
      {
         var node:* = undefined;
         var topitem:* = undefined;
         var section:String = null;
         var popup:* = undefined;
         var settings:PromoSettings = this;
         var top:* = xml..settings;
         if(!top)
         {
            return settings;
         }
         settings.allowMultiplePopups = "@allow_multiple_popups" in top?Boolean(top.@allow_multiple_popups == "true"):Boolean(true);
         for each(topitem in top.promotions.promotion)
         {
            section = topitem.@type;
            switch(section)
            {
               case PROMO_POPUPS:
                  popup = this.parsePopup(topitem);
                  if(!this.promoPopups)
                  {
                     this.promoPopups = [];
                  }
                  this.promoPopups.push(popup);
                  continue;
               case PROMO_CHAT:
                  this.promoChatSkin = this.parseChat(topitem);
                  continue;
               default:
                  continue;
            }
         }
         for each(topitem in top.rewards.reward)
         {
            if("@campaign_id" in topitem)
            {
               if(!this.rewardsPopups)
               {
                  this.rewardsPopups = [];
               }
               this.rewardsPopups.push(topitem.@campaign_id.toString());
            }
         }
         return settings;
      }
      
      protected function parsePopup(popupNode:*) : PopupDefinition
      {
         var viewNode:* = undefined;
         var popup:PopupDefinition = null;
         var id:String = null;
         var view:PopupViewDefinition = null;
         var buttons:Array = null;
         var buttonNode:* = undefined;
         var button:ButtonDefinition = null;
         var buttonsNode:* = undefined;
         var width:int = "@width" in popupNode?int(popupNode.@width):int(500);
         var height:int = "@height" in popupNode?int(popupNode.@height):int(400);
         var campaignId:String = "@campaign_id" in popupNode?popupNode.@campaign_id:"campaign";
         var displayInterval:int = "@display_interval" in popupNode?int(parseInt(popupNode.@display_interval)):int(0);
         var styleId:String = "@style_id" in popupNode?popupNode.@style_id:null;
         var views:Array = [];
         for each(viewNode in popupNode.view)
         {
            id = "@id" in viewNode?viewNode.@id:"view";
            view = new PopupViewDefinition(id);
            view.closable = "@closable" in viewNode?Boolean(viewNode.@closable == "true"):Boolean(true);
            view.trackingPixel = "@tracking_pixel" in viewNode?viewNode.@tracking_pixel.toString():null;
            view.image = this.parseImage(viewNode.image);
            view.overlayImage = this.parseImage(viewNode.overlayImage);
            buttons = [];
            if(viewNode.buttons[0])
            {
               for each(buttonNode in viewNode.buttons.item)
               {
                  button = new ButtonDefinition(buttonNode.@id);
                  if(buttonNode.label[0])
                  {
                     button.label = buttonNode.label[0].toString();
                  }
                  if(buttonNode.action[0])
                  {
                     button.navData = viewNode.buttons;
                  }
                  if("@clickAction" in buttonNode)
                  {
                     button.clickAction = buttonNode.@clickAction;
                  }
                  button.hilight = "@hilight" in buttonNode?Boolean(true):Boolean(false);
                  buttons.push(button);
               }
               if(buttons.length)
               {
                  buttonsNode = viewNode.buttons;
                  view.buttonXPos = "@x" in buttonsNode?int(buttonsNode.@x):int(0);
                  view.buttonYPos = "@y" in buttonsNode?int(buttonsNode.@y):int(0);
                  view.buttonSize = "@size" in buttonsNode?int(buttonsNode.@size):int(0);
                  view.buttonAlign = "@align" in buttonsNode?buttonsNode.@align:ControlAlign.LEFT;
                  view.buttonDirection = "@direction" in buttonsNode?buttonsNode.@direction:ListDirection.HORIZONTAL;
                  view.buttonStyleId = "@styleId" in buttonsNode?buttonsNode.@styleId:"simpleButtonSet";
                  view.buttonColor = "@color" in buttonsNode?uint(uint(buttonsNode.@color)):uint(null);
                  view.buttons = buttons;
               }
            }
            views.push(view);
         }
         popup = new PopupDefinition(campaignId,width,height,views,displayInterval,styleId);
         return popup;
      }
      
      protected function parseChat(chatNode:*) : SkinDefinition
      {
         var scale9:Scale9Definition = null;
         var campaignId:String = "@campaign_id" in chatNode?chatNode.@campaign_id:"campaign";
         var chat:SkinDefinition = new SkinDefinition(campaignId);
         if(chatNode.statusWhiteList[0])
         {
            chat.statusWhiteList = chatNode.statusWhiteList[0].toString().split(",");
         }
         if(chatNode.gamesWhiteList[0])
         {
            chat.gameWhiteList = chatNode.gamesWhiteList[0].toString().split(",");
         }
         if(chatNode.scale9[0])
         {
            scale9 = new Scale9Definition();
            scale9.imageURL = Boolean(chatNode.scale9[0].image[0])?chatNode.scale9[0].image[0].toString():null;
            scale9.clickURL = Boolean(chatNode.scale9[0].clickURL[0])?chatNode.scale9[0].clickURL[0].toString():null;
            scale9.left = "@left" in chatNode.scale9?int(chatNode.scale9.@left):int(0);
            scale9.right = "@right" in chatNode.scale9?int(chatNode.scale9.@right):int(0);
            scale9.top = "@top" in chatNode.scale9?int(chatNode.scale9.@top):int(0);
            scale9.bottom = "@bottom" in chatNode.scale9?int(chatNode.scale9.@bottom):int(0);
         }
         chat.trackingPixel = "@tracking_pixel" in chatNode?chatNode.@tracking_pixel:null;
         chat.campaignId = campaignId;
         chat.scale9 = scale9;
         return chat;
      }
      
      protected function parseImage(imageNode:*) : ImageDefinition
      {
         var imageDefinition:ImageDefinition = null;
         var url:String = Boolean(imageNode[0])?imageNode[0].toString():null;
         if(url)
         {
            imageDefinition = new ImageDefinition(url);
            imageDefinition.x = "@x" in imageNode?int(imageNode.@x):int(0);
            imageDefinition.y = "@y" in imageNode?int(imageNode.@y):int(0);
            return imageDefinition;
         }
         return null;
      }
      
      public function getPromoPopupByCampaignId(campaignId:String) : PopupDefinition
      {
         var popup:PopupDefinition = null;
         for each(popup in this.promoPopups)
         {
            if(popup.campaignId == campaignId)
            {
               return popup;
            }
         }
         return null;
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
