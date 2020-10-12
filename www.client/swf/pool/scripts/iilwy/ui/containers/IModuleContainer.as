package iilwy.ui.containers
{
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.utils.Margin;
   
   public interface IModuleContainer extends IUiContainer
   {
       
      
      function startProcessing(event:ContainerEvent = null) : void;
      
      function stopProcessing(event:ContainerEvent = null) : void;
      
      function setModule(imodule:IModule) : IModule;
      
      function removeModule() : IModule;
      
      function get processingMargin() : Margin;
      
      function set processingMargin(value:Margin) : void;
      
      function get module() : IModule;
      
      function get autoDestroyModule() : Boolean;
      
      function set autoDestroyModule(value:Boolean) : void;
      
      function get processingBlockerAlpha() : Number;
      
      function set processingBlockerAlpha(value:Number) : void;
   }
}
