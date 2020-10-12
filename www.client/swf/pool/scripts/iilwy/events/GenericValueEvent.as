package iilwy.events
{
   import flash.events.Event;
   import iilwy.utils.Responder;
   
   public class GenericValueEvent extends Event
   {
      
      public static const GET_VALUES:String = "iilwy.events.GenericValueEvent.GET_VALUES";
      
      public static const MODIFY_VALUE:String = "iilwy.events.GenericValueEvent.MODIFY_VALUE";
      
      public static const VALUE_TYPE_STRING:String = "VALUE_TYPE_STRING";
      
      public static const VALUE_TYPE_INT:String = "VALUE_TYPE_INT";
      
      public static const METHOD_SET:String = "METHOD_SET";
      
      public static const METHOD_INCREMENT:String = "METHOD_INCREMENT";
      
      public static const METHOD_DECREMENT:String = "METHOD_DECREMENT";
       
      
      public var valueType:String = "VALUE_TYPE_INT";
      
      public var methodType:String = "METHOD_SET";
      
      public var key:String;
      
      public var keys:Array;
      
      public var stringValue:String;
      
      public var intValue:uint;
      
      public var responder:Responder;
      
      public function GenericValueEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
