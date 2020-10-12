package iilwy.ui.controls
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import iilwy.ui.containers.IInfoWindow;
   
   public interface ITooltip extends IInfoWindow
   {
       
      
      function show(target:DisplayObject, method:String, x:Number, y:Number, delay:Number) : void;
      
      function showText(text:String, target:DisplayObject, method:String, x:Number, y:Number, delay:Number) : void;
      
      function showSprite(sprite:Sprite, target:DisplayObject, method:String, x:Number, y:Number, delay:Number) : void;
      
      function hide(delay:Number = 0) : void;
   }
}
