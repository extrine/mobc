package iilwy.events
{
   import flash.events.Event;
   
   public class PaginationDataResponderEvent extends DataResponderEvent implements IPaginationEvent
   {
       
      
      private var _direction:int;
      
      private var _page:int;
      
      private var _offset:int = -1;
      
      private var _limit:int = -1;
      
      private var _forceRefresh:Boolean;
      
      public function PaginationDataResponderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
      {
         super(type,bubbles,cancelable,data);
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(value:int) : void
      {
         this._direction = value;
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function set page(value:int) : void
      {
         this._page = value;
      }
      
      public function get offset() : int
      {
         return this._offset;
      }
      
      public function set offset(value:int) : void
      {
         this._offset = value;
      }
      
      public function get limit() : int
      {
         return this._limit;
      }
      
      public function set limit(value:int) : void
      {
         this._limit = value;
      }
      
      public function get forceRefresh() : Boolean
      {
         return this._forceRefresh;
      }
      
      public function set forceRefresh(value:Boolean) : void
      {
         this._forceRefresh = value;
      }
      
      override public function clone() : Event
      {
         var paginationDataResponderEvent:PaginationDataResponderEvent = new PaginationDataResponderEvent(type,bubbles,cancelable,data);
         paginationDataResponderEvent.responder = responder;
         paginationDataResponderEvent.direction = this.direction;
         paginationDataResponderEvent.page = this.page;
         paginationDataResponderEvent.offset = this.offset;
         paginationDataResponderEvent.limit = this.limit;
         paginationDataResponderEvent.forceRefresh = this.forceRefresh;
         return paginationDataResponderEvent;
      }
      
      override public function toString() : String
      {
         return formatToString("PaginationDataResponderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
