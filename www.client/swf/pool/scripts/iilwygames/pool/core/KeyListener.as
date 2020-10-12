package iilwygames.pool.core
{
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class KeyListener
   {
      
      public static const KEY_SPACE:uint = 32;
       
      
      private var _downKeys:Dictionary;
      
      private var _debounceKeys:Dictionary;
      
      private var _ref:DisplayObject;
      
      public function KeyListener()
      {
         super();
      }
      
      public function destroy() : void
      {
         this._downKeys = null;
         this._ref = null;
      }
      
      public function activate(ref:DisplayObject) : void
      {
         if(!this._downKeys)
         {
            this._downKeys = new Dictionary();
         }
         if(!this._debounceKeys)
         {
            this._debounceKeys = new Dictionary();
         }
         if(ref)
         {
            this._ref = ref;
            this._ref.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            this._ref.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         }
      }
      
      public function deactivate() : void
      {
         this._downKeys = null;
         this._debounceKeys = null;
         if(this._ref)
         {
            this._ref.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            this._ref.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         }
         this._ref = null;
      }
      
      public function isKeyDown(keyIndex:int) : Boolean
      {
         if(this._downKeys[keyIndex])
         {
            return true;
         }
         return false;
      }
      
      public function isKeyDown_ThisFrame(keyIndex:int) : Boolean
      {
         if(!this._debounceKeys[keyIndex] && this.isKeyDown(keyIndex))
         {
            this._debounceKeys[keyIndex] = true;
            return true;
         }
         return false;
      }
      
      public function update(et:Number) : void
      {
      }
      
      protected function onKeyDown(event:KeyboardEvent) : void
      {
         var focus:DisplayObject = this._ref.stage.focus;
         if(focus == this._ref)
         {
            this._downKeys[event.keyCode] = true;
         }
      }
      
      protected function onKeyUp(event:KeyboardEvent) : void
      {
         this._downKeys[event.keyCode] = false;
         this._debounceKeys[event.keyCode] = false;
      }
   }
}
