package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import iilwy.ui.controls.ITooltip;
   
   public class TooltipManager
   {
      
      public static const DELAY_MINIMUM:Number = 10;
      
      public static const DELAY_DEFAULT:Number = 600;
       
      
      private var _layer:Sprite;
      
      private var _defaultDelay:Number = 600;
      
      private var _basicTooltip:ITooltip;
      
      private var _showBasicTimeStamp:int = -99999;
      
      public function TooltipManager(layer:Sprite, tooltipClass:Class = null)
      {
         super();
         this._layer = layer;
         this._layer.mouseEnabled = false;
         try
         {
            this._basicTooltip = new tooltipClass();
            this._basicTooltip.hide();
         }
         catch(e:Error)
         {
         }
      }
      
      public function showTooltip(text:String, target:DisplayObject = null, method:String = null, delay:Number = 600, x:Number = undefined, y:Number = undefined) : void
      {
         try
         {
            this._basicTooltip.showText(text,target,method,x,y,delay);
            this.addTooltipToStage();
         }
         catch(e:Error)
         {
         }
      }
      
      public function showTooltipSprite(sprite:Sprite, target:DisplayObject = null, method:String = null, delay:Number = 600, x:Number = undefined, y:Number = undefined) : void
      {
         try
         {
            this._basicTooltip.showSprite(sprite,target,method,x,y,delay);
            this.addTooltipToStage();
         }
         catch(e:Error)
         {
         }
      }
      
      public function showTooltipSpriteInteractive(sprite:Sprite, target:DisplayObject = null, method:String = null, delay:Number = 600, x:Number = undefined, y:Number = undefined) : void
      {
         try
         {
            this._basicTooltip.mouseChildren = true;
            this._basicTooltip.mouseEnabled = true;
            this._basicTooltip.showSprite(sprite,target,method,x,y,delay);
            this.addTooltipToStage();
         }
         catch(e:Error)
         {
         }
      }
      
      public function hideTooltip() : void
      {
         try
         {
            this._basicTooltip.mouseChildren = false;
            this._basicTooltip.mouseEnabled = false;
            this._basicTooltip.hide();
            this.removeTooltipFromStage();
         }
         catch(e:Error)
         {
         }
      }
      
      private function addTooltipToStage() : void
      {
         this._showBasicTimeStamp = getTimer();
         if(!this._layer.contains(this._basicTooltip as DisplayObject))
         {
            this._layer.addChild(this._basicTooltip as DisplayObject);
         }
         this._basicTooltip.visible = true;
      }
      
      private function removeTooltipFromStage() : void
      {
         this._basicTooltip.visible = false;
      }
   }
}
