package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public interface IInfoWindow extends IModuleContainer
   {
       
      
      function setPosition(target:DisplayObject, method:String, x:Number = undefined, y:Number = undefined) : void;
      
      function get cornerRadius() : Number;
      
      function set cornerRadius(value:Number) : void;
      
      function get useArrow() : Boolean;
      
      function set useArrow(value:Boolean) : void;
      
      function requestFocus() : void;
      
      function declineFocus() : void;
      
      function get constrainTo() : Rectangle;
      
      function set constrainTo(value:Rectangle) : void;
   }
}
