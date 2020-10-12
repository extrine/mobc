package iilwy.ui.events
{
   import flash.events.Event;
   
   public class ScrollEvent extends Event
   {
      
      public static var CONTENT_CHANGE:String = "iilwy.ui.events.ScrollEvent.CONTENT_CHANGE";
      
      public static var INCREMENT:String = "iilwy.ui.events.ScrollEvent.INCREMENT";
      
      public static var SCROLL:String = "iilwy.ui.events.ScrollEvent.SCROLL";
      
      public static var SCRUB:String = "iilwy.ui.events.ScrollEvent.SCRUB";
      
      public static var START:String = "iilwy.ui.events.ScrollEvent.START";
      
      public static var STOP:String = "iilwy.ui.events.ScrollEvent.STOP";
      
      public static var VISIBLE_CHANGE:String = "iilwy.ui.events.ScrollEvent.VISIBLE_CHANGE";
       
      
      public var value:Number = 0;
      
      public function ScrollEvent(type:String, value:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.value = value;
      }
      
      override public function clone() : Event
      {
         var scrollEvent:ScrollEvent = new ScrollEvent(type,this.value,bubbles,cancelable);
         return scrollEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("ScrollEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
