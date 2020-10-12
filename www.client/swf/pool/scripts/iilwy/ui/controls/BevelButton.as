package iilwy.ui.controls
{
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import iilwy.ui.themes.Style;
   import iilwy.utils.GraphicUtil;
   import iilwy.utils.UiRender;
   
   public class BevelButton extends DisplayButton
   {
       
      
      protected var tintSprite:Sprite;
      
      protected var hilightSprite:Sprite;
      
      protected var _hilight:Boolean = false;
      
      public function BevelButton(label:String = "", x:Number = 0, y:Number = 0, width:Number = undefined, height:Number = 37, styleID:String = "bevelButton")
      {
         super(label,x,y,width,height,styleID);
         tabEnabled = true;
         setPadding(8,8);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var a:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.tintSprite && contains(this.tintSprite))
         {
            this.tintSprite.width = unscaledWidth - 6;
            this.tintSprite.height = unscaledHeight - 6;
         }
         if(processingIndicator != null && processingIndicator.stage != null)
         {
            processingIndicator.x = 3;
            processingIndicator.y = 3;
            processingIndicator.cornerRadius = 9;
            processingIndicator.width = unscaledWidth - 6;
            processingIndicator.height = unscaledHeight - 6;
            processingIndicator.stroke = 0;
            GraphicUtil.setColor(processingIndicator,6710886);
            processingIndicator.alpha = 0.2;
            processingIndicator.visible = true;
         }
         if(this._hilight && !selected && enabled)
         {
            if(!contains(this.hilightSprite))
            {
               addChild(this.hilightSprite);
            }
         }
         else if(this.hilightSprite && contains(this.hilightSprite))
         {
            removeChild(this.hilightSprite);
         }
         if(this.hilightSprite && contains(this.hilightSprite))
         {
            a = this.hilightSprite.alpha;
            GraphicUtil.setColorNotAlpha(this.hilightSprite,style.hilightColor);
            if(getValidValue(fontColor,style.fontColor) == 16777215)
            {
               this.hilightSprite.blendMode = BlendMode.OVERLAY;
            }
            else
            {
               this.hilightSprite.blendMode = BlendMode.MULTIPLY;
            }
            this.hilightSprite.alpha = a;
            this.hilightSprite.width = unscaledWidth - 10;
            this.hilightSprite.height = unscaledHeight - 10;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override protected function renderSkinStateBackground(canvas:Sprite, style:Style) : void
      {
         var h:int = 0;
         UiRender.renderRoundBorderBox(canvas,style,width,height);
         if(!isNaN(style.accentColor))
         {
            h = Math.ceil(0.62 * (height - 12));
            UiRender.renderRoundRect(canvas,style.accentColor,5,height - 5 - h,width - 10,h,7);
         }
      }
      
      public function set hilight(value:Boolean) : void
      {
         this._hilight = value;
         if(value && this.hilightSprite == null)
         {
            this.hilightSprite = new PhasingHilight();
         }
         invalidateDisplayList();
      }
      
      public function set color(value:Number) : void
      {
         if(!this.tintSprite)
         {
            this.tintSprite = new Sprite();
            UiRender.renderRoundRect(this.tintSprite,0,0,0,30,30,10);
            this.tintSprite.scale9Grid = new Rectangle(10,10,10,10);
            this.tintSprite.x = 3;
            this.tintSprite.y = 3;
            addChildAt(this.tintSprite,0);
         }
         GraphicUtil.setColor(this.tintSprite,value);
      }
   }
}

import caurina.transitions.Tweener;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import iilwy.utils.UiRender;

class PhasingHilight extends Sprite
{
    
   
   function PhasingHilight()
   {
      super();
      UiRender.renderGradient(this,[16777216,3422552064],Math.PI / 2,0,0,30,30,8);
      scale9Grid = new Rectangle(5,5,20,20);
      x = 5;
      y = 5;
      addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
   }
   
   public function onAddedToStage(event:Event) : void
   {
      this.animate();
   }
   
   public function onRemovedFromStage(event:Event) : void
   {
      Tweener.removeTweens(this);
   }
   
   protected function animate() : void
   {
      Tweener.removeTweens(this);
      var value:Number = alpha > 0.5?Number(0):Number(1);
      Tweener.addTween(this,{
         "alpha":value,
         "time":1,
         "transition":"easeInOutCubic",
         "onComplete":this.animate
      });
   }
}
