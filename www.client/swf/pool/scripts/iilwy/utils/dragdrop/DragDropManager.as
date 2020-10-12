package iilwy.utils.dragdrop
{
   import caurina.transitions.Equations;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import gs.TweenLite;
   import iilwy.managers.GraphicManager;
   import iilwy.utils.GraphicUtil;
   
   public class DragDropManager extends EventDispatcher
   {
       
      
      protected var droppableID:uint;
      
      protected var draggableID:uint;
      
      public var draggableEntries:Object;
      
      protected var droppableEntries:Object;
      
      protected var activeDroppables:Object;
      
      protected var proxyLayer:Sprite;
      
      public var layerAlpha:Number = 0.7;
      
      protected var currentfocus:Sprite;
      
      protected var focusData:Draggable;
      
      protected var mouseOffset:Point;
      
      protected var receiver:Droppable;
      
      protected var dragStart:Point;
      
      protected var okayIcon:Sprite;
      
      protected var noIcon:Sprite;
      
      protected var iconOffset:Point;
      
      protected var defaultDroppable:Droppable;
      
      public var isDragging:Boolean;
      
      public function DragDropManager()
      {
         super();
         this.draggableEntries = new Object();
         this.droppableEntries = new Object();
         this.activeDroppables = new Object();
         this.initIdCounter();
         this.proxyLayer = new Sprite();
         this.proxyLayer.alpha = this.layerAlpha;
         this.mouseOffset = new Point();
         var iconSize:Number = 0.2;
         this.okayIcon = new GraphicManager.iconCheck2();
         GraphicUtil.setColor(this.okayIcon,65280);
         this.okayIcon.scaleX = this.okayIcon.scaleY = iconSize;
         this.noIcon = new GraphicManager.iconStop();
         GraphicUtil.setColor(this.noIcon,16711680);
         this.noIcon.scaleX = this.noIcon.scaleY = iconSize;
         this.iconOffset = new Point(-this.noIcon.width * 1.9,this.noIcon.height * 0.7);
      }
      
      public function getSprite() : Sprite
      {
         return this.proxyLayer;
      }
      
      public function addDragable(draggable:Draggable) : void
      {
         this.draggableID++;
         draggable.setLinkedManager(this);
         draggable.id = this.draggableID;
         this.draggableEntries[this.draggableID] = draggable;
      }
      
      public function removeDraggable(draggable:Draggable) : void
      {
         if(draggable && this.draggableEntries && this.draggableEntries[draggable.id])
         {
            this.draggableEntries[draggable.id].destroy();
            this.draggableEntries[draggable.id] = null;
            delete this.draggableEntries[draggable.id];
         }
      }
      
      public function addDroppable(droppable:Droppable) : int
      {
         var id:int = this.droppableID++;
         this.droppableEntries[id] = droppable;
         return id;
      }
      
      public function setDefaultDroppable(id:int) : void
      {
         this.defaultDroppable = this.droppableEntries[id];
      }
      
      public function reset() : void
      {
         this.activeDroppables = null;
      }
      
      public function activateDroppable(id:int) : void
      {
         this.activeDroppables[id] = this.droppableEntries[id];
      }
      
      public function deactivateDroppable(id:int) : void
      {
         this.activeDroppables[id] = null;
         delete this.activeDroppables[id];
      }
      
      public function updateDroppable(id:int) : void
      {
         this.droppableEntries[id].update();
      }
      
      public function doDragFailed(id:int) : void
      {
         trace("drag failed");
         this.focusData = this.draggableEntries[id];
         this.defaultDroppable.dragDropFail(this.focusData);
      }
      
      public function doDrop() : void
      {
         var diffX:Number = NaN;
         var diffY:Number = NaN;
         var distance:Number = NaN;
         var speed:Number = NaN;
         var time:Number = 0.2;
         this.isDragging = false;
         this.proxyLayer.removeEventListener(Event.ENTER_FRAME,this.update);
         if(this.receiver)
         {
            TweenLite.to(this.currentfocus,time,{
               "alpha":0,
               "ease":Equations.easeOutQuad,
               "overwrite":false
            });
            this.receiver.dragDrop(this.focusData);
         }
         else
         {
            diffX = this.currentfocus.x - this.dragStart.x;
            diffY = this.currentfocus.y - this.dragStart.y;
            distance = Math.sqrt(diffX * diffX + diffY * diffY);
            speed = 800;
            TweenLite.to(this.currentfocus,time,{
               "x":this.dragStart.x,
               "y":this.dragStart.y,
               "alpha":0,
               "ease":Equations.easeOutQuad,
               "overwrite":false
            });
         }
      }
      
      public function doDrag(proxy:Sprite, id:int) : void
      {
         var param:* = null;
         var focus:Droppable = null;
         if(this.currentfocus && this.currentfocus.parent)
         {
            this.currentfocus.parent.removeChild(this.currentfocus);
         }
         this.proxyLayer.addChild(proxy);
         this.currentfocus = proxy;
         this.mouseOffset = new Point(0,0);
         this.currentfocus.x = this.proxyLayer.mouseX - this.mouseOffset.x;
         this.currentfocus.y = this.proxyLayer.mouseY - this.mouseOffset.y;
         this.dragStart = new Point(this.currentfocus.x,this.currentfocus.y);
         this.focusData = this.draggableEntries[id];
         this.receiver = null;
         for(param in this.activeDroppables)
         {
            focus = this.activeDroppables[param];
            if(focus)
            {
               focus.ready = false;
            }
         }
         this.isDragging = true;
         this.proxyLayer.removeEventListener(Event.ENTER_FRAME,this.update);
         this.proxyLayer.addEventListener(Event.ENTER_FRAME,this.update,false,0,true);
      }
      
      public function update(e:Event) : void
      {
         var response:Number = NaN;
         var param:* = null;
         var focus:Droppable = null;
         var globalmouse:Point = null;
         response = 0.7;
         this.currentfocus.x = this.currentfocus.x + (this.proxyLayer.mouseX - this.mouseOffset.x - this.currentfocus.x) * response;
         this.currentfocus.y = this.currentfocus.y + (this.proxyLayer.mouseY - this.mouseOffset.y - this.currentfocus.y) * response;
         for(param in this.activeDroppables)
         {
            if(this.activeDroppables[param])
            {
               focus = this.activeDroppables[param];
               globalmouse = this.proxyLayer.localToGlobal(new Point(this.proxyLayer.mouseX,this.proxyLayer.mouseY));
               if(focus.dimensions.containsPoint(globalmouse))
               {
                  if(focus.receiveType == this.focusData.type)
                  {
                     if(focus.ready == false)
                     {
                        focus.ready = true;
                        focus.dragIn(this.focusData);
                        this.receiver = focus;
                        this.currentfocus.addChild(this.okayIcon);
                        this.okayIcon.x = this.iconOffset.x;
                        this.okayIcon.y = this.iconOffset.y;
                        if(this.noIcon && this.noIcon.parent)
                        {
                           this.noIcon.parent.removeChild(this.noIcon);
                        }
                     }
                  }
                  else
                  {
                     this.currentfocus.addChild(this.noIcon);
                     this.noIcon.x = this.iconOffset.x;
                     this.noIcon.y = this.iconOffset.y;
                     if(this.okayIcon && this.okayIcon.parent)
                     {
                        this.okayIcon.parent.removeChild(this.okayIcon);
                     }
                  }
               }
               else
               {
                  if(focus.ready)
                  {
                     focus.dragOut(this.focusData);
                     this.receiver = null;
                     if(this.noIcon && this.noIcon.parent)
                     {
                        this.noIcon.parent.removeChild(this.noIcon);
                     }
                     if(this.okayIcon && this.okayIcon.parent)
                     {
                        this.okayIcon.parent.removeChild(this.okayIcon);
                     }
                  }
                  focus.ready = false;
               }
            }
         }
      }
      
      protected function initIdCounter() : void
      {
         this.draggableID = 0;
         this.droppableID = 0;
      }
   }
}
