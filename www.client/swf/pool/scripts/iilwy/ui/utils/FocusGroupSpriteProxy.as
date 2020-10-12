package iilwy.ui.utils
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import iilwy.utils.StageReference;
   
   public class FocusGroupSpriteProxy implements IFocusGroup
   {
       
      
      private var _sprites:Array;
      
      private var _defaultFocus:InteractiveObject;
      
      private var _savedFocus:InteractiveObject;
      
      public function FocusGroupSpriteProxy()
      {
         super();
         this._sprites = new Array();
      }
      
      public function addSprite(sprite:Sprite) : void
      {
         this._sprites.push(sprite);
      }
      
      public function destroy() : void
      {
         this._sprites = null;
      }
      
      public function focusIn() : void
      {
         var sprite:Sprite = null;
         for each(sprite in this._sprites)
         {
            sprite.tabChildren = true;
         }
      }
      
      public function focusOut() : void
      {
         var sprite:Sprite = null;
         for each(sprite in this._sprites)
         {
            sprite.tabChildren = false;
         }
      }
      
      public function get defaultFocus() : InteractiveObject
      {
         return this._defaultFocus;
      }
      
      public function set defaultFocus(i:InteractiveObject) : void
      {
         this._defaultFocus = i;
      }
      
      public function get savedFocus() : InteractiveObject
      {
         return this._savedFocus;
      }
      
      public function set savedFocus(i:InteractiveObject) : void
      {
         this._savedFocus = i;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return StageReference.stage;
      }
      
      public function get wantsFocus() : Boolean
      {
         return true;
      }
   }
}
