package iilwy.display.layout
{
   import iilwy.data.PageCommand;
   import iilwy.ui.containers.UiContainer;
   
   public interface IPageView
   {
       
      
      function init() : void;
      
      function _show() : void;
      
      function _hide() : void;
      
      function _processPageCommand(pageCommand:PageCommand) : void;
      
      function asUiContainer() : UiContainer;
      
      function onBeforeUnload() : String;
   }
}
