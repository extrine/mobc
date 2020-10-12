package iilwy.ui.events
{
   import flash.events.Event;
   import iilwy.ui.controls.UiElement;
   
   public class UiEvent extends Event
   {
      
      public static var FOCUS:String = "iilwy.ui.events.UiEvent.FOCUS";
      
      public static var INVALIDATE_DISPLAYLIST:String = "iilwy.ui.events.UiEvent.INVALIDATE_DISPLAYLIST";
      
      public static var INVALIDATE_SIZE:String = "iilwy.ui.events.UiEvent.INVALIDATE_SIZE";
      
      public static var LOAD_BEGIN:String = "iilwy.ui.events.UiEvent.LOAD_BEGIN";
      
      public static var LOAD_COMPLETE:String = "iilwy.ui.events.UiEvent.LOAD_COMPLETE";
      
      public static var MOVE:String = "iilwy.ui.events.UiEvent.MOVE";
      
      public static var REDRAW:String = "iilwy.ui.events.UiEvent.REDRAW";
      
      public static var RESIZE:String = "iilwy.ui.events.UiEvent.RESIZE";
       
      
      public var element:UiElement;
      
      public var value:Object;
      
      public function UiEvent(type:String, element:UiElement, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.element = element;
      }
      
      override public function clone() : Event
      {
         var uiEvent:UiEvent = new UiEvent(type,this.element,bubbles,cancelable);
         uiEvent.value = this.value;
         return uiEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("UiEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
