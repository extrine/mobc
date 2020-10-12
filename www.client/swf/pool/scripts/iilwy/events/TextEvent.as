package iilwy.events
{
   import flash.events.Event;
   
   public class TextEvent extends Event
   {
      
      public static const TEXT_LINK_CLICKED:String = "iilwy.events.TextEvent.TEXT_LINK_CLICKED";
       
      
      public var text:String;
      
      public function TextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = null)
      {
         super(type,bubbles,cancelable);
         this.text = text;
      }
      
      override public function clone() : Event
      {
         var textEvent:TextEvent = new TextEvent(type,bubbles,cancelable,this.text);
         return textEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("TextEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
