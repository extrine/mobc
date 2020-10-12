package iilwy.display.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import iilwy.application.AppComponents;
   import iilwy.display.commentedmedia.BubbleInfoWindow;
   import iilwy.display.context.ChatRoomUserContextMenu;
   import iilwy.display.context.ChatUserContextMenu;
   import iilwy.display.context.MiniProductContextMenu;
   import iilwy.display.context.PlayerContextMenu;
   import iilwy.display.context.ProductContextMenu;
   import iilwy.display.context.ProfileContextMenu;
   import iilwy.display.shop.ProductDetail;
   import iilwy.gamenet.model.PlayerData;
   import iilwy.model.dataobjects.ProfileData;
   import iilwy.model.dataobjects.chat.ChatRoomUser;
   import iilwy.model.dataobjects.chat.ChatUser;
   import iilwy.model.dataobjects.shop.CatalogProductBase;
   import iilwy.model.dataobjects.shop.InventoryProduct;
   import iilwy.ui.containers.IModule;
   import iilwy.ui.containers.UiModule;
   import iilwy.ui.controls.ContextSimpleMenu;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.events.MultiSelectEvent;
   import iilwy.ui.utils.IFocusGroup;
   import iilwy.utils.logging.Logger;
   
   public class ContextMenuManager
   {
       
      
      public var userContextMenuEnabled:Boolean = true;
      
      protected var defaultWindowStyleID:String;
      
      protected var _layer:Sprite;
      
      protected var _window:BubbleInfoWindow;
      
      protected var _contextSimpleMenu:ContextSimpleMenu;
      
      protected var _contextSimpleMenuCallback:Function;
      
      protected var _target:DisplayObject;
      
      protected var _profileContextMenu:ProfileContextMenu;
      
      protected var _playerContextMenu:PlayerContextMenu;
      
      protected var _chatUserContextMenu:ChatUserContextMenu;
      
      protected var _chatRoomUserContextMenu:ChatRoomUserContextMenu;
      
      protected var _productContextMenu:ProductContextMenu;
      
      protected var _miniProductContextMenu:MiniProductContextMenu;
      
      protected var _logger:Logger;
      
      protected var _showTimeStamp:int = -1000;
      
      public function ContextMenuManager(layer:Sprite)
      {
         super();
         this._layer = layer;
         this.defaultWindowStyleID = "bubbleInfoWindowDark";
         this._window = new BubbleInfoWindow();
         this._window.setStyleById(this.defaultWindowStyleID);
         this._logger = Logger.getLogger(this);
      }
      
      public function showOptions(data:Array, callback:Function, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : ContextSimpleMenu
      {
         if(this._contextSimpleMenu == null)
         {
            this._contextSimpleMenu = new ContextSimpleMenu();
         }
         this._contextSimpleMenu.setData(data);
         this.showMenu(this._contextSimpleMenu,target,method,x,y);
         this._contextSimpleMenuCallback = callback;
         return this._contextSimpleMenu;
      }
      
      public function showClickShopContextMenu(catalogProductBase:CatalogProductBase, alternateSelections:Array = null, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(this._productContextMenu == null)
         {
            this._productContextMenu = new ProductContextMenu();
         }
         this._productContextMenu.catalogProductBase = catalogProductBase;
         this._productContextMenu.detailLayout = ProductDetail.LAYOUT_CLICK_SHOP;
         this._productContextMenu.productSelections = alternateSelections;
         try
         {
            AppComponents.analytics.trackAction("context_menu/click_shop/" + catalogProductBase.id);
         }
         catch(e:Error)
         {
         }
         return this.showMenu(this._productContextMenu,target,method,x,y);
      }
      
      public function showCatalogProductContextMenu(catalogProductBase:CatalogProductBase, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(this._productContextMenu == null)
         {
            this._productContextMenu = new ProductContextMenu();
         }
         this._productContextMenu.catalogProductBase = catalogProductBase;
         this._productContextMenu.productSelections = null;
         try
         {
            AppComponents.analytics.trackAction("context_menu/catalog_product/" + catalogProductBase.id);
         }
         catch(e:Error)
         {
         }
         return this.showMenu(this._productContextMenu,target,method,x,y);
      }
      
      public function showMiniCatalogProductContextMenu(catalogProductBase:CatalogProductBase, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(this._miniProductContextMenu == null)
         {
            this._miniProductContextMenu = new MiniProductContextMenu();
         }
         this._miniProductContextMenu.catalogProductBase = catalogProductBase;
         try
         {
            AppComponents.analytics.trackAction("context_menu/catalog_product/" + catalogProductBase.id);
         }
         catch(e:Error)
         {
         }
         return this.showMenu(this._miniProductContextMenu,target,method,x,y);
      }
      
      public function showInventoryProductContextMenu(inventoryProduct:InventoryProduct, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(this._productContextMenu == null)
         {
            this._productContextMenu = new ProductContextMenu();
         }
         this._productContextMenu.inventoryProduct = inventoryProduct;
         this._productContextMenu.productSelections = null;
         try
         {
            AppComponents.analytics.trackAction("context_menu/inventory_product/" + inventoryProduct.catalogProductBase.id);
         }
         catch(e:Error)
         {
         }
         return this.showMenu(this._productContextMenu,target,method,x,y);
      }
      
      public function showProfileContextMenu(profile:ProfileData, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(!this.userContextMenuEnabled)
         {
            return null;
         }
         if(this._profileContextMenu == null)
         {
            this._profileContextMenu = new ProfileContextMenu();
         }
         this._profileContextMenu.profileData = profile;
         return this.showMenu(this._profileContextMenu,target,method,x,y);
      }
      
      public function showPlayerContextMenu(player:PlayerData, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(!this.userContextMenuEnabled)
         {
            return null;
         }
         if(this._playerContextMenu == null)
         {
            this._playerContextMenu = new PlayerContextMenu();
         }
         this._playerContextMenu.playerData = player;
         return this.showMenu(this._playerContextMenu,target,method,x,y);
      }
      
      public function showChatUserContextMenu(chatUser:ChatUser, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(!this.userContextMenuEnabled)
         {
            return null;
         }
         if(this._chatUserContextMenu == null)
         {
            this._chatUserContextMenu = new ChatUserContextMenu();
         }
         this._chatUserContextMenu.chatUser = chatUser;
         return this.showMenu(this._chatUserContextMenu,target,method,x,y);
      }
      
      public function showChatRoomUserContextMenu(chatRoomUser:ChatRoomUser, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined) : UiModule
      {
         if(!this.userContextMenuEnabled)
         {
            return null;
         }
         if(this._chatRoomUserContextMenu == null)
         {
            this._chatRoomUserContextMenu = new ChatRoomUserContextMenu();
         }
         this._chatRoomUserContextMenu.chatRoomUser = chatRoomUser;
         return this.showMenu(this._chatRoomUserContextMenu,target,method,x,y);
      }
      
      public function showMenu(menu:UiModule, target:DisplayObject = null, method:String = null, x:Number = undefined, y:Number = undefined, windowStyleID:String = null) : UiModule
      {
         this._logger.log("show");
         this.hide();
         windowStyleID = Boolean(windowStyleID)?windowStyleID:this.defaultWindowStyleID;
         if(this._window.getStyleId() != windowStyleID)
         {
            this._window.setStyleById(windowStyleID);
         }
         this._showTimeStamp = getTimer();
         if(menu != this._window.module)
         {
            this._window.setModule(menu);
         }
         menu.visible = true;
         if(menu.wantsFocus)
         {
            FocusManager.getInstance().addFocusGroup(menu);
         }
         if(!this._layer.contains(this._window))
         {
            this._layer.addChild(this._window);
         }
         this._window.visible = true;
         this._window.setPosition(target,method,x,y);
         this._target = target;
         target.addEventListener(MouseEvent.MOUSE_DOWN,this.onTargetClick,false,3,false);
         this._window.addEventListener(ContainerEvent.MOUSE_UP_OUT,this.onWindowClickOut);
         this._window.addEventListener(ContainerEvent.CLICK_OUT,this.onWindowClickOut);
         menu.addEventListener(MultiSelectEvent.SELECT,this.onSimpleMenuSelect,false,0,true);
         return menu;
      }
      
      protected function onTargetClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         this.hide();
      }
      
      public function hide() : void
      {
         this._logger.log("hide");
         this._contextSimpleMenuCallback = null;
         var module:IModule = this._window.module;
         if(this._miniProductContextMenu)
         {
            this._miniProductContextMenu.visible = false;
         }
         if(this._productContextMenu)
         {
            this._productContextMenu.visible = false;
         }
         if(this._profileContextMenu)
         {
            this._profileContextMenu.visible = false;
         }
         FocusManager.getInstance().removeFocusGroup(module as IFocusGroup);
         if(this._contextSimpleMenu != null)
         {
            this._contextSimpleMenu.removeEventListener(MultiSelectEvent.SELECT,this.onSimpleMenuSelect);
            this._contextSimpleMenu.visible = false;
         }
         this._window.visible = false;
         this._window.x = -1000;
         this._window.removeEventListener(ContainerEvent.CLICK_OUT,this.onWindowClickOut);
         this._window.removeEventListener(ContainerEvent.MOUSE_UP_OUT,this.onWindowClickOut);
         if(this._target != null)
         {
            this._target.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTargetClick);
            this._target = null;
         }
      }
      
      protected function onWindowClickOut(event:ContainerEvent) : void
      {
         if(getTimer() - this._showTimeStamp > 600)
         {
            this.hide();
         }
      }
      
      protected function onSimpleMenuSelect(event:MultiSelectEvent) : void
      {
         if(this._contextSimpleMenuCallback != null)
         {
            this._contextSimpleMenuCallback(event);
         }
         this.hide();
      }
   }
}
