package iilwy.ui.events
{
   import flash.events.Event;
   
   public class ComboBoxEvent extends Event
   {
      
      public static var CHANGED:String = "comboBoxChanged";
       
      
      public var value;
      
      public var selected:Number;
      
      public var name;
      
      public function ComboBoxEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,true,true);
      }
   }
}
