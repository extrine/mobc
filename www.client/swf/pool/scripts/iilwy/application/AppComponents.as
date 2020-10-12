package iilwy.application
{
   import iilwy.abtest.ABTestManager;
   import iilwy.application.analytics.AnalyticsManager;
   import iilwy.chat.ChatManager;
   import iilwy.chat.ChatRoomManager;
   import iilwy.chat.FBChatManager;
   import iilwy.chat.VoiceChatManager;
   import iilwy.display.core.AbstractDisplay;
   import iilwy.display.core.AlertManager;
   import iilwy.display.core.ContextMenuManager;
   import iilwy.display.core.GlobalKeyListener;
   import iilwy.display.core.IdleManager;
   import iilwy.display.core.NotificationManager;
   import iilwy.display.core.PageViewManager;
   import iilwy.display.core.PopupManager;
   import iilwy.display.core.ThemeManager;
   import iilwy.display.core.TooltipManager;
   import iilwy.display.core.UIFactory;
   import iilwy.gamenet.GamenetManager;
   import iilwy.managers.SoundManager;
   import iilwy.managers.StringManager;
   import iilwy.model.LocalStore;
   import iilwy.model.Model;
   import iilwy.net.EventManager;
   import iilwy.net.MerbProxy;
   import iilwy.utils.TextOffendCheck;
   import iilwy.utils.dragdrop.DragDropManager;
   
   public class AppComponents
   {
      
      protected static var _model:Model;
      
      protected static var _display:AbstractDisplay;
      
      public static var remoteEventSubscriber:EventManager;
      
      public static var stringManager:StringManager;
      
      public static var themeManager:ThemeManager;
      
      public static var pageViewManager:PageViewManager;
      
      public static var stateManager:StateManager;
      
      public static var gamenetManager:GamenetManager;
      
      public static var chatManager:ChatManager;
      
      public static var fbChatManager:FBChatManager;
      
      public static var chatRoomManager:ChatRoomManager;
      
      public static var voiceChatManager:VoiceChatManager;
      
      public static var popupManager:PopupManager;
      
      public static var contextMenuManager:ContextMenuManager;
      
      public static var notificationManager:NotificationManager;
      
      public static var alertManager:AlertManager;
      
      public static var tooltipManager:TooltipManager;
      
      public static var soundManager:SoundManager;
      
      public static var globalKeyListener:GlobalKeyListener;
      
      public static var idleManager:IdleManager;
      
      public static var localStore:LocalStore;
      
      public static var merbProxy:MerbProxy;
      
      public static var analytics:AnalyticsManager;
      
      public static var uiFactory:UIFactory;
      
      public static var dragdropManager:DragDropManager;
      
      public static var textOffendCheck:TextOffendCheck = new TextOffendCheck();
      
      public static var abTestManager:ABTestManager;
      
      public static var performanceManager:PerformanceManager = new PerformanceManager();
       
      
      public function AppComponents()
      {
         super();
      }
      
      public static function set model(m:Model) : void
      {
         if(!_model)
         {
            _model = m;
         }
      }
      
      public static function get model() : Model
      {
         return _model;
      }
      
      public static function set display(d:AbstractDisplay) : void
      {
         if(!_display)
         {
            _display = d;
         }
      }
      
      public static function get display() : AbstractDisplay
      {
         return _display;
      }
   }
}
