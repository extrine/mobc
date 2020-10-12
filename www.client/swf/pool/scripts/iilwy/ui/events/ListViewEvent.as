package iilwy.ui.events
{
   import flash.events.Event;
   import iilwy.ui.containers.ListViewDataWrapper;
   
   public class ListViewEvent extends Event
   {
      
      public static var CHANGED:String = "listViewChanged";
      
      public static var SELECT:String = "listViewSelect";
       
      
      public var selected:Number;
      
      public var dataWrapper:ListViewDataWrapper;
      
      public function ListViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
