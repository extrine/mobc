package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class PropertyChangeEvent extends Event
   {
      
      public static const CHANGE:String = "change";
       
      
      private var _name:String;
      
      private var _oldValue;
      
      private var _newValue;
      
      public function PropertyChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var event:PropertyChangeEvent = new PropertyChangeEvent(type,bubbles,cancelable);
         event.name = this._name;
         event.newValue = this._newValue;
         event.oldValue = this._oldValue;
         return event;
      }
      
      public function get name() : *
      {
         return this._name;
      }
      
      public function set name(value:*) : void
      {
         this._name = value;
      }
      
      public function get newValue() : *
      {
         return this._newValue;
      }
      
      public function set newValue(value:*) : void
      {
         this._newValue = value;
      }
      
      public function get oldValue() : *
      {
         return this._oldValue;
      }
      
      public function set oldValue(value:*) : void
      {
         this._oldValue = value;
      }
      
      override public function toString() : String
      {
         return "[PropertyChangeEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
