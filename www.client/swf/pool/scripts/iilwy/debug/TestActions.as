package iilwy.debug
{
   import com.adobe.utils.DateUtil;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import iilwy.application.AppComponents;
   import iilwy.display.core.NotificationManagerData;
   import iilwy.display.core.Popups;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.ArcadeEvent;
   import iilwy.events.RemoteEvent;
   import iilwy.gamenet.model.ChatData;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ArcadeGamePackData;
   import iilwy.net.EventNotificationType;
   import iilwy.ui.containers.List;
   import iilwy.ui.containers.ListDirection;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.ButtonSet;
   import iilwy.ui.controls.ComboBox;
   import iilwy.ui.controls.LiteButton;
   import iilwy.ui.controls.TextInput;
   import iilwy.ui.events.ButtonEvent;
   import iilwy.ui.events.ComboBoxEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.partials.scrollgroups.ScrollableSpriteScrollGroup;
   import iilwy.utils.EmbedUtil;
   import iilwy.utils.StageReference;
   import iilwy.utils.TestUtil;
   import iilwy.utils.TextUtil;
   import iilwy.utils.logging.Logger;
   
   public dynamic class TestActions extends UiModule
   {
       
      
      protected var _scrollSet:ScrollableSpriteScrollGroup;
      
      protected var _mainList:List;
      
      protected var _logger:Logger;
      
      protected var _forceXMPPCombo:ComboBox;
      
      protected var _notificationCombo:ComboBox;
      
      private var _arcadePromoCombo:ComboBox;
      
      public function TestActions()
      {
         super();
         percentHeight = 100;
         percentWidth = 100;
         this._logger = Logger.getLogger(this);
      }
      
      override public function createChildren() : void
      {
         this._scrollSet = new ScrollableSpriteScrollGroup();
         addContentChild(this._scrollSet);
         this._mainList = new List();
         this._scrollSet.scrollable.addContentChild(this._mainList);
         this.notificationTester();
         this.dumpMatchTester();
         this.dumpLocalStoreTester();
         this.dumpGameStoreTester();
         this.forceXMPPTester();
         this.arcadePromotionTester();
         this.achievementTester();
         this.tickTester();
         this.medalTester();
         this.clearGameTest();
         this.banTester();
         this.embedCodeOutput();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this._scrollSet.width = unscaledWidth;
         this._scrollSet.height = unscaledHeight;
      }
      
      protected function achievementTester() : void
      {
         var list:List = new List(0,0,List.TYPE_HORIZONTAL);
         list.name = "achievement";
         var but:LiteButton = new LiteButton("Earn Achievement");
         var field:TextInput = new TextInput(0,0,150,16,"simpleTextInput");
         field.name = "field";
         list.addContentChild(field);
         list.addContentChild(but);
         this._mainList.addContentChild(list);
         but.addEventListener(ButtonEvent.CLICK,this.onEarnAchievementClick);
      }
      
      protected function onEarnAchievementClick(event:ButtonEvent) : void
      {
         var evt:ArcadeEvent = new ArcadeEvent(ArcadeEvent.EARN_ACHIEVEMENT);
         evt.data = TextInput(UiContainer(this._mainList.getContentChildByName("achievement")).getContentChildByName("field")).text;
         evt.gamePack = AppComponents.model.arcade.currentGamePack;
         StageReference.stage.dispatchEvent(evt);
      }
      
      protected function dumpMatchTester() : void
      {
         var but:LiteButton = new LiteButton("Dump match");
         but.addEventListener(ButtonEvent.CLICK,this.onDumpMatch);
         this._mainList.addContentChild(but);
      }
      
      protected function onDumpMatch(event:Event) : void
      {
         var temp:* = undefined;
         var player:PlayerData = null;
         var obj:* = undefined;
         var roomObj:* = undefined;
         var p:String = null;
         var str:String = null;
         var extension:* = undefined;
         if(AppComponents.gamenetManager.currentMatch.isActive())
         {
            obj = {};
            obj.MATCH = AppComponents.gamenetManager.currentMatch.toSubjectObj();
            obj.PLAYERS = [];
            obj.SPECTATORS = [];
            obj.EXTENSIONS = {};
            obj.ROOM = [];
            for each(roomObj in AppComponents.gamenetManager.currentMatch.xmppRoom)
            {
               try
               {
                  obj.ROOM.push(roomObj.jid.node);
               }
               catch(e:Error)
               {
                  obj.ROOM.push("ERROR");
                  continue;
               }
            }
            for(p in AppComponents.gamenetManager.currentMatch.participants.source)
            {
               try
               {
                  extension = AppComponents.gamenetManager.currentMatch.participants.source[p];
                  temp = JSON.deserialize(extension.status);
                  try
                  {
                     delete temp.slate;
                  }
                  catch(e:Error)
                  {
                  }
                  obj.EXTENSIONS[p] = temp;
               }
               catch(e:Error)
               {
                  obj.EXTENSIONS[p] = "Error parsing extension";
                  continue;
               }
            }
            for each(player in AppComponents.gamenetManager.currentMatch.spectators.source)
            {
               temp = player.toStatusObject();
               delete temp.slate;
               obj.SPECTATORS.push(player.toStatusObject());
            }
            for each(player in AppComponents.gamenetManager.currentMatch.players.source)
            {
               temp = player.toStatusObject();
               delete temp.slate;
               obj.PLAYERS.push(player.toStatusObject());
            }
            str = JSON.serialize(obj);
            Logger.console.appendText(str);
         }
      }
      
      protected function dumpGameStoreTester() : void
      {
         var list:List = new List(0,0,List.TYPE_HORIZONTAL);
         list.name = "gameStore";
         var buttonSet:ButtonSet = new ButtonSet(0,0,16,ListDirection.HORIZONTAL,"simpleButtonSet");
         buttonSet.addEventListener(MultiSelectEvent.SELECT,this.onGameStoreSelect);
         buttonSet.addItem("Dump game store","dump");
         buttonSet.addItem("Save game store","save");
         list.addContentChild(buttonSet);
         var field:TextInput = new TextInput(0,0,150,16,"simpleTextInput");
         field.name = "field";
         list.addContentChild(field);
         this._mainList.addContentChild(list);
      }
      
      protected function onGameStoreSelect(event:MultiSelectEvent) : void
      {
         var data:* = undefined;
         var str:String = null;
         var evt:ArcadeEvent = null;
         if(AppComponents.localStore)
         {
            if(event.value == "dump")
            {
               Logger.console.appendText(JSON.serialize(AppComponents.model.arcade.currentUserGameStore));
            }
            else if(event.value == "save")
            {
               str = TextInput(UiContainer(this._mainList.getContentChildByName("gameStore")).getContentChildByName("field")).text;
               data = JSON.deserialize(str);
               evt = new ArcadeEvent(ArcadeEvent.UPDATE_USER_GAME_STORE);
               evt.data = data;
               evt.gamePack = AppComponents.model.arcade.currentGamePack;
               StageReference.stage.dispatchEvent(evt);
            }
         }
      }
      
      protected function dumpLocalStoreTester() : void
      {
         var buttonSet:ButtonSet = new ButtonSet(0,0,16,ListDirection.HORIZONTAL,"simpleButtonSet");
         buttonSet.addEventListener(MultiSelectEvent.SELECT,this.onLocalStoreSelect);
         buttonSet.addItem("Dump local store","dump");
         buttonSet.addItem("Clear local store","clear");
         this._mainList.addContentChild(buttonSet);
      }
      
      protected function onLocalStoreSelect(event:MultiSelectEvent) : void
      {
         var data:* = undefined;
         if(AppComponents.localStore)
         {
            if(event.value == "dump")
            {
               Logger.console.appendText(AppComponents.localStore.toString());
            }
            else if(event.value == "clear")
            {
               AppComponents.localStore.clear();
               Logger.console.appendText(AppComponents.localStore.toString());
            }
         }
      }
      
      protected function pointTester() : void
      {
         var but:LiteButton = new LiteButton("Get points");
         but.addEventListener(ButtonEvent.CLICK,this.onPointTest);
         this._mainList.addContentChild(but);
      }
      
      protected function onPointTest(event:Event) : void
      {
         var data:* = undefined;
         data = JSON.deserialize("{\"e_message\":\"You got 40 points when made a drawing.\",\"e_update_elements\":[{\"id\":\"menu_points_o\",\"url\":\"/user/update_menu_points_o_partial\"}],\"e_cached_balance\":51531,\"e_type\":" + EventNotificationType.GOT_POINTS + ",\"time\":1204161142,\"e_image\":\"/gfx/global/kitten/tiny.jpg\",\"e_link\":\"#\",\"e_cost\":-40}");
         AppComponents.remoteEventSubscriber.addEvent(data);
      }
      
      protected function clearGameTest() : void
      {
         var but:LiteButton = new LiteButton("Destroy game");
         but.addEventListener(ButtonEvent.CLICK,this.onClearGameTest);
         this._mainList.addContentChild(but);
      }
      
      protected function onClearGameTest(event:Event) : void
      {
         AppComponents.stateManager.processURL("/blank");
         var evt:ArcadeEvent = new ArcadeEvent(ArcadeEvent.SET_GAME_PACK,true);
         dispatchEvent(evt);
      }
      
      protected function forceXMPPTester() : void
      {
         this._forceXMPPCombo = new ComboBox("Forced XMPP server",0,0,200,16,"comboBoxSimple");
         var options:Array = [];
         options.push({
            "label":"Null",
            "value":null
         });
         for(var i:int = 0; i < 100; i++)
         {
            options.push(i);
         }
         this._forceXMPPCombo.setOptions(options);
         this._mainList.addContentChild(this._forceXMPPCombo);
         this._forceXMPPCombo.addEventListener(ComboBoxEvent.CHANGED,this.onForceXMPPChange);
      }
      
      protected function onForceXMPPChange(event:ComboBoxEvent) : void
      {
         AppComponents.gamenetManager.forcedServerID = int(this._forceXMPPCombo.value);
      }
      
      protected function notificationTester() : void
      {
         var list:List = new List(0,0,ListDirection.HORIZONTAL);
         this._notificationCombo = new ComboBox("Notification type",0,0,200,16,"comboBoxSimple");
         this._notificationCombo.setOptions(["error","confirm","long","yesno","promptQuestion","friendRequest","earnedExperience","banned","reported","dailylogin"]);
         list.addContentChild(this._notificationCombo);
         var but:LiteButton = new LiteButton("Notify");
         list.addContentChild(but);
         this._mainList.addContentChild(list);
         but.addEventListener(ButtonEvent.CLICK,this.onNotifyTest);
      }
      
      protected function onNotifyTest(event:ButtonEvent) : void
      {
         var obj:* = undefined;
         if(this._notificationCombo.value == "confirm")
         {
            AppComponents.notificationManager.showConfirmation("Confirm " + Math.floor(Math.random() * 1000));
         }
         else if(this._notificationCombo.value == "error")
         {
            AppComponents.notificationManager.showError("Error " + Math.floor(Math.random() * 1000));
         }
         else if(this._notificationCombo.value == "long")
         {
            AppComponents.notificationManager.showError(TestUtil.generateLoremImsum(40));
         }
         else if(this._notificationCombo.value == "yesno")
         {
            obj = JSON.deserialize("{\"e_image\":\"/gfx/global/kitten/tiny.jpg\",\"e_type\":" + EventNotificationType.QUIZ_QUESTION + ",\"e_link\":\"/home\",\"time\":1204069460,\"e_message\":\"Are you a people person?\",\"e_prop_id\":82}");
            AppComponents.notificationManager.showRemoteNotification(NotificationManagerData.createFromRemote(obj));
         }
         else if(this._notificationCombo.value == "friendRequest")
         {
            obj = JSON.deserialize("{\"e_type\":" + EventNotificationType.FRIEND_REQUEST + ",\"e_image\":\"/gfx/system_photo/female/base_tinythumb.jpg\",\"e_message\":\"test75 wants to be your friend.\",\"time\":1204734470,\"e_profile_name\":\"test75\",\"e_profile_id\":30002,\"e_link\":\"/home\"}");
            AppComponents.remoteEventSubscriber.addEvent(obj);
         }
         else if(this._notificationCombo.value == "earnedExperience")
         {
            obj = JSON.deserialize("{\"e_type\":" + EventNotificationType.EARNED_XP + "}");
            AppComponents.remoteEventSubscriber.addEvent(obj);
         }
         else if(this._notificationCombo.value == "banned")
         {
            obj = JSON.deserialize("{\"e_type\":\"" + EventNotificationType.BAN + "\", \"duration\":\"Two hours\", \"until\":\"2008-11-25T23:13:22-05:00\"}");
            AppComponents.remoteEventSubscriber.addEvent(obj);
         }
         else if(this._notificationCombo.value == "reported")
         {
            obj = JSON.deserialize("{\"e_type\":" + EventNotificationType.REPORT + ", \"category\":\"Offensive Behavior\"}");
            AppComponents.remoteEventSubscriber.addEvent(obj);
         }
         else if(this._notificationCombo.value == "dailylogin")
         {
            obj = JSON.deserialize("{\"e_image\":\"http://staticcdn.iminlikewithyou.com/graphics-notifications-alert.png\", \"e_link\":\"#\", \"e_message\":\"YARR! You completed Daily Login - Login tomorrow for even more coins!!\", \"e_type\":\"mission_complete\", \"lookup_id\":\"344712\", \"lookup_type\":\"user\", \"time\":\"2010-03-16T11:10:15-04:00\"}");
            AppComponents.remoteEventSubscriber.addEvent(obj);
         }
      }
      
      protected function arcadePromotionTester() : void
      {
         var list:List = new List(0,0,ListDirection.HORIZONTAL);
         this._arcadePromoCombo = new ComboBox("Promo type",0,0,200,16,"comboBoxSimple");
         this._arcadePromoCombo.setOptions(["finish-match"]);
         list.addContentChild(this._arcadePromoCombo);
         var but:LiteButton = new LiteButton("Send");
         list.addContentChild(but);
         this._mainList.addContentChild(list);
         but.addEventListener(ButtonEvent.CLICK,this.onArcadePromotionTest);
         but = new LiteButton("Change guest name");
         but.addEventListener(ButtonEvent.CLICK,this.onChangeGuestName);
         this._mainList.addContentChild(but);
      }
      
      protected function onChangeGuestName(event:ButtonEvent) : void
      {
         var aevt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.OPEN_POPUP_BY_ID);
         aevt.id = Popups.CHANGE_GUEST_NAME;
         StageReference.stage.dispatchEvent(aevt);
      }
      
      protected function onArcadePromotionTest(event:ButtonEvent) : void
      {
         var obj:* = undefined;
         var chat:ChatData = new ChatData();
         chat.type = ChatData.TYPE_PROMO;
         if(this._arcadePromoCombo.value == "finish-match")
         {
            chat.message = "You just earned a medal! To keep it, " + TextUtil.loginSignupHtmlBlurb();
            AppComponents.gamenetManager.currentMatch.chatMessages.addItem(chat);
         }
         this._logger.log(chat.message);
      }
      
      protected function tickTester() : void
      {
         var but:LiteButton = null;
         but = new LiteButton("Tick test");
         but.addEventListener(ButtonEvent.CLICK,this.onTickTester);
         this._mainList.addContentChild(but);
      }
      
      protected function onTickTester(event:ButtonEvent) : void
      {
         var timer:Timer = new Timer(1000);
         timer.addEventListener(TimerEvent.TIMER,this.onTick);
         timer.start();
         this.tickTimer = timer;
      }
      
      protected function onTick(event:TimerEvent) : void
      {
         trace("-----------------------------");
      }
      
      protected function medalTester() : void
      {
         var but:LiteButton = null;
         but = new LiteButton("Medal test");
         but.addEventListener(ButtonEvent.CLICK,this.onMedalTester);
         this._mainList.addContentChild(but);
      }
      
      protected function onMedalTester(event:ButtonEvent) : void
      {
         var obj:* = undefined;
         obj = JSON.deserialize("{\"e_link\":\"#\",\"time\":\"2009-08-28T13:09:43-04:00\",\"lookup_type\":\"user\",\"e_type\":" + EventNotificationType.GOLD_MEDAL + ",\"e_image\":\"http://staticcdn.iminlikewithyou.com/graphics-notifications-goldmedal.png\",\"lookup_id\":\"120\",\"e_message\":\"OMGz!  You got a gold medal in Dinglepop.\"}");
         AppComponents.remoteEventSubscriber.addEvent(obj);
      }
      
      protected function banTester() : void
      {
         var but:LiteButton = null;
         but = new LiteButton("Simulate Ban");
         but.addEventListener(ButtonEvent.CLICK,this.onBanTester);
         this._mainList.addContentChild(but);
      }
      
      protected function onBanTester(event:ButtonEvent) : void
      {
         var obj:* = undefined;
         var evt:RemoteEvent = new RemoteEvent(RemoteEvent.USER_BANNED);
         var date:Date = new Date();
         date.date = date.date + 2;
         evt.data = {
            "until":DateUtil.toW3CDTF(date,false),
            "duration":10000
         };
         AppComponents.remoteEventSubscriber.dispatchEvent(evt);
      }
      
      protected function embedCodeOutput() : void
      {
         var but:LiteButton = null;
         but = new LiteButton("Embed Code");
         but.addEventListener(ButtonEvent.CLICK,this.onEmbedCodeOutput);
         this._mainList.addContentChild(but);
      }
      
      protected function onEmbedCodeOutput(event:ButtonEvent) : void
      {
         var game:ArcadeGamePackData = null;
         var code:String = null;
         var split:Array = null;
         for each(game in AppComponents.model.arcade.catalog.source)
         {
            code = EmbedUtil.arcadeGameEmbed(game.id);
            split = code.split(".swf?key=");
            split = split[1].split("\"");
            trace(game.id,": ",split[0]);
         }
      }
   }
}
