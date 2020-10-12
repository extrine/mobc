package iilwy.display.core
{
   import flash.events.IEventDispatcher;
   
   public interface IWindowManager extends IEventDispatcher
   {
       
      
      function get width() : Number;
      
      function get height() : Number;
      
      function get isMinimized() : Boolean;
   }
}
