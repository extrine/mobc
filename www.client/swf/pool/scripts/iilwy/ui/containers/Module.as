package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import iilwy.ui.utils.IFocusGroup;
   
   public class Module extends Sprite implements IModule, IFocusGroup
   {
       
      
      private var _container:ModuleContainer;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      public var defaultContainerHeight:Number;
      
      public var defaultContainerWidth:Number;
      
      public var desiredHeight:Number;
      
      public var explicitWidth:Number;
      
      public var explicitHeight:Number;
      
      protected var _defaultFocus:InteractiveObject;
      
      protected var _savedFocus:InteractiveObject;
      
      protected var _wantsFocus:Boolean = true;
      
      public function Module()
      {
         super();
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         this._width = width;
         this._height = height;
      }
      
      public function get container() : ModuleContainer
      {
         return this._container;
      }
      
      public function setContainer(container:ModuleContainer) : void
      {
         this._container = container;
      }
      
      public function clearContainer() : void
      {
         this._container = null;
      }
      
      public function destroy() : void
      {
         this._container = null;
      }
      
      public function getConcreteDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function focusIn() : void
      {
         tabChildren = true;
      }
      
      public function focusOut() : void
      {
         tabChildren = false;
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
      
      public function get wantsFocus() : Boolean
      {
         return this._wantsFocus;
      }
      
      public function set wantsFocus(val:Boolean) : void
      {
         this._wantsFocus = val;
      }
   }
}
