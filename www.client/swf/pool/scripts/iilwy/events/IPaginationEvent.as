package iilwy.events
{
   public interface IPaginationEvent extends IResponderEvent
   {
       
      
      function get direction() : int;
      
      function set direction(value:int) : void;
      
      function get page() : int;
      
      function set page(value:int) : void;
      
      function get offset() : int;
      
      function set offset(value:int) : void;
      
      function get limit() : int;
      
      function set limit(value:int) : void;
      
      function get forceRefresh() : Boolean;
      
      function set forceRefresh(value:Boolean) : void;
   }
}
