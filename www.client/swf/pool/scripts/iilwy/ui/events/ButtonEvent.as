package iilwy.ui.events
{
   import flash.events.Event;
   import iilwy.ui.controls.AbstractButton;
   
   public class ButtonEvent extends Event
   {
      
      public static var ROLL_OUT:String = "buttonEventRollOut";
      
      public static var ROLL_OVER:String = "buttonEventRollOver";
      
      public static var CLICK:String = "buttonEventClick";
      
      public static var CHANGED:String = "buttonEventChanged";
      
      public static var DOWN:String = "buttonEventDown";
      
      public static var UP:String = "buttonEventUp";
      
      public static var REPEAT:String = "buttonEventRepeat";
       
      
      public var button:AbstractButton;
      
      public var value:Boolean;
      
      public function ButtonEvent(type:String, button:AbstractButton, value:Boolean = false)
      {
         super(type,true,true);
         this.button = button;
         this.value = value;
      }
   }
}
