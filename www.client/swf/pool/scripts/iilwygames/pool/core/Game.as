package iilwygames.pool.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.IGamenetGame;
   import iilwygames.pool.model.GameModel;
   import iilwygames.pool.model.Player;
   import iilwygames.pool.view.GameView;
   
   public class Game extends Sprite implements IGamenetGame
   {
       
      
      protected var _model:GameModel;
      
      protected var _view:GameView;
      
      protected var _cache_width:Number;
      
      protected var _cache_height:Number;
      
      protected var _lastUpdateTime:uint;
      
      private var _date:Date;
      
      private var _lastDateTime:Number;
      
      private var _timeVelocity:Number;
      
      private var _totalET:Number;
      
      private var _totalDateET:Number;
      
      public function Game()
      {
         super();
         this._lastUpdateTime = 0;
         this._date = new Date();
         Globals.initialize();
         addChild(Globals.view);
         this._model = Globals.model;
         this._view = Globals.view;
         this._timeVelocity = Number.NaN;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function start(holder:DisplayObject, gamenetController:GamenetController) : void
      {
         Globals.initialize();
         if(Globals.view && !contains(Globals.view))
         {
            addChild(Globals.view);
         }
         this._model = Globals.model;
         this._view = Globals.view;
         Globals.netController = gamenetController;
         Globals.netMediator.activate(gamenetController);
         Globals.resourceManager.loadAssets(gamenetController);
         Globals.keyListener.activate(holder);
         if(Globals.FACEBOOK_BUILD)
         {
            Globals.productManager.initialize(gamenetController);
         }
         this._model.initialize(gamenetController);
         this._view.init();
         this._view.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._view.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._date = new Date();
         this._lastUpdateTime = getTimer();
         this._lastDateTime = this._date.time;
         this._totalET = 0;
         this._totalDateET = 0;
      }
      
      public function stop() : void
      {
         if(this._view)
         {
            this._view.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         Globals.stop();
         if(this._view && contains(this._view))
         {
            removeChild(this._view);
         }
         this._model = null;
         this._view = null;
      }
      
      public function destroy() : void
      {
         Globals.destroy();
         this._model = null;
         this._view = null;
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var lp:Player = null;
         var name:String = null;
         this._date = new Date();
         var currentTime:uint = getTimer();
         var currentDateTime:Number = this._date.time;
         var et:Number = currentTime - this._lastUpdateTime;
         this._lastUpdateTime = currentTime;
         var date_et:Number = currentDateTime - this._lastDateTime;
         this._lastDateTime = currentDateTime;
         this._totalDateET = this._totalDateET + date_et;
         this._totalET = this._totalET + et;
         var difference:Number = date_et - et;
         var DIFF_LIMIT:Number = 2000;
         if(difference < -DIFF_LIMIT || difference > DIFF_LIMIT)
         {
            lp = Globals.model.localPlayer;
            name = null;
            if(lp)
            {
               name = lp.playerData.profileName;
            }
            if(name)
            {
               Globals.netController.sendNotification("Game information being sent to OMGPOP.  Have a nice day. :)");
            }
            this._model.markedAsCheating = true;
         }
         if(et > 2000)
         {
            et = 2000;
         }
         et = et / 1000;
         Globals.netMediator.update(et);
         this._model.update(et);
         this._view.update(et);
         if(this._model.quitgameNextUpdate)
         {
            this._model.quitGame();
         }
      }
      
      public function setSize(width:Number, height:Number) : Rectangle
      {
         var rec:Rectangle = null;
         if(this._view)
         {
            rec = this._view.setSize(width,height);
         }
         this._cache_width = width;
         this._cache_height = height;
         return rec;
      }
   }
}
