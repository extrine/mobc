package com.google.analytics.debug
{
   import com.google.analytics.GATracker;
   import com.google.analytics.core.GIFRequest;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLRequest;
   
   public class Layout implements ILayout
   {
       
      
      private var _display:DisplayObject;
      
      private var _debug:DebugConfiguration;
      
      private var _mainPanel:Panel;
      
      private var _hasWarning:Boolean;
      
      private var _hasInfo:Boolean;
      
      private var _hasDebug:Boolean;
      
      private var _hasGRAlert:Boolean;
      
      private var _infoQueue:Array;
      
      private var _maxCharPerLine:int = 85;
      
      private var _warningQueue:Array;
      
      private var _GRAlertQueue:Array;
      
      public var visualDebug:Debug;
      
      public function Layout(debug:DebugConfiguration, display:DisplayObject)
      {
         super();
         this._display = display;
         this._debug = debug;
         this._hasWarning = false;
         this._hasInfo = false;
         this._hasDebug = false;
         this._hasGRAlert = false;
         this._warningQueue = [];
         this._infoQueue = [];
         this._GRAlertQueue = [];
      }
      
      public function init() : void
      {
         var spaces:int = 10;
         var W:uint = this._display.stage.stageWidth - spaces * 2;
         var H:uint = this._display.stage.stageHeight - spaces * 2;
         var mp:Panel = new Panel("analytics",W,H);
         mp.alignement = Align.top;
         mp.stickToEdge = false;
         mp.title = "Google Analytics v" + GATracker.version;
         this._mainPanel = mp;
         this.addToStage(mp);
         this.bringToFront(mp);
         if(this._debug.minimizedOnStart)
         {
            this._mainPanel.onToggle();
         }
         this.createVisualDebug();
         this._display.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
      }
      
      public function destroy() : void
      {
         this._mainPanel.close();
         this._debug.layout = null;
      }
      
      private function onKey(event:KeyboardEvent = null) : void
      {
         switch(event.keyCode)
         {
            case this._debug.showHideKey:
               this._mainPanel.visible = !this._mainPanel.visible;
               break;
            case this._debug.destroyKey:
               this.destroy();
         }
      }
      
      private function _clearInfo(event:Event) : void
      {
         this._hasInfo = false;
         if(this._infoQueue.length > 0)
         {
            this.createInfo(this._infoQueue.shift());
         }
      }
      
      private function _clearWarning(event:Event) : void
      {
         this._hasWarning = false;
         if(this._warningQueue.length > 0)
         {
            this.createWarning(this._warningQueue.shift());
         }
      }
      
      private function _clearGRAlert(event:Event) : void
      {
         this._hasGRAlert = false;
         if(this._GRAlertQueue.length > 0)
         {
            this.createGIFRequestAlert.apply(this,this._GRAlertQueue.shift());
         }
      }
      
      private function _filterMaxChars(message:String, maxCharPerLine:int = 0) : String
      {
         var line:String = null;
         var CRLF:String = "\n";
         var output:Array = [];
         var lines:Array = message.split(CRLF);
         if(maxCharPerLine == 0)
         {
            maxCharPerLine = this._maxCharPerLine;
         }
         for(var i:int = 0; i < lines.length; i++)
         {
            line = lines[i];
            while(line.length > maxCharPerLine)
            {
               output.push(line.substr(0,maxCharPerLine));
               line = line.substring(maxCharPerLine);
            }
            output.push(line);
         }
         return output.join(CRLF);
      }
      
      public function addToStage(visual:DisplayObject) : void
      {
         this._display.stage.addChild(visual);
      }
      
      public function addToPanel(name:String, visual:DisplayObject) : void
      {
         var panel:Panel = null;
         var d:DisplayObject = this._display.stage.getChildByName(name);
         if(d)
         {
            panel = d as Panel;
            panel.addData(visual);
         }
         else
         {
            trace("panel \"" + name + "\" not found");
         }
      }
      
      public function bringToFront(visual:DisplayObject) : void
      {
         this._display.stage.setChildIndex(visual,this._display.stage.numChildren - 1);
      }
      
      public function isAvailable() : Boolean
      {
         return this._display.stage != null;
      }
      
      public function createVisualDebug() : void
      {
         if(!this.visualDebug)
         {
            this.visualDebug = new Debug();
            this.visualDebug.alignement = Align.bottom;
            this.visualDebug.stickToEdge = true;
            this.addToPanel("analytics",this.visualDebug);
            this._hasDebug = true;
         }
      }
      
      public function createPanel(name:String, width:uint, height:uint) : void
      {
         var p:Panel = new Panel(name,width,height);
         p.alignement = Align.center;
         p.stickToEdge = false;
         this.addToStage(p);
         this.bringToFront(p);
      }
      
      public function createInfo(message:String) : void
      {
         if(this._hasInfo || !this.isAvailable())
         {
            this._infoQueue.push(message);
            return;
         }
         message = this._filterMaxChars(message);
         this._hasInfo = true;
         var i:Info = new Info(message,this._debug.infoTimeout);
         this.addToPanel("analytics",i);
         i.addEventListener(Event.REMOVED_FROM_STAGE,this._clearInfo,false,0,true);
         if(this._hasDebug)
         {
            this.visualDebug.write(message);
         }
      }
      
      public function createWarning(message:String) : void
      {
         if(this._hasWarning || !this.isAvailable())
         {
            this._warningQueue.push(message);
            return;
         }
         message = this._filterMaxChars(message);
         this._hasWarning = true;
         var w:Warning = new Warning(message,this._debug.warningTimeout);
         this.addToPanel("analytics",w);
         w.addEventListener(Event.REMOVED_FROM_STAGE,this._clearWarning,false,0,true);
         if(this._hasDebug)
         {
            this.visualDebug.writeBold(message);
         }
      }
      
      public function createAlert(message:String) : void
      {
         message = this._filterMaxChars(message);
         var a:Alert = new Alert(message,[new AlertAction("Close","close","close")]);
         this.addToPanel("analytics",a);
         if(this._hasDebug)
         {
            this.visualDebug.writeBold(message);
         }
      }
      
      public function createFailureAlert(message:String) : void
      {
         var actionClose:AlertAction = null;
         if(this._debug.verbose)
         {
            message = this._filterMaxChars(message);
            actionClose = new AlertAction("Close","close","close");
         }
         else
         {
            actionClose = new AlertAction("X","close","close");
         }
         var fa:Alert = new FailureAlert(this._debug,message,[actionClose]);
         this.addToPanel("analytics",fa);
         if(this._hasDebug)
         {
            if(this._debug.verbose)
            {
               message = message.split("\n").join("");
               message = this._filterMaxChars(message,66);
            }
            this.visualDebug.writeBold(message);
         }
      }
      
      public function createSuccessAlert(message:String) : void
      {
         var actionClose:AlertAction = null;
         if(this._debug.verbose)
         {
            message = this._filterMaxChars(message);
            actionClose = new AlertAction("Close","close","close");
         }
         else
         {
            actionClose = new AlertAction("X","close","close");
         }
         var sa:Alert = new SuccessAlert(this._debug,message,[actionClose]);
         this.addToPanel("analytics",sa);
         if(this._hasDebug)
         {
            if(this._debug.verbose)
            {
               message = message.split("\n").join("");
               message = this._filterMaxChars(message,66);
            }
            this.visualDebug.writeBold(message);
         }
      }
      
      public function createGIFRequestAlert(message:String, request:URLRequest, ref:GIFRequest) : void
      {
         if(this._hasGRAlert)
         {
            this._GRAlertQueue.push([message,request,ref]);
            return;
         }
         this._hasGRAlert = true;
         var f:Function = function():void
         {
            ref.sendRequest(request);
         };
         var message:String = this._filterMaxChars(message);
         var gra:GIFRequestAlert = new GIFRequestAlert(message,[new AlertAction("OK","ok",f),new AlertAction("Cancel","cancel","close")]);
         this.addToPanel("analytics",gra);
         gra.addEventListener(Event.REMOVED_FROM_STAGE,this._clearGRAlert,false,0,true);
         if(this._hasDebug)
         {
            if(this._debug.verbose)
            {
               message = message.split("\n").join("");
               message = this._filterMaxChars(message,66);
            }
            this.visualDebug.write(message);
         }
      }
   }
}
