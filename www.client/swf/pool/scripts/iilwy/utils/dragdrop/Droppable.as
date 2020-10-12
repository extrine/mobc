package iilwy.utils.dragdrop
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Droppable extends EventDispatcher
   {
       
      
      protected var clip:DisplayObject;
      
      public var dimensions:Rectangle;
      
      public var responder:IDropResponder;
      
      public var receiveType:String;
      
      public var ready:Boolean;
      
      public function Droppable(view:DisplayObject, receives:String, responder:IDropResponder)
      {
         super();
         this.clip = view;
         this.receiveType = receives;
         this.update();
         this.ready = false;
         this.responder = responder;
      }
      
      public function update() : void
      {
         this.dimensions = new Rectangle();
         var pos:Point = this.clip.localToGlobal(new Point(0,0));
         this.dimensions.x = pos.x;
         this.dimensions.y = pos.y;
         this.dimensions.width = this.clip.width * this.clip.scaleX;
         this.dimensions.height = this.clip.height * this.clip.scaleY;
      }
      
      public function destroy() : void
      {
         this.clip = null;
         this.ready = false;
         this.responder = null;
      }
      
      public function dragIn(source:Draggable) : void
      {
         this.responder.dragIn(source);
      }
      
      public function dragOut(source:Draggable) : void
      {
         this.responder.dragOut(source);
      }
      
      public function dragDrop(source:Draggable) : void
      {
         this.responder.dragDrop(source);
      }
      
      public function dragDropFail(source:Draggable) : void
      {
         this.responder.dragDropFail(source);
      }
   }
}
