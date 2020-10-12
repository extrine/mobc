package iilwygames.pool.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.utils.GraphicUtil;
   import iilwygames.pool.core.Globals;
   import iilwygames.pool.events.ResourceManagerEvent;
   import iilwygames.ui.partials.GameOverPopup;
   import net.hires.debug.Stats;
   
   public class GameView extends Sprite
   {
       
      
      public var table:TableView;
      
      public var stats:Stats;
      
      public var bottomBar:BottomBar;
      
      public var blitzBottomBar:BlitzBottomBar;
      
      public var gameOverDisplay:GameOverPopup;
      
      public var cueStickView:CueView;
      
      public var editorView:EditorView;
      
      public var _width:Number;
      
      public var _height:Number;
      
      public var hasMouseFocus:Boolean;
      
      private var genericVector:Vector3D;
      
      private var shotClock:ShotClockView;
      
      private var tableMask:Sprite;
      
      public function GameView()
      {
         super();
         var isFacebook:Boolean = Globals.FACEBOOK_BUILD;
         this.table = new TableView();
         this.stats = new Stats();
         this.bottomBar = new BottomBar();
         this.blitzBottomBar = new BlitzBottomBar();
         this.gameOverDisplay = new GameOverPopup();
         this.cueStickView = new CueView();
         this.tableMask = new Sprite();
         this.editorView = new EditorView();
         if(!isFacebook)
         {
            addChild(this.bottomBar);
         }
         else
         {
            addChild(this.blitzBottomBar);
         }
         addChild(this.table);
         addChild(this.cueStickView);
         addChild(this.tableMask);
         if(Globals.EDITOR_MODE)
         {
            addChild(this.editorView);
         }
         this.table.mask = this.tableMask;
         this._width = 0;
         this._height = 0;
         this.genericVector = new Vector3D();
         this.hasMouseFocus = false;
         this.shotClock = new ShotClockView();
         if(!isFacebook)
         {
            addChild(this.shotClock);
         }
      }
      
      public function init() : void
      {
         Globals.resourceManager.removeEventListener(ResourceManagerEvent.ASSETS_READY,this.assetsReady);
         Globals.resourceManager.addEventListener(ResourceManagerEvent.ASSETS_READY,this.assetsReady);
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseIn);
            stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseIn);
         }
      }
      
      public function stop() : void
      {
         if(this.stats && contains(this.stats))
         {
            removeChild(this.stats);
         }
         this.table.stop();
         this.shotClock.stop();
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseIn);
         }
         if(this.bottomBar)
         {
            this.bottomBar.stop();
         }
         if(contains(this.gameOverDisplay))
         {
            removeChild(this.gameOverDisplay);
         }
         this.cueStickView.stop();
      }
      
      public function destroy() : void
      {
         if(this.table && contains(this.table))
         {
            removeChild(this.table);
         }
         removeChild(this.cueStickView);
         this.cueStickView.destroy();
         removeChild(this.shotClock);
         if(contains(this.bottomBar))
         {
            removeChild(this.bottomBar);
         }
         if(contains(this.blitzBottomBar))
         {
            removeChild(this.blitzBottomBar);
         }
         this.table.destroy();
         this.shotClock.destroy();
         this.bottomBar.destroy();
         this.blitzBottomBar.destroy();
         this.gameOverDisplay.destroy();
         this.table = null;
         this.genericVector = null;
         this.shotClock = null;
         this.bottomBar = null;
         this.blitzBottomBar = null;
         this.gameOverDisplay = null;
         this.cueStickView = null;
      }
      
      public function initModels() : void
      {
         this.table.initModels();
         this.bottomBar.cueControl.setStick(Globals.model.ruleset.cueStick);
         this.blitzBottomBar.cueControl.setStick(Globals.model.ruleset.cueStick);
         this.bottomBar.setPlayers(Globals.model.players);
         this.cueStickView.setStick(Globals.model.ruleset.cueStick);
      }
      
      public function update(et:Number) : void
      {
         this.table.update(et);
         this.shotClock.update(et);
         this.bottomBar.update(et);
         this.cueStickView.update();
         this.blitzBottomBar.update(et);
      }
      
      public function startClock(time:Number) : void
      {
         this.shotClock.startTimer(time);
      }
      
      public function stopClock() : void
      {
         this.shotClock.stopTimer();
      }
      
      public function setSize(w:Number, h:Number) : Rectangle
      {
         var screenRect:Rectangle = new Rectangle();
         var bottomBarPadding:Number = 75;
         this.table.setSize(w,h - bottomBarPadding);
         this.table.x = this.table._width * (1 - TableView.TABLE_SCALE) * 0.5;
         this.table.y = this.table._height * (1 - TableView.TABLE_SCALE) * 0.5;
         this.bottomBar.resize(this._width,this._height);
         this.bottomBar.x = (this.table._width - this.bottomBar._width) * 0.5;
         this.bottomBar.y = this.table._height - this.table._height * 0.035;
         this.blitzBottomBar.resize();
         this.blitzBottomBar.x = (this.table._width - this.blitzBottomBar._width) * 0.5;
         this.blitzBottomBar.y = this.table._height - this.table._height * 0.035;
         this._width = this.table._width;
         if(Globals.FACEBOOK_BUILD)
         {
            this._height = this.table._height;
            this._height = this.bottomBar.y + this.bottomBar._height;
         }
         else
         {
            this._height = this.bottomBar.y + this.bottomBar._height;
         }
         screenRect.width = this._width;
         screenRect.height = this._height;
         Globals.model.world.onScreenResize(this.table.playFieldWidth,this.table.playFieldHeight);
         Globals.resourceManager.resizeAssets();
         this.table.resizeAssets();
         this.shotClock.setWidth(64);
         this.shotClock.x = this.bottomBar.x + this.bottomBar._width - 64 - 4;
         this.shotClock.y = this.bottomBar.y + this.bottomBar._height - this.shotClock.height - 4;
         if(this.cueStickView)
         {
            this.cueStickView.resize();
            this.cueStickView.x = this.table.playFieldOffsetX + this.table.x;
            this.cueStickView.y = this.table.playFieldOffsetY + this.table.y;
         }
         var maskWidth:Number = w + 10;
         this.tableMask.graphics.clear();
         this.tableMask.graphics.beginFill(0,0.5);
         this.tableMask.graphics.drawRect(this._width - w,0.5 * (this._height - h),maskWidth,h);
         this.tableMask.graphics.endFill();
         this.editorView.setActualSize(this._width,this._height);
         return screenRect;
      }
      
      protected function mouseIn(event:MouseEvent) : void
      {
         this.hasMouseFocus = true;
      }
      
      public function assetsReady(event:ResourceManagerEvent) : void
      {
         this.cueStickView.resize();
         this.table.resizeAssets();
         this.bottomBar.resizeAssets();
         this.blitzBottomBar.resizeAssets();
      }
      
      public function getTablePosition(stage_x:Number, stage_y:Number) : Vector3D
      {
         this.genericVector.x = stage_x - this.table.x;
         this.genericVector.y = stage_y - this.table.y;
         return this.genericVector;
      }
      
      public function showGameOver(results:RoundResults) : void
      {
         this.gameOverDisplay.data = results;
         this.gameOverDisplay.title = "GAME OVER!";
         addChild(this.gameOverDisplay);
         GraphicUtil.centerInto(this.gameOverDisplay,0,0,this._width,this._height,true);
      }
      
      public function isMouseOverBottom() : Boolean
      {
         var bbRec:Rectangle = null;
         var invalidMouseDown:Boolean = false;
         if(Globals.FACEBOOK_BUILD)
         {
            bbRec = this.blitzBottomBar.getRect(this);
         }
         else
         {
            bbRec = this.bottomBar.getRect(this);
         }
         return bbRec.contains(mouseX,mouseY);
      }
   }
}
