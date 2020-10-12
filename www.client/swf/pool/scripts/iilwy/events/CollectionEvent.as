package iilwy.events
{
   import flash.events.Event;
   
   public class CollectionEvent extends Event
   {
      
      public static const COLLECTION_CHANGE:String = "iilwy.events.CollectionEvent.COLLECTION_CHANGE";
      
      public static const KIND_ADD:String = "add";
      
      public static const KIND_RESET:String = "reset";
      
      public static const KIND_REMOVE:String = "remove";
      
      public static const KIND_MODIFY:String = "modify";
      
      public static const KIND_REPLACE:String = "replace";
      
      public static const KIND_SOURCE_SET:String = "sourceSet";
       
      
      public var kind:String;
      
      public var items:Array;
      
      public var location:int;
      
      public var oldLocation:int;
      
      public function CollectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, location:int = -1, oldLocation:int = -1, items:Array = null)
      {
         super(type,bubbles,cancelable);
         this.kind = kind;
         this.location = location;
         this.oldLocation = oldLocation;
         this.items = Boolean(items)?items:[];
      }
      
      override public function clone() : Event
      {
         return new CollectionEvent(type,bubbles,cancelable,this.kind,this.location,this.oldLocation,this.items);
      }
      
      override public function toString() : String
      {
         return formatToString("CollectionEvent","kind","location","oldLocation","type","bubbles","cancelable","eventPhase");
      }
   }
}
