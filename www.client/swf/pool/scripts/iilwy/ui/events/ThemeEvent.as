package iilwy.ui.events
{
   import flash.events.Event;
   
   public class ThemeEvent extends Event
   {
      
      public static var THEME_CHANGED:String = "themeEventThemeChanged";
       
      
      public var id:String;
      
      public function ThemeEvent(type:String, id:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.id = id;
      }
   }
}
