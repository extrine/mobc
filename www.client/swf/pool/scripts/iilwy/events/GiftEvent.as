package iilwy.events
{
   import flash.events.Event;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.ProductGift;
   import iilwy.utils.Responder;
   
   public class GiftEvent extends Event
   {
      
      public static const OPEN_SEND_PRODUCT_AS_GIFT_POPUP:String = "iilwy.events.GiftEvent.OPEN_SEND_PRODUCT_AS_GIFT_POPUP";
      
      public static const OPEN_SEND_FREE_PRODUCT_AS_GIFT_POPUP:String = "iilwy.events.GiftEvent.OPEN_SEND_FREE_PRODUCT_AS_GIFT_POPUP";
      
      public static const SEND_PRODUCT_AS_GIFT:String = "iilwy.events.GiftEvent.SEND_PRODUCT_AS_GIFT";
      
      public static const ACCEPT_GIFT:String = "iilwy.events.GiftEvent.ACCEPT_GIFT";
      
      public static const GET_GIFT:String = "iilwy.events.GiftEvent.GET_GIFT";
      
      public static const GET_GIFTS:String = "iilwy.events.GiftEvent.GET_GIFTS";
       
      
      public var message:String;
      
      public var recipientID:int;
      
      public var giftID:int;
      
      public var giftState:String;
      
      public var gift:ProductGift;
      
      public var catalogProductBase:CatalogProductBase;
      
      public var categoryID:int = -1;
      
      public var shopID:int = -1;
      
      public var responder:Responder;
      
      public var productIndex:int = 0;
      
      public function GiftEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
