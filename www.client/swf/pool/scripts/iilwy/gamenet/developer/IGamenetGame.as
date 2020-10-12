package iilwy.gamenet.developer
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public interface IGamenetGame
   {
       
      
      function asDisplayObject() : DisplayObject;
      
      function start(holder:DisplayObject, gamenetController:GamenetController) : void;
      
      function stop() : void;
      
      function destroy() : void;
      
      function setSize(width:Number, height:Number) : Rectangle;
   }
}
