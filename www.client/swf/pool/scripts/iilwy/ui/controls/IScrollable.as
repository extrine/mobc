package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   
   public interface IScrollable
   {
       
      
      function dispatchContentChangedEvent() : void;
      
      function getConcreteDisplayObject() : DisplayObject;
      
      function getWindowToContentRatio() : Number;
      
      function set scrollAmount(amount:Number) : void;
      
      function get scrollAmount() : Number;
      
      function incrementScrollAmount(direction:Number, multiple:Number = 1) : void;
      
      function listenForMouseWheel() : void;
   }
}
