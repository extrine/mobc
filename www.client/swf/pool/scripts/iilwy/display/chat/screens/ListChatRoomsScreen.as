package iilwy.display.chat.screens
{
   import flash.events.Event;
   import iilwy.application.AppComponents;
   import iilwy.collections.ArrayCollection;
   import iilwy.collections.ICollection;
   import iilwy.display.chat.listitems.ChatRoomListItem;
   import iilwy.events.AsyncEvent;
   import iilwy.events.ChatEvent;
   import iilwy.events.CollectionEvent;
   import iilwy.model.dataobjects.chat.ChatRoom;
   import iilwy.ui.containers.UiContainer;
   import iilwy.ui.events.ContainerEvent;
   import iilwy.ui.partials.scrollgroups.ScrollableListScrollGroup;
   import iilwy.utils.ItemFactory;
   import iilwy.utils.Responder;
   import iilwy.utils.StageReference;
   
   public class ListChatRoomsScreen extends UiContainer
   {
       
      
      protected var roomListGroup:ScrollableListScrollGroup;
      
      protected var indexResponder:Responder;
      
      protected var roomFactory:ItemFactory;
      
      protected var roomListValid:Boolean = true;
      
      protected var showProgress:Boolean;
      
      protected var _dataProvider:ICollection;
      
      protected var _action:String;
      
      public function ListChatRoomsScreen(action:String = "join")
      {
         super();
         width = 100;
         height = 100;
         this.action = action;
         this.roomFactory = new ItemFactory(ChatRoomListItem);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function set action(value:String) : void
      {
         this._action = value;
         this.roomListValid = false;
         invalidateProperties();
      }
      
      public function get dataProvider() : ICollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(value:ICollection) : void
      {
         if(this._dataProvider != null)
         {
            this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChange);
            this._dataProvider = null;
         }
         if(value)
         {
            this._dataProvider = value;
            this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChange,false,0,true);
         }
         this.roomListValid = false;
         invalidateProperties();
      }
      
      public function getIndex() : void
      {
         this.indexResponder = new Responder();
         this.indexResponder.setAsyncListeners(this.onIndexSuccess,this.onIndexFail);
         var indexEvent:ChatEvent = new ChatEvent(ChatEvent.GET_CHAT_ROOM_INDEX,true,true);
         indexEvent.responder = this.indexResponder;
         StageReference.stage.dispatchEvent(indexEvent);
      }
      
      override public function createChildren() : void
      {
         this.roomListGroup = new ScrollableListScrollGroup();
         this.roomListGroup.scrollable.itemPadding = 3;
         addContentChild(this.roomListGroup);
      }
      
      override public function commitProperties() : void
      {
         if(!this.roomListValid)
         {
            this.roomListValid = true;
            this.clearRooms();
            if(this._dataProvider)
            {
               this.buildRooms();
            }
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.roomListGroup.width = unscaledWidth;
         this.roomListGroup.height = unscaledHeight;
      }
      
      protected function getData() : void
      {
      }
      
      protected function buildRooms() : void
      {
         var item:ChatRoomListItem = null;
         var room:ChatRoom = null;
         if(!childrenCreated)
         {
            return;
         }
         for(var i:int = 0; i < this._dataProvider.length; i++)
         {
            room = this._dataProvider.getItemAt(i) as ChatRoom;
            item = this.roomFactory.createItem();
            item.data = room;
            item.useDivider = i != 0;
            item.action = this.action;
            item.addEventListener(ChatEvent.JOIN_CHAT_ROOM,this.onAction);
            item.addEventListener(ChatEvent.LEAVE_CHAT_ROOM,this.onAction);
            this.roomListGroup.scrollable.addContentChild(item);
         }
      }
      
      protected function clearRooms() : void
      {
         var item:ChatRoomListItem = null;
         if(!childrenCreated)
         {
            return;
         }
         var items:Array = this.roomListGroup.scrollable.clearContentChildren(false);
         for each(item in items)
         {
            item.data = null;
            item.removeEventListener(ChatEvent.JOIN_CHAT_ROOM,this.onAction);
            item.removeEventListener(ChatEvent.LEAVE_CHAT_ROOM,this.onAction);
         }
         this.roomFactory.recyleItems(items);
      }
      
      private function shuffleArray(array:Array) : Array
      {
         var item:* = undefined;
         var randomNum:int = 0;
         var shuffled:Array = array.slice();
         var len:Number = array.length;
         for(var i:int = 0; i < len; i++)
         {
            item = shuffled[i];
            randomNum = Math.floor(Math.random() * len);
            shuffled[i] = shuffled[randomNum];
            shuffled[randomNum] = item;
         }
         return shuffled;
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         if(this.showProgress)
         {
            dispatchEvent(new ContainerEvent(ContainerEvent.START_PROCESSING,true));
            this.showProgress = false;
         }
      }
      
      protected function onRemovedFromStage(event:Event) : void
      {
         this.clearRooms();
         this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChange);
      }
      
      protected function onIndexSuccess(event:AsyncEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
         var chatRooms:Array = event.data as Array;
         this.dataProvider = new ArrayCollection(chatRooms);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onIndexFail(event:AsyncEvent) : void
      {
         dispatchEvent(new ContainerEvent(ContainerEvent.STOP_PROCESSING,true));
         AppComponents.alertManager.showError("Error getting list of rooms, please try again.");
         dispatchEvent(new ContainerEvent(ContainerEvent.CLOSE,true));
      }
      
      protected function onCollectionChange(event:CollectionEvent) : void
      {
         this.roomListValid = false;
         invalidateProperties();
      }
      
      protected function onAction(event:ChatEvent) : void
      {
         dispatchEvent(event);
      }
   }
}
