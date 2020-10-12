package com.google.analytics.debug
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class UISprite extends Sprite
   {
       
      
      private var _forcedWidth:uint;
      
      private var _forcedHeight:uint;
      
      protected var alignTarget:DisplayObject;
      
      protected var listenResize:Boolean;
      
      public var alignement:Align;
      
      public var margin:Margin;
      
      public function UISprite(alignTarget:DisplayObject = null)
      {
         super();
         this.listenResize = false;
         this.alignement = Align.none;
         this.alignTarget = alignTarget;
         this.margin = new Margin();
         addEventListener(Event.ADDED_TO_STAGE,this._onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this._onRemovedFromStage);
      }
      
      private function _onAddedToStage(event:Event) : void
      {
         this.layout();
         this.resize();
      }
      
      private function _onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this._onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this._onRemovedFromStage);
         this.dispose();
      }
      
      protected function layout() : void
      {
      }
      
      protected function dispose() : void
      {
         var d:DisplayObject = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            d = getChildAt(i);
            if(d)
            {
               removeChild(d);
            }
         }
      }
      
      protected function onResize(event:Event) : void
      {
         this.resize();
      }
      
      public function get forcedWidth() : uint
      {
         if(this._forcedWidth)
         {
            return this._forcedWidth;
         }
         return width;
      }
      
      public function set forcedWidth(value:uint) : void
      {
         this._forcedWidth = value;
      }
      
      public function get forcedHeight() : uint
      {
         if(this._forcedHeight)
         {
            return this._forcedHeight;
         }
         return height;
      }
      
      public function set forcedHeight(value:uint) : void
      {
         this._forcedHeight = value;
      }
      
      public function alignTo(alignement:Align, target:DisplayObject = null) : void
      {
         var H:uint = 0;
         var W:uint = 0;
         var X:uint = 0;
         var Y:uint = 0;
         var t:UISprite = null;
         if(target == null)
         {
            if(parent is Stage)
            {
               target = this.stage;
            }
            else
            {
               target = parent;
            }
         }
         if(target == this.stage)
         {
            if(this.stage == null)
            {
               return;
            }
            H = this.stage.stageHeight;
            W = this.stage.stageWidth;
            X = 0;
            Y = 0;
         }
         else
         {
            t = target as UISprite;
            if(t.forcedHeight)
            {
               H = t.forcedHeight;
            }
            else
            {
               H = t.height;
            }
            if(t.forcedWidth)
            {
               W = t.forcedWidth;
            }
            else
            {
               W = t.width;
            }
            X = 0;
            Y = 0;
         }
         switch(alignement)
         {
            case Align.top:
               x = W / 2 - this.forcedWidth / 2;
               y = Y + this.margin.top;
               break;
            case Align.bottom:
               x = W / 2 - this.forcedWidth / 2;
               y = Y + H - this.forcedHeight - this.margin.bottom;
               break;
            case Align.left:
               x = X + this.margin.left;
               y = H / 2 - this.forcedHeight / 2;
               break;
            case Align.right:
               x = X + W - this.forcedWidth - this.margin.right;
               y = H / 2 - this.forcedHeight / 2;
               break;
            case Align.center:
               x = W / 2 - this.forcedWidth / 2;
               y = H / 2 - this.forcedHeight / 2;
               break;
            case Align.topLeft:
               x = X + this.margin.left;
               y = Y + this.margin.top;
               break;
            case Align.topRight:
               x = X + W - this.forcedWidth - this.margin.right;
               y = Y + this.margin.top;
               break;
            case Align.bottomLeft:
               x = X + this.margin.left;
               y = Y + H - this.forcedHeight - this.margin.bottom;
               break;
            case Align.bottomRight:
               x = X + W - this.forcedWidth - this.margin.right;
               y = Y + H - this.forcedHeight - this.margin.bottom;
         }
         if(!this.listenResize && alignement != Align.none)
         {
            target.addEventListener(Event.RESIZE,this.onResize,false,0,true);
            this.listenResize = true;
         }
         this.alignement = alignement;
         this.alignTarget = target;
      }
      
      public function resize() : void
      {
         if(this.alignement != Align.none)
         {
            this.alignTo(this.alignement,this.alignTarget);
         }
      }
   }
}
