package iilwy.ui.utils
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   
   public interface IFocusGroup
   {
       
      
      function focusIn() : void;
      
      function focusOut() : void;
      
      function get defaultFocus() : InteractiveObject;
      
      function set defaultFocus(i:InteractiveObject) : void;
      
      function get savedFocus() : InteractiveObject;
      
      function set savedFocus(i:InteractiveObject) : void;
      
      function get wantsFocus() : Boolean;
      
      function asDisplayObject() : DisplayObject;
   }
}
