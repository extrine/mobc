package iilwy.ui.containers
{
   import flash.events.IEventDispatcher;
   import iilwy.ui.controls.UiElement;
   
   public interface IListItem extends IEventDispatcher
   {
       
      
      function set selected(b:Boolean) : void;
      
      function asUiElement() : UiElement;
   }
}
