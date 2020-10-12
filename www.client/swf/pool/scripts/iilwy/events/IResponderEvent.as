package iilwy.events
{
   import iilwy.utils.Responder;
   
   public interface IResponderEvent
   {
       
      
      function get responder() : Responder;
      
      function set responder(value:Responder) : void;
   }
}
