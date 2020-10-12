package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class RosterEvent extends Event
   {
      
      public static const ROSTER_LOADED:String = "rosterLoaded";
      
      public static const SUBSCRIPTION_DENIAL:String = "subscriptionDenial";
      
      public static const SUBSCRIPTION_REQUEST:String = "subscriptionRequest";
      
      public static const SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";
      
      public static const USER_ADDED:String = "userAdded";
      
      public static const USER_AVAILABLE:String = "userAvailable";
      
      public static const USER_PRESENCE_UPDATED:String = "userPresenceUpdated";
      
      public static const USER_REMOVED:String = "userRemoved";
      
      public static const USER_SUBSCRIPTION_UPDATED:String = "userSubscriptionUpdated";
      
      public static const USER_UNAVAILABLE:String = "userUnavailable";
       
      
      private var _data;
      
      private var _jid:UnescapedJID;
      
      public function RosterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var event:RosterEvent = new RosterEvent(type,bubbles,cancelable);
         event.data = this._data;
         event.jid = this._jid;
         return event;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(value:*) : void
      {
         this._data = value;
      }
      
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set jid(value:UnescapedJID) : void
      {
         this._jid = value;
      }
      
      override public function toString() : String
      {
         return "[RosterEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
