package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.utils.getTimer;
   import iilwy.utils.StageReference;
   
   public class GlobalKeyListener
   {
       
      
      private var _items:Array;
      
      private var _lastHeard:Number = 0;
      
      public function GlobalKeyListener()
      {
         super();
         StageReference.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._items = new Array();
      }
      
      public function addItem(item:Object) : void
      {
         this._items.push(item);
      }
      
      public function removeItem(item:Object) : void
      {
         var index:Number = this._items.indexOf(item);
         if(index >= 0)
         {
            this._items.splice(index,1);
         }
      }
      
      public function onKeyDown(event:KeyboardEvent) : void
      {
         if(getTimer() - 100 < this._lastHeard)
         {
            return;
         }
         var item:DisplayObject = FocusManager.getInstance().findTopFocusedItem(this._items);
         if(item != null)
         {
            this._lastHeard = getTimer();
            item.dispatchEvent(event);
         }
      }
   }
}
