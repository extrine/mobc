package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import iilwy.data.PageCommand;
   import iilwy.display.layout.IPageView;
   import iilwy.events.ApplicationEvent;
   import iilwy.events.ArcadeEvent;
   import iilwy.gamenet.model.PlayerStatus;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.utils.IFocusGroup;
   
   public class PageView extends UiContainer implements IPageView, IFocusGroup
   {
       
      
      protected var _defaultFocus:InteractiveObject;
      
      protected var _savedFocus:InteractiveObject;
      
      private var _pageTitle:String = "";
      
      private var _pageSubtitle:String = "";
      
      protected var panePadding:Number = 10;
      
      private var _defaultPlayerStatus:PlayerStatus;
      
      public function PageView()
      {
         super();
         maxHeight = 1500;
         maxWidth = 1650;
         minHeight = 300;
         minWidth = 400;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._hide();
      }
      
      public function init() : void
      {
      }
      
      public final function _init() : void
      {
         this.init();
      }
      
      public function processPageCommand(pageCommand:PageCommand) : void
      {
      }
      
      public final function _processPageCommand(pageCommand:PageCommand) : void
      {
         this.processPageCommand(pageCommand);
         this.sendDefaultPlayerStatus();
         this.commitPageTitles();
      }
      
      private function sendDefaultPlayerStatus() : void
      {
         var evt:ArcadeEvent = null;
         var status:PlayerStatus = this.defaultPlayerStatus;
         if(status)
         {
            evt = new ArcadeEvent(ArcadeEvent.SET_PLAYER_STATUS,true);
            evt.playerStatus = status;
            dispatchEvent(evt);
         }
      }
      
      public function show() : void
      {
      }
      
      public final function _show() : void
      {
         this.show();
         FocusManager.getInstance().addFocusGroup(this);
         this.sendDefaultPlayerStatus();
         this.commitPageTitles();
      }
      
      public function hide() : void
      {
      }
      
      public function _hide() : void
      {
         this.hide();
         this._pageTitle = "";
         this._pageSubtitle = "";
      }
      
      protected function get defaultPlayerStatus() : PlayerStatus
      {
         var s:PlayerStatus = new PlayerStatus();
         s.online();
         return s;
      }
      
      protected function set pageTitle(title:String) : void
      {
         this._pageTitle = title;
      }
      
      protected function set pageSubtitle(title:String) : void
      {
         this._pageSubtitle = title;
      }
      
      protected function commitPageTitles() : void
      {
         var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SET_PAGE_TITLE);
         evt.data = this._pageTitle;
         dispatchEvent(evt);
         evt = new ApplicationEvent(ApplicationEvent.SET_PAGE_SUBTITLE);
         evt.data = this._pageSubtitle;
         dispatchEvent(evt);
      }
      
      public function onBeforeUnload() : String
      {
         return "";
      }
      
      public function asUiContainer() : UiContainer
      {
         return this as UiContainer;
      }
      
      public function focusIn() : void
      {
         tabChildren = true;
      }
      
      public function focusOut() : void
      {
         tabChildren = false;
      }
      
      public function get defaultFocus() : InteractiveObject
      {
         return this._defaultFocus;
      }
      
      public function set defaultFocus(i:InteractiveObject) : void
      {
         this._defaultFocus = i;
      }
      
      public function get savedFocus() : InteractiveObject
      {
         return this._savedFocus;
      }
      
      public function set savedFocus(i:InteractiveObject) : void
      {
         this._savedFocus = i;
      }
      
      public function get wantsFocus() : Boolean
      {
         return true;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
   }
}
