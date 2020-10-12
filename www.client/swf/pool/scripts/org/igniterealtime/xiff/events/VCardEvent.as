package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.vcard.VCard;
   
   public class VCardEvent extends Event
   {
      
      public static const LOADED:String = "loaded";
      
      public static const SAVED:String = "saved";
      
      public static const SAVE_ERROR:String = "saveError";
       
      
      private var _vcard:VCard;
      
      public function VCardEvent(type:String, vcard:VCard, bubbles:Boolean, cancelable:Boolean)
      {
         super(type,bubbles,cancelable);
         this._vcard = vcard;
      }
      
      override public function clone() : Event
      {
         return new VCardEvent(type,this._vcard,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return "[VCardEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
      
      public function get vcard() : VCard
      {
         return this._vcard;
      }
   }
}
