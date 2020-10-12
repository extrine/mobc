package iilwy.ui.events
{
   import flash.events.Event;
   
   public class MultiSelectEvent extends Event
   {
      
      public static var CHANGED:String = "iilwy.ui.events.MultiSelectEvent.CHANGED";
      
      public static var SELECT:String = "iilwy.ui.events.MultiSelectEvent.SELECT";
      
      public static var ROLL_OVER:String = "iilwy.ui.events.MultiSelectEvent.ROLL_OVER";
      
      public static var ROLL_OUT:String = "iilwy.ui.events.MultiSelectEvent.ROLL_OUT";
       
      
      public var label;
      
      public var value;
      
      public var selected:Number;
      
      public function MultiSelectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var multiSelectEvent:MultiSelectEvent = new MultiSelectEvent(type,bubbles,cancelable);
         multiSelectEvent.label = this.label;
         multiSelectEvent.value = this.value;
         multiSelectEvent.selected = this.selected;
         return multiSelectEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("MultiSelectEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
