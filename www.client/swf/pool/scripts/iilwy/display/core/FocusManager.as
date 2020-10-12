package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.geom.Point;
   import iilwy.ui.utils.IFocusGroup;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   
   public class FocusManager
   {
      
      private static var _instance:FocusManager;
       
      
      public var focusHistory:Array;
      
      private var _currentFocus:IFocusGroup;
      
      private var _debug:Boolean = false;
      
      private var _focusIndicator:Sprite;
      
      private var _logger:Logger;
      
      public function FocusManager()
      {
         this.focusHistory = [];
         super();
         this._logger = Logger.getLogger(this);
         StageReference.stage.addEventListener(FocusEvent.FOCUS_IN,this.onStageFocusChanged);
      }
      
      public static function init() : void
      {
         if(_instance == null)
         {
            _instance = new FocusManager();
         }
      }
      
      public static function getInstance() : FocusManager
      {
         if(_instance == null)
         {
            _instance = new FocusManager();
         }
         return _instance;
      }
      
      public function get currentFocus() : IFocusGroup
      {
         return this._currentFocus;
      }
      
      public function addFocusGroup(group:IFocusGroup) : void
      {
         var index:Number = NaN;
         var inHistory:Boolean = false;
         this.debug("adding group",group,"--------------");
         if(group != this._currentFocus)
         {
            index = this.focusHistory.indexOf(group);
            inHistory = false;
            if(index >= 0)
            {
               this.debug("this group was in the stack at",index);
               inHistory = true;
               this.focusHistory.splice(index,1);
            }
            if(this._currentFocus != null)
            {
               this.debug("saving the current focus",StageReference.stage.focus,"in",this._currentFocus);
               this._currentFocus.savedFocus = StageReference.stage.focus;
            }
            this.focusHistory.push(group);
            this.assignStageFocus(group);
            group.focusIn();
            if(this._currentFocus != null)
            {
               this._currentFocus.focusOut();
            }
         }
         else
         {
            this.debug("this is already focused");
         }
         this._currentFocus = group;
      }
      
      public function removeFocusGroup(group:IFocusGroup) : void
      {
         this.debug("removing group",group,"--------------");
         var index:Number = this.focusHistory.indexOf(group);
         if(index >= 0)
         {
            this.focusHistory.splice(index,1);
         }
         if(group != null && group == this._currentFocus)
         {
            group.focusOut();
            this._currentFocus = this.focusHistory[this.focusHistory.length - 1];
            if(this._currentFocus != null)
            {
               this.debug("reassigning focus to group",this._currentFocus);
               this._currentFocus.focusIn();
               this.assignStageFocus(this._currentFocus,true);
            }
         }
      }
      
      public function setStageFocus(obj:InteractiveObject) : void
      {
         this.debug("set stage focus",obj);
         StageReference.stage.focus = obj;
      }
      
      private function assignStageFocus(group:IFocusGroup, useSaved:Boolean = false) : void
      {
         var def:InteractiveObject = group.defaultFocus;
         var saved:InteractiveObject = group.savedFocus;
         if(saved != null && useSaved)
         {
            this.debug("set focus to saved",saved);
            StageReference.stage.focus = saved;
         }
         else if(def != null)
         {
            this.debug("set focus to default",def);
            StageReference.stage.focus = def;
         }
         else
         {
            try
            {
               StageReference.stage.focus = null;
            }
            catch(e:Error)
            {
               debug("failed to set focus to object",group);
            }
         }
      }
      
      private function onStageFocusChanged(event:FocusEvent) : void
      {
         if(!this._debug)
         {
            return;
         }
         var str:String = event.target.toString();
         var tObj:* = event.target;
         try
         {
            str = str + ", " + tObj.parent;
         }
         catch(e:Error)
         {
            trace(e);
         }
         try
         {
            str = str + (", " + tObj.label);
         }
         catch(e:Error)
         {
         }
         try
         {
            str = str + ", " + tObj.text;
         }
         catch(e:Error)
         {
            trace(e);
         }
         if(this._debug)
         {
            this.debug("Focus in:",str);
         }
      }
      
      private function debug(... args) : void
      {
         if(this._debug)
         {
            args.unshift("Focus Manager:");
            trace.apply(this,args);
         }
      }
      
      public function findTopFocusedItem(items:Array) : DisplayObject
      {
         var item:DisplayObjectContainer = null;
         var resultItem:DisplayObject = null;
         var obj:Object = null;
         var result:Boolean = false;
         var layer:Object = null;
         var container:DisplayObjectContainer = null;
         var gpt:Point = new Point(StageReference.stage.mouseX,StageReference.stage.mouseY);
         var layers:Array = new Array();
         for(var i:Number = 0; i < this.focusHistory.length; i++)
         {
            obj = {
               "container":this.focusHistory[i].asDisplayObject(),
               "item":null
            };
            layers.unshift(obj);
         }
         for each(item in items)
         {
            if(item.stage != null)
            {
               result = false;
               if(item.hitTestPoint(gpt.x,gpt.y,true))
               {
                  for each(layer in layers)
                  {
                     container = layer.container;
                     if(container.contains(item))
                     {
                        layer.item = item;
                     }
                  }
               }
            }
         }
         resultItem = null;
         for(i = 0; i < layers.length; i++)
         {
            if(layers[i].item != null)
            {
               resultItem = layers[i].item;
               break;
            }
         }
         return resultItem;
      }
   }
}
