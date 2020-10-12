package iilwy.ui.containers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import iilwy.ui.controls.IUiElement;
   import iilwy.ui.utils.Margin;
   
   public interface IUiContainer extends IUiElement
   {
       
      
      function get backgroundColor() : Number;
      
      function set backgroundColor(value:Number) : void;
      
      function get backgroundGradient() : Array;
      
      function set backgroundGradient(value:Array) : void;
      
      function get cachePolicy() : Boolean;
      
      function set cachePolicy(value:Boolean) : void;
      
      function get chromePadding() : Margin;
      
      function set chromePadding(value:Margin) : void;
      
      function get content() : Sprite;
      
      function get innerHeight() : Number;
      
      function set innerHeight(value:Number) : void;
      
      function get innerWidth() : Number;
      
      function set innerWidth(value:Number) : void;
      
      function get maskContents() : Boolean;
      
      function set maskContents(value:Boolean) : void;
      
      function get numContentChildren() : int;
      
      function addContainerBackground() : void;
      
      function addContentChild(child:DisplayObject) : DisplayObject;
      
      function addContentChildAt(child:DisplayObject, index:int) : DisplayObject;
      
      function calculateInnerHeight(height:Number) : Number;
      
      function calculateInnerWidth(width:Number) : Number;
      
      function getContentChildren() : Array;
      
      function clearContentChildren(destroyChildren:Boolean = true) : Array;
      
      function getContentChildAt(index:Number) : DisplayObject;
      
      function getContentChildByName(name:String) : DisplayObject;
      
      function removeContentChild(child:DisplayObject) : DisplayObject;
      
      function removeContentChildAt(index:int) : DisplayObject;
      
      function setChromePadding(... rest) : void;
      
      function setContentChildIndex(child:DisplayObject, index:int) : void;
      
      function callLater(method:Function, args:Array = null) : void;
   }
}
