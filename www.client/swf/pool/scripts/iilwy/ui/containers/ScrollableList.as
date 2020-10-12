package iilwy.ui.containers
{
   import caurina.transitions.Tweener;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.ui.controls.ScrollableSprite;
   import iilwy.ui.controls.UiElement;
   import iilwy.utils.ItemFactory;
   
   public class ScrollableList extends ScrollableSprite
   {
       
      
      public var itemPadding:Number = 5;
      
      public var tweenItems:Boolean = false;
      
      private var _contentChangedTimer:Timer;
      
      public var useDividers:Boolean = true;
      
      public var dividerStyleId:String;
      
      private var dividerFactory:ItemFactory;
      
      public function ScrollableList(x:Number = 0, y:Number = 0, width:Number = 200, height:Number = 200)
      {
         super(x,y,width,height);
         this._contentChangedTimer = new Timer(100,1);
         this._contentChangedTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onContentChangedTimerComplete);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var item:DisplayObject = null;
         var yPos:Number = 0;
         for(var i:int = 0; i < content.numChildren; i++)
         {
            item = content.getChildAt(i);
            if(item is UiElement && !UiElement(item).includeInLayout)
            {
               item.y = 0;
            }
            else
            {
               try
               {
                  yPos = yPos + UiElement(item).margin.top;
               }
               catch(e:Error)
               {
               }
               if(yPos != item.y)
               {
                  if(this.tweenItems == false || contentRecentlyCleared || content.numChildren > 100)
                  {
                     item.y = yPos;
                  }
                  else
                  {
                     Tweener.addTween(item,{
                        "y":yPos,
                        "time":0.5,
                        "transition":"easeOutCubic",
                        "delay":0,
                        "onComplete":this.resetContentTimer
                     });
                  }
               }
               if(item is UiElement && item.width != unscaledWidth - UiElement(item).margin.horizontal)
               {
                  item.width = unscaledWidth - UiElement(item).margin.horizontal;
                  item.x = UiElement(item).margin.left;
               }
               yPos = yPos + (item.height + this.itemPadding);
               try
               {
                  yPos = yPos + UiElement(item).margin.bottom;
               }
               catch(e:Error)
               {
               }
               yPos = Math.round(yPos);
            }
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         contentRecentlyCleared = false;
      }
      
      private function resetContentTimer() : void
      {
         this._contentChangedTimer.reset();
         this._contentChangedTimer.start();
      }
      
      private function onContentChangedTimerComplete(evt:TimerEvent) : void
      {
         dispatchContentChangedEvent();
      }
   }
}
