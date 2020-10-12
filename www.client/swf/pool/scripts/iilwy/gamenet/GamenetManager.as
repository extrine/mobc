package iilwy.gamenet
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.system.Security;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.events.ArcadeEvent;
   import iilwy.factories.ProductFactory;
   import iilwy.gamenet.developer.ExtendedGamenetPlayerData;
   import iilwy.gamenet.developer.GamenetController;
   import iilwy.gamenet.developer.GamenetEvent;
   import iilwy.gamenet.developer.GamenetPlayerData;
   import iilwy.gamenet.developer.IGamenetGame;
   import iilwy.gamenet.developer.PlayModes;
   import iilwy.gamenet.developer.PlayerRoles;
   import iilwy.gamenet.developer.RoundResults;
   import iilwy.gamenet.events.ConnectionEvent;
   import iilwy.gamenet.events.XMPPDataEvent;
   import iilwy.gamenet.model.CurrentPlayerData;
   import iilwy.gamenet.model.MatchData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.gamenet.model.PlayerExtension;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.gamenet.model.RoomData;
   import iilwy.model.dataobjects.AnimationData;
   import iilwy.utils.InstantPurchaseUtil;
   import iilwy.utils.ObjectUtil;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   import iilwy.utils.logging.Logger;
   import org.igniterealtime.xiff.core.Browser;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.RosterEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   import org.igniterealtime.xiff.im.Roster;
   
   public class GamenetManager extends EventDispatcher
   {
       
      
      private const TIMEOUT_TIME:int = 30000;
      
      private const SHUTDOWN_TIME:int = 5000;
      
      public var serverID:int = -1;
      
      public var serverURL:String;
      
      public var port:int = 5222;
      
      public var policyPort:int = 5229;
      
      public var streamType:uint = 0;
      
      public var username:String;
      
      public var password:String;
      
      public var currentPlayer:CurrentPlayerData;
      
      public var gamenetController:GamenetController;
      
      public var forcedServerID:int = -1;
      
      private var logger:Logger;
      
      private var serverNowTimestamp:uint;
      
      private var connectionTimer:Timer;
      
      private var shutdownTimer:Timer;
      
      private var _serverNow:uint;
      
      private var _connection:XMPPConnection;
      
      private var _roster:Roster;
      
      private var _browser:Browser;
      
      private var _currentMatch:MatchData;
      
      private var _liveChatRoom:RoomData;
      
      private var _loggedIn:Boolean = false;
      
      private var _connectionReservations:int = 0;
      
      public function GamenetManager()
      {
         super();
         this.registerGamenetClasses();
         this.setupLogger();
         this.serverNowTime = new Date().time;
         this.setupPlayer();
         this.registerExtensions();
         this.setupConnection();
         this.setupRoster();
         this.setupBrowser();
         this.setupMatch();
         this.setupChatRoom();
         this.setupTimers();
         this.setupGamenetController();
      }
      
      public function get conferenceServer() : String
      {
         return "conference." + this.serverURL;
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function get roster() : Roster
      {
         return this._roster;
      }
      
      public function get browser() : Browser
      {
         return this._browser;
      }
      
      public function get currentMatch() : MatchData
      {
         return this._currentMatch;
      }
      
      public function get liveChatRoom() : RoomData
      {
         return this._liveChatRoom;
      }
      
      public function get loggedIn() : Boolean
      {
         return this.connection.isLoggedIn();
      }
      
      public function set logLevel(value:Number) : void
      {
         this.logger.level = value;
      }
      
      public function get serverNowTime() : uint
      {
         return this._serverNow + (getTimer() - this.serverNowTimestamp);
      }
      
      public function set serverNowTime(value:uint) : void
      {
         if(value > 1000)
         {
            this._serverNow = value;
            this.serverNowTimestamp = getTimer();
         }
         else
         {
            this.logger.warn("Bad time",value);
         }
      }
      
      public function connect() : void
      {
         this.removeRosterListeners();
         this.removeConnectionListeners();
         this.serverID = this.currentPlayer.currentServerID;
         this.serverURL = this.currentPlayer.currentServerURL;
         this.username = this.currentPlayer.currentUsername;
         this.password = this.currentPlayer.currentPassword;
         this.setupConnection();
         this.setupRoster();
         this.setupBrowser();
         this._connection.username = this.username;
         this._connection.password = this.password;
         this._connection.server = this.serverURL;
         Security.loadPolicyFile("xmlsocket://" + this.serverURL + ":" + this.policyPort);
         this.logger.log("Connecting as",this.username,"to",this.serverURL,":",this.port);
         this._connection.port = this.port;
         this._connection.connect(this.streamType);
         this.connectionTimer.reset();
         this.connectionTimer.start();
      }
      
      public function disconnect() : void
      {
         this.logger.info("Disconnecting");
         this._currentMatch.leave();
         this._liveChatRoom.leave();
         this.removeRosterListeners();
         this._connection.disconnect();
         this.removeConnectionListeners();
      }
      
      public function updatePresence() : void
      {
         var updatePresence:Presence = null;
         var playerExtension:PlayerExtension = null;
         if(this.currentPlayer && this.currentMatch && this._connection && this._connection.isActive())
         {
            updatePresence = new Presence(this.currentMatch.xmppRoom.userJID.escaped);
            playerExtension = this.currentPlayer.toExtension();
            updatePresence.addExtension(playerExtension);
            this._connection.send(updatePresence);
         }
      }
      
      public function getValidPorts() : Array
      {
         return [5222,5190,5159,90,80,100];
      }
      
      public function initController() : GamenetController
      {
         AppComponents.model.arcade.clearPlayerPreviews();
         this.gamenetController = new GamenetController();
         this.gamenetController.config = this.currentMatch.config;
         this.gamenetController.playMode = PlayModes.MULTIPLAYER;
         var h:PlayerData = new PlayerData();
         h.initFromStatusObject(this.currentMatch.host.toStatusObject());
         this.gamenetController.host = h;
         this.gamenetController.hostData = h;
         this.gamenetController.playerRole = this.currentMatch.playerRole;
         var p:PlayerData = new PlayerData();
         p.initFromStatusObject(this.currentPlayer.toStatusObject());
         this.gamenetController.player = p;
         this.gamenetController.playerData = p;
         this.gamenetController.players = this.currentMatch.players;
         this.gamenetController.chatMessages = this.currentMatch.chatMessages;
         this.gamenetController.playerList = this.currentMatch.players.source;
         this.gamenetController.chatMessageList = this.currentMatch.players.source;
         this.gamenetController.spectatorList = this.currentMatch.spectators.source;
         this.gamenetController.setSyncedTime(this.serverNowTime);
         this.logger.log("Init controller times",this.serverNowTime,this.currentMatch.startTime);
         this.gamenetController.startTime = this.currentMatch.startTime;
         this.gamenetController.randomSeed = this.currentMatch.randomSeed;
         this.gamenetController.userGameStore = ObjectUtil.cloneObject(AppComponents.model.arcade.currentUserGameStore);
         this.gamenetController.genericNumberStore = ObjectUtil.cloneObject(AppComponents.model.arcade.currentUserGenericValueStore.numbers);
         this.gamenetController.gameType = this.currentMatch.gameType;
         this.gamenetController.teamType = this.currentMatch.teamType;
         this.gamenetController.roundIndex = this.currentMatch.round;
         this.gamenetController.gameId = AppComponents.model.arcade.currentGamePack.id;
         this.gamenetController.shopId = AppComponents.model.arcade.currentGamePack.shopId;
         if(AppComponents.model.arcade.currentInstantPuchaseCollection)
         {
            this.gamenetController.instantPurchaseCollection = ProductFactory.serializeCatalogProductBaseCollection(AppComponents.model.arcade.currentInstantPuchaseCollection);
         }
         this.addControllerListeners();
         return this.gamenetController;
      }
      
      public function initSinglePlayerController() : GamenetController
      {
         this.gamenetController = new GamenetController();
         this.gamenetController.config = {};
         this.gamenetController.playerRole = PlayerRoles.HOST;
         var p:PlayerData = this.currentPlayer.clone();
         p.playerJid = "singlePlayer";
         this.gamenetController.playerData = p;
         this.gamenetController.hostData = p;
         this.gamenetController.playerList = [p];
         this.gamenetController.chatMessageList = [];
         this.gamenetController.spectatorList = [];
         this.gamenetController.setSyncedTime(this.serverNowTime);
         this.logger.log("Init controller times",this.serverNowTime,this.currentMatch.startTime);
         this.gamenetController.startTime = this.serverNowTime;
         this.gamenetController.randomSeed = Math.floor(Math.random() * 10000000);
         this.gamenetController.userGameStore = AppComponents.model.arcade.currentUserGameStore;
         this.gamenetController.genericNumberStore = ObjectUtil.cloneObject(AppComponents.model.arcade.currentUserGenericValueStore.numbers);
         this.gamenetController.gameType = AppComponents.model.arcade.currentGamePack.getDefaultGameType().value;
         this.gamenetController.teamType = null;
         this.gamenetController.gameId = AppComponents.model.arcade.currentGamePack.id;
         this.gamenetController.shopId = AppComponents.model.arcade.currentGamePack.shopId;
         if(AppComponents.model.arcade.currentInstantPuchaseCollection)
         {
            this.gamenetController.instantPurchaseCollection = ProductFactory.serializeCatalogProductBaseCollection(AppComponents.model.arcade.currentInstantPuchaseCollection);
         }
         this.gamenetController.sender.addEventListener("quit",this.onControllerQuit);
         this.gamenetController.sender.addEventListener("forceResize",this.onControllerForceResize);
         this.gamenetController.sender.addEventListener("earnAchievement",this.onControllerEarnAchievement);
         this.gamenetController.sender.addEventListener("getBestScores",this.onControllerGetBestScores);
         this.gamenetController.sender.addEventListener("updateUserGameStore",this.onControllerUpdateUserGameStore);
         this.gamenetController.sender.addEventListener("buyInstantPurchaseProduct",this.onControllerBuyInstantPurchaseItem);
         this.gamenetController.sender.addEventListener("consumeProduct",this.onControllerConsumeProduct);
         this.gamenetController.sender.addEventListener("incrementGenericNumber",this.onControllerIncrementGenericNumber);
         this.gamenetController.sender.addEventListener("decrementGenericNumber",this.onControllerDecrementGenericNumber);
         this.gamenetController.sender.addEventListener("setGenericNumber",this.onControllerSetGenericNumber);
         return this.gamenetController;
      }
      
      public function clearController() : void
      {
         this.removeControllerListeners();
         this.gamenetController = new GamenetController();
      }
      
      public function addConnectionReservation() : void
      {
         this._connectionReservations++;
         this.cancelTimedShutdown();
         this.logger.info("Add connection reservation",this._connectionReservations);
      }
      
      public function removeConnectionReservation() : void
      {
         this._connectionReservations--;
         this._connectionReservations = Math.max(0,this._connectionReservations);
         this.logger.info("Remove connection reservation",this._connectionReservations);
         if(this._connectionReservations == 0)
         {
            this.startTimedShutdown();
         }
      }
      
      public function startTimedShutdown() : void
      {
         this.shutdownTimer.reset();
         this.shutdownTimer.start();
      }
      
      public function cancelTimedShutdown() : void
      {
         this.shutdownTimer.stop();
      }
      
      private function registerGamenetClasses() : void
      {
         GamenetController(null);
         GamenetEvent(null);
         GamenetPlayerData(null);
         IGamenetGame(null);
         PlayerRoles(null);
         RoundResults(null);
         ExtendedGamenetPlayerData(null);
         PlayModes(null);
         InstantPurchaseUtil(null);
      }
      
      private function setupLogger() : void
      {
         this.logger = Logger.getLogger("GamenetManager");
         this.logger.level = Logger.WARN;
      }
      
      private function setupPlayer() : void
      {
         this.currentPlayer = new CurrentPlayerData();
         this.currentPlayer.profileName = "Default";
      }
      
      private function registerExtensions() : void
      {
         PlayerExtension.enable();
      }
      
      private function setupConnection() : void
      {
         this._connection = new XMPPConnection();
         this.addConnectionListeners();
      }
      
      private function setupRoster() : void
      {
         this._roster = new Roster(this._connection);
         this.addRosterListeners();
      }
      
      private function setupBrowser() : void
      {
         this._browser = new Browser(this._connection);
      }
      
      private function setupMatch() : void
      {
         this._currentMatch = new MatchData(this);
      }
      
      private function setupChatRoom() : void
      {
         this._liveChatRoom = new RoomData(this);
      }
      
      private function setupTimers() : void
      {
         this.connectionTimer = new Timer(this.TIMEOUT_TIME,1);
         this.connectionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onConnectionTimer);
         this.shutdownTimer = new Timer(this.SHUTDOWN_TIME,1);
         this.shutdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownTimer);
      }
      
      private function setupGamenetController() : void
      {
         this.gamenetController = new GamenetController();
      }
      
      private function addConnectionListeners() : void
      {
         this._connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnectSuccess,false,0,true);
         this._connection.addEventListener(DisconnectionEvent.DISCONNECT,this.onDisconnect,false,0,true);
         this._connection.addEventListener(LoginEvent.LOGIN,this.onLogin,false,0,true);
         this._connection.addEventListener(XIFFErrorEvent.XIFF_ERROR,this.onConnectionError,false,0,true);
         this._connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onOutgoingData,false,0,true);
         this._connection.addEventListener(IncomingDataEvent.INCOMING_DATA,this.onIncomingData,false,0,true);
         this._connection.addEventListener(PresenceEvent.PRESENCE,this.onPresence,false,0,true);
      }
      
      private function removeConnectionListeners() : void
      {
         this._connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnectSuccess);
         this._connection.removeEventListener(DisconnectionEvent.DISCONNECT,this.onDisconnect,false);
         this._connection.removeEventListener(LoginEvent.LOGIN,this.onLogin);
         this._connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR,this.onConnectionError);
         this._connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onOutgoingData);
         this._connection.removeEventListener(IncomingDataEvent.INCOMING_DATA,this.onIncomingData);
         this._connection.removeEventListener(PresenceEvent.PRESENCE,this.onPresence);
      }
      
      private function addRosterListeners() : void
      {
         this._roster.addEventListener(RosterEvent.ROSTER_LOADED,this.onRosterLoaded);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL,this.onSubscriptionDenial);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST,this.onSubscriptionRequest);
         this._roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION,this.onSubscriptionRevocation);
         this._roster.addEventListener(RosterEvent.USER_ADDED,this.onUserAdded);
         this._roster.addEventListener(RosterEvent.USER_AVAILABLE,this.onUserAvailable);
         this._roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED,this.onUserPresenceUpdated);
         this._roster.addEventListener(RosterEvent.USER_REMOVED,this.onUserRemoved);
         this._roster.addEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED,this.onUserSubscriptionUpdated);
         this._roster.addEventListener(RosterEvent.USER_UNAVAILABLE,this.onUserUnavailable);
      }
      
      private function removeRosterListeners() : void
      {
         this._roster.removeEventListener(RosterEvent.ROSTER_LOADED,this.onRosterLoaded);
         this._roster.removeEventListener(RosterEvent.SUBSCRIPTION_DENIAL,this.onSubscriptionDenial);
         this._roster.removeEventListener(RosterEvent.SUBSCRIPTION_REQUEST,this.onSubscriptionRequest);
         this._roster.removeEventListener(RosterEvent.SUBSCRIPTION_REVOCATION,this.onSubscriptionRevocation);
         this._roster.removeEventListener(RosterEvent.USER_ADDED,this.onUserAdded);
         this._roster.removeEventListener(RosterEvent.USER_AVAILABLE,this.onUserAvailable);
         this._roster.removeEventListener(RosterEvent.USER_PRESENCE_UPDATED,this.onUserPresenceUpdated);
         this._roster.removeEventListener(RosterEvent.USER_REMOVED,this.onUserRemoved);
         this._roster.removeEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED,this.onUserSubscriptionUpdated);
         this._roster.removeEventListener(RosterEvent.USER_UNAVAILABLE,this.onUserUnavailable);
      }
      
      private function addControllerListeners() : void
      {
         this.gamenetController.sender.addEventListener("chat",this.onControllerChat);
         this.gamenetController.sender.addEventListener("gameAction",this.onControllerGameAction);
         this.gamenetController.sender.addEventListener("gameActionEncrypted",this.onControllerGameActionEncrypted);
         this.gamenetController.sender.addEventListener("notification",this.onControllerNotification);
         this.gamenetController.sender.addEventListener("lobbyNotification",this.onControllerLobbyNotification);
         this.gamenetController.sender.addEventListener("selfNotification",this.onControllerSelfNotification);
         this.gamenetController.sender.addEventListener("matchBackToReady",this.onControllerBackToReady);
         this.gamenetController.sender.addEventListener("recordRound",this.onControllerRecordRound);
         this.gamenetController.sender.addEventListener("kickPlayer",this.onControllerKickPlayer);
         this.gamenetController.sender.addEventListener("logToServer",this.onControllerLogToServer);
         this.gamenetController.sender.addEventListener("logToConsole",this.onControllerLogToConsole);
         this.gamenetController.sender.addEventListener("quit",this.onControllerQuit);
         this.gamenetController.sender.addEventListener("forceResize",this.onControllerForceResize);
         this.gamenetController.sender.addEventListener("earnAchievement",this.onControllerEarnAchievement);
         this.gamenetController.sender.addEventListener("getBestScores",this.onControllerGetBestScores);
         this.gamenetController.sender.addEventListener("setMatchAboutString",this.onControllerSetMatchAboutString);
         this.gamenetController.sender.addEventListener("setMatchThumbnail",this.onControllerSetMatchThumbnail);
         this.gamenetController.sender.addEventListener("setMatchConfig",this.onControllerSetMatchConfig);
         this.gamenetController.sender.addEventListener("updateUserGameStore",this.onControllerUpdateUserGameStore);
         this.gamenetController.sender.addEventListener("incrementGenericNumber",this.onControllerIncrementGenericNumber);
         this.gamenetController.sender.addEventListener("decrementGenericNumber",this.onControllerDecrementGenericNumber);
         this.gamenetController.sender.addEventListener("setGenericNumber",this.onControllerSetGenericNumber);
         this.gamenetController.sender.addEventListener("setPlayerPreview",this.onControllerSetPlayerPreview);
         this.gamenetController.sender.addEventListener("setPlayerPreview",this.onControllerSetPlayerPreview);
         this.gamenetController.sender.addEventListener("buyInstantPurchaseProduct",this.onControllerBuyInstantPurchaseItem);
         this.gamenetController.sender.addEventListener("consumeProduct",this.onControllerConsumeProduct);
         this.gamenetController.sender.addEventListener("alert",this.onControllerAlert);
         this.gamenetController.sender.addEventListener("alertSelf",this.onControllerAlertSelf);
         this.gamenetController.sender.addEventListener("notify",this.onControllerNotify);
         this.gamenetController.sender.addEventListener("notifySelf",this.onControllerNotifySelf);
         this.gamenetController.sender.addEventListener("setPredictedMatchBackToReadyTime",this.onControllerSetPredictedMatchBackToReadyTime);
         this.gamenetController.sender.addEventListener("track",this.onControllerTrack);
      }
      
      private function removeControllerListeners() : void
      {
         if(this.gamenetController != null)
         {
            this.gamenetController.sender.removeEventListener("chat",this.onControllerChat);
            this.gamenetController.sender.removeEventListener("gameAction",this.onControllerGameAction);
            this.gamenetController.sender.removeEventListener("gameActionEncrypted",this.onControllerGameActionEncrypted);
            this.gamenetController.sender.removeEventListener("notification",this.onControllerNotification);
            this.gamenetController.sender.removeEventListener("lobbyNotification",this.onControllerLobbyNotification);
            this.gamenetController.sender.removeEventListener("selfNotification",this.onControllerSelfNotification);
            this.gamenetController.sender.removeEventListener("matchBackToReady",this.onControllerBackToReady);
            this.gamenetController.sender.removeEventListener("recordRound",this.onControllerRecordRound);
            this.gamenetController.sender.removeEventListener("kickPlayer",this.onControllerKickPlayer);
            this.gamenetController.sender.removeEventListener("logToServer",this.onControllerLogToServer);
            this.gamenetController.sender.removeEventListener("logToConsole",this.onControllerLogToConsole);
            this.gamenetController.sender.removeEventListener("quit",this.onControllerQuit);
            this.gamenetController.sender.removeEventListener("forceResize",this.onControllerForceResize);
            this.gamenetController.sender.removeEventListener("earnAchievement",this.onControllerEarnAchievement);
            this.gamenetController.sender.removeEventListener("getBestScores",this.onControllerGetBestScores);
            this.gamenetController.sender.removeEventListener("setMatchAboutString",this.onControllerSetMatchAboutString);
            this.gamenetController.sender.removeEventListener("setMatchThumbnail",this.onControllerSetMatchThumbnail);
            this.gamenetController.sender.removeEventListener("setMatchConfig",this.onControllerSetMatchConfig);
            this.gamenetController.sender.removeEventListener("updateUserGameStore",this.onControllerUpdateUserGameStore);
            this.gamenetController.sender.removeEventListener("incrementGenericNumber",this.onControllerIncrementGenericNumber);
            this.gamenetController.sender.removeEventListener("decrementGenericNumber",this.onControllerDecrementGenericNumber);
            this.gamenetController.sender.removeEventListener("setGenericNumber",this.onControllerSetGenericNumber);
            this.gamenetController.sender.removeEventListener("setPlayerPreview",this.onControllerSetPlayerPreview);
            this.gamenetController.sender.removeEventListener("setPlayerPreview",this.onControllerSetPlayerPreview);
            this.gamenetController.sender.removeEventListener("buyInstantPurchaseProduct",this.onControllerBuyInstantPurchaseItem);
            this.gamenetController.sender.removeEventListener("consumeProduct",this.onControllerConsumeProduct);
            this.gamenetController.sender.removeEventListener("alert",this.onControllerAlert);
            this.gamenetController.sender.removeEventListener("alertSelf",this.onControllerAlertSelf);
            this.gamenetController.sender.removeEventListener("notify",this.onControllerNotify);
            this.gamenetController.sender.removeEventListener("notifySelf",this.onControllerNotifySelf);
            this.gamenetController.sender.removeEventListener("setPredictedMatchBackToReadyTime",this.onControllerSetPredictedMatchBackToReadyTime);
            this.gamenetController.sender.removeEventListener("track",this.onControllerTrack);
         }
      }
      
      private function onConnectSuccess(event:Event) : void
      {
         this.connectionTimer.stop();
         this._connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR,this.onConnectionError);
         this.logger.info("Connected");
         dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_SUCCESS));
      }
      
      private function onDisconnect(event:Event) : void
      {
         this.logger.info("Disconnected");
      }
      
      private function onLogin(event:LoginEvent) : void
      {
         this._loggedIn = true;
         this.logger.info("Logged in");
         this._roster.setPresence(null,"Online",5);
         dispatchEvent(new ConnectionEvent(ConnectionEvent.LOGIN));
      }
      
      private function onConnectionError(event:XIFFErrorEvent) : void
      {
         this.logger.log("Error connecting");
         var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
         xiffErrorEvent.errorCode = event.errorCode;
         xiffErrorEvent.errorCondition = event.errorCondition;
         xiffErrorEvent.errorMessage = event.errorMessage;
         xiffErrorEvent.errorType = event.errorType;
         dispatchEvent(xiffErrorEvent);
      }
      
      private function onOutgoingData(event:OutgoingDataEvent) : void
      {
         this.logger.log("Outgoing data",event.data);
         var xmppDataEvent:XMPPDataEvent = new XMPPDataEvent(XMPPDataEvent.OUTGOING_DATA);
         xmppDataEvent.data = event.data;
         dispatchEvent(xmppDataEvent);
      }
      
      private function onIncomingData(event:IncomingDataEvent) : void
      {
         var xmppDataEvent:XMPPDataEvent = new XMPPDataEvent(XMPPDataEvent.INCOMING_DATA);
         xmppDataEvent.data = event.data;
         this.logger.log("Incoming data",event.data);
         dispatchEvent(xmppDataEvent);
      }
      
      private function onPresence(event:PresenceEvent) : void
      {
         this.logger.log("presence");
      }
      
      private function onRosterLoaded(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onSubscriptionDenial(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onSubscriptionRequest(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onSubscriptionRevocation(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserAdded(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserAvailable(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserPresenceUpdated(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserRemoved(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserSubscriptionUpdated(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onUserUnavailable(event:RosterEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onControllerChat(event:*) : void
      {
         this.currentMatch.sendChat(event.msg,event.playerJID);
      }
      
      private function onControllerGameAction(event:*) : void
      {
         this.currentMatch.sendGameAction(event.data,event.playerJID);
      }
      
      private function onControllerGameActionEncrypted(event:*) : void
      {
         this.currentMatch.sendGameActionEncrypted(event.data,event.playerJID);
      }
      
      private function onControllerNotification(event:*) : void
      {
         this.currentMatch.sendNotification(event.notification,event.playerJID);
      }
      
      private function onControllerLobbyNotification(event:*) : void
      {
      }
      
      private function onControllerSelfNotification(event:*) : void
      {
         this.currentMatch.selfNotification(event.notification);
      }
      
      private function onControllerBackToReady(event:*) : void
      {
         this.currentMatch.hostEndMatch();
      }
      
      private function onControllerSetPredictedMatchBackToReadyTime(event:*) : void
      {
         this.currentMatch.hostSetPredictedOpenTime(event.offset);
      }
      
      private function onControllerRecordRound(event:*) : void
      {
         this.currentMatch.recordRound(event.scores);
      }
      
      private function onControllerKickPlayer(event:*) : void
      {
         this.currentMatch.hostKickPlayer(event.id,null,false);
      }
      
      private function onControllerLogToServer(event:*) : void
      {
         var msg:String = null;
         var level:String = "log";
         try
         {
            level = event.level.toLowerCase();
         }
         catch(e:Error)
         {
         }
         try
         {
            msg = "gamenetcontroller/logtoserver/" + AppComponents.model.arcade.currentGamePack.id + "/" + level + "/" + event.message;
            AppComponents.analytics.trackDiagnostic(msg);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onControllerLogToConsole(event:*) : void
      {
         var level:String = "log";
         try
         {
            level = event.level.toLowerCase();
         }
         catch(e:Error)
         {
         }
         try
         {
            Logger.getInstance()[level](event.message);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onControllerQuit(event:*) : void
      {
         var quitMatchEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.QUIT_MATCH);
         StageReference.stage.dispatchEvent(quitMatchEvent);
      }
      
      private function onControllerForceResize(event:*) : void
      {
         AppComponents.pageViewManager.onResize(null);
      }
      
      private function onControllerBuyInstantPurchaseItem(event:*) : void
      {
         var evt:ArcadeEvent = new ArcadeEvent(ArcadeEvent.BUY_INSTANT_PURCHASE_PRODUCT,true);
         evt.id = event.baseID;
         StageReference.stage.dispatchEvent(evt);
      }
      
      private function onControllerConsumeProduct(event:*) : void
      {
         var evt:ArcadeEvent = new ArcadeEvent(ArcadeEvent.CONSUME_PRODUCT,true);
         evt.id = event.itemID;
         evt.quantity = event.quantity;
         StageReference.stage.dispatchEvent(evt);
      }
      
      private function onControllerAlert(event:*) : void
      {
         this.currentMatch.alert(event.method,event.args,event.playerJID);
      }
      
      private function onControllerAlertSelf(event:*) : void
      {
         this.currentMatch.alertSelf(event.method,event.args);
      }
      
      private function onControllerNotify(event:*) : void
      {
         this.currentMatch.notify(event.method,event.args,event.playerJID);
      }
      
      private function onControllerNotifySelf(event:*) : void
      {
         this.currentMatch.notifySelf(event.method,event.args);
      }
      
      private function onControllerTrack(event:*) : void
      {
         this.currentMatch.track(event.trackerType,event.method,event.args);
      }
      
      private function onControllerEarnAchievement(event:*) : void
      {
         var earnAchievementEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.EARN_ACHIEVEMENT);
         earnAchievementEvent.data = event.args;
         earnAchievementEvent.gamePack = AppComponents.model.arcade.currentGamePack;
         StageReference.stage.dispatchEvent(earnAchievementEvent);
      }
      
      private function onControllerGetBestScores(event:*) : void
      {
         var responder:Responder = new Responder();
         responder.setAsyncListeners(event.onSuccess,event.onFail);
         var getBestScoresEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.GET_BEST_SCORES);
         getBestScoresEvent.data = event.params;
         getBestScoresEvent.responder = responder;
         StageReference.stage.dispatchEvent(getBestScoresEvent);
      }
      
      private function onControllerSetMatchAboutString(event:*) : void
      {
         if(this.currentPlayer.equals(this.currentMatch.host))
         {
            this.currentMatch.aboutString = event.aboutString;
            this.currentMatch.sendSubject();
         }
      }
      
      private function onControllerSetMatchThumbnail(event:*) : void
      {
         if(this.currentPlayer.equals(this.currentMatch.host))
         {
            this.currentMatch.thumbnailUrl = event.thumbnailUrl;
            this.currentMatch.sendSubject();
         }
      }
      
      private function onControllerSetMatchConfig(event:*) : void
      {
         if(this.currentPlayer.equals(this.currentMatch.host))
         {
            this.currentMatch.config = event.config;
            this.currentMatch.sendSubject();
         }
      }
      
      private function onControllerUpdateUserGameStore(event:*) : void
      {
         var updateEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.UPDATE_USER_GAME_STORE);
         updateEvent.data = event.data;
         updateEvent.gamePack = AppComponents.model.arcade.currentGamePack;
         StageReference.stage.dispatchEvent(updateEvent);
      }
      
      private function onControllerSetPlayerPreview(event:*) : void
      {
         var settings:AnimationData = new AnimationData();
         settings.frames = event.data.frames;
         settings.frameRate = event.data.frameRate;
         settings.rect = event.data.size;
         settings.loops = event.data.loop;
         settings.center = event.data.center;
         AppComponents.model.arcade.playerPreviews[event.playerJID] = settings;
      }
      
      private function onControllerIncrementGenericNumber(event:*) : void
      {
         AppComponents.model.arcade.currentUserGenericValueStore.incrementNumber(event.key,event.amount);
      }
      
      private function onControllerDecrementGenericNumber(event:*) : void
      {
         AppComponents.model.arcade.currentUserGenericValueStore.decrementNumber(event.key,event.amount);
      }
      
      private function onControllerSetGenericNumber(event:*) : void
      {
         AppComponents.model.arcade.currentUserGenericValueStore.setNumber(event.key,event.amount);
      }
      
      private function handleGenericNumberEvent(event:*, methodType:String) : void
      {
      }
      
      private function onConnectionTimer(event:TimerEvent) : void
      {
         this.logger.log("Manual connect timeout");
         dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_TIMEOUT));
      }
      
      private function onShutdownTimer(event:TimerEvent) : void
      {
         this.disconnect();
         var statusEvent:ArcadeEvent = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
         statusEvent.playerStatus = new PlayerStatus();
         statusEvent.playerStatus.offline();
         StageReference.stage.dispatchEvent(statusEvent);
      }
   }
}
