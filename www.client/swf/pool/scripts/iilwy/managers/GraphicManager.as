package iilwy.managers
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   
   public class GraphicManager
   {
      
      [Embed(source="/../assets/website/images/icons/window_resize.png")]
      public static var iconWindowResize:Class = GraphicManager_iconWindowResize;
      
      [Embed(source="/../assets/website/images/backgrounds/base_background.jpg")]
      public static var backgroundBase:Class = GraphicManager_backgroundBase;
      
      [Embed(source="/../assets/website/images/icons/fourway_arrows.png")]
      public static var iconFourwayArrows:Class = GraphicManager_iconFourwayArrows;
      
      [Embed(symbol="loadingAnim2",source="/../assets/website/vector/assets.swf")]
      public static var loadingAnim1:Class = GraphicManager_loadingAnim1;
      
      [Embed(symbol="pageTitleBg",source="/../assets/website/vector/assets.swf")]
      public static var pageTitleBg:Class = GraphicManager_pageTitleBg;
      
      [Embed(symbol="arcadeHostIndicator",source="/../assets/website/vector/assets.swf")]
      public static var arcadeHostIndicator:Class = GraphicManager_arcadeHostIndicator;
      
      [Embed(source="/../assets/website/images/premium/badges/charles.png")]
      public static var premiumCharlesBadge:Class = GraphicManager_premiumCharlesBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/crew.png")]
      public static var premiumCrewBadge:Class = GraphicManager_premiumCrewBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/real.png")]
      public static var premiumRealBadge:Class = GraphicManager_premiumRealBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/gold_star.png")]
      public static var premiumGoldStarBadge:Class = GraphicManager_premiumGoldStarBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/star.png")]
      public static var premiumStarBadge:Class = GraphicManager_premiumStarBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/elite.png")]
      public static var premiumEliteBadge:Class = GraphicManager_premiumEliteBadge;
      
      [Embed(source="/../assets/website/images/premium/badges/lite.png")]
      public static var premiumLiteBadge:Class = GraphicManager_premiumLiteBadge;
      
      [Embed(source="/../assets/website/images/premium/icons/star_icon.png")]
      public static var premiumStarIcon:Class = GraphicManager_premiumStarIcon;
      
      [Embed(source="/../assets/website/images/premium/icons/star_text_icon.png")]
      public static var premiumStarTextIcon:Class = GraphicManager_premiumStarTextIcon;
      
      [Embed(source="/../assets/website/images/facebook/fb_icon.png")]
      public static var facebookIcon:Class = GraphicManager_facebookIcon;
      
      [Embed(source="/../assets/website/images/drawing/colorPalette.png")]
      public static var drawingColorPalette:Class = GraphicManager_drawingColorPalette;
      
      [Embed(source="/../assets/website/images/drawing/addDrawing.png")]
      public static var drawingAdd:Class = GraphicManager_drawingAdd;
      
      [Embed(symbol="coinDetailSmall",source="/../assets/website/vector/assets.swf")]
      public static var coinDetailSmall:Class = GraphicManager_coinDetailSmall;
      
      [Embed(symbol="cashDetailSmall",source="/../assets/website/vector/assets.swf")]
      public static var cashDetailSmall:Class = GraphicManager_cashDetailSmall;
      
      [Embed(symbol="fbcreditDetailSmall",source="/../assets/website/vector/assets.swf")]
      public static var fbcreditDetailSmall:Class = GraphicManager_fbcreditDetailSmall;
      
      [Embed(symbol="loginAIMIcon",source="/../assets/website/vector/assets.swf")]
      public static var loginAIMIcon:Class = GraphicManager_loginAIMIcon;
      
      [Embed(symbol="loginFacebookIcon",source="/../assets/website/vector/assets.swf")]
      public static var loginFacebookIcon:Class = GraphicManager_loginFacebookIcon;
      
      [Embed(source="/../assets/website/images/icons/ruby.png")]
      public static var ruby:Class = GraphicManager_ruby;
      
      [Embed(symbol="stickerEmbossed",source="/../assets/website/vector/assets.swf")]
      public static var tokenStickerEmbossed:Class = GraphicManager_tokenStickerEmbossed;
      
      [Embed(symbol="pokerChip",source="/../assets/website/vector/assets.swf")]
      public static var tokenPokerChip:Class = GraphicManager_tokenPokerChip;
      
      [Embed(symbol="circleToken",source="/../assets/website/vector/assets.swf")]
      public static var tokenCircle:Class = GraphicManager_tokenCircle;
      
      [Embed(symbol="glossCircleToken",source="/../assets/website/vector/assets.swf")]
      public static var tokenGlossCircle:Class = GraphicManager_tokenGlossCircle;
      
      [Embed(symbol="saleEmbossed",source="/../assets/website/vector/assets.swf")]
      public static var saleEmbossed:Class = GraphicManager_saleEmbossed;
      
      [Embed(source="/../assets/website/images/icons/browse_mini.png")]
      public static var iconBrowseMini:Class = GraphicManager_iconBrowseMini;
      
      [Embed(source="/../assets/website/images/icons/browse_full.png")]
      public static var iconBrowseFull:Class = GraphicManager_iconBrowseFull;
      
      [Embed(source="/../assets/website/images/topnav/home.png")]
      public static var iconTopNavHome:Class = GraphicManager_iconTopNavHome;
      
      [Embed(source="/../assets/website/images/topnav/search.png")]
      public static var iconTopNavSearch:Class = GraphicManager_iconTopNavSearch;
      
      [Embed(source="/../assets/website/images/topnav/soundOn.png")]
      public static var iconTopNavSoundOn:Class = GraphicManager_iconTopNavSoundOn;
      
      [Embed(source="/../assets/website/images/topnav/soundOff.png")]
      public static var iconTopNavSoundOff:Class = GraphicManager_iconTopNavSoundOff;
      
      [Embed(source="/../assets/website/images/topnav/qualityLo.png")]
      public static var iconTopNavLowQuality:Class = GraphicManager_iconTopNavLowQuality;
      
      [Embed(source="/../assets/website/images/topnav/qualityHi.png")]
      public static var iconTopNavHighQuality:Class = GraphicManager_iconTopNavHighQuality;
      
      [Embed(source="/../assets/website/images/topnav/message.png")]
      public static var iconTopNavMessage:Class = GraphicManager_iconTopNavMessage;
      
      [Embed(symbol="logo",source="/../assets/website/vector/assets.swf")]
      public static var vectorLogo:Class = GraphicManager_vectorLogo;
      
      [Embed(symbol="logoWeather",source="/../assets/website/vector/assets.swf")]
      public static var vectorLogoWeather:Class = GraphicManager_vectorLogoWeather;
      
      [Embed(symbol="arcadeReadyClock",source="/../assets/website/vector/assets.swf")]
      public static var arcadeReadyClock:Class = GraphicManager_arcadeReadyClock;
      
      [Embed(symbol="giftClosed",source="/../assets/website/vector/assets.swf")]
      public static var giftClosed:Class = GraphicManager_giftClosed;
      
      [Embed(symbol="giftOpen",source="/../assets/website/vector/assets.swf")]
      public static var giftOpen:Class = GraphicManager_giftOpen;
      
      [Embed(source="/../assets/website/images/icons/medals_gold.png")]
      public static var goldMedal:Class = GraphicManager_goldMedal;
      
      [Embed(source="/../assets/website/images/icons/medals_silver.png")]
      public static var silverMedal:Class = GraphicManager_silverMedal;
      
      [Embed(source="/../assets/website/images/icons/medals_bronze.png")]
      public static var bronzeMedal:Class = GraphicManager_bronzeMedal;
      
      [Embed(source="/../assets/website/images/icons/coin_stack.png")]
      public static var coinStack:Class = GraphicManager_coinStack;
      
      [Embed(source="/../assets/website/images/icons/sound_on.png")]
      public static var iconSoundOn:Class = GraphicManager_iconSoundOn;
      
      [Embed(source="/../assets/website/images/icons/sound_off.png")]
      public static var iconSoundOff:Class = GraphicManager_iconSoundOff;
      
      [Embed(source="/../assets/website/images/icons/signal_strength.png")]
      public static var iconSignalStrength:Class = GraphicManager_iconSignalStrength;
      
      [Embed(source="/../assets/website/images/chat/voicechat_bkgd.png")]
      public static var voicechat_bkgd:Class = GraphicManager_voicechat_bkgd;
      
      [Embed(source="/../assets/website/images/chat/voicechat_volume_speaker.png")]
      public static var voicechat_volume_speaker:Class = GraphicManager_voicechat_volume_speaker;
      
      [Embed(source="/../assets/website/images/chat/voicechat_mini_icon.png")]
      public static var voicechat_mini_icon:Class = GraphicManager_voicechat_mini_icon;
      
      [Embed(symbol="iconThumbsUpPixel",source="/../assets/website/vector/icons.swf")]
      public static var iconThumbsUpPixel:Class = GraphicManager_iconThumbsUpPixel;
      
      [Embed(symbol="iconThumbsDownPixel",source="/../assets/website/vector/icons.swf")]
      public static var iconThumbsDownPixel:Class = GraphicManager_iconThumbsDownPixel;
      
      [Embed(symbol="iconMarketAvatarAccessories",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarAccessories:Class = GraphicManager_iconMarketAvatarAccessories;
      
      [Embed(symbol="iconMarketAvatarAll",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarAll:Class = GraphicManager_iconMarketAvatarAll;
      
      [Embed(symbol="iconMarketAvatarFeatured",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarFeatured:Class = GraphicManager_iconMarketAvatarFeatured;
      
      [Embed(symbol="iconMarketAvatarBottoms",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarBottoms:Class = GraphicManager_iconMarketAvatarBottoms;
      
      [Embed(symbol="iconMarketAvatarEyebrows",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarEyebrows:Class = GraphicManager_iconMarketAvatarEyebrows;
      
      [Embed(symbol="iconMarketAvatarEyes",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarEyes:Class = GraphicManager_iconMarketAvatarEyes;
      
      [Embed(symbol="iconMarketAvatarHair",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarHair:Class = GraphicManager_iconMarketAvatarHair;
      
      [Embed(symbol="iconMarketAvatarHead",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarHead:Class = GraphicManager_iconMarketAvatarHead;
      
      [Embed(symbol="iconMarketAvatarMouth",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarMouth:Class = GraphicManager_iconMarketAvatarMouth;
      
      [Embed(symbol="iconMarketAvatarNose",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarNose:Class = GraphicManager_iconMarketAvatarNose;
      
      [Embed(symbol="iconMarketAvatarShoes",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarShoes:Class = GraphicManager_iconMarketAvatarShoes;
      
      [Embed(symbol="iconMarketAvatarTops",source="/../assets/website/vector/icons.swf")]
      public static var iconMarketAvatarTops:Class = GraphicManager_iconMarketAvatarTops;
      
      [Embed(symbol="iconArrow1Down",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow1Down:Class = GraphicManager_iconArrow1Down;
      
      [Embed(symbol="iconArrow1Left",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow1Left:Class = GraphicManager_iconArrow1Left;
      
      [Embed(symbol="iconArrow1Right",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow1Right:Class = GraphicManager_iconArrow1Right;
      
      [Embed(symbol="iconArrow1Up",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow1Up:Class = GraphicManager_iconArrow1Up;
      
      [Embed(symbol="iconArrow2Down",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow2Down:Class = GraphicManager_iconArrow2Down;
      
      [Embed(symbol="iconArrow2Left",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow2Left:Class = GraphicManager_iconArrow2Left;
      
      [Embed(symbol="iconArrow2Right",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow2Right:Class = GraphicManager_iconArrow2Right;
      
      [Embed(symbol="iconArrow3Down",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow3Down:Class = GraphicManager_iconArrow3Down;
      
      [Embed(symbol="iconArrow3Left",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow3Left:Class = GraphicManager_iconArrow3Left;
      
      [Embed(symbol="iconArrow3Right",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow3Right:Class = GraphicManager_iconArrow3Right;
      
      [Embed(symbol="iconArrow3Up",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow3Up:Class = GraphicManager_iconArrow3Up;
      
      [Embed(symbol="iconArrow4Left",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow4Left:Class = GraphicManager_iconArrow4Left;
      
      [Embed(symbol="iconArrow4Right",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow4Right:Class = GraphicManager_iconArrow4Right;
      
      [Embed(symbol="iconArrow4LeftEnd",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow4LeftEnd:Class = GraphicManager_iconArrow4LeftEnd;
      
      [Embed(symbol="iconArrow4RightEnd",source="/../assets/website/vector/icons.swf")]
      public static var iconArrow4RightEnd:Class = GraphicManager_iconArrow4RightEnd;
      
      [Embed(symbol="iconChat",source="/../assets/website/vector/icons.swf")]
      public static var iconChat:Class = GraphicManager_iconChat;
      
      [Embed(symbol="iconHeart",source="/../assets/website/vector/icons.swf")]
      public static var iconHeart:Class = GraphicManager_iconHeart;
      
      [Embed(symbol="iconFemale",source="/../assets/website/vector/icons.swf")]
      public static var iconFemale:Class = GraphicManager_iconFemale;
      
      [Embed(symbol="iconMale",source="/../assets/website/vector/icons.swf")]
      public static var iconMale:Class = GraphicManager_iconMale;
      
      [Embed(symbol="iconMaleFemale",source="/../assets/website/vector/icons.swf")]
      public static var iconMaleFemale:Class = GraphicManager_iconMaleFemale;
      
      [Embed(symbol="iconDot",source="/../assets/website/vector/icons.swf")]
      public static var iconOnline:Class = GraphicManager_iconOnline;
      
      [Embed(symbol="iconPlus1",source="/../assets/website/vector/icons.swf")]
      public static var iconPlus1:Class = GraphicManager_iconPlus1;
      
      [Embed(symbol="iconPlus2",source="/../assets/website/vector/icons.swf")]
      public static var iconPlus2:Class = GraphicManager_iconPlus2;
      
      [Embed(symbol="iconSearch",source="/../assets/website/vector/icons.swf")]
      public static var iconSearch:Class = GraphicManager_iconSearch;
      
      [Embed(symbol="iconX1",source="/../assets/website/vector/icons.swf")]
      public static var iconX1:Class = GraphicManager_iconX1;
      
      [Embed(symbol="iconX2",source="/../assets/website/vector/icons.swf")]
      public static var iconX2:Class = GraphicManager_iconX2;
      
      [Embed(symbol="iconMinimize",source="/../assets/website/vector/icons.swf")]
      public static var iconMinimize:Class = GraphicManager_iconMinimize;
      
      [Embed(symbol="iconCheck",source="/../assets/website/vector/icons.swf")]
      public static var iconCheck:Class = GraphicManager_iconCheck;
      
      [Embed(symbol="iconCheck2",source="/../assets/website/vector/icons.swf")]
      public static var iconCheck2:Class = GraphicManager_iconCheck2;
      
      [Embed(symbol="iconRefresh",source="/../assets/website/vector/icons.swf")]
      public static var iconRefresh:Class = GraphicManager_iconRefresh;
      
      [Embed(symbol="iconDrawingCrayon",source="/../assets/website/vector/icons.swf")]
      public static var iconDrawingCrayon:Class = GraphicManager_iconDrawingCrayon;
      
      [Embed(symbol="iconDrawingPencil",source="/../assets/website/vector/icons.swf")]
      public static var iconDrawingPencil:Class = GraphicManager_iconDrawingPencil;
      
      [Embed(symbol="iconDrawingChalk",source="/../assets/website/vector/icons.swf")]
      public static var iconDrawingChalk:Class = GraphicManager_iconDrawingChalk;
      
      [Embed(symbol="iconDrawingBrush",source="/../assets/website/vector/icons.swf")]
      public static var iconDrawingBrush:Class = GraphicManager_iconDrawingBrush;
      
      [Embed(symbol="iconDrawingAirbrush",source="/../assets/website/vector/icons.swf")]
      public static var iconDrawingAirbrush:Class = GraphicManager_iconDrawingAirbrush;
      
      [Embed(symbol="iconMinus",source="/../assets/website/vector/icons.swf")]
      public static var iconMinus:Class = GraphicManager_iconMinus;
      
      [Embed(symbol="iconPhone2",source="/../assets/website/vector/icons.swf")]
      public static var iconPhone2:Class = GraphicManager_iconPhone2;
      
      [Embed(symbol="iconSearch2",source="/../assets/website/vector/icons.swf")]
      public static var iconSearch2:Class = GraphicManager_iconSearch2;
      
      [Embed(symbol="iconSticker",source="/../assets/website/vector/icons.swf")]
      public static var iconSticker:Class = GraphicManager_iconSticker;
      
      [Embed(symbol="iconStop",source="/../assets/website/vector/icons.swf")]
      public static var iconStop:Class = GraphicManager_iconStop;
      
      [Embed(source="/../assets/website/images/topnav/new.png")]
      public static var iconTopNavNewItem:Class = GraphicManager_iconTopNavNewItem;
      
      [Embed(source="/../assets/website/images/topnav/star.png")]
      public static var iconTopNavStarItem:Class = GraphicManager_iconTopNavStarItem;
      
      [Embed(symbol="iconUndo",source="/../assets/website/vector/icons.swf")]
      public static var iconUndo:Class = GraphicManager_iconUndo;
      
      [Embed(symbol="tutmask",source="/../assets/website/vector/icons.swf")]
      public static var tutmask:Class = GraphicManager_tutmask;
       
      
      public function GraphicManager()
      {
         super();
      }
      
      public static function init() : void
      {
      }
      
      public static function getBitmapData(iconClass:Class, size:Number = undefined) : BitmapData
      {
         var obj:DisplayObject = new iconClass();
         if(isNaN(size))
         {
            obj.width = size;
            obj.height = size;
         }
         var bd:BitmapData = new BitmapData(obj.width,obj.height,true,16777215);
         bd.draw(obj);
         return bd;
      }
   }
}
