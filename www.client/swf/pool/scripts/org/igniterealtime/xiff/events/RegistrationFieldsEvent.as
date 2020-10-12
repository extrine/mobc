package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.register.RegisterExtension;
   
   public class RegistrationFieldsEvent extends Event
   {
      
      public static const REG_FIELDS:String = "registrationFields";
       
      
      private var _data:RegisterExtension;
      
      private var _fields:Array;
      
      public function RegistrationFieldsEvent()
      {
         super(RegistrationFieldsEvent.REG_FIELDS,false,false);
      }
      
      override public function clone() : Event
      {
         var event:RegistrationFieldsEvent = new RegistrationFieldsEvent();
         event.data = this._data;
         event.fields = this._fields;
         return event;
      }
      
      public function get data() : RegisterExtension
      {
         return this._data;
      }
      
      public function set data(value:RegisterExtension) : void
      {
         this._data = value;
      }
      
      public function get fields() : Array
      {
         return this._fields;
      }
      
      public function set fields(value:Array) : void
      {
         this._fields = value;
      }
      
      override public function toString() : String
      {
         return "[RegistrationFieldsEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
