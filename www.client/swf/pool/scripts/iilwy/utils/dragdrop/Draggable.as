package iilwy.utils.dragdrop
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   
   public class Draggable extends EventDispatcher
   {
       
      
      public var id:int;
      
      public var dragwait:int = 0;
      
      public var image:DisplayObjectContainer;
      
      public var type:String;
      
      public var manager:DragDropManager;
      
      protected var isDragging:Boolean;
      
      protected var isClicked:Boolean;
      
      protected var dragTimer:Timer;
      
      protected var proxy:Bitmap;
      
      protected var proxySize:int = 60;
      
      public var _data:Object;
      
      protected var responder:Responder;
      
      public function Draggable(clip:DisplayObjectContainer, dragtype:String)
      {
         super();
         this.image = clip;
         this.type = dragtype;
         this.image.addEventListener(MouseEvent.MOUSE_DOWN,this.thumbClick);
         this.image.addEventListener(MouseEvent.MOUSE_UP,this.cancelDrag);
         this.dragTimer = new Timer(this.dragwait,0);
         this.dragTimer.addEventListener(TimerEvent.TIMER,this.beginDrag);
      }
      
      public function set data(val:Object) : void
      {
         this._data = val;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function setLinkedManager(man:DragDropManager) : void
      {
         this.manager = man;
         StageReference.stage.addEventListener(MouseEvent.MOUSE_UP,this.thumbRelease);
      }
      
      public function thumbClick(e:MouseEvent) : void
      {
         this.dragTimer.reset();
         this.dragTimer.start();
         this.isClicked = true;
      }
      
      public function thumbRelease(e:MouseEvent) : void
      {
         this.isClicked = false;
         if(this.isDragging)
         {
            this.isDragging = false;
            this.manager.doDrop();
         }
      }
      
      public function cancelDrag(e:MouseEvent) : void
      {
         if(!this.isDragging)
         {
            this.manager.doDragFailed(this.id);
         }
         this.isClicked = false;
         this.dragTimer.reset();
         this.dragTimer.stop();
      }
      
      public function beginDrag(e:TimerEvent) : void
      {
         var grab:BitmapData = null;
         var scaler:Number = NaN;
         var center:Sprite = null;
         if(this.isClicked)
         {
            if(this.proxy && this.proxy.bitmapData)
            {
               this.proxy.bitmapData.dispose();
            }
            this.proxy = new Bitmap();
            grab = new BitmapData(this.proxySize,this.proxySize,true,255);
            scaler = this.proxySize / Math.max(this.image.width * this.image.scaleX,this.image.height * this.image.scaleY);
            grab.draw(this.image,new Matrix(scaler,0,0,scaler,0,0));
            this.proxy.bitmapData = grab;
            center = new Sprite();
            center.addChild(this.proxy);
            this.proxy.x = -this.proxy.width / 2;
            this.proxy.y = -this.proxy.height / 2;
            this.manager.doDrag(center,this.id);
            e.target.stop();
            this.isDragging = true;
         }
      }
      
      public function destroy() : void
      {
         this.image.removeEventListener(MouseEvent.MOUSE_DOWN,this.thumbClick);
         this.image.removeEventListener(MouseEvent.MOUSE_UP,this.cancelDrag);
         StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP,this.thumbRelease);
         if(this.dragTimer && this.dragTimer.running)
         {
            this.dragTimer.reset();
            this.dragTimer.stop();
            this.dragTimer = null;
         }
         if(this.proxy && this.proxy.bitmapData)
         {
            this.proxy.bitmapData.dispose();
            this.proxy = null;
         }
      }
   }
}
