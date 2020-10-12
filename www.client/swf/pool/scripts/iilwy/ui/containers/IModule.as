package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   
   public interface IModule
   {
       
      
      function destroy() : void;
      
      function get container() : ModuleContainer;
      
      function setContainer(container:ModuleContainer) : void;
      
      function getConcreteDisplayObject() : DisplayObject;
   }
}
