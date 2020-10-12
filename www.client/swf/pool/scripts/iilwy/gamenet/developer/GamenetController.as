package iilwy.gamenet.developer
{
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;

   [Event(name="playerLeft",type="iilwy.gamenet.developer.GamenetEvent")]
   [Event(name="hostChanged",type="iilwy.gamenet.developer.GamenetEvent")]
   [Event(name="gameAction",type="iilwy.gamenet.developer.GamenetEvent")]
   [Event(name="notification",type="iilwy.gamenet.developer.GamenetEvent")]
   [Event(name="chat",type="iilwy.gamenet.developer.GamenetEvent")]
   public class GamenetController extends EventDispatcher
   {


      public var playerList:Array;

      public var spectatorList:Array;

      public var chatMessageList:Array;

      public var hostData:GamenetPlayerData;

      public var playerData:GamenetPlayerData;

      public var playerRole:String;

      public var startTime:Number;

      public var randomSeed:Number;

      public var roundIndex:Number;

      public var chatInFilter:Function;

      public var chatOutFilter:Function;

      public var gameType:String;

      public var teamType:String;

      public var config:Object;

      public var userGameStore:Object;

      public var genericNumberStore:Object;

      public var playMode:String;

      public var challengeInfo:Object;

      public var shopId:int;

      public var gameId:String;

      public var instantPurchaseCollection:Array;

      private var _serverNow:Number;

      private var _serverNowTimeStamp:Number;

      private var _sender:EventDispatcher;

      public var chatMessages;

      private var _players;

      private var _host;

      private var _player;

      public function GamenetController()
      {
         super();
         this._sender = new EventDispatcher();
      }

      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = true) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }

      public function sendNotification(string:String, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("notification");
         evt.notification = string;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function selfNotification(string:String) : void
      {
         var evt:* = new GamenetEvent("selfNotification");
         evt.notification = string;
         this.sender.dispatchEvent(evt);
      }

      public function sendLobbyNotification(string:String) : void
      {
         var evt:* = new GamenetEvent("lobbyNotification");
         evt.notification = string;
         this.sender.dispatchEvent(evt);
      }

      public function sendChat(string:String, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("chat");
         evt.msg = string;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function kickPlayer(id:String) : void
      {
         var evt:* = new GamenetEvent("kickPlayer");
         evt.id = id;
         this.sender.dispatchEvent(evt);
      }

      public function sendGameAction(data:Object, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("gameAction");
         evt.data = data;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function sendGameActionEncrypted(data:Object, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("gameActionEncrypted");
         evt.data = data;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function recordRound(scores:Object) : void
      {
         var evt:* = new GamenetEvent("recordRound");
         evt.scores = scores;
         this.sender.dispatchEvent(evt);
      }

      public function earnAchievement(... args) : void
      {
         var evt:* = new GamenetEvent("earnAchievement");
         evt.args = args;
         this.sender.dispatchEvent(evt);
      }

      public function getBestScores(params:Object, onSuccess:Function, onFail:Function) : void
      {
         var evt:* = new GamenetEvent("getBestScores");
         evt.params = params;
         evt.onSuccess = onSuccess;
         evt.onFail = onFail;
         this.sender.dispatchEvent(evt);
      }

      public function setPredictedMatchBackToReadyTime(offset:Number) : void
      {
         var evt:* = new GamenetEvent("setPredictedMatchBackToReadyTime");
         evt.offset = offset;
         this.sender.dispatchEvent(evt);
      }

      public function sendMatchBackToReady() : void
      {
         var evt:* = new GamenetEvent("matchBackToReady");
         this.sender.dispatchEvent(evt);
      }

      public function quit() : void
      {
         var evt:* = new GamenetEvent("quit");
         this.sender.dispatchEvent(evt);
      }

      public function setMatchAboutString(str:String) : void
      {
         var evt:* = new GamenetEvent("setMatchAboutString");
         evt.aboutString = str;
         this.sender.dispatchEvent(evt);
      }

      public function setMatchThumbnail(url:String) : void
      {
         var evt:* = new GamenetEvent("setMatchThumbnail");
         evt.thumbnailUrl = url;
         this.sender.dispatchEvent(evt);
      }

      public function setMatchConfig(config:*) : void
      {
         var evt:* = new GamenetEvent("setMatchConfig");
         evt.config = config;
         this.sender.dispatchEvent(evt);
      }

      public function forceResize() : void
      {
         var evt:* = new GamenetEvent("forceResize");
         this.sender.dispatchEvent(evt);
      }

      public function updateUserGameStore(data:*) : void
      {
         var evt:* = new GamenetEvent("updateUserGameStore");
         evt.data = data;
         this.sender.dispatchEvent(evt);
      }

      public function incrementGenericNumber(key:String, amount:uint) : void
      {
         var evt:* = new GamenetEvent("incrementGenericNumber");
         evt.key = key;
         evt.amount = amount;
         this.sender.dispatchEvent(evt);
      }

      public function decrementGenericNumber(key:String, amount:uint) : void
      {
         var evt:* = new GamenetEvent("decrementGenericNumber");
         evt.key = key;
         evt.amount = amount;
         this.sender.dispatchEvent(evt);
      }

      public function setGenericNumber(key:String, amount:int) : void
      {
         var evt:* = new GamenetEvent("setGenericNumber");
         evt.key = key;
         evt.amount = amount;
         this.sender.dispatchEvent(evt);
      }

      public function setPlayerPreview(playerJID:String, data:*) : void
      {
         var evt:* = new GamenetEvent("setPlayerPreview");
         evt.playerJID = playerJID;
         evt.data = data;
         this.sender.dispatchEvent(evt);
      }

      public function buyInstantPurchaseProduct(baseID:int, onSuccess:Function = null, onFail:Function = null) : void
      {
         var evt:* = new GamenetEvent("buyInstantPurchaseProduct");
         evt.baseID = baseID;
         this.sender.dispatchEvent(evt);
      }

      public function consumeProduct(itemID:int, quantity:int) : void
      {
         var evt:* = new GamenetEvent("consumeProduct");
         evt.itemID = itemID;
         evt.quantity = quantity;
         this.sender.dispatchEvent(evt);
      }

      public function alert(method:String, args:Array, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("alert");
         evt.method = method;
         evt.args = args;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function alertSelf(method:String, args:Array) : void
      {
         var evt:* = new GamenetEvent("alertSelf");
         evt.method = method;
         evt.args = args;
         this.sender.dispatchEvent(evt);
      }

      public function notify(method:String, args:Array, playerJID:String = null) : void
      {
         var evt:* = new GamenetEvent("notify");
         evt.method = method;
         evt.args = args;
         evt.playerJID = playerJID;
         this.sender.dispatchEvent(evt);
      }

      public function notifySelf(method:String, args:Array) : void
      {
         var evt:* = new GamenetEvent("notifySelf");
         evt.method = method;
         evt.args = args;
         this.sender.dispatchEvent(evt);
      }

      public function track(trackerType:String, method:String, args:Array) : void
      {
         var evt:* = new GamenetEvent("track");
         evt.trackerType = trackerType;
         evt.method = method;
         evt.args = args;
         this.sender.dispatchEvent(evt);
      }

      public function simulateIncomingGameAction(data:*, playerIndex:Number = undefined) : void
      {
         var evt:GamenetEvent = new GamenetEvent(GamenetEvent.GAME_ACTION);
         var index:Number = !isNaN(playerIndex)?Number(playerIndex):Number(Math.floor(Math.random() * (this.playerList.length - 1)));
         var sender:GamenetPlayerData = this.playerList[playerIndex];
         evt.sender = sender.playerJid;
         evt.recipient = this.playerData.playerJid;
         evt.data = data;
         this.dispatchEvent(evt);
      }

      public function logToConsole(message:String, level:String) : void
      {
         var evt:* = new GamenetEvent("logToConsole");
         evt.message = message;
         evt.level = level;
         this.sender.dispatchEvent(evt);
      }

      public function logToServer(message:String, level:String) : void
      {
         var evt:* = new GamenetEvent("logToServer");
         evt.message = message;
         evt.level = level;
         this.sender.dispatchEvent(evt);
      }

      public function get syncedTime() : Number
      {
         return this._serverNow + (getTimer() - this._serverNowTimeStamp);
      }

      public function setSyncedTime(val:Number) : void
      {
         if(val > 1000)
         {
            this._serverNow = val;
            this._serverNowTimeStamp = getTimer();
         }
         else
         {
            this.logToConsole("setSyncedTime: Bad time","ERROR");
         }
      }

      public function get sender() : EventDispatcher
      {
         return this._sender;
      }

      public function set players(value:*) : void
      {
         this._players = value;
      }

      public function get players() : *
      {
         trace("GamenetController.players is deprecated, please use playerList");
         return this._players;
      }

      public function set host(value:*) : void
      {
         this._host = value;
      }

      public function get host() : *
      {
         trace("GamenetController.host is deprecated, please use hostData");
         return this._host;
      }

      public function set player(value:*) : void
      {
         this._player = value;
      }

      public function get player() : *
      {
         trace("GamenetController.player is deprecated, please use playerData");
         return this._player;
      }
   }
}
